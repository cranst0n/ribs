part of '../option.dart';

/// Provides additional functions on an Option of a 2 element tuple.
extension OptionTuple2Ops<T1, T2> on Option<(T1, T2)> {
  Option<(T1, T2)> filterN(Function2<T1, T2, bool> p) => filter(p.tupled);

  Option<(T1, T2)> filterNotN(Function2<T1, T2, bool> p) => filterNot(p.tupled);

  Option<T3> flatMapN<T3>(Function2<T1, T2, Option<T3>> f) => flatMap(f.tupled);

  T3 foldN<T3>(
    Function0<T3> ifEmpty,
    Function2<T1, T2, T3> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function2<T1, T2, void> ifSome) => foreach(ifSome.tupled);

  Option<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 3 element tuple.
extension OptionTuple3Ops<T1, T2, T3> on Option<(T1, T2, T3)> {
  Option<(T1, T2, T3)> filterN(Function3<T1, T2, T3, bool> p) => filter(p.tupled);

  Option<(T1, T2, T3)> filterNotN(Function3<T1, T2, T3, bool> p) => filterNot(p.tupled);

  Option<T4> flatMapN<T4>(Function3<T1, T2, T3, Option<T4>> f) => flatMap(f.tupled);

  T4 foldN<T4>(
    Function0<T4> ifEmpty,
    Function3<T1, T2, T3, T4> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function3<T1, T2, T3, void> ifSome) => foreach(ifSome.tupled);

  Option<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 4 element tuple.
extension OptionTuple4Ops<T1, T2, T3, T4> on Option<(T1, T2, T3, T4)> {
  Option<(T1, T2, T3, T4)> filterN(Function4<T1, T2, T3, T4, bool> p) => filter(p.tupled);

  Option<(T1, T2, T3, T4)> filterNotN(Function4<T1, T2, T3, T4, bool> p) => filterNot(p.tupled);

  Option<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, Option<T5>> f) => flatMap(f.tupled);

  T5 foldN<T5>(
    Function0<T5> ifEmpty,
    Function4<T1, T2, T3, T4, T5> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function4<T1, T2, T3, T4, void> ifSome) => foreach(ifSome.tupled);

  Option<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 5 element tuple.
extension OptionTuple5Ops<T1, T2, T3, T4, T5> on Option<(T1, T2, T3, T4, T5)> {
  Option<(T1, T2, T3, T4, T5)> filterN(Function5<T1, T2, T3, T4, T5, bool> p) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5)> filterNotN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      filterNot(p.tupled);

  Option<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, Option<T6>> f) => flatMap(f.tupled);

  T6 foldN<T6>(
    Function0<T6> ifEmpty,
    Function5<T1, T2, T3, T4, T5, T6> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function5<T1, T2, T3, T4, T5, void> ifSome) => foreach(ifSome.tupled);

  Option<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 6 element tuple.
extension OptionTuple6Ops<T1, T2, T3, T4, T5, T6> on Option<(T1, T2, T3, T4, T5, T6)> {
  Option<(T1, T2, T3, T4, T5, T6)> filterN(Function6<T1, T2, T3, T4, T5, T6, bool> p) =>
      filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6)> filterNotN(Function6<T1, T2, T3, T4, T5, T6, bool> p) =>
      filterNot(p.tupled);

  Option<T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, Option<T7>> f) => flatMap(f.tupled);

  T7 foldN<T7>(
    Function0<T7> ifEmpty,
    Function6<T1, T2, T3, T4, T5, T6, T7> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function6<T1, T2, T3, T4, T5, T6, void> ifSome) => foreach(ifSome.tupled);

  Option<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 7 element tuple.
extension OptionTuple7Ops<T1, T2, T3, T4, T5, T6, T7> on Option<(T1, T2, T3, T4, T5, T6, T7)> {
  Option<(T1, T2, T3, T4, T5, T6, T7)> filterN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> p) =>
      filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7)> filterNotN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> p) =>
      filterNot(p.tupled);

  Option<T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Option<T8>> f) => flatMap(f.tupled);

  T8 foldN<T8>(
    Function0<T8> ifEmpty,
    Function7<T1, T2, T3, T4, T5, T6, T7, T8> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function7<T1, T2, T3, T4, T5, T6, T7, void> ifSome) => foreach(ifSome.tupled);

  Option<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 8 element tuple.
extension OptionTuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8)> filterN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8)> filterNotN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
  ) => filterNot(p.tupled);

  Option<T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Option<T9>> f) =>
      flatMap(f.tupled);

  T9 foldN<T9>(
    Function0<T9> ifEmpty,
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function8<T1, T2, T3, T4, T5, T6, T7, T8, void> ifSome) => foreach(ifSome.tupled);

  Option<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 9 element tuple.
extension OptionTuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterNotN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
  ) => filterNot(p.tupled);

  Option<T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Option<T10>> f) =>
      flatMap(f.tupled);

  T10 foldN<T10>(
    Function0<T10> ifEmpty,
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, void> ifSome) =>
      foreach(ifSome.tupled);

  Option<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);
}

/// Provides additional functions on an Option of a 10 element tuple.
extension OptionTuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterNotN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
  ) => filterNot(p.tupled);

  Option<T11> flatMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Option<T11>> f) =>
      flatMap(f.tupled);

  T11 foldN<T11>(
    Function0<T11> ifEmpty,
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, void> ifSome) =>
      foreach(ifSome.tupled);

  Option<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Option of a 11 element tuple.
extension OptionTuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterNotN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
  ) => filterNot(p.tupled);

  Option<T12> flatMapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Option<T12>> f,
  ) => flatMap(f.tupled);

  T12 foldN<T12>(
    Function0<T12> ifEmpty,
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, void> ifSome) =>
      foreach(ifSome.tupled);

  Option<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Option of a 12 element tuple.
extension OptionTuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterNotN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
  ) => filterNot(p.tupled);

  Option<T13> flatMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Option<T13>> f,
  ) => flatMap(f.tupled);

  T13 foldN<T13>(
    Function0<T13> ifEmpty,
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, void> ifSome) =>
      foreach(ifSome.tupled);

  Option<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);
}

/// Provides additional functions on an Option of a 13 element tuple.
extension OptionTuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterNotN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
  ) => filterNot(p.tupled);

  Option<T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Option<T14>> f,
  ) => flatMap(f.tupled);

  T14 foldN<T14>(
    Function0<T14> ifEmpty,
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, void> ifSome) =>
      foreach(ifSome.tupled);

  Option<T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 14 element tuple.
extension OptionTuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterNotN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
  ) => filterNot(p.tupled);

  Option<T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Option<T15>> f,
  ) => flatMap(f.tupled);

  T15 foldN<T15>(
    Function0<T15> ifEmpty,
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, void> ifSome,
  ) => foreach(ifSome.tupled);

  Option<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 15 element tuple.
extension OptionTuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterNotN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
  ) => filterNot(p.tupled);

  Option<T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Option<T16>> f,
  ) => flatMap(f.tupled);

  T16 foldN<T16>(
    Function0<T16> ifEmpty,
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, void> ifSome,
  ) => foreach(ifSome.tupled);

  Option<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 16 element tuple.
extension OptionTuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterNotN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
  ) => filterNot(p.tupled);

  Option<T17> flatMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, Option<T17>>
    f,
  ) => flatMap(f.tupled);

  T17 foldN<T17>(
    Function0<T17> ifEmpty,
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, void> ifSome,
  ) => foreach(ifSome.tupled);

  Option<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 17 element tuple.
extension OptionTuple17Ops<
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
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterNotN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
  ) => filterNot(p.tupled);

  Option<T18> flatMapN<T18>(
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
      Option<T18>
    >
    f,
  ) => flatMap(f.tupled);

  T18 foldN<T18>(
    Function0<T18> ifEmpty,
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

  void foreachN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, void>
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 18 element tuple.
extension OptionTuple18Ops<
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
    on Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> filterN(
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
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  filterNotN(
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
  ) => filterNot(p.tupled);

  Option<T19> flatMapN<T19>(
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
      Option<T19>
    >
    f,
  ) => flatMap(f.tupled);

  T19 foldN<T19>(
    Function0<T19> ifEmpty,
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

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
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an Option of a 19 element tuple.
extension OptionTuple19Ops<
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
        Option<
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
        > {
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  filterN(
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
  ) => filter(p.tupled);

  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  filterNotN(
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
  ) => filterNot(p.tupled);

  Option<T20> flatMapN<T20>(
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
      Option<T20>
    >
    f,
  ) => flatMap(f.tupled);

  T20 foldN<T20>(
    Function0<T20> ifEmpty,
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
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

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
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T20> mapN<T20>(
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

/// Provides additional functions on an Option of a 20 element tuple.
extension OptionTuple20Ops<
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
        Option<
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
  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  filterN(
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
  ) => filter(p.tupled);

  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  filterNotN(
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
  ) => filterNot(p.tupled);

  Option<T21> flatMapN<T21>(
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
      Option<T21>
    >
    f,
  ) => flatMap(f.tupled);

  T21 foldN<T21>(
    Function0<T21> ifEmpty,
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
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

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
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T21> mapN<T21>(
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

/// Provides additional functions on an Option of a 21 element tuple.
extension OptionTuple21Ops<
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
        Option<
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
  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  filterN(
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
  ) => filter(p.tupled);

  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  filterNotN(
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
  ) => filterNot(p.tupled);

  Option<T22> flatMapN<T22>(
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
      Option<T22>
    >
    f,
  ) => flatMap(f.tupled);

  T22 foldN<T22>(
    Function0<T22> ifEmpty,
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
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

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
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T22> mapN<T22>(
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

/// Provides additional functions on an Option of a 22 element tuple.
extension OptionTuple22Ops<
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
        Option<
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
  Option<
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
  filterN(
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
  ) => filter(p.tupled);

  Option<
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
  filterNotN(
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
  ) => filterNot(p.tupled);

  Option<T23> flatMapN<T23>(
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
      Option<T23>
    >
    f,
  ) => flatMap(f.tupled);

  T23 foldN<T23>(
    Function0<T23> ifEmpty,
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
    ifSome,
  ) => fold(ifEmpty, ifSome.tupled);

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
    ifSome,
  ) => foreach(ifSome.tupled);

  Option<T23> mapN<T23>(
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
