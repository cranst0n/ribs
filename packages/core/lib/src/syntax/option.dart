import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/option.dart';
import 'package:ribs_core/src/syntax/record.dart';

extension OptionSyntaxOps<A> on A {
  Option<A> get some => Some(this);
}

extension Tuple2OptionOpts<A, B> on (Option<A>, Option<B>) {
  Option<C> mapN<C>(Function2<A, B, C> fn) => _tupled2($1, $2).map(fn.tupled);

  Option<(A, B)> sequence() => _tupled2($1, $2);
}

extension Tuple3OptionOps<A, B, C> on (Option<A>, Option<B>, Option<C>) {
  Option<D> mapN<D>(Function3<A, B, C, D> fn) =>
      _tupled3($1, $2, $3).map(fn.tupled);

  Option<(A, B, C)> sequence() => _tupled3($1, $2, $3);
}

extension Tuple4OptionOps<A, B, C, D> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>
) {
  Option<E> mapN<E>(Function4<A, B, C, D, E> fn) =>
      _tupled4($1, $2, $3, $4).map(fn.tupled);

  Option<(A, B, C, D)> sequence() => _tupled4($1, $2, $3, $4);
}

extension Tuple5OptionOps<A, B, C, D, E> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>
) {
  Option<F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      _tupled5($1, $2, $3, $4, $5).map(fn.tupled);

  Option<(A, B, C, D, E)> sequence() => _tupled5($1, $2, $3, $4, $5);
}

extension Tuple6OptionOps<A, B, C, D, E, F> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>
) {
  Option<G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      _tupled6($1, $2, $3, $4, $5, $6).map(fn.tupled);

  Option<(A, B, C, D, E, F)> sequence() => _tupled6($1, $2, $3, $4, $5, $6);
}

extension Tuple7OptionOps<A, B, C, D, E, F, G> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>
) {
  Option<H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      _tupled7($1, $2, $3, $4, $5, $6, $7).map(fn.tupled);

  Option<(A, B, C, D, E, F, G)> sequence() =>
      _tupled7($1, $2, $3, $4, $5, $6, $7);
}

extension Tuple8OptionOps<A, B, C, D, E, F, G, H> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>
) {
  Option<I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8).map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H)> sequence() =>
      _tupled8($1, $2, $3, $4, $5, $6, $7, $8);
}

extension Tuple9OptionOps<A, B, C, D, E, F, G, H, I> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>
) {
  Option<J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9).map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I)> sequence() =>
      _tupled9($1, $2, $3, $4, $5, $6, $7, $8, $9);
}

extension Tuple10OptionOps<A, B, C, D, E, F, G, H, I, J> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>
) {
  Option<K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J)> sequence() =>
      _tupled10($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
}

extension Tuple11OptionOps<A, B, C, D, E, F, G, H, I, J, K> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>
) {
  Option<L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K)> sequence() =>
      _tupled11($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
}

extension Tuple12OptionOps<A, B, C, D, E, F, G, H, I, J, K, L> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>
) {
  Option<M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L)> sequence() =>
      _tupled12($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}

extension Tuple13OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>
) {
  Option<N> mapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M)> sequence() =>
      _tupled13($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
}

extension Tuple14OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>
) {
  Option<O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> sequence() =>
      _tupled14($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
}

extension Tuple15OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>
) {
  Option<P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      _tupled15(
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> sequence() => _tupled15(
      $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}

extension Tuple16OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>
) {
  Option<Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> sequence() =>
      _tupled16($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16);
}

extension Tuple17OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>
) {
  Option<R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> sequence() =>
      _tupled17($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16, $17);
}

extension Tuple18OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>,
  Option<R>
) {
  Option<S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> sequence() =>
      _tupled18($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
          $15, $16, $17, $18);
}

extension Tuple19OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
    S> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>,
  Option<R>,
  Option<S>
) {
  Option<T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      sequence() => _tupled19($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19);
}

extension Tuple20OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
    S, T> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>,
  Option<R>,
  Option<S>,
  Option<T>
) {
  Option<U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      sequence() => _tupled20($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20);
}

extension Tuple21OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
    S, T, U> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>,
  Option<R>,
  Option<S>,
  Option<T>,
  Option<U>
) {
  Option<V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      sequence() => _tupled21($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21);
}

extension Tuple22OptionOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
    S, T, U, V> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
  Option<K>,
  Option<L>,
  Option<M>,
  Option<N>,
  Option<O>,
  Option<P>,
  Option<Q>,
  Option<R>,
  Option<S>,
  Option<T>,
  Option<U>,
  Option<V>
) {
  Option<W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
              $15, $16, $17, $18, $19, $20, $21, $22)
          .map(fn.tupled);

  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      sequence() => _tupled22($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
          $13, $14, $15, $16, $17, $18, $19, $20, $21, $22);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

Option<(A, B)> _tupled2<A, B>(
  Option<A> a,
  Option<B> b,
) =>
    a.flatMap((a) => b.map((b) => (a, b)));

Option<(A, B, C)> _tupled3<A, B, C>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
) =>
    _tupled2(a, b).flatMap((t) => c.map(t.append));

Option<(A, B, C, D)> _tupled4<A, B, C, D>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
) =>
    _tupled3(a, b, c).flatMap((t) => d.map(t.append));

Option<(A, B, C, D, E)> _tupled5<A, B, C, D, E>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
) =>
    _tupled4(a, b, c, d).flatMap((t) => e.map(t.append));

Option<(A, B, C, D, E, F)> _tupled6<A, B, C, D, E, F>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
) =>
    _tupled5(a, b, c, d, e).flatMap((t) => f.map(t.append));

Option<(A, B, C, D, E, F, G)> _tupled7<A, B, C, D, E, F, G>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
) =>
    _tupled6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

Option<(A, B, C, D, E, F, G, H)> _tupled8<A, B, C, D, E, F, G, H>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
) =>
    _tupled7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

Option<(A, B, C, D, E, F, G, H, I)> _tupled9<A, B, C, D, E, F, G, H, I>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
) =>
    _tupled8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J)> _tupled10<A, B, C, D, E, F, G, H, I, J>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
) =>
    _tupled9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K)>
    _tupled11<A, B, C, D, E, F, G, H, I, J, K>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
) =>
        _tupled10(a, b, c, d, e, f, g, h, i, j).flatMap((t) => k.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L)> _tupled12<A, B, C, D, E, F, G, H,
        I, J, K, L>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
) =>
    _tupled11(a, b, c, d, e, f, g, h, i, j, k).flatMap((t) => l.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
    _tupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
) =>
        _tupled12(a, b, c, d, e, f, g, h, i, j, k, l)
            .flatMap((t) => m.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
    _tupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
) =>
        _tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
            .flatMap((t) => n.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
    _tupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
) =>
        _tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
            .flatMap((t) => o.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
    _tupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
) =>
        _tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
            .flatMap((t) => p.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
    _tupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
) =>
        _tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
            .flatMap((t) => q.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
    _tupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
  Option<R> r,
) =>
        _tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
            .flatMap((t) => r.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
    _tupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
  Option<R> r,
  Option<S> s,
) =>
        _tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
            .flatMap((t) => s.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
    _tupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
  Option<R> r,
  Option<S> s,
  Option<T> t,
) =>
        _tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
            .flatMap((tup) => t.map(tup.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
    _tupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
  Option<R> r,
  Option<S> s,
  Option<T> t,
  Option<U> u,
) =>
        _tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
            .flatMap((t) => u.map(t.append));

Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
    _tupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
  Option<A> a,
  Option<B> b,
  Option<C> c,
  Option<D> d,
  Option<E> e,
  Option<F> f,
  Option<G> g,
  Option<H> h,
  Option<I> i,
  Option<J> j,
  Option<K> k,
  Option<L> l,
  Option<M> m,
  Option<N> n,
  Option<O> o,
  Option<P> p,
  Option<Q> q,
  Option<R> r,
  Option<S> s,
  Option<T> t,
  Option<U> u,
  Option<V> v,
) =>
        _tupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
            .flatMap((t) => v.map(t.append));
