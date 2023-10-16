import 'package:ribs_core/src/ilist.dart';

extension IterableOps<A> on Iterable<A> {
  /// Converts this [Iterable] to an [IList].
  IList<A> toIList() => ilist(toList());
}
