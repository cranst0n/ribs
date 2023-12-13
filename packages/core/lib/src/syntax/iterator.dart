import 'package:ribs_core/src/ilist.dart';

extension IteratorOps<A> on Iterator<A> {
  /// Converts this [Iterator] to an [IList].
  IList<A> toIList() => IList.fromIterator(this);
}
