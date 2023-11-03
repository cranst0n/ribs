import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/codecs.dart';
import 'package:ribs_binary/src/codecs/either_codec.dart';
import 'package:ribs_core/ribs_core.dart';

Codec<BitVector> bits = Codec.of(
  Decoder.instance((b) => Either.right(DecodeResult.successful(b))),
  Encoder.instance((b) => Either.right(b)),
  description: 'bits',
);

Codec<BitVector> bitsN(int size) => FixedSizeCodec(size, bits);

Codec<BitVector> bitsStrict(int size) => FixedSizeStrictCodec(size, bits);

Codec<ByteVector> bytes = bits
    .xmap((bits) => bits.toByteVector(), (bytes) => bytes.bits)
    .withDescription('bytes');

Codec<ByteVector> bytesN(int size) => FixedSizeCodec(size, bytes);

Codec<ByteVector> bytesStrict(int size) => FixedSizeStrictCodec(size, bytes);

Codec<Unit> constant(BitVector bytes) => ConstantCodec(bytes);
Codec<A> provide<A>(A value) => ProvideCodec(value);

Codec<bool> boolean = BooleanCodec();

Codec<bool> booleanN(int size) {
  final zeros = BitVector.low(size);
  final ones = BitVector.high(size);
  return bitsN(size).xmap<bool>((b) => b != zeros, (b) => b ? ones : zeros);
}

Codec<B> discriminatedBy<A, B>(Codec<A> by, IMap<A, Codec<B>> typecases) =>
    DiscriminatorCodec.typecases(by, typecases);

Codec<int> int8 = IntCodec(8, true, Endian.big);
Codec<int> int16 = IntCodec(16, true, Endian.big);
Codec<int> int24 = IntCodec(24, true, Endian.big);
Codec<int> int32 = IntCodec(32, true, Endian.big);
Codec<int> int64 = IntCodec(64, true, Endian.big);

Codec<int> uint2 = IntCodec(2, false, Endian.big);
Codec<int> uint4 = IntCodec(4, false, Endian.big);
Codec<int> uint8 = IntCodec(8, false, Endian.big);
Codec<int> uint16 = IntCodec(16, false, Endian.big);
Codec<int> uint24 = IntCodec(24, false, Endian.big);
Codec<int> uint32 = IntCodec(32, false, Endian.big);
// Codec<int> uint64 = IntCodec(64, false, Endian.big);

Codec<int> int8L = IntCodec(8, true, Endian.little);
Codec<int> int16L = IntCodec(16, true, Endian.little);
Codec<int> int24L = IntCodec(24, true, Endian.little);
Codec<int> int32L = IntCodec(32, true, Endian.little);
Codec<int> int64L = IntCodec(64, true, Endian.little);

Codec<int> uint2L = IntCodec(2, false, Endian.little);
Codec<int> uint4L = IntCodec(4, false, Endian.little);
Codec<int> uint8L = IntCodec(8, false, Endian.little);
Codec<int> uint16L = IntCodec(16, false, Endian.little);
Codec<int> uint24L = IntCodec(24, false, Endian.little);
Codec<int> uint32L = IntCodec(32, false, Endian.little);
Codec<int> uint64L = IntCodec(64, false, Endian.little);

Codec<int> integer(int size) => IntCodec(size, true, Endian.big);
Codec<int> integerL(int size) => IntCodec(size, true, Endian.little);
Codec<int> uinteger(int size) => IntCodec(size, false, Endian.big);
Codec<int> uintegerL(int size) => IntCodec(size, false, Endian.little);

Codec<double> float32 = FloatCodec.float32(Endian.big);
Codec<double> float64 = FloatCodec.float64(Endian.big);

Codec<double> float32L = FloatCodec.float32(Endian.little);
Codec<double> float64L = FloatCodec.float64(Endian.little);

Codec<String> ascii = StringCodec.acsii();
Codec<String> ascii32 = VariableSizedCodec(int32, ascii);
Codec<String> ascii32L = VariableSizedCodec(int32L, ascii);

Codec<String> utf8 = StringCodec.utf8();
Codec<String> utf8_32 = VariableSizedCodec(int32, utf8);
Codec<String> utf8_32L = VariableSizedCodec(int32L, utf8);

Codec<String> utf16 = StringCodec.utf16();
Codec<String> utf16_32 = VariableSizedCodec(int32, utf16);
Codec<String> utf16_32L = VariableSizedCodec(int32L, utf16);

Codec<String> cstring = StringCodec.cstring();

Codec<List<A>> list<A>(Codec<A> codec, [int? limit]) =>
    ListCodec(codec, limit: Option(limit));

Codec<List<A>> listOfN<A>(Codec<int> countCodec, Codec<A> valueCodec) =>
    Codec.of(
      countCodec.flatMap((count) => list(valueCodec, count)),
      Encoder.instance((as) => countCodec
          .encode(as.length)
          .flatMap((x) => valueCodec.encodeAll(as).map((y) => x.concat(y)))),
    );

Codec<IList<A>> ilist<A>(Codec<A> codec, [int? limit]) =>
    list(codec, limit).xmap(IList.of, (il) => il.toList());

Codec<IList<A>> ilistOfN<A>(Codec<int> countCodec, Codec<A> valueCodec) =>
    listOfN(countCodec, valueCodec).xmap(IList.of, (il) => il.toList());

Codec<A> peek<A>(Codec<A> target) => Codec.of(
      Decoder.instance(
          (b) => target.decode(b).map((a) => a.mapRemainder((_) => b))),
      target,
      description: 'peek($target)',
    );

Codec<Option<A>> option<A>(Codec<bool> indicator, Codec<A> valueCodec) =>
    either(indicator, provide(null), valueCodec)
        .xmap((a) => a.toOption(), (a) => a.toRight(() => null));

Codec<Either<A, B>> either<A, B>(
  Codec<bool> indicator,
  Codec<A> leftCodec,
  Codec<B> rightCodec,
) =>
    EitherCodec(indicator, leftCodec, rightCodec);

Codec<A> byteAligned<A>(Codec<A> codec) => ByteAlignedCodec(codec);

extension CodecOps<A> on Codec<A> {
  Codec<Option<A>> optional(Codec<bool> indicator) => option(indicator, this);
}
