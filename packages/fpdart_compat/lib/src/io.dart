import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension FpdartTaskOps<A> on fpdart.Task<A> {
  ribs.IO<A> toRibs() => ribs.IO.fromFuture(ribs.IO.delay(() => run()));
}

extension RibsIOOps<A> on ribs.IO<A> {
  fpdart.Task<A> toFpdart() => fpdart.Task(() => unsafeRunToFuture());
}
