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

final class _DistinctByIterator<A, B> extends RIterator<A> {
  final RIterator<A> self;
  final Function1<A, B> f;

  final _traversedValues = MSet.empty<B>();
  bool _nextElementDefined = false;
  A? _nextElement;

  _DistinctByIterator(this.self, this.f);

  @override
  bool get hasNext {
    if (_nextElementDefined) {
      return true;
    } else {
      while (self.hasNext && !_nextElementDefined) {
        final a = self.next();

        if (_traversedValues.add(f(a))) {
          _nextElement = a;
          _nextElementDefined = true;
          return true;
        }
      }

      return false;
    }
  }

  @override
  A next() {
    if (hasNext) {
      _nextElementDefined = false;
      return _nextElement!;
    } else {
      noSuchElement();
    }
  }
}
