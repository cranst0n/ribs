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

final class _SliceIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final int start;
  final int limit;

  final bool _unbounded;
  int _remaining;
  int _dropping;

  _SliceIterator(this.self, this.start, this.limit)
      : _unbounded = limit < 0,
        _remaining = limit,
        _dropping = start;

  @override
  bool get hasNext {
    _skip();
    return _remaining != 0 && self.hasNext;
  }

  @override
  A next() {
    _skip();

    if (_remaining > 0) {
      _remaining -= 1;
      return self.next();
    } else if (_unbounded) {
      return self.next();
    } else {
      noSuchElement();
    }
  }

  @override
  RIterator<A> sliceIterator(int from, int until) {
    final lo = max(from, 0);
    final adjustedBound = _unbounded ? -1 : max(0, _remaining - lo);

    final int rest;

    if (until < 0) {
      rest = adjustedBound; // respect current bound, if any
    } else if (until <= lo) {
      rest = 0; // empty
    } else if (_unbounded) {
      rest = until - lo; // now finite
    } else {
      rest = min(adjustedBound, until - lo); // keep lesser bound
    }

    if (rest == 0) {
      return RIterator.empty();
    } else {
      final sum = _dropping + lo;
      _dropping = sum < 0 ? Integer.MaxValue : sum;
      _remaining = rest;
      return this;
    }
  }

  void _skip() {
    while (_dropping > 0) {
      if (self.hasNext) {
        self.next();
        _dropping -= 1;
      } else {
        _dropping = 0;
      }
    }
  }
}
