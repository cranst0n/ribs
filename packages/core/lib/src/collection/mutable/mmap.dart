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

MMap<K, V> mmap<K, V>(Map<K, V> m) => MMap.fromDart(m);

mixin MMap<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V> {
  static MMap<K, V> empty<K, V>() => MHashMap();

  static MMap<K, V> from<K, V>(RIterableOnce<(K, V)> elems) {
    final result = empty<K, V>();
    elems.foreach((kv) => result.put(kv.$1, kv.$2));
    return result;
  }

  static MMap<K, V> fromDart<K, V>(Map<K, V> m) =>
      fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  static MMap<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      from(RIterator.fromDart(elems.iterator));

  void operator []=(K key, V value) => update(key, value);

  void clear();

  @override
  MMap<K, V> concat(covariant RIterableOnce<(K, V)> suffix) => MMap.from(super.concat(suffix));

  @override
  MMap<K, V> drop(int n) => MMap.from(super.drop(n));

  @override
  MMap<K, V> dropRight(int n) => MMap.from(super.dropRight(n));

  @override
  MMap<K, V> dropWhile(Function1<(K, V), bool> p) => MMap.from(super.dropWhile(p));

  @override
  MMap<K, V> filter(Function1<(K, V), bool> p) => from(super.filter(p));

  MMap<K, V> filterInPlace(Function1<(K, V), bool> p) {
    if (!isEmpty) {
      foreach((kv) {
        if (p(kv)) remove(kv.$1);
      });
    }

    return this;
  }

  @override
  MMap<K, V> filterNot(Function1<(K, V), bool> p) => from(super.filterNot(p));

  @override
  IMap<K2, MMap<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      IMap.from(super.groupBy(f).map((a) => (a.$1, MMap.from(a.$2))));

  V getOrElseUpdate(K key, Function0<V> defaultValue);

  @override
  RIterator<MMap<K, V>> grouped(int size) => iterator.grouped(size).map(MMap.from);

  @override
  MMap<K, V> get init => MMap.from(super.init);

  @override
  RIterator<MMap<K, V>> get inits => super.inits.map(MMap.from);

  @override
  (MMap<K, V>, MMap<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (MMap.from(first), MMap.from(second));
  }

  Option<V> put(K key, V value);

  Option<V> remove(K key);

  MMap<K, V> removeAll(RIterableOnce<K> key) {
    if (size == 0) {
      return this;
    } else {
      keys.foreach(remove);
    }

    return this;
  }

  @override
  MMap<K, V> slice(int from, int until) => MMap.from(super.slice(from, until));

  @override
  RIterator<MMap<K, V>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(MMap.from);

  @override
  (MMap<K, V>, MMap<K, V>) span(Function1<(K, V), bool> p) {
    final (first, second) = super.span(p);
    return (MMap.from(first), MMap.from(second));
  }

  @override
  (MMap<K, V>, MMap<K, V>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (MMap.from(first), MMap.from(second));
  }

  @override
  MMap<K, V> get tail => MMap.from(super.tail);

  @override
  RIterator<MMap<K, V>> get tails => super.tails.map(MMap.from);

  @override
  MMap<K, V> take(int n) => MMap.from(super.take(n));

  @override
  MMap<K, V> takeRight(int n) => MMap.from(super.takeRight(n));

  @override
  MMap<K, V> takeWhile(Function1<(K, V), bool> p) => MMap.from(super.takeWhile(p));

  @override
  MMap<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }

  void update(K key, V value) => put(key, value);

  Option<V> updateWith(
    K key,
    Function1<Option<V>, Option<V>> remappingFunction,
  ) {
    final previousValue = get(key);
    final nextValue = remappingFunction(previousValue);

    previousValue.fold(
      () => nextValue.fold(() {}, (v) => update(key, v)),
      (_) => nextValue.fold(() => remove(key), (v) => update(key, v)),
    );

    return nextValue;
  }

  MMap<K, V> withDefault(Function1<K, V> f) => _WithDefault(this, f);

  MMap<K, V> withDefaultValue(V value) => _WithDefault(this, (_) => value);
}

abstract class AbstractMMap<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, MMap<K, V> {}

final class _WithDefault<K, V> extends AbstractMMap<K, V> {
  final MMap<K, V> underlying;
  final Function1<K, V> defaultValueF;

  _WithDefault(this.underlying, this.defaultValueF);

  @override
  void clear() => underlying.clear();

  @override
  bool contains(K key) => underlying.contains(key);

  @override
  V defaultValue(K key) => defaultValueF(key);

  @override
  Option<V> get(K key) => underlying.get(key);

  @override
  V getOrElseUpdate(K key, Function0<V> defaultValue) =>
      underlying.getOrElseUpdate(key, defaultValue);

  @override
  RIterator<(K, V)> get iterator => underlying.iterator;

  @override
  RIterable<K> get keys => underlying.keys;

  @override
  Option<V> put(K key, V value) => underlying.put(key, value);

  @override
  Option<V> remove(K key) => underlying.remove(key);

  @override
  RIterable<V> get values => underlying.values;
}
