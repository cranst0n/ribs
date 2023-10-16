import 'package:ribs_core/ribs_core.dart';

/// A purely functional synchronization primitive.
///
/// In the same way [Completer] provides synchronization for [Future],
/// [Deferred] provides synchronization for [IO].
///
/// A [Deferred] when created, will be unset, i.e. it will not have a value.
/// It can then be completed exactly once, at which point any computations that
/// are waiting on the value, will be notified of it's existence.
final class Deferred<A> {
  /// The underlying state/value.
  _DeferredState<A> _state = _DeferredStateUnset<A>();

  Deferred._();

  /// Creates a new deferred, wrapping the instance in [IO] to preserve
  /// referential transparency.
  static IO<Deferred<A>> of<A>() => IO.delay(() => Deferred._());

  /// Creates a new Deferred..
  ///
  /// This is marked as 'unsafe' since it allocates mutable state and thus
  /// isn't referentially transparent.
  static Deferred<A> unsafe<A>() => Deferred._();

  /// Attempts to set the value of this instance to [a].
  ///
  /// If this instance has not yet been completed, the value will be set,
  /// readers will be notified and `true` will be returned.
  ///
  /// If this instance has already been completed, `false` is returned.
  IO<bool> complete(A a) => IO.uncancelable((_) => _state.fold(
        (a) => IO.pure(false),
        (unset) {
          _state = _DeferredStateSet(a);

          unset.readers.values.forEach((reader) => reader(a));

          return IO.pure(true);
        },
      ));

  /// Returns the completed value of this instance, if any as an [Option].
  IO<Option<A>> tryValue() => IO.delay(() => _state.fold(
        (a) => Some(a),
        (_) => none(),
      ));

  /// Returns the value of this instance, returning immediately if already
  /// completed, or returning an [IO] that will continue evaluation once this
  /// [Deferred] is completed.
  IO<A> value() => IO.defer(
        () => _state.fold(
          (a) => IO.pure(a),
          (unset) => IO.async((cb) => IO
              .delay(() => unset.addReader((a) => cb(Right(a))))
              .map((id) => Some(IO.exec(() => unset.deleteReader(id))))),
        ),
      );
}

sealed class _DeferredState<A> {
  B fold<B>(
    Function1<A, B> ifSet,
    Function1<_DeferredStateUnset<A>, B> ifUnset,
  );
}

class _DeferredStateSet<A> extends _DeferredState<A> {
  final A value;

  _DeferredStateSet(this.value);

  @override
  B fold<B>(
    Function1<A, B> ifSet,
    Function1<_DeferredStateUnset<A>, B> ifUnset,
  ) =>
      ifSet(value);
}

class _DeferredStateUnset<A> extends _DeferredState<A> {
  final Map<int, Function1<A, void>> readers = {};
  int nextId = 0;

  _DeferredStateUnset();

  @override
  B fold<B>(
    Function1<A, B> ifSet,
    Function1<_DeferredStateUnset<A>, B> ifUnset,
  ) =>
      ifUnset(this);

  int addReader(Function1<A, void> reader) {
    final id = nextId;
    readers[id] = reader;
    return nextId++;
  }

  void deleteReader(int id) {
    readers.remove(id);
  }
}
