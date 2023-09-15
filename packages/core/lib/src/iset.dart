import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_core/ribs_core.dart';

ISet<A> iset<A>(Iterable<A> as) => ISet.of(as);

// This is a thin wrapper around the FIC ISet, which is a tremendous immutable
// set implementation. This exists only because I want a particular Set API
// to make porting libraries easier, and I'm stubborn
final class ISet<A> {
  final fic.ISet<A> _underlying;

  ISet._(this._underlying);

  static ISet<A> fromIList<A>(IList<A> items) =>
      ISet._(fic.ISet(items.toList()));

  static ISet<A> of<A>(Iterable<A> items) => ISet._(fic.ISet(items));

  static ISet<A> fromSet<A>(Set<A> items) => of(items);

  ISet<A> operator +(A a) => incl(a);

  ISet<A> operator -(A a) => excl(a);

  bool call(A elem) => contains(elem);

  bool contains(A elem) => _underlying.contains(elem);

  ISet<A> concat(IList<A> items) => ISet._(_underlying.addAll(items.toList()));

  int count(Function1<A, bool> p) => filter(p).size;

  ISet<A> diff(ISet<A> that) =>
      ISet._(_underlying.difference(that._underlying));

  ISet<A> excl(A elem) => ISet._(_underlying.remove(elem));

  bool exists(Function1<A, bool> p) => _underlying.any(p);

  ISet<A> filter(Function1<A, bool> p) => ISet.of(_underlying.where(p));

  ISet<A> filterNot(Function1<A, bool> p) =>
      ISet.of(_underlying.where((e) => !p(e)));

  Option<A> find(Function1<A, bool> p) => toIList().find(p);

  ISet<B> flatMap<B>(Function1<A, Iterable<B>> f) =>
      ISet.of(_underlying.expand(f));

  B fold<B>(B init, Function2<B, A, B> op) => _underlying.fold(init, op);

  bool forall(Function1<A, bool> p) => _underlying.every(p);

  void forEach<B>(Function1<A, B> f) => _underlying.forEach(f);

  IMap<K, ISet<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, id);

  IMap<K, ISet<V>> groupMap<K, V>(
    Function1<A, K> key,
    Function1<A, V> value,
  ) =>
      fold(
        IMap.empty<K, ISet<V>>(),
        (acc, a) => acc.updatedWith(
          key(a),
          (prev) =>
              prev.map((l) => l + value(a)).orElse(() => iset([value(a)]).some),
        ),
      );

  ISet<A> incl(A elem) => ISet._(_underlying.add(elem));

  bool get isEmpty => _underlying.isEmpty;

  bool get isNotEmpty => _underlying.isNotEmpty;

  int get length => _underlying.length;

  ISet<B> map<B>(Function1<A, B> f) => ISet.of(_underlying.map(f));

  String mkString({String? start, required String sep, String? end}) =>
      toIList().mkString(start: start, sep: sep, end: end);

  bool get nonEmpty => _underlying.isNotEmpty;

  Option<A> reduceOption(Function2<A, A, A> f) => toIList().reduceOption(f);

  ISet<A> removedAll(Iterable<A> that) => ISet._(_underlying.removeAll(that));

  int get size => _underlying.length;

  bool subsetOf(ISet<A> that) => that.forall(contains);

  IList<A> toIList() => IList.of(_underlying.toList());

  List<A> toList() => _underlying.toList();
}

extension ISetNestedOps<A> on ISet<ISet<A>> {
  ISet<A> flatten() => fold(iset({}), (z, a) => z.concat(a.toIList()));
}

extension ISetTuple2Ops<A, B> on ISet<(A, B)> {
  ISet<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  ISet<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  ISet<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  IMap<A, B> toIMap() => IMap.fromIList(toIList());

  Map<A, B> toMap() => Map.fromEntries(mapN((k, v) => MapEntry(k, v)).toList());
}
