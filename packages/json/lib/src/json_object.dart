import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

@immutable
sealed class JsonObject {
  static JsonObject get empty => _LinkedHashMapJsonObject(LinkedHashMap());

  static JsonObject fromIList(IList<(String, Json)> fields) =>
      fromIterable(fields.toList());

  static JsonObject fromIterable(Iterable<(String, Json)> fields) =>
      _LinkedHashMapJsonObject(LinkedHashMap.fromIterables(
          fields.map((e) => e.$1), fields.map((e) => e.$2)));

  JsonObject add(String key, Json value);

  Option<Json> apply(String key);

  Json applyUnsafe(String key);

  bool contains(String key);

  JsonObject deepMerge(JsonObject that) => toIList().foldLeft(
        that,
        (acc, kv) => that.apply(kv.$1).fold(
              () => acc.add(kv.$1, kv.$2),
              (r) => acc.add(kv.$1, kv.$2.deepMerge(r)),
            ),
      );

  JsonObject filter(Function1<(String, Json), bool> p) =>
      JsonObject.fromIList(toIList().filter(p));

  bool get isEmpty;

  bool get isNotEmpty => !isEmpty;

  IList<String> get keys;

  JsonObject mapValues(Function1<Json, Json> f);

  bool get nonEmpty => !isEmpty;

  JsonObject remove(String key);

  int get size;

  IList<(String, Json)> toIList();

  IList<Json> get values;
}

final class _LinkedHashMapJsonObject extends JsonObject {
  final LinkedHashMap<String, Json> fields;

  _LinkedHashMapJsonObject(this.fields);

  @override
  JsonObject add(String key, Json value) =>
      _LinkedHashMapJsonObject(LinkedHashMap.of(fields)..addAll({key: value}));

  @override
  Option<Json> apply(String key) => Option.of(fields[key]);

  @override
  Json applyUnsafe(String key) => fields[key]!;

  @override
  bool contains(String key) => fields.containsKey(key);

  @override
  bool get isEmpty => fields.isEmpty;

  @override
  IList<String> get keys => IList.of(fields.keys);

  @override
  JsonObject mapValues(Function1<Json, Json> f) => _LinkedHashMapJsonObject(
      LinkedHashMap.from(fields.map((key, value) => MapEntry(key, f(value)))));

  @override
  JsonObject remove(String key) =>
      _LinkedHashMapJsonObject(LinkedHashMap.of(fields)..remove(key));

  @override
  int get size => fields.length;

  @override
  IList<(String, Json)> toIList() =>
      IList.of(fields.entries).map((e) => (e.key, e.value));

  @override
  IList<Json> get values => IList.of(fields.values);

  @override
  String toString() {
    return keys
        .map((k) => '"$k": ${applyUnsafe(k)}')
        .mkString(start: '{ ', sep: ', ', end: ' }');
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
            return keys.forall((k) => apply(k) == other.apply(k));
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
