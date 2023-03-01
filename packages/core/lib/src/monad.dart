import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/applicative.dart';

abstract class Monad<A> extends Applicative<A> {
  Monad<B> flatMap<B>(covariant Function1<A, Monad<B>> f);

  @override
  Monad<B> map<B>(Function1<A, B> f);

  @override
  Monad<B> ap<B>(covariant Monad<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));
}

extension MonadOps<A> on Monad<A> {}
