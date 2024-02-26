// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/option.dart';
import 'package:ribs_core/src/util/integer.dart';

part 'riterator/concat.dart';
part 'riterator/dart.dart';
part 'riterator/empty.dart';
part 'riterator/fill.dart';
part 'riterator/filter.dart';
part 'riterator/flatmap.dart';
part 'riterator/grouped.dart';
part 'riterator/iterate.dart';
part 'riterator/map.dart';
part 'riterator/pad_to.dart';
part 'riterator/patch.dart';
part 'riterator/scan_left.dart';
part 'riterator/single.dart';
part 'riterator/span.dart';
part 'riterator/tabulate.dart';
part 'riterator/take_while.dart';
part 'riterator/unfold.dart';
part 'riterator/zip.dart';
part 'riterator/zip_all.dart';
part 'riterator/zip_with_index.dart';

part 'riterator/collect.dart';
part 'riterator/drop_while.dart';
part 'riterator/distinct_by.dart';
part 'riterator/slice.dart';

abstract class RIterator<A> with RIterableOnce<A> {
  const RIterator();

  bool get hasNext;
  A next();

  @protected
  Never noSuchElement([String? message]) =>
      throw UnsupportedError(message ?? 'Called "next" on an empty iterator');

  @override
  RIterator<A> get iterator => this;

  static RIterator<A> empty<A>() => const _EmptyIterator();

  static RIterator<A> fill<A>(int len, A elem) => _FillIterator(len, elem);

  static RIterator<A> fromDart<A>(Iterator<A> it) => _DartIterator(it);

  static RIterator<A> iterate<A>(A start, Function1<A, A> f) =>
      _IterateIterator(start, f);

  static RIterator<A> single<A>(A a) => _SingleIterator(a);

  static RIterator<A> tabulate<A>(int len, Function1<int, A> f) =>
      _TabulateIterator(len, f);

  static RIterator<A> unfold<A, S>(
    S initial,
    Function1<S, Option<(A, S)>> f,
  ) =>
      _UnfoldIterator(initial, f);

  // ///////////////////////////////////////////////////////////////////////////

  @override
  RIterator<B> collect<B>(Function1<A, Option<B>> f) =>
      _CollectIterator(this, f);

  RIterator<A> concat(RIterableOnce<A> xs) => _ConcatIterator(this).concat(xs);

  RIterator<A> distinct<B>(Function1<A, B> f) => distinctBy(identity);

  RIterator<A> distinctBy<B>(Function1<A, B> f) => _DistinctByIterator(this, f);

  @override
  RIterator<A> drop(int n) => sliceIterator(n, -1);

  @override
  RIterator<A> dropWhile(Function1<A, bool> p) => _DropWhileIterator(this, p);

  @override
  RIterator<A> filter(Function1<A, bool> p) => _FilterIterator(this, p, false);

  @override
  RIterator<A> filterNot(Function1<A, bool> p) =>
      _FilterIterator(this, p, true);

  @override
  RIterator<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) =>
      _FlatMapIterator(this, f);

  RIterator<RSeq<A>> grouped(int size) => _GroupedIterator(this, size, size);

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
  RIterator<B> map<B>(Function1<A, B> f) => _MapIterator(this, f);

  RIterator<A> padTo(int len, A elem) => _PadToIterator(this, len, elem);

  RIterator<A> patch(int from, RIterator<A> patchElems, int replaced) =>
      _PatchIterator(this, from, patchElems, replaced);

  bool sameElements(RIterableOnce<A> that) {
    final those = that.iterator;
    while (hasNext && those.hasNext) {
      if (next() != those.next()) return false;
    }

    // At that point we know that *at least one* iterator has no next element
    // If *both* of them have no elements then the collections are the same
    return hasNext == those.hasNext;
  }

  @override
  RIterator<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      _ScanLeftIterator(this, z, op);

  @override
  RIterator<A> slice(int from, int until) => sliceIterator(from, max(until, 0));

  RIterator<RSeq<A>> sliding(int size, [int step = 1]) =>
      _GroupedIterator(this, size, step);

  @override
  (RIterator<A>, RIterator<A>) span(Function1<A, bool> p) =>
      spanIterator(this, p);

  @override
  RIterator<A> take(int n) => sliceIterator(0, max(n, 0));

  @override
  RIterator<A> takeWhile(Function1<A, bool> p) => _TakeWhileIterator(this, p);

  RIterator<(A, B)> zip<B>(RIterableOnce<B> that) => _ZipIterator(this, that);

  RIterator<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      _ZipAllIterator(this, that, thisElem, thatElem);

  RIterator<(A, int)> zipWithIndex() => _ZipWithIndexIterator(this);

  @protected
  RIterator<A> sliceIterator(int from, int until) {
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
      return RIterator.empty();
    } else {
      return _SliceIterator(this, lo, rest);
    }
  }
}
