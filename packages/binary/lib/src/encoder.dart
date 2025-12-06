import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

typedef EncodeF<A> = Function1<A, Either<Err, BitVector>>;

abstract mixin class Encoder<A> {
  static Encoder<A> instance<A>(EncodeF<A> encode) => _EncoderF(encode);

  static Either<Err, BitVector> encodeBoth<A, B>(
    Encoder<A> encodeA,
    A a,
    Encoder<B> encodeB,
    B b,
  ) => encodeA.encode(a).flatMap((bvA) => encodeB.encode(b).map((bvB) => bvA.concat(bvB)));

  Either<Err, BitVector> encode(A a);

  Encoder<B> contramap<B>(Function1<B, A> f) => Encoder.instance<B>((b) => encode(f(b)));

  Either<Err, BitVector> encodeAll(Iterable<A> as) => as.fold(
    Either.right(BitVector.empty),
    (acc, a) => encode(a).flatMap((res) => acc.map((acc) => acc.concat(res))),
  );

  static Encoder<(A, B)> tuple2<A, B>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
  ) => _EncoderF(
    (tuple) => encodeA.encode(tuple.$1).flatMap((a) => encodeB.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C)> tuple3<A, B, C>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
  ) => _EncoderF(
    (tuple) => tuple2(
      encodeA,
      encodeB,
    ).encode(tuple.init()).flatMap((a) => encodeC.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D)> tuple4<A, B, C, D>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
  ) => _EncoderF(
    (tuple) => tuple3(
      encodeA,
      encodeB,
      encodeC,
    ).encode(tuple.init()).flatMap((a) => encodeD.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
  ) => _EncoderF(
    (tuple) => tuple4(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
    ).encode(tuple.init()).flatMap((a) => encodeE.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
  ) => _EncoderF(
    (tuple) => tuple5(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
    ).encode(tuple.init()).flatMap((a) => encodeF.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
  ) => _EncoderF(
    (tuple) => tuple6(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
    ).encode(tuple.init()).flatMap((a) => encodeG.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
  ) => _EncoderF(
    (tuple) => tuple7(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
    ).encode(tuple.init()).flatMap((a) => encodeH.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
  ) => _EncoderF(
    (tuple) => tuple8(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
    ).encode(tuple.init()).flatMap((a) => encodeI.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
  ) => _EncoderF(
    (tuple) => tuple9(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
    ).encode(tuple.init()).flatMap((a) => encodeJ.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
  ) => _EncoderF(
    (tuple) => tuple10(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
    ).encode(tuple.init()).flatMap((a) => encodeK.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
  ) => _EncoderF(
    (tuple) => tuple11(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
    ).encode(tuple.init()).flatMap((a) => encodeL.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
  tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
  ) => _EncoderF(
    (tuple) => tuple12(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
    ).encode(tuple.init()).flatMap((a) => encodeM.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
  tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
  ) => _EncoderF(
    (tuple) => tuple13(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
    ).encode(tuple.init()).flatMap((a) => encodeN.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
  tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
  ) => _EncoderF(
    (tuple) => tuple14(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
    ).encode(tuple.init()).flatMap((a) => encodeO.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
  tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
  ) => _EncoderF(
    (tuple) => tuple15(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
    ).encode(tuple.init()).flatMap((a) => encodeP.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
  tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
  ) => _EncoderF(
    (tuple) => tuple16(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
    ).encode(tuple.init()).flatMap((a) => encodeQ.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
  tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
  ) => _EncoderF(
    (tuple) => tuple17(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
    ).encode(tuple.init()).flatMap((a) => encodeR.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
  tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
  ) => _EncoderF(
    (tuple) => tuple18(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
    ).encode(tuple.init()).flatMap((a) => encodeS.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
  tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
  ) => _EncoderF(
    (tuple) => tuple19(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
    ).encode(tuple.init()).flatMap((a) => encodeT.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
  tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
    Encoder<U> encodeU,
  ) => _EncoderF(
    (tuple) => tuple20(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
      encodeT,
    ).encode(tuple.init()).flatMap((a) => encodeU.encode(tuple.last).map(a.concat)),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
  tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
    Encoder<U> encodeU,
    Encoder<V> encodeV,
  ) => _EncoderF(
    (tuple) => tuple21(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
      encodeT,
      encodeU,
    ).encode(tuple.init()).flatMap((a) => encodeV.encode(tuple.last).map(a.concat)),
  );
}

final class _EncoderF<A> extends Encoder<A> {
  final EncodeF<A> _encodeF;

  _EncoderF(this._encodeF);

  @override
  Either<Err, BitVector> encode(A a) => _encodeF(a);
}
