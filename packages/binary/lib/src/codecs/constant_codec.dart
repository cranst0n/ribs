import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class ConstantCodec extends Codec<Unit> {
  final BitVector constant;

  ConstantCodec(this.constant);

  @override
  Either<Err, DecodeResult<Unit>> decode(BitVector bv) {
    return bv.aquire(constant.size).fold(
        (err) => Either.left(Err.insufficientBits(constant.size, bv.size)),
        (actual) => Either.cond(
              () => actual == constant,
              () => DecodeResult(Unit(), bv.drop(constant.size)),
              () => Err.general('Expected constant $constant but got $actual'),
            ));
  }

  @override
  Either<Err, BitVector> encode(void a) => Either.right(constant);

  @override
  String? get description => 'constant($constant)';
}
