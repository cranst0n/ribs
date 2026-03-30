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
