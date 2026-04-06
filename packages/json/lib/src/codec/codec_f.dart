import 'package:ribs_json/ribs_json.dart';

/// A [Codec] assembled from a separate [Decoder] and [Encoder].
///
/// Prefer constructing instances via [Codec.from] rather than directly.
final class CodecF<A> extends Codec<A> {
  /// The decoder used by this codec.
  final Decoder<A> decoder;

  /// The encoder used by this codec.
  final Encoder<A> encoder;

  /// Creates a codec that delegates to [decoder] and [encoder].
  CodecF(this.decoder, this.encoder);

  @override
  DecodeResult<A> decode(Json json) => decoder.decode(json);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => decoder.decodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => decoder.tryDecodeC(cursor);

  @override
  Json encode(A a) => encoder.encode(a);
}
