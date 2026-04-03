import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// A codec that constrains the underlying codec to operate on exactly [size] bits.
///
/// On encode, pads the output of the underlying codec with low bits to reach
/// [size]. On decode, slices a [size]-bit sub-buffer for the underlying codec
/// to read from.
final class FixedSizeCodec<A> extends Codec<A> {
  final int size;
  final Codec<A> codec;

  FixedSizeCodec(this.size, this.codec);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) {
    if (bv.size >= size) {
      return codec.decode(bv.take(size)).map((res) => DecodeResult(res.value, bv.drop(size)));
    } else {
      return Either.left(Err.insufficientBits(size, bv.size));
    }
  }

  @override
  Either<Err, BitVector> encode(A a) => codec
      .encode(a)
      .map((a) => a.padTo(size))
      .flatMap(
        (bv) =>
            bv.size == size
                ? Either.right<Err, BitVector>(bv)
                : Either.left<Err, BitVector>(
                  Err.general('$bv requires ${bv.size} bytes but is fixed size of $size bits'),
                ),
      );

  @override
  String? get description => 'fixedSize($size, $codec)';
}
