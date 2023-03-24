import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

class EitherCodec<A, B> extends Codec<Either<A, B>> {
  Codec<bool> indicator;
  Codec<A> leftCodec;
  Codec<B> rightCodec;

  EitherCodec(this.indicator, this.leftCodec, this.rightCodec);

  @override
  Either<Err, DecodeResult<Either<A, B>>> decode(BitVector bv) =>
      indicator.decode(bv).flatMap((a) => a.value
          ? rightCodec
              .decode(a.remainder)
              .map((r) => r.map((v) => Either.right(v)))
          : leftCodec
              .decode(a.remainder)
              .map((r) => r.map((v) => Either.left(v))));

  @override
  Either<Err, BitVector> encode(Either<A, B> a) => Either.map2(
        indicator.encode(a.fold((_) => false, (_) => true)),
        a.fold((a) => leftCodec.encode(a), (b) => rightCodec.encode(b)),
        (BitVector a, BitVector b) => a.concat(b),
      );

  @override
  String? get description => 'either($indicator, $leftCodec, $rightCodec)';
}
