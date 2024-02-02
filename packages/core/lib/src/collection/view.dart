import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin View<A> on RIterable<A> {
  static View<A> fromIterableProvider<A>(Function0<RIterable<A>> iterable) =>
      views.Id(iterable());

  @override
  RIterable<B> collect<B>(Function1<A, Option<B>> f) => views.Collect(this, f);

  @override
  RIterable<A> concat(covariant RIterableOnce<A> suffix) =>
      views.Concat(this, suffix);

  @override
  RIterable<A> drop(int n) => views.Drop(this, n);

  @override
  RIterable<A> dropRight(int n) => views.DropRight(this, n);

  @override
  RIterable<A> dropWhile(Function1<A, bool> p) => views.DropWhile(this, p);

  @override
  RIterable<A> filter(Function1<A, bool> p) => views.Filter(this, p, false);

  @override
  RIterable<A> filterNot(Function1<A, bool> p) => views.Filter(this, p, true);

  @override
  RIterable<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) =>
      views.FlatMap(this, f);

  @override
  RIterable<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f);

  @override
  RIterable<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      views.ScanLeft(this, z, op);

  @override
  RIterable<A> take(int n) => views.Take(this, n);

  @override
  RIterable<A> takeRight(int n) => views.TakeRight(this, n);

  @override
  RIterable<A> takeWhile(Function1<A, bool> p) => views.TakeWhile(this, p);

  @override
  View<A> view() => this;

  @override
  RIterable<(A, B)> zip<B>(RIterableOnce<B> that) => views.Zip(this, that);

  @override
  RIterable<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      views.ZipAll(this, that, thisElem, thatElem);

  @override
  RIterable<(A, int)> zipWithIndex() => views.ZipWithIndex(this);
}
