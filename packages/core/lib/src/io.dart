import 'dart:async';
import 'dart:io' show stderr, stdout;
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

typedef IOError = Tuple2<Object, StackTrace>;

@immutable
class IO<A> implements Monad<A> {
  final Function0<Future<A>> _run;

  const IO(this._run);

  static IO<A> async<A>(Function0<A> thunk) =>
      IO(() => Future.microtask(thunk));

  static IO<A> failed<A>(Object err, [StackTrace? stacktrace]) =>
      IO(() => Future.error(err, stacktrace));

  static IO<A> fromEither<A>(Either<Object, A> either) =>
      either.fold((a) => IO.failed<A>(a), IO.pure);

  static IO<A> fromFuture<A>(Function0<Future<A>> thunk) => IO(() => thunk());

  static IO<Unit> print(String message) =>
      IO.sync(() => stdout.writeln(message)).voided;

  static IO<Unit> printErr(String message) =>
      IO.sync(() => stderr.writeln(message)).voided;

  static IO<A> pure<A>(A a) => IO(() => Future.value(a));

  static IO<Either<A, B>> race<A, B>(IO<A> left, IO<B> right) => IO(() async {
        final f = await Future.any([
          left._run().then((value) => Tuple2(0, value)),
          right._run().then((value) => Tuple2(1, value)),
        ]);

        if (f is Tuple2<int, A> && f.$1 == 0) {
          return Left(f.$2);
        } else if (f is Tuple2<int, B> && f.$1 == 1) {
          return Right(f.$2);
        } else {
          throw TypeError();
        }
      });

  static IO<Unit> sleep(Duration duration) =>
      IO.fromFuture(() => Future.delayed(duration, () => Unit()));

  static IO<A> isolate<A>(Function0<FutureOr<A>> thunk,
          {String? isolateName}) =>
      IO(() => Isolate.run(thunk, debugName: isolateName));

  static IO<A> sync<A>(Function0<A> thunk) => IO(() => Future.sync(thunk));

  static IO<Unit> get unit => IO.pure(Unit());

  @override
  IO<B> ap<B>(IO<Function1<A, B>> f) => flatMap((a) => f.map((f) => f(a)));

  IO<A> andWait(Duration duration) => flatTap((_) => IO.sleep(duration));

  IO<B> as<B>(B b) => map((_) => b);

  IO<Either<IOError, A>> attempt() =>
      IO(() => _run().then((a) => Either.right<IOError, A>(a)).catchError(
          (Object err, StackTrace? stackTrace) => Either.left<IOError, A>(
              Tuple2(err, stackTrace ?? StackTrace.current))));

  IO<Tuple2<A, B>> both<B>(IO<B> that) => IO(
        () => Future.wait([_run(), that._run()], eagerError: true)
            .then((value) => Tuple2(value[0] as A, value[1] as B)),
      );

  IO<B> bracket<B>(Function1<A, IO<B>> use, Function1<A, IO<Unit>> release) =>
      flatMap((a) => use(a).guarantee(release(a)));

  IO<A> debug({String prefix = 'DEBUG'}) =>
      flatTap((a) => IO.print('$prefix: $a'));

  IO<A> delayBy(Duration duration) => sleep(duration).productR(this);

  IO<A> flatTap<B>(Function1<A, IO<B>> f) => flatMap((a) => f(a).as(a));

  @override
  IO<B> flatMap<B>(covariant Function1<A, IO<B>> f) =>
      IO(() => _run().then((a) => f(a)._run()));

  IO<A> guarantee(IO<Unit> finalizer) =>
      IO(() => _run().whenComplete(() => finalizer._run()));

  IO<A> handleError(Function1<IOError, A> f) =>
      attempt().map((a) => a.fold(f, id));

  IO<A> handleErrorWith(Function1<IOError, IO<A>> f) =>
      attempt().flatMap((a) => a.fold(f, IO.pure));

  IO<A> iterateUntil(Function1<A, bool> predicate) =>
      flatMap((a) => predicate(a) ? IO.pure(a) : this);

  IO<A> iterateWhile(Function1<A, bool> predicate) =>
      iterateUntil((a) => !predicate(a));

  @override
  IO<B> map<B>(Function1<A, B> f) => IO(() => _run().then(f));

  IO<IO<A>> get memoize => IO.sync(() => _MemoizedIO.fromFuture(_run));

  IO<Option<A>> get option => attempt().map((a) => a.toOption);

  IO<A> orElse(IO<A> other) => handleErrorWith((_) => other);

  /// NOTE: This operation can fail if the type of the IO can not be send
  /// across Isolate boundaries: See also: https://api.dart.dev/stable/2.19.1/dart-isolate/SendPort/send.html
  IO<A> onIsolate({String? isolateName}) =>
      IO.isolate(() => _run(), isolateName: isolateName);

  IO<A> productL<B>(IO<B> that) => flatMap((a) => that.as(a));

  IO<B> productR<B>(IO<B> that) => flatMap((_) => that);

  IO<B> redeem<B>(Function1<IOError, B> recover, Function1<A, B> map) =>
      attempt().map((a) => a.fold(recover, map));

  IO<B> redeemWith<B>(
          Function1<IOError, IO<B>> recover, Function1<A, IO<B>> bind) =>
      attempt().flatMap((a) => a.fold(recover, bind));

  IO<IList<A>> replicate(int n) => IList.fill(n, this).sequence;

  IO<IOHandle<A>> start() => IOHandle.fromIO(this);

  IO<Tuple2<Duration, A>> get timed => IO(() {
        final sw = Stopwatch()..start();
        return _run().then((a) => Tuple2(sw.elapsed, a));
      });

  IO<A> timeout(Duration timeLimit) => IO(() => _run().timeout(timeLimit));

  IO<A> timeoutTo(Duration timeLimit, IO<A> fallback) =>
      timeout(timeLimit).redeemWith(
          (err) => err is TimeoutException ? fallback : IO.failed(err),
          IO.pure);

  Future<A> unsafeRun() => _run();

  Future<Unit> unsafeRunAndForget() => voided._run();

  IO<Unit> get voided => as(Unit());

  static IO<Tuple2<A, B>> tupled2<A, B>(IO<A> a, IO<B> b) =>
      a.flatMap((a) => b.map((b) => Tuple2(a, b)));

  static IO<Tuple3<A, B, C>> tupled3<A, B, C>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
  ) =>
      tupled2(a, b).flatMap((t) => c.map(t.append));

  static IO<Tuple4<A, B, C, D>> tupled4<A, B, C, D>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
  ) =>
      tupled3(a, b, c).flatMap((t) => d.map(t.append));

  static IO<Tuple5<A, B, C, D, E>> tupled5<A, B, C, D, E>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
  ) =>
      tupled4(a, b, c, d).flatMap((t) => e.map(t.append));

  static IO<Tuple6<A, B, C, D, E, F>> tupled6<A, B, C, D, E, F>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
  ) =>
      tupled5(a, b, c, d, e).flatMap((t) => f.map(t.append));

  static IO<Tuple7<A, B, C, D, E, F, G>> tupled7<A, B, C, D, E, F, G>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
  ) =>
      tupled6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

  static IO<Tuple8<A, B, C, D, E, F, G, H>> tupled8<A, B, C, D, E, F, G, H>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
  ) =>
      tupled7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

  static IO<Tuple9<A, B, C, D, E, F, G, H, I>>
      tupled9<A, B, C, D, E, F, G, H, I>(
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
          tupled8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

  static IO<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tupled10<A, B, C, D, E, F, G, H, I, J>(
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
          tupled9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

  static IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>> tupled11<A, B, C, D, E, F,
          G, H, I, J, K>(
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
      tupled10(a, b, c, d, e, f, g, h, i, j).flatMap((t) => k.map(t.append));

  static IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> tupled12<A, B, C, D, E,
          F, G, H, I, J, K, L>(
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
      tupled11(a, b, c, d, e, f, g, h, i, j, k).flatMap((t) => l.map(t.append));

  static IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
          tupled12(a, b, c, d, e, f, g, h, i, j, k, l)
              .flatMap((t) => m.map(t.append));

  static IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
          tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
              .flatMap((t) => n.map(t.append));

  static IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
          tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
              .flatMap((t) => o.map(t.append));

  static IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
      tupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
          tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
              .flatMap((t) => p.map(t.append));

  static IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
      tupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
          tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
              .flatMap((t) => q.map(t.append));

  static IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      tupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
          tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
              .flatMap((t) => r.map(t.append));

  static IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      tupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
          tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
              .flatMap((t) => s.map(t.append));

  static IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      tupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
          tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .flatMap((tup) => t.map(tup.append));

  static IO<
          Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>>
      tupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
          tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
              .flatMap((tup) => u.map(tup.append));

  static IO<
          Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>>
      tupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
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
          tupled21(
                  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
              .flatMap((tup) => v.map(tup.append));

  static IO<C> map2<A, B, C>(IO<A> a, IO<B> b, Function2<A, B, C> fn) =>
      tupled2(a, b).map(fn.tupled);

  static IO<D> map3<A, B, C, D>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    Function3<A, B, C, D> fn,
  ) =>
      tupled3(a, b, c).map(fn.tupled);

  static IO<E> map4<A, B, C, D, E>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    Function4<A, B, C, D, E> fn,
  ) =>
      tupled4(a, b, c, d).map(fn.tupled);

  static IO<F> map5<A, B, C, D, E, F>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    Function5<A, B, C, D, E, F> fn,
  ) =>
      tupled5(a, b, c, d, e).map(fn.tupled);

  static IO<G> map6<A, B, C, D, E, F, G>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    Function6<A, B, C, D, E, F, G> fn,
  ) =>
      tupled6(a, b, c, d, e, f).map(fn.tupled);

  static IO<H> map7<A, B, C, D, E, F, G, H>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    Function7<A, B, C, D, E, F, G, H> fn,
  ) =>
      tupled7(a, b, c, d, e, f, g).map(fn.tupled);

  static IO<I> map8<A, B, C, D, E, F, G, H, I>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
    Function8<A, B, C, D, E, F, G, H, I> fn,
  ) =>
      tupled8(a, b, c, d, e, f, g, h).map(fn.tupled);

  static IO<J> map9<A, B, C, D, E, F, G, H, I, J>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
    IO<I> i,
    Function9<A, B, C, D, E, F, G, H, I, J> fn,
  ) =>
      tupled9(a, b, c, d, e, f, g, h, i).map(fn.tupled);

  static IO<K> map10<A, B, C, D, E, F, G, H, I, J, K>(
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
    Function10<A, B, C, D, E, F, G, H, I, J, K> fn,
  ) =>
      tupled10(a, b, c, d, e, f, g, h, i, j).map(fn.tupled);

  static IO<L> map11<A, B, C, D, E, F, G, H, I, J, K, L>(
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
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn,
  ) =>
      tupled11(a, b, c, d, e, f, g, h, i, j, k).map(fn.tupled);

  static IO<M> map12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn,
  ) =>
      tupled12(a, b, c, d, e, f, g, h, i, j, k, l).map(fn.tupled);

  static IO<N> map13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn,
  ) =>
      tupled13(a, b, c, d, e, f, g, h, i, j, k, l, m).map(fn.tupled);

  static IO<O> map14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn,
  ) =>
      tupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n).map(fn.tupled);

  static IO<P> map15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn,
  ) =>
      tupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o).map(fn.tupled);

  static IO<Q> map16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn,
  ) =>
      tupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p).map(fn.tupled);

  static IO<R> map17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> fn,
  ) =>
      tupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
          .map(fn.tupled);

  static IO<S> map18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> fn,
  ) =>
      tupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
          .map(fn.tupled);

  static IO<T>
      map19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> fn,
  ) =>
          tupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .map(fn.tupled);

  static IO<U>
      map20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
        fn,
  ) =>
          tupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
              .map(fn.tupled);

  static IO<V> map21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
          U, V>(
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
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        fn,
  ) =>
      tupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
          .map(fn.tupled);

  static IO<W> map22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
          U, V, W>(
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
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
            W>
        fn,
  ) =>
      tupled22(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v)
          .map(fn.tupled);

  static IO<Tuple2<A, B>> parTupled2<A, B>(IO<A> a, IO<B> b) => a.both(b);

  static IO<Tuple3<A, B, C>> parTupled3<A, B, C>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
  ) =>
      parTupled2(a, b).both(c).map((t) => t.$1.append(t.$2));

  static IO<Tuple4<A, B, C, D>> parTupled4<A, B, C, D>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
  ) =>
      parTupled3(a, b, c).both(d).map((t) => t.$1.append(t.$2));

  static IO<Tuple5<A, B, C, D, E>> parTupled5<A, B, C, D, E>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
  ) =>
      parTupled4(a, b, c, d).both(e).map((t) => t.$1.append(t.$2));

  static IO<Tuple6<A, B, C, D, E, F>> parTupled6<A, B, C, D, E, F>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
  ) =>
      parTupled5(a, b, c, d, e).both(f).map((t) => t.$1.append(t.$2));

  static IO<Tuple7<A, B, C, D, E, F, G>> parTupled7<A, B, C, D, E, F, G>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
  ) =>
      parTupled6(a, b, c, d, e, f).both(g).map((t) => t.$1.append(t.$2));

  static IO<Tuple8<A, B, C, D, E, F, G, H>> parTupled8<A, B, C, D, E, F, G, H>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
  ) =>
      parTupled7(a, b, c, d, e, f, g).both(h).map((t) => t.$1.append(t.$2));

  static IO<Tuple9<A, B, C, D, E, F, G, H, I>> parTupled9<A, B, C, D, E, F, G,
          H, I>(
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
      parTupled8(a, b, c, d, e, f, g, h).both(i).map((t) => t.$1.append(t.$2));

  static IO<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      parTupled10<A, B, C, D, E, F, G, H, I, J>(
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
          parTupled9(a, b, c, d, e, f, g, h, i)
              .both(j)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
      parTupled11<A, B, C, D, E, F, G, H, I, J, K>(
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
          parTupled10(a, b, c, d, e, f, g, h, i, j)
              .both(k)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
      parTupled12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
          parTupled11(a, b, c, d, e, f, g, h, i, j, k)
              .both(l)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      parTupled13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
          parTupled12(a, b, c, d, e, f, g, h, i, j, k, l)
              .both(m)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      parTupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
          parTupled13(a, b, c, d, e, f, g, h, i, j, k, l, m)
              .both(n)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      parTupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
          parTupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
              .both(o)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
      parTupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
          parTupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
              .both(p)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
      parTupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
          parTupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
              .both(q)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      parTupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
          parTupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
              .both(r)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      parTupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
          parTupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
              .both(s)
              .map((t) => t.$1.append(t.$2));

  static IO<Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      parTupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
          parTupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .both(t)
              .map((t) => t.$1.append(t.$2));

  static IO<
          Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>>
      parTupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>(
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
          parTupled20(
                  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
              .both(u)
              .map((t) => t.$1.append(t.$2));

  static IO<
          Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>>
      parTupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
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
          parTupled21(
                  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
              .both(v)
              .map((t) => t.$1.append(t.$2));

  static IO<C> parMap2<A, B, C>(
    IO<A> a,
    IO<B> b,
    Function2<A, B, C> fn,
  ) =>
      parTupled2(a, b).map(fn.tupled);

  static IO<D> parMap3<A, B, C, D>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    Function3<A, B, C, D> fn,
  ) =>
      parTupled3(a, b, c).map(fn.tupled);

  static IO<E> parMap4<A, B, C, D, E>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    Function4<A, B, C, D, E> fn,
  ) =>
      parTupled4(a, b, c, d).map(fn.tupled);

  static IO<F> parMap5<A, B, C, D, E, F>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    Function5<A, B, C, D, E, F> fn,
  ) =>
      parTupled5(a, b, c, d, e).map(fn.tupled);

  static IO<G> parMap6<A, B, C, D, E, F, G>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    Function6<A, B, C, D, E, F, G> fn,
  ) =>
      parTupled6(a, b, c, d, e, f).map(fn.tupled);

  static IO<H> parMap7<A, B, C, D, E, F, G, H>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    Function7<A, B, C, D, E, F, G, H> fn,
  ) =>
      parTupled7(a, b, c, d, e, f, g).map(fn.tupled);

  static IO<I> parMap8<A, B, C, D, E, F, G, H, I>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
    Function8<A, B, C, D, E, F, G, H, I> fn,
  ) =>
      parTupled8(a, b, c, d, e, f, g, h).map(fn.tupled);

  static IO<J> parMap9<A, B, C, D, E, F, G, H, I, J>(
    IO<A> a,
    IO<B> b,
    IO<C> c,
    IO<D> d,
    IO<E> e,
    IO<F> f,
    IO<G> g,
    IO<H> h,
    IO<I> i,
    Function9<A, B, C, D, E, F, G, H, I, J> fn,
  ) =>
      parTupled9(a, b, c, d, e, f, g, h, i).map(fn.tupled);

  static IO<K> parMap10<A, B, C, D, E, F, G, H, I, J, K>(
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
    Function10<A, B, C, D, E, F, G, H, I, J, K> fn,
  ) =>
      parTupled10(a, b, c, d, e, f, g, h, i, j).map(fn.tupled);

  static IO<L> parMap11<A, B, C, D, E, F, G, H, I, J, K, L>(
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
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> fn,
  ) =>
      parTupled11(a, b, c, d, e, f, g, h, i, j, k).map(fn.tupled);

  static IO<M> parMap12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> fn,
  ) =>
      parTupled12(a, b, c, d, e, f, g, h, i, j, k, l).map(fn.tupled);

  static IO<N> parMap13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> fn,
  ) =>
      parTupled13(a, b, c, d, e, f, g, h, i, j, k, l, m).map(fn.tupled);

  static IO<O> parMap14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn,
  ) =>
      parTupled14(a, b, c, d, e, f, g, h, i, j, k, l, m, n).map(fn.tupled);

  static IO<P> parMap15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn,
  ) =>
      parTupled15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o).map(fn.tupled);

  static IO<Q> parMap16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn,
  ) =>
      parTupled16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
          .map(fn.tupled);

  static IO<R> parMap17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> fn,
  ) =>
      parTupled17(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
          .map(fn.tupled);

  static IO<S>
      parMap18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> fn,
  ) =>
          parTupled18(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
              .map(fn.tupled);

  static IO<T>
      parMap19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> fn,
  ) =>
          parTupled19(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s)
              .map(fn.tupled);

  static IO<U> parMap20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
          T, U>(
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
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
        fn,
  ) =>
      parTupled20(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t)
          .map(fn.tupled);

  static IO<V> parMap21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
          T, U, V>(
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
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        fn,
  ) =>
      parTupled21(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
          .map(fn.tupled);

  static IO<W> parMap22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
          T, U, V, W>(
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
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
            W>
        fn,
  ) =>
      parTupled22(
              a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v)
          .map(fn.tupled);
}

extension IOFlattenOps<A> on IO<IO<A>> {
  IO<A> get flatten => flatMap(id);
}

extension IOBoolOps on IO<bool> {
  IO<B> ifM<B>(IO<B> ifTrue, IO<B> ifFalse) =>
      flatMap((pred) => pred ? ifTrue : ifFalse);
}

class IOHandle<A> {
  final CancelableCompleter<A> _completer;

  const IOHandle._(this._completer);

  static IO<IOHandle<A>> fromIO<A>(IO<A> io) => IO.async(() {
        final completer = CancelableCompleter<A>();
        completer.completeOperation(CancelableOperation.fromFuture(io._run()));

        return IOHandle._(completer);
      });

  IO<Unit> cancel() =>
      IO.fromFuture(() => _completer.operation.cancel()).voided;

  IO<Outcome<A>> join() {
    return IO
        .fromFuture(() => _completer.operation.valueOrCancellation())
        .attempt()
        .map((attempt) => attempt.fold(
              (err) => Errored<A>(err),
              (maybeResult) =>
                  maybeResult == null ? Cancelled<A>() : Succeeded(maybeResult),
            ));
  }
}

abstract class Outcome<A> {
  const Outcome();

  B fold<B>(
    Function0<B> cancelled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  );

  bool get isCancelled => fold(() => true, (_) => false, (_) => false);
  bool get isError => fold(() => false, (_) => true, (_) => false);
  bool get isSuccess => fold(() => false, (_) => false, (_) => true);

  @override
  String toString() => fold(
        () => 'Cancelled',
        (err) => 'Errored($err)',
        (value) => 'Succeeded($value)',
      );

  @override
  bool operator ==(dynamic other);

  @override
  int get hashCode;
}

class Succeeded<A> extends Outcome<A> {
  final A value;

  const Succeeded(this.value);

  @override
  B fold<B>(
    Function0<B> cancelled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  ) =>
      succeeded(value);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Succeeded && other.value == this.value);

  @override
  int get hashCode => value.hashCode;
}

class Errored<A> extends Outcome<A> {
  final IOError error;

  const Errored(this.error);

  @override
  B fold<B>(
    Function0<B> cancelled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  ) =>
      errored(error);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || (other is Errored && other.error == this.error);

  @override
  int get hashCode => error.hashCode;
}

class Cancelled<A> extends Outcome<A> {
  const Cancelled();

  @override
  B fold<B>(
    Function0<B> cancelled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  ) =>
      cancelled();

  @override
  bool operator ==(dynamic other) => other is Cancelled;

  @override
  int get hashCode => 0;
}

class _MemoizedIO<A> extends IO<A> {
  // ignore: unused_field
  final AsyncMemoizer<A> _memo;

  const _MemoizedIO(this._memo, super._run);

  factory _MemoizedIO.fromFuture(Function0<Future<A>> run) {
    final memo = AsyncMemoizer<A>();
    return _MemoizedIO(memo, () => memo.runOnce(cast(() => run())));
  }
}
