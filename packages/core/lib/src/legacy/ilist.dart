import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Use of this is not recommended due to poor performance. It's only reason for
/// still existing is for anyone curious how you could implement a purely
/// functional immutable list.

IList<A> ilist<A>(List<A> as) => IList.of(as);
IList<A> nil<A>() => IList.empty();

@immutable
abstract class IList<A> implements Monad<A>, Foldable<A> {
  const IList();

  static IList<A> empty<A>() => Nil<A>();

  static IList<A> fill<A>(int n, A elem) => IList.tabulate(n, (_) => elem);

  static IList<A> of<A>(Iterable<A> as) =>
      as.fold<IList<A>>(nil(), (IList<A> acc, A elem) => acc.append(elem));

  static IList<A> pure<A>(A a) => Cons(a, nil());

  static IList<A> tabulate<A>(int n, Function1<int, A> f) {
    IList<A> go(int x) => x < n ? Cons(f(x), go(x + 1)) : nil();
    return go(0);
  }

  static IList<A> unfold<A, S>(S init, Function1<S, Option<(A, S)>> f) =>
      f(init).fold(() => nil<A>(), (a) => unfold<A, S>(a.$2, f).prepend(a.$1));

  B uncons<B>(Function2<Option<A>, IList<A>, B> f);

  A operator [](int ix) => uncons<A>((h, t) => ix == 0
      ? h.getOrElse(() => throw RangeError('No such element.'))
      : t[ix - 1]);

  @override
  IList<B> ap<B>(IList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  IList<A> append(A elem) => uncons(
      (h, t) => h.fold(() => Cons(elem, this), (h) => Cons(h, t.append(elem))));

  IList<A> concat(IList<A> elems) =>
      uncons((h, t) => h.fold(() => elems, (h) => Cons(h, t.concat(elems))));

  bool contains(A elem) => find((a) => a == elem).isDefined;

  IList<A> distinct() {
    IList<A> go(IList<A> l, IList<A> acc) => l.uncons((h, t) => h.fold(
        () => acc, (h) => acc.contains(h) ? go(t, acc) : go(t, acc.append(h))));

    return go(this, nil());
  }

  IList<A> drop(int n) =>
      uncons((h, t) => h.fold(() => this, (h) => n > 0 ? t.drop(n - 1) : this));

  IList<A> dropRight(int n) => take(size - n);

  IList<A> dropWhile(Function1<A, bool> p) =>
      uncons((h, t) => h.fold(() => this, (h) => p(h) ? t.dropWhile(p) : this));

  IList<A> filter(Function1<A, bool> p) => uncons((h, t) =>
      h.fold(() => this, (h) => p(h) ? Cons(h, t.filter(p)) : t.filter(p)));

  IList<A> filterNot(Function1<A, bool> predicate) =>
      filter((a) => !predicate(a));

  Option<A> find(Function1<A, bool> p) =>
      uncons((h, t) => h.fold(() => none(), (h) => p(h) ? h.some : t.find(p)));

  Option<A> findLast(Function1<A, bool> p) => reverse().find(p);

  @override
  IList<B> flatMap<B>(covariant Function1<A, IList<B>> f) => uncons(
      (h, t) => h.fold(() => nil<B>(), (h) => f(h).concat(t.flatMap(f))));

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) =>
      uncons((h, t) => h.fold(() => init, (h) => op(t.foldLeft(init, op), h)));

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      reverse().foldLeft(init, (elem, acc) => op(acc, elem));

  Option<A> get headOption => uncons((h, _) => h);

  IList<A> init() => size <= 1
      ? nil()
      : uncons((h, t) =>
          h.fold(() => this, (h) => Cons(h, t.size <= 1 ? nil() : t.init())));

  IList<A> insertAt(int ix, A elem) => (0 <= ix && ix <= size)
      ? splitAt(ix).call((a, b) => a.append(elem).concat(b))
      : this;

  bool get isEmpty => uncons((h, t) => h.isEmpty);

  bool get isNotEmpty => nonEmpty;

  Option<A> get lastOption =>
      uncons((h, t) => h.flatMap((h) => t.size == 0 ? Some(h) : t.lastOption));

  int get length => size;

  Option<A> lift(int ix) =>
      uncons((h, t) => h.flatMap((h) => ix == 0 ? Some(h) : t.lift(ix - 1)));

  @override
  IList<B> map<B>(Function1<A, B> f) =>
      uncons((h, t) => h.fold(() => nil<B>(), (h) => Cons(f(h), t.map(f))));

  String mkString({String? start, required String sep, String? end}) {
    String go(IList<A> l, String acc) => l.uncons((h, t) =>
        h.fold(() => acc, (h) => go(t, '${acc.isEmpty ? '' : '$acc$sep'}$h')));

    return '${start ?? ''}${go(this, '')}${end ?? ''}';
  }

  bool get nonEmpty => !isEmpty;

  IList<A> padTo(int len, A elem) =>
      size >= len ? this : concat(IList.fill(len - size, elem));

  (IList<A>, IList<A>) partition(Function1<A, bool> p) => foldLeft(
        (nil<A>(), nil<A>()),
        (acc, elem) => p(elem)
            ? (acc.$1.prepend(elem), acc.$2)
            : (acc.$1, acc.$2.prepend(elem)),
      );

  IList<A> prepend(A elem) => Cons(elem, this);

  IList<A> removeAt(int ix) {
    IList<A> go(IList<A> as, int ix) => ix == 0
        ? as.tail()
        : as.uncons(
            (h, t) => h.fold(() => as, (h) => go(t, ix - 1).prepend(h)));

    return go(this, ix);
  }

  IList<A> removeFirst(Function1<A, bool> p) => uncons((h, t) =>
      h.fold(() => this, (h) => p(h) ? t : t.removeFirst(p).prepend(h)));

  IList<A> replace(int index, A elem) => updated(index, (_) => elem);

  IList<A> reverse() => foldLeft(nil(), (acc, h) => acc.append(h));

  IList<A> slice(int from, int until) => uncons(
      (h, t) => h.fold(() => this, (h) => drop(from).take(until - from)));

  IList<IList<A>> sliding(int n, int step) => uncons((h, t) => h.fold(
          () => nil<IList<A>>(),
          (h) => t.drop(step - 1).sliding(n, step).prepend(take(n))))
      // Ugly but works
      .filter((a) => a.size == n);

  IList<A> sortWith(Function2<A, A, bool> lt) => uncons((h, t) => h.fold(
      () => nil<A>(),
      (pivot) => t.partition((a) => lt(a, pivot))((less, greater) =>
          less.sortWith(lt).append(pivot).concat(greater.sortWith(lt)))));

  (IList<A>, IList<A>) splitAt(int ix) => (take(ix), drop(ix));

  bool startsWith(IList<A> that) => uncons((h, t) => h.fold(
      () => that.isEmpty,
      (h) =>
          that.headOption.fold(() => true, (th) => h == th) &&
          t.startsWith(that.tail())));

  IList<A> tail() => uncons((_, t) => t);

  IList<A> take(int n) => uncons((h, t) =>
      h.fold(() => this, (h) => n > 0 ? Cons(h, t.take(n - 1)) : nil()));

  IList<A> takeRight(int n) => drop(size - n);

  IList<A> takeWhile(Function1<A, bool> p) => uncons((h, t) =>
      h.fold(() => this, (h) => p(h) ? Cons(h, tail().takeWhile(p)) : nil()));

  List<A> toList() => foldRight(<A>[], (elem, acc) => acc..add(elem));

  Either<B, IList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) =>
      uncons((h, t) => h.fold(
          () => Either.right<B, IList<C>>(nil()),
          (h) => f(h).flatMap(
              (c) => tail().traverseEither(f).map((cs) => cs.prepend(c)))));

  IO<IList<B>> traverseIO<B>(Function1<A, IO<B>> f) => uncons((h, t) => h.fold(
      () => IO.pure(nil<B>()),
      (h) => f(h).flatMap((b) => t.traverseIO(f).map((bs) => bs.prepend(b)))));

  IO<IList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) =>
      uncons((h, t) => h.fold(
            () => IO.pure(nil<B>()),
            (h) => IO
                .both(f(h), t.parTraverseIO(f))
                .map((t) => t.$2.prepend(t.$1)),
          ));

  Option<IList<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      uncons((h, t) => h.fold(
          () => Option.pure(nil<B>()),
          (h) => f(h)
              .flatMap((b) => t.traverseOption(f).map((bs) => bs.prepend(b)))));

  IList<A> updated(int index, Function1<A, A> f) => uncons((h, t) => h.fold(
      () => nil<A>(),
      (h) => index == 0
          ? Cons(f(h), tail())
          : Cons(h, tail().updated(index - 1, f))));

  IList<(A, B)> zip<B>(IList<B> bs) {
    IList<(A, B)> go(IList<A> as, IList<B> bs) {
      return as.uncons((ha, ta) {
        return ha.fold(() => nil(), (a) {
          return bs.uncons((hb, tb) {
            return hb.fold(() => nil(), (b) {
              return go(ta, tb).prepend((a, b));
            });
          });
        });
      });
    }

    return go(this, bs);
  }

  IList<(A, int)> zipWithIndex() => _zipWithIndexImpl(0);

  IList<(A, int)> _zipWithIndexImpl(int n) => uncons((h, t) => h.fold(
      () => nil<(A, int)>(),
      (h) => t._zipWithIndexImpl(n + 1).prepend((h, n))));

  @override
  String toString() => mkString(start: 'IList(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) => uncons((h, t) => h.fold(() => other is Nil,
      (h) => other is Cons<A> && h == other.head && t == other.tail()));

  @override
  int get hashCode =>
      uncons((h, t) => h.fold(() => 0, (h) => h.hashCode ^ t.hashCode));
}

class Cons<A> extends IList<A> {
  final A head;
  final IList<A> _tail;

  @override
  IList<A> tail() => _tail;

  const Cons(this.head, this._tail);

  @override
  B uncons<B>(Function2<Option<A>, IList<A>, B> f) => f(Some(head), tail());
}

class Nil<A> extends IList<A> {
  const Nil();

  @override
  B uncons<B>(Function2<Option<A>, IList<A>, B> f) => f(const None(), this);
}

extension IListNestedOps<A> on IList<IList<A>> {
  IList<A> flatten() => foldLeft(nil<A>(), (z, a) => z.concat(a));
}

extension IListEitherOps<A, B> on IList<Either<A, B>> {
  Either<A, IList<B>> sequence() => foldLeft(Either.pure(nil<B>()),
      (a, b) => a.flatMap((a) => b.map((b) => a.prepend(b))));
}

extension IListIOOps<A> on IList<IO<A>> {
  IO<IList<A>> sequence() => foldLeft(IO.pure(nil<A>()),
      (acc, elem) => acc.flatMap((acc) => elem.map(acc.prepend)));

  IO<IList<A>> parSequence() => foldLeft(IO.pure(nil<A>()),
      (acc, elem) => IO.both(acc, elem).map((a) => a.$1.prepend(a.$2)));
}

extension IListOptionOps<A> on IList<Option<A>> {
  Option<IList<A>> sequence() => foldLeft(Option.pure(nil<A>()),
      (acc, elem) => acc.flatMap((acc) => elem.map(acc.prepend)));
}
