import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/codecs.dart';
import 'package:ribs_binary/src/codecs/either_codec.dart';
import 'package:ribs_binary/src/codecs/xmapped_codec.dart';
import 'package:ribs_core/ribs_core.dart';

abstract class Codec<A> extends Encoder<A> with Decoder<A> {
  static Codec<A> of<A>(
    Decoder<A> decoder,
    Encoder<A> encoder, {
    String? description,
  }) => CodecF(decoder, encoder, description: description);

  Codec<A> withDescription(String description) => Codec.of(this, this, description: description);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv);

  @override
  Either<Err, BitVector> encode(A a);

  String? get description => null;

  Type get tag => A;

  Codec<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) => Codec.of(map(f), contramap(g));

  Codec<(A, B)> prepend<B>(Function1<A, Codec<B>> codecB) => Codec.of(
    flatMap((a) => codecB(a).map((b) => (a, b))),
    Encoder.instance<(A, B)>((t) => Encoder.encodeBoth(this, t.$1, codecB(t.$1), t.$2)),
    description: 'prepend($this)',
  );

  @override
  String toString() => description ?? super.toString();

  //////////////////////////////////////////////////////////////////////////////
  /// Instances
  //////////////////////////////////////////////////////////////////////////////

  static final Codec<BitVector> bits = Codec.of(
    Decoder.instance((b) => Either.right(DecodeResult.successful(b))),
    Encoder.instance((b) => Either.right(b)),
    description: 'bits',
  );

  static Codec<BitVector> bitsN(int size) => FixedSizeCodec(size, bits);

  static Codec<BitVector> bitsStrict(int size) => FixedSizeStrictCodec(size, bits);

  static final Codec<ByteVector> bytes = bits
      .xmap((bits) => bits.bytes, (bytes) => bytes.bits)
      .withDescription('bytes');

  static Codec<ByteVector> bytesN(int size) => FixedSizeCodec(size * 8, bytes);

  static Codec<ByteVector> bytesStrict(int size) => FixedSizeStrictCodec(size * 8, bytes);

  static Codec<Unit> constant(BitVector bytes) => ConstantCodec(bytes);
  static Codec<A> provide<A>(A value) => ProvideCodec(value);

  static final Codec<bool> boolean = BooleanCodec();

  static Codec<bool> booleanN(int size) {
    final zeros = BitVector.low(size);
    final ones = BitVector.high(size);
    return bitsN(size).xmap<bool>((b) => b != zeros, (b) => b ? ones : zeros);
  }

  static Codec<B> discriminatedBy<A, B>(Codec<A> by, IMap<A, Codec<B>> typecases) =>
      DiscriminatorCodec.typecases(by, typecases);

  static final Codec<int> int4 = IntCodec(4, true, Endian.big);
  static final Codec<int> int8 = IntCodec(8, true, Endian.big);
  static final Codec<int> int16 = IntCodec(16, true, Endian.big);
  static final Codec<int> int24 = IntCodec(24, true, Endian.big);
  static final Codec<int> int32 = IntCodec(32, true, Endian.big);
  static final Codec<int> int64 = IntCodec(64, true, Endian.big);

  static final Codec<int> uint4 = IntCodec(4, false, Endian.big);
  static final Codec<int> uint8 = IntCodec(8, false, Endian.big);
  static final Codec<int> uint16 = IntCodec(16, false, Endian.big);
  static final Codec<int> uint24 = IntCodec(24, false, Endian.big);
  static final Codec<int> uint32 = IntCodec(32, false, Endian.big);

  static final Codec<int> int4L = IntCodec(4, true, Endian.little);
  static final Codec<int> int8L = IntCodec(8, true, Endian.little);
  static final Codec<int> int16L = IntCodec(16, true, Endian.little);
  static final Codec<int> int24L = IntCodec(24, true, Endian.little);
  static final Codec<int> int32L = IntCodec(32, true, Endian.little);
  static final Codec<int> int64L = IntCodec(64, true, Endian.little);

  static final Codec<int> uint4L = IntCodec(4, false, Endian.little);
  static final Codec<int> uint8L = IntCodec(8, false, Endian.little);
  static final Codec<int> uint16L = IntCodec(16, false, Endian.little);
  static final Codec<int> uint24L = IntCodec(24, false, Endian.little);
  static final Codec<int> uint32L = IntCodec(32, false, Endian.little);

  static Codec<int> integer(int size) => IntCodec(size, true, Endian.big);
  static Codec<int> integerL(int size) => IntCodec(size, true, Endian.little);
  static Codec<int> uinteger(int size) => IntCodec(size, false, Endian.big);
  static Codec<int> uintegerL(int size) => IntCodec(size, false, Endian.little);

  static final Codec<double> float32 = FloatCodec.float32(Endian.big);
  static final Codec<double> float64 = FloatCodec.float64(Endian.big);

  static final Codec<double> float32L = FloatCodec.float32(Endian.little);
  static final Codec<double> float64L = FloatCodec.float64(Endian.little);

  static final Codec<String> ascii = StringCodec.acsii();
  static final Codec<String> ascii32 = VariableSizedCodec(int32, ascii);
  static final Codec<String> ascii32L = VariableSizedCodec(int32L, ascii);

  static final Codec<String> utf8 = StringCodec.utf8();
  static final Codec<String> utf8_32 = VariableSizedCodec(int32, utf8);
  static final Codec<String> utf8_32L = VariableSizedCodec(int32L, utf8);

  static final Codec<String> utf16 = StringCodec.utf16();
  static final Codec<String> utf16_32 = VariableSizedCodec(int32, utf16);
  static final Codec<String> utf16_32L = VariableSizedCodec(int32L, utf16);

  static final Codec<String> cstring = StringCodec.cstring();

  static Codec<Unit> ignore(int size) => IgnoreCodec(size);

  static Codec<List<A>> list<A>(Codec<A> codec, [int? limit]) =>
      ListCodec(codec, limit: Option(limit));

  static Codec<List<A>> listOfN<A>(Codec<int> countCodec, Codec<A> valueCodec) => Codec.of(
    countCodec.flatMap((count) => list(valueCodec, count)),
    Encoder.instance(
      (as) => countCodec
          .encode(as.length)
          .flatMap((x) => valueCodec.encodeAll(as).map((y) => x.concat(y))),
    ),
  );

  static Codec<IList<A>> ilist<A>(Codec<A> codec, [int? limit]) =>
      list(codec, limit).xmap(IList.fromDart, (il) => il.toList());

  static Codec<IList<A>> ilistOfN<A>(Codec<int> countCodec, Codec<A> valueCodec) =>
      listOfN(countCodec, valueCodec).xmap(IList.fromDart, (il) => il.toList());

  static Codec<A> peek<A>(Codec<A> target) => Codec.of(
    Decoder.instance((b) => target.decode(b).map((a) => a.mapRemainder((_) => b))),
    target,
    description: 'peek($target)',
  );

  static Codec<Option<A>> option<A>(Codec<bool> indicator, Codec<A> valueCodec) => either(
    indicator,
    provide(null),
    valueCodec,
  ).xmap((a) => a.toOption(), (a) => a.toRight(() => null));

  static Codec<Either<A, B>> either<A, B>(
    Codec<bool> indicator,
    Codec<A> leftCodec,
    Codec<B> rightCodec,
  ) => EitherCodec(indicator, leftCodec, rightCodec);

  static Codec<A> byteAligned<A>(Codec<A> codec) => ByteAlignedCodec(codec);

  static Codec<A> variableSized<A>(
    Codec<int> sizeCodec,
    Codec<A> valueCodec,
  ) => VariableSizedCodec(sizeCodec, valueCodec);

  static Codec<B> xmapped<A, B>(Codec<A> by, IMap<A, B> cases) => XMappedCodec(by, cases);

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<(A, B)> tuple2<A, B>(
    Codec<A> codecA,
    Codec<B> codecB,
  ) => Codec.of(Decoder.tuple2(codecA, codecB), Encoder.tuple2(codecA, codecB));

  static Codec<(A, B, C)> tuple3<A, B, C>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
  ) => Codec.of(Decoder.tuple3(codecA, codecB, codecC), Encoder.tuple3(codecA, codecB, codecC));

  static Codec<(A, B, C, D)> tuple4<A, B, C, D>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
  ) => Codec.of(
    Decoder.tuple4(codecA, codecB, codecC, codecD),
    Encoder.tuple4(codecA, codecB, codecC, codecD),
  );

  static Codec<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
  ) => Codec.of(
    Decoder.tuple5(codecA, codecB, codecC, codecD, codecE),
    Encoder.tuple5(codecA, codecB, codecC, codecD, codecE),
  );

  static Codec<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
  ) => Codec.of(
    Decoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF),
    Encoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF),
  );

  static Codec<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
  ) => Codec.of(
    Decoder.tuple7(codecA, codecB, codecC, codecD, codecE, codecF, codecG),
    Encoder.tuple7(codecA, codecB, codecC, codecD, codecE, codecF, codecG),
  );

  static Codec<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
  ) => Codec.of(
    Decoder.tuple8(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH),
    Encoder.tuple8(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH),
  );

  static Codec<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
  ) => Codec.of(
    Decoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI),
    Encoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) => Codec.of(
    Decoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI, codecJ),
    Encoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH, codecI, codecJ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) => Codec.of(
    Decoder.tuple11(
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
    ),
    Encoder.tuple11(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) => Codec.of(
    Decoder.tuple12(
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
    ),
    Encoder.tuple12(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
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
  ) => Codec.of(
    Decoder.tuple13(
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
    ),
    Encoder.tuple13(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
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
  ) => Codec.of(
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
      codecN,
    ),
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
      codecN,
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
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
  ) => Codec.of(
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
      codecO,
    ),
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
      codecO,
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
  tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    Codec<P> codecP,
  ) => Codec.of(
    Decoder.tuple16(
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
    ),
    Encoder.tuple16(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
  tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
  ) => Codec.of(
    Decoder.tuple17(
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
    ),
    Encoder.tuple17(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
  tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
  ) => Codec.of(
    Decoder.tuple18(
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
    ),
    Encoder.tuple18(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
  tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
  ) => Codec.of(
    Decoder.tuple19(
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
    ),
    Encoder.tuple19(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
  tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
  ) => Codec.of(
    Decoder.tuple20(
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
    ),
    Encoder.tuple20(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
  tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
  ) => Codec.of(
    Decoder.tuple21(
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
    ),
    Encoder.tuple21(
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
    ),
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
  tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
    Codec<V> codecV,
  ) => Codec.of(
    Decoder.tuple22(
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
    ),
    Encoder.tuple22(
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
    ),
  );

  //////////////////////////////////////////////////////////////////////////////
  /// Product Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<C> product2<A, B, C>(
    Codec<A> codecA,
    Codec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) => tuple2(codecA, codecB).xmap(apply.tupled, tupled);

  static Codec<D> product3<A, B, C, D>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) => tuple3(codecA, codecB, codecC).xmap(apply.tupled, tupled);

  static Codec<E> product4<A, B, C, D, E>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) => tuple4(codecA, codecB, codecC, codecD).xmap(apply.tupled, tupled);

  static Codec<F> product5<A, B, C, D, E, F>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) => tuple5(codecA, codecB, codecC, codecD, codecE).xmap(apply.tupled, tupled);

  static Codec<G> product6<A, B, C, D, E, F, G>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) => tuple6(codecA, codecB, codecC, codecD, codecE, codecF).xmap(apply.tupled, tupled);

  static Codec<H> product7<A, B, C, D, E, F, G, H>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) => tuple7(codecA, codecB, codecC, codecD, codecE, codecF, codecG).xmap(apply.tupled, tupled);

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
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) => tuple8(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    codecG,
    codecH,
  ).xmap(apply.tupled, tupled);

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
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) => tuple9(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    codecG,
    codecH,
    codecI,
  ).xmap(apply.tupled, tupled);

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
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) => tuple10(
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
  ).xmap(apply.tupled, tupled);

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
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) => tuple11(
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
  ).xmap(apply.tupled, tupled);

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
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) => tuple12(
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
  ).xmap(apply.tupled, tupled);

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
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) => tuple13(
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
  ).xmap(apply.tupled, tupled);

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
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) => tuple14(
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
  ).xmap(apply.tupled, tupled);

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
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) => tuple15(
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
  ).xmap(apply.tupled, tupled);

  static Codec<Q> product16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Codec<P> codecP,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
  ) => tuple16(
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
  ).xmap(apply.tupled, tupled);

  static Codec<R> product17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
  ) => tuple17(
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
  ).xmap(apply.tupled, tupled);

  static Codec<S> product18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
  ) => tuple18(
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
  ).xmap(apply.tupled, tupled);

  static Codec<T> product19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
  ) => tuple19(
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
  ).xmap(apply.tupled, tupled);

  static Codec<U> product20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
  ) => tuple20(
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
  ).xmap(apply.tupled, tupled);

  static Codec<V> product21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
  ) => tuple21(
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
  ).xmap(apply.tupled, tupled);

  static Codec<W> product22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
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
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
    Codec<V> codecV,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
  ) => tuple22(
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
  ).xmap(apply.tupled, tupled);
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

extension CodecOps<A> on Codec<A> {
  Codec<Option<A>> optional(Codec<bool> indicator) => Codec.option(indicator, this);
}
