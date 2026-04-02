import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  group('PathToRoot', () {
    test('simple', () {
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

      final cursor = HCursor.fromJson(json)
          .downField('a')
          .field('c')
          .downArray()
          .field('a')
          .downN(1)
          .left()
          .right()
          .up()
          .downField('c')
          .downN(1);

      PathToRoot.fromHistory(cursor.history()).fold(
        (err) => fail('PathToRoot basic test failed: $err'),
        (ptr) => expect(PathToRoot.toPathString(ptr), '.a.c[0]'),
      );
    });

    test('empty path returns empty string', () {
      expect(PathToRoot.toPathString(PathToRoot.empty), '');
    });

    test('asPathString instance method', () {
      final cursor = HCursor.fromJson(Json.obj([('x', Json.number(1))])).downField('x');

      PathToRoot.fromHistory(cursor.history()).fold(
        (err) => fail(err),
        (ptr) => expect(ptr.asPathString(), '.x'),
      );
    });

    test('appendElem adds element to end', () {
      final path = PathToRoot.empty
          .appendElem(PathElem.objectKey('a'))
          .appendElem(PathElem.arrayIndex(3));
      expect(path.asPathString(), '.a[3]');
    });

    test('prependElem adds element to front', () {
      final path = PathToRoot.empty
          .prependElem(PathElem.arrayIndex(1))
          .prependElem(PathElem.objectKey('b'));
      expect(path.asPathString(), '.b[1]');
    });

    test('toString', () {
      final cursor = HCursor.fromJson(Json.obj([('z', Json.True)])).downField('z');
      PathToRoot.fromHistory(cursor.history()).fold(
        (err) => fail(err),
        (ptr) => expect(ptr.toString(), 'PathToRoot(.z)'),
      );
    });

    test('equality', () {
      final cursor = HCursor.fromJson(Json.obj([('a', Json.True)])).downField('a');
      PathToRoot.fromHistory(cursor.history()).fold(
        (err) => fail(err),
        (p1) {
          PathToRoot.fromHistory(cursor.history()).fold(
            (err) => fail(err),
            (p2) {
              expect(p1 == p2, isTrue);
              expect(p1 == PathToRoot.empty, isFalse);
              expect(p1 == ('not a PathToRoot' as Object), isFalse);
            },
          );
        },
      );
    });

    test('hashCode', () {
      final cursor = HCursor.fromJson(Json.obj([('a', Json.True)])).downField('a');
      PathToRoot.fromHistory(cursor.history()).fold(
        (err) => fail(err),
        (p1) {
          PathToRoot.fromHistory(cursor.history()).fold(
            (err) => fail(err),
            (p2) => expect(p1.hashCode, equals(p2.hashCode)),
          );
        },
      );
    });

    group('downN', () {
      test('navigates to index', () {
        final json = Json.arr([Json.str('a'), Json.str('b'), Json.str('c')]);
        final cursor = HCursor.fromJson(json).downN(2);

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('downN test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '[2]'),
        );
      });
    });

    group('array navigation', () {
      // Each left/right appends a new index entry to the path history.
      test('right appends incremented index', () {
        final json = Json.arr([Json.str('a'), Json.str('b'), Json.str('c')]);
        final cursor = HCursor.fromJson(json).downArray().right();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('right test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '[0][1]'),
        );
      });

      test('left appends decremented index', () {
        final json = Json.arr([Json.str('a'), Json.str('b'), Json.str('c')]);
        final cursor = HCursor.fromJson(json).downArray().right().left();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('left test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '[0][1][0]'),
        );
      });

      test('multiple right moves each append an index', () {
        final json = Json.arr([Json.str('a'), Json.str('b'), Json.str('c'), Json.str('d')]);
        final cursor = HCursor.fromJson(json).downArray().right().right();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('multiple right test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '[0][1][2]'),
        );
      });
    });

    group('up', () {
      test('up preserves accumulated path', () {
        final json = Json.obj([
          ('items', Json.arr([Json.str('x'), Json.str('y')])),
        ]);
        // right() appends [1], up() returns acc unchanged → path has both [0] and [1]
        final cursor = HCursor.fromJson(json).downField('items').downArray().right().up();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('up test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '.items[0][1]'),
        );
      });

      test('up from root returns Left', () {
        final cursor = HCursor.fromJson(Json.True).up();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => expect(err, contains('Attempt to move up')),
          (ptr) => fail('Expected Left but got: ${ptr.asPathString()}'),
        );
      });
    });

    group('deleteGoParent', () {
      test('delete array element records path including navigation', () {
        final json = Json.obj([
          ('items', Json.arr([Json.str('x'), Json.str('y'), Json.str('z')])),
        ]);
        // right() appends [1], deleteGoParent returns acc unchanged → path has [0][1]
        final cursor = HCursor.fromJson(json).downField('items').downArray().right().delete();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('deleteGoParent test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '.items[0][1]'),
        );
      });

      test('delete object field returns path to field', () {
        final json = Json.obj([('a', Json.number(1)), ('b', Json.number(2))]);
        final cursor = HCursor.fromJson(json).downField('b').delete();

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => fail('deleteGoParent object test failed: $err'),
          (ptr) => expect(ptr.asPathString(), '.b'),
        );
      });
    });

    group('error cases', () {
      test('field op in array context returns Left', () {
        final json = Json.arr([Json.str('a'), Json.str('b')]);
        // field() on ArrayCursor fails; when processed, Field op with ArrayIndex
        // as last acc element triggers the error condition in _onField
        final cursor = HCursor.fromJson(json).downArray().field('x');

        PathToRoot.fromHistory(cursor.history()).fold(
          (err) => expect(err, contains('sibling field')),
          (ptr) => fail('Expected Left but got: ${ptr.asPathString()}'),
        );
      });
    });
  });

  group('PathElem', () {
    group('ObjectKey', () {
      test('asObjectKey returns Some(self)', () {
        final k = ObjectKey('foo');
        expect(k.asObjectKey(), Some(k));
      });

      test('asArrayIndex returns None', () {
        expect(ObjectKey('foo').asArrayIndex(), const None());
      });

      test('equality', () {
        final k1 = ObjectKey('foo');
        final k2 = ObjectKey('foo');
        final k3 = ObjectKey('bar');
        expect(k1 == k2, isTrue);
        expect(k1 == k3, isFalse);
        expect(k1 == k1, isTrue);
        expect(k1 == (42 as Object), isFalse);
      });

      test('hashCode', () {
        expect(ObjectKey('foo').hashCode, equals(ObjectKey('foo').hashCode));
      });
    });

    group('ArrayIndex', () {
      test('asArrayIndex returns Some(self)', () {
        final a = ArrayIndex(5);
        expect(a.asArrayIndex(), Some(a));
      });

      test('asObjectKey returns None', () {
        expect(ArrayIndex(5).asObjectKey(), const None());
      });

      test('equality', () {
        final a1 = ArrayIndex(2);
        final a2 = ArrayIndex(2);
        final a3 = ArrayIndex(7);
        expect(a1 == a2, isTrue);
        expect(a1 == a3, isFalse);
        expect(a1 == a1, isTrue);
        expect(a1 == ('not an index' as Object), isFalse);
      });

      test('hashCode', () {
        expect(ArrayIndex(3).hashCode, equals(ArrayIndex(3).hashCode));
      });
    });
  });
}
