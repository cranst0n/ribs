import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';

extension GenTuple2Ops<A, B> on (Gen<A>, Gen<B>) {
  Gen<(A, B)> get tupled => $1
      .flatMap((a) => $2.map((b) => (a, b)))
      .withShrinker(Shrinker.tuple2($1.shrinker, $2.shrinker));
}

extension GenTuple3Ops<A, B, C> on (Gen<A>, Gen<B>, Gen<C>) {
  Gen<(A, B, C)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(Shrinker.tuple3($1.shrinker, $2.shrinker, $3.shrinker));
}

extension GenTuple4Ops<A, B, C, D> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>) {
  Gen<(A, B, C, D)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(Shrinker.tuple4($1.shrinker, $2.shrinker, $3.shrinker, $4.shrinker));
}

extension GenTuple5Ops<A, B, C, D, E> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>) {
  Gen<(A, B, C, D, E)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple5($1.shrinker, $2.shrinker, $3.shrinker, $4.shrinker, $5.shrinker),
      );
}

extension GenTuple6Ops<A, B, C, D, E, F> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>) {
  Gen<(A, B, C, D, E, F)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple6(
          $1.shrinker,
          $2.shrinker,
          $3.shrinker,
          $4.shrinker,
          $5.shrinker,
          $6.shrinker,
        ),
      );
}

extension GenTuple7Ops<A, B, C, D, E, F, G>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>) {
  Gen<(A, B, C, D, E, F, G)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple7(
          $1.shrinker,
          $2.shrinker,
          $3.shrinker,
          $4.shrinker,
          $5.shrinker,
          $6.shrinker,
          $7.shrinker,
        ),
      );
}

extension GenTuple8Ops<A, B, C, D, E, F, G, H>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>) {
  Gen<(A, B, C, D, E, F, G, H)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple8(
          $1.shrinker,
          $2.shrinker,
          $3.shrinker,
          $4.shrinker,
          $5.shrinker,
          $6.shrinker,
          $7.shrinker,
          $8.shrinker,
        ),
      );
}

extension GenTuple9Ops<A, B, C, D, E, F, G, H, I>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>) {
  Gen<(A, B, C, D, E, F, G, H, I)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple9(
          $1.shrinker,
          $2.shrinker,
          $3.shrinker,
          $4.shrinker,
          $5.shrinker,
          $6.shrinker,
          $7.shrinker,
          $8.shrinker,
          $9.shrinker,
        ),
      );
}

extension GenTuple10Ops<A, B, C, D, E, F, G, H, I, J>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>, Gen<J>) {
  Gen<(A, B, C, D, E, F, G, H, I, J)> get tupled => init.tupled
      .flatMap((t) => last.map(t.appended))
      .withShrinker(
        Shrinker.tuple10(
          $1.shrinker,
          $2.shrinker,
          $3.shrinker,
          $4.shrinker,
          $5.shrinker,
          $6.shrinker,
          $7.shrinker,
          $8.shrinker,
          $9.shrinker,
          $10.shrinker,
        ),
      );
}

extension GenTuple11Ops<A, B, C, D, E, F, G, H, I, J, K>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>, Gen<J>, Gen<K>) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple12Ops<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
          Gen<U>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}

extension GenTuple22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
          Gen<U>,
          Gen<V>,
        ) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> get tupled =>
      init.tupled.flatMap((t) => last.map(t.appended));
}
