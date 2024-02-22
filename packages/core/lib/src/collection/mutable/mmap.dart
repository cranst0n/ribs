import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/mutable/hash_map.dart';

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

  V getOrElseUpdate(K key, Function0<V> defaultValue);

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
  ISet<K> get keys => underlying.keys;

  @override
  Option<V> put(K key, V value) => underlying.put(key, value);

  @override
  Option<V> remove(K key) => underlying.remove(key);

  @override
  RIterator<V> get values => underlying.values;
}
