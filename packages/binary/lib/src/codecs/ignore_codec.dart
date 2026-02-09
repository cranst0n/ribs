import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class IgnoreCodec extends Codec<Unit> {
  final int size;

  IgnoreCodec(this.size);

  @override
  Either<Err, DecodeResult<Unit>> decode(BitVector bv) => bv
      .acquire(size)
      .fold(
        (_) => Either.left(Err.insufficientBits(size, bv.size)),
        (bytes) => Either.right(DecodeResult(Unit(), bv.drop(size))),
      );

  @override
  Either<Err, BitVector> encode(Unit _) => Either.right(BitVector.low(size));

  @override
  String? get description => 'ignore($size)';
}
