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

class _Set3<A> with RIterableOnce<A>, RIterable<A>, RSet<A>, ISet<A> {
  final A elem1;
  final A elem2;
  final A elem3;

  const _Set3(this.elem1, this.elem2, this.elem3);

  @override
  bool contains(A elem) => elem == elem1 || elem == elem2 || elem == elem3;

  @override
  ISet<A> excl(A elem) {
    if (elem == elem1) {
      return _Set2(elem2, elem3);
    } else if (elem == elem2) {
      return _Set2(elem1, elem3);
    } else if (elem == elem3) {
      return _Set2(elem1, elem2);
    } else {
      return this;
    }
  }

  @override
  bool exists(Function1<A, bool> p) => p(elem1) || p(elem2) || p(elem3);

  @override
  ISet<A> filter(Function1<A, bool> p) {
    A? r1;
    A? r2;
    int n = 0;

    if (p(elem1)) {
      r1 = elem1;
      n += 1;
    }

    if (p(elem2)) {
      n == 0 ? r1 = elem2 : r2 = elem2;
      n += 1;
    }

    if (p(elem3)) {
      n == 0 ? r1 = elem2 : r2 = elem3;
      n += 1;
    }

    return switch (n) {
      0 => _EmptySet<A>(),
      1 => _Set1(r1 as A),
      2 => _Set2(r1 as A, r2 as A),
      _ => this,
    };
  }

  @override
  ISet<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  Option<A> find(Function1<A, bool> p) {
    if (p(elem1)) {
      return Some(elem1);
    } else if (p(elem2)) {
      return Some(elem2);
    } else if (p(elem3)) {
      return Some(elem3);
    } else {
      return none();
    }
  }

  @override
  bool forall(Function1<A, bool> p) => p(elem1) && p(elem2) && p(elem3);

  @override
  A get head => elem1;

  @override
  ISet<A> incl(A elem) {
    if (contains(elem)) {
      return this;
    } else {
      return _Set4(elem1, elem2, elem3, elem);
    }
  }

  @override
  bool get isEmpty => false;

  @override
  RIterator<A> get iterator => _SetNIterator(3, _getElem);

  @override
  void foreach<U>(Function1<A, U> f) {
    f(elem1);
    f(elem2);
    f(elem3);
  }

  @override
  int get knownSize => 3;

  @override
  int get size => 3;

  @override
  ISet<A> tail() => _Set2(elem2, elem3);

  A _getElem(int n) => switch (n) {
        0 => elem1,
        1 => elem2,
        2 => elem3,
        _ => throw IndexError.withLength(n, size),
      };
}
