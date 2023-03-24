import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/src/lens.dart';
import 'package:ribs_optics/src/setter.dart';

typedef Iso<S, A> = PIso<S, S, A, A>;

class PIso<S, T, A, B> extends PLens<S, T, A, B> {
  final Function1<B, T> reverseGet;

  PIso(Function1<S, A> get, this.reverseGet)
      : super(get, (b) => (_) => reverseGet(b));

  // @override
  // A get(S s) => _get(s);

  // @override
  // Function1<S, T> modify(Function1<A, B> f) => (s) => reverseGet(f(get(s)));

  PIso<B, A, T, S> reverse() => PIso<B, A, T, S>(reverseGet, get);

  PIso<S, T, C, D> andThen<C, D>(PIso<A, B, C, D> other) => PIso<S, T, C, D>(
        (s) => other.get(get(s)),
        (d) => reverseGet(other.reverseGet(d)),
      );

  PSetter<S, T, A, B> asSetter() => this;
}
