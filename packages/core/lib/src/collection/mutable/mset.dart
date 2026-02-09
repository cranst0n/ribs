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

MSet<A> mset<A>(Iterable<A> as) => MSet.of(as);

mixin MSet<A> on RIterable<A>, RSet<A> {
  static MSet<A> empty<A>() => MHashSet();

  static MSet<A> from<A>(RIterableOnce<A> xs) => MHashSet.from(xs);

  static MSet<A> of<A>(Iterable<A> xs) => from(RIterator.fromDart(xs.iterator));

  /// Adds element [a].
  bool operator +(A a) => add(a);

  /// Removes element [a].
  bool operator -(A a) => remove(a);

  bool add(A elem);

  @override
  MSet<A> concat(RIterableOnce<A> suffix);

  MSet<A> diff(MSet<A> that) => foldLeft(
    MSet.empty<A>(),
    (result, elem) =>
        that.contains(elem) ? result : result
          ..add(elem),
  );

  bool remove(A elem);

  bool subsetOf(MSet<A> that) => forall(that.contains);

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
