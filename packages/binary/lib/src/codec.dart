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

  static Codec<A> choice<A>(List<Codec<A>> choices) => ChoiceCodec(choices.toIList());

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

  static Codec<(T0, T1)> tuple2<T0, T1>(
    Codec<T0> codec0,
    Codec<T1> codec1,
  ) => Codec.of(Decoder.tuple2(codec0, codec1), Encoder.tuple2(codec0, codec1));

  static Codec<(T0, T1, T2)> tuple3<T0, T1, T2>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
  ) => Codec.of(Decoder.tuple3(codec0, codec1, codec2), Encoder.tuple3(codec0, codec1, codec2));

  static Codec<(T0, T1, T2, T3)> tuple4<T0, T1, T2, T3>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
  ) => Codec.of(
    Decoder.tuple4(codec0, codec1, codec2, codec3),
    Encoder.tuple4(codec0, codec1, codec2, codec3),
  );

  static Codec<(T0, T1, T2, T3, T4)> tuple5<T0, T1, T2, T3, T4>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
  ) => Codec.of(
    Decoder.tuple5(codec0, codec1, codec2, codec3, codec4),
    Encoder.tuple5(codec0, codec1, codec2, codec3, codec4),
  );

  static Codec<(T0, T1, T2, T3, T4, T5)> tuple6<T0, T1, T2, T3, T4, T5>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
  ) => Codec.of(
    Decoder.tuple6(codec0, codec1, codec2, codec3, codec4, codec5),
    Encoder.tuple6(codec0, codec1, codec2, codec3, codec4, codec5),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6)> tuple7<T0, T1, T2, T3, T4, T5, T6>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
  ) => Codec.of(
    Decoder.tuple7(codec0, codec1, codec2, codec3, codec4, codec5, codec6),
    Encoder.tuple7(codec0, codec1, codec2, codec3, codec4, codec5, codec6),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7)> tuple8<T0, T1, T2, T3, T4, T5, T6, T7>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
  ) => Codec.of(
    Decoder.tuple8(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7),
    Encoder.tuple8(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
  ) => Codec.of(
    Decoder.tuple9(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7, codec8),
    Encoder.tuple9(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7, codec8),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)>
  tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
  ) => Codec.of(
    Decoder.tuple10(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7, codec8, codec9),
    Encoder.tuple10(codec0, codec1, codec2, codec3, codec4, codec5, codec6, codec7, codec8, codec9),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)>
  tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
  ) => Codec.of(
    Decoder.tuple11(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
    ),
    Encoder.tuple11(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)>
  tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
  ) => Codec.of(
    Decoder.tuple12(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
    ),
    Encoder.tuple12(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)>
  tuple13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
  ) => Codec.of(
    Decoder.tuple13(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
    ),
    Encoder.tuple13(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)>
  tuple14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
  ) => Codec.of(
    Decoder.tuple14(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
    ),
    Encoder.tuple14(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)>
  tuple15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
  ) => Codec.of(
    Decoder.tuple15(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
    ),
    Encoder.tuple15(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)>
  tuple16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
  ) => Codec.of(
    Decoder.tuple16(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
    ),
    Encoder.tuple16(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
  tuple17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
  ) => Codec.of(
    Decoder.tuple17(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
    ),
    Encoder.tuple17(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
    ),
  );

  static Codec<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  tuple18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
  ) => Codec.of(
    Decoder.tuple18(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
    ),
    Encoder.tuple18(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
    ),
  );

  static Codec<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
  >
  tuple19<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
  ) => Codec.of(
    Decoder.tuple19(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
    ),
    Encoder.tuple19(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
    ),
  );

  static Codec<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  >
  tuple20<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
  ) => Codec.of(
    Decoder.tuple20(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
    ),
    Encoder.tuple20(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
    ),
  );

  static Codec<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  tuple21<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19,
    T20
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
    Codec<T20> codec20,
  ) => Codec.of(
    Decoder.tuple21(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
      codec20,
    ),
    Encoder.tuple21(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
      codec20,
    ),
  );

  static Codec<
    (
      T0,
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
    )
  >
  tuple22<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19,
    T20,
    T21
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
    Codec<T20> codec20,
    Codec<T21> codec21,
  ) => Codec.of(
    Decoder.tuple22(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
      codec20,
      codec21,
    ),
    Encoder.tuple22(
      codec0,
      codec1,
      codec2,
      codec3,
      codec4,
      codec5,
      codec6,
      codec7,
      codec8,
      codec9,
      codec10,
      codec11,
      codec12,
      codec13,
      codec14,
      codec15,
      codec16,
      codec17,
      codec18,
      codec19,
      codec20,
      codec21,
    ),
  );

  static Codec<T2> product2<T0, T1, T2>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Function2<T0, T1, T2> apply,
    Function1<T2, (T0, T1)> tupled,
  ) => tuple2(codec0, codec1).xmap(apply.tupled, tupled);

  static Codec<T3> product3<T0, T1, T2, T3>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Function3<T0, T1, T2, T3> apply,
    Function1<T3, (T0, T1, T2)> tupled,
  ) => tuple3(codec0, codec1, codec2).xmap(apply.tupled, tupled);

  static Codec<T4> product4<T0, T1, T2, T3, T4>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Function4<T0, T1, T2, T3, T4> apply,
    Function1<T4, (T0, T1, T2, T3)> tupled,
  ) => tuple4(codec0, codec1, codec2, codec3).xmap(apply.tupled, tupled);

  static Codec<T5> product5<T0, T1, T2, T3, T4, T5>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Function5<T0, T1, T2, T3, T4, T5> apply,
    Function1<T5, (T0, T1, T2, T3, T4)> tupled,
  ) => tuple5(codec0, codec1, codec2, codec3, codec4).xmap(apply.tupled, tupled);

  static Codec<T6> product6<T0, T1, T2, T3, T4, T5, T6>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Function6<T0, T1, T2, T3, T4, T5, T6> apply,
    Function1<T6, (T0, T1, T2, T3, T4, T5)> tupled,
  ) => tuple6(codec0, codec1, codec2, codec3, codec4, codec5).xmap(apply.tupled, tupled);

  static Codec<T7> product7<T0, T1, T2, T3, T4, T5, T6, T7>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Function7<T0, T1, T2, T3, T4, T5, T6, T7> apply,
    Function1<T7, (T0, T1, T2, T3, T4, T5, T6)> tupled,
  ) => tuple7(codec0, codec1, codec2, codec3, codec4, codec5, codec6).xmap(apply.tupled, tupled);

  static Codec<T8> product8<T0, T1, T2, T3, T4, T5, T6, T7, T8>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Function8<T0, T1, T2, T3, T4, T5, T6, T7, T8> apply,
    Function1<T8, (T0, T1, T2, T3, T4, T5, T6, T7)> tupled,
  ) => tuple8(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
  ).xmap(apply.tupled, tupled);

  static Codec<T9> product9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Function9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> apply,
    Function1<T9, (T0, T1, T2, T3, T4, T5, T6, T7, T8)> tupled,
  ) => tuple9(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
  ).xmap(apply.tupled, tupled);

  static Codec<T10> product10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Function10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> apply,
    Function1<T10, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> tupled,
  ) => tuple10(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
  ).xmap(apply.tupled, tupled);

  static Codec<T11> product11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Function11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> apply,
    Function1<T11, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> tupled,
  ) => tuple11(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
  ).xmap(apply.tupled, tupled);

  static Codec<T12> product12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Function12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> apply,
    Function1<T12, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> tupled,
  ) => tuple12(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
  ).xmap(apply.tupled, tupled);

  static Codec<T13> product13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Function13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> apply,
    Function1<T13, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> tupled,
  ) => tuple13(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
  ).xmap(apply.tupled, tupled);

  static Codec<T14> product14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Function14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> apply,
    Function1<T14, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> tupled,
  ) => tuple14(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
  ).xmap(apply.tupled, tupled);

  static Codec<T15> product15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Function15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> apply,
    Function1<T15, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> tupled,
  ) => tuple15(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
  ).xmap(apply.tupled, tupled);

  static Codec<T16>
  product16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Function16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> apply,
    Function1<T16, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> tupled,
  ) => tuple16(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
  ).xmap(apply.tupled, tupled);

  static Codec<T17>
  product17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Function17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    apply,
    Function1<T17, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
    tupled,
  ) => tuple17(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
  ).xmap(apply.tupled, tupled);

  static Codec<T18>
  product18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Function18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
    apply,
    Function1<T18, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
    tupled,
  ) => tuple18(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
    codec17,
  ).xmap(apply.tupled, tupled);

  static Codec<T19> product19<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Function19<
      T0,
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19
    >
    apply,
    Function1<
      T19,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
    >
    tupled,
  ) => tuple19(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
    codec17,
    codec18,
  ).xmap(apply.tupled, tupled);

  static Codec<T20> product20<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19,
    T20
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
    Function20<
      T0,
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20
    >
    apply,
    Function1<
      T20,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
    >
    tupled,
  ) => tuple20(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
    codec17,
    codec18,
    codec19,
  ).xmap(apply.tupled, tupled);

  static Codec<T21> product21<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19,
    T20,
    T21
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
    Codec<T20> codec20,
    Function21<
      T0,
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21
    >
    apply,
    Function1<
      T21,
      (
        T0,
        T1,
        T2,
        T3,
        T4,
        T5,
        T6,
        T7,
        T8,
        T9,
        T10,
        T11,
        T12,
        T13,
        T14,
        T15,
        T16,
        T17,
        T18,
        T19,
        T20,
      )
    >
    tupled,
  ) => tuple21(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
    codec17,
    codec18,
    codec19,
    codec20,
  ).xmap(apply.tupled, tupled);

  static Codec<T22> product22<
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
    T12,
    T13,
    T14,
    T15,
    T16,
    T17,
    T18,
    T19,
    T20,
    T21,
    T22
  >(
    Codec<T0> codec0,
    Codec<T1> codec1,
    Codec<T2> codec2,
    Codec<T3> codec3,
    Codec<T4> codec4,
    Codec<T5> codec5,
    Codec<T6> codec6,
    Codec<T7> codec7,
    Codec<T8> codec8,
    Codec<T9> codec9,
    Codec<T10> codec10,
    Codec<T11> codec11,
    Codec<T12> codec12,
    Codec<T13> codec13,
    Codec<T14> codec14,
    Codec<T15> codec15,
    Codec<T16> codec16,
    Codec<T17> codec17,
    Codec<T18> codec18,
    Codec<T19> codec19,
    Codec<T20> codec20,
    Codec<T21> codec21,
    Function22<
      T0,
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22
    >
    apply,
    Function1<
      T22,
      (
        T0,
        T1,
        T2,
        T3,
        T4,
        T5,
        T6,
        T7,
        T8,
        T9,
        T10,
        T11,
        T12,
        T13,
        T14,
        T15,
        T16,
        T17,
        T18,
        T19,
        T20,
        T21,
      )
    >
    tupled,
  ) => tuple22(
    codec0,
    codec1,
    codec2,
    codec3,
    codec4,
    codec5,
    codec6,
    codec7,
    codec8,
    codec9,
    codec10,
    codec11,
    codec12,
    codec13,
    codec14,
    codec15,
    codec16,
    codec17,
    codec18,
    codec19,
    codec20,
    codec21,
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
