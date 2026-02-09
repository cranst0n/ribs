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

/// Provides additional functions on an Either where the right value is a 6 element tuple.
extension EitherTuple6Ops<E, T1, T2, T3, T4, T5, T6> on Either<E, (T1, T2, T3, T4, T5, T6)> {
  Either<E, (T1, T2, T3, T4, T5, T6)> ensureN(
    Function6<T1, T2, T3, T4, T5, T6, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6)> filterOrElseN(
    Function6<T1, T2, T3, T4, T5, T6, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, Either<E, T7>> f) =>
      flatMap(f.tupled);

  T7 foldN<T7>(
    Function1<E, T7> f,
    Function6<T1, T2, T3, T4, T5, T6, T7> g,
  ) => fold(f, g.tupled);

  void foreachN(Function6<T1, T2, T3, T4, T5, T6, void> f) => foreach(f.tupled);

  Either<E, T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 7 element tuple.
extension EitherTuple7Ops<E, T1, T2, T3, T4, T5, T6, T7>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7)> ensureN(
    Function7<T1, T2, T3, T4, T5, T6, T7, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7)> filterOrElseN(
    Function7<T1, T2, T3, T4, T5, T6, T7, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Either<E, T8>> f) =>
      flatMap(f.tupled);

  T8 foldN<T8>(
    Function1<E, T8> f,
    Function7<T1, T2, T3, T4, T5, T6, T7, T8> g,
  ) => fold(f, g.tupled);

  void foreachN(Function7<T1, T2, T3, T4, T5, T6, T7, void> f) => foreach(f.tupled);

  Either<E, T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 8 element tuple.
extension EitherTuple8Ops<E, T1, T2, T3, T4, T5, T6, T7, T8>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8)> ensureN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8)> filterOrElseN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Either<E, T9>> f) =>
      flatMap(f.tupled);

  T9 foldN<T9>(
    Function1<E, T9> f,
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> g,
  ) => fold(f, g.tupled);

  void foreachN(Function8<T1, T2, T3, T4, T5, T6, T7, T8, void> f) => foreach(f.tupled);

  Either<E, T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 9 element tuple.
extension EitherTuple9Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9)> ensureN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterOrElseN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Either<E, T10>> f) =>
      flatMap(f.tupled);

  T10 foldN<T10>(
    Function1<E, T10> f,
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> g,
  ) => fold(f, g.tupled);

  void foreachN(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, void> f) => foreach(f.tupled);

  Either<E, T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 10 element tuple.
extension EitherTuple10Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> ensureN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterOrElseN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T11> flatMapN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Either<E, T11>> f,
  ) => flatMap(f.tupled);

  T11 foldN<T11>(
    Function1<E, T11> f,
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> g,
  ) => fold(f, g.tupled);

  void foreachN(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, void> f) => foreach(f.tupled);

  Either<E, T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 11 element tuple.
extension EitherTuple11Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> ensureN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterOrElseN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T12> flatMapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Either<E, T12>> f,
  ) => flatMap(f.tupled);

  T12 foldN<T12>(
    Function1<E, T12> f,
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> g,
  ) => fold(f, g.tupled);

  void foreachN(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, void> f) =>
      foreach(f.tupled);

  Either<E, T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 12 element tuple.
extension EitherTuple12Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> ensureN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterOrElseN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T13> flatMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Either<E, T13>> f,
  ) => flatMap(f.tupled);

  T13 foldN<T13>(
    Function1<E, T13> f,
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> g,
  ) => fold(f, g.tupled);

  void foreachN(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, void> f) =>
      foreach(f.tupled);

  Either<E, T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 13 element tuple.
extension EitherTuple13Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> ensureN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterOrElseN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Either<E, T14>> f,
  ) => flatMap(f.tupled);

  T14 foldN<T14>(
    Function1<E, T14> f,
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> g,
  ) => fold(f, g.tupled);

  void foreachN(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, void> f) =>
      foreach(f.tupled);

  Either<E, T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 14 element tuple.
extension EitherTuple14Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> ensureN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterOrElseN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Either<E, T15>> f,
  ) => flatMap(f.tupled);

  T15 foldN<T15>(
    Function1<E, T15> f,
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> g,
  ) => fold(f, g.tupled);

  void foreachN(Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, void> f) =>
      foreach(f.tupled);

  Either<E, T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 15 element tuple.
extension EitherTuple15Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> ensureN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterOrElseN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Either<E, T16>> f,
  ) => flatMap(f.tupled);

  T16 foldN<T16>(
    Function1<E, T16> f,
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, void> f,
  ) => foreach(f.tupled);

  Either<E, T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 16 element tuple.
extension EitherTuple16Ops<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> ensureN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterOrElseN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T17> flatMapN<T17>(
    Function16<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      Either<E, T17>
    >
    f,
  ) => flatMap(f.tupled);

  T17 foldN<T17>(
    Function1<E, T17> f,
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, void> f,
  ) => foreach(f.tupled);

  Either<E, T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 17 element tuple.
extension EitherTuple17Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17
>
    on Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> ensureN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  filterOrElseN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T18> flatMapN<T18>(
    Function17<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      Either<E, T18>
    >
    f,
  ) => flatMap(f.tupled);

  T18 foldN<T18>(
    Function1<E, T18> f,
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, void> f,
  ) => foreach(f.tupled);

  Either<E, T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 18 element tuple.
extension EitherTuple18Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18
>
    on
        Either<
          E,
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
        > {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  ensureN(
    Function18<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      bool
    >
    p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  filterOrElseN(
    Function18<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      bool
    >
    p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T19> flatMapN<T19>(
    Function18<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      Either<E, T19>
    >
    f,
  ) => flatMap(f.tupled);

  T19 foldN<T19>(
    Function1<E, T19> f,
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function18<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      void
    >
    f,
  ) => foreach(f.tupled);

  Either<E, T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 19 element tuple.
extension EitherTuple19Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19
>
    on
        Either<
          E,
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
        > {
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  ensureN(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      bool
    >
    p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  filterOrElseN(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      bool
    >
    p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T20> flatMapN<T20>(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      Either<E, T20>
    >
    f,
  ) => flatMap(f.tupled);

  T20 foldN<T20>(
    Function1<E, T20> f,
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20
    >
    g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      void
    >
    f,
  ) => foreach(f.tupled);

  Either<E, T20> mapN<T20>(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20
    >
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 20 element tuple.
extension EitherTuple20Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20
>
    on
        Either<
          E,
          (
            T1,
            T2,
            T3,
            T4,
            T5,
            T6,
            T7,
            T8,
            T9,
            T10,
            T11,
            T12,
            T13,
            T14,
            T15,
            T16,
            T17,
            T18,
            T19,
            T20,
          )
        > {
  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  ensureN(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      bool
    >
    p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  filterOrElseN(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      bool
    >
    p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T21> flatMapN<T21>(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      Either<E, T21>
    >
    f,
  ) => flatMap(f.tupled);

  T21 foldN<T21>(
    Function1<E, T21> f,
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21
    >
    g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      void
    >
    f,
  ) => foreach(f.tupled);

  Either<E, T21> mapN<T21>(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21
    >
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 21 element tuple.
extension EitherTuple21Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20,
  T21
>
    on
        Either<
          E,
          (
            T1,
            T2,
            T3,
            T4,
            T5,
            T6,
            T7,
            T8,
            T9,
            T10,
            T11,
            T12,
            T13,
            T14,
            T15,
            T16,
            T17,
            T18,
            T19,
            T20,
            T21,
          )
        > {
  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  ensureN(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      bool
    >
    p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  filterOrElseN(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      bool
    >
    p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T22> flatMapN<T22>(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      Either<E, T22>
    >
    f,
  ) => flatMap(f.tupled);

  T22 foldN<T22>(
    Function1<E, T22> f,
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22
    >
    g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      void
    >
    f,
  ) => foreach(f.tupled);

  Either<E, T22> mapN<T22>(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22
    >
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Either where the right value is a 22 element tuple.
extension EitherTuple22Ops<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20,
  T21,
  T22
>
    on
        Either<
          E,
          (
            T1,
            T2,
            T3,
            T4,
            T5,
            T6,
            T7,
            T8,
            T9,
            T10,
            T11,
            T12,
            T13,
            T14,
            T15,
            T16,
            T17,
            T18,
            T19,
            T20,
            T21,
            T22,
          )
        > {
  Either<
    E,
    (
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
    )
  >
  ensureN(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      bool
    >
    p,
    Function0<E> onFailure,
  ) => ensure(p.tupled, onFailure);

  Either<
    E,
    (
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
    )
  >
  filterOrElseN(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      bool
    >
    p,
    Function0<E> zero,
  ) => filterOrElse(p.tupled, zero);

  Either<E, T23> flatMapN<T23>(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      Either<E, T23>
    >
    f,
  ) => flatMap(f.tupled);

  T23 foldN<T23>(
    Function1<E, T23> f,
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      T23
    >
    g,
  ) => fold(f, g.tupled);

  void foreachN(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      void
    >
    f,
  ) => foreach(f.tupled);

  Either<E, T23> mapN<T23>(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      T23
    >
    f,
  ) => map(f.tupled);
}
