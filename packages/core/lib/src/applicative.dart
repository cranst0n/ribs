import 'package:ribs_core/ribs_core.dart';

/// Provides the application of a function in an Applicative context to a value
/// in an Applicative context.
mixin Applicative<A> on Functor<A> {
  /// Apply [f] to the value of this [Applicative].
  Applicative<B> ap<B>(covariant Applicative<Function1<A, B>> f);
}
