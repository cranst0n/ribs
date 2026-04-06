import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart' as dawn;

/// An immutable JSON value.
///
/// The sealed subtypes are [JNull], [JBoolean], [JNumber], [JString],
/// [JArray], and [JObject]. Use the static factory methods to construct values
/// and [fold] / [foldWith] for exhaustive pattern matching.
@immutable
sealed class Json {
  /// The singleton JSON `null` value.
  static const Json Null = JNull();

  /// The singleton JSON `true` value.
  static const Json True = JBoolean(true);

  /// The singleton JSON `false` value.
  static const Json False = JBoolean(false);

  /// Creates a [JArray] from an [Iterable].
  static Json arr(Iterable<Json> values) => JArray(IList.fromDart(values));

  /// Creates a [JArray] from an [IList].
  static Json arrI(IList<Json> values) => JArray(values);

  /// Creates a [JObject] from an iterable of `(key, value)` pairs.
  static Json obj(Iterable<(String, Json)> fields) =>
      fromJsonObject(JsonObject.fromIterable(fields));

  /// Creates a [JBoolean].
  static Json boolean(bool value) => JBoolean(value);

  /// Wraps a [JsonObject] in a [JObject].
  static Json fromJsonObject(JsonObject value) => JObject(value);

  /// Creates a [JNumber], or [Null] if [value] is non-finite.
  static Json number(num value) => value.isFinite ? JNumber(value) : Null;

  /// Creates a [JString].
  static Json str(String value) => JString(value);

  /// Parses [input] as JSON, returning `Right(json)` or `Left(failure)`.
  static Either<ParsingFailure, Json> parse(String input) => dawn.Parser.parseFromString(input);

  /// Parses [input] as UTF-8 JSON bytes, returning `Right(json)` or
  /// `Left(failure)`.
  static Either<ParsingFailure, Json> parseBytes(Uint8List input) =>
      dawn.Parser.parseFromBytes(input);

  /// Parses [input] and decodes the result with [decoder] in one step.
  static Either<Error, A> decode<A>(String input, Decoder<A> decoder) =>
      parse(input).leftMap<Error>(identity).flatMap((a) => decoder.decode(a));

  /// Parses [input] bytes and decodes the result with [decoder] in one step.
  static Either<Error, A> decodeBytes<A>(Uint8List input, Decoder<A> decoder) =>
      parseBytes(input).leftMap<Error>(identity).flatMap((a) => decoder.decode(a));

  const Json();

  /// Dispatches to [folder] based on the runtime subtype of this value.
  A foldWith<A>(JsonFolder<A> folder);

  /// Pattern-matches this value, calling the corresponding function for each
  /// subtype.
  A fold<A>(
    Function0<A> jsonNull,
    Function1<bool, A> jsonBoolean,
    Function1<num, A> jsonNumber,
    Function1<String, A> jsonString,
    Function1<IList<Json>, A> jsonArray,
    Function1<JsonObject, A> jsonObject,
  ) => switch (this) {
    JNull _ => jsonNull(),
    final JBoolean b => jsonBoolean(b.value),
    final JNumber n => jsonNumber(n.value),
    final JString s => jsonString(s.value),
    final JArray a => jsonArray(a.value),
    final JObject o => jsonObject(o.value),
  };

  /// Returns a copy with all top-level object fields whose value is [JNull]
  /// removed.
  Json dropNullValues() => mapObject((a) => a.filter((keyValue) => !keyValue.$2.isNull));

  /// Returns a copy with all [JNull] values removed recursively.
  Json deepDropNullValues() => foldWith(_DropNullFolder());

  /// Recursively merges all values in [json] left-to-right, starting from an
  /// empty object.
  static Json deepMergeAll(Iterable<Json> json) =>
      json.fold(Json.obj([]), (a, b) => a.deepMerge(b));

  /// Recursively merges [that] into this value.
  ///
  /// Object fields from this value take precedence; fields present in both are
  /// merged recursively. If either value is not a [JObject], returns [that].
  Json deepMerge(Json that) => (asObject(), that.asObject())
      .mapN(
        (lhs, rhs) => fromJsonObject(
          lhs.toIList().foldLeft(
            rhs,
            (acc, kv) => rhs
                .get(kv.$1)
                .fold(
                  () => acc.add(kv.$1, kv.$2),
                  (r) => acc.add(kv.$1, kv.$2.deepMerge(r)),
                ),
          ),
        ),
      )
      .getOrElse(() => that);

  /// Renders this value using [printer].
  String printWith(Printer printer) => printer.print(this);

  /// Returns `true` if this value is [JNull].
  bool get isNull;

  /// Returns `true` if this value is a [JBoolean].
  bool get isBoolean;

  /// Returns `true` if this value is a [JNumber].
  bool get isNumber;

  /// Returns `true` if this value is a [JString].
  bool get isString;

  /// Returns `true` if this value is a [JArray].
  bool get isArray;

  /// Returns `true` if this value is a [JObject].
  bool get isObject;

  /// Returns [Some] with [Unit] if this is [JNull], otherwise [None].
  Option<Unit> asNull();

  /// Returns [Some] with the boolean if this is [JBoolean], otherwise [None].
  Option<bool> asBoolean();

  /// Returns [Some] with the number if this is [JNumber], otherwise [None].
  Option<num> asNumber();

  /// Returns [Some] with the string if this is [JString], otherwise [None].
  Option<String> asString();

  /// Returns [Some] with the elements if this is [JArray], otherwise [None].
  Option<IList<Json>> asArray();

  /// Returns [Some] with the [JsonObject] if this is [JObject], otherwise [None].
  Option<JsonObject> asObject();

  /// If this is [JNull], returns `f()`; otherwise returns this unchanged.
  Json withNull(Function0<Json> f);

  /// If this is [JBoolean], returns `f(value)`; otherwise returns this unchanged.
  Json withBoolean(Function1<bool, Json> f);

  /// If this is [JNumber], returns `f(value)`; otherwise returns this unchanged.
  Json withNumber(Function1<num, Json> f);

  /// If this is [JString], returns `f(value)`; otherwise returns this unchanged.
  Json withString(Function1<String, Json> f);

  /// If this is [JArray], returns `f(elements)`; otherwise returns this unchanged.
  Json withArray(Function1<IList<Json>, Json> f);

  /// If this is [JObject], returns `f(object)`; otherwise returns this unchanged.
  Json withObject(Function1<JsonObject, Json> f);

  /// If this is [JBoolean], returns a [JBoolean] with the value mapped through
  /// [f]; otherwise returns this unchanged.
  Json mapBoolean(Function1<bool, bool> f);

  /// If this is [JNumber], returns a [JNumber] with the value mapped through
  /// [f]; otherwise returns this unchanged.
  Json mapNumber(Function1<num, num> f);

  /// If this is [JString], returns a [JString] with the value mapped through
  /// [f]; otherwise returns this unchanged.
  Json mapString(Function1<String, String> f);

  /// If this is [JArray], returns a [JArray] with the elements mapped through
  /// [f]; otherwise returns this unchanged.
  Json mapArray(Function1<IList<Json>, IList<Json>> f);

  /// If this is [JObject], returns a [JObject] with the [JsonObject] mapped
  /// through [f]; otherwise returns this unchanged.
  Json mapObject(Function1<JsonObject, JsonObject> f);

  /// Returns an [HCursor] positioned at the root of this value.
  HCursor get hcursor => HCursor.fromJson(this);

  @override
  bool operator ==(Object other) {
    return fold(
      () => other is JNull,
      (boolean) => other is JBoolean && other.value == boolean,
      (number) => other is JNumber && other.value == number,
      (string) => other is JString && other.value == string,
      (ilist) => other is JArray && other.value == ilist,
      (object) => other is JObject && other.value == object,
    );
  }

  @override
  int get hashCode => fold(
    () => 0,
    (boolean) => boolean.hashCode,
    (number) => number.hashCode,
    (string) => string.hashCode,
    (ilist) => ilist.hashCode,
    (object) => object.keys.hashCode * object.values.hashCode,
  );
}

/// The JSON `null` value.
final class JNull extends Json {
  const JNull();

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onNull();

  @override
  bool get isNull => true;
  @override
  bool get isBoolean => false;
  @override
  bool get isNumber => false;
  @override
  bool get isString => false;
  @override
  bool get isArray => false;
  @override
  bool get isObject => false;

  @override
  Option<IList<Json>> asArray() => none();

  @override
  Option<bool> asBoolean() => none();

  @override
  Option<Unit> asNull() => Some(Unit());

  @override
  Option<num> asNumber() => none();

  @override
  Option<JsonObject> asObject() => none();

  @override
  Option<String> asString() => none();

  @override
  Json withArray(Function1<IList<Json>, Json> f) => this;

  @override
  Json withBoolean(Function1<bool, Json> f) => this;

  @override
  Json withNull(Function0<Json> f) => f();

  @override
  Json withNumber(Function1<num, Json> f) => this;

  @override
  Json withObject(Function1<JsonObject, Json> f) => this;

  @override
  Json withString(Function1<String, Json> f) => this;

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => this;

  @override
  Json mapBoolean(Function1<bool, bool> f) => this;

  @override
  Json mapNumber(Function1<num, num> f) => this;

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => this;

  @override
  Json mapString(Function1<String, String> f) => this;

  @override
  String toString() => 'JNull';
}

/// A JSON boolean value (`true` or `false`).
final class JBoolean extends Json {
  /// The boolean value.
  final bool value;

  const JBoolean(this.value);

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onBoolean(value);

  @override
  bool get isNull => false;
  @override
  bool get isBoolean => true;
  @override
  bool get isNumber => false;
  @override
  bool get isString => false;
  @override
  bool get isArray => false;
  @override
  bool get isObject => false;

  @override
  Option<IList<Json>> asArray() => none();

  @override
  Option<bool> asBoolean() => Some(value);

  @override
  Option<Unit> asNull() => none();

  @override
  Option<num> asNumber() => none();

  @override
  Option<JsonObject> asObject() => none();

  @override
  Option<String> asString() => none();

  @override
  Json withArray(Function1<IList<Json>, Json> f) => this;

  @override
  Json withBoolean(Function1<bool, Json> f) => f(value);

  @override
  Json withNull(Function0<Json> f) => this;

  @override
  Json withNumber(Function1<num, Json> f) => this;

  @override
  Json withObject(Function1<JsonObject, Json> f) => this;

  @override
  Json withString(Function1<String, Json> f) => this;

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => this;

  @override
  Json mapBoolean(Function1<bool, bool> f) => JBoolean(f(value));

  @override
  Json mapNumber(Function1<num, num> f) => this;

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => this;

  @override
  Json mapString(Function1<String, String> f) => this;

  @override
  String toString() => 'JBoolean($value)';
}

/// A JSON number value.
final class JNumber extends Json {
  /// The numeric value.
  final num value;

  const JNumber(this.value);

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onNumber(value);

  @override
  bool get isNull => false;
  @override
  bool get isBoolean => false;
  @override
  bool get isNumber => true;
  @override
  bool get isString => false;
  @override
  bool get isArray => false;
  @override
  bool get isObject => false;

  @override
  Option<IList<Json>> asArray() => none();

  @override
  Option<bool> asBoolean() => none();

  @override
  Option<Unit> asNull() => none();

  @override
  Option<num> asNumber() => Option(value);

  @override
  Option<JsonObject> asObject() => none();

  @override
  Option<String> asString() => none();

  @override
  Json withArray(Function1<IList<Json>, Json> f) => this;

  @override
  Json withBoolean(Function1<bool, Json> f) => this;

  @override
  Json withNull(Function0<Json> f) => this;

  @override
  Json withNumber(Function1<num, Json> f) => f(value);

  @override
  Json withObject(Function1<JsonObject, Json> f) => this;

  @override
  Json withString(Function1<String, Json> f) => this;

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => this;

  @override
  Json mapBoolean(Function1<bool, bool> f) => this;

  @override
  Json mapNumber(Function1<num, num> f) {
    final newValue = f(value);
    return newValue.isFinite ? JNumber(newValue) : Json.Null;
  }

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => this;

  @override
  Json mapString(Function1<String, String> f) => this;

  @override
  String toString() => 'JNumber($value)';
}

/// A JSON string value.
final class JString extends Json {
  /// The string value.
  final String value;

  const JString(this.value);

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onString(value);

  @override
  bool get isNull => false;
  @override
  bool get isBoolean => false;
  @override
  bool get isNumber => false;
  @override
  bool get isString => true;
  @override
  bool get isArray => false;
  @override
  bool get isObject => false;

  @override
  Option<IList<Json>> asArray() => none();

  @override
  Option<bool> asBoolean() => none();

  @override
  Option<Unit> asNull() => none();

  @override
  Option<num> asNumber() => none();

  @override
  Option<JsonObject> asObject() => none();

  @override
  Option<String> asString() => Some(value);

  @override
  Json withArray(Function1<IList<Json>, Json> f) => this;

  @override
  Json withBoolean(Function1<bool, Json> f) => this;

  @override
  Json withNull(Function0<Json> f) => this;

  @override
  Json withNumber(Function1<num, Json> f) => this;

  @override
  Json withObject(Function1<JsonObject, Json> f) => this;

  @override
  Json withString(Function1<String, Json> f) => f(value);

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => this;

  @override
  Json mapBoolean(Function1<bool, bool> f) => this;

  @override
  Json mapNumber(Function1<num, num> f) => this;

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => this;

  @override
  Json mapString(Function1<String, String> f) => JString(f(value));

  @override
  String toString() => 'JString("$value")';
}

/// A JSON array value.
final class JArray extends Json {
  /// The immutable list of elements.
  final IList<Json> value;

  const JArray(this.value);

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onArray(value);

  @override
  bool get isNull => false;
  @override
  bool get isBoolean => false;
  @override
  bool get isNumber => false;
  @override
  bool get isString => false;
  @override
  bool get isArray => true;
  @override
  bool get isObject => false;

  @override
  Option<IList<Json>> asArray() => Some(value);

  @override
  Option<bool> asBoolean() => none();

  @override
  Option<Unit> asNull() => none();

  @override
  Option<num> asNumber() => none();

  @override
  Option<JsonObject> asObject() => none();

  @override
  Option<String> asString() => none();

  @override
  Json withArray(Function1<IList<Json>, Json> f) => f(value);

  @override
  Json withBoolean(Function1<bool, Json> f) => this;

  @override
  Json withNull(Function0<Json> f) => this;

  @override
  Json withNumber(Function1<num, Json> f) => this;

  @override
  Json withObject(Function1<JsonObject, Json> f) => this;

  @override
  Json withString(Function1<String, Json> f) => this;

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => JArray(f(value));

  @override
  Json mapBoolean(Function1<bool, bool> f) => this;

  @override
  Json mapNumber(Function1<num, num> f) => this;

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => this;

  @override
  Json mapString(Function1<String, String> f) => this;

  @override
  String toString() => value.mkString(start: 'JArray([', sep: ', ', end: '])');
}

/// A JSON object value.
final class JObject extends Json {
  /// The immutable key-value map.
  final JsonObject value;

  const JObject(this.value);

  @override
  A foldWith<A>(JsonFolder<A> folder) => folder.onObject(value);

  @override
  bool get isNull => false;
  @override
  bool get isBoolean => false;
  @override
  bool get isNumber => false;
  @override
  bool get isString => false;
  @override
  bool get isArray => false;
  @override
  bool get isObject => true;

  @override
  Option<IList<Json>> asArray() => none();

  @override
  Option<bool> asBoolean() => none();

  @override
  Option<Unit> asNull() => none();

  @override
  Option<num> asNumber() => none();

  @override
  Option<JsonObject> asObject() => Some(value);

  @override
  Option<String> asString() => none();

  @override
  Json withArray(Function1<IList<Json>, Json> f) => this;

  @override
  Json withBoolean(Function1<bool, Json> f) => this;

  @override
  Json withNull(Function0<Json> f) => this;

  @override
  Json withNumber(Function1<num, Json> f) => this;

  @override
  Json withObject(Function1<JsonObject, Json> f) => f(value);

  @override
  Json withString(Function1<String, Json> f) => this;

  @override
  Json mapArray(Function1<IList<Json>, IList<Json>> f) => this;

  @override
  Json mapBoolean(Function1<bool, bool> f) => this;

  @override
  Json mapNumber(Function1<num, num> f) => this;

  @override
  Json mapObject(Function1<JsonObject, JsonObject> f) => JObject(f(value));

  @override
  Json mapString(Function1<String, String> f) => this;

  @override
  String toString() => 'JObject($value)';
}

/// Visitor interface for exhaustively processing a [Json] value.
///
/// Implement the `on*` methods and pass an instance to [Json.foldWith]. Use
/// [JsonFolder.of] to construct an anonymous folder from plain functions.
abstract class JsonFolder<A> {
  /// Called when the focused value is [JNull].
  A onNull();

  /// Called when the focused value is a [JBoolean].
  A onBoolean(bool value);

  /// Called when the focused value is a [JNumber].
  A onNumber(num value);

  /// Called when the focused value is a [JString].
  A onString(String value);

  /// Called when the focused value is a [JArray].
  A onArray(IList<Json> value);

  /// Called when the focused value is a [JObject].
  A onObject(JsonObject value);

  /// Creates a [JsonFolder] from plain functions.
  static JsonFolder<A> of<A>(
    Function0<A> onNull,
    Function1<bool, A> onBoolean,
    Function1<num, A> onNumber,
    Function1<String, A> onString,
    Function1<IList<Json>, A> onArray,
    Function1<JsonObject, A> onObject,
  ) => _JsonFolderF(onNull, onBoolean, onNumber, onString, onArray, onObject);
}

class _JsonFolderF<A> extends JsonFolder<A> {
  final Function0<A> _onNullF;
  final Function1<bool, A> _onBooleanF;
  final Function1<num, A> _onNumberF;
  final Function1<String, A> _onStringF;
  final Function1<IList<Json>, A> _onArrayF;
  final Function1<JsonObject, A> _onObjectF;

  _JsonFolderF(
    this._onNullF,
    this._onBooleanF,
    this._onNumberF,
    this._onStringF,
    this._onArrayF,
    this._onObjectF,
  );

  @override
  A onNull() => _onNullF();

  @override
  A onBoolean(bool value) => _onBooleanF(value);

  @override
  A onNumber(num value) => _onNumberF(value);

  @override
  A onString(String value) => _onStringF(value);

  @override
  A onArray(IList<Json> value) => _onArrayF(value);

  @override
  A onObject(JsonObject value) => _onObjectF(value);
}

class _DropNullFolder extends JsonFolder<Json> {
  @override
  Json onNull() => Json.Null;

  @override
  Json onBoolean(bool value) => JBoolean(value);

  @override
  Json onNumber(num value) => value.isFinite ? JNumber(value) : onNull();

  @override
  Json onString(String value) => JString(value);

  @override
  Json onArray(IList<Json> value) =>
      JArray(value.filter((a) => !a.isNull).map((a) => a.foldWith(this)));

  @override
  Json onObject(JsonObject value) =>
      Json.fromJsonObject(value.filter((a) => !a.$2.isNull).mapValues((a) => a.foldWith(this)));
}
