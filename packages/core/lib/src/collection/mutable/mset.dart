import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/mutable/set/hash_set.dart';

MSet<A> mset<A>(Iterable<A> as) => MSet.of(as);

mixin MSet<A> on RIterable<A> {
  static MSet<A> empty<A>() => MHashSet();

  static MSet<A> from<A>(RIterableOnce<A> xs) => MHashSet.from(xs);

  static MSet<A> of<A>(Iterable<A> xs) => from(RIterator.fromDart(xs.iterator));

  /// Adds element [a].
  bool operator +(A a) => add(a);

  /// Removes element [a].
  bool operator -(A a) => remove(a);

  bool add(A elem);

  @override
  MSet<A> concat(covariant RIterableOnce<A> suffix);

  bool contains(A elem);

  MSet<A> diff(MSet<A> that) => foldLeft(
      MSet.empty<A>(),
      (result, elem) => that.contains(elem) ? result : result
        ..add(elem));

  bool remove(A elem);

  bool subsetOf(MSet<A> that) => forall(that.contains);

  MSet<A> union(MSet<A> that) => concat(that);

  @override
  int get hashCode => MurmurHash3.msetHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is MSet<A>) {
      return size == other.size && subsetOf(other);
    } else {
      return super == other;
    }
  }
}
