import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';

/// A [Decoder] that decodes a [JObject] into a Dart [Map].
///
/// Each JSON object key is decoded by [decodeK] and each value by [decodeV].
/// Fails immediately on the first key or value that cannot be decoded.
/// Created by [Decoder.mapOf].
final class MapDecoder<K, V> extends Decoder<Map<K, V>> {
  /// The decoder applied to each object key string.
  final KeyDecoder<K> decodeK;

  /// The decoder applied to each object value.
  final Decoder<V> decodeV;

  /// Creates a [MapDecoder] using [decodeK] for keys and [decodeV] for values.
  MapDecoder(this.decodeK, this.decodeV);

  @override
  DecodeResult<Map<K, V>> decodeC(HCursor cursor) {
    if (cursor.value is JObject) {
      return _decodeJsonObject(cursor, (cursor.value as JObject).value);
    } else {
      return DecodingFailure(
        WrongTypeExpectation('object', cursor.value),
        cursor.history(),
      ).asLeft();
    }
  }

  DecodeResult<Map<K, V>> _decodeJsonObject(HCursor cursor, JsonObject obj) {
    final builder = <K, V>{};
    DecodingFailure? failure;

    final keyIt = obj.keys.toList().iterator;

    while (failure == null && keyIt.moveNext()) {
      final key = keyIt.current;
      final valueCursor = ObjectCursor(obj, key, cursor, false, cursor, CursorOp.downField(key));

      failure = decodeK.decode(key).fold(
        () => _invalidKey(key, cursor),
        (key) {
          return decodeV.decodeC(valueCursor).fold(
            (failure) => failure,
            (value) {
              builder[key] = value;
              return null;
            },
          );
        },
      );
    }

    return Either.cond(
      () => failure == null,
      () => builder,
      () => failure!,
    );
  }

  static DecodingFailure _invalidKey(String key, HCursor cursor) =>
      DecodingFailure.fromString('Could not decode key: $key', cursor);
}
