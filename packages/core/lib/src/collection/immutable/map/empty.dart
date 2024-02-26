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

final class _EmptyMap<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, IMap<K, V> {
  _EmptyMap();

  @override
  bool contains(K key) => false;

  @override
  Option<V> get(K key) => none();

  @override
  V getOrElse(K key, Function0<V> defaultValue) => defaultValue();

  @override
  bool get isEmpty => true;

  @override
  RIterator<(K, V)> get iterator => RIterator.empty();

  @override
  ISet<K> get keys => ISet.empty();

  @override
  int get knownSize => 0;

  @override
  IMap<K, V> removed(K key) => this;

  @override
  int get size => 0;

  @override
  IMap<K, V> updated(K key, V value) => _Map1(key, value);

  @override
  RIterable<V> get values => nil();

  @override
  RIterator<V> get valuesIterator => RIterator.empty();
}
