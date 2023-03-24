import 'package:ribs_core/ribs_core.dart';

abstract class Foldable<A> {
  B foldLeft<B>(B init, Function2<B, A, B> op);

  B foldRight<B>(B init, Function2<A, B, B> op);
}

extension FoldableOps<A> on Foldable<A> {
  int count(Function1<A, bool> p) =>
      foldLeft(0, (count, elem) => count + (p(elem) ? 1 : 0));

  bool forall(Function1<A, bool> p) =>
      foldLeft(true, (acc, elem) => acc && p(elem));

  bool exists(Function1<A, bool> p) =>
      foldLeft(false, (acc, elem) => acc || p(elem));

  bool get isEmpty => size == 0;

  bool get nonEmpty => size > 0;

  int get size => foldLeft(0, (acc, _) => acc + 1);
}
