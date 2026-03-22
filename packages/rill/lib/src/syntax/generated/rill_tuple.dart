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

/// Provides additional functions on a Rill of a 6 element tuple.
extension RillTuple6Ops<T1, T2, T3, T4, T5, T6> on Rill<(T1, T2, T3, T4, T5, T6)> {
  Rill<T7> collectN<T7>(Function6<T1, T2, T3, T4, T5, T6, Option<T7>> f) => collect(f.tupled);

  Rill<T7> evalMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6)> evalTapN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) =>
      evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6)> filterN(Function6<T1, T2, T3, T4, T5, T6, bool> f) =>
      filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6)> filterNotN(Function6<T1, T2, T3, T4, T5, T6, bool> f) =>
      filterNot(f.tupled);

  Rill<T7> flatMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, Rill<T7>> f) => flatMap(f.tupled);

  Rill<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => map(f.tupled);

  Rill<T7> parEvalMapN<T7>(
    int maxConcurrent,
    Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T7> parEvalMapUnboundedN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T7> parEvalMapUnorderedN<T7>(
    int maxConcurrent,
    Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T7> parEvalMapUnorderedUnboundedN<T7>(Function6<T1, T2, T3, T4, T5, T6, IO<T7>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 7 element tuple.
extension RillTuple7Ops<T1, T2, T3, T4, T5, T6, T7> on Rill<(T1, T2, T3, T4, T5, T6, T7)> {
  Rill<T8> collectN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Option<T8>> f) => collect(f.tupled);

  Rill<T8> evalMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7)> evalTapN<T8>(
    Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7)> filterN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> f) =>
      filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7)> filterNotN(Function7<T1, T2, T3, T4, T5, T6, T7, bool> f) =>
      filterNot(f.tupled);

  Rill<T8> flatMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, Rill<T8>> f) => flatMap(f.tupled);

  Rill<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => map(f.tupled);

  Rill<T8> parEvalMapN<T8>(
    int maxConcurrent,
    Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T8> parEvalMapUnboundedN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T8> parEvalMapUnorderedN<T8>(
    int maxConcurrent,
    Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T8> parEvalMapUnorderedUnboundedN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, IO<T8>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 8 element tuple.
extension RillTuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8> on Rill<(T1, T2, T3, T4, T5, T6, T7, T8)> {
  Rill<T9> collectN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Option<T9>> f) =>
      collect(f.tupled);

  Rill<T9> evalMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8)> evalTapN<T9>(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8)> filterN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8)> filterNotN(
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, bool> f,
  ) => filterNot(f.tupled);

  Rill<T9> flatMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, Rill<T9>> f) => flatMap(f.tupled);

  Rill<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => map(f.tupled);

  Rill<T9> parEvalMapN<T9>(
    int maxConcurrent,
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T9> parEvalMapUnboundedN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T9> parEvalMapUnorderedN<T9>(
    int maxConcurrent,
    Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T9> parEvalMapUnorderedUnboundedN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, IO<T9>> f) =>
      parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 9 element tuple.
extension RillTuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> {
  Rill<T10> collectN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Option<T10>> f) =>
      collect(f.tupled);

  Rill<T10> evalMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f) =>
      evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> evalTapN<T10>(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> filterNotN(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool> f,
  ) => filterNot(f.tupled);

  Rill<T10> flatMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, Rill<T10>> f) =>
      flatMap(f.tupled);

  Rill<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) => map(f.tupled);

  Rill<T10> parEvalMapN<T10>(
    int maxConcurrent,
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T10> parEvalMapUnboundedN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f) =>
      parEvalMapUnbounded(f.tupled);

  Rill<T10> parEvalMapUnorderedN<T10>(
    int maxConcurrent,
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T10> parEvalMapUnorderedUnboundedN<T10>(
    Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, IO<T10>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 10 element tuple.
extension RillTuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> {
  Rill<T11> collectN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Option<T11>> f) =>
      collect(f.tupled);

  Rill<T11> evalMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f) =>
      evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> evalTapN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> filterNotN(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool> f,
  ) => filterNot(f.tupled);

  Rill<T11> flatMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, Rill<T11>> f) =>
      flatMap(f.tupled);

  Rill<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) => map(f.tupled);

  Rill<T11> parEvalMapN<T11>(
    int maxConcurrent,
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T11> parEvalMapUnboundedN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T11> parEvalMapUnorderedN<T11>(
    int maxConcurrent,
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T11> parEvalMapUnorderedUnboundedN<T11>(
    Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, IO<T11>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 11 element tuple.
extension RillTuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> {
  Rill<T12> collectN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Option<T12>> f,
  ) => collect(f.tupled);

  Rill<T12> evalMapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f) =>
      evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> evalTapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> filterNotN(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool> f,
  ) => filterNot(f.tupled);

  Rill<T12> flatMapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, Rill<T12>> f) =>
      flatMap(f.tupled);

  Rill<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      map(f.tupled);

  Rill<T12> parEvalMapN<T12>(
    int maxConcurrent,
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T12> parEvalMapUnboundedN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T12> parEvalMapUnorderedN<T12>(
    int maxConcurrent,
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T12> parEvalMapUnorderedUnboundedN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, IO<T12>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 12 element tuple.
extension RillTuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> {
  Rill<T13> collectN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Option<T13>> f,
  ) => collect(f.tupled);

  Rill<T13> evalMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> evalTapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> filterNotN(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool> f,
  ) => filterNot(f.tupled);

  Rill<T13> flatMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, Rill<T13>> f,
  ) => flatMap(f.tupled);

  Rill<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      map(f.tupled);

  Rill<T13> parEvalMapN<T13>(
    int maxConcurrent,
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T13> parEvalMapUnboundedN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T13> parEvalMapUnorderedN<T13>(
    int maxConcurrent,
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T13> parEvalMapUnorderedUnboundedN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, IO<T13>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 13 element tuple.
extension RillTuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> {
  Rill<T14> collectN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Option<T14>> f,
  ) => collect(f.tupled);

  Rill<T14> evalMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> evalTapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> filterNotN(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool> f,
  ) => filterNot(f.tupled);

  Rill<T14> flatMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, Rill<T14>> f,
  ) => flatMap(f.tupled);

  Rill<T14> mapN<T14>(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f) =>
      map(f.tupled);

  Rill<T14> parEvalMapN<T14>(
    int maxConcurrent,
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T14> parEvalMapUnboundedN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T14> parEvalMapUnorderedN<T14>(
    int maxConcurrent,
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T14> parEvalMapUnorderedUnboundedN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, IO<T14>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 14 element tuple.
extension RillTuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> {
  Rill<T15> collectN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Option<T15>> f,
  ) => collect(f.tupled);

  Rill<T15> evalMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> evalTapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> filterNotN(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool> f,
  ) => filterNot(f.tupled);

  Rill<T15> flatMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, Rill<T15>> f,
  ) => flatMap(f.tupled);

  Rill<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f,
  ) => map(f.tupled);

  Rill<T15> parEvalMapN<T15>(
    int maxConcurrent,
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T15> parEvalMapUnboundedN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T15> parEvalMapUnorderedN<T15>(
    int maxConcurrent,
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T15> parEvalMapUnorderedUnboundedN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, IO<T15>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 15 element tuple.
extension RillTuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> {
  Rill<T16> collectN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Option<T16>> f,
  ) => collect(f.tupled);

  Rill<T16> evalMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> evalTapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> filterNotN(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool> f,
  ) => filterNot(f.tupled);

  Rill<T16> flatMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, Rill<T16>> f,
  ) => flatMap(f.tupled);

  Rill<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => map(f.tupled);

  Rill<T16> parEvalMapN<T16>(
    int maxConcurrent,
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T16> parEvalMapUnboundedN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T16> parEvalMapUnorderedN<T16>(
    int maxConcurrent,
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T16> parEvalMapUnorderedUnboundedN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, IO<T16>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 16 element tuple.
extension RillTuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> {
  Rill<T17> collectN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, Option<T17>>
    f,
  ) => collect(f.tupled);

  Rill<T17> evalMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> evalTapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> filterNotN(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, bool> f,
  ) => filterNot(f.tupled);

  Rill<T17> flatMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, Rill<T17>> f,
  ) => flatMap(f.tupled);

  Rill<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => map(f.tupled);

  Rill<T17> parEvalMapN<T17>(
    int maxConcurrent,
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T17> parEvalMapUnboundedN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T17> parEvalMapUnorderedN<T17>(
    int maxConcurrent,
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T17> parEvalMapUnorderedUnboundedN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, IO<T17>> f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 17 element tuple.
extension RillTuple17Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> {
  Rill<T18> collectN<T18>(
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

  Rill<T18> evalMapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => evalMap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> evalTapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => evalTap(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> filterNotN(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, bool> f,
  ) => filterNot(f.tupled);

  Rill<T18> flatMapN<T18>(
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
      Rill<T18>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => map(f.tupled);

  Rill<T18> parEvalMapN<T18>(
    int maxConcurrent,
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T18> parEvalMapUnboundedN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T18> parEvalMapUnorderedN<T18>(
    int maxConcurrent,
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T18> parEvalMapUnorderedUnboundedN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, IO<T18>>
    f,
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 18 element tuple.
extension RillTuple18Ops<
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
    on Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> {
  Rill<T19> collectN<T19>(
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

  Rill<T19> evalMapN<T19>(
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)> filterN(
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
    f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
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
    f,
  ) => filterNot(f.tupled);

  Rill<T19> flatMapN<T19>(
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
      Rill<T19>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => map(f.tupled);

  Rill<T19> parEvalMapN<T19>(
    int maxConcurrent,
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
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T19> parEvalMapUnboundedN<T19>(
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
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T19> parEvalMapUnorderedN<T19>(
    int maxConcurrent,
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
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T19> parEvalMapUnorderedUnboundedN<T19>(
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
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 19 element tuple.
extension RillTuple19Ops<
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
        Rill<
          (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
        > {
  Rill<T20> collectN<T20>(
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

  Rill<T20> evalMapN<T20>(
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
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
    f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
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
    f,
  ) => filterNot(f.tupled);

  Rill<T20> flatMapN<T20>(
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
      Rill<T20>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T20> mapN<T20>(
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

  Rill<T20> parEvalMapN<T20>(
    int maxConcurrent,
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
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T20> parEvalMapUnboundedN<T20>(
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
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T20> parEvalMapUnorderedN<T20>(
    int maxConcurrent,
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
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T20> parEvalMapUnorderedUnboundedN<T20>(
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
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 20 element tuple.
extension RillTuple20Ops<
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
        Rill<
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
  Rill<T21> collectN<T21>(
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

  Rill<T21> evalMapN<T21>(
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
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

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
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
    f,
  ) => filter(f.tupled);

  Rill<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
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
    f,
  ) => filterNot(f.tupled);

  Rill<T21> flatMapN<T21>(
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
      Rill<T21>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T21> mapN<T21>(
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

  Rill<T21> parEvalMapN<T21>(
    int maxConcurrent,
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
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T21> parEvalMapUnboundedN<T21>(
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
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T21> parEvalMapUnorderedN<T21>(
    int maxConcurrent,
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
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T21> parEvalMapUnorderedUnboundedN<T21>(
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
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 21 element tuple.
extension RillTuple21Ops<
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
        Rill<
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
  Rill<T22> collectN<T22>(
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

  Rill<T22> evalMapN<T22>(
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

  Rill<
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

  Rill<
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
    f,
  ) => filter(f.tupled);

  Rill<
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
    f,
  ) => filterNot(f.tupled);

  Rill<T22> flatMapN<T22>(
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
      Rill<T22>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T22> mapN<T22>(
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

  Rill<T22> parEvalMapN<T22>(
    int maxConcurrent,
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
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T22> parEvalMapUnboundedN<T22>(
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
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T22> parEvalMapUnorderedN<T22>(
    int maxConcurrent,
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
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T22> parEvalMapUnorderedUnboundedN<T22>(
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
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}

/// Provides additional functions on a Rill of a 22 element tuple.
extension RillTuple22Ops<
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
        Rill<
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
  Rill<T23> collectN<T23>(
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

  Rill<T23> evalMapN<T23>(
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

  Rill<
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

  Rill<
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
    f,
  ) => filter(f.tupled);

  Rill<
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
    f,
  ) => filterNot(f.tupled);

  Rill<T23> flatMapN<T23>(
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
      Rill<T23>
    >
    f,
  ) => flatMap(f.tupled);

  Rill<T23> mapN<T23>(
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

  Rill<T23> parEvalMapN<T23>(
    int maxConcurrent,
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
  ) => parEvalMap(maxConcurrent, f.tupled);

  Rill<T23> parEvalMapUnboundedN<T23>(
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
  ) => parEvalMapUnbounded(f.tupled);

  Rill<T23> parEvalMapUnorderedN<T23>(
    int maxConcurrent,
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
  ) => parEvalMapUnordered(maxConcurrent, f.tupled);

  Rill<T23> parEvalMapUnorderedUnboundedN<T23>(
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
  ) => parEvalMapUnorderedUnbounded(f.tupled);
}
