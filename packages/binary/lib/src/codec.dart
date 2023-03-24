import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

abstract class Codec<A> extends Encoder<A> with Decoder<A> {
  static Codec<A> of<A>(
    Decoder<A> decoder,
    Encoder<A> encoder, {
    String? description,
  }) =>
      CodecF(decoder, encoder, description: description);

  Codec<A> withDescription(String description) =>
      Codec.of(this, this, description: description);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv);

  @override
  Either<Err, BitVector> encode(A a);

  String? get description => null;

  Type get tag => A;

  Codec<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      Codec.of(map(f), contramap(g));

  Codec<Tuple2<A, B>> prepend<B>(Function1<A, Codec<B>> codecB) => Codec.of(
        flatMap((a) => codecB(a).map((b) => Tuple2(a, b))),
        Encoder.instance<Tuple2<A, B>>(
            (t) => Encoder.encodeBoth(this, t.$1, codecB(t.$1), t.$2)),
        description: 'prepend($this)',
      );

  @override
  String toString() => description ?? super.toString();

  static Codec<Tuple2<A, B>> tuple2<A, B>(
    Codec<A> codecA,
    Codec<B> codecB,
  ) =>
      Codec.of(Decoder.tuple2(codecA, codecB), Encoder.tuple2(codecA, codecB));

  static Codec<Tuple3<A, B, C>> tuple3<A, B, C>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
  ) =>
      Codec.of(Decoder.tuple3(codecA, codecB, codecC),
          Encoder.tuple3(codecA, codecB, codecC));

  static Codec<Tuple4<A, B, C, D>> tuple4<A, B, C, D>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
  ) =>
      Codec.of(Decoder.tuple4(codecA, codecB, codecC, codecD),
          Encoder.tuple4(codecA, codecB, codecC, codecD));

  static Codec<Tuple5<A, B, C, D, E>> tuple5<A, B, C, D, E>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
  ) =>
      Codec.of(Decoder.tuple5(codecA, codecB, codecC, codecD, codecE),
          Encoder.tuple5(codecA, codecB, codecC, codecD, codecE));

  static Codec<Tuple6<A, B, C, D, E, F>> tuple6<A, B, C, D, E, F>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
  ) =>
      Codec.of(Decoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF),
          Encoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF));

  static Codec<Tuple7<A, B, C, D, E, F, G>> tuple7<A, B, C, D, E, F, G>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
  ) =>
      Codec.of(
          Decoder.tuple7(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG),
          Encoder.tuple7(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG));

  static Codec<Tuple8<A, B, C, D, E, F, G, H>> tuple8<A, B, C, D, E, F, G, H>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
  ) =>
      Codec.of(
          Decoder.tuple8(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH),
          Encoder.tuple8(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH));

  static Codec<Tuple9<A, B, C, D, E, F, G, H, I>>
      tuple9<A, B, C, D, E, F, G, H, I>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
  ) =>
          Codec.of(
              Decoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI),
              Encoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI));

  static Codec<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
  ) =>
          Codec.of(
              Decoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ),
              Encoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ));

  static Codec<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
  ) =>
          Codec.of(
              Decoder.tuple11(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK),
              Encoder.tuple11(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK));

  static Codec<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
  ) =>
          Codec.of(
              Decoder.tuple12(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL),
              Encoder.tuple12(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL));

  static Codec<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
  ) =>
          Codec.of(
              Decoder.tuple13(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL, codecM),
              Encoder.tuple13(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL, codecM));

  static Codec<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
  ) =>
          Codec.of(
              Decoder.tuple14(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN),
              Encoder.tuple14(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN));

  static Codec<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
  ) =>
          Codec.of(
              Decoder.tuple15(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO),
              Encoder.tuple15(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO));

  static Codec<C> product2<A, B, C>(
    Codec<A> codecA,
    Codec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, Tuple2<A, B>> tupled,
  ) =>
      tuple2(codecA, codecB).xmap(apply.tupled, tupled);

  static Codec<D> product3<A, B, C, D>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Function3<A, B, C, D> apply,
    Function1<D, Tuple3<A, B, C>> tupled,
  ) =>
      tuple3(codecA, codecB, codecC).xmap(apply.tupled, tupled);

  static Codec<E> product4<A, B, C, D, E>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Function4<A, B, C, D, E> apply,
    Function1<E, Tuple4<A, B, C, D>> tupled,
  ) =>
      tuple4(codecA, codecB, codecC, codecD).xmap(apply.tupled, tupled);

  static Codec<F> product5<A, B, C, D, E, F>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Function5<A, B, C, D, E, F> apply,
    Function1<F, Tuple5<A, B, C, D, E>> tupled,
  ) =>
      tuple5(codecA, codecB, codecC, codecD, codecE).xmap(apply.tupled, tupled);

  static Codec<G> product6<A, B, C, D, E, F, G>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, Tuple6<A, B, C, D, E, F>> tupled,
  ) =>
      tuple6(codecA, codecB, codecC, codecD, codecE, codecF)
          .xmap(apply.tupled, tupled);

  static Codec<H> product7<A, B, C, D, E, F, G, H>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, Tuple7<A, B, C, D, E, F, G>> tupled,
  ) =>
      tuple7(codecA, codecB, codecC, codecD, codecE, codecF, codecG)
          .xmap(apply.tupled, tupled);

  static Codec<I> product8<A, B, C, D, E, F, G, H, I>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, Tuple8<A, B, C, D, E, F, G, H>> tupled,
  ) =>
      tuple8(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH)
          .xmap(apply.tupled, tupled);

  static Codec<J> product9<A, B, C, D, E, F, G, H, I, J>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, Tuple9<A, B, C, D, E, F, G, H, I>> tupled,
  ) =>
      tuple9(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI)
          .xmap(apply.tupled, tupled);

  static Codec<K> product10<A, B, C, D, E, F, G, H, I, J, K>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, Tuple10<A, B, C, D, E, F, G, H, I, J>> tupled,
  ) =>
      tuple10(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ)
          .xmap(apply.tupled, tupled);

  static Codec<L> product11<A, B, C, D, E, F, G, H, I, J, K, L>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, Tuple11<A, B, C, D, E, F, G, H, I, J, K>> tupled,
  ) =>
      tuple11(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ, codecK)
          .xmap(apply.tupled, tupled);

  static Codec<M> product12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>> tupled,
  ) =>
      tuple12(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ, codecK, codecL)
          .xmap(apply.tupled, tupled);

  static Codec<N> product13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>> tupled,
  ) =>
      tuple13(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ, codecK, codecL, codecM)
          .xmap(apply.tupled, tupled);

  static Codec<O> product14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>> tupled,
  ) =>
      tuple14(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ, codecK, codecL, codecM, codecN)
          .xmap(apply.tupled, tupled);

  static Codec<P> product15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>> tupled,
  ) =>
      tuple15(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
              codecI, codecJ, codecK, codecL, codecM, codecN, codecO)
          .xmap(apply.tupled, tupled);
}

class CodecF<A> extends Codec<A> {
  final Decoder<A> decoder;
  final Encoder<A> encoder;

  @override
  final String? description;

  CodecF(this.decoder, this.encoder, {this.description});

  @override
  String toString() => description ?? super.toString();

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) => decoder.decode(bv);

  @override
  Either<Err, BitVector> encode(A a) => encoder.encode(a);
}
