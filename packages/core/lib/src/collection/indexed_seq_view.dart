import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/indexed_seq_views.dart' as iseqview;

mixin IndexedSeqView<A>
    on
        IterableOnce<A>,
        RibsIterable<A>,
        Seq<A>,
        View<A>,
        SeqView<A>,
        IndexedSeq<A> {
  static IndexedSeqView<A> from<A>(IndexedSeq<A> v) => iseqview.Id(v);

  @override
  IndexedSeq<A> appended(A elem) => iseqview.Appended(this, elem);

  @override
  IndexedSeq<A> appendedAll(IterableOnce<A> suffix) =>
      iseqview.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeq<A> concat(IterableOnce<A> suffix) =>
      iseqview.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeq<A> drop(int n) => iseqview.Drop(this, n);

  @override
  IndexedSeq<A> dropRight(int n) => iseqview.DropRight(this, n);

  @override
  RibsIterator<A> get iterator => iseqview.IndexedSeqViewIterator(this);

  @override
  IndexedSeqView<B> map<B>(Function1<A, B> f) => iseqview.Map(this, f);

  @override
  IndexedSeq<A> prepended(A elem) => iseqview.Prepended(elem, this);

  @override
  IndexedSeq<A> prependedAll(IterableOnce<A> prefix) =>
      iseqview.Concat(prefix.toIndexedSeq(), this);

  @override
  IndexedSeq<A> reverse() => iseqview.Reverse(this);

  @override
  RibsIterator<A> reverseIterator() =>
      iseqview.IndexedSeqViewReverseIterator(this);

  @override
  IndexedSeq<A> slice(int from, int until) => iseqview.Slice(this, from, until);

  @override
  IndexedSeq<A> take(int n) => iseqview.Take(this, n);

  @override
  IndexedSeq<A> takeRight(int n) => iseqview.TakeRight(this, n);

  @override
  IndexedSeq<A> tapEach<U>(Function1<A, U> f) => iseqview.Map(this, (a) {
        f(a);
        return a;
      });

  @override
  IndexedSeqView<A> view() => this;
}
