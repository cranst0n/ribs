import 'package:ribs_core/ribs_core.dart';

abstract class Applicative<A> extends Functor<A> {
  Applicative<B> ap<B>(covariant Applicative<Function1<A, B>> f);

  @override
  Applicative<B> map<B>(Function1<A, B> f);
}
