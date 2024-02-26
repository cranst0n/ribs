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

import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/function.dart';

final class MutationTrackerIterator<A> extends RIterator<A> {
  final RIterator<A> underlying;
  final int expectedCount;
  final Function0<int> mutationCount;

  const MutationTrackerIterator(
    this.underlying,
    this.expectedCount,
    this.mutationCount,
  );

  @override
  bool get hasNext {
    if (mutationCount() != expectedCount) {
      throw StateError('mutation occurred during iteration');
    }

    return underlying.hasNext;
  }

  @override
  A next() => underlying.next();
}
