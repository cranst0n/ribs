import 'package:dartz/dartz.dart' as dartz;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension DartzIListOps<A> on dartz.IList<A> {
  ribs.IList<A> get toRibs => ribs.IList.of(toList());
}

extension RibsIListOps<A> on ribs.IList<A> {
  dartz.IList<A> get toDartz => dartz.IList.from(toList);
}
