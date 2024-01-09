part of '../iset.dart';

class _Set1<A> with IterableOnce<A>, RibsIterable<A>, ISet<A> {
  final A elem1;

  const _Set1(this.elem1);

  @override
  bool contains(A elem) => elem == elem1;

  @override
  ISet<A> excl(A elem) {
    if (elem == elem1) {
      return _EmptySet();
    } else {
      return this;
    }
  }

  @override
  bool exists(Function1<A, bool> p) => p(elem1);

  @override
  Option<A> find(Function1<A, bool> p) =>
      Option.when(() => p(elem1), () => elem1);

  @override
  bool forall(Function1<A, bool> p) => p(elem1);

  @override
  A get head => elem1;

  @override
  ISet<A> incl(A elem) {
    if (contains(elem)) {
      return this;
    } else {
      return _Set2(elem1, elem);
    }
  }

  @override
  bool get isEmpty => false;

  @override
  RibsIterator<A> get iterator => RibsIterator.single(elem1);

  @override
  void foreach<U>(Function1<A, U> f) => f(elem1);

  @override
  int get knownSize => 1;

  @override
  int get size => 1;

  @override
  ISet<A> tail() => ISet.empty();
}
