import 'package:ribs_core/ribs_core.dart';

/// A map that may associate multiple values with a single key.
///
/// Each key maps to an [RSet] of values. [RMultiDict] iterates over `(K, V)`
/// pairs — one pair per key-value association. The concrete immutable
/// implementation is [IMultiDict].
mixin RMultiDict<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)> {
  /// Returns an empty [RMultiDict].
  static RMultiDict<K, V> empty<K, V>() => IMultiDict.empty();

  /// Creates an [RMultiDict] from a [RIterable] of `(key, set-of-values)` pairs.
  static RMultiDict<K, V> fromSets<K, V>(RIterable<(K, RSet<V>)> it) =>
      IMultiDict.from(it.flatMap((kv) => kv.$2.map((v) => (kv.$1, v))));

  /// Creates an [RMultiDict] from a [RIterableOnce] of `(key, value)` pairs.
  ///
  /// Returns [elems] directly when it is already an [RMultiDict]; otherwise
  /// materialises it into an [IMultiDict].
  static RMultiDict<K, V> from<K, V>(RIterableOnce<(K, V)> elems) => switch (elems) {
    final RMultiDict<K, V> md => md,
    _ => IMultiDict.from(elems),
  };

  /// Creates an [RMultiDict] from a Dart [Map].
  static RMultiDict<K, V> fromDart<K, V>(Map<K, V> m) =>
      IMultiDict.fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  /// Creates an [RMultiDict] from a Dart [Iterable] of `(key, value)` pairs.
  static RMultiDict<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      IMultiDict.from(RIterator.fromDart(elems.iterator));

  /// Returns a new multidict formed by appending the key-set pairs in [suffix].
  RMultiDict<K, V> concatSets(RIterable<(K, RSet<V>)> suffix) =>
      RMultiDict.fromSets(sets.concat(suffix));

  /// Returns true if this multidict contains the exact key-value pair [entry].
  bool containsEntry((K, V) entry) => sets.get(entry.$1).exists((s) => s.contains(entry.$2));

  /// Returns true if [key] appears as a key in this multidict.
  bool containsKey(K key) => sets.contains(key);

  /// Returns true if [value] is associated with any key in this multidict.
  bool containsValue(V value) => sets.exists((t) => t.$2.contains(value));

  @override
  RMultiDict<K, V> drop(int n) => RMultiDict.from(super.drop(n));

  @override
  RMultiDict<K, V> dropRight(int n) => RMultiDict.from(super.dropRight(n));

  @override
  RMultiDict<K, V> dropWhile(Function1<(K, V), bool> p) => RMultiDict.from(super.dropWhile(p));

  /// Returns true if any value associated with [key] satisfies [p].
  bool entryExists(K key, Function1<V, bool> p) => sets.get(key).exists((s) => s.exists(p));

  @override
  RMultiDict<K, V> filter(Function1<(K, V), bool> p) => RMultiDict.from(super.filter(p));

  @override
  RMultiDict<K, V> filterNot(Function1<(K, V), bool> p) => RMultiDict.from(super.filterNot(p));

  /// Returns a new multidict keeping only the key-set pairs that satisfy [p].
  RMultiDict<K, V> filterSets(Function1<(K, RSet<V>), bool> p) =>
      RMultiDict.fromSets(sets.filter(p));

  /// Returns a new multidict by applying [f] to each key-set pair and
  /// concatenating the resulting key-set sequences.
  RMultiDict<K, V> flatMapSets(
    Function1<(K, RSet<V>), RIterableOnce<(K, RSet<V>)>> f,
  ) => RMultiDict.fromSets(sets.flatMap(f));

  /// Returns the set of values associated with [key], or an empty set if the
  /// key is absent.
  RSet<V> get(K key) => sets.get(key).getOrElse(() => RSet.empty());

  @override
  IMap<K2, RMultiDict<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      super.groupBy(f).mapValues(RMultiDict.from);

  @override
  RIterator<RMultiDict<K, V>> grouped(int size) => super.grouped(size).map(RMultiDict.from);

  @override
  RMultiDict<K, V> get init => RMultiDict.from(super.init);

  @override
  RIterator<RMultiDict<K, V>> get inits => super.inits.map(RMultiDict.from);

  @override
  RIterator<(K, V)> get iterator => sets.iterator.flatMap((t) {
    final (k, vs) = t;
    return vs.map((V v) => (t.$1, v));
  });

  /// Returns an [RSet] of all keys in this multidict.
  RSet<K> keySet() => sets.keySet;

  /// Returns a new multidict by applying [f] to each `(key, set-of-values)` pair.
  RMultiDict<K2, V2> mapSets<K2, V2>(Function1<(K, RSet<V>), (K2, RSet<V2>)> f) =>
      RMultiDict.fromSets(sets.map(f));

  @override
  (RMultiDict<K, V>, RMultiDict<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (RMultiDict.from(first), RMultiDict.from(second));
  }

  @override
  RMultiDict<K, V> slice(int from, int until) => RMultiDict.from(super.slice(from, until));

  @override
  RIterator<RMultiDict<K, V>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(RMultiDict.from);

  @override
  (RMultiDict<K, V>, RMultiDict<K, V>) span(Function1<(K, V), bool> p) {
    final (first, second) = super.span(p);
    return (RMultiDict.from(first), RMultiDict.from(second));
  }

  @override
  (RMultiDict<K, V>, RMultiDict<K, V>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (RMultiDict.from(first), RMultiDict.from(second));
  }

  @override
  RMultiDict<K, V> get tail => RMultiDict.from(super.tail);

  @override
  RIterator<RMultiDict<K, V>> get tails => super.tails.map(RMultiDict.from);

  @override
  RMultiDict<K, V> take(int n) => RMultiDict.from(super.take(n));

  @override
  RMultiDict<K, V> takeRight(int n) => RMultiDict.from(super.takeRight(n));

  @override
  RMultiDict<K, V> takeWhile(Function1<(K, V), bool> p) => RMultiDict.from(super.takeWhile(p));

  @override
  RMultiDict<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }

  /// The underlying map from each key to its associated set of values.
  RMap<K, RSet<V>> get sets;

  /// Returns an [RIterable] of all values across all keys.
  RIterable<V> get values => sets.values.flatten();

  @override
  int get hashCode => MurmurHash3.unorderedHash(sets, 'MultiMap'.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      switch (other) {
        final RMultiDict<K, dynamic> that =>
          size == that.size && sets.forall((kv) => that.sets.get(kv.$1).contains(kv.$2)),
        _ => false,
      };
}
