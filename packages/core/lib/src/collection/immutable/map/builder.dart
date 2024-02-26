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

final class IMapBuilder<K, V> {
  IMap<K, V> _elems = IMap.empty<K, V>();
  var _switchedToHashMapBuilder = false;
  late final _hashMapBuilder = IHashMapBuilder<K, V>();

  IMapBuilder<K, V> addAll(RIterableOnce<(K, V)> elems) {
    final it = elems.iterator;

    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

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

  void clear() {
    _elems = IMap.empty();
    _hashMapBuilder.clear();
    _switchedToHashMapBuilder = false;
  }

  IMap<K, V> result() {
    if (_switchedToHashMapBuilder) {
      return _hashMapBuilder.result();
    } else {
      return _elems;
    }
  }
}
