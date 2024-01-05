import 'package:ribs_core/ribs_core.dart';

extension IteratorOps<A> on Iterator<A> {
  /// Converts this [Iterator] to an [IList].
  IList<A> toIList() => IList.from(RibsIterator.fromDart(this));
}
