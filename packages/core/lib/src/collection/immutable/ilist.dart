import 'dart:math';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

IList<A> ilist<A>(Iterable<A> as) => IList.fromDart(as);
IList<A> nil<A>() => IList.empty();

sealed class IList<A> with IterableOnce<A>, RibsIterable<A>, Seq<A> {
  const IList();

  static ListBuffer<A> builder<A>() => ListBuffer();

  /// Create an empty list.
  static IList<A> empty<A>() => Nil<A>();

  /// Create an empty list.
  static IList<A> nil<A>() => Nil<A>();

  /// Creates an IList of size [len] where each element is set to [elem].
  static IList<A> fill<A>(int len, A elem) =>
      from(RibsIterator.fill(len, elem));

  /// Creates an IList from the given Ribs [IterableOnce].
  static IList<A> from<A>(IterableOnce<A> elems) {
    if (elems is IList<A>) {
      return elems;
    } else {
      return Nil<A>().prependedAll(elems);
    }
  }

  /// Creates an IList from the given Dart [Iterable].
  static IList<A> fromDart<A>(Iterable<A> elems) =>
      from(RibsIterator.fromDart(elems.iterator));

  /// Create an IList of size [n] and sets the element at each index by
  /// invoking [f] and passing the index.
  static IList<A> tabulate<A>(int n, Function1<int, A> f) {
    IList<A> result = Nil<A>();
    int i = n - 1;

    while (i >= 0) {
      result = Cons(f(i), result);
      i -= 1;
    }

    return result;
  }

  /// Creates an IList where elements are every integer from [start] (inclusive)
  /// to [end] (exclusive) and each element adds [step] from the previous.
  static IList<int> range(int start, int end, [int step = 1]) =>
      Range.exclusive(start, end, step).toIList();

  /// Creates an IList where elements are every integer from [start] (inclusive)
  /// to [end] (inclusive) and each element adds [step] from the previous.
  static IList<int> rangeTo(int start, int end, [int step = 1]) =>
      Range.inclusive(start, end, step).toIList();

  /// Creates an IList where elements are every integer from [start] (inclusive)
  /// to [end] (exclusive) and each element adds [step] from the previous.
  static IList<int> rangeUntil(int start, int end, [int step = 1]) =>
      Range.exclusive(start, end, step).toIList();

  @override
  A operator [](int idx) {
    if (idx < 0) throw RangeError.index(idx, 'Invalid IList index: $idx');

    final skipped = drop(idx);
    if (skipped.isEmpty) throw RangeError.index(idx, this);

    return skipped.head;
  }

  @override
  IList<A> appended(A elem) {
    final b = builder<A>();

    b.addAll(this);
    b.addOne(elem);

    return b.toIList();
  }

  @override
  IList<A> appendedAll(IterableOnce<A> suffix) => switch (suffix) {
        final IList<A> xs => xs.prependedAll(this),
        _ => builder<A>().addAll(this).addAll(suffix).toIList(),
      };

  @override
  IList<B> collect<B>(Function1<A, Option<B>> f) {
    final nilB = Nil<B>();

    if (isEmpty) {
      return nilB;
    } else {
      var rest = this;
      Cons<B>? h;

      // Special case for first element
      while (h == null) {
        f(rest.head).forEach((x) => h = Cons(x, nilB));
        rest = rest.tail();

        if (rest.isEmpty) return h ?? nilB;
      }

      var t = h;

      // Remaining elements
      while (rest.nonEmpty) {
        f(rest.head).forEach((x) {
          final nx = Cons(x, nilB);
          t!.next = nx;
          t = nx;
        });

        rest = rest.tail();
      }

      return h ?? nilB;
    }
  }

  @override
  RibsIterator<IList<A>> combinations(int n) =>
      super.combinations(n).map((a) => a.toIList());

  @override
  IList<A> concat(covariant IterableOnce<A> suffix) => appendedAll(suffix);

  @override
  bool contains(A elem) {
    var these = this;

    while (!these.isEmpty) {
      if (these.head == elem) return true;
      these = these.tail();
    }

    return false;
  }

  // TODO: This probably shouldn't exist. Use Chain for this
  Option<(A, IList<A>)> deleteFirst(Function1<A, bool> p) {
    if (isEmpty) {
      return none();
    } else {
      final b = builder<A>();

      A? found;

      var these = this;

      while (these.nonEmpty && found == null) {
        final hd = these.head;

        if (p(hd)) {
          found = hd;
          b.addAll(these.tail());
        } else {
          b.addOne(hd);
        }

        these = these.tail();
      }

      if (found != null) {
        return Some((found, b.toIList()));
      } else {
        return none();
      }
    }
  }

  @override
  IList<A> distinct() => super.distinct().toIList();

  @override
  IList<A> distinctBy<B>(Function1<A, B> f) => super.distinctBy(f).toIList();

  @override
  IList<A> diff(Seq<A> that) => super.diff(that).toIList();

  @override
  IList<A> drop(int n) {
    var l = this;
    var i = n;

    while (l.nonEmpty && i > 0) {
      l = l.tail();
      i -= 1;
    }

    return l;
  }

  @override
  IList<A> dropRight(int n) {
    if (this.isEmpty) {
      return this;
    } else {
      final lead = iterator.drop(n);
      final it = iterator;

      final res = builder<A>();

      while (lead.hasNext) {
        res.addOne(it.next());
        lead.next();
      }

      return res.toIList();
    }
  }

  @override
  IList<A> dropWhile(Function1<A, bool> p) {
    var s = this;

    while (s.nonEmpty && p(s.head)) {
      s = s.tail();
    }

    return s;
  }

  @override
  bool exists(Function1<A, bool> p) {
    var these = this;

    while (!these.isEmpty) {
      if (p(these.head)) return true;
      these = these.tail();
    }

    return false;
  }

  @override
  IList<A> filter(Function1<A, bool> p) => _filterCommon(p, false);

  @override
  IList<A> filterNot(Function1<A, bool> p) => _filterCommon(p, true);

  @override
  Option<A> find(Function1<A, bool> p) {
    var these = this;

    while (!these.isEmpty) {
      if (p(these.head)) return Some(these.head);
      these = these.tail();
    }

    return none();
  }

  @override
  IList<B> flatMap<B>(covariant Function1<A, IterableOnce<B>> f) {
    var rest = this;
    Cons<B>? h;
    Cons<B>? t;
    final nilB = Nil<B>();

    while (rest.nonEmpty) {
      final it = f(rest.head).iterator;
      while (it.hasNext) {
        final nx = Cons(it.next(), nilB);
        if (t == null) {
          h = nx;
        } else {
          t.next = nx;
        }
        t = nx;
      }
      rest = rest.tail();
    }

    return h ?? nilB;
  }

  @override
  B foldLeft<B>(B z, Function2<B, A, B> op) {
    var res = z;
    var current = this;

    while (current is Cons) {
      res = op(res, current.head);
      current = (current as Cons<A>).next;
    }

    return res;
  }

  @override
  B foldRight<B>(B z, Function2<A, B, B> op) {
    var acc = z;
    var these = this;

    while (these.nonEmpty) {
      acc = op(these.head, acc);
      these = these.tail();
    }

    return acc;
  }

  @override
  bool forall(Function1<A, bool> p) {
    var these = this;

    while (!these.isEmpty) {
      if (!p(these.head)) return false;
      these = these.tail();
    }

    return true;
  }

  @override
  IMap<K, IList<A>> groupBy<K>(Function1<A, K> f) =>
      super.groupBy(f).mapValues((a) => a.toIList());

  @override
  IMap<K, IList<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues((a) => a.toIList());

  @override
  RibsIterator<IList<A>> grouped(int size) =>
      super.grouped(size).map((a) => a.toIList());

  IList<A> insertAt(int idx, A elem) {
    if (0 <= idx && idx <= length) {
      return splitAt(idx)(
          (before, after) => before.concat(after.prepended(elem)));
    } else {
      throw RangeError('$idx is out of bounds (min 0, max $length)');
    }
  }

  @override
  bool get isEmpty => this is Nil;

  @override
  RibsIterator<A> get iterator => _IListIterator(this);

  @override
  IList<A> init() => super.init().toIList();

  @override
  RibsIterator<IList<A>> inits() => super.inits().map((i) => i.toIList());

  @override
  IList<A> intersect(Seq<A> that) {
    if (isEmpty || that.isEmpty) {
      return Nil<A>();
    } else {
      final occ = _occCounts(that);
      final b = builder<A>();

      foreach((x) {
        final count = occ[x] ?? -1;

        if (count > 0) {
          b.addOne(x);

          if (count == 1) {
            occ.remove(x);
          } else {
            occ[x] = count - 1;
          }
        }
      });

      return b.toIList();
    }
  }

  @override
  IList<A> intersperse(A x) => super.intersperse(x).toIList();

  @override
  int get length {
    var these = this;
    var len = 0;
    while (!these.isEmpty) {
      len += 1;
      these = these.tail();
    }
    return len;
  }

  @override
  IList<B> map<B>(covariant Function1<A, B> f) {
    final nilB = Nil<B>();

    if (this is Nil) {
      return nilB;
    } else {
      final h = Cons(f(head), nilB);
      var t = h;
      var rest = tail();

      while (rest is! Nil) {
        final nx = Cons(f(rest.head), nilB);
        t.next = nx;
        t = nx;
        rest = rest.tail();
      }

      return h;
    }
  }

  @override
  IList<A> padTo(int len, A elem) {
    if (len > size) {
      final b = builder<A>();
      var diff = len - size;

      b.addAll(this);

      while (diff > 0) {
        b.addOne(elem);
        diff -= 1;
      }

      return b.toIList();
    } else {
      return this;
    }
  }

  @override
  (IList<A>, IList<A>) partition(Function1<A, bool> p) {
    final (first, second) = super.partition(p);
    return (first.toIList(), second.toIList());
  }

  @override
  (IList<A1>, IList<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) {
    final (l, r) = super.partitionMap(f);
    return (l.toIList(), r.toIList());
  }

  @override
  IList<A> patch(int from, IterableOnce<A> other, int replaced) {
    final b = builder<A>();
    var i = 0;
    final it = iterator;

    while (i < from && it.hasNext) {
      b.addOne(it.next());
      i += 1;
    }

    b.addAll(other);
    i = replaced;

    while (i > 0 && it.hasNext) {
      it.next();
      i -= 1;
    }

    while (it.hasNext) {
      b.addOne(it.next());
    }

    return b.toIList();
  }

  @override
  RibsIterator<IList<A>> permutations() =>
      super.permutations().map((a) => a.toIList());

  @override
  IList<A> prepended(A elem) => Cons(elem, this);

  @override
  IList<A> prependedAll(IterableOnce<A> prefix) {
    if (prefix is IList<A>) {
      if (isEmpty) {
        return prefix;
      } else if (prefix.isEmpty) {
        return this;
      } else {
        final result = Cons(prefix.head, this);
        var curr = result;
        var that = prefix.tail();
        while (!that.isEmpty) {
          final temp = Cons(that.head, this);
          curr.next = temp;
          curr = temp;
          that = that.tail();
        }

        return result;
      }
    } else if (prefix.knownSize == 0) {
      return this;
    } else if (prefix is ListBuffer<A> && isEmpty) {
      return prefix.toIList();
    } else {
      final iter = prefix.iterator;
      if (iter.hasNext) {
        final result = Cons(iter.next(), this);
        var curr = result;
        while (iter.hasNext) {
          final temp = Cons(iter.next(), this);
          curr.next = temp;
          curr = temp;
        }
        return result;
      } else {
        return this;
      }
    }
  }

  IList<A> removeAt(int idx) {
    if (0 <= idx && idx < length) {
      if (idx == 0) {
        return tail();
      } else {
        final (a, b) = splitAt(idx);
        return a.concat(b.tail());
      }
    } else {
      throw RangeError('$idx is out of bounds (min 0, max ${length - 1})');
    }
  }

  IList<A> removeFirst(Function1<A, bool> p) =>
      indexWhere(p).fold(() => this, removeAt);

  @override
  IList<A> reverse() {
    IList<A> result = Nil<A>();
    var these = this;

    while (!these.isEmpty) {
      result = Cons(these.head, result);
      these = these.tail();
    }

    return result;
  }

  @override
  IList<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  @override
  IList<B> scanLeft<B>(B z, Function2<B, A, B> op) =>
      super.scanLeft(z, op).toIList();

  @override
  IList<B> scanRight<B>(B z, Function2<A, B, B> op) =>
      super.scanRight(z, op).toIList();

  @override
  IList<A> slice(int from, int until) {
    final lo = max(from, 0);

    if (until <= lo || isEmpty) {
      return Nil<A>();
    } else {
      return drop(lo).take(until - lo);
    }
  }

  @override
  RibsIterator<IList<A>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map((a) => a.toIList());

  @override
  IList<A> sortBy<B>(Order<B> order, Function1<A, B> f) =>
      super.sortBy(order, f).toIList();

  @override
  IList<A> sorted(Order<A> order) => super.sorted(order).toIList();

  @override
  IList<A> sortWith(Function2<A, A, bool> lt) => super.sortWith(lt).toIList();

  @override
  (IList<A>, IList<A>) span(Function1<A, bool> p) {
    final b = builder<A>();

    var these = this;

    while (!these.isEmpty && p(these.head)) {
      b.addOne(these.head);
      these = these.tail();
    }

    return (b.toIList(), these);
  }

  @override
  (IList<A>, IList<A>) splitAt(int n) {
    final b = builder<A>();
    var i = 0;
    var these = this;

    while (!these.isEmpty && i < n) {
      i += 1;
      b.addOne(these.head);
      these = these.tail();
    }

    return (b.toIList(), these);
  }

  @override
  IList<A> tail();

  @override
  RibsIterator<IList<A>> tails() => RibsIterator.iterate(this, (c) => c.tail())
      .takeWhile((a) => a.nonEmpty)
      .concat(RibsIterator.single(Nil<A>()));

  @override
  IList<A> take(int n) {
    final nilA = Nil<A>();

    if (isEmpty || n <= 0) return nilA;

    final h = Cons(head, nilA);
    var t = h;
    var rest = tail();
    var i = 1;

    if (rest.isEmpty) return this;

    while (i < n) {
      if (rest.isEmpty) return this;

      i += 1;
      final nx = Cons(rest.head, nilA);
      t.next = nx;
      t = nx;
      rest = rest.tail();
    }

    return h;
  }

  @override
  IList<A> takeRight(int n) {
    if (isEmpty || n <= 0) return Nil<A>();

    var lead = drop(n);
    var lag = this;

    while (lead.nonEmpty) {
      lead = lead.tail();
      lag = lag.tail();
    }

    return lag;
  }

  @override
  IList<A> takeWhile(Function1<A, bool> p) {
    final b = builder<A>();
    var these = this;

    while (!these.isEmpty && p(these.head)) {
      b.addOne(these.head);
      these = these.tail();
    }

    return b.toIList();
  }

  @override
  IList<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  Option<NonEmptyIList<A>> toNel() => NonEmptyIList.from(this);

  @override
  Seq<A> toSeq() => this;

  @override
  String toString() => 'IList${mkString(start: '(', sep: ', ', end: ')')}';

  B uncons<B>(Function1<Option<(A, IList<A>)>, B> f) {
    if (isEmpty) {
      return f(none());
    } else {
      return f(Some((head, tail())));
    }
  }

  IList<A> updated(int idx, A elem) {
    var i = 0;
    var current = this;
    final prefix = builder<A>();

    while (i < idx && current.nonEmpty) {
      i += 1;
      prefix.addOne(current.head);
      current = current.tail();
    }

    if (i == idx && current.nonEmpty) {
      return prefix.prependToList(Cons(elem, current.tail()));
    } else {
      throw RangeError('$idx is out of bounds (min 0, max ${length - 1})');
    }
  }

  @override
  IList<(A, B)> zip<B>(IterableOnce<B> that) {
    final b = builder<(A, B)>();
    final it1 = iterator;
    final it2 = that.iterator;

    while (it1.hasNext && it2.hasNext) {
      b.addOne((it1.next(), it2.next()));
    }

    return b.toIList();
  }

  @override
  IList<(A, B)> zipAll<B>(
    IterableOnce<B> that,
    A thisElem,
    B thatElem,
  ) =>
      super.zipAll(that, thisElem, thatElem).toIList();

  @override
  IList<(A, int)> zipWithIndex() {
    final b = builder<(A, int)>();
    var i = 0;
    final it = iterator;

    while (it.hasNext) {
      b.addOne((it.next(), i));
      i += 1;
    }

    return b.toIList();
  }

  // ///////////////////////////////////////////////////////////////////////////

  /// {@template ilist_parTraverseIO}
  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. If an error or cancelation is encountered
  /// for any element, that result is returned and all other elements will be
  /// canceled if possible.
  /// {@endtemplate}
  IO<IList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    foreach((elem) {
      result =
          IO.both(result, f(elem)).map((t) => t((acc, b) => acc.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_parTraverseIO_}
  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. If an error or cancelation is encountered for any element,
  /// that result is returned and all other elements will be canceled if
  /// possible.
  /// {@endtemplate}
  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) {
    IO<Unit> result = IO.pure(Unit());

    foreach((elem) {
      result = IO.both(result, f(elem)).map((t) => t((acc, b) => Unit()));
    });

    return result;
  }

  /// {@template ilist_traverseEither}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [Left] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  Either<B, IList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) {
    Either<B, IList<C>> result = Either.pure(nil());

    foreach((elem) {
      // short circuit
      if (result.isLeft) {
        return result;
      }

      // Workaround for contravariant issues in error case
      result = result.fold(
        (_) => result,
        (acc) => f(elem).fold(
          (err) => err.asLeft(),
          (a) => acc.appended(a).asRight(),
        ),
      );
    });

    return result;
  }

  /// {@template ilist_traverseIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_traverseIO_}
  /// Applies [f] to each element of this list, discarding any results. If an
  /// error or cancelation is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) {
    var result = IO.pure(Unit());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => Unit()));
    });

    return result;
  }

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. If an error or cancelation
  /// is encountered for any element, that result is returned and any additional
  /// elements will not be evaluated.
  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      traverseIO(f).map((a) => a.flatten());

  /// {@template ilist_traverseFilterIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      traverseIO(f).map((opts) => opts.foldLeft(IList.empty<B>(),
          (acc, elem) => elem.fold(() => acc, (elem) => acc.appended(elem))));

  /// {@template ilist_traverseOption}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If [None] is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  Option<IList<B>> traverseOption<B>(Function1<A, Option<B>> f) {
    Option<IList<B>> result = Option.pure(nil());

    foreach((elem) {
      // short circuit
      if (result.isEmpty) {
        return result;
      }

      result = result.flatMap((l) => f(elem).map((b) => l.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  @override
  int get hashCode => MurmurHash3.listHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is IList) {
      var a = this;
      var b = other;

      while (a.nonEmpty && b.nonEmpty && a.head == b.head) {
        a = a.tail();
        b = b.tail();
      }

      return a.isEmpty && b.isEmpty;
    } else {
      return super == other;
    }
  }

  IList<A> _filterCommon(Function1<A, bool> p, bool isFlipped) {
    final nilA = Nil<A>();

    // we have seen elements that should be included then one that should be excluded, start building
    IList<A> partialFill(IList<A> origStart, IList<A> firstMiss) {
      final newHead = Cons(origStart.head, nilA);
      var toProcess = origStart.tail();
      var currentLast = newHead;

      // we know that all elements are :: until at least firstMiss.tail
      while (toProcess != firstMiss) {
        final newElem = Cons(toProcess.head, nilA);
        currentLast.next = newElem;
        currentLast = newElem;
        toProcess = toProcess.tail();
      }

      // at this point newHead points to a list which is a duplicate of all the 'in' elements up to the first miss.
      // currentLast is the last element in that list.

      // now we are going to try and share as much of the tail as we can, only moving elements across when we have to.
      var next = firstMiss.tail();
      // the next element we would need to copy to our list if we cant share.
      var nextToCopy = next;

      while (!next.isEmpty) {
        // generally recommended is next.isNonEmpty but this incurs an extra method call.
        final head = next.head;
        if (p(head) != isFlipped) {
          next = next.tail();
        } else {
          // its not a match - do we have outstanding elements?
          while (nextToCopy != next) {
            final newElem = Cons(nextToCopy.head, nilA);
            currentLast.next = newElem;
            currentLast = newElem;
            nextToCopy = nextToCopy.tail();
          }
          nextToCopy = next.tail();
          next = next.tail();
        }
      }

      // we have remaining elements - they are unchanged attach them to the end
      if (!nextToCopy.isEmpty) currentLast.next = nextToCopy;

      return newHead;
    }

    // everything from 'start' is included, if everything from this point is in we can return the origin
    // start otherwise if we discover an element that is out we must create a new partial list.
    IList<A> allIn(IList<A> start, IList<A> remaining) {
      var t = remaining;

      while (true) {
        if (t.isEmpty) {
          return start;
        } else {
          final x = t.head;

          if (p(x) != isFlipped) {
            t = t.tail();
          } else {
            return partialFill(start, t);
          }
        }
      }
    }

    // everything seen so far so far is not included
    IList<A> noneIn(IList<A> l) {
      var xs = l;

      while (true) {
        if (xs.isEmpty) {
          return nilA;
        } else {
          final h = xs.head;
          final t = xs.tail();

          if (p(h) != isFlipped) {
            return allIn(xs, t);
          } else {
            xs = t;
          }
        }
      }
    }

    return noneIn(this);
  }

  Map<B, int> _occCounts<B>(Seq<B> sq) {
    final occ = <B, int>{};
    sq.foreach((y) => occ.update(y, (value) => value + 1, ifAbsent: () => 1));
    return occ;
  }
}

final class Cons<A> extends IList<A> {
  @override
  final A head;

  @internal
  IList<A> next;

  Cons(this.head, this.next);

  @override
  Option<A> get headOption => Some(head);

  @override
  IList<A> tail() => next;
}

final class Nil<A> extends IList<A> {
  const Nil();

  @override
  int get knownSize => 0;

  @override
  IList<A> tail() => throw UnsupportedError('tail on empty');
}

final class _IListIterator<A> extends RibsIterator<A> {
  IList<A> current;

  _IListIterator(this.current);

  @override
  bool get hasNext => current.nonEmpty;

  @override
  A next() {
    final r = current.head;
    current = current.tail();
    return r;
  }
}
