import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_core/ribs_core.dart';

IList<A> ilist<A>(Iterable<A> as) => IList.of(as);
IList<A> nil<A>() => IList.empty();

// You may ask why does this exist. Seems like it's just a wrapper around a FIC
// IList. The original IList implementation, while pure, had terrible
// performance so was replaced with this version. To ease the migration and keep
// the API the same, this is what was created. Much credit to the FIC folks for
// building a useful and performant IList.

class IList<A> implements Monad<A>, Foldable<A> {
  final fic.IList<A> _underlying;

  const IList._(this._underlying);

  const IList.nil() : _underlying = const fic.IListConst([]);

  static IList<A> empty<A>() => IList.of([]);

  static IList<A> fill<A>(int n, A elem) => IList.tabulate(n, (_) => elem);

  static IList<A> of<A>(Iterable<A> it) => IList._(fic.IList(it));

  static IList<A> pure<A>(A a) => IList.of([a]);

  static IList<A> tabulate<A>(int n, Function1<int, A> f) =>
      IList.of(List.generate(n, f));

  A operator [](int ix) => _underlying[ix];

  @override
  IList<B> ap<B>(covariant IList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  IList<A> append(A elem) => IList.of(_underlying.add(elem));

  IList<A> concat(IList<A> elems) =>
      IList._(_underlying.addAll(elems._underlying));

  bool contains(A elem) => _underlying.contains(elem);

  IList<A> distinct() => IList.of(foldLeft<List<A>>(
        List<A>.empty(growable: true),
        (acc, elem) => acc.contains(elem) ? acc : (acc..add(elem)),
      ));

  IList<A> drop(int n) => IList.of(_underlying.skip(n));

  IList<A> dropRight(int n) => take(size - n);

  IList<A> dropWhile(Function1<A, bool> p) =>
      IList.of(_underlying.skipWhile(p));

  IList<A> filter(Function1<A, bool> p) => IList.of(_underlying.where(p));

  Option<A> find(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return Option.when(() => ix >= 0, () => _underlying[ix]);
  }

  IList<A> filterNot(Function1<A, bool> p) => IList.of(_underlying.whereNot(p));

  Option<A> findLast(Function1<A, bool> p) {
    final ix = _underlying.lastIndexWhere(p);
    return Option.when(() => ix >= 0, () => _underlying[ix]);
  }

  @override
  IList<B> flatMap<B>(covariant Function1<A, IList<B>> f) =>
      of(_underlying.expand((a) => f(a)._underlying));

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) => _underlying.fold(init, op);

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      reverse().foldLeft(init, (elem, acc) => op(acc, elem));

  Option<A> get headOption =>
      Option.when(() => isNotEmpty, () => _underlying.first);

  IList<A> init() => take(size - 1);

  IList<A> insertAt(int ix, A elem) =>
      (0 <= ix && ix <= size) ? IList.of(_underlying.insert(ix, elem)) : this;

  bool get isEmpty => _underlying.isEmpty;

  bool get isNotEmpty => _underlying.isNotEmpty;

  Option<A> get lastOption =>
      Option.unless(() => isEmpty, () => _underlying[size - 1]);

  Option<A> lift(int ix) =>
      Option.when(() => 0 <= ix && ix < size, () => _underlying[ix]);

  int get length => _underlying.length;

  @override
  IList<B> map<B>(covariant Function1<A, B> f) => IList.of(_underlying.map(f));

  String mkString({String? start, required String sep, String? end}) {
    final buf = StringBuffer(start ?? '');

    for (int i = 0; i < size; i++) {
      buf.write(_underlying[i]);
      if (i < size - 1) buf.write(sep);
    }

    buf.write(end ?? '');

    return buf.toString();
  }

  int get size => _underlying.length;

  IList<A> padTo(int len, A elem) =>
      size >= len ? this : concat(IList.fill(len - size, elem));

  Tuple2<IList<A>, IList<A>> partition(Function1<A, bool> p) =>
      Tuple2(IList.of(_underlying.where(p)), IList.of(_underlying.whereNot(p)));

  IList<A> prepend(A elem) => IList.of(_underlying.insert(0, elem));

  IList<A> removeAt(int ix) =>
      isEmpty ? this : IList.of(_underlying.removeAt(ix.clamp(0, size - 1)));

  IList<A> removeFirst(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return ix < 0 ? this : IList.of(_underlying.removeAt(ix));
  }

  IList<A> replace(int index, A elem) => updated(index, (_) => elem);

  IList<A> reverse() => IList.of(_underlying.reversed);

  IList<A> slice(int from, int until) =>
      IList.of(_underlying.getRange(max(0, from), min(until, size)));

  IList<IList<A>> sliding(int n, int step) {
    final buf = List<IList<A>>.empty(growable: true);

    int ix = 0;

    while (ix + n <= size) {
      final window = _underlying.getRange(ix, ix + n);
      buf.add(IList.of(window));
      ix += step;
    }

    return IList.of(buf);
  }

  IList<A> sortWith(Function2<A, A, bool> lt) =>
      IList.of(_underlying.sort((a, b) => lt(a, b) ? -1 : 1));

  Tuple2<IList<A>, IList<A>> splitAt(int ix) {
    final split = _underlying.splitAt(ix);
    return Tuple2(IList.of(split.first), IList.of(split.second));
  }

  bool startsWith(IList<A> that) =>
      (isEmpty && that.isEmpty) ||
      fic.IList(_underlying.take(that.size))
          .corresponds(that._underlying, (a, b) => a == b);

  IList<A> tail() => IList.of(_underlying.tail);

  IList<A> take(int n) => n < 0
      ? nil()
      : (n < size)
          ? IList.of(_underlying.take(n))
          : this;

  IList<A> takeRight(int n) => IList.of(_underlying.skip(max(0, size - n)));

  IList<A> takeWhile(Function1<A, bool> p) =>
      IList.of(_underlying.takeWhile(p));

  List<A> toList() => _underlying.toList();

  Either<B, IList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) {
    Either<B, IList<C>> result = Either.pure(nil());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  IO<IList<B>> traverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) {
    var result = IO.pure(Unit());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => Unit()));
    }

    return result;
  }

  IO<IList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    for (final elem in _underlying) {
      result =
          IO.both(result, f(elem)).map((t) => t((acc, b) => acc.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) {
    IO<Unit> result = IO.pure(Unit());

    for (final elem in _underlying) {
      result = IO.both(result, f(elem)).map((t) => t((acc, b) => Unit()));
    }

    return result;
  }

  Option<IList<B>> traverseOption<B>(Function1<A, Option<B>> f) {
    Option<IList<B>> result = Option.pure(nil());

    for (final elem in _underlying) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  B uncons<B>(Function2<Option<A>, IList<A>, B> f) {
    if (_underlying.isEmpty) {
      return f(none(), nil());
    } else {
      return f(_underlying[0].some, IList.of(_underlying.tail));
    }
  }

  IList<A> updated(int index, Function1<A, A> f) {
    if (0 <= index && index < size) {
      return IList.of(_underlying.setAll(index, [f(_underlying[index])]));
    } else {
      return this;
    }
  }

  IList<Tuple2<A, B>> zip<B>(IList<B> bs) => IList.of(
        Iterable.generate(
          min(size, bs.size),
          (index) => Tuple2(_underlying[index], bs._underlying[index]),
        ),
      );

  IList<Tuple2<A, int>> zipWithIndex() =>
      ilist(_underlying.zipWithIndex().map((e) => Tuple2(e.second, e.first)));

  @override
  String toString() =>
      isEmpty ? 'Nil' : mkString(start: 'IList(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IList<A> && _underlying == other._underlying);

  @override
  int get hashCode => _underlying.hashCode;
}

extension IListNestedOps<A> on IList<IList<A>> {
  IList<A> flatten() => foldLeft(nil<A>(), (z, a) => z.concat(a));
}

extension IListEitherOps<A, B> on IList<Either<A, B>> {
  Either<A, IList<B>> sequence() => traverseEither(id);
}

extension IListIOOps<A> on IList<IO<A>> {
  IO<IList<A>> sequence() => traverseIO(id);
  IO<Unit> sequence_() => traverseIO_(id);

  IO<IList<A>> parSequence() => parTraverseIO(id);
  IO<Unit> parSequence_() => parTraverseIO_(id);
}

extension IListOptionOps<A> on IList<Option<A>> {
  Option<IList<A>> sequence() => traverseOption(id);
}
