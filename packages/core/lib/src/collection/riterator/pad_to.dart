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

final class _PadToIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final int len;
  final A elem;

  var _i = 0;

  _PadToIterator(this.self, this.len, this.elem);

  @override
  bool get hasNext => self.hasNext || _i < len;

  @override
  int get knownSize {
    final thisSize = self.knownSize;
    return thisSize < 0 ? -1 : max(thisSize, len - _i);
  }

  @override
  A next() {
    final A b;

    if (self.hasNext) {
      b = self.next();
    } else if (_i < len) {
      b = elem;
    } else {
      b = RIterator.empty<A>().next();
    }

    _i += 1;
    return b;
  }
}
