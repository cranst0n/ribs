import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_core/ribs_core.dart';

IMap<K, V> imap<K, V>(Map<K, V> m) => IMap.fromMap(m);

// This is a thin wrapper around the FIC IMap, which is a tremendous immutable
// map implementation. This exists only because I want a particular Map API
// to make porting libraries easier, and I'm stubborn.
final class IMap<K, V> {
  final fic.IMap<K, V> _underlying;

  const IMap._(this._underlying);

  /// Creates a map with no elements.
  const IMap.empty() : _underlying = const fic.IMapConst({});

  /// Creates a new [IMap] from the given [Map].
  static IMap<K, V> fromMap<K, V>(Map<K, V> m) => IMap._(fic.IMap(m));

  /// Creates a new map from the given list of key-value pair tuples.
  static IMap<K, V> fromIList<K, V>(IList<(K, V)> kvs) =>
      fromIterable(kvs.toList());

  /// Creates a new map from the given iterable of key-value pair tuples.
  static IMap<K, V> fromIterable<K, V>(Iterable<(K, V)> kvs) =>
      IMap._(fic.IMap.fromEntries(kvs.map((kv) => MapEntry(kv.$1, kv.$2))));

  /// Returns a new map with the given value for the given key.
  IMap<K, V> operator +((K, V) item) => updated(item.$1, item.$2);

  /// Returns a new map with the value for given [key] removed.
  IMap<K, V> operator -(K key) => removed(key);

  /// Returns a new function that will accept a key of type [K] and apply
  /// the value for that key, if it exists as a [Some]. If this map doesn't
  /// contain the key, [None] will be returned.
  Function1<K, Option<V2>> andThen<V2>(Function1<V, V2> f) =>
      (key) => get(key).map(f);

  /// Composes the given function [f] with [get] and returns the result.
  Function1<A, Option<V>> compose<A>(Function1<A, K> f) => (a) => get(f(a));

  /// Returns a new map with the elements from this list and then the elements
  /// from [m].
  IMap<K, V> concat(IMap<K, V> m) => IMap._(_underlying.addAll(m._underlying));

  /// Returns true if this map contains the key [key], false otherwise.
  bool contains(K key) => _underlying.containsKey(key);

  /// Returns the number of key-value pairs that satisfy the given
  /// predicate [p].
  int count(Function2<K, V, bool> p) => filter(p).size;

  /// Returns true if any key-value pair satisfies the given predicate [p],
  /// false otherwise.
  bool exists(Function2<K, V, bool> p) => _underlying.any(p);

  /// Returns a new map containing only the elements from this map that
  /// satisfy the given predicate [p].
  IMap<K, V> filter(Function2<K, V, bool> p) => IMap._(_underlying.where(p));

  /// Returns a new map containing only the elements from this map that
  /// do not satisfy the given predicate [p].
  IMap<K, V> filterNot(Function2<K, V, bool> p) => filter((k, v) => !p(k, v));

  /// Returns the first key-value pair that satisifes the given predicate [p]
  /// as [Some], or [None] if no key-value pair satisfies [p].
  Option<(K, V)> find(Function2<K, V, bool> p) =>
      toIList().findN((k, v) => p(k, v));

  /// Applies [f] to each key-value pair of this map, and returns all the
  /// resulting key-value pairs as a new map.
  IMap<K2, V2> flatMap<K2, V2>(covariant Function2<K, V, IList<(K2, V2)>> f) =>
      toIList().flatMap((kv) => f.tupled(kv)).toIMap();

  /// Returns the summary value by applying [f] to each key-value pair, using
  /// [init] as the seed value for the fold.
  B foldLeft<B>(B init, Function3<B, K, V, B> f) =>
      toIList().foldLeft(init, (b, kv) => f(b, kv.$1, kv.$2));

  /// return true if every key-value pair in this map satisfy the given
  /// predicate [p].
  bool forall(Function2<K, V, bool> p) =>
      _underlying.everyEntry((e) => p(e.key, e.value));

  /// Applies [f] to each element of this list, discarding any resulting values.
  void forEach<A>(Function2<K, V, A> f) => toIList().forEach(f.tupled);

  /// Returns the value for the given key [key] as a [Some], or [None] if this
  /// map doesn't contain the key.
  Option<V> get(K key) => Option(_underlying.get(key));

  /// Returns the value for the given key [key], or [orElse] if this map doesn't
  /// contain the key.
  V getOrElse(K key, Function0<V> orElse) => get(key).getOrElse(orElse);

  /// Returns true if this map contains no keys, false otherwise.
  bool get isEmpty => _underlying.isEmpty;

  /// Returns a list of all the keys stored in the map.
  IList<K> get keys => ilist(_underlying.keys);

  /// Returns the number of key-value pairs this map contains.
  int get length => _underlying.length;

  /// Applies [f] to each key-value pair in this map and returns the results
  /// as a new list.
  IList<B> map<B>(Function2<K, V, B> f) => toIList().map(f.tupled);

  /// Returns true if this map has any elements, false otherwise.
  bool get nonEmpty => _underlying.isNotEmpty;

  /// Returns 2 map as a tuple where the first tuple element will be a map
  /// of elements from this map that satisfy the given predicate [p]. The
  /// second item of the returned tuple will be elements that do not satisfy
  /// [p].
  (IMap<K, V>, IMap<K, V>) partition(Function2<K, V, bool> p) => toIList()
      .partition(p.tupled)((a, b) => (IMap.fromIList(a), IMap.fromIList(b)));

  /// Returns the summary value by applying [f] to each key-value pair as a
  /// [Some] if this map is not empty, otherwise [None] is returned.
  Option<(K, V)> reduceOption(Function2<(K, V), (K, V), (K, V)> f) =>
      toIList().reduceOption(f);

  /// Returns a new map with the value for given [key] removed.
  IMap<K, V> removed(K key) => IMap._(_underlying.remove(key));

  /// Returns a new map with all the given [keys] removed.
  IMap<K, V> removedAll(IList<K> keys) => filterNot((k, _) => keys.contains(k));

  /// Returns the number of key-value pairs in this map.
  int get size => _underlying.length;

  /// Performs the given side effect [f] for every key-value element in this
  /// map, returning this map.
  IMap<K, V> tapEach<A>(Function2<K, V, A> f) {
    forEach(f);
    return this;
  }

  /// Returns an [IList] of every key-value pair as a tuple.
  IList<(K, V)> toIList() =>
      ilist(_underlying.entries).map((e) => (e.key, e.value));

  /// Returns an [List] of every key-value pair as a tuple.
  List<(K, V)> toList() =>
      _underlying.entries.map((e) => (e.key, e.value)).toList();

  /// Return a new map where the keys and values are creating by applying [f]
  /// to every key-value pair in this map.
  IMap<K, W> transform<W>(Function2<K, V, W> f) =>
      toIList().mapN((k, v) => (k, f(k, v))).toIMap();

  /// Returns a tuple of 2 [IList]s where the first item is the keys from this
  /// map, and the second is the corresponding values.
  (IList<K>, IList<V>) unzip() => (keys, values);

  /// Returns a new map with the given [key] set to the given [value].
  IMap<K, V> updated(K key, V value) => IMap._(_underlying.add(key, value));

  /// Returns a new map with [f] applied to the value for the given [key] in
  /// this map.
  ///
  /// If [f] returns [None], the original map is returned.
  IMap<K, V> updatedWith(K key, Function1<Option<V>, Option<V>> f) =>
      f(get(key)).fold(() => this, (v) => updated(key, v));

  /// Returns a list of all values stored in this map.
  IList<V> get values => ilist(_underlying.values);

  /// Returns a new map where key lookups will return [f] if the map doesn't
  /// contain a value for the corresponding key.
  IMap<K, V> withDefault(Function1<K, V> f) => _DefaultMap._(f, _underlying);

  /// Returns a new map where key lookups will return [f] if the map doesn't
  /// contain a value for the corresponding key.
  IMap<K, V> withDefaultValue(V value) => withDefault((_) => value);

  /// Return an [IList] where each element is a tuple of a key-value pair from
  /// this map and the corresponding element from [that].
  ///
  /// The returned list will have size equal to the minimum of the size of
  /// this map and [that].
  IList<((K, V), B)> zip<B>(IList<B> that) => toIList().zip(that);

  @override
  String toString() => _underlying.toString(false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IMap<K, V> && _underlying == other._underlying);

  @override
  int get hashCode => _underlying.hashCode;
}

/// [IMap] that will always fallback to a given value when the key is not
/// present.
final class _DefaultMap<K, V> extends IMap<K, V> {
  final Function1<K, V> _default;

  _DefaultMap._(
    this._default,
    fic.IMap<K, V> fic,
  ) : super._(fic);

  @override
  Option<V> get(K key) => super.get(key).orElse(() => _default(key).some);
}
