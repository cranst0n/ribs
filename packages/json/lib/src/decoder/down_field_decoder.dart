import 'package:ribs_json/ribs_json.dart';

final class DownFieldDecoder<A> extends Decoder<A> {
  final String key;
  final Decoder<A> valueDecoder;

  DownFieldDecoder(this.key, this.valueDecoder);

  @override
  DecodeResult<A> decode(HCursor cursor) => tryDecode(cursor);

  @override
  DecodeResult<A> tryDecode(ACursor cursor) =>
      valueDecoder.tryDecode(cursor.downField(key));
}
