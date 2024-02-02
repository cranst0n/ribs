import 'package:ribs_core/ribs_core.dart';

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

extension IListTuple2Ops<A, B> on IList<(A, B)> {
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
