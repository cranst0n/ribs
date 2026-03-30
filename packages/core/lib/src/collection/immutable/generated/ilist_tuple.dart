part of '../ilist.dart';

/// Provides additional functions on an IList of a 2 element tuple.
extension IListTuple2Ops<T1, T2> on IList<(T1, T2)> {
  IList<(T1, T2)> dropWhileN(Function2<T1, T2, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2)> filterN(Function2<T1, T2, bool> p) => filter(p.tupled);

  IList<(T1, T2)> filterNotN(Function2<T1, T2, bool> p) => filterNot(p.tupled);

  IList<T3> flatMapN<T3>(Function2<T1, T2, IList<T3>> f) => flatMap(f.tupled);

  void foreachN(Function2<T1, T2, void> f) => foreach(f.tupled);

  IList<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);

  IList<(T1, T2)> takeWhileN(Function2<T1, T2, bool> p) => takeWhile(p.tupled);
}

/// Provides additional functions on an IList of a 3 element tuple.
extension IListTuple3Ops<T1, T2, T3> on IList<(T1, T2, T3)> {
  IList<(T1, T2, T3)> dropWhileN(Function3<T1, T2, T3, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2, T3)> filterN(Function3<T1, T2, T3, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3)> filterNotN(Function3<T1, T2, T3, bool> p) => filterNot(p.tupled);

  IList<T4> flatMapN<T4>(Function3<T1, T2, T3, IList<T4>> f) => flatMap(f.tupled);

  void foreachN(Function3<T1, T2, T3, void> f) => foreach(f.tupled);

  IList<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);

  IList<(T1, T2, T3)> takeWhileN(Function3<T1, T2, T3, bool> p) => takeWhile(p.tupled);
}

/// Provides additional functions on an IList of a 4 element tuple.
extension IListTuple4Ops<T1, T2, T3, T4> on IList<(T1, T2, T3, T4)> {
  IList<(T1, T2, T3, T4)> dropWhileN(Function4<T1, T2, T3, T4, bool> p) => dropWhile(p.tupled);

  IList<(T1, T2, T3, T4)> filterN(Function4<T1, T2, T3, T4, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3, T4)> filterNotN(Function4<T1, T2, T3, T4, bool> p) => filterNot(p.tupled);

  IList<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, IList<T5>> f) => flatMap(f.tupled);

  void foreachN(Function4<T1, T2, T3, T4, void> f) => foreach(f.tupled);

  IList<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);

  IList<(T1, T2, T3, T4)> takeWhileN(Function4<T1, T2, T3, T4, bool> p) => takeWhile(p.tupled);
}

/// Provides additional functions on an IList of a 5 element tuple.
extension IListTuple5Ops<T1, T2, T3, T4, T5> on IList<(T1, T2, T3, T4, T5)> {
  IList<(T1, T2, T3, T4, T5)> dropWhileN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      dropWhile(p.tupled);

  IList<(T1, T2, T3, T4, T5)> filterN(Function5<T1, T2, T3, T4, T5, bool> p) => filter(p.tupled);

  IList<(T1, T2, T3, T4, T5)> filterNotN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      filterNot(p.tupled);

  IList<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, IList<T6>> f) => flatMap(f.tupled);

  void foreachN(Function5<T1, T2, T3, T4, T5, void> f) => foreach(f.tupled);

  IList<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);

  IList<(T1, T2, T3, T4, T5)> takeWhileN(Function5<T1, T2, T3, T4, T5, bool> p) =>
      takeWhile(p.tupled);
}
