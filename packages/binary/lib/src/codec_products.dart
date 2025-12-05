import 'package:ribs_binary/src/codec.dart';
import 'package:ribs_core/ribs_core.dart';

extension Codec2Ops<A, B> on (Codec<A>, Codec<B>) {
  Codec<C> product<C>(
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) =>
      Codec.product2($1, $2, apply, tupled);
}

extension Codec3Ops<A, B, C> on (Codec<A>, Codec<B>, Codec<C>) {
  Codec<D> product<D>(
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) =>
      Codec.product3($1, $2, $3, apply, tupled);
}

extension Codec4Ops<A, B, C, D> on (Codec<A>, Codec<B>, Codec<C>, Codec<D>) {
  Codec<E> product<E>(
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) =>
      Codec.product4($1, $2, $3, $4, apply, tupled);
}

extension Codec5Ops<A, B, C, D, E> on (Codec<A>, Codec<B>, Codec<C>, Codec<D>, Codec<E>) {
  Codec<F> product<F>(
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) =>
      Codec.product5($1, $2, $3, $4, $5, apply, tupled);
}

extension Codec6Ops<A, B, C, D, E, F> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>
) {
  Codec<G> product<G>(
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) =>
      Codec.product6($1, $2, $3, $4, $5, $6, apply, tupled);
}

extension Codec7Ops<A, B, C, D, E, F, G> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>
) {
  Codec<H> product<H>(
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) =>
      Codec.product7($1, $2, $3, $4, $5, $6, $7, apply, tupled);
}

extension Codec8Ops<A, B, C, D, E, F, G, H> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>
) {
  Codec<I> product<I>(
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) =>
      Codec.product8($1, $2, $3, $4, $5, $6, $7, $8, apply, tupled);
}

extension Codec9Ops<A, B, C, D, E, F, G, H, I> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>
) {
  Codec<J> product<J>(
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) =>
      Codec.product9($1, $2, $3, $4, $5, $6, $7, $8, $9, apply, tupled);
}

extension Codec10Ops<A, B, C, D, E, F, G, H, I, J> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
) {
  Codec<K> product<K>(
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) =>
      Codec.product10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, apply, tupled);
}

extension Codec11Ops<A, B, C, D, E, F, G, H, I, J, K> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
) {
  Codec<L> product<L>(
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) =>
      Codec.product11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, apply, tupled);
}

extension Codec12Ops<A, B, C, D, E, F, G, H, I, J, K, L> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
) {
  Codec<M> product<M>(
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) =>
      Codec.product12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, apply, tupled);
}

extension Codec13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
) {
  Codec<N> product<N>(
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) =>
      Codec.product13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, apply, tupled);
}

extension Codec14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
) {
  Codec<O> product<O>(
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) =>
      Codec.product14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, apply, tupled);
}

extension Codec15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
) {
  Codec<P> product<P>(
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) =>
      Codec.product15(
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
        apply,
        tupled,
      );
}

extension Codec16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
) {
  Codec<Q> product<Q>(
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
  ) =>
      Codec.product16(
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
        apply,
        tupled,
      );
}

extension Codec17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
) {
  Codec<R> product<R>(
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
  ) =>
      Codec.product17(
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
        apply,
        tupled,
      );
}

extension Codec18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
  Codec<R>,
) {
  Codec<S> product<S>(
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
  ) =>
      Codec.product18(
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
        apply,
        tupled,
      );
}

extension Codec19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
  Codec<R>,
  Codec<S>,
) {
  Codec<T> product<T>(
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
  ) =>
      Codec.product19(
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
        apply,
        tupled,
      );
}

extension Codec20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
  Codec<R>,
  Codec<S>,
  Codec<T>,
) {
  Codec<U> product<U>(
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
  ) =>
      Codec.product20(
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
        apply,
        tupled,
      );
}

extension Codec21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
  Codec<R>,
  Codec<S>,
  Codec<T>,
  Codec<U>,
) {
  Codec<V> product<V>(
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
  ) =>
      Codec.product21(
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
        apply,
        tupled,
      );
}

extension Codec22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> on (
  Codec<A>,
  Codec<B>,
  Codec<C>,
  Codec<D>,
  Codec<E>,
  Codec<F>,
  Codec<G>,
  Codec<H>,
  Codec<I>,
  Codec<J>,
  Codec<K>,
  Codec<L>,
  Codec<M>,
  Codec<N>,
  Codec<O>,
  Codec<P>,
  Codec<Q>,
  Codec<R>,
  Codec<S>,
  Codec<T>,
  Codec<U>,
  Codec<V>,
) {
  Codec<W> product<W>(
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
  ) =>
      Codec.product22(
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
        apply,
        tupled,
      );
}
