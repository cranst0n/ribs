import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/non_empty_ilist.dart';
import 'package:ribs_core/src/syntax/tuple.dart';
import 'package:ribs_core/src/validated.dart';

extension ValidatedSyntaxOps<A> on A {
  /// Lifts this value into a [Validated], specifically an [Invalid].
  Validated<A, B> invalid<B>() => Validated.invalid(this);

  /// Lifts this value into a [Validated], specifically a [Valid].
  Validated<B, A> valid<B>() => Validated.valid(this);

  /// Lifts this value into a [ValidatedNel], specifically an [Invalid].
  ValidatedNel<A, B> invalidNel<B>() =>
      Validated.invalid(NonEmptyIList.one(this));

  /// Lifts this value into a [ValidatedNel], specifically a [Valid].
  ValidatedNel<B, A> validNel<B>() => Validated.valid(this);
}

/// {@template validatednel_tuple_ops}
/// Functions available on a tuple of [ValidatedNel]s.
/// {@endtemplate}
extension Tuple2ValidatedNelOps<EE, A, B> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>
) {
  /// {@template validatednel_mapN}
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  /// {@endtemplate}
  ValidatedNel<EE, C> mapN<C>(Function2<A, B, C> fn) => tupled().map(fn.tupled);

  /// {@template validatednel_tupled}
  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  /// {@endtemplate}
  ValidatedNel<EE, (A, B)> tupled() => $1.product($2);
}

/// {@macro validatednel_tuple_ops}
extension Tuple3ValidatedNelOps<EE, A, B, C> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>
) {
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, D> mapN<D>(Function3<A, B, C, D> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
extension Tuple4ValidatedNelOps<EE, A, B, C, D> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>
) {
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, E> mapN<E>(Function4<A, B, C, D, E> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
extension Tuple5ValidatedNelOps<EE, A, B, C, D, E> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>
) {
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
extension Tuple6ValidatedNelOps<EE, A, B, C, D, E, F> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>
) {
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
extension Tuple7ValidatedNelOps<EE, A, B, C, D, E, F, G> on (
  ValidatedNel<EE, A>,
  ValidatedNel<EE, B>,
  ValidatedNel<EE, C>,
  ValidatedNel<EE, D>,
  ValidatedNel<EE, E>,
  ValidatedNel<EE, F>,
  ValidatedNel<EE, G>
) {
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, L> mapN<L>(
          Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, M> mapN<M>(
          Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, N> mapN<N>(
          Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled() =>
      init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE,
          (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}

/// {@macro validatednel_tuple_ops}
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
  /// {@macro validatednel_mapN}
  ValidatedNel<EE, W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro validatednel_tupled}
  ValidatedNel<EE,
          (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      tupled() => init().tupled().product(last).map((t) => t.$1.append(t.$2));
}
