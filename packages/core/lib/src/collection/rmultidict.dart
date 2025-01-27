import 'package:ribs_core/ribs_core.dart';

mixin RMultiDict<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)> {
  static RMultiDict<K, V> empty<K, V>() => IMultiDict.empty();

  static RMultiDict<K, V> fromSets<K, V>(RIterable<(K, RSet<V>)> it) =>
      IMultiDict.from(it.flatMap((kv) => kv.$2.map((v) => (kv.$1, v))));

  static RMultiDict<K, V> from<K, V>(RIterableOnce<(K, V)> elems) =>
      switch (elems) {
        final RMultiDict<K, V> md => md,
        _ => IMultiDict.from(elems),
      };

  static RMultiDict<K, V> fromDart<K, V>(Map<K, V> m) =>
      IMultiDict.fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  static RMultiDict<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      IMultiDict.from(RIterator.fromDart(elems.iterator));

  RMultiDict<K, V> concatSets(RIterable<(K, RSet<V>)> suffix) =>
      RMultiDict.fromSets(sets.concat(suffix));

  bool containsEntry((K, V) entry) =>
      sets.get(entry.$1).exists((s) => s.contains(entry.$2));

  bool containsKey(K key) => sets.contains(key);

  bool containsValue(V value) => sets.exists((t) => t.$2.contains(value));

  @override
  RMultiDict<K, V> drop(int n) => RMultiDict.from(super.drop(n));

  @override
  RMultiDict<K, V> dropRight(int n) => RMultiDict.from(super.dropRight(n));

  @override
  RMultiDict<K, V> dropWhile(Function1<(K, V), bool> p) =>
      RMultiDict.from(super.dropWhile(p));

  bool entryExists(K key, Function1<V, bool> p) =>
      sets.get(key).exists((s) => s.exists(p));

  @override
  RMultiDict<K, V> filter(Function1<(K, V), bool> p) =>
      RMultiDict.from(super.filter(p));

  @override
  RMultiDict<K, V> filterNot(Function1<(K, V), bool> p) =>
      RMultiDict.from(super.filterNot(p));

  RMultiDict<K, V> filterSets(Function1<(K, RSet<V>), bool> p) =>
      RMultiDict.fromSets(sets.filter(p));

  RMultiDict<K, V> flatMapSets(
    Function1<(K, RSet<V>), RIterableOnce<(K, RSet<V>)>> f,
  ) =>
      RMultiDict.fromSets(sets.flatMap(f));

  RSet<V> get(K key) => sets.get(key).getOrElse(() => RSet.empty());

  @override
  IMap<K2, RMultiDict<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      super.groupBy(f).mapValues(RMultiDict.from);

  @override
  RIterator<RMultiDict<K, V>> grouped(int size) =>
      super.grouped(size).map(RMultiDict.from);

  @override
  RMultiDict<K, V> init() => RMultiDict.from(super.init());

  @override
  RIterator<RMultiDict<K, V>> inits() => super.inits().map(RMultiDict.from);

  @override
  RIterator<(K, V)> get iterator => sets.iterator.flatMap((t) {
        final (k, vs) = t;
        return vs.view().map((v) => (t.$1, v));
      });

  RSet<K> keySet() => sets.keySet;

  RMultiDict<K2, V2> mapSets<K2, V2>(
          Function1<(K, RSet<V>), (K2, RSet<V2>)> f) =>
      RMultiDict.fromSets(sets.map(f));

  @override
  (RMultiDict<K, V>, RMultiDict<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (RMultiDict.from(first), RMultiDict.from(second));
  }

  @override
  RMultiDict<K, V> slice(int from, int until) =>
      RMultiDict.from(super.slice(from, until));

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
  RMultiDict<K, V> tail() => RMultiDict.from(super.tail());

  @override
  RIterator<RMultiDict<K, V>> tails() => super.tails().map(RMultiDict.from);

  @override
  RMultiDict<K, V> take(int n) => RMultiDict.from(super.take(n));

  @override
  RMultiDict<K, V> takeRight(int n) => RMultiDict.from(super.takeRight(n));

  @override
  RMultiDict<K, V> takeWhile(Function1<(K, V), bool> p) =>
      RMultiDict.from(super.takeWhile(p));

  @override
  RMultiDict<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }

  RMap<K, RSet<V>> get sets;

  RIterable<V> get values => sets.values.flatten();

  @override
  int get hashCode => MurmurHash3.unorderedHash(sets, 'MultiMap'.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      switch (other) {
        final RMultiDict<K, dynamic> that => size == that.size &&
            sets.forall((kv) => that.sets.get(kv.$1).contains(kv.$2)),
        _ => false,
      };
}
