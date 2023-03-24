import 'package:ribs_core/ribs_core.dart';

class Ref<A> {
  A _underlying;

  Ref._(this._underlying);

  static Ref<A> of<A>(A initial) => Ref._(initial);

  IO<A> get value => IO.pure(_underlying);

  IO<Unit> setValue(A a) => IO.exec(() => _underlying = a);

  IO<B> modify<B>(Function1<A, Tuple2<A, B>> f) =>
      IO.delay(() => f(_underlying)((newA, result) {
            _underlying = newA;
            return result;
          }));

  IO<Unit> update(Function1<A, A> f) =>
      IO.exec(() => _underlying = f(_underlying));
}
