import 'package:dartz/dartz.dart' as dartz;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension DartzTaskOps<A> on dartz.Task<A> {
  ribs.IO<A> toRibs() => ribs.IO.fromFuture(ribs.IO.delay(() => run()));
}

extension RibsIOOps<A> on ribs.IO<A> {
  dartz.Task<A> toDartz() => dartz.Task(() => unsafeRunFuture());
}
