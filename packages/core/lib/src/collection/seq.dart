import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/seq_views.dart' as seqviews;
import 'package:ribs_core/src/collection/views.dart' as views;

mixin Seq<A> on RIterable<A> {
  A operator [](int idx);
  int get length;

  static Seq<A> from<A>(RIterableOnce<A> elems) {
    if (elems is Seq<A>) {
      return elems;
    } else {
      return IVector.from(elems.iterator);
    }
  }

  static Seq<A> fromDart<A>(Iterable<A> elems) =>
      from(RIterator.fromDart(elems.iterator));

  /// Returns a new Seq, with the given [elem] added to the end.
  Seq<A> appended(A elem) => seqviews.Appended(this, elem).toSeq();

  /// Returns a new Seq, with [elems] added to the end.
  Seq<A> appendedAll(RIterableOnce<A> suffix) => super.concat(suffix).toSeq();

  @override
  Seq<B> collect<B>(Function1<A, Option<B>> f) => super.collect(f).toSeq();

  /// Returns an [Iterator] that will produce all combinations of elements from
  /// this sequence of size [n] **in order**.
  ///
  /// Given the list `[1, 2, 2, 2]`, combinations of size 2 would result in
  /// `[1, 2]` and `[2, 2]`. Note that `[2, 1]` would not be included since
  /// combinations are taken from element **in order**.
  ///
  /// Also note from the example above, `[1, 2]` would only be included once
  /// even though there are technically 3 ways to generate a combination of
  /// `[1, 2]`, only one will be included in the result since the other 2 are
  /// duplicates.
  RIterator<Seq<A>> combinations(int n) {
    if (n < 0 || n > size) {
      return RIterator.empty();
    } else {
      return _CombinationsItr.from(n, this);
    }
  }

  @override
  Seq<A> concat(RIterableOnce<A> suffix) =>
      seqviews.Concat(this, suffix.toSeq());

  /// Returns true, if any element of this collection equals [elem].
  bool contains(A elem) => exists((a) => a == elem);

  /// Returns true if [that] is contained in this collection, in order.
  bool containsSlice(Seq<A> that) => indexOfSlice(that).isDefined;

  @override
  bool corresponds<B>(Seq<B> that, Function2<A, B, bool> p) {
    final i = iterator;
    final j = that.iterator;

    while (i.hasNext && j.hasNext) {
      if (!p(i.next(), j.next())) return false;
    }

    return !i.hasNext && !j.hasNext;
  }

  /// Returns a new collection with the difference of this and [that], i.e.
  /// all elements that appear in **only** this collection.
  Seq<A> diff(Seq<A> that) {
    final occ = _occCounts(that);

    final it = iterator.filter((key) {
      var include = false;

      if (occ.containsKey(key)) {
        final value = occ[key]!;
        if (value == 1) {
          occ.remove(key);
        } else {
          occ[key] = value - 1;
        }
      } else {
        include = true;
        occ.remove(key);
      }

      return include;
    });

    return Seq.from(it);
  }

  /// Returns a new collection where every element is distinct according to
  /// equality.
  Seq<A> distinct() => distinctBy(identity);

  /// Returns a new collection where every element is distinct according to
  /// the application of [f] to each element.
  Seq<A> distinctBy<B>(Function1<A, B> f) => views.DistinctBy(this, f).toSeq();

  @override
  Seq<A> drop(int n) => seqviews.Drop(this, n);

  @override
  Seq<A> dropRight(int n) => seqviews.DropRight(this, n);

  @override
  Seq<A> dropWhile(Function1<A, bool> p) => super.dropWhile(p).toSeq();

  /// Returns true if the end of this collection has the same elements in order
  /// as [that]. Otherwise, false is returned.
  bool endsWith(RIterable<A> that) {
    if (that.isEmpty) {
      return true;
    } else {
      final i = iterator.drop(length - that.size);
      final j = that.iterator;
      while (i.hasNext && j.hasNext) {
        if (i.next() != j.next()) return false;
      }

      return !j.hasNext;
    }
  }

  Option<A> findLast(Function1<A, bool> p) {
    final it = reverseIterator();
    while (it.hasNext) {
      final elem = it.next();
      if (p(elem)) return Some(elem);
    }

    return none();
  }

  @override
  Seq<A> filter(Function1<A, bool> p) => super.filter(p).toSeq();

  @override
  Seq<A> filterNot(Function1<A, bool> p) => super.filterNot(p).toSeq();

  @override
  Seq<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) =>
      views.FlatMap(this, f).toSeq();

  @override
  IMap<K, Seq<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues((a) => a.toSeq());

  @override
  IMap<K, Seq<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues((a) => a.toSeq());

  /// Returns the first index, if any, where the element at that index equals
  /// [elem]. If no index contains [elem], [None] is returned.
  Option<int> indexOf(A elem, [int from = 0]) =>
      indexWhere((a) => a == elem, from);

  /// Finds the first index in this collection where the next sequence of
  /// elements is equal to [that]. If [that] cannot be found in this collection,
  /// [None] is returned.
  Option<int> indexOfSlice(Seq<A> that, [int from = 0]) {
    if (that.isEmpty && from == 0) {
      return const Some(0);
    } else {
      final l = knownSize;
      final tl = that.knownSize;

      if (l >= 0 && tl >= 0) {
        final clippedFrom = max(0, from);
        if (from > l) {
          return none();
        } else if (tl < 1) {
          return Some(clippedFrom);
        } else if (l < tl) {
          return none();
        } else {
          return _kmpSearch(this, clippedFrom, l, that, 0, tl, true);
        }
      } else {
        var i = from;
        var s = drop(i);
        while (s.nonEmpty) {
          if (s.startsWith(that)) return Some(i);

          i += 1;
          s = s.tail();
        }
        return none();
      }
    }
  }

  /// {@template seq_indexWhere}
  /// Returns the index of the first element that satisfies the predicate [p].
  /// If no element satisfies, [None] is returned.
  /// {@endtemplate}
  Option<int> indexWhere(Function1<A, bool> p, [int from = 0]) =>
      iterator.indexWhere(p, from);

  @override
  Seq<A> init() => dropRight(1);

  /// Returns a new collection with the intersection of this and [that], i.e.
  /// all elements that appear in both collections.
  Seq<A> intersect(Seq<A> that) {
    final occ = _occCounts(that);

    final it = iterator.filter((key) {
      var include = true;

      if (occ.containsKey(key)) {
        final value = occ[key]!;
        if (value == 1) {
          occ.remove(key);
        } else {
          occ[key] = value - 1;
        }
      } else {
        include = false;
        occ.remove(key);
      }

      return include;
    });

    return Seq.from(it);
  }

  /// Returns a new collection with [sep] inserted between each element.
  Seq<A> intersperse(A x) {
    final b = IList.builder<A>();
    final it = iterator;

    if (it.hasNext) {
      b.addOne(it.next());

      while (it.hasNext) {
        b.addOne(x);
        b.addOne(it.next());
      }
    }

    return b.toIList();
  }

  /// Returns true if this collection has an element at the given [idx].
  bool isDefinedAt(int idx) => 0 <= idx && idx < size;

  /// Returns the last index, if any, where the element at that index equals
  /// [elem]. If no index contains [elem], [None] is returned.
  Option<int> lastIndexOf(A elem, [int end = 2147483647]) =>
      lastIndexWhere((a) => a == elem, end);

  /// Finds the last index in this collection where the next sequence of
  /// elements is equal to [that]. If [that] cannot be found in this collection,
  /// [None] is returned.
  Option<int> lastIndexOfSlice(Seq<A> that, [int end = 2147483647]) {
    final l = length;
    final tl = that.length;
    final clippedL = min(l - tl, end);

    if (end < 0) {
      return none();
    } else if (tl < 1) {
      return Some(clippedL);
    } else if (l < tl) {
      return none();
    } else {
      return _kmpSearch(this, 0, clippedL + tl, that, 0, tl, false);
    }
  }

  /// {@template seq_lastIndexWhere}
  /// Returns the index of the last element that satisfies the predicate [p].
  /// If no element satisfies, [None] is returned.
  /// {@endtemplate}
  Option<int> lastIndexWhere(Function1<A, bool> p, [int end = 2147483647]) {
    var i = length - 1;
    final it = reverseIterator();

    while (it.hasNext) {
      final elem = it.next();

      if (i < end && p(elem)) return Some(i);

      i -= 1;
    }

    return none();
  }

  /// Returns the element at index [ix] as a [Some]. If [ix] is outside the
  /// range of this collection, [None] is returned.
  Option<A> lift(int ix) => Option.when(() => isDefinedAt(ix), () => this[ix]);

  @override
  Seq<B> map<B>(covariant Function1<A, B> f) => seqviews.Map(this, f).toSeq();

  /// Returns a new collection with a length of at least [len].
  ///
  /// If this collection is shorter than [len], the returned collection will
  /// have size [len] and [elem] will be used for each new element needed to
  /// reach that size.
  ///
  /// If this collection is already at least [len] in size, this collection
  /// will be returned.
  Seq<A> padTo(int len, A elem) => views.PadTo(this, len, elem).toSeq();

  Seq<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      views.Patched(this, from, other, replaced).toSeq();

  @override
  (Seq<A>, Seq<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (a.toSeq(), b.toSeq());
  }

  @override
  (Seq<A1>, Seq<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) {
    final (a, b) = super.partitionMap(f);
    return (a.toSeq(), b.toSeq());
  }

  /// Returns an [Iterator] that will emit all possible permutations of the
  /// elements in this collection.
  ///
  /// Note that only distinct permutations are emitted. Given the example
  /// `[1, 2, 2, 2]` the permutations will only include `[1, 2, 2, 2]` once,
  /// even though there are 3 different way to generate that permutation.
  RIterator<Seq<A>> permutations() {
    if (isEmpty) {
      return RIterator.empty();
    } else {
      return _PermutationsItr.from(this);
    }
  }

  /// Returns a new collection with [elem] added to the beginning.
  Seq<A> prepended(A elem) => seqviews.Prepended(elem, this).toSeq();

  /// Returns a new collection with all [elems] added to the beginning.
  Seq<A> prependedAll(RIterableOnce<A> prefix) =>
      seqviews.Concat(prefix.toSeq(), this);

  Seq<A> removeAt(int idx) {
    if (0 <= idx && idx < length) {
      if (idx == 0) {
        return tail();
      } else {
        final (a, b) = splitAt(idx);
        return a.concat(b.tail());
      }
    } else {
      throw RangeError('$idx is out of bounds (min 0, max ${length - 1})');
    }
  }

  Seq<A> removeFirst(Function1<A, bool> p) =>
      indexWhere(p).fold(() => this, removeAt);

  /// Returns a new collection with the order of the elements reversed.
  Seq<A> reverse();

  /// Returns an iterator that will emit all elements in this collection, in
  /// reverse order.
  RIterator<A> reverseIterator() => reverse().iterator;

  /// Returns true if this collection has the same elements, in the same order,
  /// as [that].
  bool sameElements(RIterable<A> that) {
    final thisKnownSize = knownSize;
    final thatKnownSize = that.knownSize;
    final knownDifference = thisKnownSize != -1 &&
        thatKnownSize != -1 &&
        thisKnownSize != thatKnownSize;

    return !knownDifference && iterator.sameElements(that);
  }

  @override
  Seq<B> scan<B>(B z, Function2<B, A, B> op) => super.scan(z, op).toSeq();

  @override
  Seq<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      super.scanLeft(z, op).toSeq();

  @override
  Seq<B> scanRight<B>(B z, Function2<A, B, B> op) =>
      super.scanRight(z, op).toSeq();

  @override
  RIterator<Seq<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map((a) => a.toSeq());

  int segmentLength(Function1<A, bool> p, [int from = 0]) {
    var i = 0;
    final it = iterator.drop(from);

    while (it.hasNext && p(it.next())) {
      i += 1;
    }

    return i;
  }

  @override
  int get size => length;

  /// Returns a new collection that is sorted according to [order].
  Seq<A> sorted(Order<A> order) => fromDart(toList()..sort(order.compare));

  /// Returns a new collection that is sorted according to [order] after
  /// applying [f] to each element in this collection.
  Seq<A> sortBy<B>(Order<B> order, Function1<A, B> f) =>
      sorted(order.contramap(f));

  /// Returns a new collection sorted using the provided function [lt] which is
  /// used to determine if one element is less than the other.
  Seq<A> sortWith(Function2<A, A, bool> lt) => sorted(Order.fromLessThan(lt));

  @override
  (Seq<A>, Seq<A>) span(Function1<A, bool> p) =>
      super.span(p)((a, b) => (a.toSeq(), b.toSeq()));

  @override
  (Seq<A>, Seq<A>) splitAt(int n) =>
      super.splitAt(n)((a, b) => (a.toSeq(), b.toSeq()));

  /// Returns true if the beginning of this collection corresponds with [that].
  bool startsWith(RIterableOnce<A> that, [int offset = 0]) {
    final i = iterator.drop(offset);
    final j = that.iterator;
    while (j.hasNext && i.hasNext) {
      if (i.next() != j.next()) return false;
    }

    return !j.hasNext;
  }

  @override
  Seq<A> tail() => view().tail().toSeq();

  /// Applies [f] to each element of this [Seq] and collects the results into a
  /// new collection. If [Left] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  Either<B, Seq<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) {
    Either<B, Seq<C>> result = Either.pure(IVector.empty());

    foreach((elem) {
      // short circuit
      if (result.isLeft) {
        return result;
      }

      // Workaround for contravariant issues in error case
      result = result.fold(
        (_) => result,
        (acc) => f(elem).fold(
          (err) => err.asLeft(),
          (a) => acc.appended(a).asRight(),
        ),
      );
    });

    return result;
  }

  /// Applies [f] to each element of this [Seq] and collects the results into a
  /// new collection. If [None] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  Option<Seq<B>> traverseOption<B>(Function1<A, Option<B>> f) {
    Option<Seq<B>> result = Option.pure(IVector.empty());

    foreach((elem) {
      if (result.isEmpty) return result; // short circuit
      result = result.flatMap((l) => f(elem).map((b) => l.appended(b)));
    });

    return result;
  }

  @override
  SeqView<A> view() => SeqView.from(this);

  @override
  Seq<(A, B)> zip<B>(RIterableOnce<B> that) => super.zip(that).toSeq();

  @override
  Seq<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      super.zipAll(that, thisElem, thatElem).toSeq();

  @override
  Seq<(A, int)> zipWithIndex() => super.zipWithIndex().toSeq();

  Map<B, int> _occCounts<B>(Seq<B> sq) {
    final occ = <B, int>{};
    sq.foreach((y) => occ.update(y, (value) => value + 1, ifAbsent: () => 1));
    return occ;
  }
}

class _PermutationsItr<A> extends RIterator<Seq<A>> {
  final List<A> _elms;
  final List<int> _idxs;

  var _hasNext = true;

  _PermutationsItr._(this._elms, this._idxs);

  static _PermutationsItr<A> from<A>(Seq<A> l) {
    final m = <A, int>{};

    final (elems, idxs) = l
        .map((e) => (e, m.putIfAbsent(e, () => m.length)))
        .sortBy(Order.ints, (a) => a.$2)
        .unzip();

    return _PermutationsItr._(elems.toList(), idxs.toList());
  }

  @override
  bool get hasNext => _hasNext;

  @override
  Seq<A> next() {
    if (!hasNext) return RIterator.empty<Seq<A>>().next();

    final forcedElms = List<A>.empty(growable: true);
    forcedElms.addAll(_elms);

    final result = Seq.fromDart(_elms);

    var i = _idxs.length - 2;

    while (i >= 0 && _idxs[i] >= _idxs[i + 1]) {
      i -= 1;
    }

    if (i < 0) {
      _hasNext = false;
    } else {
      var j = _idxs.length - 1;
      while (_idxs[j] <= _idxs[i]) {
        j -= 1;
      }
      _swap(i, j);

      final len = (_idxs.length - i) / 2;
      var k = 1;
      while (k <= len) {
        _swap(i + k, _idxs.length - k);
        k += 1;
      }
    }

    return result;
  }

  void _swap(int i, int j) {
    final tmpI = _idxs[i];
    _idxs[i] = _idxs[j];
    _idxs[j] = tmpI;
    final tmpE = _elms[i];
    _elms[i] = _elms[j];
    _elms[j] = tmpE;
  }
}

class _CombinationsItr<A> extends RIterator<Seq<A>> {
  final int n;

  final List<A> _elems;
  final List<int> _cnts;
  final List<int> _nums;
  final List<int> _offs;

  var _hasNext = true;

  _CombinationsItr._(this.n, this._elems, this._cnts, this._nums, this._offs);

  static _CombinationsItr<A> from<A>(int n, Seq<A> l) {
    final m = <A, int>{};

    final (elems, idxs) = l
        .map((e) => (e, m.putIfAbsent(e, () => m.length)))
        .sortBy(Order.ints, (a) => a.$2)
        .unzip();

    final cnts = List.filled(m.length, 0);
    idxs.foreach((i) => cnts[i] += 1);

    final nums = List.filled(cnts.length, 0);
    int r = n;
    for (int k = 0; k < nums.length; k++) {
      nums[k] = min(r, cnts[k]);
      r -= nums[k];
    }

    final offs = RIterable.fromDart(cnts).scanLeft(0, (a, b) => a + b).toList();

    return _CombinationsItr._(n, elems.toList(), cnts, nums, offs);
  }

  @override
  bool get hasNext => _hasNext;

  @override
  Seq<A> next() {
    if (!hasNext) return RIterator.empty<Seq<A>>().next();

    /* Calculate this result. */
    // calculate next
    final buf = List<A>.empty(growable: true);
    for (int k = 0; k < _nums.length; k++) {
      for (int j = 0; j < _nums[k]; j++) {
        buf.add(_elems[_offs[k] + j]);
      }
    }

    final res = Seq.fromDart(buf);

    /* Prepare for the next call to next. */
    var idx = _nums.length - 1;
    while (idx >= 0 && _nums[idx] == _cnts[idx]) {
      idx -= 1;
    }

    idx = _nums.lastIndexWhere((x) => x > 0, idx - 1);

    if (idx < 0) {
      _hasNext = false;
    } else {
      // OPT: hand rolled version of `sum = nums.view(idx + 1, nums.length).sum + 1`
      var sum = 1;
      var i = idx + 1;
      while (i < _nums.length) {
        sum += _nums[i];
        i += 1;
      }

      _nums[idx] -= 1;

      for (int k = idx + 1; k < _nums.length; k++) {
        _nums[k] = min(sum, _cnts[k]);
        sum -= _nums[k];
      }
    }

    return res;
  }
}

Option<int> _kmpSearch<B>(
  Seq<B> S,
  int m0,
  int m1,
  Seq<B> W,
  int n0,
  int n1,
  bool forward,
) {
  // We had better not index into S directly!
  final iter = S.iterator.drop(m0);
  final Wopt = W; //kmpOptimizeWord(W, n0, n1, forward = true);
  final T = _kmpJumpTable(Wopt, n1 - n0);

  // Ring buffer--need a quick way to do a look-behind
  final cache = List<dynamic>.filled(n1 - n0, null);

  var largest = 0;
  var i = 0;
  var m = 0;
  var answer = -1;

  while (m + m0 + n1 - n0 <= m1) {
    while (i + m >= largest) {
      cache[largest % (n1 - n0)] = iter.next();
      largest += 1;
    }
    if (Wopt[i] == cache[(i + m) % (n1 - n0)] as B) {
      i += 1;
      if (i == n1 - n0) {
        if (forward) {
          return Some(m + m0);
        } else {
          i -= 1;
          answer = m + m0;
          final ti = T[i]!;
          m += i - ti;
          if (i > 0) i = ti;
        }
      }
    } else {
      final ti = T[i]!;
      m += i - ti;
      if (i > 0) i = ti;
    }
  }
  return Option(answer).filter((a) => a >= 0);
}

List<int?> _kmpJumpTable<B>(Seq<B> Wopt, int wlen) {
  final arr = List<int?>.filled(wlen, null);
  var pos = 2;
  var cnd = 0;
  arr[0] = -1;
  arr[1] = 0;
  while (pos < wlen) {
    if (Wopt[pos - 1] == Wopt[cnd]) {
      arr[pos] = cnd + 1;
      pos += 1;
      cnd += 1;
    } else if (cnd > 0) {
      cnd = arr[cnd]!;
    } else {
      arr[pos] = 0;
      pos += 1;
    }
  }
  return arr;
}
