import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

const _maxJsonDepth = 3;
const _maxArraySize = 5;
const _maxObjectSize = 5;

Gen<Json> genJson = genJsonAtDepth(_maxJsonDepth);

Gen<JNull> genNull = Gen.constant(JNull());

Gen<JBoolean> genBoolean = Gen.oneOf([JBoolean(false), JBoolean(true)]);

Gen<Json> genNumber = Gen.oneOfGen([genNumberInt, genNumberDouble]);

Gen<Json> genNumberInt = Gen.integer
    .map((x) => JNumber(x))
    .map((number) => number.value.isFinite ? number : JNull());

Gen<Json> genNumberDouble = Gen.chooseDouble(
  -double.maxFinite,
  double.maxFinite,
  specials: ilist([double.infinity, double.negativeInfinity, double.nan]),
).map((x) => JNumber(x)).map((number) => number.value.isFinite ? number : JNull());

Gen<JString> genString = Gen.chooseInt(
  1,
  6,
).flatMap((n) => Gen.alphaNumString(n).map((x) => JString(x)));

Gen<JArray> genArray(int depth) => Gen.listOf(
  Gen.chooseInt(0, _maxArraySize),
  genJsonAtDepth(depth - 1),
).map((a) => JArray(a.toIList()));

Gen<(String, Json)> genObjElem(int depth) =>
    Gen.alphaNumString(10).flatMap((key) => genJsonAtDepth(depth - 1).map((value) => (key, value)));

Gen<JsonObject> genObject(int depth) =>
    Gen.listOf(Gen.chooseInt(0, _maxObjectSize), genObjElem(depth)).map(JsonObject.fromIterable);

Gen<Json> genJsonAtDepth(int depth) => Gen.oneOfGen([
  genNull,
  genBoolean,
  genNumber,
  genString,
  if (depth > 0) genArray(depth),
  if (depth > 0) genObject(depth).map(Json.fromJsonObject),
]);
