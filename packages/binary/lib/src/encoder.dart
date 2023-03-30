import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

typedef EncodeF<A> = Function1<A, Either<Err, BitVector>>;

abstract class Encoder<A> {
  static Encoder<A> instance<A>(EncodeF<A> encode) => EncoderF(encode);

  static Either<Err, BitVector> encodeBoth<A, B>(
          Encoder<A> encodeA, A a, Encoder<B> encodeB, B b) =>
      encodeA
          .encode(a)
          .flatMap((bvA) => encodeB.encode(b).map((bvB) => bvA.concat(bvB)));

  Either<Err, BitVector> encode(A a);

  Encoder<B> contramap<B>(Function1<B, A> f) =>
      Encoder.instance<B>((b) => encode(f(b)));

  Either<Err, BitVector> encodeAll(Iterable<A> as) => as.fold(
      Either.right(BitVector.empty()),
      (acc, a) =>
          encode(a).flatMap((res) => acc.map((acc) => acc.concat(res))));

  static Encoder<(A, B)> tuple2<A, B>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
  ) =>
      EncoderF((tuple) => encodeA
          .encode(tuple.$1)
          .flatMap((a) => encodeB.encode(tuple.$2).map(a.concat)));

  static Encoder<(A, B, C)> tuple3<A, B, C>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
  ) =>
      EncoderF((tuple) => tuple2(encodeA, encodeB)
          .encode(tuple.init())
          .flatMap((a) => encodeC.encode(tuple.$3).map(a.concat)));

  static Encoder<(A, B, C, D)> tuple4<A, B, C, D>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
  ) =>
      EncoderF((tuple) => tuple3(encodeA, encodeB, encodeC)
          .encode(tuple.init())
          .flatMap((a) => encodeD.encode(tuple.$4).map(a.concat)));

  static Encoder<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
  ) =>
      EncoderF((tuple) => tuple4(encodeA, encodeB, encodeC, encodeD)
          .encode(tuple.init())
          .flatMap((a) => encodeE.encode(tuple.$5).map(a.concat)));

  static Encoder<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
  ) =>
      EncoderF((tuple) => tuple5(encodeA, encodeB, encodeC, encodeD, encodeE)
          .encode(tuple.init())
          .flatMap((a) => encodeF.encode(tuple.$6).map(a.concat)));

  static Encoder<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
  ) =>
      EncoderF((tuple) =>
          tuple6(encodeA, encodeB, encodeC, encodeD, encodeE, encodeF)
              .encode(tuple.init())
              .flatMap((a) => encodeG.encode(tuple.$7).map(a.concat)));

  static Encoder<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
  ) =>
      EncoderF((tuple) =>
          tuple7(encodeA, encodeB, encodeC, encodeD, encodeE, encodeF, encodeG)
              .encode(tuple.init())
              .flatMap((a) => encodeH.encode(tuple.$8).map(a.concat)));

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
  ) =>
      EncoderF((tuple) => tuple8(encodeA, encodeB, encodeC, encodeD, encodeE,
              encodeF, encodeG, encodeH)
          .encode(tuple.init())
          .flatMap((a) => encodeI.encode(tuple.$9).map(a.concat)));

  static Encoder<(A, B, C, D, E, F, G, H, I, J)>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) =>
          EncoderF((tuple) => tuple9(encodeA, encodeB, encodeC, encodeD,
                  encodeE, encodeF, encodeG, encodeH, encodeI)
              .encode(tuple.init())
              .flatMap((a) => encodeJ.encode(tuple.$10).map(a.concat)));

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K)>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) =>
          EncoderF((tuple) => tuple10(encodeA, encodeB, encodeC, encodeD,
                  encodeE, encodeF, encodeG, encodeH, encodeI, encodeJ)
              .encode(tuple.init())
              .flatMap((a) => encodeK.encode(tuple.$11).map(a.concat)));

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L)>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) =>
          EncoderF((tuple) => tuple11(encodeA, encodeB, encodeC, encodeD,
                  encodeE, encodeF, encodeG, encodeH, encodeI, encodeJ, encodeK)
              .encode(tuple.init())
              .flatMap((a) => encodeL.encode(tuple.$12).map(a.concat)));

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
  ) =>
          EncoderF((tuple) => tuple12(
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
                  encodeL)
              .encode(tuple.init())
              .flatMap((a) => encodeM.encode(tuple.$13).map(a.concat)));

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
  ) =>
          EncoderF((tuple) => tuple13(
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
                  encodeM)
              .encode(tuple.init())
              .flatMap((a) => encodeN.encode(tuple.$14).map(a.concat)));

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
  ) =>
          EncoderF((tuple) => tuple14(
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
                  encodeN)
              .encode(tuple.init())
              .flatMap((a) => encodeO.encode(tuple.$15).map(a.concat)));
}

class EncoderF<A> extends Encoder<A> {
  final EncodeF<A> _encodeF;

  EncoderF(this._encodeF);

  @override
  Either<Err, BitVector> encode(A a) => _encodeF(a);
}
