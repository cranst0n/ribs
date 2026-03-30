part of '../rill.dart';

/// Provides additional functions on a Rill of a 2 element tuple.
extension RillTuple2Ops<T1, T2> on Rill<(T1, T2)> {
  Rill<T3> collectN<T3>(Function2<T1, T2, Option<T3>> f) => collect(f.tupled);

  Rill<T3> evalMapN<T3>(Function2<T1, T2, IO<T3>> f) => evalMap(f.tupled);

  Rill<(T1, T2)> evalTapN<T3>(Function2<T1, T2, IO<T3>> f) => evalTap(f.tupled);

  Rill<(T1, T2)> filterN(Function2<T1, T2, bool> f) => filter(f.tupled);

  Rill<(T1, T2)> filterNotN(Function2<T1, T2, bool> f) => filterNot(f.tupled);

  Rill<T3> flatMapN<T3>(Function2<T1, T2, Rill<T3>> f) => flatMap(f.tupled);

  Rill<T3> mapN<T3>(Function2<T1, T2, T3> f) => map(f.tupled);

  Rill<T3> parEvalMapN<T3>(
    int maxConcurrent,
    Function2<T1, T2, IO<T3>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T3> parEvalMapUnboundedN<T3>(Function2<T1, T2, IO<T3>> f) => parEvalMapUnbounded(f.tupled);

  Rill<T3> parEvalMapUnorderedN<T3>(
    int maxConcurrent,
    Function2<T1, T2, IO<T3>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T3> parEvalMapUnorderedUnboundedN<T3>(Function2<T1, T2, IO<T3>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 3 element tuple.
extension RillTuple3Ops<T1, T2, T3> on Rill<(T1, T2, T3)> {
  Rill<T4> collectN<T4>(Function3<T1, T2, T3, Option<T4>> f) => collect(f.tupled);

  Rill<T4> evalMapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3)> evalTapN<T4>(Function3<T1, T2, T3, IO<T4>> f) => evalTap(f.tupled);

  Rill<(T1, T2, T3)> filterN(Function3<T1, T2, T3, bool> f) => filter(f.tupled);

  Rill<(T1, T2, T3)> filterNotN(Function3<T1, T2, T3, bool> f) => filterNot(f.tupled);

  Rill<T4> flatMapN<T4>(Function3<T1, T2, T3, Rill<T4>> f) => flatMap(f.tupled);

  Rill<T4> mapN<T4>(Function3<T1, T2, T3, T4> f) => map(f.tupled);

  Rill<T4> parEvalMapN<T4>(
    int maxConcurrent,
    Function3<T1, T2, T3, IO<T4>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T4> parEvalMapUnboundedN<T4>(Function3<T1, T2, T3, IO<T4>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T4> parEvalMapUnorderedN<T4>(
    int maxConcurrent,
    Function3<T1, T2, T3, IO<T4>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T4> parEvalMapUnorderedUnboundedN<T4>(Function3<T1, T2, T3, IO<T4>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 4 element tuple.
extension RillTuple4Ops<T1, T2, T3, T4> on Rill<(T1, T2, T3, T4)> {
  Rill<T5> collectN<T5>(Function4<T1, T2, T3, T4, Option<T5>> f) => collect(f.tupled);

  Rill<T5> evalMapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4)> evalTapN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4)> filterN(Function4<T1, T2, T3, T4, bool> f) => filter(f.tupled);

  Rill<(T1, T2, T3, T4)> filterNotN(Function4<T1, T2, T3, T4, bool> f) => filterNot(f.tupled);

  Rill<T5> flatMapN<T5>(Function4<T1, T2, T3, T4, Rill<T5>> f) => flatMap(f.tupled);

  Rill<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> f) => map(f.tupled);

  Rill<T5> parEvalMapN<T5>(
    int maxConcurrent,
    Function4<T1, T2, T3, T4, IO<T5>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T5> parEvalMapUnboundedN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T5> parEvalMapUnorderedN<T5>(
    int maxConcurrent,
    Function4<T1, T2, T3, T4, IO<T5>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T5> parEvalMapUnorderedUnboundedN<T5>(Function4<T1, T2, T3, T4, IO<T5>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 5 element tuple.
extension RillTuple5Ops<T1, T2, T3, T4, T5> on Rill<(T1, T2, T3, T4, T5)> {
  Rill<T6> collectN<T6>(Function5<T1, T2, T3, T4, T5, Option<T6>> f) => collect(f.tupled);

  Rill<T6> evalMapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5)> evalTapN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5)> filterN(Function5<T1, T2, T3, T4, T5, bool> f) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5)> filterNotN(Function5<T1, T2, T3, T4, T5, bool> f) =>
      filterNot(f.tupled);

  Rill<T6> flatMapN<T6>(Function5<T1, T2, T3, T4, T5, Rill<T6>> f) => flatMap(f.tupled);

  Rill<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => map(f.tupled);

  Rill<T6> parEvalMapN<T6>(
    int maxConcurrent,
    Function5<T1, T2, T3, T4, T5, IO<T6>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T6> parEvalMapUnboundedN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T6> parEvalMapUnorderedN<T6>(
    int maxConcurrent,
    Function5<T1, T2, T3, T4, T5, IO<T6>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T6> parEvalMapUnorderedUnboundedN<T6>(Function5<T1, T2, T3, T4, T5, IO<T6>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}
