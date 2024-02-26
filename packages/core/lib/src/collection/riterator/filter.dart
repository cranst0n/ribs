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

final class _FilterIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final Function1<A, bool> p;
  final bool isFlipped;

  late A hd;
  bool _hdDefined = false;

  _FilterIterator(this.self, this.p, this.isFlipped);

  @override
  bool get hasNext {
    if (_hdDefined) return true;
    if (!self.hasNext) return false;

    hd = self.next();

    while (p(hd) == isFlipped) {
      if (!self.hasNext) return false;
      hd = self.next();
    }

    _hdDefined = true;
    return true;
  }

  @override
  A next() {
    if (hasNext) {
      _hdDefined = false;
      return hd;
    } else {
      noSuchElement();
    }
  }
}
