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
part 'riterator/ribs.dart';
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

/// A single-use, forward-only iterator over elements of type [A].
///
/// [RIterator] is the traversal primitive for all ribs collections. Callers
/// advance it by checking [hasNext] and then calling [next]. Each element is
/// produced exactly once — the iterator cannot be reset.
///
/// Create instances with the static factory methods:
/// - [RIterator.empty] — an iterator that immediately reports `hasNext == false`
/// - [RIterator.single] — one element
/// - [RIterator.fill] — [len] copies of the same element
/// - [RIterator.tabulate] — [len] elements computed by index
/// - [RIterator.fromDart] — wrap a Dart [Iterator]
/// - [RIterator.iterate] — infinite sequence `start, f(start), f(f(start)), …`
/// - [RIterator.unfold] — stateful anamorphism that terminates when [f] returns [None]
///
/// All transformation methods ([map], [filter], [flatMap], etc.) return lazy
/// iterators — they do not evaluate elements until [next] is called.
abstract class RIterator<A> with RIterableOnce<A> {
  const RIterator();

  /// Whether the iterator has a next element.
  bool get hasNext;

  /// Returns the next element, advancing the iterator.
  ///
  /// Throws [UnsupportedError] when called on an exhausted iterator.
  A next();

  @protected
  Never noSuchElement([String? message]) =>
      throw UnsupportedError(message ?? 'Called "next" on an empty iterator');

  @override
  RIterator<A> get iterator => this;

  /// Returns an iterator that immediately reports `hasNext == false`.
  static RIterator<A> empty<A>() => _EmptyIterator<A>();

  /// Returns an iterator that yields [elem] exactly [len] times.
  static RIterator<A> fill<A>(int len, A elem) => _FillIterator(len, elem);

  /// Wraps a Dart [Iterator] in an [RIterator].
  static RIterator<A> fromDart<A>(Iterator<A> it) => _DartIterator(it);

  /// Returns an infinite iterator producing `start, f(start), f(f(start)), …`.
  static RIterator<A> iterate<A>(A start, Function1<A, A> f) => _IterateIterator(start, f);

  /// Returns an iterator that yields [a] exactly once.
  static RIterator<A> single<A>(A a) => _SingleIterator(a);

  /// Returns an iterator of length [len] where element `i` is `f(i)`.
  static RIterator<A> tabulate<A>(int len, Function1<int, A> f) => _TabulateIterator(len, f);

  /// Returns an iterator produced by an anamorphism.
  ///
  /// Starting from [initial], applies [f] repeatedly. Each call to [f] must
  /// return `Some((value, nextState))` to emit [value] and continue, or [None]
  /// to terminate.
  static RIterator<A> unfold<A, S>(
    S initial,
    Function1<S, Option<(A, S)>> f,
  ) => _UnfoldIterator(initial, f);

  // ///////////////////////////////////////////////////////////////////////////

  @override
  RIterator<B> collect<B>(Function1<A, Option<B>> f) => _CollectIterator(this, f);

  /// Returns an iterator that first yields all elements of this iterator, then
  /// all elements of [xs].
  RIterator<A> concat(RIterableOnce<A> xs) => _ConcatIterator(this).concat(xs);

  /// Returns an iterator that skips duplicate elements, keeping first occurrence.
  RIterator<A> distinct<B>(Function1<A, B> f) => distinctBy(identity);

  /// Returns an iterator that skips elements whose key [f(elem)] has already
  /// been seen, keeping the first occurrence of each key.
  RIterator<A> distinctBy<B>(Function1<A, B> f) => _DistinctByIterator(this, f);

  @override
  RIterator<A> drop(int n) => sliceIterator(n, -1);

  @override
  RIterator<A> dropWhile(Function1<A, bool> p) => _DropWhileIterator(this, p);

  @override
  RIterator<A> filter(Function1<A, bool> p) => _FilterIterator(this, p, false);

  @override
  RIterator<A> filterNot(Function1<A, bool> p) => _FilterIterator(this, p, true);

  @override
  RIterator<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) => _FlatMapIterator(this, f);

  /// Returns an iterator of non-overlapping groups of [size] consecutive
  /// elements.
  RIterator<RSeq<A>> grouped(int size) => _GroupedIterator(this, size, size);

  /// Returns `Some(index)` of the first occurrence of [elem] at or after
  /// [from], or [None] if not found.
  Option<int> indexOf(A elem, [int from = 0]) => indexWhere((a) => a == elem);

  /// Returns `Some(index)` of the first element satisfying [p] at or after
  /// [from], or [None] if no such element exists.
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

  /// Returns an iterator that yields all elements of this iterator and then
  /// [elem] repeated until the total count reaches [len].
  ///
  /// If the iterator already has [len] or more elements, no padding is added.
  RIterator<A> padTo(int len, A elem) => _PadToIterator(this, len, elem);

  /// Returns an iterator that replaces [replaced] elements starting at
  /// position [from] with the elements of [patchElems].
  RIterator<A> patch(int from, RIterator<A> patchElems, int replaced) =>
      _PatchIterator(this, from, patchElems, replaced);

  /// Returns `true` if this iterator and [that] produce the same elements in
  /// the same order and both exhaust at the same time.
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
  RIterator<B> scanLeft<B>(B z, Function2<B, A, B> op) => _ScanLeftIterator(this, z, op);

  @override
  RIterator<A> slice(int from, int until) => sliceIterator(from, max(until, 0));

  /// Returns an iterator of overlapping windows of [size] elements, advancing
  /// by [step] elements between windows.
  RIterator<RSeq<A>> sliding(int size, [int step = 1]) => _GroupedIterator(this, size, step);

  @override
  (RIterator<A>, RIterator<A>) span(Function1<A, bool> p) => _spanIterator(this, p);

  @override
  RIterator<A> take(int n) => sliceIterator(0, max(n, 0));

  @override
  RIterator<A> takeWhile(Function1<A, bool> p) => _TakeWhileIterator(this, p);

  /// Converts this [RIterator] to a Dart [Iterator].
  Iterator<A> get toDart => _RibsIterator(this);

  /// Returns an iterator of pairs, stopping when either side is exhausted.
  RIterator<(A, B)> zip<B>(RIterableOnce<B> that) => _ZipIterator(this, that);

  /// Returns an iterator of pairs, padding the shorter side with [thisElem] or
  /// [thatElem] until both sides are exhausted.
  RIterator<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      _ZipAllIterator(this, that, thisElem, thatElem);

  /// Returns an iterator of `(element, index)` pairs.
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
