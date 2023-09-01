import 'package:ribs_json/ribs_json.dart';

final class DownFieldDecoder<A> extends Decoder<A> {
  final String key;
  final Decoder<A> valueDecoder;

  DownFieldDecoder(this.key, this.valueDecoder);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) =>
      valueDecoder.tryDecodeC(cursor.downField(key));
}
