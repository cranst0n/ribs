import 'package:ribs_core/ribs_core.dart';

extension IterableOps<A> on Iterable<A> {
  /// Converts this [Iterable] to an [IList].
  IList<A> toIList() => ilist(toList());
}
