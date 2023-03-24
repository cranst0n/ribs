import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@immutable
abstract class _TupleBase {
  const _TupleBase();

  IList<dynamic> _toIList();

  @override
  String toString() => _toIList().mkString(start: '(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) =>
      other is _TupleBase && _toIList() == other._toIList();

  @override
  int get hashCode => _toIList().hashCode;
}

class Tuple2<A, B> extends _TupleBase {
  final A $1;
  final B $2;

  const Tuple2(this.$1, this.$2);

  Tuple3<A, B, C> append<C>(C $3) => Tuple3($1, $2, $3);

  C call<C>(Function2<A, B, C> f) => f($1, $2);

  Tuple2<A, B> copy({
    A? $1,
    B? $2,
  }) =>
      Tuple2(
        $1 ?? this.$1,
        $2 ?? this.$2,
      );

  A get head => $1;

  B get last => $2;

  @override
  IList<dynamic> _toIList() => ilist([$1, $2]);
}

class Tuple3<A, B, C> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;

  const Tuple3(this.$1, this.$2, this.$3);

  Tuple4<A, B, C, D> append<D>(D $4) => Tuple4($1, $2, $3, $4);

  D call<D>(Function3<A, B, C, D> f) => f($1, $2, $3);

  Tuple3<A, B, C> copy({
    A? $1,
    B? $2,
    C? $3,
  }) =>
      Tuple3(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
      );

  A get head => $1;

  Tuple2<A, B> get init => Tuple2($1, $2);

  C get last => $3;

  Tuple2<B, C> get tail => Tuple2($2, $3);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3]);
}

class Tuple4<A, B, C, D> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;

  const Tuple4(this.$1, this.$2, this.$3, this.$4);

  Tuple5<A, B, C, D, E> append<E>(E $5) => Tuple5($1, $2, $3, $4, $5);

  E call<E>(Function4<A, B, C, D, E> f) => f($1, $2, $3, $4);

  Tuple4<A, B, C, D> copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
  }) =>
      Tuple4(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
      );

  A get head => $1;

  Tuple3<A, B, C> get init => Tuple3($1, $2, $3);

  D get last => $4;

  Tuple3<B, C, D> get tail => Tuple3($2, $3, $4);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4]);
}

class Tuple5<A, B, C, D, E> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;

  const Tuple5(this.$1, this.$2, this.$3, this.$4, this.$5);

  Tuple6<A, B, C, D, E, F> append<F>(F $6) => Tuple6($1, $2, $3, $4, $5, $6);

  F call<F>(Function5<A, B, C, D, E, F> f) => f($1, $2, $3, $4, $5);

  Tuple5<A, B, C, D, E> copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
  }) =>
      Tuple5(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
      );

  A get head => $1;

  Tuple4<A, B, C, D> get init => Tuple4($1, $2, $3, $4);

  E get last => $5;

  Tuple4<B, C, D, E> get tail => Tuple4($2, $3, $4, $5);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5]);
}

class Tuple6<A, B, C, D, E, F> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;

  const Tuple6(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6);

  Tuple7<A, B, C, D, E, F, G> append<G>(G $7) =>
      Tuple7($1, $2, $3, $4, $5, $6, $7);

  G call<G>(Function6<A, B, C, D, E, F, G> f) => f($1, $2, $3, $4, $5, $6);

  Tuple6<A, B, C, D, E, F> copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
  }) =>
      Tuple6(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
      );

  A get head => $1;

  Tuple5<A, B, C, D, E> get init => Tuple5($1, $2, $3, $4, $5);

  F get last => $6;

  Tuple5<B, C, D, E, F> get tail => Tuple5($2, $3, $4, $5, $6);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5, $6]);
}

class Tuple7<A, B, C, D, E, F, G> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;

  const Tuple7(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7);

  Tuple8<A, B, C, D, E, F, G, H> append<H>(H $8) =>
      Tuple8($1, $2, $3, $4, $5, $6, $7, $8);

  H call<H>(Function7<A, B, C, D, E, F, G, H> f) =>
      f($1, $2, $3, $4, $5, $6, $7);

  Tuple7<A, B, C, D, E, F, G> copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
  }) =>
      Tuple7(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
      );

  A get head => $1;

  Tuple6<A, B, C, D, E, F> get init => Tuple6($1, $2, $3, $4, $5, $6);

  G get last => $7;

  Tuple6<B, C, D, E, F, G> get tail => Tuple6($2, $3, $4, $5, $6, $7);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5, $6, $7]);
}

class Tuple8<A, B, C, D, E, F, G, H> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;

  const Tuple8(
      this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7, this.$8);

  Tuple9<A, B, C, D, E, F, G, H, I> append<I>(I $9) =>
      Tuple9($1, $2, $3, $4, $5, $6, $7, $8, $9);

  I call<I>(Function8<A, B, C, D, E, F, G, H, I> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8);

  Tuple8<A, B, C, D, E, F, G, H> copy({
    A? $1,
    B? $2,
    C? $3,
    D? $4,
    E? $5,
    F? $6,
    G? $7,
    H? $8,
  }) =>
      Tuple8(
        $1 ?? this.$1,
        $2 ?? this.$2,
        $3 ?? this.$3,
        $4 ?? this.$4,
        $5 ?? this.$5,
        $6 ?? this.$6,
        $7 ?? this.$7,
        $8 ?? this.$8,
      );

  A get head => $1;

  Tuple7<A, B, C, D, E, F, G> get init => Tuple7($1, $2, $3, $4, $5, $6, $7);

  H get last => $8;

  Tuple7<B, C, D, E, F, G, H> get tail => Tuple7($2, $3, $4, $5, $6, $7, $8);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5, $6, $7, $8]);
}

class Tuple9<A, B, C, D, E, F, G, H, I> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;

  const Tuple9(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9);

  Tuple10<A, B, C, D, E, F, G, H, I, J> append<J>(J $10) =>
      Tuple10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  J call<J>(Function9<A, B, C, D, E, F, G, H, I, J> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9);

  Tuple9<A, B, C, D, E, F, G, H, I> copy({
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
      Tuple9(
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

  A get head => $1;

  Tuple8<A, B, C, D, E, F, G, H> get init =>
      Tuple8($1, $2, $3, $4, $5, $6, $7, $8);

  I get last => $9;

  Tuple8<B, C, D, E, F, G, H, I> get tail =>
      Tuple8($2, $3, $4, $5, $6, $7, $8, $9);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9]);
}

class Tuple10<A, B, C, D, E, F, G, H, I, J> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;

  const Tuple10(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9, this.$10);

  Tuple11<A, B, C, D, E, F, G, H, I, J, K> append<K>(K $11) =>
      Tuple11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  K call<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  Tuple10<A, B, C, D, E, F, G, H, I, J> copy({
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
      Tuple10(
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

  A get head => $1;

  Tuple9<A, B, C, D, E, F, G, H, I> get init =>
      Tuple9($1, $2, $3, $4, $5, $6, $7, $8, $9);

  J get last => $10;

  Tuple9<B, C, D, E, F, G, H, I, J> get tail =>
      Tuple9($2, $3, $4, $5, $6, $7, $8, $9, $10);

  @override
  IList<dynamic> _toIList() => ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10]);
}

class Tuple11<A, B, C, D, E, F, G, H, I, J, K> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;

  const Tuple11(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9, this.$10, this.$11);

  Tuple12<A, B, C, D, E, F, G, H, I, J, K, L> append<L>(L $12) =>
      Tuple12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  L call<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> f) => f(
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
      );

  Tuple11<A, B, C, D, E, F, G, H, I, J, K> copy({
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
      Tuple11(
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
          $11 ?? this.$11);

  A get head => $1;

  Tuple10<A, B, C, D, E, F, G, H, I, J> get init =>
      Tuple10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  K get last => $11;

  Tuple10<B, C, D, E, F, G, H, I, J, K> get tail =>
      Tuple10($2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  @override
  IList<dynamic> _toIList() =>
      ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11]);
}

class Tuple12<A, B, C, D, E, F, G, H, I, J, K, L> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;

  const Tuple12(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9, this.$10, this.$11, this.$12);

  Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M> append<M>(M $13) =>
      Tuple13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  M call<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  Tuple12<A, B, C, D, E, F, G, H, I, J, K, L> copy({
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
      Tuple12(
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
          $12 ?? this.$12);

  A get head => $1;

  Tuple11<A, B, C, D, E, F, G, H, I, J, K> get init =>
      Tuple11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  L get last => $12;

  Tuple11<B, C, D, E, F, G, H, I, J, K, L> get tail =>
      Tuple11($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  @override
  IList<dynamic> _toIList() =>
      ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12]);
}

class Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;

  const Tuple13(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9, this.$10, this.$11, this.$12, this.$13);

  Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N> append<N>(N $14) =>
      Tuple14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  N call<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M> copy({
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
      Tuple13(
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
          $13 ?? this.$13);

  A get head => $1;

  Tuple12<A, B, C, D, E, F, G, H, I, J, K, L> get init =>
      Tuple12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  M get last => $13;

  Tuple12<B, C, D, E, F, G, H, I, J, K, L, M> get tail =>
      Tuple12($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  @override
  IList<dynamic> _toIList() =>
      ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13]);
}

class Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;

  const Tuple14(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7,
      this.$8, this.$9, this.$10, this.$11, this.$12, this.$13, this.$14);

  Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> append<O>(O $15) =>
      Tuple15($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  O call<O>(Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N> copy({
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
      Tuple14(
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
          $14 ?? this.$14);

  A get head => $1;

  Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M> get init =>
      Tuple13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  N get last => $14;

  Tuple13<B, C, D, E, F, G, H, I, J, K, L, M, N> get tail =>
      Tuple13($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  @override
  IList<dynamic> _toIList() =>
      ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14]);
}

class Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;

  const Tuple15(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15);

  Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> append<P>(P $16) =>
      Tuple16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16);

  P call<P>(Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> copy({
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
      Tuple15(
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
          $15 ?? this.$15);

  A get head => $1;

  Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N> get init =>
      Tuple14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  O get last => $15;

  Tuple14<B, C, D, E, F, G, H, I, J, K, L, M, N, O> get tail =>
      Tuple14($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  @override
  IList<dynamic> _toIList() =>
      ilist([$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15]);
}

class Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;

  const Tuple16(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16);

  Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> append<Q>(Q $17) =>
      Tuple17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17);

  Q call<Q>(Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> copy({
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
      Tuple16(
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
          $16 ?? this.$16);

  A get head => $1;

  Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> get init =>
      Tuple15($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  P get last => $16;

  Tuple15<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> get tail => Tuple15(
      $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  @override
  IList<dynamic> _toIList() => ilist(
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16]);
}

class Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;

  const Tuple17(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17);

  Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> append<R>(
          R $18) =>
      Tuple18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17, $18);

  R call<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17);

  Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> copy({
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
      Tuple17(
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
          $17 ?? this.$17);

  A get head => $1;

  Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> get init => Tuple16(
      $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  Q get last => $17;

  Tuple16<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> get tail => Tuple16(
      $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}

class Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;
  final R $18;

  const Tuple18(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17,
      this.$18);

  Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> append<S>(
          S $19) =>
      Tuple19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17, $18, $19);

  S call<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18);

  Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> copy({
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
      Tuple18(
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
          $18 ?? this.$18);

  A get head => $1;

  Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> get init =>
      Tuple17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17);

  R get last => $18;

  Tuple17<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> get tail =>
      Tuple17($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}

class Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;
  final R $18;
  final S $19;

  const Tuple19(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17,
      this.$18,
      this.$19);

  Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> append<T>(
          T $20) =>
      Tuple20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17, $18, $19, $20);

  T call<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19);

  Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> copy({
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
      Tuple19(
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
          $19 ?? this.$19);

  A get head => $1;

  Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> get init =>
      Tuple18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17, $18);

  S get last => $19;

  Tuple18<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> get tail =>
      Tuple18($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}

class Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;
  final R $18;
  final S $19;
  final T $20;

  const Tuple20(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17,
      this.$18,
      this.$19,
      this.$20);

  Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
      append<U>(U $21) => Tuple21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,
          $12, $13, $14, $15, $16, $17, $18, $19, $20, $21);

  U call<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20);

  Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> copy({
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
      Tuple20(
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
          $20 ?? this.$20);

  A get head => $1;

  Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> get init =>
      Tuple19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
          $16, $17, $18, $19);

  T get last => $20;

  Tuple19<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> get tail =>
      Tuple19($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}

class Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;
  final R $18;
  final S $19;
  final T $20;
  final U $21;

  const Tuple21(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17,
      this.$18,
      this.$19,
      this.$20,
      this.$21);

  Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
      append<V>(V $22) => Tuple22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,
          $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);

  V call<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20, $21);

  Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> copy({
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
      Tuple21(
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
          $21 ?? this.$21);

  A get head => $1;

  Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
      get init => Tuple20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20);

  U get last => $21;

  Tuple20<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
      get tail => Tuple20($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13,
          $14, $15, $16, $17, $18, $19, $20, $21);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}

class Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    extends _TupleBase {
  final A $1;
  final B $2;
  final C $3;
  final D $4;
  final E $5;
  final F $6;
  final G $7;
  final H $8;
  final I $9;
  final J $10;
  final K $11;
  final L $12;
  final M $13;
  final N $14;
  final O $15;
  final P $16;
  final Q $17;
  final R $18;
  final S $19;
  final T $20;
  final U $21;
  final V $22;

  const Tuple22(
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
      this.$10,
      this.$11,
      this.$12,
      this.$13,
      this.$14,
      this.$15,
      this.$16,
      this.$17,
      this.$18,
      this.$19,
      this.$20,
      this.$21,
      this.$22);

  W call<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
          $17, $18, $19, $20, $21, $22);

  Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
      copy({
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
          Tuple22(
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
              $22 ?? this.$22);

  A get head => $1;

  Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
      get init => Tuple21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21);

  V get last => $22;

  Tuple21<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
      get tail => Tuple21($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13,
          $14, $15, $16, $17, $18, $19, $20, $21, $22);

  @override
  IList<dynamic> _toIList() => ilist([
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
      ]);
}
