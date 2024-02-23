import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/map/map_node.dart';
import 'package:ribs_core/src/collection/immutable/set/champ_common.dart';

part 'map/builder.dart';
part 'map/hash_map.dart';
part 'map/empty.dart';
part 'map/map1.dart';
part 'map/map2.dart';
part 'map/map3.dart';
part 'map/map4.dart';

IMap<K, V> imap<K, V>(Map<K, V> m) => IMap.fromDart(m);

mixin IMap<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V> {
  static IMapBuilder<K, V> builder<K, V>() => IMapBuilder();

  static IMap<K, V> empty<K, V>() => _EmptyMap();

  static IMap<K, V> from<K, V>(RIterableOnce<(K, V)> elems) => switch (elems) {
        final _EmptyMap<K, V> m => m,
        final _Map1<K, V> m => m,
        final _Map2<K, V> m => m,
        final _Map3<K, V> m => m,
        final _Map4<K, V> m => m,
        _ => IMapBuilder<K, V>().addAll(elems).result(),
      };

  static IMap<K, V> fromDart<K, V>(Map<K, V> m) =>
      fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  static IMap<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      from(RIterator.fromDart(elems.iterator));

  /// Returns a new map with the given value for the given key.
  IMap<K, V> operator +((K, V) elem) => updated(elem.$1, elem.$2);

  /// Returns a new map with the value for given [key] removed.
  IMap<K, V> operator -(K key) => removed(key);

  /// Returns a new function that will accept a key of type [K] and apply
  /// the value for that key, if it exists as a [Some]. If this map doesn't
  /// contain the key, [None] will be returned.
  Function1<K, Option<V2>> andThen<V2>(Function1<V, V2> f) =>
      (key) => get(key).map(f);

  /// Composes the given function [f] with [get] and returns the result.
  Function1<A, Option<V>> compose<A>(Function1<A, K> f) => (a) => get(f(a));

  @override
  IMap<K, V> concat(covariant RIterableOnce<(K, V)> suffix) =>
      IMap.from(super.concat(suffix));

  @override
  bool contains(K key) => get(key).isDefined;

  @override
  IMap<K, V> drop(int n) => IMap.from(super.drop(n));

  @override
  IMap<K, V> dropRight(int n) => IMap.from(super.dropRight(n));

  @override
  IMap<K, V> dropWhile(Function1<(K, V), bool> p) =>
      IMap.from(super.dropWhile(p));

  @override
  IMap<K, V> filter(Function1<(K, V), bool> p) => from(super.filter(p));

  @override
  IMap<K, V> filterNot(Function1<(K, V), bool> p) => from(super.filterNot(p));

  @override
  IMap<K2, IMap<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      IMap.from(super.groupBy(f).map((a) => (a.$1, IMap.from(a.$2))));

  @override
  RIterator<IMap<K, V>> grouped(int size) =>
      iterator.grouped(size).map(IMap.from);

  @override
  IMap<K, V> init() => IMap.from(super.init());

  @override
  RIterator<IMap<K, V>> inits() => super.inits().map(IMap.from);

  /// Applies [f] to each value in this map and returns a new map with the same
  /// keys, with the resulting values of the function application.
  IMap<K, W> mapValues<W>(Function1<V, W> f) =>
      from(iterator.map((kv) => (kv.$1, f(kv.$2))));

  @override
  (IMap<K, V>, IMap<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (IMap.from(first), IMap.from(second));
  }

  /// Returns a new map with the value for given [key] removed.
  IMap<K, V> removed(K key);

  /// Returns a new map with all the given [keys] removed.
  IMap<K, V> removedAll(RIterableOnce<K> keys) =>
      keys.iterator.foldLeft(this, (acc, k) => acc.removed(k));

  @override
  IMap<K, V> slice(int from, int until) => IMap.from(super.slice(from, until));

  @override
  RIterator<IMap<K, V>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(IMap.from);

  @override
  (IMap<K, V>, IMap<K, V>) span(Function1<(K, V), bool> p) {
    final (first, second) = super.span(p);
    return (IMap.from(first), IMap.from(second));
  }

  @override
  (IMap<K, V>, IMap<K, V>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (IMap.from(first), IMap.from(second));
  }

  @override
  IMap<K, V> tail() => IMap.from(super.tail());

  @override
  RIterator<IMap<K, V>> tails() => super.tails().map(IMap.from);

  @override
  IMap<K, V> take(int n) => IMap.from(super.take(n));

  @override
  IMap<K, V> takeRight(int n) => IMap.from(super.takeRight(n));

  @override
  IMap<K, V> takeWhile(Function1<(K, V), bool> p) =>
      IMap.from(super.takeWhile(p));

  @override
  IMap<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }

  /// Return a new map where the keys and values are creating by applying [f]
  /// to every key-value pair in this map.
  IMap<K, W> transform<W>(Function2<K, V, W> f) =>
      from(iterator.map((kv) => (kv.$1, f(kv.$1, kv.$2))));

  /// Returns a tuple of 2 [RIterable]s where the first item is the keys from
  /// this map, and the second is the corresponding values.
  (RIterable<K>, RIterable<V>) unzip() {
    final (bldr1, bldr2) = (IList.builder<K>(), IList.builder<V>());

    iterator.foreach((kv) {
      bldr1.addOne(kv.$1);
      bldr2.addOne(kv.$2);
    });

    return (bldr1.toIList(), bldr2.toIList());
  }

  /// Returns a new map with the given [key] set to the given [value].
  IMap<K, V> updated(K key, V value);

  /// Returns a new map with [remappingFunction] applied to the value for the
  /// given [key] in this map.
  ///
  /// If [remappingFunction] returns [None], the returned map will not have a
  /// value associated with the given [key].
  IMap<K, V> updatedWith(
    K key,
    Function1<Option<V>, Option<V>> remappingFunction,
  ) {
    final previousValue = get(key);

    return remappingFunction(previousValue).fold(
      () => previousValue.fold(() => this, (_) => removed(key)),
      (nexValue) => updated(key, nexValue),
    );
  }

  /// Returns a new map where key lookups will return [f] if the map doesn't
  /// contain a value for the corresponding key.
  IMap<K, V> withDefault(Function1<K, V> f) => _WithDefault(this, f);

  /// Returns a new map where key lookups will return [f] if the map doesn't
  /// contain a value for the corresponding key.
  IMap<K, V> withDefaultValue(V value) => _WithDefault(this, (_) => value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      switch (other) {
        final IMap<K, dynamic> that =>
          forall((kv) => that.get(kv.$1) == Some(kv.$2)),
        _ => false,
      };
}

abstract class AbstractIMap<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, IMap<K, V> {}

final class _WithDefault<K, V> extends AbstractIMap<K, V> {
  final IMap<K, V> underlying;
  final Function1<K, V> defaultValueF;

  _WithDefault(this.underlying, this.defaultValueF);

  @override
  V defaultValue(K key) => defaultValueF(key);

  @override
  Option<V> get(K key) => underlying.get(key);

  @override
  bool get isEmpty => underlying.isEmpty;

  @override
  RIterator<(K, V)> get iterator => underlying.iterator;

  @override
  RIterable<K> get keys => underlying.keys;

  @override
  int get knownSize => underlying.knownSize;

  @override
  IMap<K, V> removed(K key) =>
      _WithDefault(underlying.removed(key), defaultValueF);

  @override
  int get size => underlying.size;

  @override
  IMap<K, V> updated(K key, V value) =>
      _WithDefault(underlying.updated(key, value), defaultValueF);

  @override
  RIterable<V> get values => underlying.values;
}
