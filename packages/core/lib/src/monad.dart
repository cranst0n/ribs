import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/applicative.dart';

/// Provides the ability to compose dependent effectful functions.
abstract class Monad<A> extends Applicative<A> {
  /// Apply[f] to the value in this monadic context, returning the result in
  /// the same context.
  Monad<B> flatMap<B>(covariant Function1<A, Monad<B>> f);

  @override
  Monad<B> map<B>(Function1<A, B> f);

  @override
  Monad<B> ap<B>(covariant Monad<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));
}
