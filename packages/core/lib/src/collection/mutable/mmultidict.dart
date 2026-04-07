import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Creates an [MMultiDict] from a Dart [Iterable] of key-value pairs.
///
/// ```dart
/// final m = mmultidict([(1, 'a'), (1, 'b'), (2, 'c')]);
/// ```
MMultiDict<K, V> mmultidict<K, V>(Iterable<(K, V)> as) => MMultiDict.fromDartIterable(as);

/// A mutable multimap: each key is associated with a mutable set of values.
///
/// Backed by an [MMap] from key to [MSet]. Use [add] / `+` to insert a pair
/// and [get] to retrieve all values for a key.
///
/// ```dart
/// final m = mmultidict([(1, 'a'), (1, 'b'), (2, 'c')]);
/// m.get(1); // MSet('a', 'b')
/// (m + (1, 'c')).get(1); // MSet('a', 'b', 'c')
/// ```
@immutable
final class MMultiDict<K, V> with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMultiDict<K, V> {
  final MMap<K, MSet<V>> _elems;

  MMultiDict._(this._elems);

  /// Returns an empty [MMultiDict].
  static MMultiDict<K, V> empty<K, V>() => MMultiDict._(MMap.empty());

  /// Creates an [MMultiDict] from a [RIterableOnce] of key-value pairs.
  ///
  /// Returns [elems] directly when it is already an [MMultiDict].
  static MMultiDict<K, V> from<K, V>(RIterableOnce<(K, V)> elems) => switch (elems) {
    final MMultiDict<K, V> md => md,
    _ => MMultiDict._(
      MMap.from(
        elems
            .toIList()
            .groupMap((kv) => kv.$1, (kv) => kv.$2)
            .mapValues((l) => MSet.from(l.toISet())),
      ),
    ),
  };

  /// Creates an [MMultiDict] from a Dart [Map].
  static MMultiDict<K, V> fromDart<K, V>(Map<K, V> m) =>
      MMultiDict.fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  /// Creates an [MMultiDict] from a Dart [Iterable] of key-value pairs.
  static MMultiDict<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      MMultiDict.from(RIterator.fromDart(elems.iterator));

  /// Adds [elem] and returns `this`. Alias for [add].
  MMultiDict<K, V> operator +((K, V) elem) => add(elem.$1, elem.$2);

  /// Adds [value] to the set of values for [key] and returns `this`.
  MMultiDict<K, V> add(K key, V value) {
    final vs = _elems.getOrElseUpdate(key, () => MSet.empty());
    vs.add(value);
    return this;
  }

  @override
  MMultiDict<K, V> concat(RIterableOnce<(K, V)> suffix) => MMultiDict.from(super.concat(suffix));

  @override
  MMultiDict<K, V> drop(int n) => MMultiDict.from(super.drop(n));

  @override
  MMultiDict<K, V> dropRight(int n) => MMultiDict.from(super.dropRight(n));

  @override
  MMultiDict<K, V> dropWhile(Function1<(K, V), bool> p) => MMultiDict.from(super.dropWhile(p));

  @override
  MMultiDict<K, V> filter(Function1<(K, V), bool> p) => MMultiDict.from(super.filter(p));

  @override
  MMultiDict<K, V> filterNot(Function1<(K, V), bool> p) => MMultiDict.from(super.filterNot(p));

  @override
  MMultiDict<K, V> filterSets(Function1<(K, RSet<V>), bool> p) =>
      MMultiDict.from(super.filterSets(p));

  @override
  RSet<V> get(K key) => _elems.get(key).getOrElse(() => MSet.empty());

  @override
  IMap<K2, MMultiDict<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      super.groupBy(f).mapValues(MMultiDict.from);

  @override
  RIterator<MMultiDict<K, V>> grouped(int size) => super.grouped(size).map(MMultiDict.from);

  @override
  MMultiDict<K, V> get init => MMultiDict.from(super.init);

  @override
  RIterator<MMultiDict<K, V>> get inits => super.inits.map(MMultiDict.from);

  @override
  MMultiDict<K2, V2> mapSets<K2, V2>(
    Function1<(K, RSet<V>), (K2, RSet<V2>)> f,
  ) => MMultiDict.from(super.mapSets(f));

  @override
  (MMultiDict<K, V>, MMultiDict<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (MMultiDict.from(first), MMultiDict.from(second));
  }

  @override
  RMap<K, RSet<V>> get sets => _elems;

  @override
  MMultiDict<K, V> slice(int from, int until) => MMultiDict.from(super.slice(from, until));

  @override
  RIterator<MMultiDict<K, V>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(MMultiDict.from);

  @override
  (MMultiDict<K, V>, MMultiDict<K, V>) span(Function1<(K, V), bool> p) {
    final (first, second) = super.span(p);
    return (MMultiDict.from(first), MMultiDict.from(second));
  }

  @override
  (MMultiDict<K, V>, MMultiDict<K, V>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (MMultiDict.from(first), MMultiDict.from(second));
  }

  @override
  MMultiDict<K, V> get tail => MMultiDict.from(super.tail);

  @override
  RIterator<MMultiDict<K, V>> get tails => super.tails.map(MMultiDict.from);

  @override
  MMultiDict<K, V> take(int n) => MMultiDict.from(super.take(n));

  @override
  MMultiDict<K, V> takeRight(int n) => MMultiDict.from(super.takeRight(n));

  @override
  MMultiDict<K, V> takeWhile(Function1<(K, V), bool> p) => MMultiDict.from(super.takeWhile(p));

  @override
  MMultiDict<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }
}
