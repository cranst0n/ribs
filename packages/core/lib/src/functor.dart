import 'package:ribs_core/ribs_core.dart';

abstract class Functor<A> {
  Functor<B> map<B>(covariant Function1<A, B> f);
}
