import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class KeyValueCodec<A> extends Codec<A> {
  final String key;
  final Codec<A> codecKV;

  KeyValueCodec(this.key, Codec<A> codec)
      : codecKV = Codec.from(
            codec.at(key),
            codec.mapJson((a) =>
                Json.fromJsonObject(JsonObject.fromIterable([(key, a)]))));

  @override
  DecodeResult<A> decode(HCursor cursor) => codecKV.decode(cursor);

  @override
  Json encode(A a) => codecKV.encode(a);

  //////////////////////////////////////////////////////////////////////////////
  /// Product Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<C> product2<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) {
    final decoder = Decoder.instance(
        (cursor) => (codecA.decode(cursor), codecB.decode(cursor)).mapN(apply));

    final encoder =
        Encoder.instance<C>((a) => tupled(a)((a, b) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<D> product3<A, B, C, D>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
        )
            .mapN(apply));

    final encoder =
        Encoder.instance<D>((a) => tupled(a)((a, b, c) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<E> product4<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
        )
            .mapN(apply));

    final encoder =
        Encoder.instance<E>((a) => tupled(a)((a, b, c, d) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<F> product5<A, B, C, D, E, F>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<F>(
        (a) => tupled(a)((a, b, c, d, e) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<G> product6<A, B, C, D, E, F, G>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<G>(
        (a) => tupled(a)((a, b, c, d, e, f) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<H> product7<A, B, C, D, E, F, G, H>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<H>(
        (a) => tupled(a)((a, b, c, d, e, f, g) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<I> product8<A, B, C, D, E, F, G, H, I>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<I>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<J> product9<A, B, C, D, E, F, G, H, I, J>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<J>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<K> product10<A, B, C, D, E, F, G, H, I, J, K>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<K>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<L> product11<A, B, C, D, E, F, G, H, I, J, K, L>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
          codecK.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<L>((a) =>
        tupled(a)((a, b, c, d, e, f, g, h, i, j, k) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
              codecK.encode(k),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<M> product12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
          codecK.decode(cursor),
          codecL.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<M>((a) =>
        tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
              codecK.encode(k),
              codecL.encode(l),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<N> product13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
          codecK.decode(cursor),
          codecL.decode(cursor),
          codecM.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<N>((a) =>
        tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
              codecK.encode(k),
              codecL.encode(l),
              codecM.encode(m),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<O> product14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
          codecK.decode(cursor),
          codecL.decode(cursor),
          codecM.decode(cursor),
          codecN.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<O>((a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
              codecK.encode(k),
              codecL.encode(l),
              codecM.encode(m),
              codecN.encode(n),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<P> product15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) => (
          codecA.decode(cursor),
          codecB.decode(cursor),
          codecC.decode(cursor),
          codecD.decode(cursor),
          codecE.decode(cursor),
          codecF.decode(cursor),
          codecG.decode(cursor),
          codecH.decode(cursor),
          codecI.decode(cursor),
          codecJ.decode(cursor),
          codecK.decode(cursor),
          codecL.decode(cursor),
          codecM.decode(cursor),
          codecN.decode(cursor),
          codecO.decode(cursor),
        )
            .mapN(apply));

    final encoder = Encoder.instance<P>((a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) => Json.deepMergeAll([
              codecA.encode(a),
              codecB.encode(b),
              codecC.encode(c),
              codecD.encode(d),
              codecE.encode(e),
              codecF.encode(f),
              codecG.encode(g),
              codecH.encode(h),
              codecI.encode(i),
              codecJ.encode(j),
              codecK.encode(k),
              codecL.encode(l),
              codecM.encode(m),
              codecN.encode(n),
              codecO.encode(o),
            ])));

    return Codec.from(decoder, encoder);
  }
}
