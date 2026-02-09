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

import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/immutable/set/hash_set.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

part 'set/builder.dart';
part 'set/empty.dart';
part 'set/iterator.dart';
part 'set/set1.dart';
part 'set/set2.dart';
part 'set/set3.dart';
part 'set/set4.dart';

ISet<A> iset<A>(Iterable<A> as) => ISet.of(as);

mixin ISet<A> on RIterable<A>, RSet<A> {
  static ISetBuilder<A> builder<A>() => ISetBuilder();

  static ISet<A> empty<A>() => _EmptySet<A>();

  static ISet<A> from<A>(RIterableOnce<A> xs) => switch (xs) {
    final _EmptySet<A> s => s,
    final _Set1<A> s => s,
    final _Set2<A> s => s,
    final _Set3<A> s => s,
    final _Set4<A> s => s,
    final IHashSet<A> s => s,
    _ => ISetBuilder<A>().addAll(xs).result(),
  };

  static ISet<A> of<A>(Iterable<A> xs) => from(RIterator.fromDart(xs.iterator));

  /// Creates a new set with an additonal element [a].
  ISet<A> operator +(A a) => incl(a);

  /// Creates a new set with the item [a] removed.
  ISet<A> operator -(A a) => excl(a);

  @override
  ISet<B> collect<B>(Function1<A, Option<B>> f) => super.collect(f).toISet();

  @override
  ISet<A> concat(RIterableOnce<A> suffix) {
    var result = this;
    final it = suffix.iterator;

    while (it.hasNext) {
      result = result + it.next();
    }

    return result;
  }

  ISet<A> diff(ISet<A> that) =>
      foldLeft(ISet.empty<A>(), (result, elem) => that.contains(elem) ? result : result + elem);

  @override
  ISet<A> drop(int n) => super.drop(n).toISet();

  @override
  ISet<A> dropRight(int n) => super.dropRight(n).toISet();

  @override
  ISet<A> dropWhile(Function1<A, bool> p) => super.dropWhile(p).toISet();

  ISet<A> excl(A elem);

  @override
  ISet<A> filter(Function1<A, bool> p) => super.filter(p).toISet();

  @override
  ISet<A> filterNot(Function1<A, bool> p) => super.filterNot(p).toISet();

  @override
  ISet<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) => views.FlatMap(this, f).toISet();

  @override
  RIterator<ISet<A>> grouped(int size) => super.grouped(size).map((a) => a.toISet());

  @override
  IMap<K, ISet<A>> groupBy<K>(Function1<A, K> f) => super.groupBy(f).mapValues((a) => a.toISet());

  @override
  IMap<K, ISet<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) => super.groupMap(key, f).mapValues((a) => a.toISet());

  ISet<A> incl(A elem);

  @override
  ISet<A> get init => this - last;

  @override
  RIterator<ISet<A>> get inits => super.inits.map((a) => a.toISet());

  ISet<A> intersect(ISet<A> that) => filter(that.contains).toISet();

  @override
  ISet<B> map<B>(Function1<A, B> f) => views.Map(this, f).toISet();

  @override
  (ISet<A>, ISet<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (a.toISet(), b.toISet());
  }

  @override
  (ISet<A1>, ISet<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (a, b) = super.partitionMap(f);
    return (a.toISet(), b.toISet());
  }

  ISet<A> removedAll(RIterableOnce<A> that) =>
      that.iterator.foldLeft(this, (acc, elem) => acc - elem);

  @override
  ISet<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  @override
  ISet<B> scanLeft<B>(B z, Function2<B, A, B> op) => super.scanLeft(z, op).toISet();

  @override
  ISet<B> scanRight<B>(B z, Function2<A, B, B> op) => super.scanRight(z, op).toISet();

  @override
  ISet<A> slice(int from, int until) => super.slice(from, until).toISet();

  @override
  RIterator<ISet<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map((a) => a.toISet());

  @override
  (ISet<A>, ISet<A>) span(Function1<A, bool> p) {
    final (a, b) = super.span(p);
    return (a.toISet(), b.toISet());
  }

  @override
  (ISet<A>, ISet<A>) splitAt(int n) {
    final (a, b) = super.splitAt(n);
    return (a.toISet(), b.toISet());
  }

  bool subsetOf(ISet<A> that) => forall(that.contains);

  RIterator<ISet<A>> subsets({int? length}) {
    if (length != null) {
      if (0 <= length && length <= size) {
        return _SubsetsOfNItr(toIndexedSeq(), length);
      } else {
        return RIterator.empty();
      }
    } else {
      return _SubsetsItr(toIndexedSeq());
    }
  }

  @override
  ISet<A> get tail => super.tail.toISet();

  @override
  RIterator<ISet<A>> get tails => super.tails.map((a) => a.toISet());

  @override
  ISet<A> take(int n) => super.take(n).toISet();

  @override
  ISet<A> takeRight(int n) => super.takeRight(n).toISet();

  @override
  ISet<A> takeWhile(Function1<A, bool> p) => super.takeWhile(p).toISet();

  @override
  ISet<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  ISet<A> union(ISet<A> that) => concat(that);

  @override
  ISet<(A, B)> zip<B>(RIterableOnce<B> that) => super.zip(that).toISet();

  @override
  ISet<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      super.zipAll(that, thisElem, thatElem).toISet();

  @override
  ISet<(A, int)> zipWithIndex() => super.zipWithIndex().toISet();

  @override
  bool operator ==(Object that) =>
      identical(this, that) ||
      switch (that) {
        final ISet<A> thatSet => thatSet.size == size && subsetOf(thatSet),
        _ => false,
      };

  @override
  int get hashCode => MurmurHash3.setHash(this);
}

class _SubsetsItr<A> extends RIterator<ISet<A>> {
  final IndexedSeq<A> _elems;
  int _len = 0;
  RIterator<ISet<A>> _itr = RIterator.empty();

  _SubsetsItr(this._elems);

  @override
  bool get hasNext => _len <= _elems.size || _itr.hasNext;

  @override
  ISet<A> next() {
    if (!_itr.hasNext) {
      if (_len > _elems.size) {
        noSuchElement();
      } else {
        _itr = _SubsetsOfNItr(_elems, _len);
        _len += 1;
      }
    }

    return _itr.next();
  }
}

class _SubsetsOfNItr<A> extends RIterator<ISet<A>> {
  final IndexedSeq<A> elems;
  final int len;

  final Array<int> _idxs;
  bool _hasNext = true;

  _SubsetsOfNItr(this.elems, this.len) : _idxs = Array.range(0, len + 1).update(len, elems.size);

  @override
  bool get hasNext => _hasNext;

  @override
  ISet<A> next() {
    if (!hasNext) noSuchElement();

    final buf = ISet.builder<A>();
    _idxs.slice(0, len).foreach((idx) => buf.addOne(elems[idx!]));

    final result = buf.result();

    var i = len - 1;
    while (i >= 0 && _idxs[i] == _idxs[i + 1]! - 1) {
      i -= 1;
    }

    if (i < 0) {
      _hasNext = false;
    } else {
      _idxs[i] = _idxs[i]! + 1;

      for (int j = i + 1; j < len; j++) {
        _idxs[j] = _idxs[j - 1]! + 1;
      }
    }

    return result;
  }
}

extension ISetNestedOps<A> on ISet<ISet<A>> {
  /// Combines all nested set into one set using concatenation.
  ISet<A> flatten() => fold(iset({}), (z, a) => z.concat(a.toIList()));
}
