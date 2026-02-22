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

import 'package:ribs_core/ribs_core.dart';

IChain<A> ichain<A>(Iterable<A> as) => IChain.fromDart(as);

/// Sequence collection that provides constant time append, prepend and concat.
sealed class IChain<A> with RIterableOnce<A>, RIterable<A>, RSeq<A> {
  const IChain._();

  static IChain<A> empty<A>() => _Empty<A>();

  static IChain<A> fromSeq<A>(RSeq<A> iseq) => switch (iseq) {
    _ when iseq.isEmpty => _Empty<A>(),
    _ when iseq.size == 1 => _Singleton(iseq.head),
    _ => _Wrap(iseq),
  };

  static IChain<A> from<A>(RIterableOnce<A> elems) {
    if (elems is IChain<A>) {
      return elems;
    } else if (elems is RSeq<A>) {
      return fromSeq(elems);
    } else {
      return _Wrap(elems.toIVector());
    }
  }

  /// Creates an [IChain] from the given Dart [Iterable].
  static IChain<A> fromDart<A>(Iterable<A> elems) => from(RIterator.fromDart(elems.iterator));

  static IChain<A> one<A>(A a) => _Singleton(a);

  @override
  A operator [](int idx) {
    A? result;
    var i = 0;

    _foreachUntil((a) {
      if (i == idx) {
        result = a;
        return true;
      } else {
        i += 1;
        return false;
      }
    });

    if (result != null) return result!;

    throw RangeError.index(idx, this);
  }

  @override
  IChain<A> appended(A elem) => concat(one(elem));

  @override
  IChain<A> appendedAll(RIterableOnce<A> suffix) => concat(suffix);

  @override
  IChain<B> collect<B>(Function1<A, Option<B>> f) =>
      foldLeft(empty<B>(), (acc, elem) => f(elem).fold(() => acc, (a) => acc.appended(a)));

  @override
  IChain<A> concat(RIterableOnce<A> suffix) {
    final thatChain = from(suffix);

    return switch (this) {
      final _NonEmpty<A> non1 => switch (thatChain) {
        final _NonEmpty<A> non2 => _Append(non1, non2),
        _ => non1,
      },
      _ => thatChain,
    };
  }

  @override
  IChain<A> dropWhile(Function1<A, bool> p) {
    var rem = this;

    while (true) {
      final x = rem.uncons();

      if (x.isDefined) {
        final (hd, tl) = (x as Some<(A, IChain<A>)>).value;
        final pr = p(hd);

        if (pr) {
          rem = tl;
        } else {
          return rem;
        }
      } else {
        return empty();
      }
    }
  }

  @override
  IChain<A> filter(Function1<A, bool> p) => collect((a) => Option.when(() => p(a), () => a));

  @override
  IChain<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  IChain<B> flatMap<B>(Function1<A, RIterableOnce<B>> f) {
    var result = empty<B>();
    final it = iterator;

    while (it.hasNext) {
      result = result.concat(from(f(it.next())));
    }

    return result;
  }

  @override
  B foldLeft<B>(B z, Function2<B, A, B> op) {
    var result = z;
    final it = iterator;

    while (it.hasNext) {
      result = op(result, it.next());
    }

    return result;
  }

  @override
  B foldRight<B>(B z, Function2<A, B, B> op) {
    var result = z;
    final it = reverseIterator();

    while (it.hasNext) {
      result = op(it.next(), result);
    }

    return result;
  }

  @override
  Option<A> get headOption => uncons().map((a) => a.$1);

  @override
  IChain<A> get init => initLast().map((a) => a.$1).getOrElse(() => empty());

  Option<(IChain<A>, A)> initLast() {
    if (this is _NonEmpty<A>) {
      var c = this as _NonEmpty<A>;
      _NonEmpty<A>? lefts;
      (IChain<A>, A)? result;

      while (result == null) {
        if (c is _Singleton<A>) {
          result = (lefts ?? empty<A>(), c.a);
        } else if (c is _Append<A>) {
          lefts = lefts == null ? c.leftNE : _Append(lefts, c.leftNE);
          c = c.rightNE;
        } else if (c is _Wrap<A>) {
          final init = from(c.seq.init);
          final IChain<A> pre;

          if (lefts == null) {
            pre = init;
          } else {
            pre = switch (init) {
              final _NonEmpty<A> non => _Append(lefts, non),
              _ => lefts,
            };
          }

          result = (pre, c.seq.last);
        }
      }

      return Option(result);
    } else {
      return none();
    }
  }

  @override
  bool get isEmpty => this is _Empty;

  @override
  RIterator<A> get iterator => switch (this) {
    _Wrap(:final seq) => seq.iterator,
    _Singleton(:final a) => RIterator.single(a),
    final _Append<A> app => _ChainRIterator(app),
    _ => RIterator.empty(),
  };

  @override
  int get knownSize => switch (this) {
    final _Empty<A> _ => 0,
    final _Singleton<A> _ => 1,
    _Wrap(:final seq) => seq.knownSize,
    _ => -1,
  };

  @override
  Option<A> get lastOption => initLast().map((t) => t.$2);

  @override
  int get length {
    int loop(_NonEmpty<A> hd, IList<_NonEmpty<A>> tl, int acc) {
      var currentHD = hd;
      var currentTL = tl;
      var currentAcc = acc;

      while (true) {
        switch (currentHD) {
          case _Append(:final leftNE, :final rightNE):
            currentHD = leftNE;
            currentTL = currentTL.prepended(rightNE);
          case final _Singleton<A> _:
            currentAcc += 1;
            if (currentTL.nonEmpty) {
              currentHD = currentTL.head;
              currentTL = currentTL.tail;
            } else {
              return currentAcc;
            }
          case _Wrap<A>(:final seq):
            currentAcc += seq.length;
            if (currentTL.nonEmpty) {
              currentHD = currentTL.head;
              currentTL = currentTL.tail;
            } else {
              return currentAcc;
            }
        }
      }
    }

    return switch (this) {
      final _NonEmpty<A> ne => loop(ne, nil(), 0),
      _ => 0,
    };
  }

  @override
  IChain<B> map<B>(Function1<A, B> f) {
    return switch (this) {
      _Wrap(:final seq) => _Wrap(seq.map(f)),
      _ => fromSeq(iterator.map(f).toIVector()),
    };
  }

  @override
  IChain<A> prepended(A elem) => one(elem).concat(this);

  @override
  IChain<A> reverse() {
    IChain<A> loop(_NonEmpty<A> foo, IList<_NonEmpty<A>> bar, IChain<A> baz) {
      var hd = foo;
      var tl = bar;
      var acc = baz;

      while (true) {
        if (hd is _Append<A>) {
          final next = hd.leftNE;
          tl = tl.prepended(hd.rightNE);
          hd = next;
        } else if (hd is _Singleton<A>) {
          final nextAcc = hd.concat(acc);

          if (tl.nonEmpty) {
            hd = tl.head;
            tl = tl.tail;
            acc = nextAcc;
          } else {
            return nextAcc;
          }
        } else if (hd is _Wrap<A>) {
          final nextAcc = _Wrap(hd.seq.reverse()).concat(acc);

          if (tl.nonEmpty) {
            hd = tl.head;
            tl = tl.tail;
            acc = nextAcc;
          } else {
            return nextAcc;
          }
        }
      }
    }

    return switch (this) {
      _Append(:final leftNE, :final rightNE) => loop(leftNE, ilist([rightNE]), empty()),
      _Wrap(:final seq) => _Wrap(seq.reverse()),
      _ => this,
    };
  }

  @override
  RIterator<A> reverseIterator() => switch (this) {
    _Wrap(:final seq) => seq.reverseIterator(),
    _Singleton(:final a) => RIterator.single(a),
    final _Append<A> app => _ChainReverseRIterator(app),
    _ => RIterator.empty(),
  };

  @override
  int get size => length;

  @override
  IChain<A> get tail => uncons().map((a) => a.$2).getOrElse(() => empty());

  @override
  IChain<A> takeWhile(Function1<A, bool> p) {
    var result = empty<A>();

    _foreachUntil((a) {
      final pr = p(a);
      if (pr) result = result.appended(a);
      return !pr;
    });

    return result;
  }

  Option<(A, IChain<A>)> uncons() {
    if (this is _NonEmpty<A>) {
      var c = this as _NonEmpty<A>;
      _NonEmpty<A>? rights;
      (A, IChain<A>)? result;

      while (result == null) {
        if (c is _Singleton<A>) {
          result = (c.a, rights ?? empty<A>());
        } else if (c is _Append<A>) {
          rights = rights == null ? c.rightNE : _Append(c.rightNE, rights);
          c = c.leftNE;
        } else if (c is _Wrap<A>) {
          final tail = from(c.seq.tail);
          final IChain<A> next;

          if (rights == null) {
            next = tail;
          } else {
            next = switch (tail) {
              final _NonEmpty<A> non => _Append(non, rights),
              _ => rights,
            };
          }

          result = (c.seq.head, next);
        }
      }

      return Option(result);
    } else {
      return none();
    }
  }

  @override
  int get hashCode => MurmurHash3.seqHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is IChain) {
      final itA = iterator;
      final itB = other.iterator;

      while (itA.hasNext && itB.hasNext && itA.next() == itB.next()) {}

      return itA.hasNext == itB.hasNext;
    } else {
      return super == other;
    }
  }

  void _foreachUntil(Function1<A, bool> f) {
    if (this is _NonEmpty<A>) {
      _NonEmpty<A>? c = this as _NonEmpty<A>;

      IList<_NonEmpty<A>> rights = nil();

      while (c != null) {
        if (c is _Singleton<A>) {
          final a = c.a;

          if (f(a)) return;

          if (rights.isEmpty) {
            c = null;
          } else {
            c = rights.head;
            rights = rights.tail;
          }
        } else if (c is _Append<A>) {
          rights = rights.prepended(c.rightNE);
          c = c.leftNE;
        } else if (c is _Wrap<A>) {
          final iterator = c.seq.iterator;

          while (iterator.hasNext) {
            if (f(iterator.next())) return;
          }

          if (rights.isEmpty) {
            c = null;
          } else {
            c = rights.head;
            rights = rights.tail;
          }
        }
      }
    }
  }
}

final class _Empty<A> extends IChain<A> {
  const _Empty() : super._();
}

sealed class _NonEmpty<A> extends IChain<A> {
  const _NonEmpty._() : super._();
}

final class _Singleton<A> extends _NonEmpty<A> {
  final A a;

  const _Singleton(this.a) : super._();
}

final class _Append<A> extends _NonEmpty<A> {
  final _NonEmpty<A> leftNE;
  final _NonEmpty<A> rightNE;

  const _Append(this.leftNE, this.rightNE) : super._();
}

// length >= 2
final class _Wrap<A> extends _NonEmpty<A> {
  final RSeq<A> seq;

  const _Wrap(this.seq) : super._();
}

final class _ChainRIterator<A> extends RIterator<A> {
  final _NonEmpty<A> self;

  _NonEmpty<A>? c;
  IList<_NonEmpty<A>> rights = nil();
  RIterator<A>? currentIterator;

  _ChainRIterator(this.self) : c = self;

  @override
  bool get hasNext => c != null || (currentIterator?.hasNext ?? false);

  @override
  A next() {
    while (true) {
      if (currentIterator != null && (currentIterator?.hasNext ?? false)) {
        return currentIterator!.next();
      } else {
        currentIterator = null;

        if (c is _Singleton<A>) {
          final a = (c! as _Singleton<A>).a;

          if (rights.isEmpty) {
            c = null;
          } else {
            final head = rights.head;
            rights = rights.tail;
            c = head;
          }

          return a;
        } else if (c is _Append<A>) {
          final app = c! as _Append<A>;
          c = app.leftNE;
          rights = rights.prepended(app.rightNE);
        } else if (c is _Wrap<A>) {
          final wrap = c! as _Wrap<A>;
          if (rights.isEmpty) {
            c = null;
          } else {
            final head = rights.head;
            rights = rights.tail;
            c = head;
          }

          currentIterator = wrap.seq.iterator;
          return currentIterator!.next();
        } else {
          noSuchElement();
        }
      }
    }
  }
}

final class _ChainReverseRIterator<A> extends RIterator<A> {
  final _NonEmpty<A> self;

  _NonEmpty<A>? c;
  IList<_NonEmpty<A>> lefts = nil();
  RIterator<A>? currentIterator;

  _ChainReverseRIterator(this.self) : c = self;

  @override
  bool get hasNext => c != null || (currentIterator?.hasNext ?? false);

  @override
  A next() {
    while (true) {
      if (currentIterator != null && (currentIterator?.hasNext ?? false)) {
        return currentIterator!.next();
      } else {
        currentIterator = null;

        if (c is _Singleton<A>) {
          if (lefts.isEmpty) {
            c = null;
          } else {
            final head = lefts.head;
            lefts = lefts.tail;
            c = head;
          }

          return (c! as _Singleton<A>).a;
        } else if (c is _Append<A>) {
          final app = c! as _Append<A>;
          c = app.leftNE;
          lefts = lefts.prepended(app.leftNE);
        } else if (c is _Wrap<A>) {
          final wrap = c! as _Wrap<A>;
          if (lefts.isEmpty) {
            c = null;
          } else {
            final head = lefts.head;
            lefts = lefts.tail;
            c = head;
          }

          currentIterator = wrap.seq.reverseIterator();
          return currentIterator!.next();
        } else {
          noSuchElement();
        }
      }
    }
  }
}
