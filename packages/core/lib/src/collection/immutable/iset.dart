import 'dart:math';

import 'package:ribs_core/ribs_core.dart' hide ISet;
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/set/champ_common.dart';
import 'package:ribs_core/src/collection/immutable/set/set_node.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

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
  static ISetBuilder<A> builder<A>() => ISetBuilder();

  static ISet<A> empty<A>() => _EmptySet<A>();

  static ISet<A> from<A>(IterableOnce<A> xs) {
    return switch (xs) {
      final _EmptySet<A> s => s,
      final _Set1<A> s => s,
      final _Set2<A> s => s,
      final _Set3<A> s => s,
      final _Set4<A> s => s,
      final IHashSet<A> s => s,
      _ => ISetBuilder<A>().addAll(xs).result(),
    };
  }

  static ISet<A> of<A>(Iterable<A> xs) =>
      from(RibsIterator.fromDart(xs.iterator));

  /// Creates a new set with an additonal element [a].
  ISet<A> operator +(A a) => incl(a);

  /// Creates a new set with the item [a] removed.
  ISet<A> operator -(A a) => excl(a);

  @override
  ISet<A> concat(covariant IterableOnce<A> suffix) {
    var result = this;
    final it = suffix.iterator;

    while (it.hasNext) {
      result = result + it.next();
    }

    return result;
  }

  bool contains(A elem);

  ISet<A> diff(ISet<A> that) => foldLeft(ISet.empty<A>(),
      (result, elem) => that.contains(elem) ? result : result + elem);

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
  ISet<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f) =>
      views.FlatMap(this, f).toISet();

  @override
  IMap<K, ISet<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues((a) => a.toISet());

  @override
  IMap<K, ISet<B>> groupMap<K, B>(
    Function1<A, K> key,
    Function1<A, B> f,
  ) =>
      super.groupMap(key, f).mapValues((a) => a.toISet());

  ISet<A> incl(A elem);

  ISet<A> intersect(ISet<A> that) => filter(that.contains).toISet();

  @override
  ISet<B> map<B>(covariant Function1<A, B> f) => views.Map(this, f).toISet();

  ISet<A> removedAll(IterableOnce<A> that) =>
      that.iterator.foldLeft(this, (acc, elem) => acc - elem);

  bool subsetOf(ISet<A> that) => forall(that.contains);

  RibsIterator<ISet<A>> subsets({int? length}) {
    if (length != null) {
      if (0 <= length && length <= size) {
        return _SubsetsOfNItr(toIndexedSeq(), length);
      } else {
        return RibsIterator.empty();
      }
    } else {
      return _SubsetsItr(toIndexedSeq());
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
