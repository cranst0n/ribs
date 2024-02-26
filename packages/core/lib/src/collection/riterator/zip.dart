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

final class _ZipIterator<A, B> extends RIterator<(A, B)> {
  final RIterator<A> self;
  final RIterableOnce<B> that;

  final RIterator<B> thatIterator;

  _ZipIterator(this.self, this.that) : thatIterator = that.iterator;

  @override
  bool get hasNext => self.hasNext && thatIterator.hasNext;

  @override
  int get knownSize => min(self.knownSize, that.knownSize);

  @override
  (A, B) next() => (self.next(), thatIterator.next());
}
