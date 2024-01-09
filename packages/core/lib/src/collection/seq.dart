import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/seq_views.dart' as seqviews;
import 'package:ribs_core/src/collection/views.dart' as views;

mixin Seq<A> on RibsIterable<A> {
  A operator [](int idx);
  int get length;

  static Seq<A> from<A>(IterableOnce<A> elems) {
    if (elems is Seq<A>) {
      return elems;
    } else {
      return IList.from(elems.iterator);
    }
  }

  static Seq<A> fromDart<A>(Iterable<A> elems) =>
      from(RibsIterator.fromDart(elems.iterator));

  // ///////////////////////////////////////////////////////////////////////////

  Seq<A> appended(A elem);

  Seq<A> appendedAll(IterableOnce<A> suffix) => super.concat(suffix).toSeq();

  Seq<A> prepended(A elem) => views.Prepended(elem, this).toSeq();

  Seq<A> prependedAll(Seq<A> prefix) => seqviews.Concat(prefix, this);

  Seq<A> reverse();

  // ///////////////////////////////////////////////////////////////////////////

  @override
  Seq<B> collect<B>(Function1<A, Option<B>> f) => super.collect(f).toSeq();

  RibsIterator<Seq<A>> combinations(int n) {
    if (n < 0 || n > size) {
      return RibsIterator.empty();
    } else {
      return _CombinationsItr.from(n, this);
    }
  }

  @override
  Seq<A> concat(IterableOnce<A> suffix) =>
      seqviews.Concat(this, suffix.toSeq());

  bool contains(A elem) => exists((a) => a == elem);

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

  Seq<A> distinct() => distinctBy(identity);

  Seq<A> distinctBy<B>(Function1<A, B> f) => views.DistinctBy(this, f).toSeq();

  @override
  Seq<A> drop(int n) => seqviews.Drop(this, n);

  @override
  Seq<A> dropRight(int n) => seqviews.DropRight(this, n);

  @override
  Seq<A> dropWhile(Function1<A, bool> p) => super.dropWhile(p).toSeq();

  bool endsWith(RibsIterable<A> that) {
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
  Seq<B> flatMap<B>(Function1<A, IterableOnce<B>> f) =>
      views.FlatMap(this, f).toSeq();

  Option<int> indexOf(A elem, [int from = 0]) =>
      indexWhere((a) => a == elem, from);

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

  Option<int> indexWhere(Function1<A, bool> p, [int from = 0]) =>
      iterator.indexWhere(p, from);

  @override
  Seq<A> init() => dropRight(1);

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

  bool isDefinedAt(int idx) => 0 <= idx && idx < size;

  Option<int> lastIndexOf(A elem, [int end = 2147483647]) =>
      lastIndexWhere((a) => a == elem, end);

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

  Option<A> lift(int idx) =>
      Option.when(() => isDefinedAt(idx), () => this[idx]);

  @override
  Seq<B> map<B>(covariant Function1<A, B> f) => seqviews.Map(this, f).toSeq();

  Seq<A> padTo(int len, A elem) => views.PadTo(this, len, elem).toSeq();

  Seq<A> patch(int from, IterableOnce<A> other, int replaced) =>
      views.Patched(this, from, other, replaced).toSeq();

  RibsIterator<Seq<A>> permutations() {
    if (isEmpty) {
      return RibsIterator.empty();
    } else {
      return _PermutationsItr.from(this);
    }
  }

  RibsIterator<A> reverseIterator() => reverse().iterator;

  bool sameElements(RibsIterable<A> that) {
    final thisKnownSize = knownSize;
    final thatKnownSize = that.knownSize;
    final knownDifference = thisKnownSize != -1 &&
        thatKnownSize != -1 &&
        thisKnownSize != thatKnownSize;

    return !knownDifference && iterator.sameElements(that);
  }

  bool startsWith(IterableOnce<A> that, [int offset = 0]) {
    final i = iterator.drop(offset);
    final j = that.iterator;
    while (j.hasNext && i.hasNext) {
      if (i.next() != j.next()) return false;
    }

    return !j.hasNext;
  }

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

  // TODO: do better?
  Seq<A> sorted(Order<A> order) => fromDart(toList()..sort(order.compare));

  Seq<A> sortBy<B>(Order<B> order, Function1<A, B> f) =>
      sorted(order.contramap(f));

  Seq<A> sortWith(Function2<A, A, bool> lt) => sorted(Order.fromLessThan(lt));

  @override
  (Seq<A>, Seq<A>) span(Function1<A, bool> p) =>
      super.span(p)((a, b) => (a.toSeq(), b.toSeq()));

  @override
  (Seq<A>, Seq<A>) splitAt(int n) =>
      super.splitAt(n)((a, b) => (a.toSeq(), b.toSeq()));

  @override
  Seq<A> tail() => view().tail().toSeq();

  Map<B, int> _occCounts<B>(Seq<B> sq) {
    final occ = <B, int>{};
    sq.foreach((y) => occ.update(y, (value) => value + 1, ifAbsent: () => 1));
    return occ;
  }
}

class _PermutationsItr<A> extends RibsIterator<Seq<A>> {
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
    if (!hasNext) return RibsIterator.empty<Seq<A>>().next();

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

class _CombinationsItr<A> extends RibsIterator<Seq<A>> {
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

    final offs =
        RibsIterable.fromDart(cnts).scanLeft(0, (a, b) => a + b).toList();

    return _CombinationsItr._(n, elems.toList(), cnts, nums, offs);
  }

  @override
  bool get hasNext => _hasNext;

  @override
  Seq<A> next() {
    if (!hasNext) return RibsIterator.empty<Seq<A>>().next();

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
