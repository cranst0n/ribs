import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/tuple.dart';

extension Tuple2IOOps<A, B> on Tuple2<IO<A>, IO<B>> {
  IO<C> mapN<C>(Function2<A, B, C> fn) => _tupled2($1, $2).map(fn.tupled);
  IO<C> parMapN<C>(Function2<A, B, C> fn) => _parTupled2($1, $2).map(fn.tupled);

  IO<Tuple2<A, B>> sequence() => _tupled2($1, $2);
  IO<Tuple2<A, B>> parSequence() => _parTupled2($1, $2);
}

extension Tuple3IOOps<A, B, C> on Tuple3<IO<A>, IO<B>, IO<C>> {
  IO<D> mapN<D>(Function3<A, B, C, D> fn) =>
      _tupled3($1, $2, $3).map(fn.tupled);
  IO<D> parMapN<D>(Function3<A, B, C, D> fn) =>
      _parTupled3($1, $2, $3).map(fn.tupled);

  IO<Tuple3<A, B, C>> sequence() => _tupled3($1, $2, $3);
  IO<Tuple3<A, B, C>> parSequence() => _parTupled3($1, $2, $3);
}

extension Tuple4IOOps<A, B, C, D> on Tuple4<IO<A>, IO<B>, IO<C>, IO<D>> {
  IO<E> mapN<E>(Function4<A, B, C, D, E> fn) =>
      _tupled4($1, $2, $3, $4).map(fn.tupled);
  IO<E> parMapN<E>(Function4<A, B, C, D, E> fn) =>
      _parTupled4($1, $2, $3, $4).map(fn.tupled);

  IO<Tuple4<A, B, C, D>> sequence() => _tupled4($1, $2, $3, $4);
  IO<Tuple4<A, B, C, D>> parSequence() => _parTupled4($1, $2, $3, $4);
}

extension Tuple5IOOps<A, B, C, D, E>
    on Tuple5<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>> {
  IO<F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      _tupled5($1, $2, $3, $4, $5).map(fn.tupled);
  IO<F> parMapN<F>(Function5<A, B, C, D, E, F> fn) =>
      _parTupled5($1, $2, $3, $4, $5).map(fn.tupled);

  IO<Tuple5<A, B, C, D, E>> sequence() => _tupled5($1, $2, $3, $4, $5);
  IO<Tuple5<A, B, C, D, E>> parSequence() => _parTupled5($1, $2, $3, $4, $5);
}

extension Tuple6IOOps<A, B, C, D, E, F>
    on Tuple6<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>> {
  IO<G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      _tupled6($1, $2, $3, $4, $5, $6).map(fn.tupled);
  IO<G> parMapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      _parTupled6($1, $2, $3, $4, $5, $6).map(fn.tupled);

  IO<Tuple6<A, B, C, D, E, F>> sequence() => _tupled6($1, $2, $3, $4, $5, $6);
  IO<Tuple6<A, B, C, D, E, F>> parSequence() =>
      _parTupled6($1, $2, $3, $4, $5, $6);
}

extension Tuple7IOOps<A, B, C, D, E, F, G>
    on Tuple7<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>> {
  IO<H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      _tupled7($1, $2, $3, $4, $5, $6, $7).map(fn.tupled);
  IO<H> parMapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      _parTupled7($1, $2, $3, $4, $5, $6, $7).map(fn.tupled);

  IO<Tuple7<A, B, C, D, E, F, G>> sequence() =>
      _tupled7($1, $2, $3, $4, $5, $6, $7);
  IO<Tuple7<A, B, C, D, E, F, G>> parSequence() =>
      _parTupled7($1, $2, $3, $4, $5, $6, $7);
}

extension Tuple8IOOps<A, B, C, D, E, F, G, H>
    on Tuple8<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>> {
  IO<I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8).map(fn.tupled);
  IO<I> parMapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      _parTupled8($1, $2, $3, $4, $5, $6, $7, $8).map(fn.tupled);

  IO<Tuple8<A, B, C, D, E, F, G, H>> sequence() =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8);
  IO<Tuple8<A, B, C, D, E, F, G, H>> parSequence() =>
      _parTupled8($1, $2, $3, $4, $5, $6, $7, $8);
}

extension Tuple9IOOps<A, B, C, D, E, F, G, H, I>
    on Tuple9<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>> {
  IO<J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9).map(fn.tupled);
  IO<J> parMapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      _parTupled9($1, $2, $3, $4, $5, $6, $7, $8, $9).map(fn.tupled);

  IO<Tuple9<A, B, C, D, E, F, G, H, I>> sequence() =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9);
  IO<Tuple9<A, B, C, D, E, F, G, H, I>> parSequence() =>
      _parTupled9($1, $2, $3, $4, $5, $6, $7, $8, $9);
}

extension Tuple10IOOps<A, B, C, D, E, F, G, H, I, J> on Tuple10<IO<A>, IO<B>,
    IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>, IO<J>> {
  IO<K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).map(fn.tupled);
  IO<K> parMapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      _parTupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).map(fn.tupled);

  IO<Tuple10<A, B, C, D, E, F, G, H, I, J>> sequence() =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
  IO<Tuple10<A, B, C, D, E, F, G, H, I, J>> parSequence() =>
      _parTupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
}

extension Tuple11IOOps<A, B, C, D, E, F, G, H, I, J, K> on Tuple11<IO<A>, IO<B>,
    IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>, IO<J>, IO<K>> {
  IO<L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).map(fn.tupled);
  IO<L> parMapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      _parTupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).map(fn.tupled);

  IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>> sequence() =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
  IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>> parSequence() =>
      _parTupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
}

extension Tuple12IOOps<A, B, C, D, E, F, G, H, I, J, K, L> on Tuple12<
    IO<A>,
    IO<B>,
    IO<C>,
    IO<D>,
    IO<E>,
    IO<F>,
    IO<G>,
    IO<H>,
    IO<I>,
    IO<J>,
    IO<K>,
    IO<L>> {
  IO<M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          .map(fn.tupled);
  IO<M> parMapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      _parTupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          .map(fn.tupled);

  IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> sequence() =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
  IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> parSequence() =>
      _parTupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}

extension Tuple13IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M> on Tuple13<
    IO<A>,
    IO<B>,
    IO<C>,
    IO<D>,
    IO<E>,
    IO<F>,
    IO<G>,
    IO<H>,
    IO<I>,
    IO<J>,
    IO<K>,
    IO<L>,
    IO<M>> {
  IO<N> mapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
          .map(fn.tupled);
  IO<N> parMapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      _parTupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
          .map(fn.tupled);

  IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>> sequence() =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
  IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>> parSequence() =>
      _parTupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
}

extension Tuple14IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on Tuple14<
    IO<A>,
    IO<B>,
    IO<C>,
    IO<D>,
    IO<E>,
    IO<F>,
    IO<G>,
    IO<H>,
    IO<I>,
    IO<J>,
    IO<K>,
    IO<L>,
    IO<M>,
    IO<N>> {
  IO<O> mapN<O>(Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
          .map(fn.tupled);
  IO<O> parMapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      _parTupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
          .map(fn.tupled);

  IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>> sequence() =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
  IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>> parSequence() =>
      _parTupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
}

extension Tuple15IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on Tuple15<
    IO<A>,
    IO<B>,
    IO<C>,
    IO<D>,
    IO<E>,
    IO<F>,
    IO<G>,
    IO<H>,
    IO<I>,
    IO<J>,
    IO<K>,
    IO<L>,
    IO<M>,
    IO<N>,
    IO<O>> {
  IO<P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      _tupled15(
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
          .map(fn.tupled);
  IO<P> parMapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      _parTupled15(
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
          .map(fn.tupled);

  IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>> sequence() =>
      _tupled15(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
  IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>> parSequence() =>
      _parTupled15(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}

extension Tuple16IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on Tuple16<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>,
        IO<J>, IO<K>, IO<L>, IO<M>, IO<N>, IO<O>, IO<P>> {
  IO<Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16)
          .map(fn.tupled);
  IO<Q> parMapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      _parTupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16)
          .map(fn.tupled);

  IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>> sequence() =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16);
  IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>> parSequence() =>
      _parTupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16);
}

extension Tuple17IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on Tuple17<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>,
        IO<J>, IO<K>, IO<L>, IO<M>, IO<N>, IO<O>, IO<P>, IO<Q>> {
  IO<R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17)
          .map(fn.tupled);
  IO<R> parMapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      _parTupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17)
          .map(fn.tupled);

  IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>> sequence() =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16, $17);
  IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
      parSequence() => _parTupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17);
}

extension Tuple18IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on Tuple18<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>,
        IO<J>, IO<K>, IO<L>, IO<M>, IO<N>, IO<O>, IO<P>, IO<Q>, IO<R>> {
  IO<S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18)
          .map(fn.tupled);
  IO<S> parMapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      _parTupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18)
          .map(fn.tupled);

  IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      sequence() => _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18);
  IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      parSequence() => _parTupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17, $18);
}

extension Tuple19IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on Tuple19<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>, IO<F>, IO<G>, IO<H>, IO<I>,
        IO<J>, IO<K>, IO<L>, IO<M>, IO<N>, IO<O>, IO<P>, IO<Q>, IO<R>, IO<S>> {
  IO<T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19)
          .map(fn.tupled);
  IO<T> parMapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      _parTupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19)
          .map(fn.tupled);

  IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      sequence() => _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19);
  IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      parSequence() => _parTupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17, $18, $19);
}

extension Tuple20IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T>
    on Tuple20<
        IO<A>,
        IO<B>,
        IO<C>,
        IO<D>,
        IO<E>,
        IO<F>,
        IO<G>,
        IO<H>,
        IO<I>,
        IO<J>,
        IO<K>,
        IO<L>,
        IO<M>,
        IO<N>,
        IO<O>,
        IO<P>,
        IO<Q>,
        IO<R>,
        IO<S>,
        IO<T>> {
  IO<U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20)
          .map(fn.tupled);
  IO<U> parMapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      _parTupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20)
          .map(fn.tupled);

  IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      sequence() => _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20);
  IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      parSequence() => _parTupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);
}

extension Tuple21IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T, U>
    on Tuple21<
        IO<A>,
        IO<B>,
        IO<C>,
        IO<D>,
        IO<E>,
        IO<F>,
        IO<G>,
        IO<H>,
        IO<I>,
        IO<J>,
        IO<K>,
        IO<L>,
        IO<M>,
        IO<N>,
        IO<O>,
        IO<P>,
        IO<Q>,
        IO<R>,
        IO<S>,
        IO<T>,
        IO<U>> {
  IO<V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21)
          .map(fn.tupled);
  IO<V> parMapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      _parTupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21)
          .map(fn.tupled);

  IO<Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>>
      sequence() => _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21);
  IO<Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>>
      parSequence() => _parTupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21);
}

extension Tuple22IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T, U, V>
    on Tuple22<
        IO<A>,
        IO<B>,
        IO<C>,
        IO<D>,
        IO<E>,
        IO<F>,
        IO<G>,
        IO<H>,
        IO<I>,
        IO<J>,
        IO<K>,
        IO<L>,
        IO<M>,
        IO<N>,
        IO<O>,
        IO<P>,
        IO<Q>,
        IO<R>,
        IO<S>,
        IO<T>,
        IO<U>,
        IO<V>> {
  IO<W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21, $22)
          .map(fn.tupled);
  IO<W> parMapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      _parTupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21, $22)
          .map(fn.tupled);

  IO<Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>>
      sequence() => _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);
  IO<Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>>
      parSequence() => _parTupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
          $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

IO<Tuple2<A, B>> _tupled2<A, B>(IO<A> a, IO<B> b) =>
    a.flatMap((a) => b.map((b) => Tuple2(a, b)));

IO<Tuple3<A, B, C>> _tupled3<A, B, C>(IO<A> a, IO<B> b, IO<C> c) =>
    _tupled2(a, b).flatMap((t) => c.map(t.append));

IO<Tuple4<A, B, C, D>> _tupled4<A, B, C, D>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
) =>
    _tupled3(a, b, c).flatMap((t) => d.map(t.append));

IO<Tuple5<A, B, C, D, E>> _tupled5<A, B, C, D, E>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
) =>
    _tupled4(a, b, c, d).flatMap((t) => e.map(t.append));

IO<Tuple6<A, B, C, D, E, F>> _tupled6<A, B, C, D, E, F>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
) =>
    _tupled5(a, b, c, d, e).flatMap((t) => f.map(t.append));

IO<Tuple7<A, B, C, D, E, F, G>> _tupled7<A, B, C, D, E, F, G>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
) =>
    _tupled6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

IO<Tuple8<A, B, C, D, E, F, G, H>> _tupled8<A, B, C, D, E, F, G, H>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
) =>
    _tupled7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

IO<Tuple9<A, B, C, D, E, F, G, H, I>> _tupled9<A, B, C, D, E, F, G, H, I>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
) =>
    _tupled8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

IO<Tuple10<A, B, C, D, E, F, G, H, I, J>>
    _tupled10<A, B, C, D, E, F, G, H, I, J>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
) =>
        _tupled9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
    _tupled11<A, B, C, D, E, F, G, H, I, J, K>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
) =>
        _tupled10(a, b, c, d, e, f, g, h, i, j).flatMap((t) => k.map(t.append));

IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> _tupled12<A, B, C, D, E, F, G,
        H, I, J, K, L>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
) =>
    _tupled11(a, b, c, d, e, f, g, h, i, j, k).flatMap((t) => l.map(t.append));

IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
    _tupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
) =>
        _tupled12(a, b, c, d, e, f, g, h, i, j, k, l)
            .flatMap((t) => m.map(t.append));

IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
    _tupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
) =>
        _tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
            .flatMap((t) => n.map(t.append));

IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
    _tupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
) =>
        _tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
            .flatMap((t) => o.map(t.append));

IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
    _tupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
) =>
        _tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
            .flatMap((t) => p.map(t.append));

IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
    _tupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
) =>
        _tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
            .flatMap((t) => q.map(t.append));

IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
    _tupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
) =>
        _tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
            .flatMap((t) => r.map(t.append));

IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
    _tupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
) =>
        _tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
            .flatMap((t) => s.map(t.append));

IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
    _tupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
) =>
        _tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
            .flatMap((tup) => t.map(tup.append));

IO<Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>>
    _tupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
  IO<U> u,
) =>
        _tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
            .flatMap((tup) => u.map(tup.append));

IO<Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>>
    _tupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
  IO<U> u,
  IO<V> v,
) =>
        _tupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
            .flatMap((tup) => v.map(tup.append));

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

IO<Tuple2<A, B>> _parTupled2<A, B>(IO<A> a, IO<B> b) => IO.both(a, b);

IO<Tuple3<A, B, C>> _parTupled3<A, B, C>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
) =>
    IO.both(_parTupled2(a, b), c).map((t) => t.$1.append(t.$2));

IO<Tuple4<A, B, C, D>> _parTupled4<A, B, C, D>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
) =>
    IO.both(_parTupled3(a, b, c), d).map((t) => t.$1.append(t.$2));

IO<Tuple5<A, B, C, D, E>> _parTupled5<A, B, C, D, E>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
) =>
    IO.both(_parTupled4(a, b, c, d), e).map((t) => t.$1.append(t.$2));

IO<Tuple6<A, B, C, D, E, F>> _parTupled6<A, B, C, D, E, F>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
) =>
    IO.both(_parTupled5(a, b, c, d, e), f).map((t) => t.$1.append(t.$2));

IO<Tuple7<A, B, C, D, E, F, G>> _parTupled7<A, B, C, D, E, F, G>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
) =>
    IO.both(_parTupled6(a, b, c, d, e, f), g).map((t) => t.$1.append(t.$2));

IO<Tuple8<A, B, C, D, E, F, G, H>> _parTupled8<A, B, C, D, E, F, G, H>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
) =>
    IO.both(_parTupled7(a, b, c, d, e, f, g), h).map((t) => t.$1.append(t.$2));

IO<Tuple9<A, B, C, D, E, F, G, H, I>> _parTupled9<A, B, C, D, E, F, G, H, I>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
) =>
    IO
        .both(_parTupled8(a, b, c, d, e, f, g, h), i)
        .map((t) => t.$1.append(t.$2));

IO<Tuple10<A, B, C, D, E, F, G, H, I, J>>
    _parTupled10<A, B, C, D, E, F, G, H, I, J>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
) =>
        IO
            .both(_parTupled9(a, b, c, d, e, f, g, h, i), j)
            .map((t) => t.$1.append(t.$2));

IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
    _parTupled11<A, B, C, D, E, F, G, H, I, J, K>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
) =>
        IO
            .both(_parTupled10(a, b, c, d, e, f, g, h, i, j), k)
            .map((t) => t.$1.append(t.$2));

IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
    _parTupled12<A, B, C, D, E, F, G, H, I, J, K, L>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
) =>
        IO
            .both(_parTupled11(a, b, c, d, e, f, g, h, i, j, k), l)
            .map((t) => t.$1.append(t.$2));

IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
    _parTupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
) =>
        IO
            .both(_parTupled12(a, b, c, d, e, f, g, h, i, j, k, l), m)
            .map((t) => t.$1.append(t.$2));

IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
    _parTupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
) =>
        IO
            .both(_parTupled13(a, b, c, d, e, f, g, h, i, j, k, l, m), n)
            .map((t) => t.$1.append(t.$2));

IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
    _parTupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
) =>
        IO
            .both(_parTupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n), o)
            .map((t) => t.$1.append(t.$2));

IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
    _parTupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
) =>
        IO
            .both(_parTupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o), p)
            .map((t) => t.$1.append(t.$2));

IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
    _parTupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
) =>
        IO
            .both(
                _parTupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p), q)
            .map((t) => t.$1.append(t.$2));

IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
    _parTupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
) =>
        IO
            .both(
                _parTupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q),
                r)
            .map((t) => t.$1.append(t.$2));

IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
    _parTupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
) =>
        IO
            .both(
                _parTupled18(
                    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r),
                s)
            .map((t) => t.$1.append(t.$2));

IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
    _parTupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
) =>
        IO
            .both(
                _parTupled19(
                    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s),
                t)
            .map((t) => t.$1.append(t.$2));

IO<Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>>
    _parTupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
  IO<U> u,
) =>
        IO
            .both(
                _parTupled20(
                    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t),
                u)
            .map((t) => t.$1.append(t.$2));

IO<Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>>
    _parTupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
            V>(
  IO<A> a,
  IO<B> b,
  IO<C> c,
  IO<D> d,
  IO<E> e,
  IO<F> f,
  IO<G> g,
  IO<H> h,
  IO<I> i,
  IO<J> j,
  IO<K> k,
  IO<L> l,
  IO<M> m,
  IO<N> n,
  IO<O> o,
  IO<P> p,
  IO<Q> q,
  IO<R> r,
  IO<S> s,
  IO<T> t,
  IO<U> u,
  IO<V> v,
) =>
        IO
            .both(
                _parTupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,
                    r, s, t, u),
                v)
            .map((t) => t.$1.append(t.$2));
