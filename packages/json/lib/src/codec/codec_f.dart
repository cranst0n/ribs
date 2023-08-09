import 'package:ribs_json/ribs_json.dart';

final class CodecF<A> extends Codec<A> {
  final Decoder<A> decoder;
  final Encoder<A> encoder;

  CodecF(this.decoder, this.encoder);

  @override
  DecodeResult<A> decode(HCursor cursor) => decoder.decode(cursor);

  @override
  DecodeResult<A> tryDecode(ACursor cursor) => decoder.tryDecode(cursor);

  @override
  Json encode(A a) => encoder.encode(a);
}
