import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Json', () {
    forAll('hashCode / equality', genJson, (json) {
      expect(json, json);
      expect(json.hashCode, json.hashCode);
    });

    test('parseBytes', () {
      expect(
        Json.parse('[1, "string", 3.14]'),
        isRight<ParsingFailure, Json>(),
      );
    });

    test('dropNullValues', () {
      expect(
        Json.arr([Json.True, Json.number(1)]).dropNullValues(),
        Json.arr([Json.True, Json.number(1)]),
      );

      expect(
        Json.arr([Json.True, Json.number(1), Json.Null]).dropNullValues(),
        Json.arr([Json.True, Json.number(1), Json.Null]),
      );

      expect(
        Json.obj([('key1', Json.True), ('key2', Json.Null)]).dropNullValues(),
        Json.obj([('key1', Json.True)]),
      );

      expect(
        Json.obj([
          ('key1', Json.True),
          ('key2', Json.obj([('subkey', Json.Null)]))
        ]).dropNullValues(),
        Json.obj([
          ('key1', Json.True),
          ('key2', Json.obj([('subkey', Json.Null)]))
        ]),
      );
    });

    test('deepDropNullValues', () {
      expect(
        Json.arr([Json.True, Json.number(1)]).deepDropNullValues(),
        Json.arr([Json.True, Json.number(1)]),
      );

      expect(
        Json.arr([Json.True, Json.number(1), Json.Null]).deepDropNullValues(),
        Json.arr([Json.True, Json.number(1)]),
      );

      expect(
        Json.obj([('key1', Json.True), ('key2', Json.Null)])
            .deepDropNullValues(),
        Json.obj([('key1', Json.True)]),
      );

      expect(
        Json.obj([
          ('key1', Json.True),
          ('key2', Json.obj([('subkey', Json.Null)]))
        ]).deepDropNullValues(),
        Json.obj([('key1', Json.True), ('key2', Json.obj([]))]),
      );

      expect(
        Json.obj([
          ('key1', Json.True),
          ('key2', Json.obj([('subkey', Json.Null)])),
        ]).deepDropNullValues(),
        Json.obj([('key1', Json.True), ('key2', Json.obj([]))]),
      );
    });

    test('Null.isX', () {
      expect(Json.Null.isNull, isTrue);
      expect(Json.Null.isBoolean, isFalse);
      expect(Json.Null.isNumber, isFalse);
      expect(Json.Null.isString, isFalse);
      expect(Json.Null.isArray, isFalse);
      expect(Json.Null.isObject, isFalse);
    });

    test('Boolean.isX', () {
      expect(Json.True.isNull, isFalse);
      expect(Json.True.isBoolean, isTrue);
      expect(Json.True.isNumber, isFalse);
      expect(Json.True.isString, isFalse);
      expect(Json.True.isArray, isFalse);
      expect(Json.True.isObject, isFalse);
    });

    test('Number.isX', () {
      expect(Json.number(0).isNull, isFalse);
      expect(Json.number(0).isBoolean, isFalse);
      expect(Json.number(0).isNumber, isTrue);
      expect(Json.number(0).isString, isFalse);
      expect(Json.number(0).isArray, isFalse);
      expect(Json.number(0).isObject, isFalse);
    });

    test('String.isX', () {
      expect(Json.str('a').isNull, isFalse);
      expect(Json.str('a').isBoolean, isFalse);
      expect(Json.str('a').isNumber, isFalse);
      expect(Json.str('a').isString, isTrue);
      expect(Json.str('a').isArray, isFalse);
      expect(Json.str('a').isObject, isFalse);
    });

    test('Array.isX', () {
      expect(Json.arr([]).isNull, isFalse);
      expect(Json.arr([]).isBoolean, isFalse);
      expect(Json.arr([]).isNumber, isFalse);
      expect(Json.arr([]).isString, isFalse);
      expect(Json.arr([]).isArray, isTrue);
      expect(Json.arr([]).isObject, isFalse);
    });

    test('Object.isX', () {
      expect(Json.obj([]).isNull, isFalse);
      expect(Json.obj([]).isBoolean, isFalse);
      expect(Json.obj([]).isNumber, isFalse);
      expect(Json.obj([]).isString, isFalse);
      expect(Json.obj([]).isArray, isFalse);
      expect(Json.obj([]).isObject, isTrue);
    });

    test('asArray', () {
      expect(Json.Null.asArray(), isNone());
      expect(Json.True.asArray(), isNone());
      expect(Json.number(0).asArray(), isNone());
      expect(Json.str('').asArray(), isNone());
      expect(Json.arr([]).asArray(), isSome(nil<Json>()));
      expect(Json.obj([]).asArray(), isNone());
    });

    test('asBoolean', () {
      expect(Json.Null.asBoolean(), isNone());
      expect(Json.True.asBoolean(), isSome<bool>());
      expect(Json.number(0).asBoolean(), isNone());
      expect(Json.str('').asBoolean(), isNone());
      expect(Json.arr([]).asBoolean(), isNone());
      expect(Json.obj([]).asBoolean(), isNone());
    });

    test('asNull', () {
      expect(Json.Null.asNull(), isSome<Unit>());
      expect(Json.True.asNull(), isNone());
      expect(Json.number(0).asNull(), isNone());
      expect(Json.str('').asNull(), isNone());
      expect(Json.arr([]).asNull(), isNone());
      expect(Json.obj([]).asNull(), isNone());
    });

    test('asNumber', () {
      expect(Json.Null.asNumber(), isNone());
      expect(Json.True.asNumber(), isNone());
      expect(Json.number(0).asNumber(), isSome<num>(0));
      expect(Json.str('').asNumber(), isNone());
      expect(Json.arr([]).asNumber(), isNone());
      expect(Json.obj([]).asNumber(), isNone());
    });

    test('asObject', () {
      expect(Json.Null.asObject(), isNone());
      expect(Json.True.asObject(), isNone());
      expect(Json.number(0).asObject(), isNone());
      expect(Json.str('').asObject(), isNone());
      expect(Json.arr([]).asObject(), isNone());
      expect(Json.obj([]).asObject(), isSome(JsonObject.empty));
    });

    test('asString', () {
      expect(Json.Null.asString(), isNone());
      expect(Json.True.asString(), isNone());
      expect(Json.number(0).asString(), isNone());
      expect(Json.str('').asString(), isSome(''));
      expect(Json.arr([]).asString(), isNone());
      expect(Json.obj([]).asString(), isNone());
    });

    test('withArray', () {
      Json f(IList<Json> items) => items.headOption.getOrElse(() => Json.True);

      expect(Json.Null.withArray(f), Json.Null);
      expect(Json.False.withArray(f), Json.False);
      expect(Json.number(0).withArray(f), Json.number(0));
      expect(Json.str('').withArray(f), Json.str(''));
      expect(Json.arr([Json.Null]).withArray(f), Json.Null);
      expect(Json.obj([]).withArray(f), Json.obj([]));
    });

    test('withBoolean', () {
      expect(Json.Null.withBoolean((b) => Json.boolean(!b)), Json.Null);
      expect(Json.True.withBoolean((b) => Json.boolean(!b)), Json.False);

      expect(
          Json.number(0).withBoolean((b) => Json.boolean(!b)), Json.number(0));

      expect(Json.str('').withBoolean((b) => Json.boolean(!b)), Json.str(''));
      expect(Json.arr([]).withBoolean((b) => Json.boolean(!b)), Json.arr([]));
      expect(Json.obj([]).withBoolean((b) => Json.boolean(!b)), Json.obj([]));
    });

    test('withNull', () {
      expect(Json.Null.withNull(() => Json.True), Json.True);
      expect(Json.False.withNull(() => Json.True), Json.False);
      expect(Json.number(0).withNull(() => Json.True), Json.number(0));
      expect(Json.str('').withNull(() => Json.True), Json.str(''));
      expect(Json.arr([]).withNull(() => Json.True), Json.arr([]));
      expect(Json.obj([]).withNull(() => Json.True), Json.obj([]));
    });

    test('withNumber', () {
      expect(Json.Null.withNumber((n) => Json.number(n * 2)), Json.Null);
      expect(Json.True.withNumber((n) => Json.number(n * 2)), Json.True);

      expect(
          Json.number(1).withNumber((n) => Json.number(n * 2)), Json.number(2));

      expect(Json.str('').withNumber((n) => Json.number(n * 2)), Json.str(''));
      expect(Json.arr([]).withNumber((n) => Json.number(n * 2)), Json.arr([]));
      expect(Json.obj([]).withNumber((n) => Json.number(n * 2)), Json.obj([]));
    });

    test('withObject', () {
      expect(Json.Null.withObject((o) => Json.number(o.size)), Json.Null);
      expect(Json.True.withObject((o) => Json.number(o.size)), Json.True);

      expect(Json.number(0).withObject((o) => Json.number(o.size)),
          Json.number(0));

      expect(Json.str('').withObject((o) => Json.number(o.size)), Json.str(''));
      expect(Json.arr([]).withObject((o) => Json.number(o.size)), Json.arr([]));
      expect(
          Json.obj([]).withObject((o) => Json.number(o.size)), Json.number(0));
    });

    test('withString', () {
      expect(Json.Null.withString((s) => Json.str(s * 2)), Json.Null);
      expect(Json.True.withString((s) => Json.str(s * 2)), Json.True);
      expect(Json.number(0).withString((s) => Json.str(s * 2)), Json.number(0));
      expect(Json.str('1').withString((s) => Json.str(s * 2)), Json.str('11'));
      expect(Json.arr([]).withString((s) => Json.str(s * 2)), Json.arr([]));
      expect(Json.obj([]).withString((s) => Json.str(s * 2)), Json.obj([]));
    });

    test('mapArray', () {
      expect(Json.Null.mapArray((a) => a.reverse()), Json.Null);
      expect(Json.True.mapArray((a) => a.reverse()), Json.True);
      expect(Json.number(0).mapArray((a) => a.reverse()), Json.number(0));
      expect(Json.arr([Json.True, Json.False]).mapArray((a) => a.reverse()),
          Json.arr([Json.False, Json.True]));
      expect(Json.obj([]).mapArray((a) => a.reverse()), Json.obj([]));
    });

    test('mapBoolean', () {
      expect(Json.Null.mapBoolean((b) => !b), Json.Null);
      expect(Json.True.mapBoolean((b) => !b), Json.False);
      expect(Json.number(0).mapBoolean((b) => !b), Json.number(0));
      expect(Json.str('').mapBoolean((b) => !b), Json.str(''));
      expect(Json.arr([]).mapBoolean((b) => !b), Json.arr([]));
      expect(Json.obj([]).mapBoolean((b) => !b), Json.obj([]));
    });

    test('mapNumber', () {
      expect(Json.Null.mapNumber((n) => n + 1), Json.Null);
      expect(Json.True.mapNumber((n) => n + 1), Json.True);
      expect(Json.number(0).mapNumber((n) => n + 1), Json.number(1));
      expect(Json.arr([]).mapNumber((n) => n + 1), Json.arr([]));
      expect(Json.obj([]).mapNumber((n) => n + 1), Json.obj([]));
    });

    test('mapObject', () {
      expect(Json.Null.mapObject((o) => JsonObject.empty), Json.Null);
      expect(Json.True.mapObject((o) => JsonObject.empty), Json.True);
      expect(Json.number(0).mapObject((o) => JsonObject.empty), Json.number(0));
      expect(Json.arr([]).mapObject((o) => JsonObject.empty), Json.arr([]));
      expect(Json.obj([('key', Json.True)]).mapObject((o) => JsonObject.empty),
          Json.obj([]));
    });

    test('mapString', () {
      expect(Json.Null.mapString((s) => s.toUpperCase()), Json.Null);
      expect(Json.True.mapString((s) => s.toUpperCase()), Json.True);
      expect(Json.number(0).mapString((s) => s.toUpperCase()), Json.number(0));
      expect(Json.str('hi').mapString((s) => s.toUpperCase()), Json.str('HI'));
      expect(Json.arr([]).mapString((s) => s.toUpperCase()), Json.arr([]));
      expect(Json.obj([]).mapString((s) => s.toUpperCase()), Json.obj([]));
    });

    test('folder', () {
      var nulls = 0;
      var bools = 0;
      var nums = 0;
      var strings = 0;
      var arrs = 0;
      var objs = 0;

      JsonFolder<void> folder() => JsonFolder.of(
            () => nulls += 1,
            (b) => bools += 1,
            (n) => nums += 1,
            (s) => strings += 1,
            (arr) {
              arrs += 1;
              arr.foreach((a) => a.foldWith(folder()));
            },
            (obj) {
              objs += 1;
              obj.values.foreach((a) => a.foldWith(folder()));
            },
          );

      final json = Json.obj([
        ('a', Json.Null),
        ('b', Json.True),
        ('c', Json.number(0)),
        ('d', Json.arr([Json.Null, Json.False, Json.number(123)])),
        (
          'e',
          Json.obj([
            ('1', Json.number(1)),
            (
              '2',
              Json.arr([
                Json.arr([Json.Null, Json.number(-1), Json.str('hi')])
              ])
            )
          ])
        ),
      ]);

      final _ = json.foldWith(folder());

      expect(nulls, 3);
      expect(bools, 2);
      expect(nums, 4);
      expect(strings, 1);
      expect(arrs, 3);
      expect(objs, 2);
    });
  });
}
