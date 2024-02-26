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

final class _TabulateIterator<A> extends RIterator<A> {
  final int len;
  final Function1<int, A> f;
  var _i = 0;

  _TabulateIterator(this.len, this.f);

  @override
  bool get hasNext => _i < len;

  @override
  int get knownSize => max(len - _i, 0);

  @override
  A next() {
    if (_i < len) {
      final elem = f(_i);
      _i += 1;
      return elem;
    } else {
      noSuchElement();
    }
  }
}
