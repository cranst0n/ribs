import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Cursor', () {
    forAll('focus should return the JSON value in a newly created cursor', genJson, (json) {
      expect(HCursor.fromJson(json).focus(), isSome<Json>());
    });

    forAll('top should return from navigation into an object', genJson, (json) {
      final c = HCursor.fromJson(json);

      final intoObject = c.keys.flatMap(
        (keys) => keys.headOption.flatMap((first) => c.downField(first).success()),
      );

      expect(
        intoObject.forall((atFirst) => atFirst.top() == Some(json)),
        isTrue,
      );
    });

    forAll('top should return from navigation into an array', genJson, (json) {
      expect(
        HCursor.fromJson(
          json,
        ).downArray().success().forall((atFirst) => atFirst.top() == Some(json)),
        isTrue,
      );
    });

    forAll('root should return from navigation into an object', genJson, (json) {
      final c = HCursor.fromJson(json);

      final intoObject = c.keys.flatMap(
        (keys) => keys.headOption.flatMap((first) => c.downField(first).success()),
      );

      expect(
        intoObject.forall((atFirst) => atFirst.root().focus() == Some(json)),
        isTrue,
      );
    });

    forAll('root should return from navigation into an array', genJson, (json) {
      expect(HCursor.fromJson(json).downArray().root()?.focus(), Some(json));
    });

    forAll('up should undo navigation into an object', genJson, (json) {
      final c = HCursor.fromJson(json);

      final intoObject = c.keys.flatMap(
        (keys) => keys.headOption.flatMap((first) => c.downField(first).success()),
      );

      expect(
        intoObject.forall((a) => a.up().success().flatMap((a) => a.focus()) == Some(json)),
        isTrue,
      );
    });

    forAll('up should undo navigation into an array', genJson, (json) {
      final success = HCursor.fromJson(json).downArray().success();
      expect(
        success.forall((atFirst) => atFirst.up().success().flatMap((a) => a.focus()) == Some(json)),
        isTrue,
      );
    });

    forAll('up should fail at the top', genJson, (json) {
      final result = HCursor.fromJson(json).up();

      expect(result.failed, isTrue);
      expect(result.history(), ilist([CursorOp.moveUp]));
    });

    forAll('withFocus should have no effect when given the identity function', genJson, (json) {
      expect(HCursor.fromJson(json).withFocus(identity).focus(), isSome(json));
    });

    test('withFocus should support adding an element to an array', () {
      final result = cursor
          .downField('a')
          .success()
          .map(
            (a) => a.withFocus(
              (j) => j.asArray().fold(() => j, (a) => Json.arrI(a.prepended(Json.number(0)))),
            ),
          );

      expect(result.flatMap((a) => a.top()), isSome(j2));
    });

    test('delete should remove a value from an object', () {
      final result = cursor.downField('b').success().flatMap((a) => a.delete().success());

      expect(result.flatMap((a) => a.top()), isSome(j4));
    });

    forAll(
      'delete should remove a value from an array',
      (genJson, Gen.ilistOf(Gen.chooseInt(0, 5), genJson)).tupled,
      (tup) {
        final (h, t) = tup;

        final result = HCursor.fromJson(
          Json.arrI(t.prepended(h)),
        ).downArray().success().flatMap((f) => f.delete().success());

        expect(result.flatMap((a) => a.focus()), isSome(Json.arrI(t)));
      },
      numTests: 10,
    );
  });

  forAll('delete should fail at the top', genJson, (json) {
    final result = HCursor.fromJson(json).delete();

    expect(result.failed, isTrue);
    expect(result.history(), ilist([CursorOp.deleteGoParent]));
  });

  test('set should replace an element', () {
    final result = cursor.downField('b').success().map((a) => a.set(Json.number(10)));

    expect(result.flatMap((a) => a.top()), isSome(j3));
  });

  test('values should return the expected values', () {
    expect(
      cursor.downField('a').values,
      isSome(IList.rangeTo(1, 5).map(Json.number)),
    );
  });

  test('keys should return the expected values', () {
    expect(cursor.keys, isSome(ilist(['a', 'b', 'c'])));
  });

  test('left should successfully select an existing value', () {
    final result = cursor
        .downField('a')
        .success()
        .flatMap((c) => c.downN(3).success().flatMap((a) => a.left().success()));

    expect(result.flatMap((a) => a.focus()), isSome(Json.number(3)));
  });

  test("left should fail to select a value that doesn't exist", () {
    final result = cursor.downField('b').success().flatMap((c) => c.left().success());

    expect(result.flatMap((a) => a.focus()), isNone());
  });

  forAll('left should fail at the top', genJson, (json) {
    final result = HCursor.fromJson(json).left();

    expect(result.failed, isTrue);
    expect(result.history(), ilist([CursorOp.moveLeft]));
  });

  test('right should successfully select an existing value', () {
    final result = cursor
        .downField('a')
        .success()
        .flatMap((c) => c.downN(3).success().flatMap((a) => a.right().success()));

    expect(result.flatMap((a) => a.focus()), isSome(Json.number(5)));
  });

  test("right should fail to select a value that doesn't exist", () {
    final result = cursor.downField('b').success().flatMap((c) => c.right().success());

    expect(result.flatMap((a) => a.focus()), isNone());
  });

  test('downArray should successfully select an existing value', () {
    final result = cursor
        .downField('a')
        .success()
        .flatMap((c) => c.downN(3).success().flatMap((a) => a.up().downArray().success()));

    expect(result.flatMap((a) => a.focus()), isSome(Json.number(1)));
  });

  test("downArray should fail to select a value that doesn't exist", () {
    final result = cursor.downField('b').success().flatMap((c) => c.up().downArray().success());

    expect(result.flatMap((a) => a.focus()), isNone());
  });

  test('field should successfully select an existing value', () {
    final result = cursor
        .downField('c')
        .success()
        .flatMap((c) => c.downField('e').success().flatMap((e) => e.field('f').success()));

    expect(result.flatMap((a) => a.focus()), isSome(Json.number(200.2)));
  });

  forAll('field should fail at the top', (genJson, Gen.nonEmptyAlphaNumString(10)).tupled, (tup) {
    final (json, key) = tup;
    final result = HCursor.fromJson(json).field(key);

    expect(result.failed, isTrue);
    expect(result.history(), ilist([CursorOp.field(key)]));
  });

  test('getOrElse should successfully decode an existing field', () {
    final result = cursor
        .downField('b')
        .success()
        .map((b) => b.getOrElse('d', Decoder.ilist(Decoder.boolean), () => nil<bool>()));

    expect(
      result,
      isSome(ilist([true, false, true]).asRight<DecodingFailure>()),
    );
  });

  test('getOrElse should use the fallback if field is missing', () {
    final result = cursor
        .downField('b')
        .success()
        .map((b) => b.getOrElse('z', Decoder.ilist(Decoder.boolean), () => nil<bool>()));

    expect(
      result,
      isSome(nil<bool>().asRight<DecodingFailure>()),
    );
  });

  test('key should return the key if the cursor is in an object', () {
    expect(cursor.downField('b').downField('d').key, isSome('d'));
  });

  test('key should return None if the cursor is not in an object', () {
    expect(cursor.downField('a').downN(1).key, isNone());
  });

  test('key should return None if the cursor has failed', () {
    expect(cursor.downField('a').downField('XYZ').key, isNone());
  });

  test('key should return None if the cursor has at the root', () {
    expect(cursor.key, isNone());
  });

  test('index should return the index if the cursor is in an array', () {
    expect(cursor.downField('a').downN(1).index, isSome(1));
  });

  test('index should return None if the cursor is not in an array', () {
    expect(cursor.downField('b').downField('d').index, isNone());
  });

  test('index should return None if the cursor has failed', () {
    expect(cursor.downField('a').downN(10).index, isNone());
  });

  test('index should return None if the cursor has at the root', () {
    expect(cursor.index, isNone());
  });

  test('pathString should return the correct paths', () {
    final json = Json.obj([
      (
        'a',
        Json.arr([
          Json.str('string'),
          Json.obj([('b', Json.number(1))]),
        ]),
      ),
      ('c', Json.True),
    ]);

    final c = HCursor.fromJson(json);

    expect(c.pathString, '');
    expect(c.downField('a').pathString, '.a');
    expect(c.downField('a').downArray().pathString, '.a[0]');
    expect(c.downField('a').downN(1).downField('b').pathString, '.a[1].b');
    expect(c.downField('a').downN(1).downField('b').up().left().right().left().pathString, '.a[0]');
  });

  group('ArrayCursor', () {
    test('field should always fail', () {
      final json = Json.arr([Json.False, Json.number(0)]);
      final cursor = HCursor.fromJson(json).downArray().field('key');

      expect(cursor.failed, isTrue);
    });

    test('left should fail when at index 0', () {
      final json = Json.arr([Json.False, Json.number(0)]);
      final cursor = HCursor.fromJson(json).downArray().left();

      expect(cursor.failed, isTrue);
    });
  });
}

final j1 = Json.obj([
  ('a', Json.arrI(IList.rangeTo(1, 5).map(Json.number))),
  (
    'b',
    Json.obj([
      ('d', Json.arr([Json.True, Json.False, Json.True])),
    ]),
  ),
  (
    'c',
    Json.obj([
      ('e', Json.number(100.1)),
      ('f', Json.number(200.2)),
    ]),
  ),
]);

final j2 = Json.obj([
  ('a', Json.arrI(IList.rangeTo(0, 5).map(Json.number))),
  (
    'b',
    Json.obj([
      ('d', Json.arr([Json.True, Json.False, Json.True])),
    ]),
  ),
  (
    'c',
    Json.obj([
      ('e', Json.number(100.1)),
      ('f', Json.number(200.2)),
    ]),
  ),
]);

final j3 = Json.obj([
  ('a', Json.arrI(IList.rangeTo(1, 5).map(Json.number))),
  ('b', Json.number(10)),
  (
    'c',
    Json.obj([
      ('e', Json.number(100.1)),
      ('f', Json.number(200.2)),
    ]),
  ),
]);

final j4 = Json.obj([
  ('a', Json.arrI(IList.rangeTo(1, 5).map(Json.number))),
  (
    'c',
    Json.obj([
      ('e', Json.number(100.1)),
      ('f', Json.number(200.2)),
    ]),
  ),
]);

final cursor = HCursor.fromJson(j1);
