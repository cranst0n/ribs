import 'package:ribs_core/ribs_core.dart';

abstract class Functor<A> {
  Functor<B> map<B>(covariant Function1<A, B> f);
}

extension FunctorOps<A> on Functor<A> {
  Functor<B> as<B>(B b) => map((_) => b);

  Functor<Unit> voided() => as(Unit());

  Functor<(A, B)> fproduct<B>(Function1<A, B> f) => map((a) => (a, f(a)));

  Functor<(B, A)> fproductL<B>(Function1<A, B> f) => map((a) => (f(a), a));
}
