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
import 'package:ribs_core/src/collection/indexed_seq_views.dart' as iseqviews;

/// Seqs with efficient [] and length operators
mixin IndexedSeq<A> on RIterable<A>, RSeq<A> {
  static IndexedSeq<A> from<A>(RIterableOnce<A> elems) {
    if (elems is IndexedSeq<A>) {
      return elems;
    } else {
      return IVector.from(elems.iterator);
    }
  }

  static IndexedSeq<A> fromDart<A>(Iterable<A> elems) => from(RIterator.fromDart(elems.iterator));

  @override
  IndexedSeq<A> appended(A elem) => iseqviews.Appended(this, elem);

  @override
  IndexedSeq<A> appendedAll(RIterableOnce<A> suffix) =>
      iseqviews.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeq<B> collect<B>(Function1<A, Option<B>> f) => super.collect(f).toIndexedSeq();

  @override
  RIterator<IndexedSeq<A>> combinations(int n) =>
      super.combinations(n).map((a) => a.toIndexedSeq());

  @override
  IndexedSeq<A> concat(covariant RIterableOnce<A> suffix) =>
      iseqviews.Concat(this, suffix.toIndexedSeq());

  @override
  IndexedSeq<A> diff(RSeq<A> that) => super.diff(that).toIndexedSeq();

  @override
  IndexedSeq<A> distinctBy<B>(Function1<A, B> f) => super.distinctBy(f).toIndexedSeq();

  @override
  IndexedSeq<A> drop(int n) => iseqviews.Drop(this, n);

  @override
  IndexedSeq<A> dropRight(int n) => iseqviews.DropRight(this, n);

  @override
  IndexedSeq<A> dropWhile(Function1<A, bool> p) => super.dropWhile(p).toIndexedSeq();

  @override
  IndexedSeq<A> filter(Function1<A, bool> p) => super.filter(p).toIndexedSeq();

  @override
  IndexedSeq<A> filterNot(Function1<A, bool> p) => super.filterNot(p).toIndexedSeq();

  @override
  IndexedSeq<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) =>
      super.flatMap(f).toIndexedSeq();

  @override
  IMap<K, IndexedSeq<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues((a) => a.toIndexedSeq());

  @override
  IMap<K, IndexedSeq<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues((a) => a.toIndexedSeq());

  @override
  IndexedSeq<A> intersect(RSeq<A> that) => super.intersect(that).toIndexedSeq();

  @override
  IndexedSeq<A> intersperse(A x) => super.intersperse(x).toIndexedSeq();

  @override
  IndexedSeq<A> padTo(int len, A elem) => super.padTo(len, elem).toIndexedSeq();

  @override
  (IndexedSeq<A>, IndexedSeq<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (a.toIndexedSeq(), b.toIndexedSeq());
  }

  @override
  (IndexedSeq<A1>, IndexedSeq<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) {
    final (a, b) = super.partitionMap(f);
    return (a.toIndexedSeq(), b.toIndexedSeq());
  }

  @override
  IndexedSeq<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      super.patch(from, other, replaced).toIndexedSeq();

  @override
  RIterator<IndexedSeq<A>> permutations() => super.permutations().map((a) => a.toIndexedSeq());

  @override
  IndexedSeq<A> prepended(A elem) => super.prepended(elem).toIndexedSeq();

  @override
  IndexedSeq<A> prependedAll(RIterableOnce<A> prefix) => super.prependedAll(prefix).toIndexedSeq();

  @override
  IndexedSeq<B> scan<B>(B z, Function2<B, A, B> op) => super.scan(z, op).toIndexedSeq();

  @override
  IndexedSeq<B> scanLeft<B>(B z, Function2<B, A, B> op) => super.scanLeft(z, op).toIndexedSeq();

  @override
  IndexedSeq<B> scanRight<B>(B z, Function2<A, B, B> op) => super.scanRight(z, op).toIndexedSeq();

  @override
  RIterator<IndexedSeq<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map((a) => a.toIndexedSeq());

  @override
  IndexedSeq<A> sortBy<B>(Order<B> order, Function1<A, B> f) =>
      super.sortBy(order, f).toIndexedSeq();

  @override
  IndexedSeq<A> sortWith(Function2<A, A, bool> lt) => super.sortWith(lt).toIndexedSeq();

  @override
  IndexedSeq<A> sorted(Order<A> order) => super.sorted(order).toIndexedSeq();

  @override
  IndexedSeq<(A, B)> zip<B>(RIterableOnce<B> that) => super.zip(that).toIndexedSeq();

  @override
  IndexedSeq<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      super.zipAll(that, thisElem, thatElem).toIndexedSeq();

  @override
  IndexedSeq<(A, int)> zipWithIndex() => super.zipWithIndex().toIndexedSeq();
}

extension IndexedSeqTuple2Ops<A, B> on IndexedSeq<(A, B)> {
  (IndexedSeq<A>, IndexedSeq<B>) unzip() =>
      (iseqviews.Map(this, (a) => a.$1), iseqviews.Map(this, (a) => a.$2));
}
