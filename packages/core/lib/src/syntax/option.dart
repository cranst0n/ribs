import 'package:ribs_core/ribs_core.dart';

extension OptionSyntaxOps<A> on A {
  /// Lifts this value into an [Option], specifically a [Some].
  Option<A> get some => Some(this);
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension OptionTuple2Ops<A, B> on Option<(A, B)> {
  Option<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  Option<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  Option<C> flatMapN<C>(Function2<A, B, Option<C>> f) => flatMap(f.tupled);

  C foldN<C>(Function0<C> ifEmpty, Function2<A, B, C> f) =>
      fold(ifEmpty, f.tupled);

  void foreachN(Function2<A, B, void> ifSome) => foreach(ifSome.tupled);

  Option<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);
}

/// {@template option_tuple_ops}
/// Functions available on a tuple of [Option]s.
/// {@endtemplate}
extension Tuple2OptionOpts<A, B> on (Option<A>, Option<B>) {
  /// {@template option_mapN}
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  /// {@endtemplate}
  Option<C> mapN<C>(Function2<A, B, C> fn) => tupled().map(fn.tupled);

  /// {@template option_tupled}
  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  /// [None], [None] is returned.
  /// {@endtemplate}
  /// /// {@macro option_tupled}
  Option<(A, B)> tupled() => $1.flatMap((a) => $2.map((b) => (a, b)));
}

/// {@macro option_tuple_ops}
extension Tuple3OptionOps<A, B, C> on (Option<A>, Option<B>, Option<C>) {
  /// {@macro option_mapN}
  Option<D> mapN<D>(Function3<A, B, C, D> fn) => tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
extension Tuple4OptionOps<A, B, C, D> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>
) {
  /// {@macro option_mapN}
  Option<E> mapN<E>(Function4<A, B, C, D, E> fn) => tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
extension Tuple5OptionOps<A, B, C, D, E> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>
) {
  /// {@macro option_mapN}
  Option<F> mapN<F>(Function5<A, B, C, D, E, F> fn) => tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
extension Tuple6OptionOps<A, B, C, D, E, F> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>
) {
  /// {@macro option_mapN}
  Option<G> mapN<G>(Function6<A, B, C, D, E, F, G> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
extension Tuple7OptionOps<A, B, C, D, E, F, G> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>
) {
  /// {@macro option_mapN}
  Option<H> mapN<H>(Function7<A, B, C, D, E, F, G, H> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<I> mapN<I>(Function8<A, B, C, D, E, F, G, H, I> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<J> mapN<J>(Function9<A, B, C, D, E, F, G, H, I, J> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<K> mapN<K>(Function10<A, B, C, D, E, F, G, H, I, J, K> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<L> mapN<L>(Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<M> mapN<M>(Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<N> mapN<N>(Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<O> mapN<O>(
          Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<P> mapN<P>(
          Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<Q> mapN<Q>(
          Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<R> mapN<R>(
          Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<S> mapN<S>(
          Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<T> mapN<T>(
          Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<U> mapN<U>(
          Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<V> mapN<V>(
          Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}

/// {@macro option_tuple_ops}
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
  /// {@macro option_mapN}
  Option<W> mapN<W>(
          Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
                  U, V, W>
              fn) =>
      tupled().map(fn.tupled);

  /// {@macro option_tupled}
  Option<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));
}
