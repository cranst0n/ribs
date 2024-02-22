part of '../iset.dart';

class _Set2<A> with RIterableOnce<A>, RIterable<A>, RSet<A>, ISet<A> {
  final A elem1;
  final A elem2;

  const _Set2(this.elem1, this.elem2);

  @override
  bool contains(A elem) => elem == elem1 || elem == elem2;

  @override
  ISet<A> excl(A elem) {
    if (elem == elem1) {
      return _Set1(elem2);
    } else if (elem == elem2) {
      return _Set1(elem1);
    } else {
      return this;
    }
  }

  @override
  bool exists(Function1<A, bool> p) => p(elem1) || p(elem2);

  @override
  ISet<A> filter(Function1<A, bool> p) {
    final p1 = p(elem1);
    final p2 = p(elem2);

    if (p1 && p2) {
      return this;
    } else if (p1) {
      return _Set1(elem1);
    } else if (p2) {
      return _Set1(elem2);
    } else {
      return _EmptySet();
    }
  }

  @override
  ISet<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  Option<A> find(Function1<A, bool> p) {
    if (p(elem1)) {
      return Some(elem1);
    } else if (p(elem2)) {
      return Some(elem2);
    } else {
      return none();
    }
  }

  @override
  bool forall(Function1<A, bool> p) => p(elem1) && p(elem2);

  @override
  A get head => elem1;

  @override
  ISet<A> incl(A elem) {
    if (contains(elem)) {
      return this;
    } else {
      return _Set3(elem1, elem2, elem);
    }
  }

  @override
  bool get isEmpty => false;

  @override
  RIterator<A> get iterator => _SetNIterator(2, _getElem);

  @override
  void foreach<U>(Function1<A, U> f) {
    f(elem1);
    f(elem2);
  }

  @override
  int get knownSize => 2;

  @override
  int get size => 2;

  @override
  ISet<A> tail() => _Set1(elem2);

  A _getElem(int n) => switch (n) {
        0 => elem1,
        1 => elem2,
        _ => throw IndexError.withLength(n, size),
      };
}
