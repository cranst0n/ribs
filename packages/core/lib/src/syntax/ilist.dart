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

    foreach((elem) => elem.fold((a1) => a1s.add(a1), (a2) => a2s.add(a2)));

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
      nil(), (acc, elem) => elem.fold(() => acc, (a) => acc.appended(a)));
}

/// Operations avaiable when [IList] elements are nullable.
extension IListNullableOps<A> on IList<A?> {
  /// Returns a new list with all null elements removed.
  IList<A> noNulls() => foldLeft(nil(),
      (acc, elem) => Option(elem).fold(() => acc, (a) => acc.appended(a)));
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

extension IListTuple2Ops<A, B> on IList<(A, B)> {
  /// Creates a new [IMap] where element tuple element of this list is used to
  /// create a key and value respectively.
  IMap<A, B> toIMap() => IMap.from(this);

  /// Creates a new [Map] where element tuple element of this list is used to
  /// create a key and value respectively.
  Map<A, B> toMap() =>
      Map.fromEntries(map((kv) => MapEntry(kv.$1, kv.$2)).toList());

  /// Returns 2 new lists as a tuple. The first list is all the first items
  /// from each tuple element of this list. The second list is all the second
  /// items from each tuple element of this list.
  (IList<A>, IList<B>) unzip() => foldLeft((nil<A>(), nil<B>()),
      (acc, ab) => (acc.$1.appended(ab.$1), acc.$2.appended(ab.$2)));
}

extension IListTuple3Ops<A, B, C> on IList<(A, B, C)> {
  /// Returns 3 new lists as a tuple. The first list is all the first items
  /// from each tuple element of this list. The second list is all the second
  /// items from each tuple element of this list. The third list is all the
  /// third items from each tuple element of this list.
  (IList<A>, IList<B>, IList<C>) unzip() => foldLeft(
        (nil<A>(), nil<B>(), nil<C>()),
        (acc, abc) => (
          acc.$1.appended(abc.$1),
          acc.$2.appended(abc.$2),
          acc.$3.appended(abc.$3)
        ),
      );
}
