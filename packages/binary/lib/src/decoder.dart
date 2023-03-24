import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

class DecodeResult<A> {
  final A value;
  final BitVector remainder;

  const DecodeResult(this.value, this.remainder);

  factory DecodeResult.successful(A value) =>
      DecodeResult(value, BitVector.empty());

  DecodeResult<B> map<B>(Function1<A, B> f) =>
      DecodeResult(f(value), remainder);

  DecodeResult<A> mapRemainder(Function1<BitVector, BitVector> f) =>
      DecodeResult(value, f(remainder));

  @override
  String toString() => 'DecodeResult($value, ${remainder.toHexString})';
}

typedef DecodeF<A> = Function1<BitVector, Either<Err, DecodeResult<A>>>;

abstract class Decoder<A> {
  Either<Err, DecodeResult<A>> decode(BitVector bv);

  Decoder<B> map<B>(Function1<A, B> f) => instance<B>(
      (bv) => decode(bv).map((a) => DecodeResult(f(a.value), a.remainder)));

  Decoder<B> flatMap<B>(covariant Function1<A, Decoder<B>> f) => instance(
      (bv) => decode(bv).flatMap((a) => f(a.value).decode(a.remainder)));

  Decoder<B> emap<B>(Function1<A, Either<Err, B>> f) =>
      instance((bv) => decode(bv)
          .flatMap((a) => f(a.value).map((b) => DecodeResult(b, a.remainder))));

  static Decoder<A> instance<A>(DecodeF<A> decode) => DecoderF(decode);

  static Decoder<Tuple2<A, B>> tuple2<A, B>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
  ) =>
      DecoderF((bv) => decodeA.decode(bv).flatMap((a) => decodeB
          .decode(a.remainder)
          .map((b) => DecodeResult(Tuple2(a.value, b.value), b.remainder))));

  static Decoder<Tuple3<A, B, C>> tuple3<A, B, C>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
  ) =>
      DecoderF((bv) => tuple2(decodeA, decodeB).decode(bv).flatMap((t) =>
          decodeC
              .decode(t.remainder)
              .map((c) => DecodeResult(t.value.append(c.value), c.remainder))));

  static Decoder<Tuple4<A, B, C, D>> tuple4<A, B, C, D>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
  ) =>
      DecoderF((bv) => tuple3(decodeA, decodeB, decodeC).decode(bv).flatMap(
          (t) => decodeD
              .decode(t.remainder)
              .map((d) => DecodeResult(t.value.append(d.value), d.remainder))));

  static Decoder<Tuple5<A, B, C, D, E>> tuple5<A, B, C, D, E>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
  ) =>
      DecoderF((bv) => tuple4(decodeA, decodeB, decodeC, decodeD)
          .decode(bv)
          .flatMap((t) => decodeE
              .decode(t.remainder)
              .map((e) => DecodeResult(t.value.append(e.value), e.remainder))));

  static Decoder<Tuple6<A, B, C, D, E, F>> tuple6<A, B, C, D, E, F>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
  ) =>
      DecoderF((bv) => tuple5(decodeA, decodeB, decodeC, decodeD, decodeE)
          .decode(bv)
          .flatMap((t) => decodeF
              .decode(t.remainder)
              .map((f) => DecodeResult(t.value.append(f.value), f.remainder))));

  static Decoder<Tuple7<A, B, C, D, E, F, G>> tuple7<A, B, C, D, E, F, G>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
  ) =>
      DecoderF((bv) => tuple6(
              decodeA, decodeB, decodeC, decodeD, decodeE, decodeF)
          .decode(bv)
          .flatMap((t) => decodeG
              .decode(t.remainder)
              .map((g) => DecodeResult(t.value.append(g.value), g.remainder))));

  static Decoder<Tuple8<A, B, C, D, E, F, G, H>> tuple8<A, B, C, D, E, F, G, H>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
  ) =>
      DecoderF((bv) => tuple7(
              decodeA, decodeB, decodeC, decodeD, decodeE, decodeF, decodeG)
          .decode(bv)
          .flatMap((t) => decodeH
              .decode(t.remainder)
              .map((h) => DecodeResult(t.value.append(h.value), h.remainder))));

  static Decoder<Tuple9<A, B, C, D, E, F, G, H, I>>
      tuple9<A, B, C, D, E, F, G, H, I>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
  ) =>
          DecoderF((bv) => tuple8(decodeA, decodeB, decodeC, decodeD, decodeE,
                  decodeF, decodeG, decodeH)
              .decode(bv)
              .flatMap((t) => decodeI.decode(t.remainder).map(
                  (i) => DecodeResult(t.value.append(i.value), i.remainder))));

  static Decoder<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
  ) =>
          DecoderF((bv) => tuple9(decodeA, decodeB, decodeC, decodeD, decodeE,
                  decodeF, decodeG, decodeH, decodeI)
              .decode(bv)
              .flatMap((t) => decodeJ.decode(t.remainder).map(
                  (j) => DecodeResult(t.value.append(j.value), j.remainder))));

  static Decoder<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
  ) =>
          DecoderF((bv) => tuple10(decodeA, decodeB, decodeC, decodeD, decodeE,
                  decodeF, decodeG, decodeH, decodeI, decodeJ)
              .decode(bv)
              .flatMap((t) => decodeK.decode(t.remainder).map(
                  (k) => DecodeResult(t.value.append(k.value), k.remainder))));

  static Decoder<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
  ) =>
          DecoderF((bv) => tuple11(decodeA, decodeB, decodeC, decodeD, decodeE,
                  decodeF, decodeG, decodeH, decodeI, decodeJ, decodeK)
              .decode(bv)
              .flatMap((t) => decodeL.decode(t.remainder).map(
                  (l) => DecodeResult(t.value.append(l.value), l.remainder))));

  static Decoder<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
  ) =>
          DecoderF((bv) => tuple12(decodeA, decodeB, decodeC, decodeD, decodeE,
                  decodeF, decodeG, decodeH, decodeI, decodeJ, decodeK, decodeL)
              .decode(bv)
              .flatMap((t) => decodeM.decode(t.remainder).map(
                  (m) => DecodeResult(t.value.append(m.value), m.remainder))));

  static Decoder<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
    Decoder<N> decodeN,
  ) =>
          DecoderF((bv) => tuple13(
                  decodeA,
                  decodeB,
                  decodeC,
                  decodeD,
                  decodeE,
                  decodeF,
                  decodeG,
                  decodeH,
                  decodeI,
                  decodeJ,
                  decodeK,
                  decodeL,
                  decodeM)
              .decode(bv)
              .flatMap((t) => decodeN.decode(t.remainder).map(
                  (n) => DecodeResult(t.value.append(n.value), n.remainder))));

  static Decoder<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
    Decoder<N> decodeN,
    Decoder<O> decodeO,
  ) =>
          DecoderF((bv) => tuple14(
                  decodeA,
                  decodeB,
                  decodeC,
                  decodeD,
                  decodeE,
                  decodeF,
                  decodeG,
                  decodeH,
                  decodeI,
                  decodeJ,
                  decodeK,
                  decodeL,
                  decodeM,
                  decodeN)
              .decode(bv)
              .flatMap((t) => decodeO.decode(t.remainder).map(
                  (o) => DecodeResult(t.value.append(o.value), o.remainder))));
}

class DecoderF<A> extends Decoder<A> {
  final DecodeF<A> decodeF;

  DecoderF(this.decodeF);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) => decodeF(bv);
}
