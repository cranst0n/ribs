import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/indexed_seq_views.dart' as iseqview;

mixin IndexedSeqView<A>
    on
        IterableOnce<A>,
        RibsIterable<A>,
        Seq<A>,
        IndexedSeq<A>,
        View<A>,
        SeqView<A> {
  @override
  IndexedSeqView<A> appended(A elem) => iseqview.Appended(this, elem);

  @override
  IndexedSeqView<A> appendedAll(IterableOnce<A> suffix) =>
      iseqview.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeqView<A> concat(IterableOnce<A> suffix) =>
      iseqview.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeqView<A> drop(int n) => iseqview.Drop(this, n);

  @override
  IndexedSeqView<A> dropRight(int n) => iseqview.DropRight(this, n);

  @override
  RibsIterator<A> get iterator => iseqview.IndexedSeqViewIterator(this);

  @override
  IndexedSeqView<B> map<B>(Function1<A, B> f) => iseqview.Map(this, f);

  @override
  IndexedSeqView<A> prepended(A elem) => iseqview.Prepended(elem, this);

  @override
  IndexedSeqView<A> prependedAll(covariant IndexedSeq<A> prefix) =>
      iseqview.Concat(prefix, this);

  @override
  IndexedSeqView<A> reverse() => iseqview.Reverse(this);

  @override
  RibsIterator<A> reverseIterator() =>
      iseqview.IndexedSeqViewReverseIterator(this);

  @override
  IndexedSeqView<A> slice(int from, int until) =>
      iseqview.Slice(this, from, until);

  @override
  IndexedSeqView<A> take(int n) => iseqview.Take(this, n);

  @override
  IndexedSeqView<A> takeRight(int n) => iseqview.TakeRight(this, n);

  @override
  IndexedSeqView<A> tapEach<U>(Function1<A, U> f) => iseqview.Map(this, (a) {
        f(a);
        return a;
      });

  @override
  IndexedSeqView<A> view() => this;
}
