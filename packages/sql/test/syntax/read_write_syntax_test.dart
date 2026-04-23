import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

Row row(List<Object?> cols) => Row(IList.fromDart(cols));

void main() {
  group('ReadWrite tuple syntax', () {
    group('Tuple2', () {
      final rw = (ReadWrite.integer, ReadWrite.string).tupled;

      test('length is 2', () {
        expect(rw.length, 2);
      });

      test('reads both columns', () {
        expect(rw.unsafeGet(row([7, 'hi']), 0), (7, 'hi'));
      });

      test('encodes both values', () {
        expect(rw.encode((7, 'hi')).toList, [7, 'hi']);
      });

      test('gets and puts each have 2 entries', () {
        expect(rw.gets.length, 2);
        expect(rw.puts.length, 2);
      });
    });

    group('Tuple3', () {
      // Use types with symmetric roundtrip (read/write agree on storage format)
      final rw = (ReadWrite.integer, ReadWrite.string, ReadWrite.dubble).tupled;

      test('length is 3', () {
        expect(rw.length, 3);
      });

      test('reads three columns', () {
        expect(rw.unsafeGet(row([1, 'a', 2.5]), 0), (1, 'a', 2.5));
      });

      test('encodes three values', () {
        expect(rw.encode((1, 'a', 2.5)).toList, [1, 'a', 2.5]);
      });
    });

    group('Tuple4', () {
      final rw =
          (ReadWrite.integer, ReadWrite.string, ReadWrite.dubble, ReadWrite.integer).tupled;

      test('length is 4', () {
        expect(rw.length, 4);
      });

      test('reads and encodes symmetrically', () {
        const values = (10, 'b', 3.14, 42);
        final encoded = rw.encode(values).toList;
        expect(encoded, [10, 'b', 3.14, 42]);
        expect(rw.unsafeGet(row(encoded), 0), values);
      });
    });

    group('roundtrip', () {
      test('encode then decode recovers original value', () {
        final rw = (ReadWrite.string, ReadWrite.integer).tupled;
        const original = ('hello', 99);
        final encoded = rw.encode(original).toList;
        expect(rw.unsafeGet(row(encoded), 0), original);
      });
    });
  });
}
