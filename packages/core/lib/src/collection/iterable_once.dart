import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

// Developer Note
//
// When mixing in [IterableOnce], you'll likely want to override the following
// methods so they return the appropriate collection type. Until Dart supports
// Higher Kinded Types (which could be never), this is what we're left to do.
//
// Could possibly employ some 'dynamic' shenanigans to get around this in
// the near term, but would rather avoid that.
//
// @see https://github.com/dart-lang/language/issues/1655
//
// * appended           (Seq)
// * appendedAll        (Seq)
// * collect
// * combinations       (Seq)
// * concat
// * diff               (Seq)
// * distinct
// * distinctBy
// * drop
// * dropRight
// * dropWhile
// * empty
// * filter
// * filterNot
// * flatten
// * groupBy
// * groupMap
// * grouped
// * init
// * inits
// * intersect          (Seq)
// * padTo              (Seq)
// * partition
// * partitionMap
// * patch
// * permutations       (Seq)
// * prepended          (Seq)
// * prependedAll       (Seq)
// * reverse            (Seq)
// * scanLeft
// * scanRight
// * slice
// * sliding
// * sorted             (Seq)
// * sortBy             (Seq)
// * sortWith           (Seq)
// * span
// * splitAt
// * tail
// * tails
// * take
// * takeRight
// * takeWhile
// * tapEach
// * unzip
// * unzip3
// * updated
// * view (?)
// * zip
// * zipAll
// * zipWithIndex

// Need to add the following functions to Iterable / Once / Seq
//
// * search    (Seq)
// * toSet

// And these extensions:
//
// * flatten
// * product
// * sum
// * toMap

// And these constructors:
//
// * range

mixin IterableOnce<A> {
  RibsIterator<A> get iterator;

  int get knownSize => -1;

  // ///////////////////////////////////////////////////////////////////////////

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

  // ///////////////////////////////////////////////////////////////////////////

  Option<B> collectFirst<B>(Function1<A, Option<B>> f) {
    final it = iterator;

    while (it.hasNext) {
      final x = f(it.next());
      if (x.isDefined) return x;
    }

    return none();
  }

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

  int count(Function1<A, bool> p) {
    var res = 0;
    final it = iterator;

    while (it.hasNext) {
      if (p(it.next())) res += 1;
    }

    return res;
  }

  bool exists(Function1<A, bool> p) {
    var res = false;
    final it = iterator;

    while (!res && it.hasNext) {
      res = p(it.next());
    }

    return res;
  }

  Option<A> find(Function1<A, bool> p) {
    final it = iterator;

    while (it.hasNext) {
      final a = it.next();
      if (p(a)) return Some(a);
    }

    return none();
  }

  A fold(A init, Function2<A, A, A> op) => foldLeft(init, op);

  B foldLeft<B>(B z, Function2<B, A, B> op) {
    var result = z;
    final it = iterator;

    while (it.hasNext) {
      result = op(result, it.next());
    }

    return result;
  }

  B foldRight<B>(B z, Function2<A, B, B> op) =>
      reversed().foldLeft(z, (b, a) => op(a, b));

  bool forall(Function1<A, bool> p) {
    var res = true;
    final it = iterator;

    while (res && it.hasNext) {
      res = p(it.next());
    }

    return res;
  }

  void foreach<U>(Function1<A, U> f) {
    final it = iterator;
    while (it.hasNext) {
      f(it.next());
    }
  }

  Option<A> maxOption(Order<A> order) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, order.max),
      };

  Option<A> maxByOption<B>(Function1<A, B> f, Order<B> order) =>
      _minMaxByOption(f, order.max);

  Option<A> minOption(Order<A> order) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, order.min),
      };

  Option<A> minByOption<B>(Function1<A, B> f, Order<B> order) =>
      _minMaxByOption(f, order.min);

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

  Option<A> reduceOption(Function2<A, A, A> op) => reduceLeftOption(op);

  A reduceLeft(Function2<A, A, A> op) => switch (this) {
        final IndexedSeq<A> seq when seq.length > 0 =>
          _foldl(seq, 1, seq[0], op),
        _ when knownSize == 0 => throw UnsupportedError('empty.reduceLeft'),
        _ => _reduceLeftIterator(
            () => throw UnsupportedError('empty.reduceLeft'), op),
      };

  Option<A> reduceLeftOption(Function2<A, A, A> op) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, op),
      };

  A reduceRight(Function2<A, A, A> op) => switch (this) {
        final IndexedSeq<A> seq when seq.length > 0 => _foldr(seq, op),
        _ when knownSize == 0 => throw UnsupportedError('empty.reduceLeft'),
        _ => reversed().reduceLeft((x, y) => op(y, x)),
      };

  Option<A> reduceRightOption(Function2<A, A, A> op) => switch (knownSize) {
        -1 => _reduceOptionIterator(reversed().iterator, (x, y) => op(y, x)),
        0 => none(),
        _ => Some(reduceRight(op)),
      };

  IterableOnce<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  (IterableOnce<A>, IterableOnce<A>) splitAt(int n) {
    final spanner = _Spanner<A>(n);
    return span(spanner.call);
  }

  IterableOnce<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  List<A> toList() {
    final it = iterator;
    final res = List<A>.empty(growable: true);

    while (it.hasNext) {
      res.add(it.next());
    }

    return res;
  }

  IList<A> toIList() => IList.from(this);
  IndexedSeq<A> toIndexedSeq() => IndexedSeq.from(this);
  ISet<A> toISet() => ISet.of(toList());
  IVector<A> toIVector() => IVector.from(this);
  Seq<A> toSeq() => Seq.from(this);

  @protected
  RibsIterable<A> reversed() {
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
