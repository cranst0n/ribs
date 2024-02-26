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

final class _SingleIterator<A> extends RIterator<A> {
  final A a;
  bool _consumed = false;

  _SingleIterator(this.a);

  @override
  bool get hasNext => !_consumed;

  @override
  A next() {
    if (_consumed) {
      noSuchElement();
    } else {
      _consumed = true;
      return a;
    }
  }

  @override
  RIterator<A> sliceIterator(int from, int until) {
    if (_consumed || from > 0 || until == 0) {
      return RIterator.empty();
    } else {
      return this;
    }
  }
}
