import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// A codec that uses an initial value to determine which subsequent codec to use.
///
/// First decodes a discriminator of type `A` using the [by] codec, then uses
/// that value to look up the appropriate codec for type `B` in the [cases] map.
///
/// During encoding, [getDiscriminator] extracts the discriminator from the
/// value, which is used to select the matching codec from [cases].
final class DiscriminatorCodec<A, B> extends Codec<B> {
  /// The codec used to encode and decode the discriminator value.
  final Codec<A> by;

  /// Maps each discriminator value to the codec used to encode/decode the
  /// corresponding [B] value.
  final IMap<A, Codec<B>> cases;

  /// Extracts the discriminator value from a [B] instance.
  ///
  /// Used during encoding to select the appropriate codec from [cases].
  final A Function(B) getDiscriminator;

  DiscriminatorCodec._(this.by, this.cases, this.getDiscriminator);

  /// Creates a [DiscriminatorCodec] from a discriminator codec, a map of
  /// cases, and a function to extract the discriminator from a [B] value.
  static DiscriminatorCodec<A, B> typecases<A, B>(
    Codec<A> by,
    IMap<A, Codec<B>> typecases,
    A Function(B) getDiscriminator,
  ) => DiscriminatorCodec._(by, typecases, getDiscriminator);

  @override
  Either<Err, DecodeResult<B>> decode(BitVector bv) {
    return by
        .decode(bv)
        .flatMap(
          (a) => cases
              .get(a.value)
              .fold(
                () => Either.left<Err, DecodeResult<B>>(
                  Err.general('Missing typecase for: ${a.value}'),
                ),
                (decoder) => decoder.decode(a.remainder),
              ),
        );
  }

  @override
  Either<Err, BitVector> encode(B b) {
    final discriminator = getDiscriminator(b);
    return cases
        .get(discriminator)
        .fold(
          () => Either.left<Err, BitVector>(
            Err.general('Missing typecase for discriminator: $discriminator'),
          ),
          (decoder) => (by.encode(discriminator), decoder.encode(b)).mapN((a, b) => a.concat(b)),
        );
  }
}
