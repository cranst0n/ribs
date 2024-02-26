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

final class _ZipWithIndexIterator<A> extends RIterator<(A, int)> {
  final RIterator<A> self;
  int _i = 0;

  _ZipWithIndexIterator(this.self);

  @override
  bool get hasNext => self.hasNext;

  @override
  int get knownSize => self.knownSize;

  @override
  (A, int) next() {
    final res = (self.next(), _i);
    _i += 1;
    return res;
  }
}
