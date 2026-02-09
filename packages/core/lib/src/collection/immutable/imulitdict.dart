import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

IMultiDict<K, V> imultidict<K, V>(Iterable<(K, V)> as) => IMultiDict.fromDartIterable(as);

@immutable
final class IMultiDict<K, V> with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMultiDict<K, V> {
  final IMap<K, ISet<V>> _elems;

  IMultiDict._(this._elems);

  static IMultiDict<K, V> empty<K, V>() => IMultiDict._(IMap.empty());

  static IMultiDict<K, V> from<K, V>(RIterableOnce<(K, V)> elems) => switch (elems) {
    final IMultiDict<K, V> md => md,
    _ => IMultiDict._(
      elems.toIList().groupMap((kv) => kv.$1, (kv) => kv.$2).mapValues((l) => l.toISet()),
    ),
  };

  static IMultiDict<K, V> fromDart<K, V>(Map<K, V> m) =>
      IMultiDict.fromDartIterable(m.entries.map((e) => (e.key, e.value)));

  static IMultiDict<K, V> fromDartIterable<K, V>(Iterable<(K, V)> elems) =>
      IMultiDict.from(RIterator.fromDart(elems.iterator));

  IMultiDict<K, V> operator +((K, V) elem) => add(elem.$1, elem.$2);

  IMultiDict<K, V> add(K key, V value) => IMultiDict._(
    _elems.updatedWith(
      key,
      (updated) => updated.fold(
        () => Some(iset([value])),
        (vs) => Some(vs.incl(value)),
      ),
    ),
  );

  @override
  IMultiDict<K, V> concat(RIterableOnce<(K, V)> suffix) => IMultiDict.from(super.concat(suffix));

  @override
  IMultiDict<K, V> drop(int n) => IMultiDict.from(super.drop(n));

  @override
  IMultiDict<K, V> dropRight(int n) => IMultiDict.from(super.dropRight(n));

  @override
  IMultiDict<K, V> dropWhile(Function1<(K, V), bool> p) => IMultiDict.from(super.dropWhile(p));

  @override
  IMultiDict<K, V> filter(Function1<(K, V), bool> p) => IMultiDict.from(super.filter(p));

  @override
  IMultiDict<K, V> filterNot(Function1<(K, V), bool> p) => IMultiDict.from(super.filterNot(p));

  @override
  IMultiDict<K, V> filterSets(Function1<(K, RSet<V>), bool> p) =>
      IMultiDict.from(super.filterSets(p));

  @override
  RSet<V> get(K key) => _elems.get(key).getOrElse(() => ISet.empty());

  @override
  IMap<K2, IMultiDict<K, V>> groupBy<K2>(Function1<(K, V), K2> f) =>
      super.groupBy(f).mapValues(IMultiDict.from);

  @override
  RIterator<IMultiDict<K, V>> grouped(int size) => super.grouped(size).map(IMultiDict.from);

  @override
  IMultiDict<K, V> get init => IMultiDict.from(super.init);

  @override
  RIterator<IMultiDict<K, V>> get inits => super.inits.map(IMultiDict.from);

  @override
  IMultiDict<K2, V2> mapSets<K2, V2>(
    Function1<(K, RSet<V>), (K2, RSet<V2>)> f,
  ) => IMultiDict.from(super.mapSets(f));

  @override
  (IMultiDict<K, V>, IMultiDict<K, V>) partition(Function1<(K, V), bool> p) {
    final (first, second) = super.partition(p);
    return (IMultiDict.from(first), IMultiDict.from(second));
  }

  @override
  RMap<K, ISet<V>> get sets => _elems;

  @override
  IMultiDict<K, V> slice(int from, int until) => IMultiDict.from(super.slice(from, until));

  @override
  RIterator<IMultiDict<K, V>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(IMultiDict.from);

  @override
  (IMultiDict<K, V>, IMultiDict<K, V>) span(Function1<(K, V), bool> p) {
    final (first, second) = super.span(p);
    return (IMultiDict.from(first), IMultiDict.from(second));
  }

  @override
  (IMultiDict<K, V>, IMultiDict<K, V>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (IMultiDict.from(first), IMultiDict.from(second));
  }

  @override
  IMultiDict<K, V> get tail => IMultiDict.from(super.tail);

  @override
  RIterator<IMultiDict<K, V>> get tails => super.tails.map(IMultiDict.from);

  @override
  IMultiDict<K, V> take(int n) => IMultiDict.from(super.take(n));

  @override
  IMultiDict<K, V> takeRight(int n) => IMultiDict.from(super.takeRight(n));

  @override
  IMultiDict<K, V> takeWhile(Function1<(K, V), bool> p) => IMultiDict.from(super.takeWhile(p));

  @override
  IMultiDict<K, V> tapEach<U>(Function1<(K, V), U> f) {
    foreach(f);
    return this;
  }
}
