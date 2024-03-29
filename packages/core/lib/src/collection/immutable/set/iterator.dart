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

part of '../iset.dart';

class _SetNIterator<A> extends RIterator<A> {
  final int n;
  final Function1<int, A> apply;

  int _current = 0;
  int _remainder;

  _SetNIterator(this.n, this.apply) : _remainder = n;

  @override
  RIterator<A> drop(int n) {
    if (n > 0) {
      _current += n;
      _remainder = max(0, _remainder - n);
    }

    return this;
  }

  @override
  bool get hasNext => _remainder > 0;

  @override
  int get knownSize => _remainder;

  @override
  A next() {
    if (hasNext) {
      final r = apply(_current);
      _current += 1;
      _remainder -= 1;
      return r;
    } else {
      noSuchElement();
    }
  }
}
