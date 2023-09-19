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

  /// Creates a new set from the given [items], with duplicates removed.
  static ISet<A> fromIList<A>(IList<A> items) =>
      ISet._(fic.ISet(items.toList()));

  /// Creates a new set from the given [items], with duplicates removed.
  static ISet<A> of<A>(Iterable<A> items) => ISet._(fic.ISet(items));

  /// Creates a new set from the given [Set] [s].
  static ISet<A> fromSet<A>(Set<A> s) => of(s);

  /// Creates a new set with an additonal element [a].
  ISet<A> operator +(A a) => incl(a);

  /// Creates a new set with the item [a] removed.
  ISet<A> operator -(A a) => excl(a);

  /// Alias for [contains].
  bool call(A elem) => contains(elem);

  /// Returns true if this set contains [elem], false otherwise.
  bool contains(A elem) => _underlying.contains(elem);

  /// Returns a new set with the elements from this set and the elements from
  /// [items].
  ISet<A> concat(IList<A> items) => ISet._(_underlying.addAll(items.toList()));

  /// Return the number of elements in this set that satisfy the given
  /// predicate.
  int count(Function1<A, bool> p) => filter(p).size;

  /// Returns the diffence of this set and [that].
  ISet<A> diff(ISet<A> that) =>
      ISet._(_underlying.difference(that._underlying));

  /// Returns a new set with [elem] removed.
  ISet<A> excl(A elem) => ISet._(_underlying.remove(elem));

  /// Returns true if **any** element of this set satisfies the given
  /// predicate, false if no elements satisfy it.
  bool exists(Function1<A, bool> p) => _underlying.any(p);

  /// Returns a new set with all elements from this set that satisfy the
  /// given predicate [p].
  ISet<A> filter(Function1<A, bool> p) => ISet.of(_underlying.where(p));

  /// Returns a new set with all elements from this set that do not satisfy the
  /// given predicate [p].
  ISet<A> filterNot(Function1<A, bool> p) =>
      ISet.of(_underlying.where((e) => !p(e)));

  /// Returns the first element from this set that satisfies the given
  /// predicate [p]. If no element satisfies [p], [None] is returned.
  Option<A> find(Function1<A, bool> p) => toIList().find(p);

  /// Applies [f] to each element of this set, and returns a new set that
  /// concatenates all of the results.
  ISet<B> flatMap<B>(Function1<A, Iterable<B>> f) =>
      ISet.of(_underlying.expand(f));

  /// Returns a summary value by applying the given binary operator to the
  /// [init] and all values of this set.
  B fold<B>(B init, Function2<B, A, B> op) => _underlying.fold(init, op);

  /// Returns true if **all** elements of this set satisfy the given
  /// predicate, false if any elements do not.
  bool forall(Function1<A, bool> p) => _underlying.every(p);

  /// Applies [f] to each element of this set, discarding any resulting values.
  void forEach<B>(Function1<A, B> f) => _underlying.forEach(f);

  /// Partitions all elements of this set by applying [f] to each element
  /// and accumulating duplicate keys in the returned [IMap].
  IMap<K, ISet<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, id);

  /// Creates a new map by generating a key-value pair for each elements of this
  /// set using [key] and [value]. Any elements that generate the same key will
  /// have the resulting values accumulated in the returned map.
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

  /// Creates a new set with an additonal element [a].
  ISet<A> incl(A elem) => ISet._(_underlying.add(elem));

  /// Returns true if this set has no elements, false otherwise.
  bool get isEmpty => _underlying.isEmpty;

  /// Returns true if this list has any elements, false otherwise.
  bool get isNotEmpty => _underlying.isNotEmpty;

  /// Returns the number of elements in this set.
  int get length => _underlying.length;

  /// Returns a new set where each new element is the result of applying [f]
  /// to the original element from this set.
  ISet<B> map<B>(Function1<A, B> f) => ISet.of(_underlying.map(f));

  /// Returns a [String] by using each elements [toString()], adding [sep]
  /// between each element. If [start] is defined, it will be prepended to the
  /// resulting string. If [end] is defined, it will be appended to the
  /// resulting string.
  String mkString({String? start, required String sep, String? end}) =>
      toIList().mkString(start: start, sep: sep, end: end);

  /// Returns true if this list has any elements, false otherwise.
  bool get nonEmpty => _underlying.isNotEmpty;

  /// Returns a summary values of all elements of this set by applying [f] to
  /// each element.
  ///
  /// If this set is empty, [None] will be returned.
  Option<A> reduceOption(Function2<A, A, A> f) => toIList().reduceOption(f);

  /// Returns a new set where all elements of [that] are removed.
  ISet<A> removedAll(Iterable<A> that) => ISet._(_underlying.removeAll(that));

  /// Returns the number of elements in this set.
  int get size => _underlying.length;

  /// Returns true if every elements of this set is present in [that].
  bool subsetOf(ISet<A> that) => that.forall(contains);

  /// Returns a new [IList] with all elements from this set.
  IList<A> toIList() => IList.of(_underlying.toList());

  /// Returns a new [List] with all elements from this set.
  List<A> toList() => _underlying.toList();
}

extension ISetNestedOps<A> on ISet<ISet<A>> {
  /// Combines all nested set into one set using concatenation.
  ISet<A> flatten() => fold(iset({}), (z, a) => z.concat(a.toIList()));
}

// Until lambda destructuring arrives, this will provide a little bit
// of convenience: https://github.com/dart-lang/language/issues/3001
extension ISetTuple2Ops<A, B> on ISet<(A, B)> {
  ISet<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  ISet<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  ISet<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  IMap<A, B> toIMap() => IMap.fromIList(toIList());

  Map<A, B> toMap() => Map.fromEntries(mapN((k, v) => MapEntry(k, v)).toList());
}
