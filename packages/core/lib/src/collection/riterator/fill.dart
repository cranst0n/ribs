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

final class _FillIterator<A> extends RIterator<A> {
  final int len;
  final A elem;
  var _i = 0;

  _FillIterator(this.len, this.elem);

  @override
  bool get hasNext => _i < len;

  @override
  int get knownSize => max(len, 0);

  @override
  A next() {
    if (_i < len) {
      _i += 1;
      return elem;
    } else {
      noSuchElement();
    }
  }
}
