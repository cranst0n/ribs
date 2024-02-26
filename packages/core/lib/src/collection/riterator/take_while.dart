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

final class _TakeWhileIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final Function1<A, bool> p;

  late A hd;
  bool hdDefined = false;
  late RIterator<A> tailIt = self;

  _TakeWhileIterator(this.self, this.p);

  @override
  bool get hasNext {
    if (hdDefined) return true;
    if (!tailIt.hasNext) return false;

    hd = tailIt.next();

    if (p(hd)) {
      hdDefined = true;
    } else {
      tailIt = RIterator.empty();
    }

    return hdDefined;
  }

  @override
  A next() {
    if (hasNext) {
      hdDefined = false;
      return hd;
    } else {
      noSuchElement();
    }
  }
}
