import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

Option<A> none<A>() => None<A>();

@immutable
abstract class Option<A> implements Monad<A>, Foldable<A> {
  const Option();

  factory Option.of(A? a) => a == null ? none<A>() : Some(a);

  factory Option.pure(A a) => Some(a);

  factory Option.unless(Function0<bool> condition, Function0<A> a) =>
      condition() ? None<A>() : Some(a());

  factory Option.when(Function0<bool> condition, Function0<A> a) =>
      condition() ? Some(a()) : None<A>();

  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f);

  @override
  Option<B> ap<B>(Option<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  bool get isDefined => fold(() => false, (_) => true);

  bool get isEmpty => !isDefined;

  Option<A> filter(Function1<A, bool> p) =>
      fold(() => this, (a) => p(a) ? this : const None());

  Option<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  Option<B> flatMap<B>(covariant Function1<A, Option<B>> f) =>
      fold(() => none<B>(), f);

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) =>
      fold(() => init, (a) => op(init, a));

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      fold(() => init, (a) => op(a, init));

  A getOrElse(Function0<A> ifEmpty) => fold(() => ifEmpty(), id);

  void forEach(Function1<A, void> ifSome) {
    if (this is Some<A>) {
      ifSome((this as Some<A>).value);
    }
  }

  @override
  Option<B> map<B>(Function1<A, B> f) => flatMap((a) => Some(f(a)));

  bool get nonEmpty => isDefined;

  Option<A> orElse(Function0<Option<A>> orElse) =>
      fold(() => orElse(), (_) => this);

  IList<A> toIList() => fold(() => nil<A>(), (a) => ilist([a]));

  Either<A, X> toLeft<X>(Function0<X> ifEmpty) =>
      fold(() => Either.right<A, X>(ifEmpty()), (x) => Either.left<A, X>(x));

  Either<X, A> toRight<X>(Function0<X> ifEmpty) =>
      fold(() => Either.left<X, A>(ifEmpty()), (x) => Either.right<X, A>(x));

  A? toNullable() => fold(() => null, id);

  @override
  String toString() => fold(() => 'None', (a) => 'Some($a)');

  @override
  bool operator ==(Object other) => fold(
        () => other is None,
        (value) => other is Some<A> && value == other.value,
      );

  @override
  int get hashCode => fold(() => 0, (a) => a.hashCode);

  static Option<Tuple2<A, B>> tupled2<A, B>(
    Option<A> a,
    Option<B> b,
  ) =>
      a.flatMap((a) => b.map((b) => Tuple2(a, b)));

  static Option<Tuple3<A, B, C>> tupled3<A, B, C>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
  ) =>
      tupled2(a, b).flatMap((t) => c.map(t.append));

  static Option<Tuple4<A, B, C, D>> tupled4<A, B, C, D>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
  ) =>
      tupled3(a, b, c).flatMap((t) => d.map(t.append));

  static Option<Tuple5<A, B, C, D, E>> tupled5<A, B, C, D, E>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
  ) =>
      tupled4(a, b, c, d).flatMap((t) => e.map(t.append));

  static Option<Tuple6<A, B, C, D, E, F>> tupled6<A, B, C, D, E, F>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
  ) =>
      tupled5(a, b, c, d, e).flatMap((t) => f.map(t.append));

  static Option<Tuple7<A, B, C, D, E, F, G>> tupled7<A, B, C, D, E, F, G>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Option<G> g,
  ) =>
      tupled6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

  static Option<Tuple8<A, B, C, D, E, F, G, H>> tupled8<A, B, C, D, E, F, G, H>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Option<G> g,
    Option<H> h,
  ) =>
      tupled7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

  static Option<Tuple9<A, B, C, D, E, F, G, H, I>>
      tupled9<A, B, C, D, E, F, G, H, I>(
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
          tupled8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

  static Option<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tupled10<A, B, C, D, E, F, G, H, I, J>(
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
          tupled9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

  static Option<Tuple11<A, B, C, D, E, F, G, H, I, J, K>> tupled11<A, B, C, D,
          E, F, G, H, I, J, K>(
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
      tupled10(a, b, c, d, e, f, g, h, i, j).flatMap((t) => k.map(t.append));

  static Option<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> tupled12<A, B, C,
          D, E, F, G, H, I, J, K, L>(
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
      tupled11(a, b, c, d, e, f, g, h, i, j, k).flatMap((t) => l.map(t.append));

  static Option<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
          tupled12(a, b, c, d, e, f, g, h, i, j, k, l)
              .flatMap((t) => m.map(t.append));

  static Option<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
          tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
              .flatMap((t) => n.map(t.append));

  static Option<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
          tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
              .flatMap((t) => o.map(t.append));

  static Option<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
      tupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
          tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
              .flatMap((t) => p.map(t.append));

  static Option<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
      tupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
          tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
              .flatMap((t) => q.map(t.append));

  static Option<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      tupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
          tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
              .flatMap((t) => r.map(t.append));

  static Option<
          Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      tupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
          tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
              .flatMap((t) => s.map(t.append));

  static Option<
          Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      tupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
          tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .flatMap((tup) => t.map(tup.append));

  static Option<
          Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>>
      tupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
          tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
              .flatMap((t) => u.map(t.append));

  static Option<
          Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>>
      tupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>(
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
          tupled21(
                  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
              .flatMap((t) => v.map(t.append));

  static Option<C> map2<A, B, C>(
    Option<A> a,
    Option<B> b,
    Function2<A, B, C> fn,
  ) =>
      tupled2(a, b).map(fn.tupled);

  static Option<D> map3<A, B, C, D>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Function3<A, B, C, D> fn,
  ) =>
      tupled3(a, b, c).map(fn.tupled);

  static Option<E> map4<A, B, C, D, E>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Function4<A, B, C, D, E> fn,
  ) =>
      tupled4(a, b, c, d).map(fn.tupled);

  static Option<F> map5<A, B, C, D, E, F>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Function5<A, B, C, D, E, F> fn,
  ) =>
      tupled5(a, b, c, d, e).map(fn.tupled);

  static Option<G> map6<A, B, C, D, E, F, G>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Function6<A, B, C, D, E, F, G> fn,
  ) =>
      tupled6(a, b, c, d, e, f).map(fn.tupled);

  static Option<H> map7<A, B, C, D, E, F, G, H>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Option<G> g,
    Function7<A, B, C, D, E, F, G, H> fn,
  ) =>
      tupled7(a, b, c, d, e, f, g).map(fn.tupled);

  static Option<I> map8<A, B, C, D, E, F, G, H, I>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Option<G> g,
    Option<H> h,
    Function8<A, B, C, D, E, F, G, H, I> fn,
  ) =>
      tupled8(a, b, c, d, e, f, g, h).map(fn.tupled);

  static Option<J> map9<A, B, C, D, E, F, G, H, I, J>(
    Option<A> a,
    Option<B> b,
    Option<C> c,
    Option<D> d,
    Option<E> e,
    Option<F> f,
    Option<G> g,
    Option<H> h,
    Option<I> i,
    Function9<A, B, C, D, E, F, G, H, I, J> fn,
  ) =>
      tupled9(a, b, c, d, e, f, g, h, i).map(fn.tupled);

  static Option<K> map10<A, B, C, D, E, F, G, H, I, J, K>(
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
    Function10<A, B, C, D, E, F, G, H, I, J, K> fn,
  ) =>
      tupled10(a, b, c, d, e, f, g, h, i, j).map(fn.tupled);

  static Option<L> map11<A, B, C, D, E, F, G, H, I, J, K, L>(
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
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn,
  ) =>
      tupled11(a, b, c, d, e, f, g, h, i, j, k).map(fn.tupled);

  static Option<M> map12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn,
  ) =>
      tupled12(a, b, c, d, e, f, g, h, i, j, k, l).map(fn.tupled);

  static Option<N> map13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn,
  ) =>
      tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m).map(fn.tupled);

  static Option<O> map14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn,
  ) =>
      tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n).map(fn.tupled);

  static Option<P> map15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn,
  ) =>
      tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o).map(fn.tupled);

  static Option<Q> map16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn,
  ) =>
      tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p).map(fn.tupled);

  static Option<R> map17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> fn,
  ) =>
      tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
          .map(fn.tupled);

  static Option<S>
      map18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> fn,
  ) =>
          tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
              .map(fn.tupled);

  static Option<T>
      map19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> fn,
  ) =>
          tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .map(fn.tupled);

  static Option<U>
      map20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
        fn,
  ) =>
          tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
              .map(fn.tupled);

  static Option<V> map21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
          S, T, U, V>(
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
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        fn,
  ) =>
      tupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
          .map(fn.tupled);

  static Option<W> map22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
          S, T, U, V, W>(
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
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
            W>
        fn,
  ) =>
      tupled22(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v)
          .map(fn.tupled);
}

class Some<A> extends Option<A> {
  final A value;

  const Some(this.value);

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => f(value);
}

class None<A> extends Option<A> {
  const None();

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => ifEmpty();
}

extension OptionNestedOps<A> on Option<Option<A>> {
  Option<A> flatten() => fold(() => none<A>(), id);
}
