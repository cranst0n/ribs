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

final class _DropWhileIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final Function1<A, bool> p;

  // Magic value: -1 = hasn't dropped, 0 = found first, 1 = defer to parent iterator
  int _status = -1;
  A? _fst;

  _DropWhileIterator(this.self, this.p);

  @override
  bool get hasNext {
    if (_status == 1) {
      return self.hasNext;
    } else if (_status == 0) {
      return true;
    } else {
      while (self.hasNext) {
        final a = self.next();
        if (!p(a)) {
          _fst = a;
          _status = 0;
          return true;
        }
      }

      _status = 1;
      return false;
    }
  }

  @override
  A next() {
    if (hasNext) {
      if (_status == 1) {
        return self.next();
      } else {
        _status = 1;
        return _fst!;
      }
    } else {
      noSuchElement();
    }
  }
}
