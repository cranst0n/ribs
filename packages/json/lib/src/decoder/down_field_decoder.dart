import 'package:ribs_json/ribs_json.dart';

final class DownFieldDecoder<A> extends Decoder<A> {
  final String key;
  final Decoder<A> valueDecoder;

  DownFieldDecoder(this.key, this.valueDecoder);

  @override
  DecodeResult<A> decodeC(HCursor cursor) {
    final json = cursor.value;
    if (json is JObject) {
      final v = json.value.tryGet(key);
      if (v != null) return valueDecoder.decode(v);
    }
    return valueDecoder.tryDecodeC(cursor.downField(key));
  }

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) {
    if (cursor is HCursor) {
      final json = cursor.value;
      if (json is JObject) {
        final v = json.value.tryGet(key);
        if (v != null) return valueDecoder.decode(v);
      }
    }
    return valueDecoder.tryDecodeC(cursor.downField(key));
  }
}
