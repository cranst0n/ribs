import 'package:ribs_core/ribs_core.dart';

abstract mixin class Fold<S, A> {
  Function1<S, bool> exists(Function1<A, bool> p) =>
      (s) => find(p)(s).isDefined;

  Function1<S, Option<A>> find(Function1<A, bool> p);
}
