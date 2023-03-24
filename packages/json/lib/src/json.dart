import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

@immutable
abstract class Json {
  static Json Null = JNull();
  static Json True = JBoolean(true);
  static Json False = JBoolean(false);

  static Json arr(Iterable<Json> values) => JArray(IList.of(values));
  static Json arrI(IList<Json> values) => JArray(values);

  static Json obj(Iterable<Tuple2<String, Json>> fields) =>
      fromJsonObject(JsonObject.fromIterable(fields));

  static Json boolean(bool value) => JBoolean(value);
  static Json fromJsonObject(JsonObject value) => JObject(value);
  static Json number(num value) => value.isFinite ? JNumber(value) : Null;
  static Json str(String value) => JString(value);

  static Either<ParsingFailure, Json> parse(String input) {
    Either<ParsingFailure, Json> go(dynamic input) {
      if (input == null) {
        return Null.asRight();
      } else if (input is bool) {
        return JBoolean(input).asRight();
      } else if (input is String) {
        return JString(input).asRight();
      } else if (input is num) {
        return JNumber(input).asRight();
      } else if (input is List) {
        return IList.of(input).traverseEither(go).map(JArray.new);
      } else if (input is Map) {
        return IList.of(input.keys)
            .traverseEither(
                (k) => go(input[k]).map((v) => Tuple2(k.toString(), v)))
            .map((keyValues) =>
                JObject(JsonObject.fromIterable(keyValues.toList())));
      } else {
        return ParsingFailure('Unknown JSON element: $input').asLeft();
      }
    }

    return Either.catching(() => jsonDecode(input),
        (error, _) => ParsingFailure(error.toString())).flatMap(go);
  }

  static Either<Error, A> parseAs<A>(String input, Decoder<A> decoder) =>
      parse(input).leftMap<Error>((a) => a).flatMap((a) => a.decode(decoder));

  DecodeResult<A> decode<A>(Decoder<A> decoder) => decoder.decode(hcursor);

  A foldWith<A>(JsonFolder<A> folder);

  A fold<A>(
    Function0<A> jsonNull,
    Function1<bool, A> jsonBoolean,
    Function1<num, A> jsonNumber,
    Function1<String, A> jsonString,
    Function1<IList<Json>, A> jsonArray,
    Function1<JsonObject, A> jsonObject,
  ) {
    final self = this;

    if (self is JNull) {
      return jsonNull();
    } else if (self is JBoolean) {
      return jsonBoolean(self.value);
    } else if (self is JNumber) {
      return jsonNumber(self.value);
    } else if (self is JString) {
      return jsonString(self.value);
    } else if (self is JArray) {
      return jsonArray(self.value);
    } else if (self is JObject) {
      return jsonObject(self.value);
    } else {
      throw UnsupportedError('Invalid JSON: $this');
    }
  }

  Json get dropNullValues =>
      mapObject((a) => a.filter((keyValue) => !keyValue.$2.isNull));

  Json get deepDropNullValues => foldWith(_DropNullFolder());

  static Json deepMergeAll(Iterable<Json> json) =>
      json.fold(Json.obj([]), (a, b) => a.deepMerge(b));

  Json deepMerge(Json that) => Option.map2(
        asObject,
        that.asObject,
        (lhs, rhs) => fromJsonObject(lhs.toIList().foldLeft(
              rhs,
              (acc, kv) => rhs.apply(kv.$1).fold(
                    () => acc.add(kv.$1, kv.$2),
                    (r) => acc.add(kv.$1, kv.$2.deepMerge(r)),
                  ),
            )),
      ).getOrElse(() => that);

  String printWith(Printer printer) => printer.print(this);

  bool get isNull;
  bool get isBoolean;
  bool get isNumber;
  bool get isString;
  bool get isArray;
  bool get isObject;

  Option<Unit> get asNull;
  Option<bool> get asBoolean;
  Option<num> get asNumber;
  Option<String> get asString;
  Option<IList<Json>> get asArray;
  Option<JsonObject> get asObject;

  Json withNull(Function0<Json> f);
  Json withBoolean(Function1<bool, Json> f);
  Json withNumber(Function1<num, Json> f);
  Json withString(Function1<String, Json> f);
  Json withArray(Function1<IList<Json>, Json> f);
  Json withObject(Function1<JsonObject, Json> f);

  Json mapBoolean(Function1<bool, bool> f);
  Json mapNumber(Function1<num, num> f);
  Json mapString(Function1<String, String> f);
  Json mapArray(Function1<IList<Json>, IList<Json>> f);
  Json mapObject(Function1<JsonObject, JsonObject> f);

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

class JNull extends Json {
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
  Option<IList<Json>> get asArray => none();

  @override
  Option<bool> get asBoolean => none();

  @override
  Option<Unit> get asNull => Unit().some;

  @override
  Option<num> get asNumber => none();

  @override
  Option<JsonObject> get asObject => none();

  @override
  Option<String> get asString => none();

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

class JBoolean extends Json {
  final bool value;

  JBoolean(this.value);

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
  Option<IList<Json>> get asArray => none();

  @override
  Option<bool> get asBoolean => value.some;

  @override
  Option<Unit> get asNull => none();

  @override
  Option<num> get asNumber => none();

  @override
  Option<JsonObject> get asObject => none();

  @override
  Option<String> get asString => none();

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

class JNumber extends Json {
  final num value;

  JNumber(this.value);

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
  Option<IList<Json>> get asArray => none();

  @override
  Option<bool> get asBoolean => none();

  @override
  Option<Unit> get asNull => none();

  @override
  Option<num> get asNumber => value.some;

  @override
  Option<JsonObject> get asObject => none();

  @override
  Option<String> get asString => none();

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

class JString extends Json {
  final String value;

  JString(this.value);

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
  Option<IList<Json>> get asArray => none();

  @override
  Option<bool> get asBoolean => none();

  @override
  Option<Unit> get asNull => none();

  @override
  Option<num> get asNumber => none();

  @override
  Option<JsonObject> get asObject => none();

  @override
  Option<String> get asString => value.some;

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

class JArray extends Json {
  final IList<Json> value;

  JArray(this.value);

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
  Option<IList<Json>> get asArray => value.some;

  @override
  Option<bool> get asBoolean => none();

  @override
  Option<Unit> get asNull => none();

  @override
  Option<num> get asNumber => none();

  @override
  Option<JsonObject> get asObject => none();

  @override
  Option<String> get asString => none();

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

class JObject extends Json {
  final JsonObject value;

  JObject(this.value);

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
  Option<IList<Json>> get asArray => none();

  @override
  Option<bool> get asBoolean => none();

  @override
  Option<Unit> get asNull => none();

  @override
  Option<num> get asNumber => none();

  @override
  Option<JsonObject> get asObject => value.some;

  @override
  Option<String> get asString => none();

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

abstract class JsonFolder<A> {
  A onNull();
  A onBoolean(bool value);
  A onNumber(num value);
  A onString(String value);
  A onArray(IList<Json> value);
  A onObject(JsonObject value);

  static JsonFolder<A> of<A>(
    Function0<A> onNull,
    Function1<bool, A> onBoolean,
    Function1<num, A> onNumber,
    Function1<String, A> onString,
    Function1<IList<Json>, A> onArray,
    Function1<JsonObject, A> onObject,
  ) =>
      _JsonFolderF(onNull, onBoolean, onNumber, onString, onArray, onObject);
}

class _JsonFolderF<A> extends JsonFolder<A> {
  final Function0<A> _onNullF;
  final Function1<bool, A> _onBooleanF;
  final Function1<num, A> _onNumberF;
  final Function1<String, A> _onStringF;
  final Function1<IList<Json>, A> _onArrayF;
  final Function1<JsonObject, A> _onObjectF;

  _JsonFolderF(this._onNullF, this._onBooleanF, this._onNumberF,
      this._onStringF, this._onArrayF, this._onObjectF);

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
  Json onObject(JsonObject value) => Json.fromJsonObject(
      value.filter((a) => !a.$2.isNull).mapValues((a) => a.foldWith(this)));
}
