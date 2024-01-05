import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/option.dart';

part 'iterator/concat.dart';
part 'iterator/dart.dart';
part 'iterator/empty.dart';
part 'iterator/fill.dart';
part 'iterator/filter.dart';
part 'iterator/flatmap.dart';
part 'iterator/grouped.dart';
part 'iterator/iterate.dart';
part 'iterator/map.dart';
part 'iterator/pad_to.dart';
part 'iterator/patch.dart';
part 'iterator/scan_left.dart';
part 'iterator/single.dart';
part 'iterator/span.dart';
part 'iterator/tabulate.dart';
part 'iterator/take_while.dart';
part 'iterator/unfold.dart';
part 'iterator/zip.dart';
part 'iterator/zip_all.dart';
part 'iterator/zip_with_index.dart';

part 'iterator/collect.dart';
part 'iterator/drop_while.dart';
part 'iterator/distinct_by.dart';
part 'iterator/slice.dart';

abstract class RibsIterator<A> with IterableOnce<A> {
  const RibsIterator();

  bool get hasNext;
  A next();

  @protected
  Never noSuchElement([String? message]) =>
      throw UnsupportedError(message ?? 'Called "next" on an empty iterator');

  @override
  RibsIterator<A> get iterator => this;

  static RibsIterator<A> empty<A>() => const _EmptyIterator();

  static RibsIterator<A> fill<A>(int len, A elem) => _FillIterator(len, elem);

  static RibsIterator<A> fromDart<A>(Iterator<A> it) => _DartIterator(it);

  static RibsIterator<A> iterate<A>(A start, Function1<A, A> f) =>
      _IterateIterator(start, f);

  static RibsIterator<A> single<A>(A a) => _SingleIterator(a);

  static RibsIterator<A> tabulate<A>(int len, Function1<int, A> f) =>
      _TabulateIterator(len, f);

  static RibsIterator<A> unfold<A, S>(
    S initial,
    Function1<S, Option<(A, S)>> f,
  ) =>
      _UnfoldIterator(initial, f);

  // ///////////////////////////////////////////////////////////////////////////

  @override
  RibsIterator<B> collect<B>(Function1<A, Option<B>> f) =>
      _CollectIterator(this, f);

  RibsIterator<A> concat(IterableOnce<A> xs) =>
      _ConcatIterator(this).concat(xs);

  RibsIterator<A> distinct<B>(Function1<A, B> f) => distinctBy(identity);

  RibsIterator<A> distinctBy<B>(Function1<A, B> f) =>
      _DistinctByIterator(this, f);

  @override
  RibsIterator<A> drop(int n) => sliceIterator(n, -1);

  @override
  RibsIterator<A> dropWhile(Function1<A, bool> p) =>
      _DropWhileIterator(this, p);

  @override
  RibsIterator<A> filter(Function1<A, bool> p) =>
      _FilterIterator(this, p, false);

  @override
  RibsIterator<A> filterNot(Function1<A, bool> p) =>
      _FilterIterator(this, p, true);

  @override
  RibsIterator<B> flatMap<B>(Function1<A, IterableOnce<B>> f) =>
      _FlatMapIterator(this, f);

  RibsIterator<Seq<A>> grouped(int size) => _GroupedIterator(this, size, size);

  Option<int> indexOf(A elem, [int from = 0]) => indexWhere((a) => a == elem);

  Option<int> indexWhere(Function1<A, bool> p, [int from = 0]) {
    var i = max(from, 0);
    final dropped = drop(from);

    while (dropped.hasNext) {
      if (p(dropped.next())) return Some(i);
      i += 1;
    }

    return none();
  }

  @override
  RibsIterator<B> map<B>(Function1<A, B> f) => _MapIterator(this, f);

  RibsIterator<A> padTo(int len, A elem) => _PadToIterator(this, len, elem);

  RibsIterator<A> patch(int from, RibsIterator<A> patchElems, int replaced) =>
      _PatchIterator(this, from, patchElems, replaced);

  bool sameElements(IterableOnce<A> that) {
    final those = that.iterator;
    while (hasNext && those.hasNext) {
      if (next() != those.next()) return false;
    }

    // At that point we know that *at least one* iterator has no next element
    // If *both* of them have no elements then the collections are the same
    return hasNext == those.hasNext;
  }

  @override
  RibsIterator<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      _ScanLeftIterator(this, z, op);

  @override
  RibsIterator<A> slice(int from, int until) =>
      sliceIterator(from, max(until, 0));

  RibsIterator<Seq<A>> sliding(int size, [int step = 1]) =>
      _GroupedIterator(this, size, step);

  @override
  (RibsIterator<A>, RibsIterator<A>) span(Function1<A, bool> p) =>
      spanIterator(this, p);

  @override
  RibsIterator<A> take(int n) => sliceIterator(0, max(n, 0));

  @override
  RibsIterator<A> takeWhile(Function1<A, bool> p) =>
      _TakeWhileIterator(this, p);

  RibsIterator<(A, B)> zip<B>(IterableOnce<B> that) => _ZipIterator(this, that);

  RibsIterator<(A, B)> zipAll<B>(
          IterableOnce<B> that, A thisElem, B thatElem) =>
      _ZipAllIterator(this, that, thisElem, thatElem);

  RibsIterator<(A, int)> zipWithIndex() => _ZipWithIndexIterator(this);

  @protected
  RibsIterator<A> sliceIterator(int from, int until) {
    final lo = max(from, 0);
    final int rest;

    if (until < 0) {
      rest = -1; // unbounded
    } else if (until <= lo) {
      rest = 0; // empty
    } else {
      rest = until - lo; // finite
    }

    if (rest == 0) {
      return RibsIterator.empty();
    } else {
      return _SliceIterator(this, lo, rest);
    }
  }
}
