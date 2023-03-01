import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/src/fold.dart';

class Getter<S, A> extends Fold<S, A> {
  final Function1<S, A> get;

  Getter(this.get);

  @override
  Function1<S, Option<A>> find(Function1<A, bool> p) =>
      (s) => get(s).some.filter(p);

  Getter<S, B> andThenG<B>(Getter<A, B> other) =>
      Getter((S s) => other.get(get(s)));
}
