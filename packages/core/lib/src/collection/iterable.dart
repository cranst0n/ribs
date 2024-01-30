import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin RibsIterable<A> on IterableOnce<A> {
  static RibsIterable<A> empty<A>() => IList.empty();

  static RibsIterable<A> from<A>(IterableOnce<A> elems) {
    if (elems is RibsIterable<A>) {
      return elems;
    } else {
      return IList.from(elems.iterator);
    }
  }

  static RibsIterable<A> fromDart<A>(Iterable<A> elems) =>
      from(RibsIterator.fromDart(elems.iterator));

  @override
  RibsIterable<B> collect<B>(Function1<A, Option<B>> f) =>
      views.Collect(this, f);

  /// Returns a copy of this collection, with [elems] added to the end.
  RibsIterable<A> concat(covariant IterableOnce<A> suffix) =>
      views.Concat(this, suffix);

  @override
  RibsIterable<A> drop(int n) => views.Drop(this, n);

  /// Return a new collection with the last [n] elements removed.
  RibsIterable<A> dropRight(int n) => views.DropRight(this, n);

  @override
  RibsIterable<A> dropWhile(Function1<A, bool> p) => views.DropWhile(this, p);

  @override
  RibsIterable<A> filter(Function1<A, bool> p) => views.Filter(this, p, false);

  @override
  RibsIterable<A> filterNot(Function1<A, bool> p) =>
      views.Filter(this, p, true);

  @override
  RibsIterable<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f) =>
      views.FlatMap(this, f);

  /// {@template iterable_groupBy}
  /// Partitions all elements of this collection by applying [f] to each element
  /// and accumulating duplicate keys in the returned [IMap].
  /// {@endtemplate}
  IMap<K, RibsIterable<A>> groupBy<K>(Function1<A, K> f) =>
      groupMap(f, identity);

  /// {@template iterable_groupMap}
  /// Creates a new map by generating a key-value pair for each elements of this
  /// collection using [key] and [f]. Any elements that generate the same key
  /// will have the resulting values accumulated in the returned map.
  /// {@endtemplate}
  IMap<K, RibsIterable<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) {
    // TODO: use IMap.builder, revist implementation
    final m = <K, ListBuffer<B>>{};
    final it = iterator;

    while (it.hasNext) {
      final elem = it.next();
      final k = key(elem);
      final bldr = m.putIfAbsent(k, () => ListBuffer<B>());
      bldr.addOne(f(elem));
    }

    return IMap.fromDart(
      m.map((key, value) => MapEntry(key, value.toIList())),
    );
  }

  /// Partitions all elements of this collection by applying [key] to each
  /// element. Additionally [f] is applied to each element to generate a value.
  /// If multiple values are generating for the same key, those values will be
  /// combined using [reduce].
  IMap<K, B> groupMapReduce<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
    Function2<B, B, B> reduce,
  ) {
    final m = <K, B>{};

    foreach((elem) {
      m.update(key(elem), (b) => reduce(b, f(elem)), ifAbsent: () => f(elem));
    });

    return IMap.fromDart(m);
  }

  /// Returns a new iterator where each element is a collection of [size]
  /// elements from the original collection. The last element may contain less
  /// than [size] elements.
  RibsIterator<RibsIterable<A>> grouped(int size) => iterator.grouped(size);

  /// Returns the first element of this collection, or throws if it is empty.
  A get head => iterator.next();

  /// Returns the first element of this collection as a [Some] if non-empty.
  /// If this collction is empty, [None] is returned.
  Option<A> get headOption {
    final it = iterator;
    return Option.when(() => it.hasNext, () => it.next());
  }

  /// Returns all elements from this collection **except** the last. If this
  /// collection is empty, an empty collection is returned.
  RibsIterable<A> init() => dropRight(1);

  /// Returns an iterator of all potential tails of this list, starting with the
  /// entire list and ending with the empty list.
  RibsIterator<RibsIterable<A>> inits() => _iterateUntilEmpty((a) => a.init());

  /// Returns the last element of this collection, or throws if it is empty.
  A get last {
    final it = iterator;
    var lst = it.next();

    while (it.hasNext) {
      lst = it.next();
    }

    return lst;
  }

  /// Returns the last element of this list as a [Some], or [None] if this
  /// list is empty.
  Option<A> get lastOption {
    if (isEmpty) {
      return none();
    } else {
      final it = iterator;
      var last = it.next();

      while (it.hasNext) {
        last = it.next();
      }

      return Some(last);
    }
  }

  @override
  RibsIterable<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f);

  /// {@template iterable_partition}
  /// Returns 2 collections as a tuple where the first tuple element will be a
  /// collection of elements that satisfy the given predicate [p]. The second
  /// item of the returned tuple will be elements that do not satisfy [p].
  /// {@endtemplate}
  (RibsIterable<A>, RibsIterable<A>) partition(Function1<A, bool> p) {
    final first = views.Filter(this, p, false);
    final second = views.Filter(this, p, true);

    return (first.toIList(), second.toIList());
  }

  /// {@template iterable_partitionMap}
  /// Applies [f] to each element of this collection and returns a separate
  /// collection for all applications resulting in a [Left] and [Right]
  /// respectively.
  /// {@endtemplate}
  (RibsIterable<A1>, RibsIterable<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final l = IList.builder<A1>();
    final r = IList.builder<A2>();

    iterator.foreach((x) {
      f(x).fold(
        (x1) => l.addOne(x1),
        (x2) => r.addOne(x2),
      );
    });

    return (l.toIList(), r.toIList());
  }

  @override
  RibsIterable<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      views.ScanLeft(this, z, op);

  RibsIterable<B> scanRight<B>(B z, Function2<A, B, B> op) {
    var acc = z;
    var scanned = IList.empty<B>().prepended(acc);

    _reversed().foreach((elem) {
      acc = op(elem, acc);
      scanned = scanned.prepended(acc);
    });

    return scanned;
  }

  @override
  RibsIterable<A> slice(int from, int until) =>
      views.Drop(views.Take(this, until), from);

  /// Returns an iterator where elements are fixed size chunks of size [n] of
  /// the original collection. Each chunk is calculated by sliding a 'window'
  /// of size [n] over the original list, moving the window [step] elements at
  /// a time.
  RibsIterator<IterableOnce<A>> sliding(int size, [int step = 1]) =>
      iterator.sliding(size, step);

  @override
  (RibsIterable<A>, RibsIterable<A>) span(Function1<A, bool> p) =>
      (takeWhile(p), dropWhile(p));

  @override
  (RibsIterable<A>, RibsIterable<A>) splitAt(int n) => (take(n), drop(n));

  /// Returns a new collection with the first element removed. If this
  /// collection is empty, an empty collection is returned.
  RibsIterable<A> tail() => drop(1);

  /// Returns an iterator of all potential tails of this collection, starting
  /// with the entire collection and ending with an empty one.
  RibsIterator<RibsIterable<A>> tails() => _iterateUntilEmpty((a) => a.tail());

  @override
  RibsIterable<A> take(int n) => views.Take(this, n);

  /// Returns a new collection with the last [n] elements of this collection.
  /// If [n] is greater than the size of this collection, the original
  /// collection is returned.
  RibsIterable<A> takeRight(int n) => views.TakeRight(this, n);

  @override
  RibsIterable<A> takeWhile(Function1<A, bool> p) => views.TakeWhile(this, p);

  @override
  RibsIterable<A> tapEach<U>(Function1<A, U> f) => views.Map(this, (a) {
        f(a);
        return a;
      });

  View<A> view() => View.fromIterableProvider(() => this);

  /// Returns a new collection that combines corresponding elements from this
  /// collection and [that] as a tuple. The length of the returned collection will
  /// be the minimum of this collections size and the size of [that].
  RibsIterable<(A, B)> zip<B>(IterableOnce<B> that) {
    return switch (that) {
      final RibsIterable<B> that => views.Zip(this, that),
      _ => RibsIterable.from(iterator.zip(that)),
    };
  }

  /// Returns a new collection that combines corresponding elements from this
  /// collection and [that] as a tuple. The length of the returned collection
  /// will be the maximum of this collections size and thes size of [that]. If
  /// this collection is shorter than [that], [thisElem] will be used to fill in
  /// the resulting collection. If [that] is shorter, [thatElem] will be used to
  /// will in the resulting collection.
  RibsIterable<(A, B)> zipAll<B>(
    IterableOnce<B> that,
    A thisElem,
    B thatElem,
  ) =>
      views.ZipAll(this, that, thisElem, thatElem);

  /// Return a new collection with each element of this collection paired with
  /// it's respective index.
  RibsIterable<(A, int)> zipWithIndex() => views.ZipWithIndex(this);

  // ///////////////////////////////////////////////////////////////////////////

  @override
  String toString() => 'Iterable${mkString(start: '(', sep: ', ', end: ')')}';

  RibsIterator<RibsIterable<A>> _iterateUntilEmpty(
    Function1<RibsIterable<A>, RibsIterable<A>> f,
  ) {
    final it = RibsIterator.iterate(this, f).takeWhile((a) => a.nonEmpty);
    return it.concat(RibsIterator.single(RibsIterable.empty()));
  }

  RibsIterable<A> _reversed() {
    var xs = IList.empty<A>();
    final it = iterator;

    while (it.hasNext) {
      xs = xs.prepended(it.next());
    }

    return xs;
  }
}

extension RibsIterableTuple2Ops<A, B> on RibsIterable<(A, B)> {
  (RibsIterable<A>, RibsIterable<B>) unzip() =>
      (views.Map(this, (a) => a.$1), views.Map(this, (a) => a.$2));
}
