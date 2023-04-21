import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';

final class MapDecoder<K, V> extends Decoder<Map<K, V>> {
  final KeyDecoder<K> decodeK;
  final Decoder<V> decodeV;

  MapDecoder(this.decodeK, this.decodeV);

  @override
  DecodeResult<Map<K, V>> decode(HCursor cursor) {
    if (cursor.value is JObject) {
      return _decodeJsonObject(cursor, (cursor.value as JObject).value);
    } else {
      return DecodingFailure(
              WrongTypeExpectation('object', cursor.value), cursor.history())
          .asLeft();
    }
  }

  DecodeResult<Map<K, V>> _decodeJsonObject(HCursor cursor, JsonObject obj) {
    final builder = <K, V>{};
    DecodingFailure? failure;

    final keyIt = obj.keys.toList().iterator;

    while (failure == null && keyIt.moveNext()) {
      final key = keyIt.current;
      final valueCursor = ObjectCursor(
          obj, key, cursor, false, cursor, CursorOp.downField(key));

      failure = decodeK.decode(key).fold(
        () => _invalidKey(key, cursor),
        (key) {
          return decodeV.decode(valueCursor).fold(
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
