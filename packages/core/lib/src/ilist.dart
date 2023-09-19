import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_core/ribs_core.dart';

IList<A> ilist<A>(Iterable<A> as) => IList.of(as);
IList<A> nil<A>() => IList.empty();

/// An immutable ordered list of elements.
///
/// You may ask why does this exist. Seems like it's just a wrapper around a FIC
/// IList. The original IList implementation, while pure, had terrible
/// performance so was replaced with this version. To ease the migration and keep
/// the API the same, this is what was created. Much credit to the FIC folks for
/// building a useful and performant IList.
final class IList<A> implements Monad<A>, Foldable<A> {
  final fic.IList<A> _underlying;

  const IList._(this._underlying);

  /// Creates the empty list.
  const IList.nil() : _underlying = const fic.IListConst([]);

  /// Create an empty list.
  static IList<A> empty<A>() => IList.of([]);

  /// Creates an IList of size [n] where each element is set to [elem].
  static IList<A> fill<A>(int n, A elem) => IList.tabulate(n, (_) => elem);

  /// Creates an IList from the given [Iterable].
  static IList<A> of<A>(Iterable<A> it) => IList._(fic.IList(it));

  /// Creates an IList with a single element, [a];
  static IList<A> pure<A>(A a) => IList.of([a]);

  /// Creates an IList where elements are every integer from [start] (inclusive)
  /// to [end] (exclusive).
  static IList<int> range(int start, int end) =>
      tabulate(end - start, (ix) => ix + start);

  /// Create an IList of size [n] and sets the element at each index by
  /// invoking [f] and passing the index.
  static IList<A> tabulate<A>(int n, Function1<int, A> f) =>
      IList.of(List.generate(n, f));

  /// Returns the element at the given index or throws a [RangeError] if the
  /// index is out of the bounds of this list.
  A operator [](int ix) => _underlying[ix];

  /// Alias for [append]
  IList<A> operator +(A a) => append(a);

  /// Alias for [removeFirst]
  IList<A> operator -(A a) => removeFirst((x) => x == a);

  /// Applies the list of functions [f] to each element of this list and
  /// returns all values as an IList.
  @override
  IList<B> ap<B>(covariant IList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  /// Returns a copy of this IList, with the given [elem] added to the end.
  IList<A> append(A elem) => IList.of(_underlying.add(elem));

  /// Returns a copy of this IList, with [elems] added to the end.
  IList<A> concat(IList<A> elems) =>
      IList._(_underlying.addAll(elems._underlying));

  /// Returns true, if any element of this list equals [elem].
  bool contains(A elem) => _underlying.contains(elem);

  /// {@template ilist_deleteFirst}
  /// Attempts to find the first element that satifies the given predicate [p].
  /// If an element is found:
  ///   returns a tuple containing the element that was removed and the new
  ///   IList with the element removed.
  /// If an element is not found:
  ///   returns [None].
  /// {@endtemplate}
  Option<(A, IList<A>)> deleteFirst(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return Option.when(
      () => ix >= 0,
      () => (_underlying[ix], IList.of(_underlying.removeAt(ix))),
    );
  }

  /// Returns a new IList where every element is distinct according to
  /// equality.
  IList<A> distinct() => IList.of(foldLeft<List<A>>(
        List<A>.empty(growable: true),
        (acc, elem) => acc.contains(elem) ? acc : (acc..add(elem)),
      ));

  /// Returns a new IList with the first [n] elements removed. If [n] is
  /// greater than or equal to the number of elements in this list, an
  /// empty IList is returned.
  IList<A> drop(int n) => IList.of(_underlying.skip(n));

  /// Return a new IList with the last [n] elements of this list removed.
  IList<A> dropRight(int n) => take(size - n);

  /// {@template ilist_dropWhile}
  /// Returns a new IList with the longest prefix of elements from this list
  /// that satisfy the given predicate [p] removed.
  /// {@endtemplate}
  IList<A> dropWhile(Function1<A, bool> p) =>
      IList.of(_underlying.skipWhile(p));

  /// {@template ilist_filter}
  /// Returns a new IList with all elements from this list that satisfy the
  /// given predicate [p].
  /// {@endtemplate}
  IList<A> filter(Function1<A, bool> p) => IList.of(_underlying.where(p));

  /// {@template ilist_filterNot}
  /// Returns a new IList with all elements from this list that **do not**
  /// satisfy the given predicate [p].
  /// {@endtemplate}
  IList<A> filterNot(Function1<A, bool> p) => IList.of(_underlying.whereNot(p));

  /// {@template ilist_find}
  /// Returns the first element from this list that satisfies the given
  /// predicate [p]. If no element satisfies [p], [None] is returned.
  /// {@endtemplate}
  Option<A> find(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return Option.when(() => ix >= 0, () => _underlying[ix]);
  }

  /// {@template ilist_findLast}
  /// Returns the last element from this list that satisfies the given
  /// predicate [p]. If no element satisfies [p], [None] is returned.
  /// {@endtemplate}
  Option<A> findLast(Function1<A, bool> p) {
    final ix = _underlying.lastIndexWhere(p);
    return Option.when(() => ix >= 0, () => _underlying[ix]);
  }

  /// {@template ilist_flatMap}
  /// Applies [f] to each element of this list, and returns a new list that
  /// concatenates all of the results.
  /// {@endtemplate}
  @override
  IList<B> flatMap<B>(covariant Function1<A, IList<B>> f) =>
      of(_underlying.expand((a) => f(a)._underlying));

  /// {@template ilist_foldLeft}
  /// Returns a summary value by applying [op] to all elements of this list,
  /// moving from left to right. The fold uses a seed value of [init].
  /// {@endtemplate}
  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) => _underlying.fold(init, op);

  /// {@template ilist_foldRight}
  /// Returns a summary value by applying [op] to all elements of this list,
  /// moving from right to left. The fold uses a seed value of [init].
  /// {@endtemplate}
  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      reverse().foldLeft(init, (elem, acc) => op(acc, elem));

  /// {@template ilist_forEach}
  /// {@endtemplate}
  /// Applies [f] to each element of this list, discarding any resulting values.
  void forEach<B>(Function1<A, B> f) => _underlying.forEach(f);

  /// {@template ilist_groupBy}
  /// Partitions all elements of this list by applying [f] to each element
  /// and accumulating duplicate keys in the returned [IMap].
  /// {@endtemplate}
  IMap<K, IList<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, id);

  /// {@template ilist_groupMap}
  /// Creates a new map by generating a key-value pair for each elements of this
  /// list using [key] and [value]. Any elements that generate the same key will
  /// have the resulting values accumulated in the returned map.
  /// {@endtemplate}
  IMap<K, IList<V>> groupMap<K, V>(
    Function1<A, K> key,
    Function1<A, V> value,
  ) =>
      foldLeft(
        IMap.empty<K, IList<V>>(),
        (acc, a) => acc.updatedWith(
          key(a),
          (prev) => prev
              .map((l) => l.append(value(a)))
              .orElse(() => ilist([value(a)]).some),
        ),
      );

  /// Returns the first element of this list as a [Some] if non-empty. If this
  /// list is empty, [None] is returned.
  Option<A> get headOption =>
      Option.when(() => isNotEmpty, () => _underlying.first);

  /// {@template ilist_indexWhere}
  /// Returns the index of the first element that satisfies the predicate [p].
  /// If no element satisfies, [None] is returned.
  /// {@endtemplate}
  Option<int> indexWhere(Function1<A, bool> p) {
    final idx = _underlying.indexWhere(p);
    return Option.unless(() => idx < 0, () => idx);
  }

  /// Returns all elements from this list **except** the last. If this list is
  /// empty, the empty list is returned.
  IList<A> init() => take(size - 1);

  /// Returns a new list with [elem] inserted at index [ix]. The resulting list
  /// has a size of one more of this list.
  ///
  /// If [ix] is less than zero or greater than the size of this list, this
  /// list is returned.
  IList<A> insertAt(int ix, A elem) =>
      (0 <= ix && ix <= size) ? IList.of(_underlying.insert(ix, elem)) : this;

  /// Returns a new list with [sep] inserted between each element. If [start]
  /// is defined, it will be added to the start of the new list. If [end] is
  /// defined, it will be added to the end of the new list.
  IList<A> intersperse({A? start, required A sep, A? end}) {
    final buf = List<A>.empty(growable: true);

    if (start != null) {
      buf.add(start);
    }

    for (int i = 0; i < size; i++) {
      buf.add(_underlying[i]);
      if (i < size - 1) buf.add(sep);
    }

    if (end != null) {
      buf.add(end);
    }

    return IList.of(buf);
  }

  /// Returns true if this list has no elements, false otherwise.
  bool get isEmpty => _underlying.isEmpty;

  /// Returns true if this list has any elements, false otherwise.
  bool get isNotEmpty => _underlying.isNotEmpty;

  /// Returns the last element of this list as a [Some], or [None] if this
  /// list is empty.
  Option<A> get lastOption =>
      Option.unless(() => isEmpty, () => _underlying[size - 1]);

  /// Returns the element at index [ix] as a [Some]. If [ix] is outside the
  /// range of this list, [None] is returned.
  Option<A> lift(int ix) =>
      Option.when(() => 0 <= ix && ix < size, () => _underlying[ix]);

  /// Returns the number of elements in this list.
  int get length => _underlying.length;

  /// {@template ilist_map}
  /// Returns a new list where each new element is the result of applying [f]
  /// to the original element from this list.
  /// {@endtemplate}
  @override
  IList<B> map<B>(covariant Function1<A, B> f) => IList.of(_underlying.map(f));

  /// Returns a [String] by using each elements [toString()], adding [sep]
  /// between each element. If [start] is defined, it will be prepended to the
  /// resulting string. If [end] is defined, it will be appended to the
  /// resulting string.
  String mkString({String? start, required String sep, String? end}) {
    final buf = StringBuffer(start ?? '');

    for (int i = 0; i < size; i++) {
      buf.write(_underlying[i]);
      if (i < size - 1) buf.write(sep);
    }

    buf.write(end ?? '');

    return buf.toString();
  }

  /// Returns true if this list has any elements, false otherwise.
  bool get nonEmpty => _underlying.isNotEmpty;

  /// Returns a new list with a length of at least [len].
  ///
  /// If this list is shorter than [len], the returned list will have size [len]
  /// and [elem] will be used for each new element needed to reach that size.
  ///
  /// If this list is already at least [len] in size, this list will be
  /// returned.
  IList<A> padTo(int len, A elem) =>
      size >= len ? this : concat(IList.fill(len - size, elem));

  /// {@template ilist_partition}
  /// Returns 2 lists as a tuple where the first tuple element will be a list
  /// of elements from this list that satisfy the given predicate [p]. The
  /// second item of the returned tuple will be elements that do not satisfy
  /// [p].
  /// {@endtemplate}
  (IList<A>, IList<A>) partition(Function1<A, bool> p) =>
      (IList.of(_underlying.where(p)), IList.of(_underlying.whereNot(p)));

  /// {@template ilist_parTraverseIO}
  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. If an error or cancelation is encountered
  /// for any element, that result is returned and all other elements will be
  /// canceled if possible.
  /// {@endtemplate}
  IO<IList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    for (final elem in _underlying) {
      result =
          IO.both(result, f(elem)).map((t) => t((acc, b) => acc.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_parTraverseIO_}
  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. If an error or cancelation is encountered for any element,
  /// that result is returned and all other elements will be canceled if
  /// possible.
  /// {@endtemplate}
  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) {
    IO<Unit> result = IO.pure(Unit());

    for (final elem in _underlying) {
      result = IO.both(result, f(elem)).map((t) => t((acc, b) => Unit()));
    }

    return result;
  }

  /// Returns a new list with [elem] added to the beginning.
  IList<A> prepend(A elem) => IList.of(_underlying.insert(0, elem));

  /// Returns a summary values of all elements of this list by applying [f] to
  /// each element.
  ///
  /// If this list is empty, [None] will be returned.
  Option<A> reduceOption(Function2<A, A, A> f) =>
      headOption.map((hd) => tail().foldLeft(hd, f));

  /// Returns a new list with the element at index [ix] removed. If [ix] is
  /// outside the bounds of this list, then the original list is returned.
  IList<A> removeAt(int ix) => isEmpty || ix < 0 || ix >= size
      ? this
      : IList.of(_underlying.removeAt(ix));

  /// {@template ilist_removeFirst}
  /// Returns a new list with the first element that satisfies the predicate [p]
  /// removed. If no element satisfies [p], the original list is returned.
  /// {@endtemplate}
  IList<A> removeFirst(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return ix < 0 ? this : IList.of(_underlying.removeAt(ix));
  }

  /// Replaces the element at [index] with [elem].
  ///
  /// If [index] is outside the bounds of this list, the original list is
  /// returned.
  IList<A> replace(int index, A elem) => updated(index, (_) => elem);

  /// Returns a new list with the order of the elements reversed.
  IList<A> reverse() => IList.of(_underlying.reversed);

  /// Returns the number of elements in this list.
  int get size => _underlying.length;

  /// Returns a new list that contains all elements between indicies [from]
  /// (inclusive) and [until] (exclusive).
  ///
  /// If [from] is less than or equal to [until], the empty list is returned.
  IList<A> slice(int from, int until) {
    final lo = max(from, 0);
    if (until <= lo || isEmpty) {
      return nil();
    } else {
      return drop(lo).take(until - lo);
    }
  }

  /// Returns a new list where elements are fixed size chunks of size [n] of
  /// the original list. Each chunk is calculated by sliding a 'window' of size
  /// [n] over the original list, moving the window [step] elements at a time.
  IList<IList<A>> sliding(int n, int step) {
    final buf = List<IList<A>>.empty(growable: true);

    int ix = 0;

    while (ix + n <= size) {
      final window = _underlying.getRange(ix, ix + n);
      buf.add(IList.of(window));
      ix += step;
    }

    return IList.of(buf);
  }

  /// Returns a new list sorted using the provided function [lt] which is used
  /// to determine if one element is less than the other.
  IList<A> sortWith(Function2<A, A, bool> lt) =>
      IList.of(_underlying.sort((a, b) => lt(a, b) ? -1 : 1));

  /// Returns 2 lists of all elements before and after index [ix] respectively.
  (IList<A>, IList<A>) splitAt(int ix) {
    final split = _underlying.splitAt(ix);
    return (IList.of(split.first), IList.of(split.second));
  }

  /// Returns true if the beginning of this list corresponds with [that].
  bool startsWith(IList<A> that) =>
      (isEmpty && that.isEmpty) ||
      fic.IList(_underlying.take(that.size))
          .corresponds(that._underlying, (a, b) => a == b);

  /// Returns a new list with the first element removed. If this list is empty,
  /// the empty list is returned.
  IList<A> tail() => IList.of(_underlying.tail);

  /// Return a new list with the first [n] elements of this list.
  ///
  /// If [n] is less than or equal to 0, the empty list is returned.
  /// If [n] is greater than or equal to the size of this list, the original
  /// list is returned.
  IList<A> take(int n) => n <= 0
      ? nil()
      : (n < size)
          ? IList.of(_underlying.take(n))
          : this;

  /// Returns a new list with the last [n] elements of this list. If [n] is
  /// greater than the size of this list, the original list is returned.
  IList<A> takeRight(int n) =>
      n >= size ? this : IList.of(_underlying.skip(max(0, size - n)));

  /// {@template ilist_takeWhile}
  /// Returns a new list of the longest prefix that satisfies the predicate [p].
  /// {@endtemplate}
  IList<A> takeWhile(Function1<A, bool> p) =>
      IList.of(_underlying.takeWhile(p));

  /// Returns a new [ISet] with the same elements as this [IList], with
  /// duplicates removed.
  ISet<A> toISet() => ISet.fromIList(this);

  /// Returns a new [List] with the same elements as this [IList].
  List<A> toList() => _underlying.toList();

  /// {@template ilist_traverseEither}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [Left] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  Either<B, IList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) {
    Either<B, IList<C>> result = Either.pure(nil());

    for (final elem in _underlying) {
      // short circuit
      if (result.isLeft) {
        return result;
      }

      // Workaround for contravariant issues in error case
      result = result.fold(
        (_) => result,
        (acc) => f(elem).fold(
          (err) => err.asLeft(),
          (a) => acc.append(a).asRight(),
        ),
      );
    }

    return result;
  }

  /// {@template ilist_traverseIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_traverseIO_}
  /// Applies [f] to each element of this list, discarding any results. If an
  /// error or cancelation is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) {
    var result = IO.pure(Unit());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => Unit()));
    }

    return result;
  }

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. If an error or cancelation
  /// is encountered for any element, that result is returned and any additional
  /// elements will not be evaluated.
  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      traverseIO(f).map((a) => a.flatten());

  /// {@template ilist_traverseFilterIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      traverseIO(f).map((opts) => opts.foldLeft(IList.empty<B>(),
          (acc, elem) => elem.fold(() => acc, (elem) => acc.append(elem))));

  /// {@template ilist_traverseOption}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [None] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  Option<IList<B>> traverseOption<B>(Function1<A, Option<B>> f) {
    Option<IList<B>> result = Option.pure(nil());

    for (final elem in _underlying) {
      // short circuit
      if (result.isEmpty) {
        return result;
      }

      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  /// Applies [f] to the first element and tail of this list. If this list
  /// is non empty then the head and tail will be provided to [f] as a [Some].
  /// If this list is empty, [None] will be passed to [f].
  B uncons<B>(Function1<Option<(A, IList<A>)>, B> f) {
    if (_underlying.isEmpty) {
      return f(none());
    } else {
      return f(Some((_underlying[0], IList.of(_underlying.tail))));
    }
  }

  /// {@template ilist_updated}
  /// Returns a new list with [f] applied to the element at index [index].
  ///
  /// If [index] is outside the range of this list, the original list is
  /// returned.
  /// {@endtemplate}
  IList<A> updated(int index, Function1<A, A> f) {
    if (0 <= index && index < size) {
      return IList.of(_underlying.setAll(index, [f(_underlying[index])]));
    } else {
      return this;
    }
  }

  /// Returns a new list that combines corresponding elements from this list
  /// and [bs] as a tuple. The length of the returned list will be the minimum
  /// of this lists size and thes size of [bs].
  IList<(A, B)> zip<B>(IList<B> bs) => IList.of(
        Iterable.generate(
          min(size, bs.size),
          (index) => (_underlying[index], bs._underlying[index]),
        ),
      );

  /// Return a new list with each element of this list paired with it's
  /// respective index.
  IList<(A, int)> zipWithIndex() =>
      ilist(_underlying.zipWithIndex().map((e) => (e.second, e.first)));

  @override
  String toString() =>
      isEmpty ? 'Nil' : mkString(start: 'IList(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IList<A> && _underlying == other._underlying);

  @override
  int get hashCode => _underlying.hashCode;
}

extension IListNestedOps<A> on IList<IList<A>> {
  /// Combines all nested lists into one list using concatenation.
  IList<A> flatten() => foldLeft(nil<A>(), (z, a) => z.concat(a));
}

extension IListEitherOps<A, B> on IList<Either<A, B>> {
  Either<A, IList<B>> sequence() => traverseEither(id);
}

/// Operations avaiable when [IList] elemention are of type [IO].
extension IListIOOps<A> on IList<IO<A>> {
  /// Alias for [traverseIO], using [id] as the function parameter.
  IO<IList<A>> sequence() => traverseIO(id);

  /// Alias for [traverseIO_], using [id] as the function parameter.
  IO<Unit> sequence_() => traverseIO_(id);

  /// Alias for [parTraverseIO], using [id] as the function parameter.
  IO<IList<A>> parSequence() => parTraverseIO(id);

  /// Alias for [parTraverseIO_], using [id] as the function parameter.
  IO<Unit> parSequence_() => parTraverseIO_(id);
}

/// Operations avaiable when [IList] elemention are of type [Option].
extension IListOptionOps<A> on IList<Option<A>> {
  /// Accumulates all elements in this list as one [Option]. If any element is
  /// a [None], [None] will be returned. If all elements are [Some], then the
  /// entire list is returned, wrapped in a [Some].
  Option<IList<A>> sequence() => traverseOption(id);

  /// Returns a new list with all [None] elements removed.
  IList<A> unNone() => foldLeft(
      nil(), (acc, elem) => elem.fold(() => acc, (a) => acc.append(a)));
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension IListTuple2Ops<A, B> on IList<(A, B)> {
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
      groupMap(f.tupled, id);

  /// {@macro ilist_groupMap}
  IMap<K, IList<V>> groupMapN<K, V>(
    Function2<A, B, K> key,
    Function2<A, B, V> value,
  ) =>
      groupMap(key.tupled, value.tupled);

  /// {@macro ilist_indexWhere}
  Option<int> indexWhereN(Function2<A, B, bool> p) => indexWhere(p.tupled);

  /// {@macro ilist_map}
  IList<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  /// {@macro ilist_partition}
  (IList<(A, B)>, IList<(A, B)>) partitionN(Function2<A, B, bool> p) =>
      partition(p.tupled);

  /// {@macro ilist_removeFirst}
  IList<(A, B)> removeFirstN(Function2<A, B, bool> p) => removeFirst(p.tupled);

  /// {@macro ilist_takeWhile}
  IList<(A, B)> takeWhileN(Function2<A, B, bool> p) => takeWhile(p.tupled);

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
      groupMap(f.tupled, id);

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

  /// {@macro ilist_removeFirst}
  IList<(A, B, C)> removeFirstN(Function3<A, B, C, bool> p) =>
      removeFirst(p.tupled);

  /// {@macro ilist_takeWhile}
  IList<(A, B, C)> takeWhileN(Function3<A, B, C, bool> p) =>
      takeWhile(p.tupled);

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
