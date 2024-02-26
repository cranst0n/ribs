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

final class _EmptySet<A> with RIterableOnce<A>, RIterable<A>, RSet<A>, ISet<A> {
  @override
  bool contains(A elem) => false;

  @override
  ISet<A> diff(ISet<A> that) => this;

  @override
  ISet<A> excl(A elem) => this;

  @override
  ISet<A> filter(Function1<A, bool> p) => this;

  @override
  ISet<A> filterNot(Function1<A, bool> p) => this;

  @override
  void foreach<U>(Function1<A, U> f) {}

  @override
  ISet<A> incl(A elem) => _Set1(elem);

  @override
  ISet<A> intersect(ISet<A> that) => this;

  @override
  bool get isEmpty => true;

  @override
  RIterator<A> get iterator => RIterator.empty();

  @override
  int get knownSize => 0;

  @override
  ISet<A> removedAll(RIterableOnce<A> that) => this;

  @override
  int get size => 0;

  @override
  bool subsetOf(ISet<A> that) => true;
}
