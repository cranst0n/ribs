import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin View<A> on RibsIterable<A> {
  static View<A> fromIterableProvider<A>(Function0<RibsIterable<A>> iterable) =>
      views.Id(iterable());

  @override
  RibsIterable<B> collect<B>(Function1<A, Option<B>> f) =>
      views.Collect(this, f);

  @override
  RibsIterable<A> concat(covariant IterableOnce<A> suffix) =>
      views.Concat(this, suffix);

  @override
  RibsIterable<A> drop(int n) => views.Drop(this, n);

  @override
  RibsIterable<A> dropRight(int n) => views.DropRight(this, n);

  @override
  RibsIterable<A> dropWhile(Function1<A, bool> p) => views.DropWhile(this, p);

  @override
  RibsIterable<A> filter(Function1<A, bool> p) => views.Filter(this, p, false);

  @override
  RibsIterable<A> filterNot(Function1<A, bool> p) =>
      views.Filter(this, p, true);

  @override
  RibsIterable<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f) =>
      views.FlatMap(this, f);

  @override
  RibsIterable<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f);

  @override
  RibsIterable<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      views.ScanLeft(this, z, op);

  @override
  RibsIterable<A> take(int n) => views.Take(this, n);

  @override
  RibsIterable<A> takeRight(int n) => views.TakeRight(this, n);

  @override
  RibsIterable<A> takeWhile(Function1<A, bool> p) => views.TakeWhile(this, p);

  @override
  View<A> view() => this;

  @override
  RibsIterable<(A, B)> zip<B>(IterableOnce<B> that) => views.Zip(this, that);

  @override
  RibsIterable<(A, B)> zipAll<B>(
          IterableOnce<B> that, A thisElem, B thatElem) =>
      views.ZipAll(this, that, thisElem, thatElem);

  @override
  RibsIterable<(A, int)> zipWithIndex() => views.ZipWithIndex(this);
}
