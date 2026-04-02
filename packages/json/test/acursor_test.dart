import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  // JSON used across tests:
  // { "a": [1, 2, 3], "b": { "c": true }, "d": 42 }
  final json = Json.obj([
    ('a', Json.arr([Json.number(1), Json.number(2), Json.number(3)])),
    ('b', Json.obj([('c', Json.True)])),
    ('d', Json.number(42)),
  ]);

  final root = HCursor.fromJson(json);

  group('pathToRoot — success branch', () {
    // Exercises the TopCursor case (line 146) which exits the while loop.
    test('root cursor has empty path', () {
      expect(root.pathString, '');
    });

    test('object field path', () {
      expect(root.downField('d').pathString, '.d');
    });

    test('nested object path', () {
      expect(root.downField('b').downField('c').pathString, '.b.c');
    });

    test('array element path via downArray', () {
      expect(root.downField('a').downArray().pathString, '.a[0]');
    });

    test('array element path via downN', () {
      expect(root.downField('a').downN(2).pathString, '.a[2]');
    });
  });

  group('pathToRoot — failed cursor: Field op', () {
    // Field('key') means we tried cursor.field('key') and the sibling didn't exist.
    // pathToRoot should still include the attempted key in the path.
    test('missing sibling field includes field name in path', () {
      // downField('b') → ObjectCursor at 'b'; field('missing') → FailedCursor
      final fc = root.downField('b').field('missing');
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.b.missing');
    });

    test('missing sibling on nested object', () {
      final fc = root.downField('b').downField('c').up().field('nope');
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.b.nope');
    });
  });

  group('pathToRoot — failed cursor: DownField op', () {
    // DownField('key') means we tried downField('key') and the key was absent.
    test('missing top-level field shows field name in path', () {
      final fc = root.downField('missing');
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.missing');
    });

    test('missing nested field shows full path', () {
      final fc = root.downField('b').downField('absent');
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.b.absent');
    });
  });

  group('pathToRoot — failed cursor: DownArray op', () {
    // DownArray on a non-array (or empty array) fails.
    // pathToRoot reports index 0 as the attempted position.
    test('downArray on non-array shows [0] in path', () {
      final fc = HCursor.fromJson(Json.str('not-an-array')).downArray();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '[0]');
    });

    test('downArray on empty array shows [0] in path', () {
      final fc = HCursor.fromJson(Json.arr([])).downArray();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '[0]');
    });

    test('failed downArray after object navigation includes prefix', () {
      // Navigate into field 'd' (a number, not an array), then try downArray.
      final fc = root.downField('d').downArray();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.d[0]');
    });
  });

  group('pathToRoot — failed cursor: DownN op', () {
    // DownN(n) on an out-of-range index (or wrong type) fails.
    // pathToRoot reports index n as the attempted position.
    test('downN out of range shows [n] in path', () {
      final fc = root.downField('a').downN(99);
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.a[99]');
    });

    test('downN on non-array shows [n] in path', () {
      final fc = root.downField('d').downN(0);
      expect(fc.failed, isTrue);
      expect(fc.pathString, '.d[0]');
    });
  });

  group('pathToRoot — failed cursor: MoveLeft op', () {
    // MoveLeft at index 0 fails.
    // pathToRoot records index -1 (one before start) and then the prior position.
    test('left at index 0 shows [-1] suffix after current position', () {
      final fc = root.downField('a').downArray().left();
      expect(fc.failed, isTrue);
      // downArray → [0]; left fails → records [0][-1]
      expect(fc.pathString, '.a[0][-1]');
    });
  });

  group('pathToRoot — failed cursor: MoveRight op', () {
    test('right at last index uses ArrayCursor parent, records index+1', () {
      // Single-element array: downArray → index 0; right() → FailedCursor
      // lastCursor is the ArrayCursor(index=0), pathToRoot uses its parent and
      // records index 0+1 = 1.
      final fc = HCursor.fromJson(Json.arr([Json.str('only')])).downArray().right();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '[1]');
    });

    test('right at top level (non-ArrayCursor lastCursor) returns empty path', () {
      // TopCursor.right() → FailedCursor(lastCursor=TopCursor, lastOp=MoveRight).
      // The non-ArrayCursor branch in pathToRoot just steps to lastCursor (TopCursor)
      // and exits, so the path stays empty.
      final fc = HCursor.fromJson(Json.True).right();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '');
    });
  });

  group('pathToRoot — failed cursor: MoveUp / DeleteGoParent (default)', () {
    // Both MoveUp and DeleteGoParent failures hit the default branch, which
    // just moves to lastCursor without modifying the accumulated path.
    test('up at root returns empty path', () {
      final fc = HCursor.fromJson(Json.True).up();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '');
    });

    test('delete at root returns empty path', () {
      final fc = HCursor.fromJson(Json.True).delete();
      expect(fc.failed, isTrue);
      expect(fc.pathString, '');
    });
  });

  group('getOrElse', () {
    // Covers the error-fallback branch: field exists but decoding with optional()
    // still returns Left (wrong type), so getOrElse falls back to the default value.
    test('uses fallback when field exists but has the wrong type', () {
      // 'd' exists and is a number; Decoder.string fails → optional returns Left →
      // getOrElse invokes fallback.
      final result = root.getOrElse('d', Decoder.string, () => 'default');
      expect(result, const Right<DecodingFailure, String>('default'));
    });

    test('successfully decodes when field exists with correct type', () {
      final nestedRoot = HCursor.fromJson(
        Json.obj([
          ('name', Json.str('hello')),
        ]),
      );
      final result = nestedRoot.getOrElse('name', Decoder.string, () => 'fallback');
      expect(result, const Right<DecodingFailure, String>('hello'));
    });

    test('uses fallback when field is absent', () {
      final result = root.getOrElse('absent', Decoder.string, () => 'missing');
      expect(result, const Right<DecodingFailure, String>('missing'));
    });
  });

  group('decode and get', () {
    test('decode decodes the focused value', () {
      final cursor = root.downField('d');
      final result = cursor.decode(Decoder.number);
      expect(result, const Right<DecodingFailure, num>(42));
    });

    test('decode returns Left for wrong type', () {
      final cursor = root.downField('d');
      final result = cursor.decode(Decoder.string);
      expect(result.isLeft, isTrue);
    });

    test('get decodes a named field', () {
      final result = root.get('d', Decoder.number);
      expect(result, const Right<DecodingFailure, num>(42));
    });

    test('get returns Left for missing field', () {
      final result = root.get('absent', Decoder.number);
      expect(result.isLeft, isTrue);
    });
  });

  group('FailedCursor', () {
    test('focus returns None', () {
      expect(root.downField('missing').focus(), isNone());
    });

    test('succeeded is false', () {
      expect(root.downField('missing').succeeded, isFalse);
    });

    test('success returns None', () {
      expect(root.downField('missing').success(), isNone());
    });

    test('top returns None', () {
      expect(root.downField('missing').top(), isNone());
    });

    test('values returns None', () {
      expect(root.downField('missing').values, isNone());
    });

    test('keys returns None', () {
      expect(root.downField('missing').keys, isNone());
    });

    test('all navigation on FailedCursor returns itself (still failed)', () {
      final fc = root.downField('missing');
      expect(fc.left().failed, isTrue);
      expect(fc.right().failed, isTrue);
      expect(fc.up().failed, isTrue);
      expect(fc.downArray().failed, isTrue);
      expect(fc.downField('x').failed, isTrue);
      expect(fc.downN(0).failed, isTrue);
      expect(fc.field('x').failed, isTrue);
      expect(fc.delete().failed, isTrue);
      expect(fc.withFocus((_) => Json.True).failed, isTrue);
      expect(fc.set(Json.True).failed, isTrue);
    });

    test('incorrectFocus is true when op requires object but value is not', () {
      // DownField requires an object; if we try it on an array, incorrectFocus=true.
      final arrJson = Json.arr([Json.True]);
      final fc = HCursor.fromJson(arrJson).downField('key');
      expect((fc as FailedCursor).incorrectFocus, isTrue);
    });

    test('incorrectFocus is false for missing field in an object', () {
      final fc = root.downField('missing');
      expect((fc as FailedCursor).incorrectFocus, isFalse);
    });

    test('missingField is true for DownField failure', () {
      final fc = root.downField('missing') as FailedCursor;
      expect(fc.missingField, isTrue);
    });

    test('missingField is true for Field failure', () {
      final fc = root.downField('b').field('missing') as FailedCursor;
      expect(fc.missingField, isTrue);
    });

    test('missingField is false for non-field failures', () {
      final fc = HCursor.fromJson(Json.True).up() as FailedCursor;
      expect(fc.missingField, isFalse);
    });
  });
}
