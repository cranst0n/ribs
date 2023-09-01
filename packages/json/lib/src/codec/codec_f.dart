import 'package:ribs_json/ribs_json.dart';

final class CodecF<A> extends Codec<A> {
  final Decoder<A> decoder;
  final Encoder<A> encoder;

  CodecF(this.decoder, this.encoder);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => decoder.decodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => decoder.tryDecodeC(cursor);

  @override
  Json encode(A a) => encoder.encode(a);
}
