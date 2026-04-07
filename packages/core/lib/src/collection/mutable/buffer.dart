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

/// A mutable sequence that supports efficient in-place modification.
///
/// [Buffer] extends [RSeq] with operations that mutate the buffer directly
/// (in-place variants) as well as operations that return a new buffer. Concrete
/// implementations include [ListBuffer] and [ArrayDeque].
mixin Buffer<A> on RIterableOnce<A>, RIterable<A>, RSeq<A> {
  /// Appends [elem] and returns `this`.
  Buffer<A> addOne(A elem);

  /// Appends all [elems] and returns `this`.
  Buffer<A> addAll(RIterableOnce<A> elems);

  /// Alias for [addOne].
  Buffer<A> append(A elem) => addOne(elem);

  /// Alias for [addAll].
  Buffer<A> appendAll(RIterableOnce<A> elems) => addAll(elems);

  /// Removes all elements from this buffer.
  void clear();

  /// Removes the first [n] elements in place and returns `this`.
  Buffer<A> dropInPlace(int n) {
    removeN(0, _normalized(n));
    return this;
  }

  /// Removes the last [n] elements in place and returns `this`.
  Buffer<A> dropRightInPlace(int n) {
    final norm = _normalized(n);
    removeN(length - norm, norm);
    return this;
  }

  /// Removes leading elements satisfying [p] in place and returns `this`.
  Buffer<A> dropWhileInPlace(Function1<A, bool> p) {
    indexWhere((a) => !p(a)).fold(() => clear(), dropInPlace);
    return this;
  }

  /// Inserts [elem] at position [idx], shifting later elements right.
  void insert(int idx, A elem);

  /// Inserts all [elems] starting at position [idx].
  void insertAll(int idx, RIterableOnce<A> elems);

  /// Prepends [elem] and returns `this`.
  Buffer<A> prepend(A elem);

  /// Prepends all [elems] and returns `this`.
  Buffer<A> prependAll(RIterableOnce<A> elems) {
    insertAll(0, elems);
    return this;
  }

  /// Removes and returns the element at [idx].
  A remove(int idx);

  /// Removes [count] elements starting at [idx].
  void removeN(int idx, int count);

  /// Appends [elem] until [length] equals [len], then returns `this`.
  Buffer<A> padToInPlace(int len, A elem) {
    while (length < len) {
      addOne(elem);
    }

    return this;
  }

  /// Replaces [replaced] elements starting at [from] with [patch] in place.
  Buffer<A> patchInPlace(int from, RIterableOnce<A> patch, int replaced);

  /// Keeps only the elements in `[start, end)` in place and returns `this`.
  Buffer<A> sliceInPlace(int start, int end) => takeInPlace(end).dropInPlace(start);

  /// Removes the first occurrence of [x] and returns `this`.
  Buffer<A> subtractOne(A x) {
    indexOf(x).foreach(remove);
    return this;
  }

  /// Keeps only the first [n] elements in place and returns `this`.
  Buffer<A> takeInPlace(int n) {
    final norm = _normalized(n);
    removeN(norm, length - norm);
    return this;
  }

  /// Keeps only the last [n] elements in place and returns `this`.
  Buffer<A> takeRightInPlace(int n) {
    removeN(0, length - _normalized(n));
    return this;
  }

  /// Keeps only the leading elements satisfying [p] in place and returns `this`.
  Buffer<A> takeWhileInPlace(Function1<A, bool> p) =>
      indexWhere((a) => !p(a)).fold(() => this, takeInPlace);

  int _normalized(int n) => min(max(n, 0), length);
}
