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

mixin RMap<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)> {
  /// Returns the value associated with the given [key], or the [defaultValue]
  /// of this map (which could potentially throw).
  V operator [](K key) => get(key).getOrElse(() => defaultValue(key));

  /// Returns true if this map contains the key [key], false otherwise.
  bool contains(K key);

  V defaultValue(K key) => throw Exception("No such value for key: '$key'");

  /// Returns the value for the given key [key] as a [Some], or [None] if this
  /// map doesn't contain the key.
  Option<V> get(K key);

  /// Returns a [RIterable] of all the keys stored in the map.
  RIterable<K> get keys => keysIterator.toISet();

  RIterator<K> get keysIterator => iterator.map((kv) => kv.$1);

  /// Returns the value for the given key [key], or [orElse] if this map doesn't
  /// contain the key.
  V getOrElse(K key, Function0<V> orElse) => get(key).getOrElse(orElse);

  /// Returns a new [Map] containing the same key-value pairs.
  Map<K, V> toMap() =>
      Map.fromEntries(iterator.map((a) => MapEntry(a.$1, a.$2)).toList());

  /// Returns a [RIterable] of all values stored in this map.
  RIterable<V> get values => valuesIterator.toSeq();

  /// Returns a [RIterator] of all values stored in this map.
  RIterator<V> get valuesIterator => iterator.map((kv) => kv.$2);

  @override
  int get hashCode => MurmurHash3.mapHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is RMap<K, V>) {
      return size == other.size &&
          forall((kv) => other.get(kv.$1) == Some(kv.$2));
    } else {
      return super == other;
    }
  }
}
