import 'package:ribs_core/src/function.dart';

extension Tuple2Ops<A, B> on (A, B) {
  (A, B, C) append<C>(C $3) => ($1, $2, $3);

  (C, D) bimap<C, D>(Function1<A, C> fa, Function1<B, D> fb) =>
      (fa($1), fb($2));

  C call<C>(Function2<A, B, C> f) => f($1, $2);

  (A, B) copy({
    A? $1,
    B? $2,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
      );

  B get last => $2;
}

extension Tuple3Ops<A, B, C> on (A, B, C) {
  (A, B, C, D) append<D>(D $4) => ($1, $2, $3, $4);

  D call<D>(Function3<A, B, C, D> f) => f($1, $2, $3);

  (A, B, C) copy({
    A? $1,
    B? $2,
    C? $3,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
      );

  (A, B) init() => ($1, $2);

  C get last => $3;
}

extension Tuple4Ops<A, B, C, D> on (A, B, C, D) {
  (A, B, C, D, E) append<E>(E $5) => ($1, $2, $3, $4, $5);

  E call<E>(Function4<A, B, C, D, E> f) => f($1, $2, $3, $4);

  (A, B, C, D) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
      );

  (A, B, C) init() => ($1, $2, $3);

  D get last => $4;
}

extension Tuple5Ops<A, B, C, D, E> on (A, B, C, D, E) {
  (A, B, C, D, E, F) append<F>(F $6) => ($1, $2, $3, $4, $5, $6);

  F call<F>(Function5<A, B, C, D, E, F> f) => f($1, $2, $3, $4, $5);

  (A, B, C, D, E) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
      );

  (A, B, C, D) init() => ($1, $2, $3, $4);

  E get last => $5;
}

extension Tuple6Ops<A, B, C, D, E, F> on (A, B, C, D, E, F) {
  (A, B, C, D, E, F, G) append<G>(G $7) => ($1, $2, $3, $4, $5, $6, $7);

  G call<G>(Function6<A, B, C, D, E, F, G> f) => f($1, $2, $3, $4, $5, $6);

  (A, B, C, D, E, F) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
      );

  (A, B, C, D, E) init() => ($1, $2, $3, $4, $5);

  F get last => $6;
}

extension Tuple7Ops<A, B, C, D, E, F, G> on (A, B, C, D, E, F, G) {
  (A, B, C, D, E, F, G, H) append<H>(H $8) => ($1, $2, $3, $4, $5, $6, $7, $8);

  H call<H>(Function7<A, B, C, D, E, F, G, H> f) =>
      f($1, $2, $3, $4, $5, $6, $7);

  (A, B, C, D, E, F, G) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
      );

  (A, B, C, D, E, F) init() => ($1, $2, $3, $4, $5, $6);

  G get last => $7;
}

extension Tuple8Ops<A, B, C, D, E, F, G, H> on (A, B, C, D, E, F, G, H) {
  (A, B, C, D, E, F, G, H, I) append<I>(I $9) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9);

  I call<I>(Function8<A, B, C, D, E, F, G, H, I> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8);

  (A, B, C, D, E, F, G, H) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
      );

  (A, B, C, D, E, F, G) init() => ($1, $2, $3, $4, $5, $6, $7);

  H get last => $8;
}

extension Tuple9Ops<A, B, C, D, E, F, G, H, I> on (A, B, C, D, E, F, G, H, I) {
  (A, B, C, D, E, F, G, H, I, J) append<J>(J $10) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  J call<J>(Function9<A, B, C, D, E, F, G, H, I, J> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9);

  (A, B, C, D, E, F, G, H, I) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
      );

  (A, B, C, D, E, F, G, H) init() => ($1, $2, $3, $4, $5, $6, $7, $8);

  I get last => $9;
}

extension Tuple10Ops<A, B, C, D, E, F, G, H, I, J> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J
) {
  (A, B, C, D, E, F, G, H, I, J, K) append<K>(K $11) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  K call<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  (A, B, C, D, E, F, G, H, I, J) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
      );

  (A, B, C, D, E, F, G, H, I) init() => ($1, $2, $3, $4, $5, $6, $7, $8, $9);

  J get last => $10;
}

extension Tuple11Ops<A, B, C, D, E, F, G, H, I, J, K> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K
) {
  (A, B, C, D, E, F, G, H, I, J, K, L) append<L>(L $12) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  L call<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  (A, B, C, D, E, F, G, H, I, J, K) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11
      );

  (A, B, C, D, E, F, G, H, I, J) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  K get last => $11;
}

extension Tuple12Ops<A, B, C, D, E, F, G, H, I, J, K, L> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M) append<M>(M $13) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  M call<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  (A, B, C, D, E, F, G, H, I, J, K, L) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12
      );

  (A, B, C, D, E, F, G, H, I, J, K) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  L get last => $12;
}

extension Tuple13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N) append<N>(N $14) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  N call<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  (A, B, C, D, E, F, G, H, I, J, K, L, M) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13
      );

  (A, B, C, D, E, F, G, H, I, J, K, L) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  M get last => $13;
}

extension Tuple14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) append<O>(O $15) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  O call<O>(Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  N get last => $14;
}

extension Tuple15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) append<P>(P $16) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  P call<P>(Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  O get last => $15;
}

extension Tuple16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) append<Q>(Q $17) => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17
      );

  Q call<Q>(Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  P get last => $16;
}

extension Tuple17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) append<R>(R $18) => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18
      );

  R call<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) init() =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  Q get last => $17;
}

extension Tuple18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R
) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) append<S>(S $19) =>
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19
      );

  S call<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
    R? $18,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17,
        $18 ?? this.$18
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) init() => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17
      );

  R get last => $18;
}

extension Tuple19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T) append<T>(
          T $20) =>
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20
      );

  T call<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
    R? $18,
    S? $19,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17,
        $18 ?? this.$18,
        $19 ?? this.$19
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) init() => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18
      );

  S get last => $19;
}

extension Tuple20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T> on (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U) append<U>(
          U $21) =>
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20,
        $21
      );

  U call<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
    R? $18,
    S? $19,
    T? $20,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17,
        $18 ?? this.$18,
        $19 ?? this.$19,
        $20 ?? this.$20
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) init() => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19
      );

  T get last => $20;
}

extension Tuple21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T, U> on (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V) append<V>(
          V $22) =>
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20,
        $21,
        $22
      );

  V call<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20, $21);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
    R? $18,
    S? $19,
    T? $20,
    U? $21,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17,
        $18 ?? this.$18,
        $19 ?? this.$19,
        $20 ?? this.$20,
        $21 ?? this.$21
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T) init() => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20
      );

  U get last => $21;
}

extension Tuple22Ops<
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V> on (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V) {
  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W)
      append<W>(W $23) => (
            $1,
            $2,
            $3,
            $4,
            $5,
            $6,
            $7,
            $8,
            $9,
            $10,
            $11,
            $12,
            $13,
            $14,
            $15,
            $16,
            $17,
            $18,
            $19,
            $20,
            $21,
            $22,
            $23
          );

  W call<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20, $21, $22);

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V) copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
    I? $9,
    J? $10,
    K? $11,
    L? $12,
    M? $13,
    N? $14,
    O? $15,
    P? $16,
    Q? $17,
    R? $18,
    S? $19,
    T? $20,
    U? $21,
    V? $22,
  }) =>
      (
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
        $9 ?? this.$9,
        $10 ?? this.$10,
        $11 ?? this.$11,
        $12 ?? this.$12,
        $13 ?? this.$13,
        $14 ?? this.$14,
        $15 ?? this.$15,
        $16 ?? this.$16,
        $17 ?? this.$17,
        $18 ?? this.$18,
        $19 ?? this.$19,
        $20 ?? this.$20,
        $21 ?? this.$21,
        $22 ?? this.$22
      );

  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U) init() => (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20,
        $21
      );

  V get last => $22;
}
