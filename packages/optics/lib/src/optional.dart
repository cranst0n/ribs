import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

typedef Optional<S, A> = POptional<S, S, A, A>;

class POptional<S, T, A, B> extends PSetter<S, T, A, B> with Fold<S, A> {
  final Function1<S, Either<T, A>> getOrModify;

  POptional(this.getOrModify, Function2C<B, S, T> set)
      : super((f) => (s) => getOrModify(s).fold(identity, (a) => set(f(a))(s)));

  Option<A> getOption(S s) => getOrModify(s).toOption();

  Function1<S, Option<T>> modifyOption(Function1<A, B> f) =>
      (s) => getOption(s).map((a) => replace(f(a))(s));

  Function1<S, Option<T>> replaceOption(B b) => modifyOption((_) => b);

  @override
  Function1<S, Option<A>> find(Function1<A, bool> p) => (s) => getOption(s).filter(p);

  POptional<S, T, C, D> andThenO<C, D>(POptional<A, B, C, D> other) => POptional<S, T, C, D>(
        (s) => getOrModify(s)
            .flatMap((a) => other.getOrModify(a).bimap((b) => replace(b)(s), (c) => c)),
        (d) => modify(other.replace(d)),
      );
}
