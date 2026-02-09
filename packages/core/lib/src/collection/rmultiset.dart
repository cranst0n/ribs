import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin RMultiSet<A> on RIterableOnce<A>, RIterable<A> {
  static RMultiSet<A> empty<A>() => IMultiSet.empty();

  static RMultiSet<A> from<A>(RIterableOnce<A> elems) => switch (elems) {
    final RMultiSet<A> ms => ms,
    _ => IMultiSet.from(elems),
  };

  static RMultiSet<A> fromOccurences<A>(RIterableOnce<(A, int)> elems) => switch (elems) {
    final RMultiSet<A> ms => ms,
    _ => from(elems.flatMap((occ) => views.Fill(occ.$2, occ.$1))),
  };

  static RMultiSet<A> fromDartIterable<A>(Iterable<A> elems) =>
      RMultiSet.from(RIterator.fromDart(elems.iterator));

  @override
  RMultiSet<B> collect<B>(Function1<A, Option<B>> f) => RMultiSet.from(super.collect(f));

  RMultiSet<B> collectOccurances<B>(Function1<(A, int), Option<(B, int)>> f) => flatMapOccurences(
    (kvs) => f(kvs).fold(
      () => const views.Empty(),
      (res) => views.Single(res),
    ),
  );

  @override
  RMultiSet<A> concat(RIterableOnce<A> suffix) => RMultiSet.from(super.concat(suffix));

  RMultiSet<A> concatOccurences(RIterable<(A, int)> that) => RMultiSet.fromOccurences(that);

  bool contains(A elem) => occurrences.contains(elem);

  @override
  RMultiSet<A> drop(int n) => RMultiSet.from(super.drop(n));

  @override
  RMultiSet<A> dropRight(int n) => RMultiSet.from(super.dropRight(n));

  @override
  RMultiSet<A> dropWhile(Function1<A, bool> p) => RMultiSet.from(super.dropWhile(p));

  @override
  RMultiSet<A> filter(Function1<A, bool> p) => RMultiSet.from(super.filter(p));

  @override
  RMultiSet<A> filterNot(Function1<A, bool> p) => RMultiSet.from(super.filterNot(p));

  RMultiSet<A> filterOccurences(Function1<(A, int), bool> p) =>
      RMultiSet.fromOccurences(views.Filter(occurrences, p, false));

  @override
  RMultiSet<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) => RMultiSet.from(super.flatMap(f));

  RMultiSet<B> flatMapOccurences<B>(
    Function1<(A, int), RIterableOnce<(B, int)>> f,
  ) => RMultiSet.fromOccurences(views.FlatMap(occurrences, f));

  int get(A elem) => occurrences.getOrElse(elem, () => 0);

  @override
  IMap<K, RMultiSet<A>> groupBy<K>(Function1<A, K> f) => super.groupBy(f).mapValues(RMultiSet.from);

  @override
  IMap<K, RMultiSet<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) => super.groupMap(key, f).mapValues(RMultiSet.from);

  @override
  RIterator<RMultiSet<A>> grouped(int size) => super.grouped(size).map(RMultiSet.from);

  @override
  RMultiSet<A> get init => RMultiSet.from(super.init);

  @override
  RIterator<RMultiSet<A>> get inits => super.inits.map(RMultiSet.from);

  @override
  RIterator<A> get iterator => occurrences.iterator.flatMap((kv) => views.Fill(kv.$2, kv.$1));

  @override
  RMultiSet<B> map<B>(Function1<A, B> f) => RMultiSet.from(super.map(f));

  RMultiSet<B> mapOccurences<B>(Function1<(A, int), (B, int)> f) =>
      RMultiSet.fromOccurences(views.Map<(A, int), (B, int)>(occurrences, f));

  RMap<A, int> get occurrences;

  @override
  (RMultiSet<A>, RMultiSet<A>) partition(Function1<A, bool> p) {
    final (first, second) = super.partition(p);
    return (RMultiSet.from(first), RMultiSet.from(second));
  }

  @override
  (RIterable<A1>, RIterable<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (first, second) = super.partitionMap(f);
    return (RMultiSet.from(first), RMultiSet.from(second));
  }

  @override
  RMultiSet<B> scan<B>(B z, Function2<B, A, B> op) => RMultiSet.from(super.scan(z, op));

  @override
  RMultiSet<B> scanLeft<B>(B z, Function2<B, A, B> op) => RMultiSet.from(super.scanLeft(z, op));

  @override
  RMultiSet<B> scanRight<B>(B z, Function2<A, B, B> op) => RMultiSet.from(super.scanRight(z, op));

  @override
  RMultiSet<A> slice(int from, int until) => RMultiSet.from(super.slice(from, until));

  @override
  RIterator<RMultiSet<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(RMultiSet.from);

  @override
  (RMultiSet<A>, RMultiSet<A>) span(Function1<A, bool> p) {
    final (first, second) = super.span(p);
    return (RMultiSet.from(first), RMultiSet.from(second));
  }

  @override
  (RMultiSet<A>, RMultiSet<A>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (RMultiSet.from(first), RMultiSet.from(second));
  }

  @override
  RMultiSet<A> get tail => RMultiSet.from(super.tail);

  @override
  RIterator<RMultiSet<A>> get tails => super.tails.map(RMultiSet.from);

  @override
  RMultiSet<A> take(int n) => RMultiSet.from(super.take(n));

  @override
  RMultiSet<A> takeRight(int n) => RMultiSet.from(super.takeRight(n));

  @override
  RMultiSet<A> takeWhile(Function1<A, bool> p) => RMultiSet.from(super.takeWhile(p));

  @override
  RMultiSet<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  RMultiSet<(A, B)> zip<B>(RIterableOnce<B> that) => RMultiSet.from(super.zip(that));

  @override
  RMultiSet<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      RMultiSet.from(super.zipAll(that, thisElem, thatElem));

  @override
  RMultiSet<(A, int)> zipWithIndex() => RMultiSet.from(super.zipWithIndex());

  @override
  int get hashCode => MurmurHash3.unorderedHash(occurrences, 'MultiSet'.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      switch (other) {
        final RMultiSet<A> that =>
          size == that.size && occurrences.forall((kv) => that.get(kv.$1) == kv.$2),
        _ => false,
      };
}
