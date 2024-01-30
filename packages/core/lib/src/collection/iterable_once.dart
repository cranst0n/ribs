import 'package:ribs_core/ribs_core.dart';

// Developer Note
//
// When mixing in [IterableOnce], you'll likely want to override any functions
// that return a new collection so they return the appropriate collection type.
// Until Dart supports Higher Kinded Types (which could be never), this is what
// we're left to do.
//
// Could possibly employ some 'dynamic' shenanigans to get around this in
// the near term, but would rather avoid that. Will look into it further.
//
// @see https://github.com/dart-lang/language/issues/1655
//

mixin IterableOnce<A> {
  RibsIterator<A> get iterator;

  /// Returns the number of elements in this collection, if that number is
  /// already known. If not, -1 is returned.
  int get knownSize => -1;

  // ///////////////////////////////////////////////////////////////////////////

  /// {@template iterable_once_collect}
  /// Returns a new collection by applying [f] to each element an only keeping
  /// results of type [Some].
  /// {@endtemplate}
  IterableOnce<B> collect<B>(Function1<A, Option<B>> f);

  IterableOnce<A> drop(int n);

  IterableOnce<A> dropWhile(Function1<A, bool> p);

  IterableOnce<A> filter(Function1<A, bool> p);

  IterableOnce<A> filterNot(Function1<A, bool> p);

  IterableOnce<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f);

  IterableOnce<B> map<B>(Function1<A, B> f);

  IterableOnce<B> scanLeft<B>(B z, Function2<B, A, B> op);

  IterableOnce<A> slice(int from, int until);

  (IterableOnce<A>, IterableOnce<A>) span(Function1<A, bool> p);

  IterableOnce<A> take(int n);

  IterableOnce<A> takeWhile(Function1<A, bool> p);

  // ///////////////////////////////////////////////////////////////////////////

  bool get isEmpty => switch (knownSize) {
        -1 => iterator.hasNext,
        0 => true,
        _ => false,
      };

  bool get isNotEmpty => !isEmpty;

  bool get isTraversableAgain => false;

  bool get nonEmpty => !isEmpty;

  /// Returns the number of elements in this collection.
  int get size {
    if (knownSize >= 0) {
      return knownSize;
    } else {
      final it = iterator;
      var len = 0;

      while (it.hasNext) {
        len += 1;
        it.next();
      }

      return len;
    }
  }

  /// {@template iterable_once_collectFirst}
  /// Applies [f] to each element of this collection, returning the first
  /// element that results in a [Some], if any.
  /// {@endtemplate}
  Option<B> collectFirst<B>(Function1<A, Option<B>> f) {
    final it = iterator;

    while (it.hasNext) {
      final x = f(it.next());
      if (x.isDefined) return x;
    }

    return none();
  }

  /// Returns true if this collection has the same size as [that] and each
  /// corresponding element from this and [that] satisfies the given
  /// predicate [p].
  bool corresponds<B>(
    covariant RibsIterable<B> that,
    Function2<A, B, bool> p,
  ) {
    final a = iterator;
    final b = that.iterator;

    while (a.hasNext && b.hasNext) {
      if (!p(a.next(), b.next())) return false;
    }

    return a.hasNext && b.hasNext;
  }

  /// {@template iterable_once_count}
  /// Return the number of elements in this collection that satisfy the given
  /// predicate.
  /// {@endtemplate}
  int count(Function1<A, bool> p) {
    var res = 0;
    final it = iterator;

    while (it.hasNext) {
      if (p(it.next())) res += 1;
    }

    return res;
  }

  /// {@template iterable_once_exists}
  /// Returns true if **any** element of this collection satisfies the given
  /// predicate, false if no elements satisfy it.
  /// {@endtemplate}
  bool exists(Function1<A, bool> p) {
    var res = false;
    final it = iterator;

    while (!res && it.hasNext) {
      res = p(it.next());
    }

    return res;
  }

  /// {@template iterable_once_find}
  /// Returns the first element from this collection that satisfies the given
  /// predicate [p]. If no element satisfies [p], [None] is returned.
  /// {@endtemplate}
  Option<A> find(Function1<A, bool> p) {
    final it = iterator;

    while (it.hasNext) {
      final a = it.next();
      if (p(a)) return Some(a);
    }

    return none();
  }

  /// {@macro iterable_once_foldLeft}
  A fold(A init, Function2<A, A, A> op) => foldLeft(init, op);

  /// {@template iterable_once_foldLeft}
  /// Returns a summary value by applying [op] to all elements of this
  /// collection, moving from left to right. The fold uses a seed value of
  /// [init].
  /// {@endtemplate}
  B foldLeft<B>(B z, Function2<B, A, B> op) {
    var result = z;
    final it = iterator;

    while (it.hasNext) {
      result = op(result, it.next());
    }

    return result;
  }

  /// {@template iterableonce_foldRight}
  /// Returns a summary value by applying [op] to all elements of this
  /// collection, moving from right to left. The fold uses a seed value of
  /// [init].
  /// {@endtemplate}
  B foldRight<B>(B z, Function2<A, B, B> op) =>
      _reversed().foldLeft(z, (b, a) => op(a, b));

  /// {@template iterable_forall}
  /// Returns true if **all** elements of this collection satisfy the given
  /// predicate, false if any elements do not.
  /// {@endtemplate}
  bool forall(Function1<A, bool> p) {
    var res = true;
    final it = iterator;

    while (res && it.hasNext) {
      res = p(it.next());
    }

    return res;
  }

  /// {@template iterable_once_forEach}
  /// Applies [f] to each element of this collection, discarding any resulting
  /// values.
  /// {@endtemplate}
  void foreach<U>(Function1<A, U> f) {
    final it = iterator;
    while (it.hasNext) {
      f(it.next());
    }
  }

  /// Finds the largest element in this collection according to the given
  /// [Order].
  ///
  /// If this collection is empty, [None] is returned.
  Option<A> maxOption(Order<A> order) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, order.max),
      };

  /// Finds the largest element in this collection by applying [f] to each element
  /// and using the given [Order] to find the greatest.
  ///
  /// If this collection is empty, [None] is returned.
  Option<A> maxByOption<B>(Function1<A, B> f, Order<B> order) =>
      _minMaxByOption(f, order.max);

  /// Finds the largest element in this collection according to the given
  /// [Order].
  ///
  /// If this collection is empty, [None] is returned.
  Option<A> minOption(Order<A> order) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, order.min),
      };

  /// Finds the smallest element in this collection by applying [f] to each element
  /// and using the given [Order] to find the greatest.
  ///
  /// If this collection is empty, [None] is returned.
  Option<A> minByOption<B>(Function1<A, B> f, Order<B> order) =>
      _minMaxByOption(f, order.min);

  /// Returns a [String] by using each elements [toString()], adding [sep]
  /// between each element. If [start] is defined, it will be prepended to the
  /// resulting string. If [end] is defined, it will be appended to the
  /// resulting string.
  String mkString({String? start, String? sep, String? end}) {
    if (knownSize == 0) {
      return '${start ?? ""}${end ?? ""}';
    } else {
      return _mkStringImpl(StringBuffer(), start ?? '', sep ?? '', end ?? '');
    }
  }

  String _mkStringImpl(StringBuffer buf, String start, String sep, String end) {
    if (start.isNotEmpty) buf.write(start);

    final it = iterator;
    if (it.hasNext) {
      buf.write(it.next());
      while (it.hasNext) {
        buf.write(sep);
        buf.write(it.next());
      }
    }

    if (end.isNotEmpty) buf.write(end);

    return buf.toString();
  }

  A reduce(Function2<A, A, A> op) => reduceLeft(op);

  /// Returns a summary values of all elements of this collection by applying
  /// [f] to each element, moving left to right.
  ///
  /// If this collection is empty, [None] will be returned.
  Option<A> reduceOption(Function2<A, A, A> op) => reduceLeftOption(op);

  A reduceLeft(Function2<A, A, A> op) => switch (this) {
        final IndexedSeq<A> seq when seq.length > 0 =>
          _foldl(seq, 1, seq[0], op),
        _ when knownSize == 0 => throw UnsupportedError('empty.reduceLeft'),
        _ => _reduceLeftIterator(
            () => throw UnsupportedError('empty.reduceLeft'), op),
      };

  /// Returns a summary values of all elements of this collection by applying
  /// [f] to each element, moving left to right.
  ///
  /// If this collection is empty, [None] will be returned.
  Option<A> reduceLeftOption(Function2<A, A, A> op) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, op),
      };

  A reduceRight(Function2<A, A, A> op) => switch (this) {
        final IndexedSeq<A> seq when seq.length > 0 => _foldr(seq, op),
        _ when knownSize == 0 => throw UnsupportedError('empty.reduceLeft'),
        _ => _reversed().reduceLeft((x, y) => op(y, x)),
      };

  /// Returns a summary values of all elements of this collection by applying
  /// [f] to each element, moving right to left.
  ///
  /// If this collection is empty, [None] will be returned.
  Option<A> reduceRightOption(Function2<A, A, A> op) => switch (knownSize) {
        -1 => _reduceOptionIterator(_reversed().iterator, (x, y) => op(y, x)),
        0 => none(),
        _ => Some(reduceRight(op)),
      };

  /// Returns a new collection of the accumulation of results by applying [f] to
  /// all elements of the collection, including the inital value [z]. Traversal
  /// moves from left to right.
  IterableOnce<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  /// Returns 2 collectins of all elements before and after index [ix]
  /// respectively.
  (IterableOnce<A>, IterableOnce<A>) splitAt(int n) {
    final spanner = _Spanner<A>(n);
    return span(spanner.call);
  }

  /// Applies [f] to each element in this collection, discarding any results and
  /// returns this collection.
  IterableOnce<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  /// Returns a new [List] with the same elements as this collection.
  List<A> toList({bool growable = true}) {
    if (growable) {
      final it = iterator;
      final res = List<A>.empty(growable: true);

      while (it.hasNext) {
        res.add(it.next());
      }

      return res;
    } else {
      final it = iterator;
      return List.generate(size, (_) => it.next());
    }
  }

  /// Returns an [IList] with the same elements as this collection.
  IList<A> toIList() => IList.from(this);

  /// Returns an [IndexedSeq] with the same elements as this collection.
  IndexedSeq<A> toIndexedSeq() => IndexedSeq.from(this);

  /// Returns an [ISet] with the same elements as this collection, duplicates
  /// removed.
  ISet<A> toISet() => ISet.from(this);

  /// Returns an [IVector] with the same elements as this collection.
  IVector<A> toIVector() => IVector.from(this);

  /// Returns a [Seq] with the same elements as this collection.
  Seq<A> toSeq() => Seq.from(this);

  RibsIterable<A> _reversed() {
    var xs = IList.empty<A>();
    final it = iterator;

    while (it.hasNext) {
      xs = xs.prepended(it.next());
    }

    return xs;
  }

  // ///////////////////////////////////////////////////////////////////////////

  Option<A> _minMaxByOption<B>(
    Function1<A, B> f,
    Function2<B, B, B> minMax,
  ) {
    final it = iterator;

    A? minmax;
    B? minmaxBy;

    while (it.hasNext) {
      if (minmax != null) {
        final next = it.next();
        final nextF = f(next);

        if (minMax(minmaxBy as B, nextF) == nextF) {
          minmax = next;
          minmaxBy = nextF;
        }
      } else {
        minmax = it.next();
        minmaxBy = f(minmax as A);
      }
    }

    return Option(minmax);
  }

  Option<A> _reduceOptionIterator(RibsIterator<A> it, Function2<A, A, A> op) {
    if (it.hasNext) {
      var acc = it.next();

      while (it.hasNext) {
        acc = op(acc, it.next());
      }

      return Some(acc);
    } else {
      return none();
    }
  }

  A _reduceLeftIterator(Function0<A> onEmpty, Function2<A, A, A> op) {
    final it = iterator;

    if (it.hasNext) {
      var acc = it.next();

      while (it.hasNext) {
        acc = op(acc, it.next());
      }

      return acc;
    } else {
      return onEmpty();
    }
  }

  A _foldl(IndexedSeq<A> seq, int start, A z, Function2<A, A, A> op) {
    var at = start;
    var acc = z;

    while (at < seq.length) {
      acc = op(acc, seq[at]);
      at = at + 1;
    }

    return acc;
  }

  A _foldr(IndexedSeq<A> seq, Function2<A, A, A> op) {
    var at = seq.length - 1;
    var acc = seq[seq.length - 1];

    while (at > 0) {
      acc = op(seq[at - 1], acc);
      at = at - 1;
    }

    return acc;
  }
}

final class _Spanner<A> {
  final int n;
  var _i = 0;

  _Spanner(this.n);

  bool call(A a) {
    if (_i >= n) {
      return false;
    } else {
      _i += 1;
      return true;
    }
  }
}
