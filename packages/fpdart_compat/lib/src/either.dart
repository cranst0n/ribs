import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension FpdartEitherOps<A, B> on fpdart.Either<A, B> {
  ribs.Either<A, B> toRibs() =>
      fold((l) => ribs.Left<A, B>(l), (r) => ribs.Right(r));
}

extension RibsEitherOps<A, B> on ribs.Either<A, B> {
  fpdart.Either<A, B> toFpdart() =>
      fold((l) => fpdart.Left<A, B>(l), (r) => fpdart.Right(r));
}
