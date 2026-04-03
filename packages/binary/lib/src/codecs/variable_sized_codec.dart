import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/fixed_size_codec.dart';
import 'package:ribs_core/ribs_core.dart';

/// A codec for variable-length structures that encodes their size before the payload.
///
/// On decode, it first reads the size in bits using [sizeCodec], reads exactly
/// that many bits using [valueCodec].
final class VariableSizedCodec<A> extends Codec<A> {
  final Codec<int> sizeCodec;
  final Codec<A> valueCodec;

  VariableSizedCodec(this.sizeCodec, this.valueCodec);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) =>
      sizeCodec.flatMap<A>((s) => FixedSizeCodec(s, valueCodec)).decode(bv);

  @override
  Either<Err, BitVector> encode(A a) =>
      valueCodec.encode(a).flatMap((a) => sizeCodec.encode(a.size).map((b) => b.concat(a)));

  @override
  String? get description => 'variableSized($sizeCodec, $valueCodec)';
}
