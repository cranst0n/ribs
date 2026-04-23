import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

Row row(List<Object?> cols) => Row(IList.fromDart(cols));

void main() {
  group('Read tuple syntax', () {
    group('Tuple2', () {
      final read = (Read.integer, Read.string).tupled;

      test('length is sum of column counts', () {
        expect(read.length, 2);
      });

      test('reads both columns', () {
        expect(read.unsafeGet(row([42, 'hello']), 0), (42, 'hello'));
      });

      test('reads starting at non-zero offset', () {
        expect(read.unsafeGet(row([0, 42, 'hello']), 1), (42, 'hello'));
      });

      test('gets list has 2 entries', () {
        expect(read.gets.length, 2);
      });
    });

    group('Tuple3', () {
      final read = (Read.integer, Read.string, Read.dubble).tupled;

      test('length is 3', () {
        expect(read.length, 3);
      });

      test('reads all three columns', () {
        expect(read.unsafeGet(row([1, 'a', 2.5]), 0), (1, 'a', 2.5));
      });
    });

    group('Tuple4', () {
      final read = (Read.integer, Read.string, Read.dubble, Read.boolean).tupled;

      test('length is 4', () {
        expect(read.length, 4);
      });

      test('reads all four columns', () {
        expect(read.unsafeGet(row([10, 'b', 3.0, 1]), 0), (10, 'b', 3.0, true));
      });
    });

    group('nested tuple composition', () {
      test('Tuple2 of Tuple2 reads correctly', () {
        final inner = (Read.integer, Read.string).tupled;
        final outer = (inner, Read.boolean).tupled;
        expect(outer.length, 3);
        expect(outer.unsafeGet(row([5, 'x', 1]), 0), ((5, 'x'), true));
      });
    });
  });
}
