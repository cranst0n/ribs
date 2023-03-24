import 'package:ribs_core/ribs_core.dart';

typedef Setter<S, A> = PSetter<S, S, A, A>;

class PSetter<S, T, A, B> {
  final Function2C<Function1<A, B>, S, T> modify;

  PSetter(this.modify);

  Function1<S, T> replace(B b) => modify((_) => b);

  PSetter<S, T, C, D> andThenS<C, D>(PSetter<A, B, C, D> other) {
    return PSetter<S, T, C, D>((f) => modify(other.modify(f)));
  }
}
