import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class KeyValueCodec<A> extends Codec<A> {
  final String key;
  final Codec<A> value;
  final Codec<A> codecKV;

  KeyValueCodec(this.key, this.value)
      : codecKV = Codec.from(
            value.at(key),
            value.mapJson((a) =>
                Json.fromJsonObject(JsonObject.fromIterable([(key, a)]))));

  @override
  DecodeResult<A> decodeC(HCursor cursor) => codecKV.decodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => codecKV.tryDecodeC(cursor);

  @override
  Json encode(A a) => codecKV.encode(a);

  @override
  KeyValueCodec<B> iemap<B>(
    Function1<A, Either<String, B>> f,
    Function1<B, A> g,
  ) =>
      KeyValueCodec(key, value.iemap(f, g));

  @override
  KeyValueCodec<A?> nullable() => KeyValueCodec(key, value.nullable());

  @override
  KeyValueCodec<Option<A>> optional() => KeyValueCodec(key, value.optional());

  @override
  KeyValueCodec<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      KeyValueCodec(key, value.xmap(f, g));

  KeyValueCodec<A> withKey(String newKey) => KeyValueCodec(newKey, value);

  //////////////////////////////////////////////////////////////////////////////
  /// Product Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<C> product2<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) {
    final decoder = Decoder.instance((cursor) =>
        (codecA.decodeC(cursor), codecB.decodeC(cursor)).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
          codecK.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
          codecK.decodeC(cursor),
          codecL.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
          codecK.decodeC(cursor),
          codecL.decodeC(cursor),
          codecM.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
          codecK.decodeC(cursor),
          codecL.decodeC(cursor),
          codecM.decodeC(cursor),
          codecN.decodeC(cursor),
        ).mapN(apply));

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
          codecA.decodeC(cursor),
          codecB.decodeC(cursor),
          codecC.decodeC(cursor),
          codecD.decodeC(cursor),
          codecE.decodeC(cursor),
          codecF.decodeC(cursor),
          codecG.decodeC(cursor),
          codecH.decodeC(cursor),
          codecI.decodeC(cursor),
          codecJ.decodeC(cursor),
          codecK.decodeC(cursor),
          codecL.decodeC(cursor),
          codecM.decodeC(cursor),
          codecN.decodeC(cursor),
          codecO.decodeC(cursor),
        ).mapN(apply));

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

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<(A, B)> tuple2<A, B>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
  ) =>
      product2(codecA, codecB, (a, b) => (a, b), identity);

  static Codec<(A, B, C)> tuple3<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
  ) =>
      product3(codecA, codecB, codecC, (a, b, c) => (a, b, c), identity);

  static Codec<(A, B, C, D)> tuple4<A, B, C, D>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
  ) =>
      product4(codecA, codecB, codecC, codecD, (a, b, c, d) => (a, b, c, d),
          identity);

  static Codec<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
  ) =>
      product5(codecA, codecB, codecC, codecD, codecE,
          (a, b, c, d, e) => (a, b, c, d, e), identity);

  static Codec<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
  ) =>
      product6(codecA, codecB, codecC, codecD, codecE, codecF,
          (a, b, c, d, e, f) => (a, b, c, d, e, f), identity);

  static Codec<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
  ) =>
      product7(codecA, codecB, codecC, codecD, codecE, codecF, codecG,
          (a, b, c, d, e, f, g) => (a, b, c, d, e, f, g), identity);

  static Codec<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
  ) =>
      product8(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH,
          (a, b, c, d, e, f, g, h) => (a, b, c, d, e, f, g, h), identity);

  static Codec<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
  ) =>
      product9(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          (a, b, c, d, e, f, g, h, i) => (a, b, c, d, e, f, g, h, i),
          identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J)>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) =>
          product10(
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
              (a, b, c, d, e, f, g, h, i, j) => (a, b, c, d, e, f, g, h, i, j),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K)>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) =>
          product11(
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
              (a, b, c, d, e, f, g, h, i, j, k) =>
                  (a, b, c, d, e, f, g, h, i, j, k),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L)>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) =>
          product12(
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
              (a, b, c, d, e, f, g, h, i, j, k, l) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
      tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
  ) =>
          product13(
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
              (a, b, c, d, e, f, g, h, i, j, k, l, m) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
      tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
  ) =>
          product14(
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
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
      tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
  ) =>
          product15(
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
              codecO,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o),
              identity);
}
