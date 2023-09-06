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

final class IList<A> implements Monad<A>, Foldable<A> {
  final fic.IList<A> _underlying;

  const IList._(this._underlying);

  const IList.nil() : _underlying = const fic.IListConst([]);

  static IList<A> empty<A>() => IList.of([]);

  static IList<A> fill<A>(int n, A elem) => IList.tabulate(n, (_) => elem);

  static IList<A> of<A>(Iterable<A> it) => IList._(fic.IList(it));

  static IList<A> pure<A>(A a) => IList.of([a]);

  static IList<int> range(int start, int end) =>
      tabulate(end - start, (ix) => ix + start);

  static IList<A> tabulate<A>(int n, Function1<int, A> f) =>
      IList.of(List.generate(n, f));

  /// Returns the element at the given index or throws a [RangeError] if the
  /// index is out of the bounds of this list.
  A operator [](int ix) => _underlying[ix];

  IList<A> operator +(A a) => append(a);

  IList<A> operator -(A a) => removeFirst((x) => x == a);

  @override
  IList<B> ap<B>(covariant IList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  IList<A> append(A elem) => IList.of(_underlying.add(elem));

  IList<A> concat(IList<A> elems) =>
      IList._(_underlying.addAll(elems._underlying));

  bool contains(A elem) => _underlying.contains(elem);

  Option<(A, IList<A>)> deleteFirst(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return Option.when(
      () => ix >= 0,
      () => (_underlying[ix], IList.of(_underlying.removeAt(ix))),
    );
  }

  IList<A> distinct() => IList.of(foldLeft<List<A>>(
        List<A>.empty(growable: true),
        (acc, elem) => acc.contains(elem) ? acc : (acc..add(elem)),
      ));

  IList<A> drop(int n) => IList.of(_underlying.skip(n));

  IList<A> dropRight(int n) => take(size - n);

  IList<A> dropWhile(Function1<A, bool> p) =>
      IList.of(_underlying.skipWhile(p));

  IList<A> filter(Function1<A, bool> p) => IList.of(_underlying.where(p));

  IList<A> filterNot(Function1<A, bool> p) => IList.of(_underlying.whereNot(p));

  Option<A> find(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return Option.when(() => ix >= 0, () => _underlying[ix]);
  }

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

  void forEach<B>(Function1<A, B> f) => _underlying.forEach(f);

  IMap<K, IList<A>> groupBy<K>(Function1<A, K> f) => groupMap(f, id);

  IMap<K, IList<V>> groupMap<K, V>(
    Function1<A, K> key,
    Function1<A, V> value,
  ) =>
      foldLeft(
        IMap.empty<K, IList<V>>(),
        (acc, a) => acc.updatedWith(
          key(a),
          (prev) => prev
              .map((l) => l.append(value(a)))
              .orElse(() => ilist([value(a)]).some),
        ),
      );

  Option<A> get headOption =>
      Option.when(() => isNotEmpty, () => _underlying.first);

  Option<int> indexWhere(Function1<A, bool> p) {
    final idx = _underlying.indexWhere(p);
    return Option.unless(() => idx < 0, () => idx);
  }

  IList<A> init() => take(size - 1);

  IList<A> insertAt(int ix, A elem) =>
      (0 <= ix && ix <= size) ? IList.of(_underlying.insert(ix, elem)) : this;

  IList<A> intersperse({A? start, required A sep, A? end}) {
    final buf = List<A>.empty(growable: true);

    if (start != null) {
      buf.add(start);
    }

    for (int i = 0; i < size; i++) {
      buf.add(_underlying[i]);
      if (i < size - 1) buf.add(sep);
    }

    if (end != null) {
      buf.add(end);
    }

    return IList.of(buf);
  }

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

  IList<A> padTo(int len, A elem) =>
      size >= len ? this : concat(IList.fill(len - size, elem));

  (IList<A>, IList<A>) partition(Function1<A, bool> p) =>
      (IList.of(_underlying.where(p)), IList.of(_underlying.whereNot(p)));

  IList<A> prepend(A elem) => IList.of(_underlying.insert(0, elem));

  Option<A> reduceOption(Function2<A, A, A> f) =>
      headOption.map((hd) => tail().foldLeft(hd, f));

  IList<A> removeAt(int ix) =>
      isEmpty ? this : IList.of(_underlying.removeAt(ix.clamp(0, size - 1)));

  IList<A> removeFirst(Function1<A, bool> p) {
    final ix = _underlying.indexWhere(p);
    return ix < 0 ? this : IList.of(_underlying.removeAt(ix));
  }

  IList<A> replace(int index, A elem) => updated(index, (_) => elem);

  IList<A> reverse() => IList.of(_underlying.reversed);

  int get size => _underlying.length;

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

  (IList<A>, IList<A>) splitAt(int ix) {
    final split = _underlying.splitAt(ix);
    return (IList.of(split.first), IList.of(split.second));
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

  ISet<A> toISet() => ISet.fromIList(this);

  List<A> toList() => _underlying.toList();

  Either<B, IList<C>> traverseEither<B, C>(Function1<A, Either<B, C>> f) {
    Either<B, IList<C>> result = Either.pure(nil());

    for (final elem in _underlying) {
      // short circuit
      if (result.isLeft) {
        return result;
      }

      // Workaround for contravariant issues in error case
      result = result.fold(
        (_) => result,
        (acc) => f(elem).fold(
          (err) => err.asLeft(),
          (a) => acc.append(a).asRight(),
        ),
      );
    }

    return result;
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

  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      traverseIO(f).map((a) => a.flatten());

  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      traverseIO(f).map((opts) => opts.foldLeft(IList.empty<B>(),
          (acc, elem) => elem.fold(() => acc, (elem) => acc.append(elem))));

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
      // short circuit
      if (result.isEmpty) {
        return result;
      }

      result = result.flatMap((l) => f(elem).map((b) => l.prepend(b)));
    }

    return result.map((a) => a.reverse());
  }

  B uncons<B>(Function1<Option<(A, IList<A>)>, B> f) {
    if (_underlying.isEmpty) {
      return f(none());
    } else {
      return f(Some((_underlying[0], IList.of(_underlying.tail))));
    }
  }

  IList<A> updated(int index, Function1<A, A> f) {
    if (0 <= index && index < size) {
      return IList.of(_underlying.setAll(index, [f(_underlying[index])]));
    } else {
      return this;
    }
  }

  IList<(A, B)> zip<B>(IList<B> bs) => IList.of(
        Iterable.generate(
          min(size, bs.size),
          (index) => (_underlying[index], bs._underlying[index]),
        ),
      );

  IList<(A, int)> zipWithIndex() =>
      ilist(_underlying.zipWithIndex().map((e) => (e.second, e.first)));

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

// Until lambda destructuring arrives, this will provide a little bit
// of convenience: https://github.com/dart-lang/language/issues/3001
extension IListTuple2Ops<A, B> on IList<(A, B)> {
  Option<((A, B), IList<(A, B)>)> deleteFirstN(Function2<A, B, bool> p) =>
      deleteFirst(p.tupled);

  IList<(A, B)> dropWhileN(Function2<A, B, bool> p) => dropWhile(p.tupled);

  IList<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  IList<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  Option<(A, B)> findN(Function2<A, B, bool> p) => find(p.tupled);

  Option<(A, B)> findLastN(Function2<A, B, bool> p) => findLast(p.tupled);

  IList<C> flatMapN<C>(Function2<A, B, IList<C>> f) => flatMap(f.tupled);

  C foldLeftN<C>(C init, Function3<C, A, B, C> op) =>
      foldLeft(init, (acc, elem) => op(acc, elem.$1, elem.$2));

  C foldRightN<C>(C init, Function3<A, B, C, C> op) =>
      foldRight(init, (elem, acc) => op(elem.$1, elem.$2, acc));

  void forEachN<C>(Function2<A, B, C> f) => forEach(f.tupled);

  IMap<K, IList<(A, B)>> groupByN<K>(Function2<A, B, K> f) =>
      groupMap(f.tupled, id);

  IMap<K, IList<V>> groupMapN<K, V>(
    Function2<A, B, K> key,
    Function2<A, B, V> value,
  ) =>
      groupMap(key.tupled, value.tupled);

  Option<int> indexWhereN(Function2<A, B, bool> p) => indexWhere(p.tupled);

  IList<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  (IList<(A, B)>, IList<(A, B)>) partitionN(Function2<A, B, bool> p) =>
      partition(p.tupled);

  IList<(A, B)> removeFirstN(Function2<A, B, bool> p) => removeFirst(p.tupled);

  IList<(A, B)> takeWhileN(Function2<A, B, bool> p) => takeWhile(p.tupled);

  IMap<A, B> toIMap() => IMap.fromIList(this);

  Map<A, B> toMap() => Map.fromEntries(mapN((k, v) => MapEntry(k, v)).toList());

  Either<C, IList<D>> traverseEitherN<C, D>(Function2<A, B, Either<C, D>> f) =>
      traverseEither(f.tupled);

  IO<IList<C>> traverseION<C>(Function2<A, B, IO<C>> f) => traverseIO(f.tupled);

  IO<Unit> traverseION_<C>(Function2<A, B, IO<C>> f) => traverseIO_(f.tupled);

  IO<IList<C>> traverseFilterION<C>(Function2<A, B, IO<Option<C>>> f) =>
      traverseFilterIO(f.tupled);

  IO<IList<C>> parTraverseION<C>(Function2<A, B, IO<C>> f) =>
      parTraverseIO(f.tupled);

  IO<Unit> parTraverseION_<C>(Function2<A, B, IO<C>> f) =>
      parTraverseIO_(f.tupled);

  Option<IList<C>> traverseOptionN<C>(Function2<A, B, Option<C>> f) =>
      traverseOption(f.tupled);

  IList<(A, B)> updatedN(int index, Function2<A, B, (A, B)> f) =>
      updated(index, f.tupled);

  (IList<A>, IList<B>) unzip() => foldLeft((nil<A>(), nil<B>()),
      (acc, ab) => (acc.$1.append(ab.$1), acc.$2.append(ab.$2)));
}

extension IListTuple3Ops<A, B, C> on IList<(A, B, C)> {
  Option<((A, B, C), IList<(A, B, C)>)> deleteFirstN(
          Function3<A, B, C, bool> p) =>
      deleteFirst(p.tupled);

  IList<(A, B, C)> dropWhileN(Function3<A, B, C, bool> p) =>
      dropWhile(p.tupled);

  IList<(A, B, C)> filterN(Function3<A, B, C, bool> p) => filter(p.tupled);

  IList<(A, B, C)> filterNotN(Function3<A, B, C, bool> p) =>
      filterNot(p.tupled);

  Option<(A, B, C)> findN(Function3<A, B, C, bool> p) => find(p.tupled);

  Option<(A, B, C)> findLastN(Function3<A, B, C, bool> p) => findLast(p.tupled);

  IList<D> flatMapN<D>(Function3<A, B, C, IList<D>> f) => flatMap(f.tupled);

  D foldLeftN<D>(D init, Function4<D, A, B, C, D> op) =>
      foldLeft(init, (acc, elem) => op(acc, elem.$1, elem.$2, elem.$3));

  D foldRightN<D>(D init, Function4<A, B, C, D, D> op) =>
      foldRight(init, (elem, acc) => op(elem.$1, elem.$2, elem.$3, acc));

  void forEachN<D>(Function3<A, B, C, D> f) => forEach(f.tupled);

  IMap<K, IList<(A, B, C)>> groupByN<K>(Function3<A, B, C, K> f) =>
      groupMap(f.tupled, id);

  IMap<K, IList<V>> groupMapN<K, V>(
    Function3<A, B, C, K> key,
    Function3<A, B, C, V> value,
  ) =>
      groupMap(key.tupled, value.tupled);

  Option<int> indexWhereN(Function3<A, B, C, bool> p) => indexWhere(p.tupled);

  IList<D> mapN<D>(Function3<A, B, C, D> f) => map(f.tupled);

  (IList<(A, B, C)>, IList<(A, B, C)>) partitionN(Function3<A, B, C, bool> p) =>
      partition(p.tupled);

  IList<(A, B, C)> removeFirstN(Function3<A, B, C, bool> p) =>
      removeFirst(p.tupled);

  IList<(A, B, C)> takeWhileN(Function3<A, B, C, bool> p) =>
      takeWhile(p.tupled);

  Either<D, IList<E>> traverseEitherN<D, E>(
          Function3<A, B, C, Either<D, E>> f) =>
      traverseEither(f.tupled);

  IO<IList<D>> traverseION<D>(Function3<A, B, C, IO<D>> f) =>
      traverseIO(f.tupled);

  IO<Unit> traverseION_<D>(Function3<A, B, C, IO<D>> f) =>
      traverseIO_(f.tupled);

  IO<IList<D>> traverseFilterION<D>(Function3<A, B, C, IO<Option<D>>> f) =>
      traverseFilterIO(f.tupled);

  IO<IList<D>> parTraverseION<D>(Function3<A, B, C, IO<D>> f) =>
      parTraverseIO(f.tupled);

  IO<Unit> parTraverseION_<D>(Function3<A, B, C, IO<D>> f) =>
      parTraverseIO_(f.tupled);

  Option<IList<D>> traverseOptionN<D>(Function3<A, B, C, Option<D>> f) =>
      traverseOption(f.tupled);

  IList<(A, B, C)> updatedN(int index, Function3<A, B, C, (A, B, C)> f) =>
      updated(index, f.tupled);
}
