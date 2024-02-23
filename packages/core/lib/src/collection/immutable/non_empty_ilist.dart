import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Creates a [NonEmptyIList] with the given head element, and any additional
/// elements after.
NonEmptyIList<A> nel<A>(A head, [Iterable<A>? tail]) =>
    NonEmptyIList(head, IList.fromDart(tail ?? []));

/// An immutable [IList] that contains at least one element.
@immutable
final class NonEmptyIList<A> with RIterableOnce<A>, RIterable<A>, RSeq<A> {
  @override
  final A head;

  /// All remaining elements of the list.
  final IList<A> _tail;

  /// Creates a list with the given [head] and [tail].
  const NonEmptyIList(this.head, [this._tail = const Nil()]);

  static Option<NonEmptyIList<A>> from<A>(RIterableOnce<A> as) =>
      Option.when(() => as.nonEmpty, () {
        final l = as.toIList();
        return NonEmptyIList(l.head, l.tail());
      });

  static NonEmptyIList<A> unsafe<A>(RIterableOnce<A> as) => from(as)
      .getOrElse(() => throw ArgumentError('NonEmptyList.fromUnsafe: empty'));

  /// If the given [Iterable] is non-empty, a [NonEmptyIList] wrapped in a
  /// [Some] is returned. If the [Iterable] is empty, [None] is returned.
  ///
  /// ```dart main
  /// assert(NonEmptyIList.fromDart([1, 2, 3]) == Some(nel(1, [2, 3])));
  /// assert(NonEmptyIList.fromDart([]) == None<NonEmptyIList<int>>());
  /// ```
  static Option<NonEmptyIList<A>> fromDart<A>(Iterable<A> as) => Option.when(
        () => as.isNotEmpty,
        () => NonEmptyIList(as.first, as.toIList().tail()),
      );

  /// Returns a [NonEmptyIList] with all elements from the given [Iterable] if
  /// the [Iterable] is non-empty. If the [Iterable] is empty, an
  /// [ArgumentError] will be thrown.
  static NonEmptyIList<A> fromDartUnsafe<A>(Iterable<A> as) =>
      fromDart(as).getOrElse(
          () => throw ArgumentError('NonEmptyList.fromDartUnsafe: empty'));

  /// Creates a [NonEmptyIList] with a single element.
  static NonEmptyIList<A> one<A>(A head) => nel(head);

  @override
  A operator [](int ix) => ix == 0 ? head : _tail[ix - 1];

  @override
  NonEmptyIList<A> appended(A a) => NonEmptyIList(head, _tail.appended(a));

  @override
  NonEmptyIList<A> appendedAll(RIterableOnce<A> suffix) =>
      NonEmptyIList(head, _tail.appendedAll(suffix));

  @override
  NonEmptyIList<A> concat(RIterableOnce<A> as) =>
      NonEmptyIList(head, _tail.concat(as));

  /// Adds all elements of [nel] to the end of this list.
  ///
  /// ```dart main
  /// final l = nel(1, [2, 3, 4, 5]);
  /// assert(l.concatNel(l) == nel(1, [2, 3, 4, 5, 1, 2, 3, 4, 5]));
  /// ```
  NonEmptyIList<A> concatNel(NonEmptyIList<A> nel) =>
      NonEmptyIList(head, _tail.concat(nel));

  @override
  IList<B> collect<B>(Function1<A, Option<B>> f) => toIList().collect(f);

  @override
  RIterator<IList<A>> combinations(int n) => toIList().combinations(n);

  @override
  IList<A> diff(RSeq<A> that) => toIList().diff(that);

  @override
  NonEmptyIList<A> distinct() => NonEmptyIList.unsafe(toIList().distinct());

  @override
  NonEmptyIList<A> distinctBy<B>(Function1<A, B> f) =>
      NonEmptyIList.unsafe(toIList().distinctBy(f));

  @override
  IList<A> drop(int n) => toIList().drop(n);

  @override
  IList<A> dropRight(int n) => toIList().dropRight(n);

  @override
  IList<A> dropWhile(Function1<A, bool> p) => toIList().dropWhile(p);

  @override
  NonEmptyIList<B> flatMap<B>(covariant Function1<A, NonEmptyIList<B>> f) =>
      f(head).concat(_tail.flatMap((a) => f(a).toIList()));

  @override
  IList<A> filter(Function1<A, bool> p) => toIList().filter(p);

  @override
  IList<A> filterNot(Function1<A, bool> p) => toIList().filterNot(p);

  @override
  IMap<K, NonEmptyIList<A>> groupBy<K>(Function1<A, K> f) =>
      groupMap(f, identity);

  @override
  RIterator<IList<A>> grouped(int size) => toIList().grouped(size);

  @override
  IMap<K, NonEmptyIList<V>> groupMap<K, V>(
    Function1<A, K> key,
    Function1<A, V> value,
  ) =>
      foldLeft(
        imap({}),
        (acc, a) => acc.updatedWith(
          key(a),
          (prev) => prev
              .map((l) => l.appended(value(a)))
              .orElse(() => nel(value(a)).some),
        ),
      );

  @override
  IList<A> init() => toIList().init();

  @override
  RIterator<IList<A>> inits() => toIList().inits();

  @override
  IList<A> intersect(RSeq<A> that) => toIList().intersect(that);

  @override
  NonEmptyIList<A> intersperse(A x) =>
      NonEmptyIList.unsafe(toIList().intersperse(x));

  @override
  bool get isEmpty => false;

  @override
  RIterator<A> get iterator => RIterator.single(head).concat(_tail.iterator);

  @override
  int get length => 1 + _tail.length;

  @override
  NonEmptyIList<B> map<B>(Function1<A, B> f) =>
      NonEmptyIList(f(head), _tail.map(f));

  @override
  NonEmptyIList<A> padTo(int len, A elem) =>
      size >= len ? this : NonEmptyIList(head, _tail.padTo(len - 1, elem));

  @override
  (IList<A>, IList<A>) partition(Function1<A, bool> p) =>
      toIList().partition(p);

  @override
  (IList<A1>, IList<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) =>
      toIList().partitionMap(f);

  @override
  IList<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      toIList().patch(from, other, replaced);

  @override
  RIterator<NonEmptyIList<A>> permutations() =>
      toIList().permutations().map(NonEmptyIList.unsafe);

  @override
  NonEmptyIList<A> prepended(A elem) => NonEmptyIList(elem, toIList());

  @override
  NonEmptyIList<A> prependedAll(RIterableOnce<A> prefix) =>
      NonEmptyIList.unsafe(toIList().prependedAll(prefix));

  @override
  IList<A> removeAt(int idx) => toIList().removeAt(idx);

  @override
  IList<A> removeFirst(Function1<A, bool> p) => toIList().removeFirst(p);

  @override
  NonEmptyIList<A> reverse() => _tail.isEmpty
      ? this
      : NonEmptyIList(_tail.lastOption.getOrElse(() => head),
          _tail.init().reverse().appended(head));

  @override
  NonEmptyIList<B> scan<B>(B z, Function2<B, A, B> f) => scanLeft(z, f);

  @override
  NonEmptyIList<B> scanLeft<B>(B z, Function2<B, A, B> f) =>
      NonEmptyIList(z, _tail.scanLeft(f(z, head), f));

  @override
  NonEmptyIList<B> scanRight<B>(B z, Function2<A, B, B> f) {
    final newTail = _tail.scanRight(z, f);

    return newTail.headOption.fold(
      () => NonEmptyIList(f(head, z), ilist([z])),
      (h) => NonEmptyIList(f(head, h), newTail),
    );
  }

  @override
  RIterator<IList<A>> sliding(int size, [int step = 1]) =>
      toIList().sliding(size, step);

  @override
  NonEmptyIList<A> sorted(Order<A> o) =>
      fromDartUnsafe(toIList().sorted(o).toList());

  @override
  NonEmptyIList<A> sortBy<B>(Order<B> order, Function1<A, B> f) =>
      NonEmptyIList.unsafe(super.sortBy(order, f));

  @override
  NonEmptyIList<A> sortWith(Function2<A, A, bool> lt) =>
      fromDartUnsafe(toIList().sortWith(lt).toList());

  @override
  (IList<A>, IList<A>) span(Function1<A, bool> p) => toIList().span(p);

  @override
  (IList<A>, IList<A>) splitAt(int n) => toIList().splitAt(n);

  /// Checks if the beginning of this [NonEmptyIList] corresponds to the given
  /// [NonEmptyIList].
  bool startsWithNel(NonEmptyIList<A> that, [int offset = 0]) =>
      head == that.head && _tail.startsWith(that._tail, offset);

  @override
  IList<A> tail() => _tail;

  @override
  RIterator<IList<A>> tails() => toIList().tails();

  @override
  IList<A> take(int n) => toIList().take(n);

  @override
  IList<A> takeRight(int n) => toIList().takeRight(n);

  @override
  IList<A> takeWhile(Function1<A, bool> p) => toIList().takeWhile(p);

  @override
  NonEmptyIList<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  IList<A> toIList() => _tail.prepended(head);

  @override
  Either<B, NonEmptyIList<C>> traverseEither<B, C>(
          Function1<A, Either<B, C>> f) =>
      super.traverseEither(f).map(NonEmptyIList.unsafe);

  @override
  Option<NonEmptyIList<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      super.traverseOption(f).map(NonEmptyIList.unsafe);

  /// Returns a new list with [f] applied to the element at index [index].
  ///
  /// If [index] is outside the range of this list, the original list is
  /// returned.
  @override
  NonEmptyIList<A> updated(int index, A elem) {
    if (index == 0) {
      return NonEmptyIList(elem, _tail);
    } else if (1 <= index && index < size) {
      return NonEmptyIList(head, _tail.updated(index - 1, elem));
    } else {
      return this;
    }
  }

  @override
  IList<(A, B)> zip<B>(RIterableOnce<B> that) => toIList().zip(that);

  @override
  NonEmptyIList<(A, B)> zipAll<B>(
    RIterableOnce<B> that,
    A thisElem,
    B thatElem,
  ) =>
      NonEmptyIList.unsafe(super.zipAll(that, thisElem, thatElem));

  @override
  NonEmptyIList<(A, int)> zipWithIndex() => NonEmptyIList(
      (head, 0), _tail.zipWithIndex().map((a) => a.copy($2: a.$2 + 1)));

  @override
  String toString() => mkString(start: 'NonEmptyIList(', sep: ', ', end: ')');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is NonEmptyIList) {
      if (head != other.head) {
        return false;
      }

      var a = _tail;
      var b = other._tail;

      while (a.nonEmpty && b.nonEmpty && a.head == b.head) {
        a = a.tail();
        b = b.tail();
      }

      return a.isEmpty && b.isEmpty;
    } else {
      return super == other;
    }
  }

  @override
  int get hashCode => MurmurHash3.listHash(toIList());
}

extension NonEmptyIListNestedOps<A> on NonEmptyIList<NonEmptyIList<A>> {
  /// Combines all nested lists into one list using concatenation.
  NonEmptyIList<A> flatten() => head.concat(_tail.flatMap((a) => a.toIList()));
}

extension NonEmptyIListEitherOps<A, B> on NonEmptyIList<Either<A, B>> {
  Either<A, NonEmptyIList<B>> sequence() => traverseEither(identity);
}

/// Operations avaiable when [IList] elemention are of type [Option].
extension NonEmptyIListOptionOps<A> on NonEmptyIList<Option<A>> {
  /// Accumulates all elements in this list as one [Option]. If any element is
  /// a [None], [None] will be returned. If all elements are [Some], then the
  /// entire list is returned, wrapped in a [Some].
  Option<NonEmptyIList<A>> sequence() => traverseOption(identity);
}
