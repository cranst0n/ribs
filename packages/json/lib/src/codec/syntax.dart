import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

extension<A> on (String, Codec<A>) {
  KeyValueCodec<A> get kv => KeyValueCodec($1, $2);
}

extension Codec2KVOps<A, B> on (KeyValueCodec<A>, KeyValueCodec<B>) {
  Codec<C> product<C>(
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) => Codec.product2($1, $2, apply, tupled);
}

extension Codec2Ops<A, B> on ((String, Codec<A>), (String, Codec<B>)) {
  Codec<C> product<C>(
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) => ($1.kv, $2.kv).product(apply, tupled);
}

extension Codec3KVOps<A, B, C> on (KeyValueCodec<A>, KeyValueCodec<B>, KeyValueCodec<C>) {
  Codec<D> product<D>(
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) => Codec.product3($1, $2, $3, apply, tupled);
}

extension Codec3Ops<A, B, C> on ((String, Codec<A>), (String, Codec<B>), (String, Codec<C>)) {
  Codec<D> product<D>(
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) => ($1.kv, $2.kv, $3.kv).product(apply, tupled);
}

extension Codec4KVOps<A, B, C, D>
    on (KeyValueCodec<A>, KeyValueCodec<B>, KeyValueCodec<C>, KeyValueCodec<D>) {
  Codec<E> product<E>(
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) => Codec.product4($1, $2, $3, $4, apply, tupled);
}

extension Codec4Ops<A, B, C, D>
    on ((String, Codec<A>), (String, Codec<B>), (String, Codec<C>), (String, Codec<D>)) {
  Codec<E> product<E>(
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv).product(apply, tupled);
}

extension Codec5KVOps<A, B, C, D, E>
    on (KeyValueCodec<A>, KeyValueCodec<B>, KeyValueCodec<C>, KeyValueCodec<D>, KeyValueCodec<E>) {
  Codec<F> product<F>(
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) => Codec.product5($1, $2, $3, $4, $5, apply, tupled);
}

extension Codec5Ops<A, B, C, D, E>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
        ) {
  Codec<F> product<F>(
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv, $5.kv).product(apply, tupled);
}

extension Codec6KVOps<A, B, C, D, E, F>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
        ) {
  Codec<G> product<G>(
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) => Codec.product6($1, $2, $3, $4, $5, $6, apply, tupled);
}

extension Codec6Ops<A, B, C, D, E, F>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
        ) {
  Codec<G> product<G>(
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv, $5.kv, $6.kv).product(apply, tupled);
}

extension Codec7KVOps<A, B, C, D, E, F, G>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
        ) {
  Codec<H> product<H>(
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) => Codec.product7($1, $2, $3, $4, $5, $6, $7, apply, tupled);
}

extension Codec7Ops<A, B, C, D, E, F, G>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
        ) {
  Codec<H> product<H>(
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv, $5.kv, $6.kv, $7.kv).product(apply, tupled);
}

extension Codec8KVOps<A, B, C, D, E, F, G, H>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
        ) {
  Codec<I> product<I>(
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) => Codec.product8($1, $2, $3, $4, $5, $6, $7, $8, apply, tupled);
}

extension Codec8Ops<A, B, C, D, E, F, G, H>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
        ) {
  Codec<I> product<I>(
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv, $5.kv, $6.kv, $7.kv, $8.kv).product(apply, tupled);
}

extension Codec9KVOps<A, B, C, D, E, F, G, H, I>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
        ) {
  Codec<J> product<J>(
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) => Codec.product9($1, $2, $3, $4, $5, $6, $7, $8, $9, apply, tupled);
}

extension Codec9Ops<A, B, C, D, E, F, G, H, I>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
        ) {
  Codec<J> product<J>(
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) => ($1.kv, $2.kv, $3.kv, $4.kv, $5.kv, $6.kv, $7.kv, $8.kv, $9.kv).product(apply, tupled);
}

extension Codec10KVOps<A, B, C, D, E, F, G, H, I, J>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
        ) {
  Codec<K> product<K>(
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) => Codec.product10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, apply, tupled);
}

extension Codec10Ops<A, B, C, D, E, F, G, H, I, J>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
        ) {
  Codec<K> product<K>(
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
  ).product(apply, tupled);
}

extension Codec11KVOps<A, B, C, D, E, F, G, H, I, J, K>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
        ) {
  Codec<L> product<L>(
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) => Codec.product11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, apply, tupled);
}

extension Codec11Ops<A, B, C, D, E, F, G, H, I, J, K>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
        ) {
  Codec<L> product<L>(
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
  ).product(apply, tupled);
}

extension Codec12KVOps<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
        ) {
  Codec<M> product<M>(
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) => Codec.product12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, apply, tupled);
}

extension Codec12Ops<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
        ) {
  Codec<M> product<M>(
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
  ).product(apply, tupled);
}

extension Codec13KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
        ) {
  Codec<N> product<N>(
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) => Codec.product13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, apply, tupled);
}

extension Codec13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
        ) {
  Codec<N> product<N>(
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
  ).product(apply, tupled);
}

extension Codec14KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
        ) {
  Codec<O> product<O>(
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) => Codec.product14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, apply, tupled);
}

extension Codec14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
        ) {
  Codec<O> product<O>(
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
  ).product(apply, tupled);
}

extension Codec15KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
        ) {
  Codec<P> product<P>(
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) => Codec.product15(
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

extension Codec15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
        ) {
  Codec<P> product<P>(
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
  ).product(apply, tupled);
}

extension Codec16KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
        ) {
  Codec<Q> product<Q>(
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
  ) => Codec.product16(
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

extension Codec16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
        ) {
  Codec<Q> product<Q>(
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
  ).product(apply, tupled);
}

extension Codec17KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
        ) {
  Codec<R> product<R>(
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
  ) => Codec.product17(
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

extension Codec17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
        ) {
  Codec<R> product<R>(
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
  ).product(apply, tupled);
}

extension Codec18KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
          KeyValueCodec<R>,
        ) {
  Codec<S> product<S>(
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
  ) => Codec.product18(
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

extension Codec18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
          (String, Codec<R>),
        ) {
  Codec<S> product<S>(
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
    $18.kv,
  ).product(apply, tupled);
}

extension Codec19KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
          KeyValueCodec<R>,
          KeyValueCodec<S>,
        ) {
  Codec<T> product<T>(
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
  ) => Codec.product19(
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

extension Codec19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
          (String, Codec<R>),
          (String, Codec<S>),
        ) {
  Codec<T> product<T>(
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
    $18.kv,
    $19.kv,
  ).product(apply, tupled);
}

extension Codec20KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
          KeyValueCodec<R>,
          KeyValueCodec<S>,
          KeyValueCodec<T>,
        ) {
  Codec<U> product<U>(
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
  ) => Codec.product20(
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

extension Codec20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
          (String, Codec<R>),
          (String, Codec<S>),
          (String, Codec<T>),
        ) {
  Codec<U> product<U>(
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
    $18.kv,
    $19.kv,
    $20.kv,
  ).product(apply, tupled);
}

extension Codec21KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
          KeyValueCodec<R>,
          KeyValueCodec<S>,
          KeyValueCodec<T>,
          KeyValueCodec<U>,
        ) {
  Codec<V> product<V>(
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
  ) => Codec.product21(
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

extension Codec21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
          (String, Codec<R>),
          (String, Codec<S>),
          (String, Codec<T>),
          (String, Codec<U>),
        ) {
  Codec<V> product<V>(
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
    $18.kv,
    $19.kv,
    $20.kv,
    $21.kv,
  ).product(apply, tupled);
}

extension Codec22KVOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    on
        (
          KeyValueCodec<A>,
          KeyValueCodec<B>,
          KeyValueCodec<C>,
          KeyValueCodec<D>,
          KeyValueCodec<E>,
          KeyValueCodec<F>,
          KeyValueCodec<G>,
          KeyValueCodec<H>,
          KeyValueCodec<I>,
          KeyValueCodec<J>,
          KeyValueCodec<K>,
          KeyValueCodec<L>,
          KeyValueCodec<M>,
          KeyValueCodec<N>,
          KeyValueCodec<O>,
          KeyValueCodec<P>,
          KeyValueCodec<Q>,
          KeyValueCodec<R>,
          KeyValueCodec<S>,
          KeyValueCodec<T>,
          KeyValueCodec<U>,
          KeyValueCodec<V>,
        ) {
  Codec<W> product<W>(
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
  ) => Codec.product22(
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

extension Codec22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    on
        (
          (String, Codec<A>),
          (String, Codec<B>),
          (String, Codec<C>),
          (String, Codec<D>),
          (String, Codec<E>),
          (String, Codec<F>),
          (String, Codec<G>),
          (String, Codec<H>),
          (String, Codec<I>),
          (String, Codec<J>),
          (String, Codec<K>),
          (String, Codec<L>),
          (String, Codec<M>),
          (String, Codec<N>),
          (String, Codec<O>),
          (String, Codec<P>),
          (String, Codec<Q>),
          (String, Codec<R>),
          (String, Codec<S>),
          (String, Codec<T>),
          (String, Codec<U>),
          (String, Codec<V>),
        ) {
  Codec<W> product<W>(
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
  ) => (
    $1.kv,
    $2.kv,
    $3.kv,
    $4.kv,
    $5.kv,
    $6.kv,
    $7.kv,
    $8.kv,
    $9.kv,
    $10.kv,
    $11.kv,
    $12.kv,
    $13.kv,
    $14.kv,
    $15.kv,
    $16.kv,
    $17.kv,
    $18.kv,
    $19.kv,
    $20.kv,
    $21.kv,
    $22.kv,
  ).product(apply, tupled);
}
