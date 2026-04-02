import 'dart:math';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

class ArrayDeque<A> with RIterableOnce<A>, RIterable<A>, RSeq<A>, IndexedSeq<A>, Buffer<A> {
  static const DefaultInitialSize = 16;
  static const _StableSize = 128;

  @protected
  Array<A> array;
  @protected
  int start;
  @protected
  int end;

  ArrayDeque([int size = DefaultInitialSize]) : this.internal(alloc(size), 0, 0);

  @protected
  ArrayDeque.internal(this.array, this.start, this.end);

  @protected
  static Array<T> alloc<T>(int len) {
    if (len <= 0) {
      return Array.ofDim(DefaultInitialSize);
    } else {
      // Use len + 1 to ensure array.length > len (ring buffer needs one spare slot)
      final nextPowerOf2 = pow(2, (log(len + 1) / ln2).ceil()).toInt();

      return Array.ofDim(max(nextPowerOf2, DefaultInitialSize));
    }
  }

  static ArrayDeque<A> from<A>(RIterableOnce<A> elems) {
    if (elems is ArrayDeque<A>) {
      return elems;
    } else {
      final s = elems.knownSize;

      if (s >= 0) {
        final array = alloc<A>(s);
        final actual = elems.iterator.copyToArray(array);

        if (actual != s) throw StateError('ArrayDeque: copied $actual of $s');

        return ArrayDeque.internal(array, 0, s);
      } else {
        return ArrayDeque<A>().addAll(elems);
      }
    }
  }

  static ArrayDeque<A> fromDart<A>(Iterable<A> elems) => from(RIterator.fromDart(elems.iterator));

  @override
  A operator [](int idx) {
    _requireBounds(idx);
    return _get(idx);
  }

  @override
  int get knownSize => length;

  @override
  ArrayDeque<A> addAll(RIterableOnce<A> elems) {
    final srcLength = elems.knownSize;

    if (srcLength > 0) {
      _ensureSize(srcLength + length);
      elems.iterator.foreach(_appendAssumingCapacity);
    } else {
      elems.iterator.foreach(addOne);
    }

    return this;
  }

  @override
  ArrayDeque<A> addOne(A elem) {
    _ensureSize(length + 1);
    return _appendAssumingCapacity(elem);
  }

  @override
  ArrayDeque<A> append(A elem) => from(super.append(elem));

  @override
  ArrayDeque<A> appendAll(RIterableOnce<A> elems) => from(super.appendAll(elems));

  @override
  ArrayDeque<A> appended(A elem) => from(super.appended(elem));

  @override
  ArrayDeque<A> appendedAll(RIterableOnce<A> suffix) => from(super.appendedAll(suffix));

  @override
  void clear() {
    while (nonEmpty) {
      _removeHeadAssumingNonEmpty();
    }
  }

  @override
  ArrayDeque<B> collect<B>(Function1<A, Option<B>> f) => from(super.collect(f));

  @override
  RIterator<ArrayDeque<A>> combinations(int n) => super.combinations(n).map(from);

  @override
  ArrayDeque<A> concat(covariant RIterableOnce<A> suffix) => from(super.concat(suffix));

  @override
  ArrayDeque<A> diff(RSeq<A> that) => from(super.diff(that));

  @override
  ArrayDeque<A> distinct() => from(super.distinct());

  @override
  ArrayDeque<A> distinctBy<B>(Function1<A, B> f) => from(super.distinctBy(f));

  @override
  ArrayDeque<A> drop(int n) => from(super.drop(n));

  @override
  ArrayDeque<A> dropInPlace(int n) => from(super.dropInPlace(n));

  @override
  ArrayDeque<A> dropRight(int n) => from(super.dropRight(n));

  @override
  ArrayDeque<A> dropRightInPlace(int n) => from(super.dropRightInPlace(n));

  @override
  ArrayDeque<A> dropWhile(Function1<A, bool> p) => from(super.dropWhile(p));

  @override
  ArrayDeque<A> dropWhileInPlace(Function1<A, bool> p) => from(super.dropWhileInPlace(p));

  @override
  ArrayDeque<A> filter(Function1<A, bool> p) {
    return from(super.filter(p));
  }

  @override
  ArrayDeque<A> filterNot(Function1<A, bool> p) => from(super.filterNot(p));

  @override
  ArrayDeque<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) => from(super.flatMap(f));

  @override
  IMap<K, ArrayDeque<A>> groupBy<K>(Function1<A, K> f) => super.groupBy(f).mapValues(from);

  @override
  RIterator<ArrayDeque<A>> grouped(int size) => super.grouped(size).map(from);

  @override
  IMap<K, ArrayDeque<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues(from);

  @override
  ArrayDeque<A> get init => from(super.init);

  @override
  RIterator<ArrayDeque<A>> get inits => super.inits.map(from);

  @override
  void insert(int idx, A elem) {
    _requireBounds(idx, length + 1);
    final n = length;

    if (idx == 0) {
      prepend(elem);
    } else if (idx == n) {
      addOne(elem);
    } else {
      final finalLength = n + 1;
      if (_mustGrow(finalLength)) {
        final array2 = ArrayDeque.alloc<A>(finalLength);
        _copySliceToArray(0, array2, 0, idx);
        array2[idx] = elem;
        _copySliceToArray(idx, array2, idx + 1, n);
        _reset(array2, 0, finalLength);
      } else if (n <= idx * 2) {
        var i = n - 1;
        while (i >= idx) {
          _set(i + 1, _get(i));
          i -= 1;
        }
        end = _end_plus(1);
        i += 1;
        _set(i, elem);
      } else {
        var i = 0;
        while (i < idx) {
          _set(i - 1, _get(i));
          i += 1;
        }
        start = _start_minus(1);
        _set(i, elem);
      }
    }
  }

  @override
  void insertAll(int idx, RIterableOnce<A> elems) {
    _requireBounds(idx, length + 1);
    final n = length;

    if (idx == 0) {
      prependAll(elems);
    } else if (idx == n) {
      addAll(elems);
    } else {
      final RIterator<A> it;
      final int srcLength;

      if (elems.knownSize >= 0) {
        it = elems.iterator;
        srcLength = elems.knownSize;
      } else {
        final indexed = IndexedSeq.from(elems);
        it = indexed.iterator;
        srcLength = indexed.size;
      }

      if (it.nonEmpty) {
        final finalLength = srcLength + n;

        // Either we resize right away or move prefix left or suffix right
        if (_mustGrow(finalLength)) {
          final array2 = ArrayDeque.alloc<A>(finalLength);
          _copySliceToArray(0, array2, 0, idx);

          final copied = it.copyToArray(array2, idx);
          assert(copied == srcLength);

          _copySliceToArray(idx, array2, idx + srcLength, n);
          _reset(array2, 0, finalLength);
        } else if (2 * idx >= n) {
          // Cheaper to shift the suffix right
          var i = n - 1;
          while (i >= idx) {
            _set(i + srcLength, _get(i));
            i -= 1;
          }
          end = _end_plus(srcLength);
          while (it.hasNext) {
            i += 1;
            _set(i, it.next());
          }
        } else {
          // Cheaper to shift prefix left
          var i = 0;
          while (i < idx) {
            _set(i - srcLength, _get(i));
            i += 1;
          }
          start = _start_minus(srcLength);
          while (it.hasNext) {
            _set(i, it.next());
            i += 1;
          }
        }
      }
    }
  }

  @override
  ArrayDeque<A> intersect(RSeq<A> that) => from(super.intersect(that));

  @override
  ArrayDeque<A> intersperse(A x) => from(super.intersperse(x));

  @override
  bool get isEmpty => start == end;

  @override
  RIterator<A> get iterator => _ArrayDequeIterator(this, 0, () => 0);

  @override
  int get length => _end_minus(start);

  @override
  ArrayDeque<A> padTo(int len, A elem) => from(super.padTo(len, elem));

  @override
  ArrayDeque<A> padToInPlace(int len, A elem) => from(super.padToInPlace(len, elem));

  @override
  (ArrayDeque<A>, ArrayDeque<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (from(a), from(b));
  }

  @override
  (ArrayDeque<A1>, ArrayDeque<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) {
    final (a, b) = super.partitionMap(f);
    return (from(a), from(b));
  }

  @override
  ArrayDeque<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      ArrayDeque.from(super.patch(from, other, replaced));

  @override
  ArrayDeque<A> patchInPlace(int from, RIterableOnce<A> patch, int replaced) {
    final replaced0 = min(max(replaced, 0), length);
    final i = min(max(from, 0), length);
    var j = 0;
    final iter = patch.iterator;

    while (iter.hasNext && j < replaced0 && i + j < length) {
      update(i + j, iter.next());
      j += 1;
    }

    if (iter.hasNext) {
      insertAll(i + j, iter);
    } else if (j < replaced0) {
      removeN(i + j, min(replaced0 - j, length - i - j));
    }

    return this;
  }

  @override
  ArrayDeque<A> prepend(A elem) {
    _ensureSize(length + 1);
    return _prependAssumingCapacity(elem);
  }

  @override
  ArrayDeque<A> prependAll(RIterableOnce<A> elems) {
    final it = elems.iterator;

    if (it.nonEmpty) {
      final n = length;

      final srcLength = elems.knownSize;

      if (srcLength < 0) {
        return prependAll(it.toIndexedSeq());
      } else if (_mustGrow(srcLength + n)) {
        final finalLength = srcLength + n;
        final array2 = ArrayDeque.alloc<A>(finalLength);

        final copied = it.copyToArray(array2);
        assert(copied == srcLength);

        _copySliceToArray(0, array2, srcLength, n);
        _reset(array2, 0, finalLength);
      } else {
        var i = 0;

        while (i < srcLength) {
          _set(i - srcLength, it.next());
          i += 1;
        }

        start = _start_minus(srcLength);
      }
    }

    return this;
  }

  @override
  A remove(int idx) {
    final elem = this[idx];
    removeN(idx, 1);
    return elem;
  }

  RSeq<A> removeAll(Function1<A, bool> p) {
    final elems = IVector.builder<A>();

    while (nonEmpty) {
      elems.addOne(_removeHeadAssumingNonEmpty());
    }

    return elems.result();
  }

  @override
  ArrayDeque<A> removeAt(int idx) => from(super.removeAt(idx));

  @override
  void removeN(int idx, int count) {
    if (count > 0) {
      _requireBounds(idx);

      final n = length;
      final removals = min(n - idx, count);
      final finalLength = n - removals;
      final suffixStart = idx + removals;

      // If we know we can resize after removing, do it right away using arrayCopy
      // Else, choose the shorter: either move the prefix (0 until idx) right OR the suffix (idx+removals until n) left
      if (_shouldShrink(finalLength)) {
        final array2 = ArrayDeque.alloc<A>(finalLength);
        _copySliceToArray(0, array2, 0, idx);
        _copySliceToArray(suffixStart, array2, idx, n);
        _reset(array2, 0, finalLength);
      } else if (2 * idx <= finalLength) {
        // Cheaper to move the prefix right
        var i = suffixStart - 1;

        while (i >= removals) {
          _set(i, _get(i - removals));
          i -= 1;
        }

        while (i >= 0) {
          _set(i, null);
          i -= 1;
        }

        start = _start_plus(removals);
      } else {
        // Cheaper to move the suffix left
        var i = idx;

        while (i < finalLength) {
          _set(i, _get(i + removals));
          i += 1;
        }

        while (i < n) {
          _set(i, null);
          i += 1;
        }

        end = _end_minus(removals);
      }
    } else if (count < 0) {
      throw ArgumentError("removing negative number of elements: $count");
    }
  }

  Option<A> removeFirst(Function1<A, bool> p, [int from = 0]) => indexWhere(p, from).map(remove);

  A removeHead({bool resizeInternalRepr = false}) {
    if (isEmpty) {
      throw UnsupportedError('ArrayDeque.removeHead: empty');
    } else {
      return _removeHeadAssumingNonEmpty();
    }
  }

  Option<A> removeHeadOption({bool resizeInternalRepr = false}) {
    if (isEmpty) {
      return const None();
    } else {
      return Some(_removeHeadAssumingNonEmpty());
    }
  }

  RSeq<A> removeHeadWhile(Function1<A, bool> p) {
    final elems = IVector.builder<A>();

    while (headOption.exists(p)) {
      elems.addOne(_removeHeadAssumingNonEmpty());
    }

    return elems.result();
  }

  A removeLast({bool resizeInternalRepr = false}) {
    if (isEmpty) {
      throw UnsupportedError('ArrayDeque.removeLast: empty');
    } else {
      return _removeLastAssumingNonEmpty();
    }
  }

  Option<A> removeLastOption({bool resizeInternalRepr = false}) {
    if (isEmpty) {
      return const None();
    } else {
      return Some(_removeLastAssumingNonEmpty());
    }
  }

  @override
  ArrayDeque<A> reverse() {
    final n = length;
    final arr = alloc<A>(n);
    var i = 0;

    while (i < n) {
      arr[i] = this[n - i - 1];
      i += 1;
    }

    return ArrayDeque.internal(arr, 0, n);
  }

  @override
  ArrayDeque<B> scan<B>(B z, Function2<B, A, B> op) => from(super.scan(z, op));

  @override
  ArrayDeque<B> scanLeft<B>(B z, Function2<B, A, B> op) => from(super.scanLeft(z, op));

  @override
  ArrayDeque<B> scanRight<B>(B z, Function2<A, B, B> op) => from(super.scanRight(z, op));

  @override
  ArrayDeque<A> slice(int from, int until) => ArrayDeque.from(super.slice(from, until));

  @override
  ArrayDeque<A> sliceInPlace(int start, int end) => from(super.sliceInPlace(start, end));

  @override
  RIterator<ArrayDeque<A>> sliding(int size, [int step = 1]) => super.sliding(size, step).map(from);

  @override
  ArrayDeque<A> sortBy<B>(Order<B> order, Function1<A, B> f) => from(super.sortBy(order, f));

  @override
  ArrayDeque<A> sorted(Order<A> order) => from(super.sorted(order));

  @override
  ArrayDeque<A> sortWith(Function2<A, A, bool> lt) => from(super.sortWith(lt));

  @override
  (ArrayDeque<A>, ArrayDeque<A>) span(Function1<A, bool> p) {
    final (a, b) = super.span(p);
    return (from(a), from(b));
  }

  @override
  ArrayDeque<A> subtractOne(A x) => from(super.subtractOne(x));

  @override
  ArrayDeque<A> get tail => from(super.tail);

  @override
  RIterator<ArrayDeque<A>> get tails => super.tails.map(from);

  @override
  ArrayDeque<A> take(int n) => from(super.take(n));

  @override
  ArrayDeque<A> takeInPlace(int n) => from(super.takeInPlace(n));

  @override
  ArrayDeque<A> takeRight(int n) => from(super.takeRight(n));

  @override
  ArrayDeque<A> takeRightInPlace(int n) => from(super.takeRightInPlace(n));

  @override
  ArrayDeque<A> takeWhile(Function1<A, bool> p) => from(super.takeWhile(p));

  @override
  ArrayDeque<A> takeWhileInPlace(Function1<A, bool> p) => from(super.takeWhileInPlace(p));

  @override
  ArrayDeque<A> tapEach<U>(Function1<A, U> f) => from(super.tapEach(f));

  @override
  Either<B, ArrayDeque<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) =>
      super.traverseEither(f).map(from);

  @override
  Option<ArrayDeque<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      super.traverseOption(f).map(from);

  void trimToSize() => _resize(length);

  void update(int idx, A elem) {
    _requireBounds(idx);
    _set(idx, elem);
  }

  @override
  ArrayDeque<A> updated(int index, A elem) => from(super.updated(index, elem));

  @override
  ArrayDeque<(A, B)> zip<B>(RIterableOnce<B> that) => from(super.zip(that));

  @override
  ArrayDeque<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      from(super.zipAll(that, thisElem, thatElem));

  @override
  ArrayDeque<(A, int)> zipWithIndex() => from(super.zipWithIndex());

  @pragma('vm:prefer-inline')
  A _get(int idx) => array[_start_plus(idx)]!;

  @pragma('vm:prefer-inline')
  void _set(int idx, A? elem) => array[_start_plus(idx)] = elem;

  void _requireBounds(int idx, [int? until]) {
    if (idx < 0 || idx >= (until ?? length)) {
      throw IndexError.withLength(idx, until ?? length);
    }
  }

  void _ensureSize(int hint) {
    if (hint > length && _mustGrow(hint)) _resize(hint);
  }

  @pragma('vm:prefer-inline')
  bool _mustGrow(int len) => len >= array.length;

  @pragma('vm:prefer-inline')
  bool _shouldShrink(int len) =>
      // To avoid allocation churn, only shrink when array is large
      // and less than 2/5 filled.
      array.length > _StableSize && array.length - len - (len >> 1) > len;

  @pragma('vm:prefer-inline')
  bool _canShrink(int len) => array.length > DefaultInitialSize && array.length - len > len;

  void _resize(int len) {
    if (_mustGrow(len) || _canShrink(len)) {
      final n = length;
      final array2 = _copySliceToArray(0, ArrayDeque.alloc(len), 0, n);
      _reset(array2, 0, n);
    }
  }

  void _reset(Array<A> array, int start, int end) {
    assert((array.length & (array.length - 1)) == 0, "Array.length must be power of 2");

    _requireBounds(start, array.length);
    _requireBounds(end, array.length);

    this.array = array;
    this.start = start;
    this.end = end;
  }

  @pragma('vm:prefer-inline')
  ArrayDeque<A> _appendAssumingCapacity(A elem) {
    array[end] = elem;
    end = _end_plus(1);
    return this;
  }

  @pragma('vm:prefer-inline')
  ArrayDeque<A> _prependAssumingCapacity(A elem) {
    start = _start_minus(1);
    array[start] = elem;

    return this;
  }

  A _removeHeadAssumingNonEmpty({bool resizeInternalRepr = false}) {
    final elem = array[start];
    array[start] = null;
    start = _start_plus(1);

    if (resizeInternalRepr) _resize(length);

    return elem!;
  }

  A _removeLastAssumingNonEmpty({bool resizeInternalRepr = false}) {
    end = _end_minus(1);
    final elem = array[end];
    array[end] = null;

    if (resizeInternalRepr) _resize(length);

    return elem!;
  }

  @pragma('vm:prefer-inline')
  int _start_plus(int idx) => (start + idx) & (array.length - 1);
  @pragma('vm:prefer-inline')
  int _start_minus(int idx) => (start - idx) & (array.length - 1);
  @pragma('vm:prefer-inline')
  int _end_plus(int idx) => (end + idx) & (array.length - 1);
  @pragma('vm:prefer-inline')
  int _end_minus(int idx) => (end - idx) & (array.length - 1);

  Array<A> _copySliceToArray(int srcStart, Array<A> dest, int destStart, int maxItems) {
    _requireBounds(destStart, dest.length + 1);

    final toCopy = min(maxItems, min(length - srcStart, dest.length - destStart));

    if (toCopy > 0) {
      _requireBounds(srcStart);
      final startIdx = _start_plus(srcStart);
      final block1 = min(toCopy, array.length - startIdx);

      Array.arraycopy(array, startIdx, dest, destStart, block1);

      final block2 = toCopy - block1;

      if (block2 > 0) {
        Array.arraycopy(array, 0, dest, destStart + block1, block2);
      }
    }

    return dest;
  }
}

final class _ArrayDequeIterator<A> extends RIterator<A> {
  final ArrayDeque<A> underlying;

  int current;
  int remaining;

  final int expectedCount;
  final Function0<int> mutationCount;

  _ArrayDequeIterator(
    this.underlying,
    this.expectedCount,
    this.mutationCount,
  ) : current = 0,
      remaining = underlying.length;

  @override
  bool get hasNext {
    if (mutationCount() != expectedCount) {
      throw StateError('mutation occurred during iteration');
    }

    return remaining > 0;
  }

  @override
  A next() {
    if (hasNext) {
      final r = underlying[current];
      current += 1;
      remaining -= 1;
      return r;
    } else {
      return noSuchElement();
    }
  }
}
