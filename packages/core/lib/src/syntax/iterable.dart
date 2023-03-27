import 'package:ribs_core/src/ilist.dart';

extension IterableOps<A> on Iterable<A> {
  IList<A> toIList() => ilist(toList());
}
