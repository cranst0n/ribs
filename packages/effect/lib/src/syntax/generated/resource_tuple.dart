part of '../resource.dart';

/// Provides additional functions on a Resource of a 2 element tuple.
extension ResourceTuple2Ops<T1, T2> on Resource<(T1, T2)> {
  Resource<T3> evalMapN<T3>(Function2<T1, T2, IO<T3>> f) => evalMap(f.tupled);

  Resource<(T1, T2)> evalTapN<T3>(Function2<T1, T2, IO<T3>> f) => evalTap(f.tupled);

  Resource<T3> flatMapN<T3>(Function2<T1, T2, Resource<T3>> f) => flatMap(f.tupled);

  Resource<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);

  IO<T3> useN<T3>(Function2<T1, T2, IO<T3>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 3 element tuple.
extension ResourceTuple3Ops<T1, T2, T3> on Resource<(T1, T2, T3)> {
  Resource<T4> evalMapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3)> evalTapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalTap(f.tupled);

  Resource<T4> flatMapN<T4>(Function3<T1, T2, T3, Resource<T4>> f) => flatMap(f.tupled);

  Resource<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);

  IO<T4> useN<T4>(Function3<T1, T2, T3, IO<T4>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 4 element tuple.
extension ResourceTuple4Ops<T1, T2, T3, T4> on Resource<(T1, T2, T3, T4)> {
  Resource<T5> evalMapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4)> evalTapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalTap(f.tupled);

  Resource<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, Resource<T5>> f) => flatMap(f.tupled);

  Resource<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);

  IO<T5> useN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 5 element tuple.
extension ResourceTuple5Ops<T1, T2, T3, T4, T5> on Resource<(T1, T2, T3, T4, T5)> {
  Resource<T6> evalMapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5)> evalTapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      evalTap(f.tupled);

  Resource<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, Resource<T6>> f) => flatMap(f.tupled);

  Resource<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);

  IO<T6> useN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 6 element tuple.
extension ResourceTuple6Ops<T1, T2, T3, T4, T5, T6> on Resource<(T1, T2, T3, T4, T5, T6)> {
  Resource<T7> evalMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6)> evalTapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) =>
      evalTap(f.tupled);

  Resource<T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, Resource<T7>> f) => flatMap(f.tupled);

  Resource<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);

  IO<T7> useN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 7 element tuple.
extension ResourceTuple7Ops<T1, T2, T3, T4, T5, T6, T7> on Resource<(T1, T2, T3, T4, T5, T6, T7)> {
  Resource<T8> evalMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7)> evalTapN<T8>(
    Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f,
  ) => evalTap(f.tupled);

  Resource<T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Resource<T8>> f) =>
      flatMap(f.tupled);

  Resource<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);

  IO<T8> useN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 8 element tuple.
extension ResourceTuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8)> {
  Resource<T9> evalMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) =>
      evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8)> evalTapN<T9>(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f,
  ) => evalTap(f.tupled);

  Resource<T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Resource<T9>> f) =>
      flatMap(f.tupled);

  Resource<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);

  IO<T9> useN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 9 element tuple.
extension ResourceTuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  Resource<T10> evalMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f) =>
      evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> evalTapN<T10>(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f,
  ) => evalTap(f.tupled);

  Resource<T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Resource<T10>> f) =>
      flatMap(f.tupled);

  Resource<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);

  IO<T10> useN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 10 element tuple.
extension ResourceTuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  Resource<T11> evalMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f) =>
      evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> evalTapN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => evalTap(f.tupled);

  Resource<T11> flatMapN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Resource<T11>> f,
  ) => flatMap(f.tupled);

  Resource<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) =>
      map(f.tupled);

  IO<T11> useN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f) =>
      use(f.tupled);
}

/// Provides additional functions on a Resource of a 11 element tuple.
extension ResourceTuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  Resource<T12> evalMapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> evalTapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => evalTap(f.tupled);

  Resource<T12> flatMapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Resource<T12>> f,
  ) => flatMap(f.tupled);

  Resource<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);

  IO<T12> useN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f) =>
      use(f.tupled);
}

/// Provides additional functions on a Resource of a 12 element tuple.
extension ResourceTuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  Resource<T13> evalMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> evalTapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => evalTap(f.tupled);

  Resource<T13> flatMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Resource<T13>> f,
  ) => flatMap(f.tupled);

  Resource<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);

  IO<T13> useN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f) =>
      use(f.tupled);
}

/// Provides additional functions on a Resource of a 13 element tuple.
extension ResourceTuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  Resource<T14> evalMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> evalTapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => evalTap(f.tupled);

  Resource<T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Resource<T14>> f,
  ) => flatMap(f.tupled);

  Resource<T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f,
  ) => map(f.tupled);

  IO<T14> useN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 14 element tuple.
extension ResourceTuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  Resource<T15> evalMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> evalTapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => evalTap(f.tupled);

  Resource<T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Resource<T15>> f,
  ) => flatMap(f.tupled);

  Resource<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);

  IO<T15> useN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 15 element tuple.
extension ResourceTuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  Resource<T16> evalMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> evalTapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => evalTap(f.tupled);

  Resource<T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Resource<T16>> f,
  ) => flatMap(f.tupled);

  Resource<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);

  IO<T16> useN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 16 element tuple.
extension ResourceTuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  Resource<T17> evalMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> evalTapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => evalTap(f.tupled);

  Resource<T17> flatMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, Resource<T17>>
    f,
  ) => flatMap(f.tupled);

  Resource<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);

  IO<T17> useN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 17 element tuple.
extension ResourceTuple17Ops<
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
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  Resource<T18> evalMapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  evalTapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => evalTap(f.tupled);

  Resource<T18> flatMapN<T18>(
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
      Resource<T18>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);

  IO<T18> useN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 18 element tuple.
extension ResourceTuple18Ops<
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
    on Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> {
  Resource<T19> evalMapN<T19>(
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
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  evalTapN<T19>(
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
  ) => evalTap(f.tupled);

  Resource<T19> flatMapN<T19>(
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
      Resource<T19>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);

  IO<T19> useN<T19>(
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
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 19 element tuple.
extension ResourceTuple19Ops<
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
        Resource<
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
        > {
  Resource<T20> evalMapN<T20>(
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
  ) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  evalTapN<T20>(
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
  ) => evalTap(f.tupled);

  Resource<T20> flatMapN<T20>(
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
      Resource<T20>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T20> mapN<T20>(
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

  IO<T20> useN<T20>(
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
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 20 element tuple.
extension ResourceTuple20Ops<
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
        Resource<
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
  Resource<T21> evalMapN<T21>(
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
  ) => evalMap(f.tupled);

  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  evalTapN<T21>(
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
  ) => evalTap(f.tupled);

  Resource<T21> flatMapN<T21>(
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
      Resource<T21>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T21> mapN<T21>(
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

  IO<T21> useN<T21>(
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
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 21 element tuple.
extension ResourceTuple21Ops<
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
        Resource<
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
  Resource<T22> evalMapN<T22>(
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
  ) => evalMap(f.tupled);

  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  evalTapN<T22>(
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
  ) => evalTap(f.tupled);

  Resource<T22> flatMapN<T22>(
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
      Resource<T22>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T22> mapN<T22>(
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

  IO<T22> useN<T22>(
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
  ) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 22 element tuple.
extension ResourceTuple22Ops<
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
        Resource<
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
  Resource<T23> evalMapN<T23>(
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
  ) => evalMap(f.tupled);

  Resource<
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
  evalTapN<T23>(
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
  ) => evalTap(f.tupled);

  Resource<T23> flatMapN<T23>(
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
      Resource<T23>
    >
    f,
  ) => flatMap(f.tupled);

  Resource<T23> mapN<T23>(
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

  IO<T23> useN<T23>(
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
  ) => use(f.tupled);
}
