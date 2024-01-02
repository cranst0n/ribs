import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin RibsIterable<A> on IterableOnce<A> {
  static RibsIterable<A> empty<A>() => IVector.empty();

  static RibsIterable<A> from<A>(IterableOnce<A> elems) {
    if (elems is RibsIterable<A>) {
      return elems;
    } else {
      // TODO: change this to IList?
      return IVector.from(elems.iterator);
    }
  }

  static RibsIterable<A> fromDart<A>(Iterable<A> elems) =>
      from(RibsIterator.fromDart(elems.iterator));

  @override
  RibsIterable<B> collect<B>(Function1<A, Option<B>> f) =>
      views.Collect(this, f);

  RibsIterable<A> concat(covariant IterableOnce<A> suffix) =>
      views.Concat(this, suffix);

  @override
  RibsIterable<A> drop(int n) => views.Drop(this, n);

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

  IMap<K, RibsIterable<A>> groupBy<K>(Function1<A, K> f) =>
      groupMap(f, identity);

  IMap<K, RibsIterable<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) {
    // TODO: use ribs collections, revist implementation
    final m = <K, List<B>>{};
    final it = iterator;

    while (it.hasNext) {
      final elem = it.next();
      final k = key(elem);
      final bldr = m.putIfAbsent(k, () => List.empty(growable: true));
      bldr.add(f(elem));
    }

    return IMap.fromMap(
      m.map((key, value) => MapEntry(key, RibsIterable.fromDart(value))),
    );
  }

  IMap<K, B> groupMapReduce<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
    Function2<B, B, B> reduce,
  ) {
    final m = <K, B>{};

    foreach((elem) {
      m.update(key(elem), (b) => reduce(b, f(elem)), ifAbsent: () => f(elem));
    });

    return IMap.fromMap(m);
  }

  RibsIterator<RibsIterable<A>> grouped(int size) => iterator.grouped(size);

  RibsIterator<RibsIterable<A>> inits() => _iterateUntilEmpty((a) => a.init());

  @override
  RibsIterable<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f);

  (RibsIterable<A>, RibsIterable<A>) partition(Function1<A, bool> p) {
    final l = List<A>.empty(growable: true);
    final r = List<A>.empty(growable: true);

    iterator.foreach((x) {
      if (p(x)) {
        l.add(x);
      } else {
        r.add(x);
      }
    });

    return (RibsIterable.fromDart(l), RibsIterable.fromDart(r));
  }

  (RibsIterable<A1>, RibsIterable<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final l = List<A1>.empty(growable: true);
    final r = List<A2>.empty(growable: true);

    iterator.foreach((x) {
      f(x).fold(
        (x1) => l.add(x1),
        (x2) => r.add(x2),
      );
    });

    return (RibsIterable.fromDart(l), RibsIterable.fromDart(r));
  }

  @override
  RibsIterable<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      views.ScanLeft(this, z, op);

  @override
  RibsIterable<A> slice(int from, int until) =>
      views.Drop(views.Take(this, until), from);

  RibsIterator<RibsIterable<A>> sliding(int size, [int step = 1]) =>
      iterator.sliding(size, step);

  @override
  (RibsIterable<A>, RibsIterable<A>) span(Function1<A, bool> p) =>
      (takeWhile(p), dropWhile(p));

  @override
  (RibsIterable<A>, RibsIterable<A>) splitAt(int n) => (take(n), drop(n));

  RibsIterator<RibsIterable<A>> tails() => _iterateUntilEmpty((a) => a.tail());

  @override
  RibsIterable<A> take(int n) => views.Take(this, n);

  RibsIterable<A> takeRight(int n) => views.TakeRight(this, n);

  @override
  RibsIterable<A> takeWhile(Function1<A, bool> p) => views.TakeWhile(this, p);

  @override
  RibsIterable<A> tapEach<U>(Function1<A, U> f) => views.Map(this, (a) {
        f(a);
        return a;
      });

  RibsIterable<(A, B)> zip<B>(IterableOnce<B> that) {
    return switch (that) {
      final RibsIterable<B> that => views.Zip(this, that),
      _ => iterator.zip(that),
    };
  }

  RibsIterable<(A, B)> zipAll<B>(
    IterableOnce<B> that,
    A thisElem,
    B thatElem,
  ) =>
      views.ZipAll(this, that, thisElem, thatElem);

  @override
  RibsIterable<(A, int)> zipWithIndex() => views.ZipWithIndex(this);

  // ///////////////////////////////////////////////////////////////////////////

  Option<A> get headOption {
    final it = iterator;
    return Option.when(() => it.hasNext, () => it.next());
  }

  RibsIterable<A> init() => dropRight(1);

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

  RibsIterable<B> scanRight<B>(B z, Function2<A, B, B> op) {
    var acc = z;
    // TODO: change to IList
    var scanned = IVector.empty<B>().prepended(acc);

    reversed().foreach((elem) {
      acc = op(elem, acc);
      scanned = scanned.prepended(acc);
    });

    return scanned;
  }

  RibsIterable<A> tail() => drop(1);

  View<A> view() => View.fromIterableProvider(() => this);

  RibsIterator<RibsIterable<A>> _iterateUntilEmpty(
    Function1<RibsIterable<A>, RibsIterable<A>> f,
  ) {
    final it = RibsIterator.iterate(this, f).takeWhile((a) => a.nonEmpty);
    return it.concat(RibsIterator.single(RibsIterable.empty()));
  }
}

extension RibsIterableTuple2Ops<A, B> on RibsIterable<(A, B)> {
  (RibsIterable<A>, RibsIterable<B>) unzip() =>
      (views.Map(this, (a) => a.$1), views.Map(this, (a) => a.$2));
}
