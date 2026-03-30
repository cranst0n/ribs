part of '../resource.dart';

/// Provides additional functions on a Resource of a 2 element tuple.
extension ResourceTuple2Ops<T1, T2> on Resource<(T1, T2)> {
  Resource<T3> evalMapN<T3>(Function2<T1, T2, IO<T3>> f) => evalMap(f.tupled);

  Resource<(T1, T2)> evalTapN<T3>(Function2<T1, T2, IO<T3>> f) => evalTap(f.tupled);

  Resource<T3> flatMapN<T3>(Function2<T1, T2, Resource<T3>> f) => flatMap(f.tupled);

  Resource<(T1, T2)> flatTapN<T3>(Function2<T1, T2, Resource<T3>> f) => flatTap(f.tupled);

  Resource<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);

  IO<T3> useN<T3>(Function2<T1, T2, IO<T3>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 3 element tuple.
extension ResourceTuple3Ops<T1, T2, T3> on Resource<(T1, T2, T3)> {
  Resource<T4> evalMapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3)> evalTapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalTap(f.tupled);

  Resource<T4> flatMapN<T4>(Function3<T1, T2, T3, Resource<T4>> f) => flatMap(f.tupled);

  Resource<(T1, T2, T3)> flatTapN<T4>(Function3<T1, T2, T3, Resource<T4>> f) => flatTap(f.tupled);

  Resource<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);

  IO<T4> useN<T4>(Function3<T1, T2, T3, IO<T4>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 4 element tuple.
extension ResourceTuple4Ops<T1, T2, T3, T4> on Resource<(T1, T2, T3, T4)> {
  Resource<T5> evalMapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4)> evalTapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalTap(f.tupled);

  Resource<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, Resource<T5>> f) => flatMap(f.tupled);

  Resource<(T1, T2, T3, T4)> flatTapN<T5>(Function4<T1, T2, T3, T4, Resource<T5>> f) =>
      flatTap(f.tupled);

  Resource<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);

  IO<T5> useN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => use(f.tupled);
}

/// Provides additional functions on a Resource of a 5 element tuple.
extension ResourceTuple5Ops<T1, T2, T3, T4, T5> on Resource<(T1, T2, T3, T4, T5)> {
  Resource<T6> evalMapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => evalMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5)> evalTapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      evalTap(f.tupled);

  Resource<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, Resource<T6>> f) => flatMap(f.tupled);

  Resource<(T1, T2, T3, T4, T5)> flatTapN<T6>(Function5<T1, T2, T3, T4, T5, Resource<T6>> f) =>
      flatTap(f.tupled);

  Resource<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);

  IO<T6> useN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => use(f.tupled);
}
