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

final class _Map1<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, IMap<K, V> {
  final K key1;
  final V value1;

  const _Map1(this.key1, this.value1);

  @override
  bool contains(K key) => key == key1;

  @override
  bool exists(Function1<(K, V), bool> p) => p((key1, value1));

  @override
  bool forall(Function1<(K, V), bool> p) => p((key1, value1));

  @override
  void foreach<U>(Function1<(K, V), U> f) {
    f((key1, value1));
  }

  @override
  Option<V> get(K key) => Option.when(() => key == key1, () => value1);

  @override
  RIterator<(K, V)> get iterator => RIterator.single((key1, value1));

  @override
  ISet<K> get keys => ISet.of([key1]);

  @override
  int get knownSize => 1;

  @override
  IMap<K, V> removed(K key) => key == key1 ? _EmptyMap() : this;

  @override
  int get size => 1;

  @override
  IMap<K, V> updated(K key, V value) =>
      key == key1 ? _Map1(key, value) : _Map2(key1, value1, key, value);

  @override
  RIterator<V> get valuesIterator => RIterator.single(value1);
}
