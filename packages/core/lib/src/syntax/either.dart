import 'package:ribs_core/src/either.dart';

extension EitherSyntaxOps<A> on A {
  Either<A, B> asLeft<B>() => Either.left(this);
  Either<B, A> asRight<B>() => Either.right(this);
}
