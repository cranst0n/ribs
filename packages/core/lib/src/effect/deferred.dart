import 'package:ribs_core/ribs_core.dart';

class Deferred<A> {
  _DeferredState<A> _ref = _DeferredStateUnset<A>();

  IO<bool> complete(A a) => IO.uncancelable((_) => _ref.fold(
        (a) => IO.pure(false),
        (unset) {
          _ref = _DeferredStateSet(a);

          unset.readers.values.forEach((reader) => reader(a));

          return IO.pure(true);
        },
      ));

  IO<Option<A>> tryValue() => IO.delay(() => _ref.fold(
        (a) => a.some,
        (_) => none(),
      ));

  IO<A> value() => IO.defer(
        () => _ref.fold(
          (a) => IO.pure(a),
          (unset) => IO.async((cb) => IO
              .delay(() => unset.addReader((a) => cb(Right(a))))
              .map((id) => IO.exec(() => unset.deleteReader(id)).some)),
        ),
      );
}

abstract class _DeferredState<A> {
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
