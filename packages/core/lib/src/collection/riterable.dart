// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin RIterable<A> on RIterableOnce<A> {
  static RIterable<A> from<A>(RIterableOnce<A> elems) {
    if (elems is RIterable<A>) {
      return elems;
    } else {
      return IList.from(elems.iterator);
    }
  }

  static RIterable<A> fromDart<A>(Iterable<A> elems) => from(RIterator.fromDart(elems.iterator));

  @override
  RIterable<B> collect<B>(Function1<A, Option<B>> f) => views.Collect(this, f);

  /// Returns a copy of this collection, with [elems] added to the end.
  RIterable<A> concat(covariant RIterableOnce<A> suffix) => views.Concat(this, suffix);

  @override
  RIterable<A> drop(int n) => views.Drop(this, n);

  /// Return a new collection with the last [n] elements removed.
  RIterable<A> dropRight(int n) => views.DropRight(this, n);

  @override
  RIterable<A> dropWhile(Function1<A, bool> p) => views.DropWhile(this, p);

  @override
  RIterable<A> filter(Function1<A, bool> p) => views.Filter(this, p, false);

  @override
  RIterable<A> filterNot(Function1<A, bool> p) => views.Filter(this, p, true);

  @override
  RIterable<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) => views.FlatMap(this, f);

  /// {@macro iterable_once_foldLeft}
  A fold(A init, Function2<A, A, A> op) => foldLeft(init, op);

  /// {@template iterable_groupBy}
  /// Partitions all elements of this collection by applying [f] to each element
  /// and accumulating duplicate keys in the returned [IMap].
  /// {@endtemplate}
  IMap<K, RIterable<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, identity);

  /// {@template iterable_groupMap}
  /// Creates a new map by generating a key-value pair for each elements of this
  /// collection using [key] and [f]. Any elements that generate the same key
  /// will have the resulting values accumulated in the returned map.
  /// {@endtemplate}
  IMap<K, RIterable<B>> groupMap<K, B>(
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
  RIterator<RIterable<A>> grouped(int size) => iterator.grouped(size);

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
  RIterable<A> init() => dropRight(1);

  /// Returns an iterator of all potential tails of this collection, starting
  /// with the entire collection and ending with an empty one.
  RIterator<RIterable<A>> inits() => _iterateUntilEmpty((a) => a.init());

  /// Returns the last element of this collection, or throws if it is empty.
  A get last {
    final it = iterator;
    var lst = it.next();

    while (it.hasNext) {
      lst = it.next();
    }

    return lst;
  }

  /// Returns the last element of this collection as a [Some], or [None] if this
  /// collection is empty.
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
  RIterable<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f);

  /// {@template iterable_partition}
  /// Returns 2 collections as a tuple where the first tuple element will be a
  /// collection of elements that satisfy the given predicate [p]. The second
  /// item of the returned tuple will be elements that do not satisfy [p].
  /// {@endtemplate}
  (RIterable<A>, RIterable<A>) partition(Function1<A, bool> p) {
    final first = views.Filter(this, p, false);
    final second = views.Filter(this, p, true);

    return (first.toIList(), second.toIList());
  }

  /// {@template iterable_partitionMap}
  /// Applies [f] to each element of this collection and returns a separate
  /// collection for all applications resulting in a [Left] and [Right]
  /// respectively.
  /// {@endtemplate}
  (RIterable<A1>, RIterable<A2>) partitionMap<A1, A2>(
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
  RIterable<B> scanLeft<B>(B z, Function2<B, A, B> op) => views.ScanLeft(this, z, op);

  RIterable<B> scanRight<B>(B z, Function2<A, B, B> op) {
    var acc = z;
    var scanned = IList.empty<B>().prepended(acc);

    _reversed().foreach((elem) {
      acc = op(elem, acc);
      scanned = scanned.prepended(acc);
    });

    return scanned;
  }

  @override
  RIterable<A> slice(int from, int until) => views.Drop(views.Take(this, until), from);

  /// Returns an iterator where elements are fixed size chunks of size [n] of
  /// the original collection. Each chunk is calculated by sliding a 'window'
  /// of size [n] over the original collection, moving the window [step]
  /// elements at a time.
  RIterator<RIterableOnce<A>> sliding(int size, [int step = 1]) => iterator.sliding(size, step);

  @override
  (RIterable<A>, RIterable<A>) span(Function1<A, bool> p) => (takeWhile(p), dropWhile(p));

  @override
  (RIterable<A>, RIterable<A>) splitAt(int n) => (take(n), drop(n));

  /// Returns a new collection with the first element removed. If this
  /// collection is empty, an empty collection is returned.
  RIterable<A> tail() => drop(1);

  /// Returns an iterator of all potential tails of this collection, starting
  /// with the entire collection and ending with an empty one.
  RIterator<RIterable<A>> tails() => _iterateUntilEmpty((a) => a.tail());

  @override
  RIterable<A> take(int n) => views.Take(this, n);

  /// Returns a new collection with the last [n] elements of this collection.
  /// If [n] is greater than the size of this collection, the original
  /// collection is returned.
  RIterable<A> takeRight(int n) => views.TakeRight(this, n);

  @override
  RIterable<A> takeWhile(Function1<A, bool> p) => views.TakeWhile(this, p);

  @override
  RIterable<A> tapEach<U>(Function1<A, U> f) => views.Map(this, (a) {
        f(a);
        return a;
      });

  View<A> view() => views.Id(this);

  /// Returns a new collection that combines corresponding elements from this
  /// collection and [that] as a tuple. The length of the returned collection will
  /// be the minimum of this collections size and the size of [that].
  RIterable<(A, B)> zip<B>(RIterableOnce<B> that) {
    return switch (that) {
      final RIterable<B> that => views.Zip(this, that),
      _ => RIterable.from(iterator.zip(that)),
    };
  }

  /// Returns a new collection that combines corresponding elements from this
  /// collection and [that] as a tuple. The length of the returned collection
  /// will be the maximum of this collections size and thes size of [that]. If
  /// this collection is shorter than [that], [thisElem] will be used to fill in
  /// the resulting collection. If [that] is shorter, [thatElem] will be used to
  /// will in the resulting collection.
  RIterable<(A, B)> zipAll<B>(
    RIterableOnce<B> that,
    A thisElem,
    B thatElem,
  ) =>
      views.ZipAll(this, that, thisElem, thatElem);

  /// Return a new collection with each element of this collection paired with
  /// it's respective index.
  RIterable<(A, int)> zipWithIndex() => views.ZipWithIndex(this);

  // ///////////////////////////////////////////////////////////////////////////

  @override
  String toString() => 'Iterable${mkString(start: '(', sep: ', ', end: ')')}';

  RIterator<RIterable<A>> _iterateUntilEmpty(
    Function1<RIterable<A>, RIterable<A>> f,
  ) {
    final it = RIterator.iterate(this, f).takeWhile((a) => a.nonEmpty);
    return it.concat(RIterator.single(const Nil()));
  }

  RIterable<A> _reversed() {
    var xs = IList.empty<A>();
    final it = iterator;

    while (it.hasNext) {
      xs = xs.prepended(it.next());
    }

    return xs;
  }
}

extension RibsIterableTuple2Ops<A, B> on RIterable<(A, B)> {
  (RIterable<A>, RIterable<B>) unzip() =>
      (views.Map(this, (a) => a.$1), views.Map(this, (a) => a.$2));
}
