import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/non_empty_ilist.dart';
// import 'package:ribs_core/src/tuple.dart';
import 'package:ribs_core/src/syntax/record.dart';
import 'package:ribs_core/src/validated.dart';

extension ValidatedSyntaxOps<A> on A {
  Validated<A, B> invalid<B>() => Validated.invalid(this);
  Validated<B, A> valid<B>() => Validated.valid(this);

  ValidatedNel<A, B> invalidNel<B>() =>
      Validated.invalid(NonEmptyIList.one(this));

  ValidatedNel<B, A> validNel<B>() => Validated.valid(this);
}

extension Tuple2ValidatedNelOps<EE, A, B> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>
) {
  ValidatedNel<EE, C> mapN<C>(Function2<A, B, C> fn) =>
      _tupled2($1, $2).map(fn.tupled);

  ValidatedNel<EE, (A, B)> sequence() => _tupled2($1, $2);
}

extension Tuple3ValidatedNelOps<EE, A, B, C> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>
) {
  ValidatedNel<EE, D> mapN<D>(Function3<A, B, C, D> fn) =>
      _tupled3($1, $2, $3).map(fn.tupled);

  ValidatedNel<EE, (A, B, C)> sequence() => _tupled3($1, $2, $3);
}

extension Tuple4ValidatedNelOps<EE, A, B, C, D> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>
) {
  ValidatedNel<EE, E> mapN<E>(Function4<A, B, C, D, E> fn) =>
      _tupled4($1, $2, $3, $4).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D)> sequence() => _tupled4($1, $2, $3, $4);
}

extension Tuple5ValidatedNelOps<EE, A, B, C, D, E> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>
) {
  ValidatedNel<EE, F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      _tupled5($1, $2, $3, $4, $5).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E)> sequence() => _tupled5($1, $2, $3, $4, $5);
}

extension Tuple6ValidatedNelOps<EE, A, B, C, D, E, F> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>
) {
  ValidatedNel<EE, G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      _tupled6($1, $2, $3, $4, $5, $6).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F)> sequence() =>
      _tupled6($1, $2, $3, $4, $5, $6);
}

extension Tuple7ValidatedNelOps<EE, A, B, C, D, E, F, G> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>
) {
  ValidatedNel<EE, H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      _tupled7($1, $2, $3, $4, $5, $6, $7).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G)> sequence() =>
      _tupled7($1, $2, $3, $4, $5, $6, $7);
}

extension Tuple8ValidatedNelOps<EE, A, B, C, D, E, F, G, H> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>
) {
  ValidatedNel<EE, I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H)> sequence() =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8);
}

extension Tuple9ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>
) {
  ValidatedNel<EE, J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I)> sequence() =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9);
}

extension Tuple10ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>
) {
  ValidatedNel<EE, K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J)> sequence() =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
}

extension Tuple11ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>
) {
  ValidatedNel<EE, L> mapN<L>(
          Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K)> sequence() =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
}

extension Tuple12ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>
) {
  ValidatedNel<EE, M> mapN<M>(
          Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L)> sequence() =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}

extension Tuple13ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>
) {
  ValidatedNel<EE, N> mapN<N>(
          Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)> sequence() =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
}

extension Tuple14ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>
) {
  ValidatedNel<EE, O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> sequence() =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
}

extension Tuple15ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>
) {
  ValidatedNel<EE, P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      _tupled15(
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> sequence() =>
      _tupled15(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}

extension Tuple16ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>
) {
  ValidatedNel<EE, Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
      sequence() => _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16);
}

extension Tuple17ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>
) {
  ValidatedNel<EE, R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
      sequence() => _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17);
}

extension Tuple18ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q, R> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>,
  ValidatedNel<EE, R>
) {
  ValidatedNel<EE, S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
      sequence() => _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18);
}

extension Tuple19ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q, R, S> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>,
  ValidatedNel<EE, R>,
  ValidatedNel<EE, S>
) {
  ValidatedNel<EE, T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      sequence() => _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19);
}

extension Tuple20ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q, R, S, T> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>,
  ValidatedNel<EE, R>,
  ValidatedNel<EE, S>,
  ValidatedNel<EE, T>
) {
  ValidatedNel<EE, U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20)
          .map(fn.tupled);

  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      sequence() => _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20);
}

extension Tuple21ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q, R, S, T, U> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>,
  ValidatedNel<EE, R>,
  ValidatedNel<EE, S>,
  ValidatedNel<EE, T>,
  ValidatedNel<EE, U>
) {
  ValidatedNel<EE, V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21)
          .map(fn.tupled);

  ValidatedNel<EE,
          (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      sequence() => _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21);
}

extension Tuple22ValidatedNelOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
    O, P, Q, R, S, T, U, V> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>,
  ValidatedNel<EE, H>,
  ValidatedNel<EE, I>,
  ValidatedNel<EE, J>,
  ValidatedNel<EE, K>,
  ValidatedNel<EE, L>,
  ValidatedNel<EE, M>,
  ValidatedNel<EE, N>,
  ValidatedNel<EE, O>,
  ValidatedNel<EE, P>,
  ValidatedNel<EE, Q>,
  ValidatedNel<EE, R>,
  ValidatedNel<EE, S>,
  ValidatedNel<EE, T>,
  ValidatedNel<EE, U>,
  ValidatedNel<EE, V>
) {
  ValidatedNel<EE, W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21, $22)
          .map(fn.tupled);

  ValidatedNel<EE,
          (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      sequence() => _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

ValidatedNel<EE, (A, B)> _tupled2<EE, A, B>(
  ValidatedNel<EE, A> a,
  ValidatedNel<EE, B> b,
) =>
    a.product(b);

ValidatedNel<EE, (A, B, C)> _tupled3<EE, A, B, C>(
  ValidatedNel<EE, A> a,
  ValidatedNel<EE, B> b,
  ValidatedNel<EE, C> c,
) =>
    _tupled2(a, b).product(c).map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D)> _tupled4<EE, A, B, C, D>(
  ValidatedNel<EE, A> a,
  ValidatedNel<EE, B> b,
  ValidatedNel<EE, C> c,
  ValidatedNel<EE, D> d,
) =>
    _tupled3(a, b, c).product(d).map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E)> _tupled5<EE, A, B, C, D, E>(
  ValidatedNel<EE, A> a,
  ValidatedNel<EE, B> b,
  ValidatedNel<EE, C> c,
  ValidatedNel<EE, D> d,
  ValidatedNel<EE, E> e,
) =>
    _tupled4(a, b, c, d).product(e).map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F)> _tupled6<EE, A, B, C, D, E, F>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
) =>
    _tupled5(va, vb, vc, vd, ve).product(vf).map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G)> _tupled7<EE, A, B, C, D, E, F, G>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
) =>
    _tupled6(va, vb, vc, vd, ve, vf).product(vg).map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H)> _tupled8<EE, A, B, C, D, E, F, G, H>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
) =>
    _tupled7(va, vb, vc, vd, ve, vf, vg)
        .product(vh)
        .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I)>
    _tupled9<EE, A, B, C, D, E, F, G, H, I>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
) =>
        _tupled8(va, vb, vc, vd, ve, vf, vg, vh)
            .product(vi)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J)>
    _tupled10<EE, A, B, C, D, E, F, G, H, I, J>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
) =>
        _tupled9(va, vb, vc, vd, ve, vf, vg, vh, vi)
            .product(vj)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K)>
    _tupled11<EE, A, B, C, D, E, F, G, H, I, J, K>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
) =>
        _tupled10(va, vb, vc, vd, ve, vf, vg, vh, vi, vj)
            .product(vk)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L)>
    _tupled12<EE, A, B, C, D, E, F, G, H, I, J, K, L>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
) =>
        _tupled11(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk)
            .product(vl)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)>
    _tupled13<EE, A, B, C, D, E, F, G, H, I, J, K, L, M>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
) =>
        _tupled12(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl)
            .product(vm)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
    _tupled14<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
) =>
        _tupled13(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm)
            .product(vn)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
    _tupled15<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
) =>
        _tupled14(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn)
            .product(vo)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
    _tupled16<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
) =>
        _tupled15(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo)
            .product(vp)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> _tupled17<
        EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
) =>
    _tupled16(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp)
        .product(vq)
        .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
    _tupled18<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
  ValidatedNel<EE, R> vr,
) =>
        _tupled17(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                vp, vq)
            .product(vr)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
    _tupled19<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
  ValidatedNel<EE, R> vr,
  ValidatedNel<EE, S> vs,
) =>
        _tupled18(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                vp, vq, vr)
            .product(vs)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
    _tupled20<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
  ValidatedNel<EE, R> vr,
  ValidatedNel<EE, S> vs,
  ValidatedNel<EE, T> vt,
) =>
        _tupled19(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                vp, vq, vr, vs)
            .product(vt)
            .map((t) => t.$1.append(t.$2));

ValidatedNel<EE,
    (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> _tupled21<
        EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
  ValidatedNel<EE, R> vr,
  ValidatedNel<EE, S> vs,
  ValidatedNel<EE, T> vt,
  ValidatedNel<EE, U> vu,
) =>
    _tupled20(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp,
            vq, vr, vs, vt)
        .product(vu)
        .map((t) => t.$1.append(t.$2));

ValidatedNel<EE,
        (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
    _tupled22<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
            V>(
  ValidatedNel<EE, A> va,
  ValidatedNel<EE, B> vb,
  ValidatedNel<EE, C> vc,
  ValidatedNel<EE, D> vd,
  ValidatedNel<EE, E> ve,
  ValidatedNel<EE, F> vf,
  ValidatedNel<EE, G> vg,
  ValidatedNel<EE, H> vh,
  ValidatedNel<EE, I> vi,
  ValidatedNel<EE, J> vj,
  ValidatedNel<EE, K> vk,
  ValidatedNel<EE, L> vl,
  ValidatedNel<EE, M> vm,
  ValidatedNel<EE, N> vn,
  ValidatedNel<EE, O> vo,
  ValidatedNel<EE, P> vp,
  ValidatedNel<EE, Q> vq,
  ValidatedNel<EE, R> vr,
  ValidatedNel<EE, S> vs,
  ValidatedNel<EE, T> vt,
  ValidatedNel<EE, U> vu,
  ValidatedNel<EE, V> vv,
) =>
        _tupled21(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                vp, vq, vr, vs, vt, vu)
            .product(vv)
            .map((t) => t.$1.append(t.$2));
