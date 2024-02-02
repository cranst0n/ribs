import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

Array<A> arr<A>(List<A?> l) => Array._(List.of(l));

// A fixed sized array that can potentially contain null values. This was born
// out of not wanting to fight the type checker at every corner when porting
// Vector. It's proved useful in that regard but beware, here be dragons...
//
// TODO: add methods from IterableOnce
final class Array<A> {
  final List<A?> _list;

  Array._(this._list);

  static ArrayBuilder<A> builder<A>() => ArrayBuilder();

  static Array<A> empty<A>() => Array.ofDim(0);

  static Array<A> fill<A>(int len, A? elem) => Array._(List.filled(len, elem));

  static Array<A> from<A>(RIterableOnce<A?> elems) =>
      fromDart(elems.toList(growable: false));

  static Array<A> fromDart<A>(Iterable<A?> elems) {
    return Array._(elems.toList(growable: false));
  }

  static Array<A> ofDim<A>(int len) => Array._(List.filled(len, null));

  static Array<int> range(int start, int end, [int step = 1]) {
    if (step == 0) throw ArgumentError('zero step');

    final array = Array.ofDim<int>(Range.elementCount(start, end, step));

    var n = 0;
    var i = start;
    while (step < 0 ? end < i : i < end) {
      array[n] = i;
      i += step;
      n += 1;
    }

    return array;
  }

  static Array<A> tabulate<A>(int n, Function1<int, A?> f) =>
      Array._(List.generate(n, f));

  A? operator [](int idx) => _list[idx];

  void operator []=(int index, A? value) => _list[index] = value;

  Array<A> clone() => copyOf(this, length);

  Array<B> collect<B>(Function1<A, Option<B>> f) {
    final b = ArrayBuilder<B>();

    var i = 0;
    while (i < _list.length) {
      f(_list[i] as A).foreach(b.addOne);
      i += 1;
    }

    return b.result();
  }

  void filled(A? elem) => _list.fillRange(0, length, elem);

  void foreach<U>(Function1<A?, U> f) => _list.forEach(f);

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  RIterator<A?> get iterator => RIterator.fromDart(_list.iterator);

  int get length => _list.length;

  Array<B> map<B>(covariant Function1<A, B> f) =>
      Array.tabulate(length, (idx) => f(this[idx] as A));

  bool get nonEmpty => _list.isNotEmpty;

  Array<A> slice(int from, int until) {
    final lo = max(from, 0);
    final hi = min(until, length);

    if (hi > lo) {
      return copyOfRange(this, lo, hi);
    } else {
      return Array.empty();
    }
  }

  Array<A> update(int idx, A? value) {
    this[idx] = value;
    return this;
  }

  List<A?> toList() => List.of(_list);

  static void arraycopy<A>(
    Array<A> src,
    int srcPos,
    Array<A> dest,
    int destPos,
    int length,
  ) =>
      dest._list.setRange(
        destPos,
        destPos + length,
        src._list.getRange(srcPos, srcPos + length),
      );

  static Array<A> copyOf<A>(Array<A> original, int newLength) {
    final dest = Array.ofDim<A>(newLength);
    arraycopy(original, 0, dest, 0, min(original.length, newLength));
    return dest;
  }

  static Array<A> copyOfRange<A>(Array<A> original, int from, int to) =>
      Array.fromDart(original._list.getRange(from, to));

  static bool equals<A>(Array<A> a, Array<A> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;

    for (int idx = 0; idx < a.length; idx++) {
      if (a[idx] != b[idx]) return false;
    }

    return true;
  }
}

final class ArrayBuilder<A> {
  int capacity = 0;
  int size = 0;
  Array<A>? _elems;

  ArrayBuilder<A> addAll(RIterableOnce<A> xs) {
    final k = xs.knownSize;

    if (k > 0) _ensureSize(size + k);

    final it = xs.iterator;
    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  ArrayBuilder<A> addArray(Array<A> xs, {int offset = 0, int? length}) {
    final len = length ?? xs.length;

    _ensureSize(size + len);
    Array.arraycopy(xs, offset, _elems!, size, len);
    size += len;

    return this;
  }

  ArrayBuilder<A> addOne(A? elem) {
    _ensureSize(size + 1);
    _elems![size] = elem;
    size += 1;
    return this;
  }

  void clear() {
    size = 0;
    if (_elems != null) _elems!.filled(null);
  }

  int get length => size;

  Array<A> result() {
    if (capacity != 0 && capacity == size) {
      capacity = 0;
      final res = _elems!;
      _elems = null;
      return res;
    } else {
      return _mkArray(size);
    }
  }

  void _ensureSize(int size) {
    final newLen = max(capacity, size);
    if (newLen > capacity) _resize(newLen);
  }

  Array<A> _mkArray(int size) {
    if (_elems == null) {
      return Array.ofDim(size);
    } else if (capacity == size && capacity > 0) {
      return _elems!;
    } else {
      return Array.copyOf(_elems!, size);
    }
  }

  void _resize(int size) {
    _elems = _mkArray(size);
    capacity = size;
  }
}
