import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/seq_views.dart' as seqview;

mixin SeqView<A> on IterableOnce<A>, RibsIterable<A>, Seq<A>, View<A> {
  static SeqView<A> from<A>(Seq<A> v) => seqview.Id(v);

  @override
  Seq<A> appended(A elem) => seqview.Appended(this, elem);

  @override
  Seq<A> appendedAll(IterableOnce<A> suffix) =>
      seqview.Concat(this, suffix.toSeq());

  @override
  Seq<A> concat(covariant IterableOnce<A> suffix) =>
      seqview.Concat(this, suffix.toSeq());

  @override
  Seq<A> drop(int n) => seqview.Drop(this, n);

  @override
  Seq<A> dropRight(int n) => seqview.DropRight(this, n);

  @override
  SeqView<B> map<B>(Function1<A, B> f) => seqview.Map(this, f);

  @override
  Seq<A> prepended(A elem) => seqview.Prepended(elem, this);

  @override
  Seq<A> prependedAll(IterableOnce<A> prefix) =>
      seqview.Concat(prefix.toSeq(), this);

  @override
  Seq<A> reverse() => seqview.Reverse(this);

  @override
  Seq<A> sorted(Order<A> order) => seqview.Sorted(this, order);

  @override
  Seq<A> take(int n) => seqview.Take(this, n);

  @override
  Seq<A> takeRight(int n) => seqview.TakeRight(this, n);

  @override
  Seq<A> tapEach<U>(Function1<A, U> f) => seqview.Map(this, (a) {
        f(a);
        return a;
      });

  @override
  SeqView<A> view() => this;
}
