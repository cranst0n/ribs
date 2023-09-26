import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Creates a [NonEmptyIList] with the given head element, and any additional
/// elements after.
NonEmptyIList<A> nel<A>(A head, [Iterable<A>? tail]) =>
    NonEmptyIList.of(head, tail ?? []);

/// An immutable list that contains at least one element.
@immutable
final class NonEmptyIList<A> implements Monad<A>, Foldable<A> {
  /// The first element of the list.
  final A head;

  /// All remaining elements of the list.
  final IList<A> tail;

  /// Creates a list with the given [head] and [tail].
  const NonEmptyIList(this.head, [this.tail = const IList.nil()]);

  /// If the given [Iterable] is non-empty, a [NonEmptyIList] wrapped in a
  /// [Some] is returned. If the [Iterable] is empty, [None] is returned.
  ///
  /// ```dart main
  /// assert(NonEmptyIList.fromIterable([1, 2, 3]) == Some(nel(1, [2, 3])));
  /// assert(NonEmptyIList.fromIterable([]) == None<NonEmptyIList<int>>());
  /// ```
  static Option<NonEmptyIList<A>> fromIterable<A>(Iterable<A> as) =>
      Option.when(
        () => as.isNotEmpty,
        () => NonEmptyIList(as.first, as.toIList().tail()),
      );

  /// Returns a [NonEmptyIList] with all elements from the given [Iterable] if
  /// the [Iterable] is non-empty. If the [Iterable] is empty, a [StateError]
  /// will be thrown.
  static NonEmptyIList<A> fromIterableUnsafe<A>(Iterable<A> as) =>
      NonEmptyIList(as.first, as.toIList().tail());

  /// Creates a [NonEmptyIList] with the given [head] and [tail] elements.
  static NonEmptyIList<A> of<A>(A head, [Iterable<A>? tail]) =>
      NonEmptyIList(head, IList.of(tail ?? []));

  /// Creates a [NonEmptyIList] with a single element.
  static NonEmptyIList<A> one<A>(A head) => of(head, []);

  /// Returns the element at the given index or throws a [RangeError] if the
  /// index is out of the bounds of this list.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3])[0] == 1);
  /// assert(nel(1, [2, 3])[2] == 3);
  /// assert(nel(1, [2, 3])[3] == 100); // throws RangeError
  /// ```
  A operator [](int ix) => ix == 0 ? head : tail[ix - 1];

  /// Applies all functions in [f] to all elements in this list.
  ///
  /// ```dart main
  /// final l = nel(1, [2, 3]);
  /// final f = nel((int i) => i * 2, [(int i) => i * 3]);
  /// assert(l.ap(f) == nel(2, [3, 4, 6, 6, 9]));
  /// ```
  @override
  NonEmptyIList<B> ap<B>(NonEmptyIList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  /// Adds the element the end of this list.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).append(6) == nel(1, [2, 3, 4, 5, 6]));
  /// ```
  NonEmptyIList<A> append(A a) => NonEmptyIList(head, tail.append(a));

  /// Adds all elements of [as] to the end of this list.
  ///
  /// ```dart main
  /// final l = nel(1, [2, 3, 4, 5]);
  /// assert(l.concat(ilist([0, 0])) == nel(1, [2, 3, 4, 5, 0, 0]));
  /// ```
  NonEmptyIList<A> concat(IList<A> as) => NonEmptyIList(head, tail.concat(as));

  /// Adds all elements of [nel] to the end of this list.
  ///
  /// ```dart main
  /// final l = nel(1, [2, 3, 4, 5]);
  /// assert(l.concatNel(l) == nel(1, [2, 3, 4, 5, 1, 2, 3, 4, 5]));
  /// ```
  NonEmptyIList<A> concatNel(NonEmptyIList<A> nel) =>
      NonEmptyIList(head, tail.append(nel.head).concat(nel.tail));

  /// Returns true if any element of this list == [elem], otherwise false.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).contains(5));
  /// assert(!nel(1, [2, 3, 2, 1]).contains(100));
  /// ```
  bool contains(A elem) => head == elem || tail.contains(elem);

  /// Returns an [IList] of all distinct (i.e. non-equal) elements in this list.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).distinct() == ilist([1, 2, 3, 4, 5]));
  /// assert(nel(1, [2, 3, 2, 1]).distinct() == ilist([1, 2, 3]));
  /// ```
  IList<A> distinct() => toIList().distinct();

  /// Returns a new [IList] with the first [n] elements from this list
  /// discarded.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).drop(2) == ilist([3, 4, 5]));
  /// ```
  IList<A> drop(int n) => toIList().drop(n);

  /// Returns a new [IList] with the last [n] elements from this list
  /// discarded.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).dropRight(2) == ilist([1, 2, 3]));
  /// ```
  IList<A> dropRight(int n) => toIList().dropRight(n);

  /// Drops the longest prefix of elements that satisfy the given predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).dropWhile((n) => n < 3) == ilist([3, 4, 5]));
  /// ```
  IList<A> dropWhile(Function1<A, bool> p) => toIList().dropWhile(p);

  /// Returns true if **any** element in the list satisfies the given
  /// predicate. False is returned if no elements satisfy the predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).exists((n) => n == 4) == true);
  /// ```
  bool exists(Function1<A, bool> p) => p(head) || tail.exists(p);

  /// Returns a new [IList] that contains only the elements in this list
  /// that satisfy the given predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).filter((n) => n.isEven) == ilist([2, 4]));
  /// ```
  IList<A> filter(Function1<A, bool> p) => toIList().filter(p);

  /// Returns a new [IList] that contains only the elements in this list
  /// that **do not** satisfy the given predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).filterNot((n) => n.isEven) == ilist([1, 3, 5]));
  /// ```
  IList<A> filterNot(Function1<A, bool> p) => toIList().filterNot(p);

  /// Returns the first element of this list that satifies the given predicate
  /// or [None] if no elements satisfy the predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).find((n) => n.isEven) == Some(2));
  /// assert(nel(1, [2, 3, 4, 5]).find((n) => n > 10) == None<int>());
  /// ```
  Option<A> find(Function1<A, bool> p) => toIList().find(p);

  /// Returns the last element of this list that satifies the given predicate
  /// or [None] if no elements satisfy the predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).findLast((n) => n.isEven) == Some(4));
  /// assert(nel(1, [2, 3, 4, 5]).findLast((n) => n > 10) == None<int>());
  /// ```
  Option<A> findLast(Function1<A, bool> p) =>
      tail.findLast(p).orElse(() => Option.when(() => p(head), () => head));

  /// Creates a new [NonEmptyIList] by applying the given function [f] to each
  /// element of this list, and concatenating all of the results.
  ///
  /// ```dart main
  /// final l = nel(1, [2, 3]);
  /// assert(l.flatMap((n) => nel(n - 1, [n, n + 1])) == nel(0, [1, 2, 1, 2, 3, 2, 3, 4]));
  /// ```
  @override
  NonEmptyIList<B> flatMap<B>(covariant Function1<A, NonEmptyIList<B>> f) =>
      f(head).concat(tail.flatMap((a) => f(a).toIList()));

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) => toIList().foldLeft(init, op);

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      toIList().foldRight(init, op);

  /// Returns true if **all** elements of this list satisfy the given predicate.
  ///
  /// ```dart main
  /// assert(nel(1, [2, 3, 4, 5]).forall((n) => n <= 5));
  /// assert(!nel(1, [2, 3, 4, 5]).forall((n) => n < 2));
  /// ```
  bool forall(Function1<A, bool> p) => p(head) && tail.forall(p);

  /// For each element in this list, evaluate the given function by passing the
  /// element to it.
  ///
  /// ```dart main
  /// int count = 0;
  /// nel(1, [2, 3, 4, 5]).forEach((_) => count += 1);
  /// assert(count == 5);
  /// ```
  void forEach<B>(Function1<A, B> f) {
    f(head);
    tail.forEach(f);
  }

  /// {@template nel_groupBy}
  /// Partitions all elements of this list by applying [f] to each element
  /// and accumulating duplicate keys in the returned [IMap].
  /// {@endtemplate}
  IMap<K, NonEmptyIList<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, id);

  /// {@template nel_groupMap}
  /// Creates a new map by generating a key-value pair for each elements of this
  /// list using [key] and [value]. Any elements that generate the same key will
  /// have the resulting values accumulated in the returned map.
  /// {@endtemplate}
  IMap<K, NonEmptyIList<V>> groupMap<K, V>(
    Function1<A, K> key,
    Function1<A, V> value,
  ) =>
      foldLeft(
        IMap.empty<K, NonEmptyIList<V>>(),
        (acc, a) => acc.updatedWith(
          key(a),
          (prev) => prev
              .map((l) => l.append(value(a)))
              .orElse(() => nel(value(a)).some),
        ),
      );

  /// Returns all elements except the last.
  IList<A> get init => toIList().init();

  /// Returns the last element of this list.
  A get last => tail.lastOption.getOrElse(() => head);

  /// Returns the number of elements in this list.
  int get length => size;

  /// Returns the element at the given index wrapped in a [Some] if the index
  /// is within the bounds of this list. Otherwise, [None] is returned.
  Option<A> lift(int ix) => ix < 0
      ? none<A>()
      : ix == 0
          ? Some(head)
          : tail.lift(ix - 1);

  /// Applies the given function to each element of this list to create a new
  /// [NonEmptyIList].
  @override
  NonEmptyIList<B> map<B>(Function1<A, B> f) =>
      NonEmptyIList(f(head), tail.map(f));

  /// Returns a String representation of this list, with the given [start]
  /// (prefix), [sep] (separator) and [end] (suffix). Each element is converted
  /// using it's [toString] method.
  String mkString({String? start, required String sep, String? end}) =>
      toIList().mkString(start: start, sep: sep, end: end);

  /// Returns a [NonEmptyIList] of at least the given length.
  ///
  /// If this list is equal to or larger than the specified length, this list
  /// is returned. If not, a new list is returned with the given size, where
  /// all appendend elements are equal to [elem].
  NonEmptyIList<A> padTo(int len, A elem) =>
      size >= len ? this : NonEmptyIList(head, tail.padTo(len - 1, elem));

  /// Prepends the given element to the beginning of this list.
  NonEmptyIList<A> prepend(A elem) => NonEmptyIList(elem, toIList());

  /// Replaces the element at the given [index] with specified [elem] (value).
  NonEmptyIList<A> replace(int index, A elem) => updated(index, (_) => elem);

  /// Returns a new [NonEmptyIList] with elements in reverse order as this one.
  NonEmptyIList<A> reverse() => tail.isEmpty
      ? this
      : NonEmptyIList(tail.lastOption.getOrElse(() => head),
          tail.init().reverse().append(head));

  /// Checks if the beginning of this [NonEmptyIList] corresponds to the given
  /// [IList].
  bool startsWith(IList<A> that) => toIList().startsWith(that);

  /// Checks if the beginning of this [NonEmptyIList] corresponds to the given
  /// [NonEmptyIList].
  bool startsWithNel(NonEmptyIList<A> that) =>
      head == that.head && tail.startsWith(that.tail);

  /// Return a new [IList] with the first [n] elements of this non empty list.
  ///
  /// If [n] is less than or equal to 0, the empty list is returned.
  /// If [n] is greater than or equal to the size of this list, the original
  /// list is returned as an [IList].
  IList<A> take(int n) => toIList().take(n);

  /// Returns a new [IList] with the last [n] elements of this non empty list.
  /// If [n] is greater than the size of this list, the original list is
  /// returned.
  IList<A> takeRight(int n) => toIList().takeRight(n);

  /// Returns a new [IList] of the longest prefix that satisfies the
  /// predicate [p].
  IList<A> takeWhile(Function1<A, bool> p) => toIList().takeWhile(p);

  /// Returns a new [IList] with all elements of this non empty list.
  IList<A> toIList() => tail.prepend(head);

  /// Returns a new [List] with all elements of this non empty list.
  List<A> toList() => toIList().toList();

  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [Left] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  Either<B, NonEmptyIList<C>> traverseEither<B, C>(
          Function1<A, Either<B, C>> f) =>
      f(head).flatMap(
          (h) => tail.traverseEither(f).map((t) => NonEmptyIList(h, t)));

  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  IO<NonEmptyIList<B>> traverseIO<B>(Function1<A, IO<B>> f) => f(head)
      .flatMap((h) => tail.traverseIO(f).map((t) => NonEmptyIList(h, t)));

  /// Applies [f] to each element of this list, discarding any results. If an
  /// error or cancelation is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) => toIList().traverseIO_(f);

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. If an error or cancelation
  /// is encountered for any element, that result is returned and any additional
  /// elements will not be evaluated.
  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      toIList().flatTraverseIO(f);

  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      toIList().traverseFilterIO(f);

  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. If an error or cancelation is encountered
  /// for any element, that result is returned and all other elements will be
  /// canceled if possible.
  IO<NonEmptyIList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) => IO
      .both(f(head), tail.parTraverseIO(f))
      .map((t) => NonEmptyIList(t.$1, t.$2));

  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. If an error or cancelation is encountered for any element,
  /// that result is returned and all other elements will be canceled if
  /// possible.
  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) =>
      toIList().parTraverseIO_(f);

  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [None] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  Option<NonEmptyIList<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      f(head).flatMap(
          (h) => tail.traverseOption(f).map((t) => NonEmptyIList(h, t)));

  /// Returns a new list with [f] applied to the element at index [index].
  ///
  /// If [index] is outside the range of this list, the original list is
  /// returned.
  NonEmptyIList<A> updated(int index, Function1<A, A> f) {
    if (index == 0) {
      return NonEmptyIList(f(head), tail);
    } else if (1 <= index && index < size) {
      return NonEmptyIList(head, tail.updated(index - 1, f));
    } else {
      return this;
    }
  }

  /// Returns a new list that combines corresponding elements from this list
  /// and [bs] as a tuple. The length of the returned list will be the minimum
  /// of this lists size and thes size of [bs].
  NonEmptyIList<(A, B)> zip<B>(NonEmptyIList<B> bs) =>
      NonEmptyIList((head, bs.head), tail.zip(bs.tail));

  /// Return a new list with each element of this list paired with it's
  /// respective index.
  NonEmptyIList<(A, int)> zipWithIndex() => NonEmptyIList(
      (head, 0), tail.zipWithIndex().map((a) => a.copy($2: a.$2 + 1)));

  @override
  String toString() => mkString(start: 'NonEmptyIList(', sep: ', ', end: ')');

  @override
  bool operator ==(Object other) =>
      other is NonEmptyIList<A> && other.head == head && other.tail == tail;

  @override
  int get hashCode => head.hashCode ^ tail.hashCode;
}
