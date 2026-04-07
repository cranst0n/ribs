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

/// Creates an [MMap] from a Dart [Map].
///
/// ```dart
/// final m = mmap({'a': 1, 'b': 2});
/// ```
MMap<K, V> mmap<K, V>(Map<K, V> m) => MMap.fromDart(m);

/// A mutable key-value map.
///
/// Backed by [MHashMap] with O(1) amortized [put], [get], and [remove].
/// Construct with [MMap.empty], [MMap.from], [MMap.fromDart], or via [mmap].
///
/// ```dart
/// final m = mmap({'a': 1});
/// m.put('b', 2); // Some(2) if 'b' existed before, None otherwise
/// m.get('a');    // Some(1)
/// m.remove('a'); // Some(1)
/// ```
mixin MMap<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V> {
  /// Returns an empty [MMap].
  static MMap<K, V> empty<K, V>() => MHashMap();

  /// Creates an [MMap] from a [RIterableOnce] of key-value pairs.
  static MMap<K, V> from<K, V>(RIterableOnce<(K, V)> elems) {
    final result = empty<K, V>();
    elems.foreach((kv) => result.put(kv.$1, kv.$2));
    return result;
  }

  /// Creates an [MMap] from a Dart [Map].
  static MMap<K, V> fromDart<K, V>(Map<K, V> m) =>
      fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  /// Creates an [MMap] from a Dart [Iterable] of key-value pairs.
  static MMap<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      from(RIterator.fromDart(elems.iterator));

  /// Sets the value for [key] to [value]. Alias for [update].
  void operator []=(K key, V value) => update(key, value);

  /// Removes all entries from this map.
  void clear();

  @override
  MMap<K, V> concat(RIterableOnce<(K, V)> suffix) => MMap.from(super.concat(suffix));

  @override
  MMap<K, V> drop(int n) => MMap.from(super.drop(n));

  @override
  MMap<K, V> dropRight(int n) => MMap.from(super.dropRight(n));

  @override
  MMap<K, V> dropWhile(Function1<(K, V), bool> p) => MMap.from(super.dropWhile(p));

  @override
  MMap<K, V> filter(Function1<(K, V), bool> p) => from(super.filter(p));

  /// Removes all entries that do not satisfy [p] in place and returns `this`.
  MMap<K, V> filterInPlace(Function1<(K, V), bool> p) {
    if (!isEmpty) {
      foreach((kv) {
        if (!p(kv)) remove(kv.$1);
      });
    }

    return this;
  }

  @override
  MMap<K, V> filterNot(Function1<(K, V), bool> p) => from(super.filterNot(p));

  @override
  IMap<K2, MMap<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      IMap.from(super.groupBy(f).map((a) => (a.$1, MMap.from(a.$2))));

  /// Returns the value for [key], or inserts and returns [defaultValue] when
  /// the key is absent.
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

  /// Associates [key] with [value], returning the previous value as `Some`,
  /// or `None` if [key] was not present.
  Option<V> put(K key, V value);

  /// Removes [key] and returns its value as `Some`, or `None` if absent.
  Option<V> remove(K key);

  /// Removes all of the given [key]s and returns `this`.
  MMap<K, V> removeAll(RIterableOnce<K> key) {
    if (size == 0) {
      return this;
    } else {
      key.foreach(remove);
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

  /// Sets [key] to [value]. Alias for [put].
  void update(K key, V value) => put(key, value);

  /// Computes a new value for [key] by applying [remappingFunction] to the
  /// current value (or [None] if absent).
  ///
  /// If [remappingFunction] returns [None], the key is removed.
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

  /// Returns a view of this map where key lookups fall back to [f] for missing
  /// keys.
  MMap<K, V> withDefault(Function1<K, V> f) => _WithDefault(this, f);

  /// Returns a view of this map where key lookups return [value] for missing
  /// keys.
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
