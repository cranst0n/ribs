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

part of '../imap.dart';

/// A mutable builder for [IMap].
///
/// Uses compact inline representations ([_Map1] through [_Map4]) for up to
/// four entries and transparently promotes to an [IHashMapBuilder] once a
/// fifth distinct key is added.
final class IMapBuilder<K, V> {
  IMap<K, V> _elems = IMap.empty<K, V>();
  var _switchedToHashMapBuilder = false;
  late final _hashMapBuilder = IHashMapBuilder<K, V>();

  /// Adds all key-value pairs from [elems] to this builder.
  IMapBuilder<K, V> addAll(RIterableOnce<(K, V)> elems) {
    final it = elems.iterator;

    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  /// Adds a single key-value pair to this builder.
  IMapBuilder<K, V> addOne((K, V) keyValue) {
    final (key, value) = keyValue;

    if (_switchedToHashMapBuilder) {
      _hashMapBuilder.addOne(keyValue);
    } else if (_elems.size < 4) {
      _elems = _elems.updated(key, value);
    } else {
      if (_elems.contains(key)) {
        _elems = _elems.updated(key, value);
      } else {
        _switchedToHashMapBuilder = true;

        _hashMapBuilder.addAll(_elems);
        _hashMapBuilder.addOne(keyValue);
      }
    }

    return this;
  }

  /// Resets this builder so it can be reused to build a new [IMap].
  void clear() {
    _elems = IMap.empty();
    _hashMapBuilder.clear();
    _switchedToHashMapBuilder = false;
  }

  /// Returns the [IMap] containing all key-value pairs added so far.
  IMap<K, V> result() {
    if (_switchedToHashMapBuilder) {
      return _hashMapBuilder.result();
    } else {
      return _elems;
    }
  }
}
