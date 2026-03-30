part of '../io.dart';

/// Provides additional functions on an IO of a 2 element tuple.
extension IOTuple2Ops<T1, T2> on IO<(T1, T2)> {
  IO<T3> flatMapN<T3>(Function2<T1, T2, IO<T3>> f) => flatMap(f.tupled);

  IO<(T1, T2)> flatTapN<T3>(Function2<T1, T2, IO<T3>> f) => flatTap(f.tupled);

  IO<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 3 element tuple.
extension IOTuple3Ops<T1, T2, T3> on IO<(T1, T2, T3)> {
  IO<T4> flatMapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => flatMap(f.tupled);

  IO<(T1, T2, T3)> flatTapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => flatTap(f.tupled);

  IO<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 4 element tuple.
extension IOTuple4Ops<T1, T2, T3, T4> on IO<(T1, T2, T3, T4)> {
  IO<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => flatMap(f.tupled);

  IO<(T1, T2, T3, T4)> flatTapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => flatTap(f.tupled);

  IO<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);
}

/// Provides additional functions on an IO of a 5 element tuple.
extension IOTuple5Ops<T1, T2, T3, T4, T5> on IO<(T1, T2, T3, T4, T5)> {
  IO<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => flatMap(f.tupled);

  IO<(T1, T2, T3, T4, T5)> flatTapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      flatTap(f.tupled);

  IO<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);
}
