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

part 'vector/statics.dart';
part 'vector/vector0.dart';
part 'vector/vector1.dart';
part 'vector/vector2.dart';
part 'vector/vector3.dart';
part 'vector/vector4.dart';
part 'vector/vector5.dart';
part 'vector/vector6.dart';
part 'vector/builder.dart';
part 'vector/vector_slice_builder.dart';
part 'vector/iterator.dart';

IVector<A> ivec<A>(Iterable<A> as) => IVector.fromDart(as);

sealed class IVector<A> with RIterableOnce<A>, RIterable<A>, RSeq<A>, IndexedSeq<A> {
  final _Arr1 _prefix1;

  IVector._(this._prefix1);

  static IVectorBuilder<A> builder<A>() => IVectorBuilder();

  static IVector<A> empty<A>() => _Vector0();

  static IVector<A> from<A>(RIterableOnce<A> elems) {
    if (elems is IVector<A>) {
      return elems;
    } else {
      final b = IVectorBuilder<A>();
      final it = elems.iterator;

      while (it.hasNext) {
        b.addOne(it.next());
      }

      return b.result();
    }
  }

  static IVector<A> fromDart<A>(Iterable<A> elems) => from(RIterator.fromDart(elems.iterator));

  static IVector<A> fill<A>(int n, A elem) {
    final b = IVectorBuilder<A>();
    b._initSparse(n, elem);
    return b.result();
  }

  static IVector<IVector<A>> fill2<A>(int n1, int n2, A elem) => fill(n1, fill(n2, elem));

  static IVector<IVector<IVector<A>>> fill3<A>(int n1, int n2, int n3, A elem) =>
      fill(n1, fill2(n2, n3, elem));

  static IVector<IVector<IVector<IVector<A>>>> fill4<A>(int n1, int n2, int n3, int n4, A elem) =>
      fill(n1, fill3(n2, n3, n4, elem));

  static IVector<IVector<IVector<IVector<IVector<A>>>>> fill5<A>(
    int n1,
    int n2,
    int n3,
    int n4,
    int n5,
    A elem,
  ) => fill(n1, fill4(n2, n3, n4, n5, elem));

  static IVector<A> tabulate<A>(int n, Function1<int, A> f) {
    if (n > 0) {
      final b = IVectorBuilder<A>();
      int i = 0;

      while (i < n) {
        b.addOne(f(i));
        i += 1;
      }

      return b.result();
    } else {
      return empty();
    }
  }

  static IVector<IVector<A>> tabulate2<A>(int n1, int n2, Function2<int, int, A> f) =>
      tabulate(n1, (i1) => tabulate(n2, (i2) => f(i1, i2)));

  static IVector<IVector<IVector<A>>> tabulate3<A>(
    int n1,
    int n2,
    int n3,
    Function3<int, int, int, A> f,
  ) => tabulate(n1, (i1) => tabulate2(n2, n3, (i2, i3) => f(i1, i2, i3)));

  static IVector<IVector<IVector<IVector<A>>>> tabulate4<A>(
    int n1,
    int n2,
    int n3,
    int n4,
    Function4<int, int, int, int, A> f,
  ) => tabulate(n1, (i1) => tabulate3(n2, n3, n4, (i2, i3, i4) => f(i1, i2, i3, i4)));

  static IVector<IVector<IVector<IVector<IVector<A>>>>> tabulate5<A>(
    int n1,
    int n2,
    int n3,
    int n4,
    int n5,
    Function5<int, int, int, int, int, A> f,
  ) => tabulate(n1, (i1) => tabulate4(n2, n3, n4, n5, (i2, i3, i4, i5) => f(i1, i2, i3, i4, i5)));

  @override
  int get length => switch (this) {
    final _BigVector<A> bv => bv.length0,
    _ => _prefix1.length,
  };

  @override
  IVector<A> appended(A elem);

  @override
  IVector<A> appendedAll(RIterableOnce<A> suffix) {
    final k = suffix.knownSize;

    if (k == 0) {
      return this;
    } else if (k < 0) {
      return IVectorBuilder<A>().addAll(this).addAll(suffix).result();
    } else {
      return _appendedAll0(suffix, k);
    }
  }

  @override
  IVector<A> concat(RIterableOnce<A> suffix) => appendedAll(suffix);

  @override
  IVector<B> collect<B>(Function1<A, Option<B>> f) => super.collect(f).toIVector();

  @override
  RIterator<IVector<A>> combinations(int n) => super.combinations(n).map((a) => a.toIVector());

  @override
  IVector<A> diff(RSeq<A> that) => super.diff(that).toIVector();

  @override
  IVector<A> distinct() => distinctBy(identity);

  @override
  IVector<A> distinctBy<B>(Function1<A, B> f) => super.distinctBy(f).toIVector();

  @override
  IVector<A> drop(int n) => slice(n, length);

  @override
  IVector<A> dropRight(int n) => slice(0, length - max(n, 0));

  @override
  IVector<A> dropWhile(Function1<A, bool> p) => super.dropWhile(p).toIVector();

  @override
  IVector<A> filter(Function1<A, bool> p) => _filterImpl(p, false);

  @override
  IVector<A> filterNot(Function1<A, bool> p) => _filterImpl(p, true);

  IVector<A> _filterImpl(Function1<A, bool> p, bool isFlipped) {
    final b = IVectorBuilder<A>();
    final it = iterator;

    while (it.hasNext) {
      final elem = it.next();
      if (p(elem) != isFlipped) {
        b.addOne(elem);
      }
    }

    return b.result();
  }

  @override
  IVector<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) => super.flatMap(f).toIVector();

  @override
  IMap<K, IVector<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues((a) => a.toIVector());

  @override
  RIterator<IVector<A>> grouped(int size) => super.grouped(size).map((a) => a.toIVector());

  @override
  IMap<K, IVector<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues((a) => a.toIVector());

  @override
  IVector<A> get init => slice(0, length - 1);

  @override
  RIterator<IVector<A>> get inits => super.inits.map((a) => a.toIVector());

  @override
  IVector<A> intersect(RSeq<A> that) => super.intersect(that).toIVector();

  @override
  IVector<A> intersperse(A x) => super.intersperse(x).toIVector();

  @override
  RIterator<A> get iterator {
    if (this is _Vector0<A>) {
      return RIterator.empty();
    } else {
      return _NewVectorIterator(this, length, _vectorSliceCount);
    }
  }

  @override
  int get knownSize => length;

  @override
  IVector<B> map<B>(Function1<A, B> f);

  @override
  IVector<A> padTo(int len, A elem) => super.padTo(len, elem).toIVector();

  @override
  (IVector<A>, IVector<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (a.toIVector(), b.toIVector());
  }

  @override
  (IVector<A1>, IVector<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (a, b) = super.partitionMap(f);
    return (a.toIVector(), b.toIVector());
  }

  @override
  IVector<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      super.patch(from, other, replaced).toIVector();

  @override
  RIterator<IVector<A>> permutations() => super.permutations().map((a) => a.toIVector());

  @override
  IVector<A> prepended(A elem);

  @override
  IVector<A> prependedAll(RIterableOnce<A> prefix) {
    final k = prefix.knownSize;
    if (k == 0) {
      return this;
    } else if (k < 0) {
      return IVectorBuilder<A>().addAll(prefix).addAll(this).result();
    } else {
      return _prependedAll0(prefix, k);
    }
  }

  @override
  IVector<A> removeAt(int idx) => super.removeAt(idx).toIVector();

  @override
  IVector<A> removeFirst(Function1<A, bool> p) => super.removeFirst(p).toIVector();

  @override
  IVector<A> reverse() => view.reverse().toIVector();

  @override
  IVector<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  @override
  IVector<B> scanLeft<B>(B z, Function2<B, A, B> op) => super.scanLeft(z, op).toIVector();

  @override
  IVector<B> scanRight<B>(B z, Function2<A, B, B> op) => super.scanRight(z, op).toIVector();

  @override
  RIterator<IVector<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map((a) => a.toIVector());

  @override
  IVector<A> sorted(Order<A> order) => super.sorted(order).toIVector();

  @override
  IVector<A> sortBy<B>(Order<B> order, Function1<A, B> f) => super.sortBy(order, f).toIVector();

  @override
  IVector<A> sortWith(Function2<A, A, bool> lt) => super.sortWith(lt).toIVector();

  @override
  (IVector<A>, IVector<A>) span(Function1<A, bool> p) {
    final (a, b) = super.span(p);
    return (a.toIVector(), b.toIVector());
  }

  @override
  (IVector<A>, IVector<A>) splitAt(int n) {
    final (a, b) = super.splitAt(n);
    return (a.toIVector(), b.toIVector());
  }

  @override
  IVector<A> get tail => slice(1, length);

  @override
  RIterator<IVector<A>> get tails => super.tails.map((a) => a.toIVector());

  @override
  IVector<A> take(int n) => slice(0, n);

  @override
  IVector<A> takeRight(int n) => slice(length - max(n, 0), length);

  @override
  IVector<A> takeWhile(Function1<A, bool> p) => super.takeWhile(p).toIVector();

  @override
  RIterable<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  Either<B, IVector<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) =>
      super.traverseEither(f).map(IVector.from);

  @override
  Option<IVector<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      super.traverseOption(f).map((a) => a.toIVector());

  @override
  String toString() => 'IVector${mkString(start: '(', sep: ', ', end: ')')}';

  @override
  IVector<A> slice(int from, int until);

  @override
  IVector<A> updated(int index, A elem);

  @override
  IndexedSeqView<A> get view => IndexedSeqView.from(this);

  @override
  IVector<(A, B)> zip<B>(RIterableOnce<B> that) => super.zip(that).toIVector();

  @override
  IVector<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      super.zipAll(that, thisElem, thatElem).toIVector();

  @override
  IVector<(A, int)> zipWithIndex() => super.zipWithIndex().toIVector();

  @override
  int get hashCode => MurmurHash3.seqHash(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      switch (other) {
        final RSeq<A> that => sameElements(that),
        _ => false,
      };

  // ///////////////////////////////////////////////////////////////////////////

  IVector<A> _appendedAll0(RIterableOnce<A> suffix, int k) {
    // k >= 0, k = suffix.knownSize
    final tinyAppendLimit = 4 + _vectorSliceCount;
    if (k < tinyAppendLimit) {
      var v = this;

      if (suffix is RIterable) {
        (suffix as RIterable<A>).foreach((x) => v = v.appended(x));
      } else {
        suffix.iterator.foreach((x) => v = v.appended(x));
      }

      return v;
    } else if (size < (k >>> _Log2ConcatFaster) && suffix is IVector) {
      var v = suffix as IVector<A>;
      final ri = reverseIterator();

      while (ri.hasNext) {
        v = v.prepended(ri.next());
      }

      return v;
    } else if (size < k - _AlignToFaster && suffix is IVector) {
      final v = suffix as IVector<A>;
      return IVectorBuilder<A>()._alignTo(size, v).addAll(this).addAll(v).result();
    } else {
      return IVectorBuilder<A>()._initFromVector(this).addAll(suffix).result();
    }
  }

  IVector<A> _prependedAll0(RIterableOnce<A> prefix, int k) {
    // k >= 0, k = prefix.knownSize
    final tinyAppendLimit = 4 + _vectorSliceCount;
    if (k < tinyAppendLimit /*|| k < (this.size >>> Log2ConcatFaster)*/ ) {
      var v = this;
      final it = IndexedSeq.from(prefix).reverseIterator();

      while (it.hasNext) {
        v = v.prepended(it.next());
      }

      return v;
    } else if (size < (k >>> _Log2ConcatFaster) && prefix is IVector) {
      var v = prefix as IVector<A>;
      final it = iterator;

      while (it.hasNext) {
        v = v.prepended(it.next());
      }
      return v;
    } else {
      return IVectorBuilder<A>()._alignTo(k, this).addAll(prefix).addAll(this).result();
    }
  }

  IVector<A> _slice0(int lo, int hi);

  int get _vectorSliceCount;
  Array<dynamic> _vectorSlice(int idx);
}

sealed class _VectorImpl<A> extends IVector<A> {
  _VectorImpl(super._prefix1) : super._();

  @override
  A operator [](int idx);

  @override
  IVector<A> slice(int from, int until) {
    final lo = max(from, 0);
    final hi = min(until, length);

    if (hi <= lo) {
      return _Vector0();
    } else if (hi - lo == length) {
      return this;
    } else {
      return _slice0(lo, hi);
    }
  }

  RangeError _rngErr(int index) => RangeError('$index is out of bounds (min 0, max ${length - 1})');
}

sealed class _BigVector<A> extends _VectorImpl<A> {
  final _Arr1 suffix1;
  final int length0;

  _BigVector(super._prefix, this.suffix1, this.length0);
}
