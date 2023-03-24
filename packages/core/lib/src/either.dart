import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@immutable
abstract class Either<A, B> implements Monad<B>, Foldable<B> {
  const Either();

  static Either<A, B> left<A, B>(A a) => Left<A, B>(a);

  static Either<A, B> right<A, B>(B b) => Right<A, B>(b);

  static Either<A, B> catching<A, B>(
    Function0<B> body,
    Function2<Object, StackTrace, A> onError,
  ) {
    try {
      return right(body());
    } catch (err, stack) {
      return left(onError(err, stack));
    }
  }

  static Either<A, B> cond<A, B>(
    Function0<bool> test,
    Function0<B> ifTrue,
    Function0<A> ifFalse,
  ) =>
      test() ? right(ifTrue()) : left(ifFalse());

  static Either<A, B> pure<A, B>(B b) => Right(b);

  C fold<C>(Function1<A, C> fa, Function1<B, C> fb);

  @override
  Either<A, C> ap<C>(Either<A, Function1<B, C>> f) => fold((a) => left<A, C>(a),
      (b) => f.fold((a) => left<A, C>(a), (f) => right(f(b))));

  Either<C, D> bimap<C, D>(Function1<A, C> fa, Function1<B, D> fb) =>
      fold((a) => left<C, D>(fa(a)), (b) => right(fb(b)));

  bool contains(B elem) => fold((_) => false, (b) => elem == b);

  Either<A, B> ensure(Function1<B, bool> p, Function0<A> onFailure) =>
      fold((_) => this, (b) => p(b) ? this : left(onFailure()));

  Either<A, B> filterOrElse(Function1<B, bool> p, Function0<A> zero) =>
      fold((_) => left<A, B>(zero()), (b) => p(b) ? this : left(zero()));

  @override
  Either<A, C> flatMap<C>(covariant Function1<B, Either<A, C>> f) =>
      fold(left<A, C>, f);

  @override
  R2 foldLeft<R2>(R2 init, Function2<R2, B, R2> op) =>
      fold((_) => init, (r) => op(init, r));

  @override
  R2 foldRight<R2>(R2 init, Function2<B, R2, R2> op) =>
      fold((_) => init, (r) => op(r, init));

  B getOrElse(Function0<B> orElse) => fold((_) => orElse(), id);

  bool get isLeft => fold((_) => true, (_) => false);

  bool get isRight => !isLeft;

  Either<C, B> leftMap<C>(Function1<A, C> f) =>
      fold((a) => left<C, B>(f(a)), (b) => right<C, B>(b));

  @override
  Either<A, C> map<C>(Function1<B, C> f) =>
      fold(left<A, C>, (r) => Right(f(r)));

  Either<A, B> orElse(Function0<Either<A, B>> or) =>
      fold((a) => or(), (b) => this);

  Either<B, A> swap() => fold((a) => right<B, A>(a), (b) => left(b));

  IList<B> toIList() => fold((_) => nil<B>(), (b) => IList.pure(b));

  Option<B> toOption() => fold((_) => none<B>(), Some.new);

  Validated<A, B> toValidated() => fold((a) => a.invalid(), (b) => b.valid());

  @override
  String toString() => fold((a) => 'Left($a)', (b) => 'Right($b)');

  @override
  bool operator ==(Object other) => fold((a) => other is Left && a == other.a,
      (b) => other is Right && b == other.b);

  @override
  int get hashCode => fold((a) => a.hashCode, (b) => b.hashCode);

  static Either<A, Tuple2<B, C>> tupled2<A, B, C>(
    Either<A, B> eb,
    Either<A, C> ec,
  ) =>
      eb.flatMap((b) => ec.map((c) => Tuple2(b, c)));

  static Either<A, Tuple3<B, C, D>> tupled3<A, B, C, D>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
  ) =>
      tupled2(eb, ec).flatMap((t) => ed.map(t.append));

  static Either<A, Tuple4<B, C, D, E>> tupled4<A, B, C, D, E>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
  ) =>
      tupled3(eb, ec, ed).flatMap((t) => ee.map(t.append));

  static Either<A, Tuple5<B, C, D, E, F>> tupled5<A, B, C, D, E, F>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
  ) =>
      tupled4(eb, ec, ed, ee).flatMap((t) => ef.map(t.append));

  static Either<A, Tuple6<B, C, D, E, F, G>> tupled6<A, B, C, D, E, F, G>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
  ) =>
      tupled5(eb, ec, ed, ee, ef).flatMap((t) => eg.map(t.append));

  static Either<A, Tuple7<B, C, D, E, F, G, H>> tupled7<A, B, C, D, E, F, G, H>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
  ) =>
      tupled6(eb, ec, ed, ee, ef, eg).flatMap((t) => eh.map(t.append));

  static Either<A, Tuple8<B, C, D, E, F, G, H, I>>
      tupled8<A, B, C, D, E, F, G, H, I>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
  ) =>
          tupled7(eb, ec, ed, ee, ef, eg, eh).flatMap((t) => ei.map(t.append));

  static Either<A, Tuple9<B, C, D, E, F, G, H, I, J>> tupled9<A, B, C, D, E, F,
          G, H, I, J>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
  ) =>
      tupled8(eb, ec, ed, ee, ef, eg, eh, ei).flatMap((t) => ej.map(t.append));

  static Either<A, Tuple10<B, C, D, E, F, G, H, I, J, K>>
      tupled10<A, B, C, D, E, F, G, H, I, J, K>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
  ) =>
          tupled9(eb, ec, ed, ee, ef, eg, eh, ei, ej)
              .flatMap((t) => ek.map(t.append));

  static Either<A, Tuple11<B, C, D, E, F, G, H, I, J, K, L>>
      tupled11<A, B, C, D, E, F, G, H, I, J, K, L>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
  ) =>
          tupled10(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek)
              .flatMap((t) => el.map(t.append));

  static Either<A, Tuple12<B, C, D, E, F, G, H, I, J, K, L, M>>
      tupled12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
  ) =>
          tupled11(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el)
              .flatMap((t) => em.map(t.append));

  static Either<A, Tuple13<B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tupled13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
  ) =>
          tupled12(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em)
              .flatMap((t) => en.map(t.append));

  static Either<A, Tuple14<B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tupled14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
  ) =>
          tupled13(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en)
              .flatMap((t) => eo.map(t.append));

  static Either<A, Tuple15<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
      tupled15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
  ) =>
          tupled14(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo)
              .flatMap((t) => ep.map(t.append));

  static Either<A, Tuple16<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>>
      tupled16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
  ) =>
          tupled15(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep)
              .flatMap((t) => eq.map(t.append));

  static Either<A, Tuple17<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      tupled17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
  ) =>
          tupled16(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq)
              .flatMap((t) => er.map(t.append));

  static Either<A,
          Tuple18<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      tupled18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
  ) =>
          tupled17(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er)
              .flatMap((t) => es.map(t.append));

  static Either<A,
          Tuple19<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      tupled19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
  ) =>
          tupled18(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es)
              .flatMap((t) => et.map(t.append));

  static Either<A,
          Tuple20<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>>
      tupled20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
  ) =>
          tupled19(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es, et)
              .flatMap((t) => eu.map(t.append));

  static Either<
          A,
          Tuple21<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>>
      tupled21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
    Either<A, V> ev,
  ) =>
          tupled20(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es, et, eu)
              .flatMap((t) => ev.map(t.append));

  static Either<
          A,
          Tuple22<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
              W>>
      tupled22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
              W>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
    Either<A, V> ev,
    Either<A, W> ew,
  ) =>
          tupled21(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es, et, eu, ev)
              .flatMap((t) => ew.map(t.append));

  static Either<A, D> map2<A, B, C, D>(
    Either<A, B> eb,
    Either<A, C> ec,
    Function2<B, C, D> fn,
  ) =>
      tupled2(eb, ec).map(fn.tupled);

  static Either<A, E> map3<A, B, C, D, E>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Function3<B, C, D, E> fn,
  ) =>
      tupled3(eb, ec, ed).map(fn.tupled);

  static Either<A, F> map4<A, B, C, D, E, F>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Function4<B, C, D, E, F> fn,
  ) =>
      tupled4(eb, ec, ed, ee).map(fn.tupled);

  static Either<A, G> map5<A, B, C, D, E, F, G>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Function5<B, C, D, E, F, G> fn,
  ) =>
      tupled5(eb, ec, ed, ee, ef).map(fn.tupled);

  static Either<A, H> map6<A, B, C, D, E, F, G, H>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Function6<B, C, D, E, F, G, H> fn,
  ) =>
      tupled6(eb, ec, ed, ee, ef, eg).map(fn.tupled);

  static Either<A, I> map7<A, B, C, D, E, F, G, H, I>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Function7<B, C, D, E, F, G, H, I> fn,
  ) =>
      tupled7(eb, ec, ed, ee, ef, eg, eh).map(fn.tupled);

  static Either<A, J> map8<A, B, C, D, E, F, G, H, I, J>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Function8<B, C, D, E, F, G, H, I, J> fn,
  ) =>
      tupled8(eb, ec, ed, ee, ef, eg, eh, ei).map(fn.tupled);

  static Either<A, K> map9<A, B, C, D, E, F, G, H, I, J, K>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Function9<B, C, D, E, F, G, H, I, J, K> fn,
  ) =>
      tupled9(eb, ec, ed, ee, ef, eg, eh, ei, ej).map(fn.tupled);

  static Either<A, L> map10<A, B, C, D, E, F, G, H, I, J, K, L>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Function10<B, C, D, E, F, G, H, I, J, K, L> fn,
  ) =>
      tupled10(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek).map(fn.tupled);

  static Either<A, M> map11<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Function11<B, C, D, E, F, G, H, I, J, K, L, M> fn,
  ) =>
      tupled11(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el).map(fn.tupled);

  static Either<A, N> map12<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Function12<B, C, D, E, F, G, H, I, J, K, L, M, N> fn,
  ) =>
      tupled12(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em).map(fn.tupled);

  static Either<A, O> map13<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Function13<B, C, D, E, F, G, H, I, J, K, L, M, N, O> fn,
  ) =>
      tupled13(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en)
          .map(fn.tupled);

  static Either<A, P> map14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Function14<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> fn,
  ) =>
      tupled14(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo)
          .map(fn.tupled);

  static Either<A, Q> map15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Function15<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> fn,
  ) =>
      tupled15(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep)
          .map(fn.tupled);

  static Either<A, R> map16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,
          R>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Function16<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> fn,
  ) =>
      tupled16(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep, eq)
          .map(fn.tupled);

  static Either<A, S>
      map17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Function17<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> fn,
  ) =>
          tupled17(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er)
              .map(fn.tupled);

  static Either<A, T>
      map18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Function18<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> fn,
  ) =>
          tupled18(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es)
              .map(fn.tupled);

  static Either<A, U>
      map19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Function19<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> fn,
  ) =>
          tupled19(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es, et)
              .map(fn.tupled);

  static Either<A, V>
      map20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
    Function20<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        fn,
  ) =>
          tupled20(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep,
                  eq, er, es, et, eu)
              .map(fn.tupled);

  static Either<A, W> map21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,
          R, S, T, U, V, W>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
    Either<A, V> ev,
    Function21<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>
        fn,
  ) =>
      tupled21(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep, eq,
              er, es, et, eu, ev)
          .map(fn.tupled);

  static Either<A, X> map22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,
          R, S, T, U, V, W, X>(
    Either<A, B> eb,
    Either<A, C> ec,
    Either<A, D> ed,
    Either<A, E> ee,
    Either<A, F> ef,
    Either<A, G> eg,
    Either<A, H> eh,
    Either<A, I> ei,
    Either<A, J> ej,
    Either<A, K> ek,
    Either<A, L> el,
    Either<A, M> em,
    Either<A, N> en,
    Either<A, O> eo,
    Either<A, P> ep,
    Either<A, Q> eq,
    Either<A, R> er,
    Either<A, S> es,
    Either<A, T> et,
    Either<A, U> eu,
    Either<A, V> ev,
    Either<A, W> ew,
    Function22<B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W,
            X>
        fn,
  ) =>
      tupled22(eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, el, em, en, eo, ep, eq,
              er, es, et, eu, ev, ew)
          .map(fn.tupled);
}

class Left<A, B> extends Either<A, B> {
  final A a;

  const Left(this.a);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fa(a);
}

class Right<A, B> extends Either<A, B> {
  final B b;

  const Right(this.b);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fb(b);
}

extension EitherNestedOps<A, B> on Either<A, Either<A, B>> {
  Either<A, B> flatten() => fold((a) => Either.left<A, B>(a), id);
}
