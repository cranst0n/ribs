import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An immutable, ordered JSON object (key-value map).
///
/// Keys are [String]s and values are [Json]. Insertion order is preserved.
/// Use the factory methods to construct instances and [add], [remove],
/// [mapValues], and [filter] to produce modified copies.
@immutable
sealed class JsonObject {
  /// An empty [JsonObject].
  static JsonObject get empty => _LinkedHashMapJsonObject(LinkedHashMap());

  /// Creates a [JsonObject] from an [IList] of `(key, value)` pairs.
  static JsonObject fromIList(IList<(String, Json)> fields) => fromIterable(fields.toList());

  /// Creates a [JsonObject] from an [Iterable] of `(key, value)` pairs.
  /// Later entries with the same key overwrite earlier ones.
  static JsonObject fromIterable(Iterable<(String, Json)> fields) {
    final map = <String, Json>{};

    for (final (k, v) in fields) {
      map[k] = v;
    }

    return _LinkedHashMapJsonObject(map as LinkedHashMap<String, Json>);
  }

  /// Wraps an existing [Map] directly, avoiding repeated iteration.
  static JsonObject fromMap(Map<String, Json> fields) =>
      _LinkedHashMapJsonObject(LinkedHashMap.from(fields));

  /// Returns a copy with [key] set to [value] (overwrites if [key] exists).
  JsonObject add(String key, Json value);

  /// Iterates over all key-value pairs in insertion order.
  void forEach(void Function(String key, Json value) f);

  /// Returns [Some] with the value for [key], or [None] if absent.
  Option<Json> get(String key);

  /// Returns the value for [key], or `null` if absent. Avoids [Option] allocation.
  Json? tryGet(String key);

  /// Returns the value for [key], throwing if absent.
  Json getUnsafe(String key);

  /// Returns `true` if [key] is present.
  bool contains(String key);

  /// Recursively merges [that] into this object.
  ///
  /// Fields present in both are merged recursively; fields only in this object
  /// are added to [that].
  JsonObject deepMerge(JsonObject that) => toIList().foldLeft(
    that,
    (acc, kv) => that
        .get(kv.$1)
        .fold(
          () => acc.add(kv.$1, kv.$2),
          (r) => acc.add(kv.$1, kv.$2.deepMerge(r)),
        ),
  );

  /// Returns a copy containing only the entries for which [p] returns `true`.
  JsonObject filter(Function1<(String, Json), bool> p) => JsonObject.fromIList(toIList().filter(p));

  /// Returns `true` if this object has no entries.
  bool get isEmpty;

  /// Returns `true` if this object has at least one entry.
  bool get isNotEmpty => !isEmpty;

  /// The keys of this object in insertion order.
  IList<String> get keys;

  /// Returns a copy with each value replaced by `f(value)`.
  JsonObject mapValues(Function1<Json, Json> f);

  /// Returns `true` if this object has at least one entry.
  bool get nonEmpty => !isEmpty;

  /// Returns a copy with [key] removed (no-op if [key] is absent).
  JsonObject remove(String key);

  /// The number of entries in this object.
  int get size;

  /// Returns the entries as an [IList] of `(key, value)` pairs in insertion
  /// order.
  IList<(String, Json)> toIList();

  /// Wraps this object in a [JObject].
  Json toJson() => Json.fromJsonObject(this);

  /// The values of this object in insertion order.
  IList<Json> get values;
}

final class _LinkedHashMapJsonObject extends JsonObject {
  final LinkedHashMap<String, Json> fields;

  _LinkedHashMapJsonObject(this.fields);

  @override
  JsonObject add(String key, Json value) =>
      _LinkedHashMapJsonObject(LinkedHashMap.of(fields)..addAll({key: value}));

  @override
  void forEach(void Function(String key, Json value) f) => fields.forEach(f);

  @override
  Option<Json> get(String key) => Option(fields[key]);

  @override
  Json? tryGet(String key) => fields[key];

  @override
  Json getUnsafe(String key) => fields[key]!;

  @override
  bool contains(String key) => fields.containsKey(key);

  @override
  bool get isEmpty => fields.isEmpty;

  @override
  IList<String> get keys => IList.fromDart(fields.keys);

  @override
  JsonObject mapValues(Function1<Json, Json> f) => _LinkedHashMapJsonObject(
    LinkedHashMap.from(fields.map((key, value) => MapEntry(key, f(value)))),
  );

  @override
  JsonObject remove(String key) => _LinkedHashMapJsonObject(LinkedHashMap.of(fields)..remove(key));

  @override
  int get size => fields.length;

  @override
  IList<(String, Json)> toIList() => IList.fromDart(fields.entries).map((e) => (e.key, e.value));

  @override
  IList<Json> get values => IList.fromDart(fields.values);

  @override
  String toString() {
    return keys.map((k) => '"$k": ${getUnsafe(k)}').mkString(start: '{ ', sep: ', ', end: ' }');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      if (other is JsonObject) {
        if (isEmpty && other.isEmpty) {
          return true;
        } else {
          if (size == other.size) {
            return keys.forall((k) => tryGet(k) == other.tryGet(k));
          } else {
            return false;
          }
        }
      } else {
        return false;
      }
    }
  }

  @override
  int get hashCode => fields.hashCode;
}
