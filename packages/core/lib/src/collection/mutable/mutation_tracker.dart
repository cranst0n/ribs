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

/// An [RIterator] wrapper that detects concurrent modification.
///
/// On each call to [hasNext], compares the current mutation count (obtained
/// via [mutationCount]) against [expectedCount]. If they differ — meaning the
/// underlying collection was mutated since the iterator was created — a
/// [StateError] is thrown. Used internally by [ListBuffer].
final class MutationTrackerIterator<A> extends RIterator<A> {
  final RIterator<A> underlying;

  /// The mutation count at the time this iterator was created.
  final int expectedCount;

  /// A callback that returns the current mutation count of the collection.
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
