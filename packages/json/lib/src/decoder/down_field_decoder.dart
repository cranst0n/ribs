import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that navigates into object field [key] before decoding.
///
/// Uses a fast path that reads directly from the [JsonObject] when the cursor
/// is already focused on a [JObject], avoiding unnecessary cursor allocation.
/// Created by [Decoder.at].
final class DownFieldDecoder<A> extends Decoder<A> {
  /// The object field to navigate into before decoding.
  final String key;

  /// The decoder applied to the value at [key].
  final Decoder<A> valueDecoder;

  /// Creates a [DownFieldDecoder] for [key] using [valueDecoder].
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
