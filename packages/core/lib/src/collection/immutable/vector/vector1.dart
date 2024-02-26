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

part of '../ivector.dart';

final class _Vector1<A> extends _VectorImpl<A> {
  _Vector1(super._prefix) : super();

  @override
  A operator [](int idx) {
    if (0 <= idx && idx < _prefix1.length) {
      return _prefix1[idx] as A;
    } else {
      throw _rngErr(idx);
    }
  }

  @override
  IVector<A> appended(A elem) {
    final len1 = _prefix1.length;
    if (len1 < _WIDTH) {
      return _Vector1(_copyAppend1(_prefix1, elem));
    } else {
      return _Vector2(_prefix1, _WIDTH, _empty2, _wrap1(elem), _WIDTH + 1);
    }
  }

  @override
  IVector<A> init() =>
      _prefix1.length == 1 ? _Vector0() : _Vector1(_copyInit(_prefix1));

  @override
  IVector<B> map<B>(Function1<A, B> f) => _Vector1(_mapElems1(_prefix1, f));

  @override
  IVector<A> prepended(A elem) {
    final len1 = _prefix1.length;
    if (len1 < _WIDTH) {
      return _Vector1(_copyPrepend1(elem, _prefix1));
    } else {
      return _Vector2(_wrap1(elem), 1, _empty2, _prefix1, len1 + 1);
    }
  }

  @override
  IVector<A> tail() =>
      _prefix1.length == 1 ? _Vector0() : _Vector1(_copyTail(_prefix1));

  @override
  IVector<A> updated(int index, A elem) {
    if (0 <= index && index < _prefix1.length) {
      return _Vector1(_copyUpdate1(_prefix1, index, elem));
    } else {
      throw _rngErr(index);
    }
  }

  @override
  IVector<A> _slice0(int lo, int hi) =>
      _Vector1(Array.copyOfRange(_prefix1, lo, hi));

  @override
  int get _vectorSliceCount => 1;

  @override
  Array<dynamic> _vectorSlice(int idx) => _prefix1;
}
