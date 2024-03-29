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

part of '../riterator.dart';

final class _ZipAllIterator<A, B> extends RIterator<(A, B)> {
  final RIterator<A> self;
  final RIterableOnce<B> that;

  final A thisElem;
  final B thatElem;

  final RIterator<B> thatIterator;

  _ZipAllIterator(this.self, this.that, this.thisElem, this.thatElem)
      : thatIterator = that.iterator;

  @override
  bool get hasNext => self.hasNext || thatIterator.hasNext;

  @override
  int get knownSize {
    final thisSize = self.knownSize;
    final thatSize = thatIterator.knownSize;

    if (thisSize < 0 || thatSize < 0) {
      return -1;
    } else {
      return max(thisSize, thatSize);
    }
  }

  @override
  (A, B) next() {
    final next1 = self.hasNext;
    final next2 = thatIterator.hasNext;

    if (next1 || next2) {
      return (
        next1 ? self.next() : thisElem,
        next2 ? thatIterator.next() : thatElem,
      );
    } else {
      noSuchElement();
    }
  }
}
