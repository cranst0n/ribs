import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/collection.dart';

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

  (IterableOnce<A>, IterableOnce<A>) splitAt(int n);

  IterableOnce<A> take(int n);

  IterableOnce<A> takeWhile(Function1<A, bool> p);

  IterableOnce<A> tapEach<U>(Function1<A, U> f);

  IterableOnce<(A, int)> zipWithIndex();

  // ///////////////////////////////////////////////////////////////////////////

  bool get isEmpty => switch (knownSize) {
        -1 => iterator.hasNext,
        0 => true,
        _ => false,
      };

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
      return '$start$end';
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

  Option<A> reduceOption(Function2<A, A, A> op) => reduceLeftOption(op);

  Option<A> reduceLeftOption(Function2<A, A, A> op) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(iterator, op),
      };

  Option<A> reduceRightOption(Function2<A, A, A> op) => switch (knownSize) {
        0 => none(),
        _ => _reduceOptionIterator(reversed().iterator, (x, y) => op(y, x)),
      };

  List<A> toList() {
    final res = List<A>.empty(growable: true);
    final it = iterator;

    while (it.hasNext) {
      res.add(it.next());
    }

    return res;
  }

  // TODO: Make appropriate constructors from RibsIterable, etc...
  RibsIterable<A> toIterable() => Seq.from(this);
  Seq<A> toSeq() => Seq.from(this);
  IndexedSeq<A> toIndexedSeq() => IndexedSeq.from(this);
  IVector<A> toIVector() => IVector.from(this);

  @protected
  RibsIterable<A> reversed() {
    // TODO: Change to IList
    var xs = IVector.empty<A>();
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
}
