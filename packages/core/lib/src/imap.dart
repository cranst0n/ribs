import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_core/ribs_core.dart';

IMap<K, V> imap<K, V>(Map<K, V> m) => IMap.fromMap(m);

// This is a thin wrapper around the FIC IMap, which is a tremendous immutable
// map implementation. This exists only because I want a particular Map API
// and I'm stubborn
final class IMap<K, V> {
  final fic.IMap<K, V> _underlying;

  IMap._(this._underlying);

  static IMap<K, V> empty<K, V>() => IMap._(fic.IMap());

  static IMap<K, V> fromMap<K, V>(Map<K, V> m) => IMap._(fic.IMap(m));

  static IMap<K, V> fromIList<K, V>(IList<(K, V)> kvs) =>
      fromIterable(kvs.toList());

  static IMap<K, V> fromIterable<K, V>(Iterable<(K, V)> kvs) =>
      IMap._(fic.IMap.fromEntries(kvs.map((kv) => MapEntry(kv.$1, kv.$2))));

  IMap<K, V> operator +((K, V) item) => updated(item.$1, item.$2);

  IMap<K, V> operator -(K key) => removed(key);

  Function1<K, Option<V2>> andThen<V2>(Function1<V, V2> f) =>
      (key) => get(key).map(f);

  Function1<A, Option<V>> compose<A>(Function1<A, K> f) => (a) => get(f(a));

  IMap<K, V> concat(IMap<K, V> m) => IMap._(_underlying.addAll(m._underlying));

  bool contains(K key) => _underlying.containsKey(key);

  int count(Function2<K, V, bool> p) => filter(p).size;

  bool exists(Function2<K, V, bool> p) => _underlying.any(p);

  IMap<K, V> filter(Function2<K, V, bool> p) => IMap._(_underlying.where(p));

  IMap<K, V> filterNot(Function2<K, V, bool> p) => filter((k, v) => !p(k, v));

  Option<(K, V)> find(Function2<K, V, bool> p) =>
      toIList().findN((k, v) => p(k, v));

  IMap<K2, V2> flatMap<K2, V2>(covariant Function2<K, V, IList<(K2, V2)>> f) =>
      toIList().flatMap((kv) => f.tupled(kv)).toIMap();

  B foldLeft<B>(B init, Function3<B, K, V, B> f) =>
      toIList().foldLeft(init, (b, kv) => f(b, kv.$1, kv.$2));

  bool forall(Function2<K, V, bool> p) =>
      _underlying.everyEntry((e) => p(e.key, e.value));

  void forEach<A>(Function2<K, V, A> f) => toIList().forEach(f.tupled);

  Option<V> get(K key) => Option.of(_underlying.get(key));

  V getOrElse(K key, Function0<V> orElse) => get(key).getOrElse(orElse);

  bool get isEmpty => _underlying.isEmpty;

  IList<K> get keys => ilist(_underlying.keys);

  int get length => _underlying.length;

  Function1<K, Option<V>> get lift => (k) => get(k);

  IList<B> map<B>(Function2<K, V, B> f) => toIList().map(f.tupled);

  bool get nonEmpty => _underlying.isNotEmpty;

  (IMap<K, V>, IMap<K, V>) partition(Function2<K, V, bool> p) => toIList()
      .partition(p.tupled)((a, b) => (IMap.fromIList(a), IMap.fromIList(b)));

  Option<(K, V)> reduceOption(Function2<(K, V), (K, V), (K, V)> f) =>
      toIList().reduceOption(f);

  IMap<K, V> removed(K key) => IMap._(_underlying.remove(key));

  IMap<K, V> removedAll(IList<K> keys) => filter((k, _) => keys.contains(k));

  int get size => _underlying.length;

  IMap<K, V> tapEach<A>(Function2<K, V, A> f) {
    forEach(f);
    return this;
  }

  IList<(K, V)> toIList() =>
      ilist(_underlying.entries).map((e) => (e.key, e.value));

  List<(K, V)> toList() =>
      _underlying.entries.map((e) => (e.key, e.value)).toList();

  IMap<K, W> transform<W>(Function2<K, V, W> f) =>
      toIList().mapN((k, v) => (k, f(k, v))).toIMap();

  (IList<K>, IList<V>) unzip() => (keys, values);

  IMap<K, V> updated(K key, V value) => IMap._(_underlying.add(key, value));

  IMap<K, V> updatedWith(K key, Function1<Option<V>, Option<V>> f) =>
      f(get(key)).fold(() => this, (v) => updated(key, v));

  IList<V> get values => ilist(_underlying.values);

  IMap<K, V> withDefault(Function1<K, V> f) => _DefaultMap._(f, _underlying);

  IMap<K, V> withDefaultValue(V value) => withDefault((_) => value);

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

final class _DefaultMap<K, V> extends IMap<K, V> {
  final Function1<K, V> _default;

  _DefaultMap._(
    this._default,
    fic.IMap<K, V> fic,
  ) : super._(fic);

  @override
  Option<V> get(K key) => super.get(key).orElse(() => _default(key).some);
}
