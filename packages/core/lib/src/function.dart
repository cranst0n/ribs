import 'package:ribs_core/ribs_core.dart';

@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
A identity<A>(A a) => a;

typedef Function0<A> = A Function();
typedef Function1<A, B> = B Function(A a);
typedef Function2<A, B, C> = C Function(A a, B b);
typedef Function3<A, B, C, D> = D Function(A a, B b, C c);
typedef Function4<A, B, C, D, E> = E Function(A a, B b, C c, D d);
typedef Function5<A, B, C, D, E, F> = F Function(A a, B b, C c, D d, E e);
typedef Function6<A, B, C, D, E, F, G> = G Function(
    A a, B b, C c, D d, E e, F f);
typedef Function7<A, B, C, D, E, F, G, H> = H Function(
    A a, B b, C c, D d, E e, F f, G g);
typedef Function8<A, B, C, D, E, F, G, H, I> = I Function(
    A a, B b, C c, D d, E e, F f, G g, H h);
typedef Function9<A, B, C, D, E, F, G, H, I, J> = J Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i);
typedef Function10<A, B, C, D, E, F, G, H, I, J, K> = K Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j);
typedef Function11<A, B, C, D, E, F, G, H, I, J, K, L> = L Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k);
typedef Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> = M Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l);
typedef Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> = N Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l, M m);
typedef Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> = O Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l, M m, N n);
typedef Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> = P Function(
    A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l, M m, N n, O o);
typedef Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    = Q Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p);
typedef Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    = R Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q);
typedef Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    = S Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q, R r);
typedef Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    = T Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q, R r, S s);
typedef Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U>
    = U Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q, R r, S s, T t);
typedef Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V>
    = V Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q, R r, S s, T t, U u);
typedef Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V, W>
    = W Function(A a, B b, C c, D d, E e, F f, G g, H h, I i, J j, K k, L l,
        M m, N n, O o, P p, Q q, R r, S s, T t, U u, V v);

typedef Function2C<A, B, C> = Function1<A, Function1<B, C>>;
typedef Function3C<A, B, C, D> = Function1<A, Function2C<B, C, D>>;
typedef Function4C<A, B, C, D, E> = Function1<A, Function3C<B, C, D, E>>;
typedef Function5C<A, B, C, D, E, F> = Function1<A, Function4C<B, C, D, E, F>>;
typedef Function6C<A, B, C, D, E, F, G>
    = Function1<A, Function5C<B, C, D, E, F, G>>;
typedef Function7C<A, B, C, D, E, F, G, H>
    = Function1<A, Function6C<B, C, D, E, F, G, H>>;
typedef Function8C<A, B, C, D, E, F, G, H, I>
    = Function1<A, Function7C<B, C, D, E, F, G, H, I>>;
typedef Function9C<A, B, C, D, E, F, G, H, I, J>
    = Function1<A, Function8C<B, C, D, E, F, G, H, I, J>>;
typedef Function10C<A, B, C, D, E, F, G, H, I, J, K>
    = Function1<A, Function9C<B, C, D, E, F, G, H, I, J, K>>;
typedef Function11C<A, B, C, D, E, F, G, H, I, J, K, L>
    = Function1<A, Function10C<B, C, D, E, F, G, H, I, J, K, L>>;
typedef Function12C<A, B, C, D, E, F, G, H, I, J, K, L, M>
    = Function1<A, Function11C<B, C, D, E, F, G, H, I, J, K, L, M>>;
typedef Function13C<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    = Function1<A, Function12C<B, C, D, E, F, G, H, I, J, K, L, M, N>>;
typedef Function14C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    = Function1<A, Function13C<B, C, D, E, F, G, H, I, J, K, L, M, N, O>>;
typedef Function15C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    = Function1<A, Function14C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>;
typedef Function16C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    = Function1<A, Function15C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>;
typedef Function17C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    = Function1<A,
        Function16C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>;
typedef Function18C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    = Function1<A,
        Function17C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>;
typedef Function19C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    = Function1<A,
        Function18C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>;
typedef Function20C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U>
    = Function1<
        A,
        Function19C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
            U>>;
typedef Function21C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V>
    = Function1<
        A,
        Function20C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
            V>>;
typedef Function22C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V, W>
    = Function1<
        A,
        Function21C<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
            V, W>>;

extension Function0Ops<A> on Function0<A> {
  Function0<B> andThen<B>(Function1<A, B> fn) => () => fn(this());
}

extension Function1Ops<A, B> on Function1<A, B> {
  Function1<A, C> andThen<C>(Function1<B, C> fn) => (a) => fn(this(a));

  Function1<C, B> compose<C>(Function1<C, A> fn) => (c) => this(fn(c));
}

extension Function2Ops<A, B, C> on Function2<A, B, C> {
  Function2<A, B, D> andThen<D>(Function1<C, D> fn) => (a, b) => fn(this(a, b));

  Function1<D, C> compose<D>(Function1<D, (A, B)> fn) => (d) => tupled(fn(d));

  Function2C<A, B, C> get curried => (a) => (b) => this(a, b);

  Function1<(A, B), C> get tupled => (t) => t(this);
}

extension Function2COps<A, B, C> on Function2C<A, B, C> {
  Function2<A, B, C> get uncurried => (a, b) => this(a)(b);
}

extension Function3Ops<A, B, C, D> on Function3<A, B, C, D> {
  Function3<A, B, C, E> andThen<E>(Function1<D, E> fn) =>
      (a, b, c) => fn(this(a, b, c));

  Function1<E, D> compose<E>(Function1<E, (A, B, C)> fn) =>
      (e) => tupled(fn(e));

  Function3C<A, B, C, D> get curried => (a) => (b) => (c) => this(a, b, c);

  Function1<(A, B, C), D> get tupled => (t) => t(this);
}

extension Function3COps<A, B, C, D> on Function3C<A, B, C, D> {
  Function3<A, B, C, D> get uncurried => (a, b, c) => this(a)(b)(c);
}

extension Function4Ops<A, B, C, D, E> on Function4<A, B, C, D, E> {
  Function4<A, B, C, D, F> andThen<F>(Function1<E, F> fn) =>
      (a, b, c, d) => fn(this(a, b, c, d));

  Function1<F, E> compose<F>(Function1<F, (A, B, C, D)> fn) =>
      (f) => tupled(fn(f));

  Function4C<A, B, C, D, E> get curried =>
      (a) => (b) => (c) => (d) => this(a, b, c, d);

  Function1<(A, B, C, D), E> get tupled => (t) => t(this);
}

extension Function4COps<A, B, C, D, E> on Function4C<A, B, C, D, E> {
  Function4<A, B, C, D, E> get uncurried => (a, b, c, d) => this(a)(b)(c)(d);
}

extension Function5Ops<A, B, C, D, E, F> on Function5<A, B, C, D, E, F> {
  Function5<A, B, C, D, E, G> andThen<G>(Function1<F, G> fn) =>
      (a, b, c, d, e) => fn(this(a, b, c, d, e));

  Function1<G, F> compose<G>(Function1<G, (A, B, C, D, E)> fn) =>
      (g) => tupled(fn(g));

  Function5C<A, B, C, D, E, F> get curried =>
      (a) => (b) => (c) => (d) => (e) => this(a, b, c, d, e);

  Function1<(A, B, C, D, E), F> get tupled => (t) => t(this);
}

extension Function5COps<A, B, C, D, E, F> on Function5C<A, B, C, D, E, F> {
  Function5<A, B, C, D, E, F> get uncurried =>
      (a, b, c, d, e) => this(a)(b)(c)(d)(e);
}

extension Function6Ops<A, B, C, D, E, F, G> on Function6<A, B, C, D, E, F, G> {
  Function6<A, B, C, D, E, F, H> andThen<H>(Function1<G, H> fn) =>
      (a, b, c, d, e, f) => fn(this(a, b, c, d, e, f));

  Function1<H, G> compose<H>(Function1<H, (A, B, C, D, E, F)> fn) =>
      (h) => tupled(fn(h));

  Function6C<A, B, C, D, E, F, G> get curried =>
      (A a) => (b) => (c) => (d) => (e) => (f) => this(a, b, c, d, e, f);

  Function1<(A, B, C, D, E, F), G> get tupled => (t) => t(this);
}

extension Function6COps<A, B, C, D, E, F, G>
    on Function6C<A, B, C, D, E, F, G> {
  Function6<A, B, C, D, E, F, G> get uncurried =>
      (a, b, c, d, e, f) => this(a)(b)(c)(d)(e)(f);
}

extension Function7Ops<A, B, C, D, E, F, G, H>
    on Function7<A, B, C, D, E, F, G, H> {
  Function7<A, B, C, D, E, F, G, I> andThen<I>(Function1<H, I> fn) =>
      (a, b, c, d, e, f, g) => fn(this(a, b, c, d, e, f, g));

  Function1<I, H> compose<I>(Function1<I, (A, B, C, D, E, F, G)> fn) =>
      (i) => tupled(fn(i));

  Function7C<A, B, C, D, E, F, G, H> get curried => (a) =>
      (b) => (c) => (d) => (e) => (f) => (g) => this(a, b, c, d, e, f, g);

  Function1<(A, B, C, D, E, F, G), H> get tupled => (t) => t(this);
}

extension Function7COps<A, B, C, D, E, F, G, H>
    on Function7C<A, B, C, D, E, F, G, H> {
  Function7<A, B, C, D, E, F, G, H> get uncurried =>
      (a, b, c, d, e, f, g) => this(a)(b)(c)(d)(e)(f)(g);
}

extension Function8Ops<A, B, C, D, E, F, G, H, I>
    on Function8<A, B, C, D, E, F, G, H, I> {
  Function8<A, B, C, D, E, F, G, H, J> andThen<J>(Function1<I, J> fn) =>
      (a, b, c, d, e, f, g, h) => fn(this(a, b, c, d, e, f, g, h));

  Function1<J, I> compose<J>(Function1<J, (A, B, C, D, E, F, G, H)> fn) =>
      (j) => tupled(fn(j));

  Function8C<A, B, C, D, E, F, G, H, I> get curried => (a) => (b) =>
      (c) => (d) => (e) => (f) => (g) => (h) => this(a, b, c, d, e, f, g, h);

  Function1<(A, B, C, D, E, F, G, H), I> get tupled => (t) => t(this);
}

extension Function8COps<A, B, C, D, E, F, G, H, I>
    on Function8C<A, B, C, D, E, F, G, H, I> {
  Function8<A, B, C, D, E, F, G, H, I> get uncurried =>
      (a, b, c, d, e, f, g, h) => this(a)(b)(c)(d)(e)(f)(g)(h);
}

extension Function9Ops<A, B, C, D, E, F, G, H, I, J>
    on Function9<A, B, C, D, E, F, G, H, I, J> {
  Function9<A, B, C, D, E, F, G, H, I, K> andThen<K>(Function1<J, K> fn) =>
      (a, b, c, d, e, f, g, h, i) => fn(this(a, b, c, d, e, f, g, h, i));

  Function1<K, J> compose<K>(Function1<K, (A, B, C, D, E, F, G, H, I)> fn) =>
      (k) => tupled(fn(k));

  Function9C<A, B, C, D, E, F, G, H, I, J> get curried => (a) => (b) => (c) =>
      (d) => (e) => (f) => (g) => (h) => (i) => this(a, b, c, d, e, f, g, h, i);

  Function1<(A, B, C, D, E, F, G, H, I), J> get tupled => (t) => t(this);
}

extension Function9COps<A, B, C, D, E, F, G, H, I, J>
    on Function9C<A, B, C, D, E, F, G, H, I, J> {
  Function9<A, B, C, D, E, F, G, H, I, J> get uncurried =>
      (a, b, c, d, e, f, g, h, i) => this(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

extension Function10Ops<A, B, C, D, E, F, G, H, I, J, K>
    on Function10<A, B, C, D, E, F, G, H, I, J, K> {
  Function10<A, B, C, D, E, F, G, H, I, J, L> andThen<L>(Function1<K, L> fn) =>
      (a, b, c, d, e, f, g, h, i, j) => fn(this(a, b, c, d, e, f, g, h, i, j));

  Function1<L, K> compose<L>(Function1<L, (A, B, C, D, E, F, G, H, I, J)> fn) =>
      (l) => tupled(fn(l));

  Function10C<A, B, C, D, E, F, G, H, I, J, K> get curried =>
      (a) => (b) => (c) => (d) => (e) =>
          (f) => (g) => (h) => (i) => (j) => this(a, b, c, d, e, f, g, h, i, j);

  Function1<(A, B, C, D, E, F, G, H, I, J), K> get tupled => (t) => t(this);
}

extension Function10COps<A, B, C, D, E, F, G, H, I, J, K>
    on Function10C<A, B, C, D, E, F, G, H, I, J, K> {
  Function10<A, B, C, D, E, F, G, H, I, J, K> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j) => this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j);
}

extension Function11Ops<A, B, C, D, E, F, G, H, I, J, K, L>
    on Function11<A, B, C, D, E, F, G, H, I, J, K, L> {
  Function11<A, B, C, D, E, F, G, H, I, J, K, M> andThen<M>(
          Function1<L, M> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k));

  Function1<M, L> compose<M>(
          Function1<M, (A, B, C, D, E, F, G, H, I, J, K)> fn) =>
      (m) => tupled(fn(m));

  Function11C<A, B, C, D, E, F, G, H, I, J, K, L> get curried =>
      (a) => (b) => (c) => (d) => (e) => (f) => (g) =>
          (h) => (i) => (j) => (k) => this(a, b, c, d, e, f, g, h, i, j, k);

  Function1<(A, B, C, D, E, F, G, H, I, J, K), L> get tupled => (t) => t(this);
}

extension Function11COps<A, B, C, D, E, F, G, H, I, J, K, L>
    on Function11C<A, B, C, D, E, F, G, H, I, J, K, L> {
  Function11<A, B, C, D, E, F, G, H, I, J, K, L> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k);
}

extension Function12Ops<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> {
  Function12<A, B, C, D, E, F, G, H, I, J, K, L, N> andThen<N>(
          Function1<M, N> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l));

  Function1<N, M> compose<N>(
          Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L)> fn) =>
      (n) => tupled(fn(n));

  Function12C<A, B, C, D, E, F, G, H, I, J, K, L, M> get curried =>
      (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) =>
          (i) => (j) => (k) => (l) => this(a, b, c, d, e, f, g, h, i, j, k, l);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L), M> get tupled =>
      (t) => t(this);
}

extension Function12COps<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on Function12C<A, B, C, D, E, F, G, H, I, J, K, L, M> {
  Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k, l) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l);
}

extension Function13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> {
  Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, O> andThen<O>(
          Function1<N, O> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m));

  Function1<O, N> compose<O>(
          Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M)> fn) =>
      (o) => tupled(fn(o));

  Function13C<A, B, C, D, E, F, G, H, I, J, K, L, M, N> get curried =>
      (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
          (k) => (l) => (m) => this(a, b, c, d, e, f, g, h, i, j, k, l, m);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M), N> get tupled =>
      (t) => t(this);
}

extension Function13COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on Function13C<A, B, C, D, E, F, G, H, I, J, K, L, M, N> {
  Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m);
}

extension Function14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> {
  Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, P> andThen<P>(
          Function1<O, P> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n));

  Function1<P, O> compose<P>(
          Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> fn) =>
      (p) => tupled(fn(p));

  Function14C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> get curried => (a) =>
      (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) => (k) =>
          (l) => (m) => (n) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N), O> get tupled =>
      (t) => t(this);
}

extension Function14COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on Function14C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> {
  Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n);
}

extension Function15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> {
  Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Q> andThen<Q>(
          Function1<P, Q> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o));

  Function1<Q, P> compose<Q>(
          Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> fn) =>
      (q) => tupled(fn(q));

  Function15C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> get curried =>
      (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
          (k) => (l) => (m) =>
              (n) => (o) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O), P> get tupled =>
      (t) => t(this);
}

extension Function15COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on Function15C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> {
  Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o);
}

extension Function16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> {
  Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, R> andThen<R>(
          Function1<Q, R> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p));

  Function1<R, Q> compose<R>(
          Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> fn) =>
      (q) => tupled(fn(q));

  Function16C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> get curried =>
      (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
          (k) => (l) => (m) => (n) => (o) =>
              (p) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P), Q> get tupled =>
      (t) => t(this);
}

extension Function16COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on Function16C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> {
  Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> get uncurried =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p);
}

extension Function17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> {
  Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, S> andThen<S>(
          Function1<R, S> fn) =>
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q));

  Function1<S, R> compose<S>(
          Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
              fn) =>
      (r) => tupled(fn(r));

  Function17C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
      get curried => (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) =>
          (i) => (j) => (k) => (l) => (m) => (n) => (o) => (p) =>
              (q) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q), R>
      get tupled => (t) => t(this);
}

extension Function17COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on Function17C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> {
  Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
      get uncurried => (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q);
}

extension Function18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> {
  Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, T>
      andThen<T>(Function1<S, T> fn) =>
          (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) =>
              fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r));

  Function1<T, S> compose<T>(
          Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
              fn) =>
      (r) => tupled(fn(r));

  Function18C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
      get curried => (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) =>
          (i) => (j) => (k) => (l) => (m) => (n) => (o) => (p) => (q) =>
              (r) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R), S>
      get tupled => (t) => t(this);
}

extension Function18COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
    S> on Function18C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> {
  Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
      get uncurried => (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)(r);
}

extension Function19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T>
    on Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> {
  Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, U>
      andThen<U>(Function1<T, U> fn) =>
          (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) =>
              fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s));

  Function1<U, T> compose<U>(
          Function1<U,
                  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
              fn) =>
      (r) => tupled(fn(r));

  Function19C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
      get curried =>
          (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
              (k) => (l) => (m) => (n) => (o) => (p) => (q) => (r) => (s) =>
                  this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S), T>
      get tupled => (t) => t(this);
}

extension Function19COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
        S, T>
    on Function19C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> {
  Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
      get uncurried =>
          (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) =>
              this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)(r)(s);
}

extension Function20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T, U>
    on Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U> {
  Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, V>
      andThen<V>(Function1<U, V> fn) => (a, b, c, d, e, f, g, h, i, j, k, l, m,
              n, o, p, q, r, s, t) =>
          fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t));

  Function1<V, U> compose<V>(
          Function1<V,
                  (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
              fn) =>
      (r) => tupled(fn(r));

  Function20C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
      get curried =>
          (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
              (k) => (l) => (m) => (n) => (o) => (p) => (q) => (r) => (s) => (t) =>
                  this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T), U>
      get tupled => (t) => t(this);
}

extension Function20COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
        S, T, U>
    on Function20C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U> {
  Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
      get uncurried =>
          (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t) =>
              this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)(r)(s)(t);
}

extension Function21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T, U, V>
    on Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
        V> {
  Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
      W> andThen<W>(Function1<V, W> fn) => (a, b, c, d, e, f, g, h, i, j, k, l,
          m, n, o, p, q, r, s, t, u) =>
      fn(this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u));

  Function1<W, V> compose<W>(
          Function1<
                  W,
                  (
                    A,
                    B,
                    C,
                    D,
                    E,
                    F,
                    G,
                    H,
                    I,
                    J,
                    K,
                    L,
                    M,
                    N,
                    O,
                    P,
                    Q,
                    R,
                    S,
                    T,
                    U
                  )>
              fn) =>
      (r) => tupled(fn(r));

  Function21C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
      get curried =>
          (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
              (k) => (l) => (m) => (n) => (o) => (p) => (q) => (r) => (s) => (t) =>
                  (u) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U), V>
      get tupled => (t) => t(this);
}

extension Function21COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
        S, T, U, V>
    on Function21C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V> {
  Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
      get uncurried => (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s,
              t, u) =>
          this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)(r)(s)(t)(u);
}

extension Function22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
        T, U, V, W>
    on Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
        V, W> {
  Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
      X> andThen<X>(Function1<W, X> fn) => (a, b, c, d, e, f, g, h, i, j, k, l,
          m, n, o, p, q, r, s, t, u, v) =>
      fn(this(
          a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v));

  Function1<X, W> compose<X>(
          Function1<
                  X,
                  (
                    A,
                    B,
                    C,
                    D,
                    E,
                    F,
                    G,
                    H,
                    I,
                    J,
                    K,
                    L,
                    M,
                    N,
                    O,
                    P,
                    Q,
                    R,
                    S,
                    T,
                    U,
                    V
                  )>
              fn) =>
      (r) => tupled(fn(r));

  Function22C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>
      get curried =>
          (a) => (b) => (c) => (d) => (e) => (f) => (g) => (h) => (i) => (j) =>
              (k) => (l) => (m) => (n) => (o) => (p) => (q) => (r) => (s) => (t) =>
                  (u) => (v) => this(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v);

  Function1<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V),
      W> get tupled => (t) => t(this);
}

extension Function22COps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R,
        S, T, U, V, W>
    on Function22C<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
        U, V, W> {
  Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
      W> get uncurried => (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r,
          s, t, u, v) =>
      this(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)(m)(n)(o)(p)(q)(r)(s)(t)(u)(v);
}
