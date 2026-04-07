// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// An immutable, lazily-evaluated (potentially infinite) sequence.
///
/// Elements are computed on demand and memoized after first evaluation.
/// Operations like [map], [filter], [take], and [drop] return new lazy lists
/// without forcing evaluation. Operations marked "Will force evaluation" in
/// their doc comment traverse the whole list eagerly.
///
/// Construct with [ILazyList.from], [ILazyList.fromDart], [ILazyList.fill],
/// [ILazyList.tabulate], [ILazyList.continually], [ILazyList.ints],
/// [ILazyList.iterate], or [ILazyList.unfold]. Use [ILazyList.builder] when
/// building incrementally.
///
/// ```dart
/// // infinite sequence of natural numbers
/// final nats = ILazyList.ints(0);
/// nats.take(5).toIList(); // IList(0, 1, 2, 3, 4)
/// ```
final class ILazyList<A> with RIterableOnce<A>, RIterable<A>, RSeq<A> {
  late Function0<_State<A>>? _lazyState;
  bool _stateEvaluated = false;
  bool _midEvaluation = false;

  late final _State<A> _state = _evaluateState();

  ILazyList._(Function0<_State<A>> lazyState) : _lazyState = lazyState;

  _State<A> _evaluateState() {
    if (_midEvaluation) {
      throw Exception('self-referential ILazyList or a derivation thereof has no more elements');
    }

    _midEvaluation = true;

    final _State<A> res;

    try {
      res = _lazyState!();
    } finally {
      _midEvaluation = false;
    }

    _stateEvaluated = true;
    _lazyState = null;

    return res;
  }

  /// Returns a mutable builder that accumulates elements into an [ILazyList].
  static ILazyListBuilder<A> builder<A>() => ILazyListBuilder();

  /// Returns an infinite lazy list where every element is [elem].
  static ILazyList<A> continually<A>(A elem) => _newLL(() => _sCons(elem, continually(elem)));

  /// Returns an empty [ILazyList].
  static ILazyList<A> empty<A>() => _newLL(() => _Empty<A>()).force();

  /// Creates a lazy list of length [len] where every element is [elem].
  static ILazyList<A> fill<A>(int len, A elem) =>
      len > 0 ? _newLL(() => _sCons(elem, fill(len - 1, elem))) : empty<A>();

  /// Creates an [ILazyList] from any [RIterableOnce].
  ///
  /// Returns [coll] directly when it is already an [ILazyList].
  static ILazyList<A> from<A>(RIterableOnce<A> coll) {
    if (coll is ILazyList<A>) {
      return coll;
    } else if (coll.knownSize == 0) {
      return empty();
    } else {
      return _newLL(() => _stateFromIterator(coll.iterator));
    }
  }

  /// Returns an infinite lazy list of integers beginning at [start],
  /// incrementing by [step] (default 1).
  static ILazyList<int> ints(int start, [int step = 1]) =>
      _newLL(() => _sCons(start, ints(start + step, step)));

  /// Returns an infinite lazy list produced by repeatedly applying [f],
  /// starting from the value `start()`.
  static ILazyList<A> iterate<A>(Function0<A> start, Function1<A, A> f) => _newLL(() {
    final head = start();
    return _sCons(head, iterate(() => f(head), f));
  });

  /// Creates a lazy list of length [n] where element `i` is `f(i)`.
  ///
  /// Returns an empty list when `n <= 0`.
  static ILazyList<A> tabulate<A>(int n, Function1<int, A> f) {
    ILazyList<A> at(int index) {
      if (index < n) {
        return _newLL(() => _sCons(f(index), at(index + 1)));
      } else {
        return empty();
      }
    }

    return at(0);
  }

  /// Creates a lazy list by unfolding [initial] state with [f].
  ///
  /// Each call to [f] either returns `Some((element, nextState))` to emit
  /// an element and continue, or [None] to terminate the list.
  static ILazyList<A> unfold<A, S>(
    S initial,
    Function1<S, Option<(A, S)>> f,
  ) => _newLL(
    () => f(initial).fold(
      () => _Empty<A>(),
      (t) => _sCons(t.$1, unfold(t.$2, f)),
    ),
  );

  @override
  A operator [](int idx) {
    if (idx < 0) throw RangeError.index(idx, 'Invalid ILazyList index: $idx');
    final skipped = drop(idx);

    if (skipped.isEmpty) {
      throw RangeError.index(idx, 'Invalid ILazyList index: $idx');
    }

    return skipped.head;
  }

  @override
  ILazyList<A> appended(A elem) {
    if (knownIsEmpty) {
      return _newLL(() => _sCons(elem, ILazyList.empty()));
    } else {
      return lazyAppendedAll(() => RIterator.single(elem));
    }
  }

  @override
  ILazyList<A> appendedAll(RIterableOnce<A> suffix) {
    if (knownIsEmpty) {
      return ILazyList.from(suffix);
    } else {
      return lazyAppendedAll(() => suffix);
    }
  }

  @override
  ILazyList<B> collect<B>(Function1<A, Option<B>> f) =>
      knownIsEmpty ? empty() : _collectImpl(this, f);

  ILazyList<B> _collectImpl<B>(ILazyList<A> ll, Function1<A, Option<B>> f) {
    return _newLL(() {
      var rest = ll;
      Option<B> res = none();

      while (res.isEmpty && !rest.isEmpty) {
        res = f(rest.head);
        rest = rest.tail;
      }

      return res.fold(() => _Empty(), (b) => _sCons(b, _collectImpl(rest, f)));
    });
  }

  @override
  Option<B> collectFirst<B>(Function1<A, Option<B>> f) {
    if (isEmpty) {
      return none();
    } else {
      var res = f(head);
      var rest = tail;

      while (res.isEmpty && !rest.isEmpty) {
        res = f(rest.head);
        rest = rest.tail;
      }

      return res;
    }
  }

  /// Will force evaluation
  @override
  RIterator<ILazyList<A>> combinations(int n) => super.combinations(n).map(ILazyList.from);

  @override
  ILazyList<A> concat(RIterableOnce<A> suffix) => appendedAll(suffix);

  @override
  ILazyList<A> diff(RSeq<A> that) {
    // Re-implemented to preserve laziness

    final occ = <A, int>{};
    that.foreach((y) => occ.update(y, (value) => value + 1, ifAbsent: () => 1));

    final it = iterator.filter((key) {
      var include = false;

      if (occ.containsKey(key)) {
        final value = occ[key]!;
        if (value == 1) {
          occ.remove(key);
        } else {
          occ[key] = value - 1;
        }
      } else {
        include = true;
        occ.remove(key);
      }

      return include;
    });

    return ILazyList.from(it);
  }

  @override
  ILazyList<A> distinct() => distinctBy(identity);

  @override
  ILazyList<A> distinctBy<B>(Function1<A, B> f) =>
      _newLL(() => _stateFromIterator(iterator.distinctBy(f)));

  @override
  ILazyList<A> drop(int n) {
    if (n <= 0) {
      return this;
    } else if (knownIsEmpty) {
      return empty();
    } else {
      return _dropImpl(this, n);
    }
  }

  ILazyList<A> _dropImpl(ILazyList<A> ll, int n) {
    return _newLL(() {
      var rest = ll;
      var i = n;

      while (i > 0 && !rest.isEmpty) {
        rest = rest.tail;
        i -= 1;
      }

      return rest._state;
    });
  }

  @override
  ILazyList<A> dropRight(int n) {
    if (n <= 0) {
      return this;
    } else if (knownIsEmpty) {
      return empty();
    } else {
      return _newLL(() {
        var scout = this;
        var remaining = n;

        // advance scout n elements ahead (or until empty)
        while (remaining > 0 && !scout.isEmpty) {
          remaining -= 1;
          scout = scout.tail;
        }

        return _dropRightState(scout);
      });
    }
  }

  _State<A> _dropRightState(ILazyList<A> scout) {
    if (scout.isEmpty) {
      return _Empty();
    } else {
      return _sCons(head, _newLL(() => tail._dropRightState(scout.tail)));
    }
  }

  @override
  ILazyList<A> dropWhile(Function1<A, bool> p) {
    if (knownIsEmpty) {
      return empty();
    } else {
      return _dropWhileImpl(this, p);
    }
  }

  ILazyList<A> _dropWhileImpl(ILazyList<A> ll, Function1<A, bool> p) {
    return _newLL(() {
      var rest = ll;
      while (!rest.isEmpty && p(rest.head)) {
        rest = rest.tail;
      }

      return rest._state;
    });
  }

  @override
  ILazyList<A> filter(Function1<A, bool> p) => knownIsEmpty ? empty() : _filterImpl(this, p, false);

  @override
  ILazyList<A> filterNot(Function1<A, bool> p) =>
      knownIsEmpty ? empty() : _filterImpl(this, p, true);

  ILazyList<A> _filterImpl(
    ILazyList<A> ll,
    Function1<A, bool> p,
    bool isFlipped,
  ) {
    return _newLL(() {
      late A elem;
      var rest = ll;
      bool found = false;

      while (!found && !rest.isEmpty) {
        elem = rest.head;
        found = p(elem) != isFlipped;
        rest = rest.tail;
      }

      return found ? _sCons(elem, _filterImpl(rest, p, isFlipped)) : _Empty();
    });
  }

  @override
  Option<A> find(Function1<A, bool> p) {
    if (isEmpty) {
      return none();
    } else {
      var rest = this;

      while (!rest.isEmpty) {
        if (p(rest.head)) return Some(rest.head);
        rest = rest.tail;
      }

      return none();
    }
  }

  @override
  ILazyList<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) =>
      knownIsEmpty ? empty() : _flatMapImpl(this, f);

  ILazyList<B> _flatMapImpl<B>(
    ILazyList<A> ll,
    Function1<A, RIterableOnce<B>> f,
  ) {
    return _newLL(() {
      var rest = ll;
      RIterator<B>? it;
      var itHasNext = false;

      while (!itHasNext && !rest.isEmpty) {
        it = f(rest.head).iterator;
        itHasNext = it.hasNext;
        if (!itHasNext) {
          rest = rest.tail;
        }
      }

      if (itHasNext) {
        final head = it!.next();
        rest = rest.tail;
        return _sCons(
          head,
          _newLL(() => _stateFromIteratorConcatSuffix(it!, () => _flatMapImpl(rest, f)._state)),
        );
      } else {
        return _Empty();
      }
    });
  }

  @override
  B foldLeft<B>(B z, Function2<B, A, B> op) {
    var result = z;
    var these = this;

    while (!these.isEmpty) {
      result = op(result, these.head);
      these = these.tail;
    }

    return result;
  }

  /// Forces evaluation of the entire list and returns `this`.
  ///
  /// After calling [force], all elements are memoized. Has no effect on an
  /// already-evaluated list.
  ILazyList<A> force() {
    ILazyList<A> these = this;
    ILazyList<A> those = this;

    if (!these.isEmpty) {
      these = these.tail;
    }

    while (those != these) {
      if (these.isEmpty) return this;
      these = these.tail;
      if (these.isEmpty) return this;
      these = these.tail;
      if (these == those) return this;
      those = those.tail;
    }

    return this;
  }

  @override
  void foreach<U>(Function1<A, U> f) {
    var these = this;
    while (!these.isEmpty) {
      f(these.head);
      these = these.tail;
    }
  }

  /// Will force evaluation
  @override
  IMap<K, ILazyList<A>> groupBy<K>(Function1<A, K> f) => super.groupBy(f).mapValues(ILazyList.from);

  @override
  RIterator<ILazyList<A>> grouped(int size) => _slidingImpl(size, size);

  /// Will force evaluation
  @override
  IMap<K, ILazyList<B>> groupMap<K, B>(Function1<A, K> key, Function1<A, B> f) =>
      super.groupMap(key, f).mapValues(ILazyList.from);

  @override
  A get head => _state.head;

  /// Will force evaluation
  @override
  ILazyList<A> get init => ILazyList.from(super.init);

  /// Will force evaluation
  @override
  RIterator<ILazyList<A>> get inits => super.inits.map(ILazyList.from);

  @override
  ILazyList<A> intersect(RSeq<A> that) {
    // Re-implemented to preserve laziness

    final occ = <A, int>{};
    that.foreach((y) => occ.update(y, (value) => value + 1, ifAbsent: () => 1));

    final it = iterator.filter((key) {
      var include = true;

      if (occ.containsKey(key)) {
        final value = occ[key]!;
        if (value == 1) {
          occ.remove(key);
        } else {
          occ[key] = value - 1;
        }
      } else {
        include = false;
        occ.remove(key);
      }

      return include;
    });

    return ILazyList.from(it);
  }

  @override
  ILazyList<A> intersperse(A x) => knownIsEmpty ? this : _intersperseImpl(x, false);

  ILazyList<A> _intersperseImpl(A x, bool addIt) {
    if (knownIsEmpty) {
      return this;
    } else {
      return _newLL(() {
        final hd = addIt ? x : head;

        final tl =
            (isEmpty || addIt) ? _intersperseImpl(x, !addIt) : tail._intersperseImpl(x, !addIt);

        return _sCons(hd, tl);
      });
    }
  }

  @override
  bool get isEmpty => _state is _Empty;

  @override
  RIterator<A> get iterator => knownIsEmpty ? RIterator.empty() : _LazyIterator(this);

  @override
  int get knownSize => knownIsEmpty ? 0 : -1;

  /// Appends all elements produced by [suffix] lazily, without evaluating
  /// [suffix] until the end of this list is reached.
  ILazyList<A> lazyAppendedAll(Function0<RIterableOnce<A>> suffix) {
    return _newLL(() {
      if (isEmpty) {
        final foo = suffix();

        if (foo is ILazyList<A>) {
          return foo._state;
        } else if (foo.knownSize == 0) {
          return _Empty<A>();
        } else {
          return _stateFromIterator(foo.iterator);
        }
      } else {
        return _sCons(head, tail.lazyAppendedAll(suffix));
      }
    });
  }

  @override
  int get length {
    var these = this;
    var len = 0;

    while (these.nonEmpty) {
      len += 1;
      these = these.tail;
    }

    return len;
  }

  @override
  ILazyList<B> map<B>(Function1<A, B> f) {
    if (knownIsEmpty) {
      return empty();
    } else {
      return _mapImpl(f);
    }
  }

  ILazyList<B> _mapImpl<B>(Function1<A, B> f) =>
      _newLL(() => isEmpty ? _Empty() : _sCons(f(head), tail._mapImpl(f)));

  @override
  ILazyList<A> padTo(int len, A elem) {
    if (len <= 0) {
      return this;
    } else {
      return _newLL(() {
        if (isEmpty) {
          return ILazyList.fill(len, elem)._state;
        } else {
          return _sCons(head, tail.padTo(len - 1, elem));
        }
      });
    }
  }

  @override
  (ILazyList<A>, ILazyList<A>) partition(Function1<A, bool> p) => (filter(p), filterNot(p));

  @override
  (ILazyList<A1>, ILazyList<A2>) partitionMap<A1, A2>(
    Function1<A, Either<A1, A2>> f,
  ) {
    final (left, right) = map(f).partition((x) => x.isLeft);

    final a1s = left.map((l) => (l as Left<A1, A2>).a);
    final a2s = right.map((l) => (l as Right<A1, A2>).b);

    return (a1s, a2s);
  }

  @override
  ILazyList<A> patch(int from, RIterableOnce<A> other, int replaced) {
    if (knownIsEmpty) {
      return ILazyList.from(other);
    } else {
      return _patchImpl(from, other, replaced);
    }
  }

  ILazyList<A> _patchImpl(int from, RIterableOnce<A> other, int replaced) {
    return _newLL(() {
      if (from <= 0) {
        return _stateFromIteratorConcatSuffix(
          other.iterator,
          () => _dropImpl(this, replaced)._state,
        );
      } else if (isEmpty) {
        return _stateFromIterator(other.iterator);
      } else {
        return _sCons(head, tail._patchImpl(from - 1, other, replaced));
      }
    });
  }

  /// Will force evaluation
  @override
  RIterator<ILazyList<A>> permutations() => super.permutations().map(ILazyList.from);

  @override
  ILazyList<A> prepended(A elem) => _newLL(() => _sCons(elem, this));

  @override
  ILazyList<A> prependedAll(RIterableOnce<A> prefix) {
    if (knownIsEmpty) {
      return ILazyList.from(prefix);
    } else if (prefix.knownSize == 0) {
      return this;
    } else {
      return _newLL(() => _stateFromIteratorConcatSuffix(prefix.iterator, () => _state));
    }
  }

  /// Prepends a lazily-computed element [f] to the front of this list.
  ///
  /// [f] is not called until the first element is demanded.
  ILazyList<A> prependedLazy(Function0<A> f) => _newLL(() => _sCons(f(), this));

  @override
  A reduceLeft(Function2<A, A, A> op) {
    if (isEmpty) {
      throw UnsupportedError('empty.reduceLeft');
    } else {
      var reducedRes = head;
      var left = tail;

      while (!left.isEmpty) {
        reducedRes = op(reducedRes, left.head);
        left = left.tail;
      }

      return reducedRes;
    }
  }

  @override
  ILazyList<A> removeAt(int idx) {
    if (0 <= idx && !knownIsEmpty) {
      return _newLL(() {
        if (idx == 0) {
          return tail._state;
        } else {
          return _sCons(head, tail.removeAt(idx - 1));
        }
      });
    } else {
      throw RangeError('$idx is out of bounds (min 0, max ${length - 1})');
    }
  }

  /// Returns a new lazy list with the first element satisfying [p] removed.
  ///
  /// Returns this list unchanged if no element matches.
  ILazyList<A> removeFirst(Function1<A, bool> p) {
    if (knownIsEmpty) {
      return this;
    } else {
      if (p(head)) {
        return tail;
      } else {
        return _newLL(() => _sCons(head, tail.removeFirst(p)));
      }
    }
  }

  @override
  ILazyList<A> reverse() => _reverseOnto(empty());

  ILazyList<A> _reverseOnto(ILazyList<A> tl) {
    var result = tl;
    var current = this;

    while (!current.isEmpty) {
      final h = current.head;
      final t = result;
      result = _newLL(() => _sCons(h, t));
      current = current.tail;
    }

    return result;
  }

  @override
  bool sameElements(RIterable<A> that) {
    var a = this;
    var b = that;

    while (a.nonEmpty && b.nonEmpty) {
      if (identical(a, b)) return true;
      if (a.head != b.head) return false;

      a = a.tail;
      b = b.tail;
    }

    return a.isEmpty && b.isEmpty;
  }

  @override
  ILazyList<B> scan<B>(B z, Function2<B, A, B> op) => scanLeft(z, op);

  @override
  ILazyList<B> scanLeft<B>(B z, Function2<B, A, B> op) {
    if (knownIsEmpty) {
      return _newLL(() => _sCons(z, empty()));
    } else {
      return _newLL(() => _scanLeftState(z, op));
    }
  }

  _State<B> _scanLeftState<B>(B z, Function2<B, A, B> op) => _sCons(
    z,
    _newLL(() {
      if (isEmpty) {
        return _Empty();
      } else {
        return tail._scanLeftState(op(z, head), op);
      }
    }),
  );

  /// Will force evaluation
  @override
  ILazyList<B> scanRight<B>(B z, Function2<A, B, B> op) => ILazyList.from(super.scanRight(z, op));

  @override
  ILazyList<A> slice(int from, int until) => take(until).drop(from);

  @override
  RIterator<ILazyList<A>> sliding(int size, [int step = 1]) => _slidingImpl(size, step);

  RIterator<ILazyList<A>> _slidingImpl(int size, int step) {
    if (knownIsEmpty) {
      return RIterator.empty();
    } else {
      return _SlidingIterator(this, size, step);
    }
  }

  /// Will force evaluation
  @override
  ILazyList<A> sortBy<B>(Order<B> order, Function1<A, B> f) => sorted(order.contramap(f));

  /// Will force evaluation
  @override
  ILazyList<A> sorted(Order<A> order) => ILazyList.from(super.sorted(order));

  /// Will force evaluation
  @override
  ILazyList<A> sortWith(Function2<A, A, bool> lt) => sorted(Order.fromLessThan(lt));

  @override
  (ILazyList<A>, ILazyList<A>) span(Function1<A, bool> p) => (takeWhile(p), dropWhile(p));

  @override
  (ILazyList<A>, ILazyList<A>) splitAt(int n) => (take(n), drop(n));

  @override
  ILazyList<A> get tail => _state.tail;

  @override
  RIterator<ILazyList<A>> get tails => ILazyList.iterate(
    () => this,
    (ll) => ll.nonEmpty ? ll.tail : ll,
  ).iterator.takeWhile((ll) => ll.nonEmpty).concat(RIterator.single(ILazyList.empty()));

  @override
  ILazyList<A> take(int n) {
    if (knownIsEmpty) {
      return empty();
    } else {
      return _takeImpl(n);
    }
  }

  ILazyList<A> _takeImpl(int n) {
    if (n <= 0) {
      return empty();
    } else {
      return _newLL(() {
        if (isEmpty) {
          return _Empty();
        } else {
          return _sCons(head, tail._takeImpl(n - 1));
        }
      });
    }
  }

  @override
  ILazyList<A> takeRight(int n) {
    if (n <= 0 || knownIsEmpty) {
      return empty();
    } else {
      return _takeRightImpl(this, n);
    }
  }

  ILazyList<A> _takeRightImpl(ILazyList<A> ll, int n) {
    return _newLL(() {
      var rest = ll;
      var scout = ll;
      var remaining = n;

      while (remaining > 0 && !scout.isEmpty) {
        scout = scout.tail;
        remaining -= 1;
      }

      while (!scout.isEmpty) {
        scout = scout.tail;
        rest = rest.tail;
      }

      return rest._state;
    });
  }

  @override
  ILazyList<A> takeWhile(Function1<A, bool> p) {
    if (knownIsEmpty) {
      return empty();
    } else {
      return _takeWhileImpl(p);
    }
  }

  ILazyList<A> _takeWhileImpl(Function1<A, bool> p) => _newLL(() {
    if (isEmpty || !p(head)) {
      return _Empty();
    } else {
      return _sCons(head, tail._takeWhileImpl(p));
    }
  });

  @override
  ILazyList<A> tapEach<U>(Function1<A, U> f) => map((a) {
    f(a);
    return a;
  });

  /// Will force evaluation
  @override
  Either<B, ILazyList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) =>
      super.traverseEither(f).map(ILazyList.from);

  /// Will force evaluation
  @override
  Option<ILazyList<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      super.traverseOption(f).map(ILazyList.from);

  @override
  ILazyList<A> updated(int index, A elem) => _updatedImpl(index, elem, index);

  ILazyList<A> _updatedImpl(int index, A elem, int startIndex) {
    if (index < 0) throw RangeError('invalid index: $startIndex');

    return _newLL(() {
      if (index <= 0) {
        return _sCons(elem, tail);
      } else if (tail.isEmpty) {
        throw RangeError('invalid index: $startIndex');
      } else {
        return _sCons(head, tail._updatedImpl(index - 1, elem, startIndex));
      }
    });
  }

  @override
  ILazyList<(A, B)> zip<B>(RIterableOnce<B> that) {
    if (knownIsEmpty || that.knownSize == 0) {
      return empty();
    } else {
      return _newLL(() => _zipState(that.iterator));
    }
  }

  _State<(A, B)> _zipState<B>(RIterator<B> it) {
    if (isEmpty || !it.hasNext) {
      return _Empty();
    } else {
      return _sCons((head, it.next()), _newLL(() => tail._zipState(it)));
    }
  }

  @override
  ILazyList<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) {
    if (knownIsEmpty) {
      if (that.knownSize == 0) {
        return empty();
      } else {
        return ILazyList.continually(thisElem).zip(that);
      }
    } else {
      if (that.knownSize == 0) {
        return zip(ILazyList.continually(thatElem));
      } else {
        return _newLL(() => _zipAllState(that.iterator, thisElem, thatElem));
      }
    }
  }

  _State<(A, B)> _zipAllState<B>(RIterator<B> it, A thisElem, B thatElem) {
    if (it.hasNext) {
      if (isEmpty) {
        return _sCons((
          head,
          it.next(),
        ), _newLL(() => ILazyList.continually(thisElem)._zipState(it)));
      } else {
        return _sCons((head, it.next()), _newLL(() => tail._zipAllState(it, thisElem, thatElem)));
      }
    } else {
      if (isEmpty) {
        return _Empty();
      } else {
        return _sCons((head, thatElem), tail.zip(ILazyList.continually(thatElem)));
      }
    }
  }

  @override
  ILazyList<(A, int)> zipWithIndex() => zip(ILazyList.ints(0));

  // TODO: hashCode / ==

  @override
  String toString() => addStringNoForce(StringBuffer('ILazyList'), '(', ', ', ')').toString();

  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////

  /// `true` if the list has already been evaluated and is empty.
  ///
  /// Unlike [isEmpty], this does not force evaluation.
  bool get knownIsEmpty => _stateEvaluated && isEmpty;

  /// `true` if the list has already been evaluated and is non-empty.
  ///
  /// Unlike [nonEmpty], this does not force evaluation.
  bool get knownNonEmpty => _stateEvaluated && !isEmpty;

  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////

  static ILazyList<A> _newLL<A>(Function0<_State<A>> state) => ILazyList._(state);

  static _State<A> _sCons<A>(A hd, ILazyList<A> tl) => _Cons(hd, tl);

  static _State<A> _stateFromIteratorConcatSuffix<A>(
    RIterator<A> it,
    Function0<_State<A>> suffix,
  ) {
    if (it.hasNext) {
      return _sCons(
        it.next(),
        _newLL(() => _stateFromIteratorConcatSuffix(it, suffix)),
      );
    } else {
      return suffix();
    }
  }

  static _State<A> _stateFromIterator<A>(RIterator<A> it) {
    if (it.hasNext) {
      return _sCons(it.next(), _newLL(() => _stateFromIterator(it)));
    } else {
      return _Empty();
    }
  }

  bool _lengthGt(int len) {
    if (len < 0) return true;

    var i = len;
    var rest = this;

    while (i > 0 && !rest.isEmpty) {
      rest = rest.tail;
      i -= 1;
    }

    return i >= 0 && !rest.isEmpty;
  }

  StringBuffer addStringNoForce(
    StringBuffer b,
    String start,
    String sep,
    String end,
  ) {
    b.write(start);

    if (!_stateEvaluated) {
      b.write('<not computed>');
    } else if (!isEmpty) {
      b.write(head);

      var cursor = this;

      void appendHead(ILazyList<A> c) =>
          b
            ..write(sep)
            ..write(c.head);

      var scout = tail;

      if (!identical(cursor, scout)) {
        cursor = scout;

        if (scout.knownNonEmpty) {
          scout = scout.tail;

          // Use 2x 1x iterator trick for cycle detection; slow iterator can add strings
          while (!identical(cursor, scout) && scout.knownNonEmpty) {
            appendHead(cursor);
            cursor = cursor.tail;
            scout = scout.tail;
            if (scout.knownNonEmpty) scout = scout.tail;
          }
        }
      }

      if (!scout.knownNonEmpty) {
        // Not a cycle, scout hit an end (empty or non-evaluated)
        while (!identical(cursor, scout)) {
          appendHead(cursor);
          cursor = cursor.tail;
        }

        // if cursor (eq scout) has state defined, it is empty; else unknown state
        if (!cursor._stateEvaluated) {
          b
            ..write(sep)
            ..write('<not computed>');
        }
      } else {
        if (!identical(cursor, this)) {
          var runner = this;
          while (!identical(runner, scout)) {
            runner = runner.tail;
            scout = scout.tail;
          }

          do {
            final ct = cursor.tail;

            if (!identical(ct, scout)) appendHead(cursor);

            cursor = ct;
          } while (!identical(cursor, scout));
        }

        b
          ..write(sep)
          ..write('<cycle>');
      }
    }

    return b..write(end);
  }
}

final class _LazyIterator<A> extends RIterator<A> {
  ILazyList<A> lazyList;

  _LazyIterator(this.lazyList);

  @override
  bool get hasNext => !lazyList.isEmpty;

  @override
  A next() {
    if (lazyList.isEmpty) {
      noSuchElement();
    } else {
      final res = lazyList.head;
      lazyList = lazyList.tail;
      return res;
    }
  }
}

final class _SlidingIterator<A> extends RIterator<ILazyList<A>> {
  final int sz;
  final int step;
  final int minLen;

  ILazyList<A> lazyList;
  bool first = true;

  _SlidingIterator(this.lazyList, this.sz, this.step) : minLen = sz - max(step, 0);

  @override
  bool get hasNext {
    return first ? !lazyList.isEmpty : lazyList._lengthGt(minLen);
  }

  @override
  ILazyList<A> next() {
    if (!hasNext) {
      noSuchElement();
    } else {
      first = false;
      final list = lazyList;
      lazyList = list.drop(step);
      return list.take(size);
    }
  }
}

sealed class _State<A> {
  A get head;
  ILazyList<A> get tail;
}

final class _Empty<A> extends _State<A> {
  @override
  A get head => throw UnsupportedError('head of empty lazy list');

  @override
  ILazyList<A> get tail => throw UnsupportedError('tail of empty lazy list');

  @override
  String toString() => 'ILazyList.State.Empty';
}

final class _Cons<A> extends _State<A> {
  @override
  final A head;
  @override
  final ILazyList<A> tail;

  _Cons(this.head, this.tail);

  @override
  String toString() => 'ILazyList.State.Cons($head, $tail)';
}

/// A mutable builder for constructing [ILazyList] instances.
///
/// Elements are appended lazily; the output list is not evaluated until
/// iterated. Obtain via [ILazyList.builder].
final class ILazyListBuilder<A> {
  late _DeferredState<A> _next;
  late ILazyList<A> _list;

  ILazyListBuilder() {
    clear();
  }

  /// Appends all elements from [elems] to this builder and returns `this`.
  ILazyListBuilder<A> addAll(RIterableOnce<A> elems) {
    if (elems.knownSize != 0) {
      final deferred = _DeferredState<A>();
      _next.init(
        () => ILazyList._stateFromIteratorConcatSuffix(elems.iterator, () => deferred.eval()),
      );
      _next = deferred;
    }

    return this;
  }

  /// Appends a single element [elem] to this builder and returns `this`.
  ILazyListBuilder<A> addOne(A elem) {
    final deferred = _DeferredState<A>();
    _next.init(() => ILazyList._sCons(elem, ILazyList._newLL(() => deferred.eval())));
    _next = deferred;
    return this;
  }

  /// Resets this builder to an empty state so it can be reused.
  void clear() {
    final deferred = _DeferredState<A>();
    _list = ILazyList._newLL(() => deferred.eval());
    _next = deferred;
  }

  /// Returns the [ILazyList] containing all elements added so far.
  ILazyList<A> result() {
    _next.init(() => _Empty<A>());
    return _list;
  }
}

final class _DeferredState<A> {
  late Function0<_State<A>> _state;

  _State<A> eval() {
    final state = _state;
    return state();
  }

  // ignore: use_setters_to_change_properties
  void init(Function0<_State<A>> state) {
    _state = state;
  }
}

extension ILazyListNestedOps<A> on ILazyList<ILazyList<A>> {
  /// Combines all nested lazy lists into one using concatenation.
  ILazyList<A> flatten() => flatMap(identity);
}
