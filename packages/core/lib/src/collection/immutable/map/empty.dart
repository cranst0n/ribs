part of '../imap.dart';

final class _EmptyMap<K, V>
    with IterableOnce<(K, V)>, RibsIterable<(K, V)>, IMap<K, V> {
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
  RibsIterator<(K, V)> get iterator => RibsIterator.empty();

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
  RibsIterator<V> get values => RibsIterator.empty();
}
