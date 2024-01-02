import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/collection/seq_views.dart' as seqview;

mixin SeqView<A> on IterableOnce<A>, RibsIterable<A>, Seq<A>, View<A> {
  static SeqView<A> from<A>(Seq<A> v) => seqview.Id(v);

  @override
  SeqView<A> appended(A elem) => seqview.Appended(this, elem);

  @override
  SeqView<A> appendedAll(covariant Seq<A> suffix) =>
      seqview.Concat(this, suffix);

  @override
  SeqView<A> concat(covariant IterableOnce<A> suffix) =>
      seqview.Concat(this, suffix.toSeq());

  @override
  SeqView<A> drop(int n) => seqview.Drop(this, n);

  @override
  SeqView<A> dropRight(int n) => seqview.DropRight(this, n);

  @override
  SeqView<B> map<B>(Function1<A, B> f) => seqview.Map(this, f);

  @override
  SeqView<A> prepended(A elem) => seqview.Prepended(elem, this);

  @override
  SeqView<A> prependedAll(covariant Seq<A> prefix) =>
      seqview.Concat(prefix, this);

  @override
  SeqView<A> reverse() => seqview.Reverse(this);

  @override
  SeqView<A> sorted(Order<A> order) => seqview.Sorted(this, order);

  @override
  SeqView<A> take(int n) => seqview.Take(this, n);

  @override
  SeqView<A> takeRight(int n) => seqview.TakeRight(this, n);

  @override
  SeqView<A> tapEach<U>(Function1<A, U> f) => seqview.Map(this, (a) {
        f(a);
        return a;
      });

  @override
  SeqView<A> view() => this;
}
