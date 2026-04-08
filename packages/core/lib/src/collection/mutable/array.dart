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

import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// Creates an [Array] from a Dart [List].
///
/// The resulting array has the same length as [l] and may contain `null`
/// values.
Array<A> arr<A>(List<A?> l) => Array._(List.of(l));

/// A fixed-size, nullable array used as a low-level building block.
///
/// Unlike Dart's `List`, [Array] deliberately allows `null` values regardless
/// of the element type [A]. This makes it straightforward to port algorithms
/// that treat unused slots as `null` (e.g. the [IVector] trie). Prefer
/// higher-level collections for application code — here be dragons.
///
/// Construct with [Array.ofDim], [Array.fill], [Array.from], [Array.fromDart],
/// [Array.range], or [Array.tabulate]. For incremental construction use
/// [Array.builder].
final class Array<A> {
  final List<A?> _list;

  Array._(this._list);

  /// Returns a mutable builder for incrementally constructing an [Array].
  static ArrayBuilder<A> builder<A>() => ArrayBuilder();

  /// Returns an empty [Array] of length zero.
  static Array<A> empty<A>() => Array.ofDim(0);

  /// Returns an [Array] of length [len] where every slot holds [elem].
  static Array<A> fill<A>(int len, A? elem) => Array._(List.filled(len, elem));

  /// Creates an [Array] from a [RIterableOnce].
  static Array<A> from<A>(RIterableOnce<A?> elems) => fromDart(elems.toList(growable: false));

  /// Creates an [Array] from a Dart [Iterable].
  static Array<A> fromDart<A>(Iterable<A?> elems) {
    return Array._(elems.toList(growable: false));
  }

  /// Returns an [Array] of length [len] with all slots initialised to `null`.
  static Array<A> ofDim<A>(int len) => Array._(List.filled(len, null));

  /// Returns an [Array] containing the integers from [start] (inclusive) to
  /// [end] (exclusive), incremented by [step].
  ///
  /// Throws [ArgumentError] if [step] is zero.
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

  /// Returns an [Array] of length [n] where element `i` is `f(i)`.
  static Array<A> tabulate<A>(int n, Function1<int, A?> f) => Array._(List.generate(n, f));

  /// Returns the element at [idx], which may be `null`.
  A? operator [](int idx) => _list[idx];

  /// Sets the element at [index] to [value].
  void operator []=(int index, A? value) => _list[index] = value;

  /// Returns a copy of this array with the same length.
  Array<A> clone() => copyOf(this, length);

  /// Returns a new array containing only the elements for which [f] returns
  /// [Some], in their original order.
  Array<B> collect<B>(Function1<A, Option<B>> f) {
    final b = ArrayBuilder<B>();

    var i = 0;
    while (i < _list.length) {
      f(_list[i] as A).foreach(b.addOne);
      i += 1;
    }

    return b.result();
  }

  /// Fills every slot of this array with [elem].
  void filled(A? elem) => _list.fillRange(0, length, elem);

  /// Applies [f] to each element in order.
  void foreach<U>(Function1<A?, U> f) => _list.forEach(f);

  /// Whether this array has no elements.
  bool get isEmpty => _list.isEmpty;

  /// Whether this array has at least one element.
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns an iterator over all elements, including `null` slots.
  RIterator<A?> get iterator => RIterator.fromDart(_list.iterator);

  /// The number of elements in this array.
  int get length => _list.length;

  /// Returns a new array produced by applying [f] to each element.
  Array<B> map<B>(Function1<A, B> f) => Array.tabulate(length, (idx) => f(this[idx] as A));

  /// Whether this array has at least one element.
  bool get nonEmpty => _list.isNotEmpty;

  /// Returns a sub-array from index [from] (inclusive) to [until] (exclusive).
  ///
  /// Out-of-bound indices are clamped to `[0, length]`.
  Array<A> slice(int from, int until) {
    final lo = max(from, 0);
    final hi = min(until, length);

    if (hi > lo) {
      return copyOfRange(this, lo, hi);
    } else {
      return Array.empty();
    }
  }

  /// Sets the element at [idx] to [value] and returns `this`.
  Array<A> update(int idx, A? value) {
    this[idx] = value;
    return this;
  }

  /// Returns a copy of the underlying list, preserving `null` slots.
  List<A?> toList() => List.of(_list);

  /// Copies [length] elements from [src] starting at [srcPos] into [dest]
  /// starting at [destPos].
  static void arraycopy<A>(
    Array<A> src,
    int srcPos,
    Array<A> dest,
    int destPos,
    int length,
  ) => dest._list.setRange(
    destPos,
    destPos + length,
    src._list.getRange(srcPos, srcPos + length),
  );

  /// Returns a new array of length [newLength] containing the elements of
  /// [original], truncating or padding with `null` as needed.
  static Array<A> copyOf<A>(Array<A> original, int newLength) {
    final dest = Array.ofDim<A>(newLength);
    arraycopy(original, 0, dest, 0, min(original.length, newLength));
    return dest;
  }

  /// Returns a new array containing elements of [original] in the range
  /// `[from, to)`.
  static Array<A> copyOfRange<A>(Array<A> original, int from, int to) =>
      Array.fromDart(original._list.getRange(from, to));

  /// Returns `true` if [a] and [b] have the same length and equal elements at
  /// every index.
  static bool equals<A>(Array<A> a, Array<A> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;

    for (int idx = 0; idx < a.length; idx++) {
      if (a[idx] != b[idx]) return false;
    }

    return true;
  }
}

/// Incrementally builds an [Array] by appending elements one at a time.
///
/// The internal buffer grows automatically as elements are added. Call
/// [result] to obtain the final fixed-size [Array].
final class ArrayBuilder<A> {
  int capacity = 0;
  int size = 0;
  Array<A>? _elems;

  /// Appends all elements of [xs] to this builder.
  ArrayBuilder<A> addAll(RIterableOnce<A> xs) {
    final k = xs.knownSize;

    if (k > 0) _ensureSize(size + k);

    final it = xs.iterator;
    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  /// Appends [length] elements from [xs] starting at [offset].
  ArrayBuilder<A> addArray(Array<A> xs, {int offset = 0, int? length}) {
    final len = length ?? xs.length;

    _ensureSize(size + len);
    Array.arraycopy(xs, offset, _elems!, size, len);
    size += len;

    return this;
  }

  /// Appends a single element [elem] to this builder.
  ArrayBuilder<A> addOne(A? elem) {
    _ensureSize(size + 1);
    _elems![size] = elem;
    size += 1;
    return this;
  }

  /// Resets this builder to an empty state.
  void clear() {
    size = 0;
    if (_elems != null) _elems!.filled(null);
  }

  /// The number of elements added so far.
  int get length => size;

  /// Returns a fixed-size [Array] containing all added elements.
  ///
  /// May return the internal buffer directly when it is exactly full, avoiding
  /// an extra copy.
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
