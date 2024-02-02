part of '../iset.dart';

class _Set4<A> with RIterableOnce<A>, RIterable<A>, ISet<A> {
  final A elem1;
  final A elem2;
  final A elem3;
  final A elem4;

  const _Set4(this.elem1, this.elem2, this.elem3, this.elem4);

  @override
  bool contains(A elem) =>
      elem == elem1 || elem == elem2 || elem == elem3 || elem == elem4;

  @override
  ISet<A> excl(A elem) {
    if (elem == elem1) {
      return _Set3(elem2, elem3, elem4);
    } else if (elem == elem2) {
      return _Set3(elem1, elem3, elem4);
    } else if (elem == elem3) {
      return _Set3(elem1, elem2, elem4);
    } else if (elem == elem4) {
      return _Set3(elem1, elem2, elem3);
    } else {
      return this;
    }
  }

  @override
  bool exists(Function1<A, bool> p) =>
      p(elem1) || p(elem2) || p(elem3) || p(elem4);

  @override
  ISet<A> filter(Function1<A, bool> p) {
    A? r1;
    A? r2;
    A? r3;
    int n = 0;

    if (p(elem1)) {
      r1 = elem1;
      n += 1;
    }

    if (p(elem2)) {
      n == 0 ? r1 = elem2 : r2 = elem2;
      n += 1;
    }

    if (p(elem3)) {
      if (n == 0) {
        r1 = elem3;
      } else if (n == 1) {
        r2 = elem3;
      } else if (n == 2) {
        r3 = elem3;
      }

      n += 1;
    }

    if (p(elem4)) {
      if (n == 0) {
        r1 = elem4;
      } else if (n == 1) {
        r2 = elem4;
      } else if (n == 2) {
        r3 = elem4;
      }

      n += 1;
    }

    return switch (n) {
      0 => _EmptySet<A>(),
      1 => _Set1(r1 as A),
      2 => _Set2(r1 as A, r2 as A),
      3 => _Set3(r1 as A, r2 as A, r3 as A),
      _ => this,
    };
  }

  @override
  ISet<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  Option<A> find(Function1<A, bool> p) {
    if (p(elem1)) {
      return Some(elem1);
    } else if (p(elem2)) {
      return Some(elem2);
    } else if (p(elem3)) {
      return Some(elem3);
    } else if (p(elem4)) {
      return Some(elem4);
    } else {
      return none();
    }
  }

  @override
  bool forall(Function1<A, bool> p) =>
      p(elem1) && p(elem2) && p(elem3) && p(elem4);

  @override
  A get head => elem1;

  @override
  ISet<A> incl(A elem) {
    if (contains(elem)) {
      return this;
    } else {
      return IHashSet.empty<A>() + elem1 + elem2 + elem3 + elem4 + elem;
    }
  }

  @override
  bool get isEmpty => false;

  @override
  RIterator<A> get iterator => _SetNIterator(4, _getElem);

  @override
  void foreach<U>(Function1<A, U> f) {
    f(elem1);
    f(elem2);
    f(elem3);
    f(elem4);
  }

  @override
  int get knownSize => 4;

  @override
  int get size => 4;

  @override
  ISet<A> tail() => _Set3(elem2, elem3, elem4);

  A _getElem(int n) => switch (n) {
        0 => elem1,
        1 => elem2,
        2 => elem3,
        3 => elem4,
        _ => throw IndexError.withLength(n, size),
      };
}
