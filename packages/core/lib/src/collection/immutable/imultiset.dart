import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

/// Creates an [IMultiSet] from a Dart [Iterable].
///
/// ```dart
/// final ms = imultiset([1, 1, 2, 3]);
/// ms.occurrences.get(1); // Some(2)
/// ```
IMultiSet<A> imultiset<A>(Iterable<A> as) => IMultiSet.fromDartIterable(as);

/// An immutable multiset (bag): a set where elements may appear multiple times.
///
/// Backed by an [IMap] from element to occurrence count. Access counts via
/// [occurrences]; add with [incl] / `+`; remove one occurrence with
/// [excl] / `-`.
///
/// ```dart
/// final ms = imultiset([1, 1, 2]);
/// (ms + 3).occurrences; // IMap(1→2, 2→1, 3→1)
/// (ms - 1).occurrences; // IMap(1→1, 2→1)
/// ```
@immutable
final class IMultiSet<A> with RIterableOnce<A>, RIterable<A>, RMultiSet<A> {
  final IMap<A, int> _elems;

  IMultiSet._(this._elems);

  /// Returns an empty [IMultiSet].
  static IMultiSet<A> empty<A>() => IMultiSet._(IMap.empty());

  /// Creates an [IMultiSet] from any [RIterableOnce].
  ///
  /// Returns [elems] directly when it is already an [IMultiSet].
  static IMultiSet<A> from<A>(RIterableOnce<A> elems) => switch (elems) {
    final IMultiSet<A> ms => ms,
    _ => IMultiSet._(elems.toIList().groupMapReduce(identity, (_) => 1, (a, b) => a + b)),
  };

  /// Creates an [IMultiSet] from an iterable of `(element, count)` pairs.
  static IMultiSet<A> fromOccurences<A>(RIterableOnce<(A, int)> elems) => switch (elems) {
    final IMultiSet<A> ms => ms,
    _ => from(elems.flatMap((occ) => views.Fill(occ.$2, occ.$1))),
  };

  /// Creates an [IMultiSet] from a Dart [Iterable].
  static IMultiSet<A> fromDartIterable<A>(Iterable<A> elems) =>
      IMultiSet.from(RIterator.fromDart(elems.iterator));

  /// Returns a new multiset with one additional occurrence of [elem].
  IMultiSet<A> operator +(A elem) => incl(elem);

  /// Returns a new multiset with one fewer occurrence of [elem].
  ///
  /// Has no effect if [elem] is not present.
  IMultiSet<A> operator -(A elem) => excl(elem);

  @override
  IMultiSet<B> collect<B>(Function1<A, Option<B>> f) => IMultiSet.from(super.collect(f));

  @override
  IMultiSet<A> concat(RIterableOnce<A> suffix) => IMultiSet.from(iterator.concat(suffix.iterator));

  @override
  IMultiSet<A> concatOccurences(RIterable<(A, int)> that) => IMultiSet.fromOccurences(that);

  @override
  IMultiSet<A> drop(int n) => IMultiSet.from(super.drop(n));

  @override
  IMultiSet<A> dropRight(int n) => IMultiSet.from(super.dropRight(n));

  @override
  IMultiSet<A> dropWhile(Function1<A, bool> p) => IMultiSet.from(super.dropWhile(p));

  /// Returns a new multiset with one fewer occurrence of [elem].
  ///
  /// Removes the key entirely when its count would drop to zero.
  IMultiSet<A> excl(A elem) => IMultiSet._(
    _elems.updatedWith(
      elem,
      (n) => n.fold(
        () => none(),
        (n) => n > 1 ? Some(n - 1) : none(),
      ),
    ),
  );

  @override
  IMultiSet<A> filter(Function1<A, bool> p) => IMultiSet.from(super.filter(p));

  @override
  IMultiSet<A> filterNot(Function1<A, bool> p) => IMultiSet.from(super.filterNot(p));

  @override
  IMultiSet<A> filterOccurences(Function1<(A, int), bool> p) =>
      IMultiSet.fromOccurences(views.Filter(occurrences, p, false));

  @override
  IMultiSet<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) => IMultiSet.from(super.flatMap(f));

  @override
  IMultiSet<B> flatMapOccurences<B>(
    Function1<(A, int), RIterableOnce<(B, int)>> f,
  ) => IMultiSet.fromOccurences(views.FlatMap(occurrences, f));

  @override
  IMap<K, IMultiSet<A>> groupBy<K>(Function1<A, K> f) => super.groupBy(f).mapValues(IMultiSet.from);

  @override
  IMap<K, IMultiSet<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) => super.groupMap(key, f).mapValues(IMultiSet.from);

  @override
  RIterator<IMultiSet<A>> grouped(int size) => super.grouped(size).map(IMultiSet.from);

  /// Returns a new multiset with one additional occurrence of [elem].
  IMultiSet<A> incl(A elem) =>
      IMultiSet._(_elems.updatedWith(elem, (n) => Some(n.fold(() => 1, (n) => n + 1))));

  @override
  IMultiSet<A> get init => IMultiSet.from(super.init);

  @override
  RIterator<IMultiSet<A>> get inits => super.inits.map(IMultiSet.from);

  @override
  IMultiSet<B> map<B>(Function1<A, B> f) => IMultiSet.from(iterator.map(f));

  @override
  IMultiSet<B> mapOccurences<B>(Function1<(A, int), (B, int)> f) =>
      IMultiSet.fromOccurences(views.Map<(A, int), (B, int)>(occurrences, f));

  @override
  RMap<A, int> get occurrences => _elems;

  @override
  (IMultiSet<A>, IMultiSet<A>) partition(Function1<A, bool> p) {
    final (first, second) = super.partition(p);
    return (IMultiSet.from(first), IMultiSet.from(second));
  }

  @override
  (RIterable<A1>, RIterable<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (first, second) = super.partitionMap(f);
    return (IMultiSet.from(first), IMultiSet.from(second));
  }

  @override
  IMultiSet<A> slice(int from, int until) => IMultiSet.from(super.slice(from, until));

  @override
  RIterator<IMultiSet<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(IMultiSet.from);

  @override
  (IMultiSet<A>, IMultiSet<A>) span(Function1<A, bool> p) {
    final (first, second) = super.span(p);
    return (IMultiSet.from(first), IMultiSet.from(second));
  }

  @override
  (IMultiSet<A>, IMultiSet<A>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (IMultiSet.from(first), IMultiSet.from(second));
  }

  @override
  IMultiSet<A> get tail => IMultiSet.from(super.tail);

  @override
  RIterator<IMultiSet<A>> get tails => super.tails.map(IMultiSet.from);

  @override
  IMultiSet<A> take(int n) => IMultiSet.from(super.take(n));

  @override
  IMultiSet<A> takeRight(int n) => IMultiSet.from(super.takeRight(n));

  @override
  IMultiSet<A> takeWhile(Function1<A, bool> p) => IMultiSet.from(super.takeWhile(p));

  @override
  IMultiSet<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  IMultiSet<(A, B)> zip<B>(RIterableOnce<B> that) => IMultiSet.from(super.zip(that));

  @override
  IMultiSet<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      IMultiSet.from(super.zipAll(that, thisElem, thatElem));

  @override
  IMultiSet<(A, int)> zipWithIndex() => IMultiSet.from(super.zipWithIndex());
}
