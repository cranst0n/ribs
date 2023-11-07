import 'package:ribs_core/src/either.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/syntax/tuple.dart';

/// Operations for any value to lift it into an [Either].
extension EitherSyntaxOps<A> on A {
  /// Creates a [Left] instance with this value.
  Either<A, B> asLeft<B>() => Either.left(this);

  /// Creates a [Right] instance with this value.
  Either<B, A> asRight<B>() => Either.right(this);
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension EitherTuple2Ops<EE, A, B> on Either<EE, (A, B)> {
  Either<EE, C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);
}

/// {@template either_tuple_ops}
/// Functions available on a tuple of [Either]s.
/// {@endtemplate}
extension Tuple2EitherOps<EE, A, B> on (Either<EE, A>, Either<EE, B>) {
  /// {@template either_mapN}
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  /// {@endtemplate}
  Either<EE, C> mapN<C>(Function2<A, B, C> fn) => tupled().map(fn.tupled);

  /// {@template either_tupled}
  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  /// {@endtemplate}
  Either<EE, (A, B)> tupled() => $1.flatMap((a) => last.map((b) => (a, b)));
}

/// {@macro either_tuple_ops}
extension Tuple3EitherOps<EE, A, B, C> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>
) {
  /// {@macro either_mapN}
  Either<EE, D> mapN<D>(Function3<A, B, C, D> fn) => tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
extension Tuple4EitherOps<EE, A, B, C, D> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>
) {
  /// {@macro either_mapN}
  Either<EE, E> mapN<E>(Function4<A, B, C, D, E> fn) => tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
extension Tuple5EitherOps<EE, A, B, C, D, E> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>
) {
  /// {@macro either_mapN}
  Either<EE, F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
extension Tuple6EitherOps<EE, A, B, C, D, E, F> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>
) {
  /// {@macro either_mapN}
  Either<EE, G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
extension Tuple7EitherOps<EE, A, B, C, D, E, F, G> on (
  Either<EE, A>,
  Either<EE, B>,
  Either<EE, C>,
  Either<EE, D>,
  Either<EE, E>,
  Either<EE, F>,
  Either<EE, G>
) {
  /// {@macro either_mapN}
  Either<EE, H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, N> mapN<N>(
          Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro either_tuple_ops}
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
  /// {@macro either_mapN}
  Either<EE, W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro either_tupled}
  Either<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}
