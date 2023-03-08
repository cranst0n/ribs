import 'package:ribs_core/ribs_core.dart';

// TODO: Is this safe or even necessary?
// I'm trying to stay as close as possible to the Red Book implementation
// but Dart is single threaded
// I know enough to know I don't know
class Ref<A> {
  A _underlying;

  Ref._(this._underlying);

  static Ref<A> of<A>(A initial) => Ref._(initial);

  IO<A> get value => IO.async(() => _underlying);

  IO<Unit> setValue(A a) => IO.async(() => _underlying = a).voided;

  IO<B> modify<B>(Function1<A, Tuple2<A, B>> f) =>
      IO.async(() => f(_underlying)((newA, result) {
            _underlying = newA;
            return result;
          }));
}
