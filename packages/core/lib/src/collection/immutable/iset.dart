import 'dart:math';

import 'package:ribs_core/ribs_core.dart' hide ISet;

part 'set/builder.dart';
part 'set/empty.dart';
part 'set/iterator.dart';
part 'set/hash_set.dart';
part 'set/set1.dart';
part 'set/set2.dart';
part 'set/set3.dart';
part 'set/set4.dart';

ISet<A> iset<A>(Iterable<A> as) => ISet.of(as);

mixin ISet<A> on RibsIterable<A> {
  static ISet<A> empty<A>() => const _EmptySet();

  static ISet<A> from<A>(IterableOnce<A> xs) {
    final seq = xs.toSeq();
    return switch (xs.size) {
      0 => _EmptySet<A>(),
      1 => _Set1(seq[0]),
      2 => _Set2(seq[0], seq[1]),
      3 => _Set3(seq[0], seq[1], seq[2]),
      4 => _Set4(seq[0], seq[1], seq[2], seq[3]),
      _ => throw UnimplementedError('ISet.of'),
    };
  }

  static ISet<A> of<A>(Iterable<A> xs) {
    final l = xs.toList();

    return switch (xs.length) {
      0 => _EmptySet<A>(),
      1 => _Set1(l[0]),
      2 => _Set2(l[0], l[1]),
      3 => _Set3(l[0], l[1], l[2]),
      4 => _Set4(l[0], l[1], l[2], l[3]),
      _ => throw UnimplementedError('ISet.of'),
    };
  }

  /// Creates a new set with an additonal element [a].
  ISet<A> operator +(A a) => incl(a);

  /// Creates a new set with the item [a] removed.
  ISet<A> operator -(A a) => excl(a);

  @override
  ISet<A> concat(covariant IterableOnce<A> suffix) {
    throw UnimplementedError('ISet.concat');
  }

  bool contains(A elem);

  ISet<A> diff(ISet<A> that) {
    throw UnimplementedError('ISet.diff');
  }

  ISet<A> excl(A elem);

  @override
  ISet<A> filter(Function1<A, bool> p) {
    throw UnimplementedError('ISet.filter');
  }

  @override
  ISet<A> filterNot(Function1<A, bool> p) {
    throw UnimplementedError('ISet.filterNot');
  }

  @override
  ISet<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f) {
    throw UnimplementedError('ISet.flatMap');
  }

  ISet<A> incl(A elem);

  ISet<A> intersect(ISet<A> that) => filter(that.contains).toISet();

  @override
  ISet<B> map<B>(covariant Function1<A, B> f) {
    throw UnimplementedError('ISet.map');
  }

  ISet<A> removedAll(IterableOnce<A> that) =>
      that.iterator.foldLeft(this, (acc, elem) => acc - elem);

  bool subsetOf(ISet<A> that) => forall(that.contains);

  RibsIterator<ISet<A>> subsets() => _SubsetsItr(toIndexedSeq());

  RibsIterator<ISet<A>> subsetsOfN(int len) {
    if (0 <= len && len <= size) {
      return _SubsetsOfNItr(toIndexedSeq(), len);
    } else {
      return RibsIterator.empty();
    }
  }

  ISet<A> union(ISet<A> that) => concat(that);

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

class _SubsetsItr<A> extends RibsIterator<ISet<A>> {
  final IndexedSeq<A> elems;

  _SubsetsItr(this.elems);

  @override
  // TODO: implement hasNext
  bool get hasNext => throw UnimplementedError();

  @override
  ISet<A> next() {
    // TODO: implement next
    throw UnimplementedError();
  }
}

class _SubsetsOfNItr<A> extends RibsIterator<ISet<A>> {
  final IndexedSeq<A> elems;
  final int len;

  _SubsetsOfNItr(this.elems, this.len);

  @override
  // TODO: implement hasNext
  bool get hasNext => throw UnimplementedError();

  @override
  ISet<A> next() {
    // TODO: implement next
    throw UnimplementedError();
  }
}
