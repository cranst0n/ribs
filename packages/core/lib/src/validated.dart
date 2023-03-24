import 'package:ribs_core/ribs_core.dart';

typedef ValidatedNel<E, A> = Validated<NonEmptyIList<E>, A>;

abstract class Validated<E, A> implements Functor<A> {
  static Validated<E, A> invalid<E, A>(E e) => Invalid(e);

  static Validated<E, A> valid<E, A>(A a) => Valid(a);

  B fold<B>(Function1<E, B> fe, Function1<A, B> fa);

  Validated<EE, AA> bimap<EE, AA>(Function1<E, EE> fe, Function1<A, AA> fa) =>
      fold((e) => fe(e).invalid(), (a) => fa(a).valid());

  bool exists(Function1<A, bool> p) => fold((_) => false, p);

  bool forall(Function1<A, bool> p) => fold((_) => true, p);

  A getOrElse(Function0<A> orElse) => fold((_) => orElse(), id);

  bool get isValid => fold((_) => false, (_) => true);

  bool get isInvalid => !isValid;

  Validated<EE, A> leftMap<EE>(Function1<E, EE> f) =>
      fold((e) => f(e).invalid(), (a) => a.valid());

  @override
  Validated<E, B> map<B>(Function1<A, B> f) =>
      fold((e) => e.invalid(), (a) => f(a).valid());

  Validated<E, A> orElse(Function0<Validated<E, A>> orElse) =>
      fold((_) => orElse(), (a) => this);

  Validated<A, E> swap() => fold((e) => e.valid(), (a) => a.invalid());

  Either<E, A> toEither() => fold((e) => e.asLeft(), (a) => a.asRight());

  IList<A> toIList() => fold((_) => nil(), (a) => IList.of([a]));

  Option<A> toOption() => fold((_) => none(), (a) => a.some);

  A valueOr(Function1<E, A> f) => fold(f, id);

  @override
  String toString() => fold((a) => 'Left($a)', (b) => 'Right($b)');

  @override
  bool operator ==(Object other) => fold(
        (e) => other is Invalid<E, A> && other.value == e,
        (a) => other is Valid<E, A> && other.value == a,
      );

  @override
  int get hashCode => fold((e) => e.hashCode, (a) => a.hashCode);

  static ValidatedNel<EE, Tuple2<A, B>> tupled2<EE, A, B>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
  ) =>
      va.product(vb);

  static ValidatedNel<EE, Tuple3<A, B, C>> tupled3<EE, A, B, C>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
  ) =>
      tupled2(va, vb).product(vc).map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple4<A, B, C, D>> tupled4<EE, A, B, C, D>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
  ) =>
      tupled3(va, vb, vc).product(vd).map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple5<A, B, C, D, E>> tupled5<EE, A, B, C, D, E>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
  ) =>
      tupled4(va, vb, vc, vd).product(ve).map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple6<A, B, C, D, E, F>>
      tupled6<EE, A, B, C, D, E, F>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
  ) =>
          tupled5(va, vb, vc, vd, ve).product(vf).map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple7<A, B, C, D, E, F, G>> tupled7<EE, A, B, C, D,
          E, F, G>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
  ) =>
      tupled6(va, vb, vc, vd, ve, vf).product(vg).map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple8<A, B, C, D, E, F, G, H>>
      tupled8<EE, A, B, C, D, E, F, G, H>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
  ) =>
          tupled7(va, vb, vc, vd, ve, vf, vg)
              .product(vh)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple9<A, B, C, D, E, F, G, H, I>>
      tupled9<EE, A, B, C, D, E, F, G, H, I>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
  ) =>
          tupled8(va, vb, vc, vd, ve, vf, vg, vh)
              .product(vi)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tupled10<EE, A, B, C, D, E, F, G, H, I, J>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
  ) =>
          tupled9(va, vb, vc, vd, ve, vf, vg, vh, vi)
              .product(vj)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
      tupled11<EE, A, B, C, D, E, F, G, H, I, J, K>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
  ) =>
          tupled10(va, vb, vc, vd, ve, vf, vg, vh, vi, vj)
              .product(vk)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
      tupled12<EE, A, B, C, D, E, F, G, H, I, J, K, L>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
  ) =>
          tupled11(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk)
              .product(vl)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tupled13<EE, A, B, C, D, E, F, G, H, I, J, K, L, M>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
  ) =>
          tupled12(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl)
              .product(vm)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tupled14<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
  ) =>
          tupled13(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm)
              .product(vn)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tupled15<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
  ) =>
          tupled14(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn)
              .product(vo)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE,
          Tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>>
      tupled16<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
  ) =>
          tupled15(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo)
              .product(vp)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE,
      Tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>> tupled17<EE,
          A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
  ) =>
      tupled16(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp)
          .product(vq)
          .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE,
          Tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>>
      tupled18<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
  ) =>
          tupled17(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq)
              .product(vr)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE,
          Tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>>
      tupled19<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
  ) =>
          tupled18(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr)
              .product(vs)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE,
          Tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>>
      tupled20<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
  ) =>
          tupled19(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr, vs)
              .product(vt)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<
          EE,
          Tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>>
      tupled21<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
    ValidatedNel<EE, U> vu,
  ) =>
          tupled20(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr, vs, vt)
              .product(vu)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<
          EE,
          Tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U,
              V>>
      tupled22<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
              U, V>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
    ValidatedNel<EE, U> vu,
    ValidatedNel<EE, V> vv,
  ) =>
          tupled21(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr, vs, vt, vu)
              .product(vv)
              .map((t) => t.$1.append(t.$2));

  static ValidatedNel<EE, C> map2<EE, A, B, C>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    Function2<A, B, C> f,
  ) =>
      tupled2(va, vb).map(f.tupled);

  static ValidatedNel<EE, D> map3<EE, A, B, C, D>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    Function3<A, B, C, D> f,
  ) =>
      tupled3(va, vb, vc).map(f.tupled);

  static ValidatedNel<EE, E> map4<EE, A, B, C, D, E>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    Function4<A, B, C, D, E> f,
  ) =>
      tupled4(va, vb, vc, vd).map(f.tupled);

  static ValidatedNel<EE, F> map5<EE, A, B, C, D, E, F>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    Function5<A, B, C, D, E, F> f,
  ) =>
      tupled5(va, vb, vc, vd, ve).map(f.tupled);

  static ValidatedNel<EE, G> map6<EE, A, B, C, D, E, F, G>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    Function6<A, B, C, D, E, F, G> f,
  ) =>
      tupled6(va, vb, vc, vd, ve, vf).map(f.tupled);

  static ValidatedNel<EE, H> map7<EE, A, B, C, D, E, F, G, H>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    Function7<A, B, C, D, E, F, G, H> f,
  ) =>
      tupled7(va, vb, vc, vd, ve, vf, vg).map(f.tupled);

  static ValidatedNel<EE, I> map8<EE, A, B, C, D, E, F, G, H, I>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    Function8<A, B, C, D, E, F, G, H, I> f,
  ) =>
      tupled8(va, vb, vc, vd, ve, vf, vg, vh).map(f.tupled);

  static ValidatedNel<EE, J> map9<EE, A, B, C, D, E, F, G, H, I, J>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    Function9<A, B, C, D, E, F, G, H, I, J> f,
  ) =>
      tupled9(va, vb, vc, vd, ve, vf, vg, vh, vi).map(f.tupled);

  static ValidatedNel<EE, K> map10<EE, A, B, C, D, E, F, G, H, I, J, K>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    Function10<A, B, C, D, E, F, G, H, I, J, K> f,
  ) =>
      tupled10(va, vb, vc, vd, ve, vf, vg, vh, vi, vj).map(f.tupled);

  static ValidatedNel<EE, L> map11<EE, A, B, C, D, E, F, G, H, I, J, K, L>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> f,
  ) =>
      tupled11(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk).map(f.tupled);

  static ValidatedNel<EE, M> map12<EE, A, B, C, D, E, F, G, H, I, J, K, L, M>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> f,
  ) =>
      tupled12(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl).map(f.tupled);

  static ValidatedNel<EE, N>
      map13<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> f,
  ) =>
          tupled13(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm)
              .map(f.tupled);

  static ValidatedNel<EE, O>
      map14<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> f,
  ) =>
          tupled14(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn)
              .map(f.tupled);

  static ValidatedNel<EE, P>
      map15<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> f,
  ) =>
          tupled15(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo)
              .map(f.tupled);

  static ValidatedNel<EE, Q> map16<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
          O, P, Q>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> f,
  ) =>
      tupled16(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp)
          .map(f.tupled);

  static ValidatedNel<EE, R>
      map17<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> f,
  ) =>
          tupled17(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq)
              .map(f.tupled);

  static ValidatedNel<EE, S>
      map18<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> f,
  ) =>
          tupled18(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr)
              .map(f.tupled);

  static ValidatedNel<EE, T>
      map19<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> f,
  ) =>
          tupled19(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr, vs)
              .map(f.tupled);

  static ValidatedNel<EE, U>
      map20<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> f,
  ) =>
          tupled20(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo,
                  vp, vq, vr, vs, vt)
              .map(f.tupled);

  static ValidatedNel<EE, V> map21<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
          O, P, Q, R, S, T, U, V>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
    ValidatedNel<EE, U> vu,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        f,
  ) =>
      tupled21(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp,
              vq, vr, vs, vt, vu)
          .map(f.tupled);

  static ValidatedNel<EE, W> map22<EE, A, B, C, D, E, F, G, H, I, J, K, L, M, N,
          O, P, Q, R, S, T, U, V, W>(
    ValidatedNel<EE, A> va,
    ValidatedNel<EE, B> vb,
    ValidatedNel<EE, C> vc,
    ValidatedNel<EE, D> vd,
    ValidatedNel<EE, E> ve,
    ValidatedNel<EE, F> vf,
    ValidatedNel<EE, G> vg,
    ValidatedNel<EE, H> vh,
    ValidatedNel<EE, I> vi,
    ValidatedNel<EE, J> vj,
    ValidatedNel<EE, K> vk,
    ValidatedNel<EE, L> vl,
    ValidatedNel<EE, M> vm,
    ValidatedNel<EE, N> vn,
    ValidatedNel<EE, O> vo,
    ValidatedNel<EE, P> vp,
    ValidatedNel<EE, Q> vq,
    ValidatedNel<EE, R> vr,
    ValidatedNel<EE, S> vs,
    ValidatedNel<EE, T> vt,
    ValidatedNel<EE, U> vu,
    ValidatedNel<EE, V> vv,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
            W>
        f,
  ) =>
      tupled22(va, vb, vc, vd, ve, vf, vg, vh, vi, vj, vk, vl, vm, vn, vo, vp,
              vq, vr, vs, vt, vu, vv)
          .map(f.tupled);
}

class Valid<E, A> extends Validated<E, A> {
  final A value;

  Valid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fa(value);
}

class Invalid<E, A> extends Validated<E, A> {
  final E value;

  Invalid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fe(value);
}

extension ValidatedNelOps<E, A> on ValidatedNel<E, A> {
  ValidatedNel<E, B> ap<B>(ValidatedNel<E, Function1<A, B>> f) {
    return fold(
      (e) => f.fold(
        (ef) => e.concatNel(ef).invalid(),
        (af) => e.invalid(),
      ),
      (a) => f.fold(
        (ef) => ef.invalid(),
        (af) => af(a).validNel<E>(),
      ),
    );
  }

  ValidatedNel<E, Tuple2<A, B>> product<B>(ValidatedNel<E, B> f) {
    return fold(
      (e) => f.fold(
        (ef) => e.concatNel(ef).invalid(),
        (af) => e.invalid(),
      ),
      (a) => f.fold(
        (ef) => ef.invalid(),
        (af) => Tuple2(a, af).validNel<E>(),
      ),
    );
  }
}
