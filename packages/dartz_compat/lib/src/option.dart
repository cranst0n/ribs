import 'package:dartz/dartz.dart' as dartz;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension DartzOptionOps<A> on dartz.Option<A> {
  ribs.Option<A> get toRibs => fold(() => ribs.None<A>(), (a) => ribs.Some(a));
}

extension RibsOptionOps<A> on ribs.Option<A> {
  dartz.Option<A> get toDartz =>
      fold(() => dartz.None<A>(), (a) => dartz.Some(a));
}
