import 'package:ribs_json/ribs_json.dart';

/// An [Encoder] that converts a Dart [Map] to a [JObject].
///
/// Each key is encoded to a string by [encodeK] and each value by [encodeV].
/// Created by [Encoder.mapOf].
final class MapEncoder<K, V> extends Encoder<Map<K, V>> {
  /// The encoder applied to each map key.
  final KeyEncoder<K> encodeK;

  /// The encoder applied to each map value.
  final Encoder<V> encodeV;

  /// Creates a [MapEncoder] using [encodeK] for keys and [encodeV] for values.
  MapEncoder(this.encodeK, this.encodeV);

  @override
  Json encode(Map<K, V> a) => Json.fromJsonObject(
    a.entries.fold(
      JsonObject.empty,
      (acc, entry) => acc.add(
        encodeK.encode(entry.key),
        encodeV.encode(entry.value),
      ),
    ),
  );
}
