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
            Json.obj([('b', Json.number(1))])
          ])
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
  });
}
