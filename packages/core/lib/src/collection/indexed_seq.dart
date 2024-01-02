import 'package:ribs_core/ribs_collection.dart';
import 'package:ribs_core/src/collection/indexed_seq_views.dart' as iseqviews;

/// Seqs with efficient [] and length operators
mixin IndexedSeq<A> on Seq<A> {
  static IndexedSeq<A> from<A>(IterableOnce<A> elems) {
    if (elems is IndexedSeq<A>) {
      return elems;
    } else {
      return IVector.from(elems.iterator);
    }
  }
}

extension IndexedSeqTuple2Ops<A, B> on IndexedSeq<(A, B)> {
  (IndexedSeq<A>, IndexedSeq<B>) unzip() =>
      (iseqviews.Map(this, (a) => a.$1), iseqviews.Map(this, (a) => a.$2));
}
