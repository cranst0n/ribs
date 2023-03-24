import 'package:ribs_json/ribs_json.dart';

class CodecF<A> extends Codec<A> {
  final Decoder<A> decoder;
  final Encoder<A> encoder;

  CodecF(this.decoder, this.encoder);

  @override
  DecodeResult<A> decode(HCursor cursor) => decoder.decode(cursor);

  @override
  Json encode(A a) => encoder.encode(a);
}
