import 'package:ribs_core/ribs_core.dart';

extension IterableOps<A> on Iterable<A> {
  /// Converts this [Iterable] to an [IList].
  IList<A> toIList() => IList.fromDart(this);

  /// Converts this [Iterable] to an [IndexedSeq].
  IndexedSeq<A> toIndexedSeq() => IndexedSeq.fromDart(this);

  /// Converts this [Iterable] to an [IVector].
  IVector<A> toIVector() => IVector.fromDart(this);

  /// Converts this [Iterable] to a [RSeq].
  RSeq<A> toSeq() => RSeq.fromDart(this);
}
