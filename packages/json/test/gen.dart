import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

const _maxJsonDepth = 3;
const _maxArraySize = 5;
const _maxObjectSize = 5;

Gen<Json> genJson = genJsonAtDepth(_maxJsonDepth);

Gen<JNull> genNull = Gen.constant(JNull());

Gen<JBoolean> genBoolean = Gen.oneOf(ilist([JBoolean(false), JBoolean(true)]));

Gen<Json> genNumber = Gen.chooseDouble(-double.maxFinite, double.maxFinite)
    .map((x) => JNumber(x))
    .map((number) => number.value.isFinite ? number : JNull());

Gen<JString> genString = Gen.chooseInt(1, 6)
    .flatMap((n) => Gen.alphaNumString(n).map((x) => JString(x)));

Gen<JArray> genArray(int depth) {
  return Gen.chooseInt(0, _maxArraySize).flatMap((size) {
    return Gen.listOfN(size, genJsonAtDepth(depth - 1))
        .map((a) => JArray(a.toIList()));
  });
}

Gen<JsonObject> genObject(int depth) {
  return Gen.chooseInt(0, _maxObjectSize).flatMap((size) {
    final fields = Gen.listOfN(
        size,
        Gen.alphaNumString(3).flatMap(
            (key) => genJsonAtDepth(depth - 1).map((value) => (key, value))));

    return fields.map(JsonObject.fromIterable);
  });
}

Gen<Json> genJsonAtDepth(int depth) {
  return Gen.oneOfGen(ilist([
    genNull,
    genBoolean,
    genNumber,
    genString,
    if (depth > 0) genArray(depth),
    if (depth > 0) genObject(depth).map(Json.fromJsonObject),
  ]));
}
