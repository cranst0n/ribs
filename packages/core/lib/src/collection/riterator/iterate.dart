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

final class _IterateIterator<A> extends RIterator<A> {
  final A start;
  final Function1<A, A> f;

  bool _first = true;
  A _acc;

  _IterateIterator(this.start, this.f) : _acc = start;

  @override
  bool get hasNext => true;

  @override
  A next() {
    if (_first) {
      _first = false;
    } else {
      _acc = f(_acc);
    }

    return _acc;
  }
}
