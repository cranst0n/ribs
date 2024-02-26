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

final class _CollectIterator<A, B> extends RIterator<B> {
  final RIterator<A> self;
  final Function1<A, Option<B>> f;

  B? _hd;
  int _status = 0; // Seek = 0; Found = 1; Empty = -1

  _CollectIterator(this.self, this.f);

  @override
  bool get hasNext {
    while (_status == 0) {
      if (self.hasNext) {
        final x = self.next();
        final v = f(x);

        v.foreach((v) {
          _hd = v;
          _status = 1;
        });
      } else {
        _status = -1;
      }
    }

    return _status == 1;
  }

  @override
  B next() {
    if (hasNext) {
      _status = 0;
      return _hd!;
    } else {
      noSuchElement();
    }
  }
}
