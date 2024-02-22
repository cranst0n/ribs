part of '../imap.dart';

final class _Map2<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, IMap<K, V> {
  final K key1;
  final V value1;
  final K key2;
  final V value2;

  const _Map2(this.key1, this.value1, this.key2, this.value2);

  @override
  bool contains(K key) => key == key1 || key == key2;

  @override
  bool exists(Function1<(K, V), bool> p) =>
      p((key1, value1)) || p((key2, value2));

  @override
  bool forall(Function1<(K, V), bool> p) =>
      p((key1, value1)) && p((key2, value2));

  @override
  void foreach<U>(Function1<(K, V), U> f) {
    f((key1, value1));
    f((key2, value2));
  }

  @override
  Option<V> get(K key) => switch (key) {
        _ when key == key1 => Some(value1),
        _ when key == key2 => Some(value2),
        _ => none(),
      };

  @override
  RIterator<(K, V)> get iterator =>
      ilist([(key1, value1), (key2, value2)]).iterator;

  @override
  ISet<K> get keys => ISet.of([key1, key2]);

  @override
  int get knownSize => 2;

  @override
  IMap<K, V> removed(K key) {
    if (key == key1) {
      return _Map1(key2, value2);
    } else if (key == key2) {
      return _Map1(key1, value1);
    } else {
      return this;
    }
  }

  @override
  int get size => 2;

  @override
  IMap<K, V> updated(K key, V value) {
    if (key == key1) {
      return _Map2(key1, value, key2, value2);
    } else if (key == key2) {
      return _Map2(key1, value1, key2, value);
    } else {
      return _Map3(key1, value1, key2, value2, key, value);
    }
  }

  @override
  RIterator<V> get values => ilist([value1, value2]).iterator;
}
