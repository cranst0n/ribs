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

final class _DartIterator<A> extends RIterator<A> {
  final Iterator<A> self;

  bool _hasNext = false;
  dynamic _nextElem;

  _DartIterator(this.self) {
    _hasNext = self.moveNext();
    _nextElem = hasNext ? self.current : null;
  }

  @override
  bool get hasNext => _hasNext;

  @override
  A next() {
    if (!hasNext) noSuchElement();

    final result = _nextElem;

    _hasNext = self.moveNext();
    if (_hasNext) _nextElem = self.current;

    return result as A;
  }
}
