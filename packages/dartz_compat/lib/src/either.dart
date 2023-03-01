import 'package:dartz/dartz.dart' as dartz;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension DartzEitherOps<A, B> on dartz.Either<A, B> {
  ribs.Either<A, B> get toRibs =>
      fold((l) => ribs.Left<A, B>(l), (r) => ribs.Right(r));
}

extension RibsEitherOps<A, B> on ribs.Either<A, B> {
  dartz.Either<A, B> get toDartz =>
      fold((l) => dartz.Left<A, B>(l), (r) => dartz.Right(r));
}
