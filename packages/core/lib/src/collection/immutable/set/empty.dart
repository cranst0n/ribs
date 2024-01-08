part of '../iset.dart';

final class _EmptySet<A> with IterableOnce<A>, RibsIterable<A>, ISet<A> {
  const _EmptySet();

  @override
  bool contains(A elem) => false;

  @override
  ISet<A> diff(ISet<A> that) => this;

  @override
  ISet<A> excl(A elem) => this;

  @override
  ISet<A> filter(Function1<A, bool> p) => this;

  @override
  ISet<A> filterNot(Function1<A, bool> p) => this;

  @override
  void foreach<U>(Function1<A, U> f) {}

  @override
  ISet<A> incl(A elem) => _Set1(elem);

  @override
  ISet<A> intersect(ISet<A> that) => this;

  @override
  bool get isEmpty => true;

  @override
  RibsIterator<A> get iterator => RibsIterator.empty();

  @override
  int get knownSize => 0;

  @override
  ISet<A> removedAll(IterableOnce<A> that) => this;

  @override
  int get size => 0;

  @override
  bool subsetOf(ISet<A> that) => true;
}
