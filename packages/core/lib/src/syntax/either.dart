import 'package:ribs_core/src/either.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/syntax/record.dart';

extension EitherSyntaxOps<A> on A {
  Either<A, B> asLeft<B>() => Either.left(this);
  Either<B, A> asRight<B>() => Either.right(this);
}

extension Tuple2EitherOps<EE, A, B> on (Either<EE, A>, Either<EE, B>) {
  Either<EE, C> mapN<C>(Function2<A, B, C> fn) =>
      _tupled2($1, $2).map(fn.tupled);

  Either<EE, (A, B)> sequence() => _tupled2($1, $2);
}

extension Tuple3EitherOps<EE, A, B, C> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>
) {
  Either<EE, D> mapN<D>(Function3<A, B, C, D> fn) =>
      _tupled3($1, $2, $3).map(fn.tupled);

  Either<EE, (A, B, C)> sequence() => _tupled3($1, $2, $3);
}

extension Tuple4EitherOps<EE, A, B, C, D> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>
) {
  Either<EE, E> mapN<E>(Function4<A, B, C, D, E> fn) =>
      _tupled4($1, $2, $3, $4).map(fn.tupled);

  Either<EE, (A, B, C, D)> sequence() => _tupled4($1, $2, $3, $4);
}

extension Tuple5EitherOps<EE, A, B, C, D, E> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>
) {
  Either<EE, F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      _tupled5($1, $2, $3, $4, $5).map(fn.tupled);

  Either<EE, (A, B, C, D, E)> sequence() => _tupled5($1, $2, $3, $4, $5);
}

extension Tuple6EitherOps<EE, A, B, C, D, E, F> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>
) {
  Either<EE, G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      _tupled6($1, $2, $3, $4, $5, $6).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F)> sequence() => _tupled6($1, $2, $3, $4, $5, $6);
}

extension Tuple7EitherOps<EE, A, B, C, D, E, F, G> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>
) {
  Either<EE, H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      _tupled7($1, $2, $3, $4, $5, $6, $7).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G)> sequence() =>
      _tupled7($1, $2, $3, $4, $5, $6, $7);
}

extension Tuple8EitherOps<EE, A, B, C, D, E, F, G, H> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>
) {
  Either<EE, I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H)> sequence() =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8);
}

extension Tuple9EitherOps<EE, A, B, C, D, E, F, G, H, I> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>
) {
  Either<EE, J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I)> sequence() =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9);
}

extension Tuple10EitherOps<EE, A, B, C, D, E, F, G, H, I, J> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>
) {
  Either<EE, K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J)> sequence() =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
}

extension Tuple11EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>
) {
  Either<EE, L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K)> sequence() =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
}

extension Tuple12EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>
) {
  Either<EE, M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L)> sequence() =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}

extension Tuple13EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>
) {
  Either<EE, N> mapN<N>(
          Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)> sequence() =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
}

extension Tuple14EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>
) {
  Either<EE, O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> sequence() =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
}

extension Tuple15EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>
) {
  Either<EE, P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      _tupled15(
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> sequence() =>
      _tupled15(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}

extension Tuple16EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>
) {
  Either<EE, Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> sequence() =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16);
}

extension Tuple17EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>
) {
  Either<EE, R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> sequence() =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16, $17);
}

extension Tuple18EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q, R> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>,
  Either<EE, R>
) {
  Either<EE, S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
      sequence() => _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18);
}

extension Tuple19EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q, R, S> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>,
  Either<EE, R>,
  Either<EE, S>
) {
  Either<EE, T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      sequence() => _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19);
}

extension Tuple20EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q, R, S, T> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>,
  Either<EE, R>,
  Either<EE, S>,
  Either<EE, T>
) {
  Either<EE, U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      sequence() => _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20);
}

extension Tuple21EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q, R, S, T, U> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>,
  Either<EE, R>,
  Either<EE, S>,
  Either<EE, T>,
  Either<EE, U>
) {
  Either<EE, V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      sequence() => _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21);
}

extension Tuple22EitherOps<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,
    Q, R, S, T, U, V> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>,
  Either<EE, H>,
  Either<EE, I>,
  Either<EE, J>,
  Either<EE, K>,
  Either<EE, L>,
  Either<EE, M>,
  Either<EE, N>,
  Either<EE, O>,
  Either<EE, P>,
  Either<EE, Q>,
  Either<EE, R>,
  Either<EE, S>,
  Either<EE, T>,
  Either<EE, U>,
  Either<EE, V>
) {
  Either<EE, W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21, $22)
          .map(fn.tupled);

  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      sequence() => _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

Either<EE, (A, B)> _tupled2<EE, A, B>(
  Either<EE, A> a,
  Either<EE, B> b,
) =>
    a.flatMap((a) => b.map((b) => (a, b)));

Either<EE, (A, B, C)> _tupled3<EE, A, B, C>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
) =>
    _tupled2(a, b).flatMap((t) => c.map(t.append));

Either<EE, (A, B, C, D)> _tupled4<EE, A, B, C, D>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
) =>
    _tupled3(a, b, c).flatMap((t) => d.map(t.append));

Either<EE, (A, B, C, D, E)> _tupled5<EE, A, B, C, D, E>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
) =>
    _tupled4(a, b, c, d).flatMap((t) => e.map(t.append));

Either<EE, (A, B, C, D, E, F)> _tupled6<EE, A, B, C, D, E, F>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
) =>
    _tupled5(a, b, c, d, e).flatMap((t) => f.map(t.append));

Either<EE, (A, B, C, D, E, F, G)> _tupled7<EE, A, B, C, D, E, F, G>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
) =>
    _tupled6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H)> _tupled8<EE, A, B, C, D, E, F, G, H>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
) =>
    _tupled7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I)> _tupled9<EE, A, B, C, D, E, F, G, H, I>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
) =>
    _tupled8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J)>
    _tupled10<EE, A, B, C, D, E, F, G, H, I, J>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
) =>
        _tupled9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K)>
    _tupled11<EE, A, B, C, D, E, F, G, H, I, J, K>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
) =>
        _tupled10(a, b, c, d, e, f, g, h, i, j).flatMap((t) => k.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L)> _tupled12<EE, A, B, C, D, E, F,
        G, H, I, J, K, L>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
) =>
    _tupled11(a, b, c, d, e, f, g, h, i, j, k).flatMap((t) => l.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)>
    _tupled13<EE, A, B, C, D, E, F, G, H, I, J, K, L, M>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
) =>
        _tupled12(a, b, c, d, e, f, g, h, i, j, k, l)
            .flatMap((t) => m.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
    _tupled14<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
) =>
        _tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
            .flatMap((t) => n.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
    _tupled15<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
) =>
        _tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
            .flatMap((t) => o.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
    _tupled16<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
) =>
        _tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
            .flatMap((t) => p.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
    _tupled17<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
) =>
        _tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
            .flatMap((t) => q.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
    _tupled18<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
  Either<EE, R> r,
) =>
        _tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
            .flatMap((t) => r.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
    _tupled19<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
  Either<EE, R> r,
  Either<EE, S> s,
) =>
        _tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
            .flatMap((t) => s.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
    _tupled20<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
  Either<EE, R> r,
  Either<EE, S> s,
  Either<EE, T> t,
) =>
        _tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
            .flatMap((tup) => t.map(tup.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
    _tupled21<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
            U>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
  Either<EE, R> r,
  Either<EE, S> s,
  Either<EE, T> t,
  Either<EE, U> u,
) =>
        _tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
            .flatMap((t) => u.map(t.append));

Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
    _tupled22<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
            V>(
  Either<EE, A> a,
  Either<EE, B> b,
  Either<EE, C> c,
  Either<EE, D> d,
  Either<EE, E> e,
  Either<EE, F> f,
  Either<EE, G> g,
  Either<EE, H> h,
  Either<EE, I> i,
  Either<EE, J> j,
  Either<EE, K> k,
  Either<EE, L> l,
  Either<EE, M> m,
  Either<EE, N> n,
  Either<EE, O> o,
  Either<EE, P> p,
  Either<EE, Q> q,
  Either<EE, R> r,
  Either<EE, S> s,
  Either<EE, T> t,
  Either<EE, U> u,
  Either<EE, V> v,
) =>
        _tupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
            .flatMap((t) => v.map(t.append));
