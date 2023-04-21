import 'package:ribs_core/ribs_core.dart';

final class Deferred<A> {
  _DeferredState<A> _state = _DeferredStateUnset<A>();

  Deferred._();

  static IO<Deferred<A>> of<A>() => IO.delay(() => Deferred._());

  static Deferred<A> unsafe<A>() => Deferred._();

  IO<bool> complete(A a) => IO.uncancelable((_) => _state.fold(
        (a) => IO.pure(false),
        (unset) {
          _state = _DeferredStateSet(a);

          unset.readers.values.forEach((reader) => reader(a));

          return IO.pure(true);
        },
      ));

  IO<Option<A>> tryValue() => IO.delay(() => _state.fold(
        (a) => Some(a),
        (_) => none(),
      ));

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
