import 'package:ribs_core/ribs_core.dart';

extension IListNestedOps<A> on IList<IList<A>> {
  /// Combines all nested lists into one list using concatenation.
  IList<A> flatten() => foldLeft(nil<A>(), (z, a) => z.concat(a));
}

extension IListEitherOps<A, B> on IList<Either<A, B>> {
  Either<A, IList<B>> sequence() => traverseEither(identity);

  /// Returns 2 new lists as a tuple. The first list is all the [Left] items
  /// from each element of this list. The second list is all the [Right] items
  /// from each element of this list.
  (IList<A>, IList<B>) unzip() {
    final a1s = List<A>.empty(growable: true);
    final a2s = List<B>.empty(growable: true);

    forEach((elem) => elem.fold((a1) => a1s.add(a1), (a2) => a2s.add(a2)));

    return (ilist(a1s), ilist(a2s));
  }
}

/// Operations avaiable when [IList] elements are of type [IO].
extension IListIOOps<A> on IList<IO<A>> {
  /// Alias for [traverseIO], using [identity] as the function parameter.
  IO<IList<A>> sequence() => traverseIO(identity);

  /// Alias for [traverseIO_], using [identity] as the function parameter.
  IO<Unit> sequence_() => traverseIO_(identity);

  /// Alias for [parTraverseIO], using [identity] as the function parameter.
  IO<IList<A>> parSequence() => parTraverseIO(identity);

  /// Alias for [parTraverseIO_], using [identity] as the function parameter.
  IO<Unit> parSequence_() => parTraverseIO_(identity);
}

/// Operations avaiable when [IList] elements are of type [Option].
extension IListOptionOps<A> on IList<Option<A>> {
  /// Accumulates all elements in this list as one [Option]. If any element is
  /// a [None], [None] will be returned. If all elements are [Some], then the
  /// entire list is returned, wrapped in a [Some].
  Option<IList<A>> sequence() => traverseOption(identity);

  /// Returns a new list with all [None] elements removed.
  IList<A> unNone() => foldLeft(
      nil(), (acc, elem) => elem.fold(() => acc, (a) => acc.append(a)));
}

/// Operations avaiable when [IList] elements are nullable.
extension IListNullableOps<A> on IList<A?> {
  /// Returns a new list with all null elements removed.
  IList<A> noNulls() => foldLeft(
      nil(), (acc, elem) => Option(elem).fold(() => acc, (a) => acc.append(a)));
}

extension IListComparableOps<A extends Comparable<dynamic>> on IList<A> {
  /// Returns the maximum item in this list as defined by the behavior of this
  /// element types [Comparable] implementation. If the list is empty, [None]
  /// is returned.
  Option<A> maxOption() => headOption.map((hd) =>
      tail().foldLeft(hd, (acc, elem) => acc.compareTo(elem) > 0 ? acc : elem));

  /// Returns the minimum item in this list as defined by the behavior of this
  /// element types [Comparable] implementation. If the list is empty, [None]
  /// is returned.
  Option<A> minOption() => headOption.map((hd) =>
      tail().foldLeft(hd, (acc, elem) => acc.compareTo(elem) < 0 ? acc : elem));

  /// Returns a new list with all elements sorted from least to greatest
  /// according to the implementation of this [Comparable].
  IList<A> sorted() => sortWith((a, b) => a.compareTo(b) < 0);
}

extension IListIntOps on IList<int> {
  /// Returns the sum of all elements in this list
  int sum() => foldLeft(0, (a, b) => a + b);

  /// Returns the product of all elements in this list
  int product() => foldLeft(1, (a, b) => a * b);
}

extension IListDoubleOps on IList<double> {
  /// Returns the sum of all elements in this list
  double sum() => foldLeft(0, (a, b) => a + b);

  /// Returns the product of all elements in this list
  double product() => foldLeft(1, (a, b) => a * b);
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension IListTuple2Ops<A, B> on IList<(A, B)> {
  /// {@macro ilist_collect}
  IList<C> collectN<C>(Function2<A, B, Option<C>> f) => map(f.tupled).unNone();

  /// {@macro ilist_collectFirst}
  Option<C> collectFirstN<C>(Function2<A, B, Option<C>> f) =>
      collectFirst(f.tupled);

  /// {@macro ilist_deleteFirst}
  Option<((A, B), IList<(A, B)>)> deleteFirstN(Function2<A, B, bool> p) =>
      deleteFirst(p.tupled);

  /// {@macro ilist_dropWhile}
  IList<(A, B)> dropWhileN(Function2<A, B, bool> p) => dropWhile(p.tupled);

  /// {@macro ilist_filter}
  IList<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  /// {@macro ilist_filterNot}
  IList<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  /// {@macro ilist_find}
  Option<(A, B)> findN(Function2<A, B, bool> p) => find(p.tupled);

  /// {@macro ilist_findLast}
  Option<(A, B)> findLastN(Function2<A, B, bool> p) => findLast(p.tupled);

  /// {@macro ilist_flatMap}
  IList<C> flatMapN<C>(Function2<A, B, IList<C>> f) => flatMap(f.tupled);

  /// {@macro ilist_foldLeft}
  C foldLeftN<C>(C init, Function3<C, A, B, C> op) =>
      foldLeft(init, (acc, elem) => op(acc, elem.$1, elem.$2));

  /// {@macro ilist_foldRight}
  C foldRightN<C>(C init, Function3<A, B, C, C> op) =>
      foldRight(init, (elem, acc) => op(elem.$1, elem.$2, acc));

  /// {@macro ilist_forEach}
  void forEachN<C>(Function2<A, B, C> f) => forEach(f.tupled);

  /// {@macro ilist_groupBy}
  IMap<K, IList<(A, B)>> groupByN<K>(Function2<A, B, K> f) =>
      groupMap(f.tupled, identity);

  /// {@macro ilist_groupMap}
  IMap<K, IList<V>> groupMapN<K, V>(
    Function2<A, B, K> key,
    Function2<A, B, V> value,
  ) =>
      groupMap(key.tupled, value.tupled);

  /// {@macro ilist_indexWhere}
  Option<int> indexWhereN(Function2<A, B, bool> p) => indexWhere(p.tupled);

  /// {@macro ilist_lastIndexWhere}
  Option<int> lastIndexWhereN(Function2<A, B, bool> p) =>
      lastIndexWhere(p.tupled);

  /// {@macro ilist_map}
  IList<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  /// {@macro ilist_partition}
  (IList<(A, B)>, IList<(A, B)>) partitionN(Function2<A, B, bool> p) =>
      partition(p.tupled);

  /// {@macro ilist_partitionMap}
  (IList<A1>, IList<A2>) partitionMapN<A1, A2>(
          Function2<A, B, Either<A1, A2>> f) =>
      partitionMap(f.tupled);

  /// {@macro ilist_removeFirst}
  IList<(A, B)> removeFirstN(Function2<A, B, bool> p) => removeFirst(p.tupled);

  /// {@macro ilist_takeWhile}
  IList<(A, B)> takeWhileN(Function2<A, B, bool> p) => takeWhile(p.tupled);

  /// {@macro ilist_tapEach}
  IList<(A, B)> tapEachN<U>(Function2<A, B, U> f) => tapEach(f.tupled);

  /// Creates a new [IMap] where element tuple element of this list is used to
  /// create a key and value respectively.
  IMap<A, B> toIMap() => IMap.fromIList(this);

  /// Creates a new [Map] where element tuple element of this list is used to
  /// create a key and value respectively.
  Map<A, B> toMap() => Map.fromEntries(mapN((k, v) => MapEntry(k, v)).toList());

  /// {@macro ilist_traverseEither}
  Either<C, IList<D>> traverseEitherN<C, D>(Function2<A, B, Either<C, D>> f) =>
      traverseEither(f.tupled);

  /// {@macro ilist_traverseIO}
  IO<IList<C>> traverseION<C>(Function2<A, B, IO<C>> f) => traverseIO(f.tupled);

  /// {@macro ilist_traverseIO_}
  IO<Unit> traverseION_<C>(Function2<A, B, IO<C>> f) => traverseIO_(f.tupled);

  /// {@macro ilist_traverseFilterIO}
  IO<IList<C>> traverseFilterION<C>(Function2<A, B, IO<Option<C>>> f) =>
      traverseFilterIO(f.tupled);

  /// {@macro ilist_parTraverseIO}
  IO<IList<C>> parTraverseION<C>(Function2<A, B, IO<C>> f) =>
      parTraverseIO(f.tupled);

  /// {@macro ilist_parTraverseIO_}
  IO<Unit> parTraverseION_<C>(Function2<A, B, IO<C>> f) =>
      parTraverseIO_(f.tupled);

  /// {@macro ilist_traverseOption}
  Option<IList<C>> traverseOptionN<C>(Function2<A, B, Option<C>> f) =>
      traverseOption(f.tupled);

  /// {@macro ilist_updated}
  IList<(A, B)> updatedN(int index, Function2<A, B, (A, B)> f) =>
      updated(index, f.tupled);

  /// Returns 2 new lists as a tuple. The first list is all the first items
  /// from each tuple element of this list. The second list is all the second
  /// items from each tuple element of this list.
  (IList<A>, IList<B>) unzip() => foldLeft((nil<A>(), nil<B>()),
      (acc, ab) => (acc.$1.append(ab.$1), acc.$2.append(ab.$2)));
}

extension IListTuple3Ops<A, B, C> on IList<(A, B, C)> {
  /// {@macro ilist_collect}
  IList<D> collectN<D>(Function3<A, B, C, Option<D>> f) =>
      map(f.tupled).unNone();

  /// {@macro ilist_collectFirst}
  Option<D> collectFirstN<D>(Function3<A, B, C, Option<D>> f) =>
      collectFirst(f.tupled);

  /// {@macro ilist_deleteFirst}
  Option<((A, B, C), IList<(A, B, C)>)> deleteFirstN(
          Function3<A, B, C, bool> p) =>
      deleteFirst(p.tupled);

  /// {@macro ilist_dropWhile}
  IList<(A, B, C)> dropWhileN(Function3<A, B, C, bool> p) =>
      dropWhile(p.tupled);

  /// {@macro ilist_filter}
  IList<(A, B, C)> filterN(Function3<A, B, C, bool> p) => filter(p.tupled);

  /// {@macro ilist_filterNot}
  IList<(A, B, C)> filterNotN(Function3<A, B, C, bool> p) =>
      filterNot(p.tupled);

  /// {@macro ilist_find}
  Option<(A, B, C)> findN(Function3<A, B, C, bool> p) => find(p.tupled);

  /// {@macro ilist_findLast}
  Option<(A, B, C)> findLastN(Function3<A, B, C, bool> p) => findLast(p.tupled);

  /// {@macro ilist_flatMap}
  IList<D> flatMapN<D>(Function3<A, B, C, IList<D>> f) => flatMap(f.tupled);

  /// {@macro ilist_foldLeft}
  D foldLeftN<D>(D init, Function4<D, A, B, C, D> op) =>
      foldLeft(init, (acc, elem) => op(acc, elem.$1, elem.$2, elem.$3));

  /// {@macro ilist_foldRight}
  D foldRightN<D>(D init, Function4<A, B, C, D, D> op) =>
      foldRight(init, (elem, acc) => op(elem.$1, elem.$2, elem.$3, acc));

  /// {@macro ilist_forEach}
  void forEachN<D>(Function3<A, B, C, D> f) => forEach(f.tupled);

  /// {@macro ilist_groupBy}
  IMap<K, IList<(A, B, C)>> groupByN<K>(Function3<A, B, C, K> f) =>
      groupMap(f.tupled, identity);

  /// {@macro ilist_groupMap}
  IMap<K, IList<V>> groupMapN<K, V>(
    Function3<A, B, C, K> key,
    Function3<A, B, C, V> value,
  ) =>
      groupMap(key.tupled, value.tupled);

  /// {@macro ilist_indexWhere}
  Option<int> indexWhereN(Function3<A, B, C, bool> p) => indexWhere(p.tupled);

  /// {@macro ilist_map}
  IList<D> mapN<D>(Function3<A, B, C, D> f) => map(f.tupled);

  /// {@macro ilist_partition}
  (IList<(A, B, C)>, IList<(A, B, C)>) partitionN(Function3<A, B, C, bool> p) =>
      partition(p.tupled);

  /// {@macro ilist_partitionMap}
  (IList<A1>, IList<A2>) partitionMapN<A1, A2>(
          Function3<A, B, C, Either<A1, A2>> f) =>
      partitionMap(f.tupled);

  /// {@macro ilist_removeFirst}
  IList<(A, B, C)> removeFirstN(Function3<A, B, C, bool> p) =>
      removeFirst(p.tupled);

  /// {@macro ilist_takeWhile}
  IList<(A, B, C)> takeWhileN(Function3<A, B, C, bool> p) =>
      takeWhile(p.tupled);

  /// {@macro ilist_tapEach}
  IList<(A, B, C)> tapEachN<U>(Function3<A, B, C, U> f) => tapEach(f.tupled);

  /// {@macro ilist_traverseEither}
  Either<D, IList<E>> traverseEitherN<D, E>(
          Function3<A, B, C, Either<D, E>> f) =>
      traverseEither(f.tupled);

  /// {@macro ilist_traverseIO}
  IO<IList<D>> traverseION<D>(Function3<A, B, C, IO<D>> f) =>
      traverseIO(f.tupled);

  /// {@macro ilist_traverseIO_}
  IO<Unit> traverseION_<D>(Function3<A, B, C, IO<D>> f) =>
      traverseIO_(f.tupled);

  /// {@macro ilist_traverseFilterIO}
  IO<IList<D>> traverseFilterION<D>(Function3<A, B, C, IO<Option<D>>> f) =>
      traverseFilterIO(f.tupled);

  /// {@macro ilist_parTraverseIO}
  IO<IList<D>> parTraverseION<D>(Function3<A, B, C, IO<D>> f) =>
      parTraverseIO(f.tupled);

  /// {@macro ilist_parTraverseIO_}
  IO<Unit> parTraverseION_<D>(Function3<A, B, C, IO<D>> f) =>
      parTraverseIO_(f.tupled);

  /// {@macro ilist_traverseOption}
  Option<IList<D>> traverseOptionN<D>(Function3<A, B, C, Option<D>> f) =>
      traverseOption(f.tupled);

  /// {@macro ilist_updated}
  IList<(A, B, C)> updatedN(int index, Function3<A, B, C, (A, B, C)> f) =>
      updated(index, f.tupled);

  /// Returns 3 new lists as a tuple. The first list is all the first items
  /// from each tuple element of this list. The second list is all the second
  /// items from each tuple element of this list. The third list is all the
  /// third items from each tuple element of this list.
  (IList<A>, IList<B>, IList<C>) unzip() => foldLeft(
        (nil<A>(), nil<B>(), nil<C>()),
        (acc, abc) => (
          acc.$1.append(abc.$1),
          acc.$2.append(abc.$2),
          acc.$3.append(abc.$3)
        ),
      );
}
