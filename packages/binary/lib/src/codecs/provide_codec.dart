import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class ProvideCodec<A> extends Codec<A> {
  final A value;

  ProvideCodec(this.value);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) =>
      Either.right(DecodeResult(value, bv));

  @override
  Either<Err, BitVector> encode(A a) => Either.right(BitVector.empty());

  @override
  String? get description => 'provide($value)';
}
