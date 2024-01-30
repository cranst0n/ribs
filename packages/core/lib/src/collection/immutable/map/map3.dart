part of '../imap.dart';

final class _Map3<K, V>
    with IterableOnce<(K, V)>, RibsIterable<(K, V)>, IMap<K, V> {
  final K key1;
  final V value1;
  final K key2;
  final V value2;
  final K key3;
  final V value3;

  const _Map3(
      this.key1, this.value1, this.key2, this.value2, this.key3, this.value3);

  @override
  bool contains(K key) => key == key1 || key == key2 || key == key3;

  @override
  bool exists(Function1<(K, V), bool> p) =>
      p((key1, value1)) || p((key2, value2)) || p((key3, value3));

  @override
  bool forall(Function1<(K, V), bool> p) =>
      p((key1, value1)) && p((key2, value2)) && p((key3, value3));

  @override
  void foreach<U>(Function1<(K, V), U> f) {
    f((key1, value1));
    f((key2, value2));
    f((key3, value3));
  }

  @override
  Option<V> get(K key) => switch (key) {
        _ when key == key1 => Some(value1),
        _ when key == key2 => Some(value2),
        _ when key == key3 => Some(value3),
        _ => none(),
      };

  @override
  RibsIterator<(K, V)> get iterator =>
      ilist([(key1, value1), (key2, value2), (key3, value3)]).iterator;

  @override
  ISet<K> get keys => ISet.of([key1, key2, key3]);

  @override
  int get knownSize => 3;

  @override
  IMap<K, V> removed(K key) {
    if (key == key1) {
      return _Map2(key2, value2, key3, value3);
    } else if (key == key2) {
      return _Map2(key1, value1, key3, value3);
    } else if (key == key3) {
      return _Map2(key1, value1, key2, value2);
    } else {
      return this;
    }
  }

  @override
  int get size => 3;

  @override
  IMap<K, V> updated(K key, V value) {
    if (key == key1) {
      return _Map3(key1, value, key2, value2, key3, value3);
    } else if (key == key2) {
      return _Map3(key1, value1, key2, value, key3, value3);
    } else if (key == key3) {
      return _Map3(key1, value1, key2, value2, key3, value);
    } else {
      return _Map4(key1, value1, key2, value2, key3, value3, key, value);
    }
  }

  @override
  RibsIterator<V> get values => ilist([value1, value2, value3]).iterator;
}
