import 'package:ribs_core/src/either.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/syntax/tuple.dart';

part 'generated/either_tuple.dart';
part 'generated/tuple_either.dart';

/// Operations for any value to lift it into an [Either].
extension EitherSyntaxOps<A> on A {
  /// Creates a [Left] instance with this value.
  Either<A, B> asLeft<B>() => Either.left(this);

  /// Creates a [Right] instance with this value.
  Either<B, A> asRight<B>() => Either.right(this);
}
