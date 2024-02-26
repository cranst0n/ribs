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

final class _MapIterator<A, B> extends RIterator<B> {
  final RIterator<A> self;
  final Function1<A, B> f;

  const _MapIterator(this.self, this.f);

  @override
  bool get hasNext => self.hasNext;

  @override
  B next() => f(self.next());
}
