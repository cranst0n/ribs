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

final class _PatchIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final int from;
  final RIterator<A> patchElems;
  final int replaced;

  RIterator<A> _origElems;

  // > 0  => that many more elems from `origElems` before switching to `patchElems`
  //   0  => need to drop elems from `origElems` and start using `patchElems`
  //  -1  => have dropped elems from `origElems`, will be using `patchElems` until it's empty
  //         and then using what's left of `origElems` after the drop
  int _state;

  _PatchIterator(this.self, this.from, this.patchElems, this.replaced)
      : _origElems = self,
        _state = from > 0 ? from : 0;

  @override
  bool get hasNext {
    _switchToPathIfNeeded();
    return _origElems.hasNext || patchElems.hasNext;
  }

  @override
  A next() {
    _switchToPathIfNeeded();

    if (_state < 0) {
      if (patchElems.hasNext) {
        return patchElems.next();
      } else {
        return _origElems.next();
      }
    } else {
      if (_origElems.hasNext) {
        _state -= 1;
        return _origElems.next();
      } else {
        _state = -1;
        return patchElems.next();
      }
    }
  }

  void _switchToPathIfNeeded() {
    if (_state == 0) {
      _origElems = _origElems.drop(replaced);
      _state = -1;
    }
  }
}
