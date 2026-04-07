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
import 'package:ribs_core/src/collection/mutable/hash_set.dart';

/// Creates an [MSet] from a Dart [Iterable].
///
/// ```dart
/// final s = mset([1, 2, 3]);
/// ```
MSet<A> mset<A>(Iterable<A> as) => MSet.of(as);

/// A mutable set.
///
/// Backed by [MHashSet] with amortized O(1) [add], [contains], and [remove].
/// Construct with [MSet.empty], [MSet.from], or via [mset].
///
/// ```dart
/// final s = mset([1, 2]);
/// s + 3; // true (added)
/// s - 1; // true (removed)
/// s.contains(2); // true
/// ```
mixin MSet<A> on RIterable<A>, RSet<A> {
  /// Returns an empty [MSet].
  static MSet<A> empty<A>() => MHashSet();

  /// Creates an [MSet] from a [RIterableOnce].
  static MSet<A> from<A>(RIterableOnce<A> xs) => MHashSet.from(xs);

  /// Creates an [MSet] from a Dart [Iterable].
  static MSet<A> of<A>(Iterable<A> xs) => from(RIterator.fromDart(xs.iterator));

  /// Adds element [a].
  bool operator +(A a) => add(a);

  /// Removes element [a].
  bool operator -(A a) => remove(a);

  /// Adds [elem] and returns `true` if the set was modified.
  bool add(A elem);

  @override
  MSet<A> concat(RIterableOnce<A> suffix);

  /// Returns a new set with all elements from this set that are not in [that].
  MSet<A> diff(MSet<A> that) => foldLeft(
    MSet.empty<A>(),
    (result, elem) => that.contains(elem) ? result : (result..add(elem)),
  );

  /// Removes [elem] and returns `true` if the set was modified.
  bool remove(A elem);

  /// Returns `true` if every element of this set is in [that].
  bool subsetOf(MSet<A> that) => forall(that.contains);

  /// Returns a new set containing all elements from both this set and [that].
  MSet<A> union(MSet<A> that) => concat(that);

  @override
  int get hashCode => MurmurHash3.setHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is MSet<A>) {
      return size == other.size && subsetOf(other);
    } else {
      return super == other;
    }
  }
}
