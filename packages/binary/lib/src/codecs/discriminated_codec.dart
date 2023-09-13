import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

// TODO: Basic tests show this works for some simple cases but need to examine
// if this can be improved. Have a feeling there are non-rare cases where this
// will break down.
final class DiscriminatorCodec<A, B> extends Codec<B> {
  final Codec<A> by;
  final IMap<A, Codec<B>> cases;

  DiscriminatorCodec._(this.by, this.cases);

  static DiscriminatorCodec<A, B> typecases<A, B>(
          Codec<A> by, IMap<A, Codec<B>> typecases) =>
      DiscriminatorCodec._(by, typecases);

  @override
  Either<Err, DecodeResult<B>> decode(BitVector bv) {
    return by.decode(bv).flatMap((a) => cases.get(a.value).fold(
        () => Either.left<Err, DecodeResult<B>>(
            Err.general('Missing typecase for: ${a.value}')),
        (decoder) => decoder.decode(a.remainder)));
  }

  @override
  Either<Err, BitVector> encode(B b) {
    return cases.find((k, v) => v.tag == b.runtimeType).fold(
        () => Either.left<Err, BitVector>(
            Err.general('Missing typecase for: ${b.runtimeType}')),
        (t) => (by.encode(t.$1), t.$2.encode(b)).mapN((a, b) => a.concat(b)));
  }
}
