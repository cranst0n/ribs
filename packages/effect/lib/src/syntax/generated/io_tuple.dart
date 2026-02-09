part of '../io.dart';

/// Provides additional functions on an IO of a 2 element tuple.
extension IOTuple2Ops<T1, T2> on IO<(T1, T2)> {
  IO<T3> flatMapN<T3>(Function2<T1, T2, IO<T3>> f) => flatMap(f.tupled);

  IO<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 3 element tuple.
extension IOTuple3Ops<T1, T2, T3> on IO<(T1, T2, T3)> {
  IO<T4> flatMapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => flatMap(f.tupled);

  IO<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 4 element tuple.
extension IOTuple4Ops<T1, T2, T3, T4> on IO<(T1, T2, T3, T4)> {
  IO<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => flatMap(f.tupled);

  IO<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 5 element tuple.
extension IOTuple5Ops<T1, T2, T3, T4, T5> on IO<(T1, T2, T3, T4, T5)> {
  IO<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => flatMap(f.tupled);

  IO<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 6 element tuple.
extension IOTuple6Ops<T1, T2, T3, T4, T5, T6> on IO<(T1, T2, T3, T4, T5, T6)> {
  IO<T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) => flatMap(f.tupled);

  IO<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 7 element tuple.
extension IOTuple7Ops<T1, T2, T3, T4, T5, T6, T7> on IO<(T1, T2, T3, T4, T5, T6, T7)> {
  IO<T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) => flatMap(f.tupled);

  IO<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 8 element tuple.
extension IOTuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8> on IO<(T1, T2, T3, T4, T5, T6, T7, T8)> {
  IO<T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) => flatMap(f.tupled);

  IO<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 9 element tuple.
extension IOTuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  IO<T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f) =>
      flatMap(f.tupled);

  IO<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 10 element tuple.
extension IOTuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  IO<T11> flatMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f) =>
      flatMap(f.tupled);

  IO<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 11 element tuple.
extension IOTuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  IO<T12> flatMapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f) =>
      flatMap(f.tupled);

  IO<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IO of a 12 element tuple.
extension IOTuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  IO<T13> flatMapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f) =>
      flatMap(f.tupled);

  IO<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IO of a 13 element tuple.
extension IOTuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  IO<T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => flatMap(f.tupled);

  IO<T14> mapN<T14>(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IO of a 14 element tuple.
extension IOTuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  IO<T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => flatMap(f.tupled);

  IO<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IO of a 15 element tuple.
extension IOTuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  IO<T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => flatMap(f.tupled);

  IO<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IO of a 16 element tuple.
extension IOTuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  IO<T17> flatMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => flatMap(f.tupled);

  IO<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IO of a 17 element tuple.
extension IOTuple17Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  IO<T18> flatMapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => flatMap(f.tupled);

  IO<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IO of a 18 element tuple.
extension IOTuple18Ops<
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
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> {
  IO<T19> flatMapN<T19>(
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
      IO<T19>
    >
    f,
  ) => flatMap(f.tupled);

  IO<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IO of a 19 element tuple.
extension IOTuple19Ops<
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
    on IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)> {
  IO<T20> flatMapN<T20>(
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
      IO<T20>
    >
    f,
  ) => flatMap(f.tupled);

  IO<T20> mapN<T20>(
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

/// Provides additional functions on an IO of a 20 element tuple.
extension IOTuple20Ops<
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
        IO<
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
  IO<T21> flatMapN<T21>(
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
      IO<T21>
    >
    f,
  ) => flatMap(f.tupled);

  IO<T21> mapN<T21>(
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

/// Provides additional functions on an IO of a 21 element tuple.
extension IOTuple21Ops<
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
        IO<
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
  IO<T22> flatMapN<T22>(
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
      IO<T22>
    >
    f,
  ) => flatMap(f.tupled);

  IO<T22> mapN<T22>(
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

/// Provides additional functions on an IO of a 22 element tuple.
extension IOTuple22Ops<
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
        IO<
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
  IO<T23> flatMapN<T23>(
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
      IO<T23>
    >
    f,
  ) => flatMap(f.tupled);

  IO<T23> mapN<T23>(
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
