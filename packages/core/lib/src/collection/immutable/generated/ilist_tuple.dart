part of '../ilist.dart';

/// Provides additional functions on an IList of a 2 element tuple.
extension IListTuple2Ops<T1, T2> on IList<(T1, T2)> {
  IList<T3> collectN<T3>(Function2<T1, T2, Option<T3>> f) => collect(f.tupled);

  IList<(T1, T2)> distinctByN<T3>(Function2<T1, T2, T3> f) => distinctBy(f.tupled);

  IList<(T1, T2)> dropWhileN(Function2<T1, T2, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2)> filterN(Function2<T1, T2, bool> p) => filter(p.tupled);

  IList<(T1, T2)> filterNotN(Function2<T1, T2, bool> p) => filterNot(p.tupled);

  IList<T3> flatMapN<T3>(Function2<T1, T2, IList<T3>> f) => flatMap(f.tupled);

  void foreachN(Function2<T1, T2, void> f) => foreach(f.tupled);

  IList<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 3 element tuple.
extension IListTuple3Ops<T1, T2, T3> on IList<(T1, T2, T3)> {
  IList<T4> collectN<T4>(Function3<T1, T2, T3, Option<T4>> f) => collect(f.tupled);

  IList<(T1, T2, T3)> distinctByN<T4>(Function3<T1, T2, T3, T4> f) => distinctBy(f.tupled);

  IList<(T1, T2, T3)> dropWhileN(Function3<T1, T2, T3, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2, T3)> filterN(Function3<T1, T2, T3, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3)> filterNotN(Function3<T1, T2, T3, bool> p) => filterNot(p.tupled);

  IList<T4> flatMapN<T4>(Function3<T1, T2, T3, IList<T4>> f) => flatMap(f.tupled);

  void foreachN(Function3<T1, T2, T3, void> f) => foreach(f.tupled);

  IList<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 4 element tuple.
extension IListTuple4Ops<T1, T2, T3, T4> on IList<(T1, T2, T3, T4)> {
  IList<T5> collectN<T5>(Function4<T1, T2, T3, T4, Option<T5>> f) => collect(f.tupled);

  IList<(T1, T2, T3, T4)> distinctByN<T5>(Function4<T1, T2, T3, T4, T5> f) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4)> dropWhileN(Function4<T1, T2, T3, T4, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4)> filterN(Function4<T1, T2, T3, T4, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3, T4)> filterNotN(Function4<T1, T2, T3, T4, bool> p) => filterNot(p.tupled);

  IList<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, IList<T5>> f) => flatMap(f.tupled);

  void foreachN(Function4<T1, T2, T3, T4, void> f) => foreach(f.tupled);

  IList<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 5 element tuple.
extension IListTuple5Ops<T1, T2, T3, T4, T5> on IList<(T1, T2, T3, T4, T5)> {
  IList<T6> collectN<T6>(Function5<T1, T2, T3, T4, T5, Option<T6>> f) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5)> distinctByN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) =>
      distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5)> dropWhileN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5)> filterN(Function5<T1, T2, T3, T4, T5, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5)> filterNotN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      filterNot(p.tupled);

  IList<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, IList<T6>> f) => flatMap(f.tupled);

  void foreachN(Function5<T1, T2, T3, T4, T5, void> f) => foreach(f.tupled);

  IList<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 6 element tuple.
extension IListTuple6Ops<T1, T2, T3, T4, T5, T6> on IList<(T1, T2, T3, T4, T5, T6)> {
  IList<T7> collectN<T7>(Function6<T1, T2, T3, T4, T5, T6, Option<T7>> f) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6)> distinctByN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) =>
      distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6)> dropWhileN(Function6<T1, T2, T3, T4, T5, T6, bool> p) =>
      dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6)> filterN(Function6<T1, T2, T3, T4, T5, T6, bool> p) =>
      filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6)> filterNotN(Function6<T1, T2, T3, T4, T5, T6, bool> p) =>
      filterNot(p.tupled);

  IList<T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IList<T7>> f) => flatMap(f.tupled);

  void foreachN(Function6<T1, T2, T3, T4, T5, T6, void> f) => foreach(f.tupled);

  IList<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 7 element tuple.
extension IListTuple7Ops<T1, T2, T3, T4, T5, T6, T7> on IList<(T1, T2, T3, T4, T5, T6, T7)> {
  IList<T8> collectN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Option<T8>> f) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7)> distinctByN<T8>(
    Function7<T1, T2, T3, T4, T5, T6, T7, T8> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7)> dropWhileN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> p) =>
      dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7)> filterN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> p) =>
      filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7)> filterNotN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> p) =>
      filterNot(p.tupled);

  IList<T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IList<T8>> f) => flatMap(f.tupled);

  void foreachN(Function7<T1, T2, T3, T4, T5, T6, T7, void> f) => foreach(f.tupled);

  IList<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 8 element tuple.
extension IListTuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8)> {
  IList<T9> collectN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Option<T9>> f) =>
      collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8)> distinctByN<T9>(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8)> dropWhileN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8)> filterN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8)> filterNotN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> p,
  ) => filterNot(p.tupled);

  IList<T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IList<T9>> f) =>
      flatMap(f.tupled);

  void foreachN(Function8<T1, T2, T3, T4, T5, T6, T7, T8, void> f) => foreach(f.tupled);

  IList<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 9 element tuple.
extension IListTuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  IList<T10> collectN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Option<T10>> f) =>
      collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> distinctByN<T10>(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> dropWhileN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterNotN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> p,
  ) => filterNot(p.tupled);

  IList<T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IList<T10>> f) =>
      flatMap(f.tupled);

  void foreachN(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, void> f) => foreach(f.tupled);

  IList<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 10 element tuple.
extension IListTuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  IList<T11> collectN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Option<T11>> f) =>
      collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> distinctByN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> dropWhileN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterNotN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> p,
  ) => filterNot(p.tupled);

  IList<T11> flatMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IList<T11>> f) =>
      flatMap(f.tupled);

  void foreachN(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, void> f) => foreach(f.tupled);

  IList<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) => map(f.tupled);
}

/// Provides additional functions on an IList of a 11 element tuple.
extension IListTuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  IList<T12> collectN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Option<T12>> f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> distinctByN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> dropWhileN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterNotN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> p,
  ) => filterNot(p.tupled);

  IList<T12> flatMapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IList<T12>> f,
  ) => flatMap(f.tupled);

  void foreachN(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, void> f) =>
      foreach(f.tupled);

  IList<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IList of a 12 element tuple.
extension IListTuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  IList<T13> collectN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Option<T13>> f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> distinctByN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> dropWhileN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterNotN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> p,
  ) => filterNot(p.tupled);

  IList<T13> flatMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IList<T13>> f,
  ) => flatMap(f.tupled);

  void foreachN(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, void> f) =>
      foreach(f.tupled);

  IList<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IList of a 13 element tuple.
extension IListTuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  IList<T14> collectN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Option<T14>> f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> distinctByN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> dropWhileN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterNotN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> p,
  ) => filterNot(p.tupled);

  IList<T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IList<T14>> f,
  ) => flatMap(f.tupled);

  void foreachN(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, void> f) =>
      foreach(f.tupled);

  IList<T14> mapN<T14>(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f) =>
      map(f.tupled);
}

/// Provides additional functions on an IList of a 14 element tuple.
extension IListTuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  IList<T15> collectN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Option<T15>> f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> distinctByN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> dropWhileN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterNotN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> p,
  ) => filterNot(p.tupled);

  IList<T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IList<T15>> f,
  ) => flatMap(f.tupled);

  void foreachN(Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, void> f) =>
      foreach(f.tupled);

  IList<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IList of a 15 element tuple.
extension IListTuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  IList<T16> collectN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Option<T16>> f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> distinctByN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> dropWhileN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterNotN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> p,
  ) => filterNot(p.tupled);

  IList<T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IList<T16>> f,
  ) => flatMap(f.tupled);

  void foreachN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, void> f,
  ) => foreach(f.tupled);

  IList<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IList of a 16 element tuple.
extension IListTuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  IList<T17> collectN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, Option<T17>>
    f,
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> distinctByN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> dropWhileN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterNotN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> p,
  ) => filterNot(p.tupled);

  IList<T17> flatMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IList<T17>> f,
  ) => flatMap(f.tupled);

  void foreachN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, void> f,
  ) => foreach(f.tupled);

  IList<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IList of a 17 element tuple.
extension IListTuple17Ops<
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
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  IList<T18> collectN<T18>(
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
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  distinctByN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> dropWhileN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
  ) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterNotN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> p,
  ) => filterNot(p.tupled);

  IList<T18> flatMapN<T18>(
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
      IList<T18>
    >
    f,
  ) => flatMap(f.tupled);

  void foreachN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, void> f,
  ) => foreach(f.tupled);

  IList<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IList of a 18 element tuple.
extension IListTuple18Ops<
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
    on IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> {
  IList<T19> collectN<T19>(
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
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  distinctByN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  dropWhileN(
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
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> filterN(
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

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
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

  IList<T19> flatMapN<T19>(
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
      IList<T19>
    >
    f,
  ) => flatMap(f.tupled);

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

  IList<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);
}

/// Provides additional functions on an IList of a 19 element tuple.
extension IListTuple19Ops<
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
        IList<
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
        > {
  IList<T20> collectN<T20>(
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
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  distinctByN<T20>(
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
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  dropWhileN(
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
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
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

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
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

  IList<T20> flatMapN<T20>(
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
      IList<T20>
    >
    f,
  ) => flatMap(f.tupled);

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

  IList<T20> mapN<T20>(
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

/// Provides additional functions on an IList of a 20 element tuple.
extension IListTuple20Ops<
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
        IList<
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
  IList<T21> collectN<T21>(
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
  ) => collect(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
  distinctByN<T21>(
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
  ) => distinctBy(f.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
  dropWhileN(
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
  ) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
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

  IList<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
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

  IList<T21> flatMapN<T21>(
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
      IList<T21>
    >
    f,
  ) => flatMap(f.tupled);

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

  IList<T21> mapN<T21>(
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

/// Provides additional functions on an IList of a 21 element tuple.
extension IListTuple21Ops<
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
        IList<
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
  IList<T22> collectN<T22>(
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
  ) => collect(f.tupled);

  IList<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  distinctByN<T22>(
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
  ) => distinctBy(f.tupled);

  IList<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  dropWhileN(
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
  ) => dropWhile(p.tupled);

  IList<
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

  IList<
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

  IList<T22> flatMapN<T22>(
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
      IList<T22>
    >
    f,
  ) => flatMap(f.tupled);

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

  IList<T22> mapN<T22>(
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

/// Provides additional functions on an IList of a 22 element tuple.
extension IListTuple22Ops<
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
        IList<
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
  IList<T23> collectN<T23>(
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
  ) => collect(f.tupled);

  IList<
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
  distinctByN<T23>(
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
  ) => distinctBy(f.tupled);

  IList<
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
  dropWhileN(
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
  ) => dropWhile(p.tupled);

  IList<
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

  IList<
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

  IList<T23> flatMapN<T23>(
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
      IList<T23>
    >
    f,
  ) => flatMap(f.tupled);

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

  IList<T23> mapN<T23>(
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
