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

import 'package:ribs_core/ribs_core.dart';

mixin RSet<A> on RIterable<A> {
  static RSet<A> empty<A>() => ISet.empty<A>();

  static RSet<A> from<A>(RIterableOnce<A> xs) => ISet.from(xs);

  static RSet<A> of<A>(Iterable<A> xs) =>
      RSet.from(RIterator.fromDart(xs.iterator));

  bool contains(A elem);
}
