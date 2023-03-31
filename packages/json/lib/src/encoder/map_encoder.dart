import 'package:ribs_json/ribs_json.dart';

final class MapEncoder<K, V> extends Encoder<Map<K, V>> {
  final KeyEncoder<K> encodeK;
  final Encoder<V> encodeV;

  MapEncoder(this.encodeK, this.encodeV);

  @override
  Json encode(Map<K, V> a) => Json.fromJsonObject(a.entries.fold(
        JsonObject.empty,
        (acc, entry) => acc.add(
          encodeK.encode(entry.key),
          encodeV.encode(entry.value),
        ),
      ));
}
