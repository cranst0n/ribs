import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

MMultiSet<A> mmultiset<A>(Iterable<A> as) => MMultiSet.fromDartIterable(as);

@immutable
final class MMultiSet<A> with RIterableOnce<A>, RIterable<A>, RMultiSet<A> {
  final MMap<A, int> _elems;

  MMultiSet._(this._elems);

  static MMultiSet<A> empty<A>() => MMultiSet._(MMap.empty());

  static MMultiSet<A> from<A>(RIterableOnce<A> elems) => switch (elems) {
        final MMultiSet<A> ms => ms,
        _ => MMultiSet._(
            MMap.from(elems
                .toIList()
                .groupMapReduce(identity, (_) => 1, (a, b) => a + b)),
          ),
      };

  static MMultiSet<A> fromOccurences<A>(RIterableOnce<(A, int)> elems) =>
      switch (elems) {
        final MMultiSet<A> ms => ms,
        _ => from(elems.flatMap((occ) => views.Fill(occ.$2, occ.$1))),
      };

  static MMultiSet<A> fromDartIterable<A>(Iterable<A> elems) =>
      MMultiSet.from(RIterator.fromDart(elems.iterator));

  MMultiSet<A> operator +(A elem) => incl(elem);

  MMultiSet<A> operator -(A elem) => excl(elem);

  @override
  MMultiSet<B> collect<B>(Function1<A, Option<B>> f) =>
      MMultiSet.from(super.collect(f));

  @override
  MMultiSet<A> concat(covariant RIterableOnce<A> suffix) =>
      MMultiSet.from(iterator.concat(suffix.iterator));

  @override
  MMultiSet<A> concatOccurences(RIterable<(A, int)> that) =>
      MMultiSet.fromOccurences(that);

  @override
  MMultiSet<A> drop(int n) => MMultiSet.from(super.drop(n));

  @override
  MMultiSet<A> dropRight(int n) => MMultiSet.from(super.dropRight(n));

  @override
  MMultiSet<A> dropWhile(Function1<A, bool> p) =>
      MMultiSet.from(super.dropWhile(p));

  MMultiSet<A> excl(A elem) {
    _elems.updateWith(
        elem, (n) => n.fold(() => none(), (n) => n > 1 ? Some(n - 1) : none()));

    return this;
  }

  @override
  MMultiSet<A> filter(Function1<A, bool> p) => MMultiSet.from(super.filter(p));

  @override
  MMultiSet<A> filterNot(Function1<A, bool> p) =>
      MMultiSet.from(super.filterNot(p));

  @override
  MMultiSet<A> filterOccurences(Function1<(A, int), bool> p) =>
      MMultiSet.fromOccurences(views.Filter(occurrences, p, false));

  @override
  MMultiSet<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) =>
      MMultiSet.from(super.flatMap(f));

  @override
  MMultiSet<B> flatMapOccurences<B>(
    Function1<(A, int), RIterableOnce<(B, int)>> f,
  ) =>
      MMultiSet.fromOccurences(views.FlatMap(occurrences, f));

  @override
  IMap<K, MMultiSet<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues(MMultiSet.from);

  @override
  IMap<K, MMultiSet<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) =>
      super.groupMap(key, f).mapValues(MMultiSet.from);

  @override
  RIterator<MMultiSet<A>> grouped(int size) =>
      super.grouped(size).map(MMultiSet.from);

  MMultiSet<A> incl(A elem) {
    _elems.updateWith(elem, (n) => Some(n.fold(() => 1, (n) => n + 1)));
    return this;
  }

  @override
  MMultiSet<A> init() => MMultiSet.from(super.init());

  @override
  RIterator<MMultiSet<A>> inits() => super.inits().map(MMultiSet.from);

  @override
  MMultiSet<B> map<B>(covariant Function1<A, B> f) =>
      MMultiSet.from(iterator.map(f));

  @override
  MMultiSet<B> mapOccurences<B>(Function1<(A, int), (B, int)> f) =>
      MMultiSet.fromOccurences(views.Map<(A, int), (B, int)>(occurrences, f));

  @override
  RMap<A, int> get occurrences => _elems;

  @override
  (MMultiSet<A>, MMultiSet<A>) partition(Function1<A, bool> p) {
    final (first, second) = super.partition(p);
    return (MMultiSet.from(first), MMultiSet.from(second));
  }

  @override
  (RIterable<A1>, RIterable<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (first, second) = super.partitionMap(f);
    return (MMultiSet.from(first), MMultiSet.from(second));
  }

  @override
  MMultiSet<A> slice(int from, int until) =>
      MMultiSet.from(super.slice(from, until));

  @override
  RIterator<MMultiSet<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(MMultiSet.from);

  @override
  (MMultiSet<A>, MMultiSet<A>) span(Function1<A, bool> p) {
    final (first, second) = super.span(p);
    return (MMultiSet.from(first), MMultiSet.from(second));
  }

  @override
  (MMultiSet<A>, MMultiSet<A>) splitAt(int n) {
    final (first, second) = super.splitAt(n);
    return (MMultiSet.from(first), MMultiSet.from(second));
  }

  @override
  MMultiSet<A> tail() => MMultiSet.from(super.tail());

  @override
  RIterator<MMultiSet<A>> tails() => super.tails().map(MMultiSet.from);

  @override
  MMultiSet<A> take(int n) => MMultiSet.from(super.take(n));

  @override
  MMultiSet<A> takeRight(int n) => MMultiSet.from(super.takeRight(n));

  @override
  MMultiSet<A> takeWhile(Function1<A, bool> p) =>
      MMultiSet.from(super.takeWhile(p));

  @override
  MMultiSet<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  MMultiSet<(A, B)> zip<B>(RIterableOnce<B> that) =>
      MMultiSet.from(super.zip(that));

  @override
  MMultiSet<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      MMultiSet.from(super.zipAll(that, thisElem, thatElem));

  @override
  MMultiSet<(A, int)> zipWithIndex() => MMultiSet.from(super.zipWithIndex());
}
