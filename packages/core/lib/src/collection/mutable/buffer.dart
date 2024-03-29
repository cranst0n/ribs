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

mixin Buffer<A> on RIterableOnce<A>, RIterable<A>, RSeq<A> {
  Buffer<A> addOne(A elem);

  Buffer<A> addAll(RIterableOnce<A> elems);

  Buffer<A> append(A elem) => addOne(elem);

  Buffer<A> appendAll(RIterableOnce<A> elems) => addAll(elems);

  void clear();

  Buffer<A> dropInPlace(int n) {
    removeN(n, _normalized(n));
    return this;
  }

  Buffer<A> dropRightInPlace(int n) {
    final norm = _normalized(n);
    removeN(length - norm, norm);
    return this;
  }

  Buffer<A> dropWhileInPlace(Function1<A, bool> p) {
    indexWhere((a) => !p(a)).fold(() => clear(), dropInPlace);
    return this;
  }

  void insert(int idx, A elem);

  void insertAll(int idx, RIterableOnce<A> elems);

  Buffer<A> prepend(A elem);

  Buffer<A> prependAll(RIterableOnce<A> elems) {
    insertAll(0, elems);
    return this;
  }

  A remove(int idx);

  void removeN(int idx, int count);

  Buffer<A> padToInPlace(int len, A elem) {
    while (length < len) {
      addOne(elem);
    }

    return this;
  }

  Buffer<A> patchInPlace(int from, RIterableOnce<A> patch, int replaced);

  Buffer<A> sliceInPlace(int start, int end) =>
      takeInPlace(end).dropInPlace(start);

  Buffer<A> subtractOne(A x) {
    indexOf(x).foreach(remove);
    return this;
  }

  Buffer<A> takeInPlace(int n) {
    final norm = _normalized(n);
    removeN(norm, length - norm);
    return this;
  }

  Buffer<A> takeRightInPlace(int n) {
    removeN(0, length - _normalized(n));
    return this;
  }

  Buffer<A> takeWhileInPlace(Function1<A, bool> p) =>
      indexWhere((a) => !p(a)).fold(() => this, takeInPlace);

  int _normalized(int n) => min(max(n, 0), length);
}
