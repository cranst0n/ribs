import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class BooleanCodec extends Codec<bool> {
  @override
  Either<Err, DecodeResult<bool>> decode(BitVector bv) => bv.acquire(1).fold(
      (_) => Either.left(Err.insufficientBits(1, 0)),
      (bs) => DecodeResult(bs.head, bv.drop(1)).asRight());

  @override
  Either<Err, BitVector> encode(bool a) => Either.right(a ? BitVector.high(1) : BitVector.low(1));

  @override
  String? get description => 'bool';
}
