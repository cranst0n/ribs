import 'package:ribs_core/ribs_core.dart';

/// Provides the application of a function to a value in a Functor context.
abstract class Functor<A> {
  /// Applies [f] to the value of this [Functor].
  Functor<B> map<B>(covariant Function1<A, B> f);
}
