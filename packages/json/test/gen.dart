import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

const _maxJsonDepth = 3;
const _maxArraySize = 4;
const _maxObjectSize = 4;

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
    return Gen.listOf(size, genJsonAtDepth(depth - 1))
        .map((a) => JArray(a.toIList()));
  });
}

Gen<JsonObject> genObject(int depth) {
  return Gen.chooseInt(0, _maxObjectSize).flatMap((size) {
    final fields = Gen.listOf(
        size,
        Gen.alphaNumString(3).flatMap(
            (key) => genJsonAtDepth(depth - 1).map((value) => (key, value))));

    return fields.map(JsonObject.fromIterable);
  });
}

Gen<Json> genJsonAtDepth(int depth) {
  final deeperJsons = depth > 0
      ? ilist([
          genArray(depth),
          genObject(depth).map(Json.fromJsonObject),
        ])
      : nil<Gen<Json>>();

  return Gen.oneOfGen(
      ilist([genNull, genBoolean, genNumber, genString]).concat(deeperJsons));
}
