part of '../either.dart';

/// Provides additional functions on an Either where the right value is a 2 element tuple.
extension EitherTuple2Ops<E, T1, T2> on Either<E, (T1, T2)> {
  Either<E, (T1, T2)> ensureN(
    Function2<T1, T2, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2)> filterOrElseN(
    Function2<T1, T2, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T3> flatMapN<T3>(Function2<T1, T2, Either<E, T3>> f) => flatMap(f.tupled);

  T3 foldN<T3>(
    Function1<E, T3> f,
    Function2<T1, T2, T3> g,
  ) => fold(f, g.tupled);

  void foreachN(Function2<T1, T2, void> f) => foreach(f.tupled);

  Either<E, T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 3 element tuple.
extension EitherTuple3Ops<E, T1, T2, T3> on Either<E, (T1, T2, T3)> {
  Either<E, (T1, T2, T3)> ensureN(
    Function3<T1, T2, T3, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3)> filterOrElseN(
    Function3<T1, T2, T3, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T4> flatMapN<T4>(Function3<T1, T2, T3, Either<E, T4>> f) => flatMap(f.tupled);

  T4 foldN<T4>(
    Function1<E, T4> f,
    Function3<T1, T2, T3, T4> g,
  ) => fold(f, g.tupled);

  void foreachN(Function3<T1, T2, T3, void> f) => foreach(f.tupled);

  Either<E, T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 4 element tuple.
extension EitherTuple4Ops<E, T1, T2, T3, T4> on Either<E, (T1, T2, T3, T4)> {
  Either<E, (T1, T2, T3, T4)> ensureN(
    Function4<T1, T2, T3, T4, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4)> filterOrElseN(
    Function4<T1, T2, T3, T4, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T5> flatMapN<T5>(Function4<T1, T2, T3, T4, Either<E, T5>> f) => flatMap(f.tupled);

  T5 foldN<T5>(
    Function1<E, T5> f,
    Function4<T1, T2, T3, T4, T5> g,
  ) => fold(f, g.tupled);

  void foreachN(Function4<T1, T2, T3, T4, void> f) => foreach(f.tupled);

  Either<E, T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 5 element tuple.
extension EitherTuple5Ops<E, T1, T2, T3, T4, T5> on Either<E, (T1, T2, T3, T4, T5)> {
  Either<E, (T1, T2, T3, T4, T5)> ensureN(
    Function5<T1, T2, T3, T4, T5, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5)> filterOrElseN(
    Function5<T1, T2, T3, T4, T5, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, Either<E, T6>> f) => flatMap(f.tupled);

  T6 foldN<T6>(
    Function1<E, T6> f,
    Function5<T1, T2, T3, T4, T5, T6> g,
  ) => fold(f, g.tupled);

  void foreachN(Function5<T1, T2, T3, T4, T5, void> f) => foreach(f.tupled);

  Either<E, T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);
}
