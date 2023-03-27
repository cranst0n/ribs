import 'package:ribs_core/ribs_core.dart';

class Ref<A> {
  A _underlying;

  Ref(this._underlying);

  IO<Tuple2<A, Function1<A, IO<bool>>>> access() => IO.delay(() {
        final snapshot = _underlying;

        IO<bool> setter(A a) => IO.delay(() {
              if (_underlying == snapshot) {
                _underlying = a;
                return true;
              } else {
                return false;
              }
            });

        return Tuple2(snapshot, setter);
      });

  IO<A> getAndUpdate(Function1<A, A> f) => modify((a) => Tuple2(f(a), a));

  IO<A> getAndSet(A a) => getAndUpdate((_) => a);

  IO<B> modify<B>(Function1<A, Tuple2<A, B>> f) =>
      IO.delay(() => f(_underlying)((newA, result) {
            _underlying = newA;
            return result;
          }));

  IO<Unit> setValue(A a) => IO.exec(() => _underlying = a);

  IO<bool> tryUpdate(Function1<A, A> f) =>
      tryModify((a) => Tuple2(f(a), Unit())).map((a) => a.isDefined);

  IO<Option<B>> tryModify<B>(Function1<A, Tuple2<A, B>> f) => IO.delay(() {
        final c = _underlying;

        return f(c)(
          (u, b) {
            if (c == _underlying) {
              _underlying = u;
              return b.some;
            } else {
              return none();
            }
          },
        );
      });

  IO<Unit> update(Function1<A, A> f) =>
      IO.exec(() => _underlying = f(_underlying));

  IO<A> updateAndGet(Function1<A, A> f) => modify((a) {
        final newA = f(a);
        return Tuple2(newA, newA);
      });

  IO<A> value() => IO.delay(() => _underlying);
}
