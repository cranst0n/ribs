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

/// A mutable builder for constructing [ISet] instances efficiently.
///
/// Uses a small-set representation for up to four elements, then switches to
/// an [IHashSetBuilder] automatically. Obtain via [ISet.builder].
final class ISetBuilder<A> {
  ISet<A> _elems = ISet.empty<A>();
  var _switchedToHashSetBuilder = false;
  late final _hashSetBuilder = IHashSetBuilder<A>();

  /// Adds all elements from [elems] to this builder and returns `this`.
  ISetBuilder<A> addAll(RIterableOnce<A> elems) {
    final it = elems.iterator;

    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  /// Adds a single element [elem] to this builder and returns `this`.
  ///
  /// Duplicate elements are silently ignored.
  ISetBuilder<A> addOne(A elem) {
    if (_switchedToHashSetBuilder) {
      _hashSetBuilder.addOne(elem);
    } else if (_elems.size < 4) {
      _elems = _elems + elem;
    } else {
      // assert(elems.size == 4)
      if (!_elems.contains(elem)) {
        _switchedToHashSetBuilder = true;
        _hashSetBuilder.addAll(_elems);
        _hashSetBuilder.addOne(elem);
      }
    }

    return this;
  }

  /// Resets this builder to an empty state so it can be reused.
  void clear() {
    _elems = ISet.empty();
    _hashSetBuilder.clear();
    _switchedToHashSetBuilder = false;
  }

  /// Returns the [ISet] containing all elements added so far.
  ISet<A> result() {
    if (_switchedToHashSetBuilder) {
      return _hashSetBuilder.result();
    } else {
      return _elems;
    }
  }
}
