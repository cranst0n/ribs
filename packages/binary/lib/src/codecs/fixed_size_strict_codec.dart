import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class FixedSizeStrictCodec<A> extends Codec<A> {
  final int size;
  final Codec<A> codec;

  FixedSizeStrictCodec(this.size, this.codec);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) =>
      bv.size >= size
          ? codec.decode(bv.take(size)).map((res) => DecodeResult(res.value, bv.drop(size)))
          : Either.left(Err.insufficientBits(size, bv.size));

  @override
  Either<Err, BitVector> encode(A a) => codec
      .encode(a)
      .flatMap(
        (a) =>
            a.size == size
                ? Either.right<Err, BitVector>(a)
                : Either.left<Err, BitVector>(
                  Err.general(
                    '$a requires ${a.size} bytes but is fixed size of exactly $size bytes',
                  ),
                ),
      );

  @override
  String? get description => 'fixedSizeStrict($size, $codec)';
}
