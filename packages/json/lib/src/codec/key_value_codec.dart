import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class KeyValueCodec<A> extends Codec<A> {
  final String key;
  final Codec<A> value;
  final Codec<A> codecKV;

  KeyValueCodec(this.key, this.value)
      : codecKV = Codec.from(value.at(key),
            value.mapJson((a) => Json.fromJsonObject(JsonObject.fromIterable([(key, a)]))));

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
    final decoder =
        Decoder.instance((cursor) => (codecA.decodeC(cursor), codecB.decodeC(cursor)).mapN(apply));

    final encoder = Encoder.instance<C>((a) => tupled(a)((a, b) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<D>((a) => tupled(a)((a, b, c) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<E>((a) => tupled(a)((a, b, c, d) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<F>((a) => tupled(a)((a, b, c, d, e) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<G>((a) => tupled(a)((a, b, c, d, e, f) => Json.deepMergeAll([
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

    final encoder =
        Encoder.instance<H>((a) => tupled(a)((a, b, c, d, e, f, g) => Json.deepMergeAll([
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

    final encoder =
        Encoder.instance<I>((a) => tupled(a)((a, b, c, d, e, f, g, h) => Json.deepMergeAll([
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

    final encoder =
        Encoder.instance<J>((a) => tupled(a)((a, b, c, d, e, f, g, h, i) => Json.deepMergeAll([
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

    final encoder =
        Encoder.instance<K>((a) => tupled(a)((a, b, c, d, e, f, g, h, i, j) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<L>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<M>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<N>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<O>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n) => Json.deepMergeAll([
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

    final encoder = Encoder.instance<P>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) => Json.deepMergeAll([
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

  static Codec<Q> product16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    KeyValueCodec<P> codecP,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
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
          codecP.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<Q>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) => Json.deepMergeAll([
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
              codecP.encode(p),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<R> product17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<R>(
        (a) => tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<S> product18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
          codecR.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<S>((a) =>
        tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
              codecR.encode(r),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<T> product19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
          codecR.decodeC(cursor),
          codecS.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<T>((a) =>
        tupled(a)((a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
              codecR.encode(r),
              codecS.encode(s),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<U> product20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
          codecR.decodeC(cursor),
          codecS.decodeC(cursor),
          codecT.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<U>((a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
              codecR.encode(r),
              codecS.encode(s),
              codecT.encode(t),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<V> product21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
          codecR.decodeC(cursor),
          codecS.decodeC(cursor),
          codecT.decodeC(cursor),
          codecU.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<V>((a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
              codecR.encode(r),
              codecS.encode(s),
              codecT.encode(t),
              codecU.encode(u),
            ])));

    return Codec.from(decoder, encoder);
  }

  static Codec<W> product22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
    KeyValueCodec<V> codecV,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
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
          codecP.decodeC(cursor),
          codecQ.decodeC(cursor),
          codecR.decodeC(cursor),
          codecS.decodeC(cursor),
          codecT.decodeC(cursor),
          codecU.decodeC(cursor),
          codecV.decodeC(cursor),
        ).mapN(apply));

    final encoder = Encoder.instance<W>((a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v) => Json.deepMergeAll([
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
              codecP.encode(p),
              codecQ.encode(q),
              codecR.encode(r),
              codecS.encode(s),
              codecT.encode(t),
              codecU.encode(u),
              codecV.encode(v),
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
      product4(codecA, codecB, codecC, codecD, (a, b, c, d) => (a, b, c, d), identity);

  static Codec<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
  ) =>
      product5(
          codecA, codecB, codecC, codecD, codecE, (a, b, c, d, e) => (a, b, c, d, e), identity);

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
      product9(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI,
          (a, b, c, d, e, f, g, h, i) => (a, b, c, d, e, f, g, h, i), identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
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
      product10(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI, codecJ,
          (a, b, c, d, e, f, g, h, i, j) => (a, b, c, d, e, f, g, h, i, j), identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
      product11(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI, codecJ,
          codecK, (a, b, c, d, e, f, g, h, i, j, k) => (a, b, c, d, e, f, g, h, i, j, k), identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
          (a, b, c, d, e, f, g, h, i, j, k, l) => (a, b, c, d, e, f, g, h, i, j, k, l),
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
              (a, b, c, d, e, f, g, h, i, j, k, l, m) => (a, b, c, d, e, f, g, h, i, j, k, l, m),
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

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
      tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    KeyValueCodec<P> codecP,
  ) =>
          product16(
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
              codecP,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
      tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
  ) =>
          product17(
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
              codecP,
              codecQ,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
      tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
  ) =>
          product18(
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
              codecP,
              codecQ,
              codecR,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
  ) =>
          product19(
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
              codecP,
              codecQ,
              codecR,
              codecS,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
  ) =>
          product20(
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
              codecP,
              codecQ,
              codecR,
              codecS,
              codecT,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
  ) =>
          product21(
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
              codecP,
              codecQ,
              codecR,
              codecS,
              codecT,
              codecU,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u),
              identity);

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
    KeyValueCodec<V> codecV,
  ) =>
          product22(
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
              codecP,
              codecQ,
              codecR,
              codecS,
              codecT,
              codecU,
              codecV,
              (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v) =>
                  (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v),
              identity);
}
