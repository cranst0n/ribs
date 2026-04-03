import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// A codec that provides a constant value without consuming or producing any bits.
///
/// On decode, it immediately returns [value] and leaves the [BitVector] unchanged.
/// On encode, it always produces an empty [BitVector].
final class ProvideCodec<A> extends Codec<A> {
  final A value;

  ProvideCodec(this.value);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) => Either.right(DecodeResult(value, bv));

  @override
  Either<Err, BitVector> encode(A a) => Either.right(BitVector.empty);

  @override
  String? get description => 'provide($value)';
}
