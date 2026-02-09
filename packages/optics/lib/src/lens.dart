import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

typedef Lens<S, A> = PLens<S, S, A, A>;

class PLens<S, T, A, B> extends POptional<S, T, A, B> with Fold<S, A> {
  final Function1<S, A> get;

  PLens(this.get, Function2C<B, S, T> set) : super((s) => get(s).asRight(), set);

  Getter<S, C> andThenG<C>(Getter<A, C> other) => Getter((S s) => other.get(get(s)));

  PLens<S, T, C, D> andThenL<C, D>(PLens<A, B, C, D> other) => PLens<S, T, C, D>(
    (s) => other.get(get(s)),
    (d) => modify(other.replace(d)),
  );
}
