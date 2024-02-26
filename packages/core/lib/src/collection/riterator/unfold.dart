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

final class _UnfoldIterator<A, S> extends RIterator<A> {
  final Function1<S, Option<(A, S)>> f;

  late S _state;
  Option<(A, S)>? _nextResult;

  _UnfoldIterator(S init, this.f) : _state = init;

  @override
  bool get hasNext {
    _nextResult ??= f(_state);
    return _nextResult?.isDefined ?? false;
  }

  @override
  A next() {
    if (hasNext) {
      final (value, newState) =
          _nextResult!.getOrElse(() => throw 'unreachable');
      _state = newState;
      _nextResult = null;
      return value;
    } else {
      noSuchElement();
    }
  }
}
