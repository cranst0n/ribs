import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class ByteAlignedCodec<A> extends Codec<A> {
  final Codec<A> codec;

  ByteAlignedCodec(this.codec);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) =>
      codec.decode(bv).map((res) => res.mapRemainder(
          (r) => r.drop(_padAmount(bv.size - res.remainder.size))));

  @override
  Either<Err, BitVector> encode(A a) =>
      codec.encode(a).map((enc) => enc.padTo(enc.size + _padAmount(enc.size)));

  @override
  String? get description => 'byteAligned(${codec.toString})';

  int _padAmount(int size) {
    final mod = size % 8;
    return mod == 0 ? 0 : 8 - mod;
  }
}
