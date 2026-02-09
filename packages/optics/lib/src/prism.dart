import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

typedef Prism<S, A> = PPrism<S, S, A, A>;

class PPrism<S, T, A, B> extends POptional<S, T, A, B> {
  final Function1<B, T> reverseGet;

  PPrism(Function1<S, Either<T, A>> getOrModify, this.reverseGet)
    : super(getOrModify, (b) => (_) => reverseGet(b));

  Getter<B, T> get re => Getter(reverseGet);

  PPrism<S, T, C, D> andThenP<C, D>(PPrism<A, B, C, D> other) => PPrism<S, T, C, D>(
    (s) =>
        getOrModify(s).flatMap((a) => other.getOrModify(a).bimap((b) => replace(b)(s), identity)),
    (d) => reverseGet(other.reverseGet(d)),
  );
}
