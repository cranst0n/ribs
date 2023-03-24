import 'package:ribs_core/ribs_core.dart';

abstract class Functor<A> {
  Functor<B> map<B>(covariant Function1<A, B> f);
}

extension FunctorOps<A> on Functor<A> {
  Functor<B> as<B>(B b) => map((_) => b);

  Functor<Unit> voided() => as(Unit());

  Functor<Tuple2<A, B>> fproduct<B>(Function1<A, B> f) =>
      map((a) => Tuple2(a, f(a)));

  Functor<Tuple2<B, A>> fproductL<B>(Function1<A, B> f) =>
      map((a) => Tuple2(f(a), a));
}
