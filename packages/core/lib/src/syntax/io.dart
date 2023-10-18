import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/syntax/tuple.dart';

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension IOTuple2Ops<A, B> on IO<(A, B)> {
  IO<C> flatMapN<C>(Function2<A, B, IO<C>> f) => flatMap(f.tupled);

  IO<(A, B)> flatTapN<C>(Function2<A, B, IO<C>> f) => flatTap(f.tupled);

  IO<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  IO<(C, A, B)> tupleLeftN<C>(C c) => map((ab) => ab.prepend(c));

  IO<(A, B, C)> tupleRightN<C>(C c) => map((ab) => ab.append(c));
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension IOTuple3Ops<A, B, C> on IO<(A, B, C)> {
  IO<D> flatMapN<D>(Function3<A, B, C, IO<D>> f) => flatMap(f.tupled);

  IO<(A, B, C)> flatTapN<D>(Function3<A, B, C, IO<D>> f) => flatTap(f.tupled);

  IO<D> mapN<D>(Function3<A, B, C, D> f) => map(f.tupled);

  IO<(D, A, B, C)> tupleLeftN<D>(D d) => map((abc) => abc.prepend(d));

  IO<(A, B, C, D)> tupleRightN<D>(D d) => map((abc) => abc.append(d));
}

/// {@template io_tuple_ops}
/// Functions available on a tuple of [IO]s.
/// {@endtemplate}
extension Tuple2IOOps<A, B> on (IO<A>, IO<B>) {
  /// {@template io_mapN}
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  /// {@endtemplate}
  IO<C> mapN<C>(Function2<A, B, C> fn) => sequence().map(fn.tupled);

  /// {@template io_parMapN}
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Items are evaluated
  /// asynchronously.
  /// {@endtemplate}
  IO<C> parMapN<C>(Function2<A, B, C> fn) => parSequence().map(fn.tupled);

  /// {@template io_sequence}
  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  /// {@endtemplate}
  IO<(A, B)> sequence() => $1.flatMap((a) => $2.map((b) => (a, b)));

  /// {@template io_parSequence}
  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  /// {@endtemplate}
  IO<(A, B)> parSequence() => IO.both($1, $2);
}

/// {@macro io_tuple_ops}
extension Tuple3IOOps<A, B, C> on (IO<A>, IO<B>, IO<C>) {
  /// {@macro io_mapN}
  IO<D> mapN<D>(Function3<A, B, C, D> fn) => sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<D> parMapN<D>(Function3<A, B, C, D> fn) => parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple4IOOps<A, B, C, D> on (IO<A>, IO<B>, IO<C>, IO<D>) {
  /// {@macro io_mapN}
  IO<E> mapN<E>(Function4<A, B, C, D, E> fn) => sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<E> parMapN<E>(Function4<A, B, C, D, E> fn) => parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple5IOOps<A, B, C, D, E> on (IO<A>, IO<B>, IO<C>, IO<D>, IO<E>) {
  /// {@macro io_mapN}
  IO<F> mapN<F>(Function5<A, B, C, D, E, F> fn) => sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<F> parMapN<F>(Function5<A, B, C, D, E, F> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple6IOOps<A, B, C, D, E, F> on (
  IO<A>,
  IO<B>,
  IO<C>,
  IO<D>,
  IO<E>,
  IO<F>
) {
  /// {@macro io_mapN}
  IO<G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) => sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<G> parMapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple7IOOps<A, B, C, D, E, F, G> on (
  IO<A>,
  IO<B>,
  IO<C>,
  IO<D>,
  IO<E>,
  IO<F>,
  IO<G>
) {
  /// {@macro io_mapN}
  IO<H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<H> parMapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple8IOOps<A, B, C, D, E, F, G, H> on (
  IO<A>,
  IO<B>,
  IO<C>,
  IO<D>,
  IO<E>,
  IO<F>,
  IO<G>,
  IO<H>
) {
  /// {@macro io_mapN}
  IO<I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<I> parMapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple9IOOps<A, B, C, D, E, F, G, H, I> on (
  IO<A>,
  IO<B>,
  IO<C>,
  IO<D>,
  IO<E>,
  IO<F>,
  IO<G>,
  IO<H>,
  IO<I>
) {
  /// {@macro io_mapN}
  IO<J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<J> parMapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple10IOOps<A, B, C, D, E, F, G, H, I, J> on (
  IO<A>,
  IO<B>,
  IO<C>,
  IO<D>,
  IO<E>,
  IO<F>,
  IO<G>,
  IO<H>,
  IO<I>,
  IO<J>
) {
  /// {@macro io_mapN}
  IO<K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<K> parMapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple11IOOps<A, B, C, D, E, F, G, H, I, J, K> on (
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
  IO<K>
) {
  /// {@macro io_mapN}
  IO<L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<L> parMapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple12IOOps<A, B, C, D, E, F, G, H, I, J, K, L> on (
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
  IO<L>
) {
  /// {@macro io_mapN}
  IO<M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<M> parMapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple13IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
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
  IO<M>
) {
  /// {@macro io_mapN}
  IO<N> mapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<N> parMapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple14IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
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
  IO<N>
) {
  /// {@macro io_mapN}
  IO<O> mapN<O>(Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<O> parMapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple15IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
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
  IO<O>
) {
  /// {@macro io_mapN}
  IO<P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<P> parMapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple16IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
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
  IO<P>
) {
  /// {@macro io_mapN}
  IO<Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<Q> parMapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple17IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> on (
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
  IO<Q>
) {
  /// {@macro io_mapN}
  IO<R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<R> parMapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple18IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on (
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
  IO<R>
) {
  /// {@macro io_mapN}
  IO<S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<S> parMapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple19IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on (
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
  IO<S>
) {
  /// {@macro io_mapN}
  IO<T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<T> parMapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> parSequence() =>
      IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple20IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T> on (
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
  IO<T>
) {
  /// {@macro io_mapN}
  IO<U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<U> parMapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> sequence() =>
      init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      parSequence() =>
          IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple21IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T, U> on (
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
  IO<U>
) {
  /// {@macro io_mapN}
  IO<V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<V> parMapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      sequence() =>
          init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      parSequence() =>
          IO.both(init().parSequence(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro io_tuple_ops}
extension Tuple22IOOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T, U, V> on (
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
  IO<V>
) {
  /// {@macro io_mapN}
  IO<W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      sequence().map(fn.tupled);

  /// {@macro io_parMapN}
  IO<W> parMapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      parSequence().map(fn.tupled);

  /// {@macro io_sequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      sequence() =>
          init().sequence().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro io_parSequence}
  IO<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      parSequence() => IO
          .both(init().parSequence(), last)
          .map((t) => t((a, b) => a.append(b)));
}
