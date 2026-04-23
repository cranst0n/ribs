import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('Row', () {
    final row = Row(ilist([1, 'hello', null, 3.14]));

    test('length', () {
      expect(row.length, 4);
    });

    test('[] returns value at index', () {
      expect(row[0], 1);
      expect(row[1], 'hello');
      expect(row[2], null);
      expect(row[3], 3.14);
    });

    test('empty row has length 0', () {
      expect(Row(nil()).length, 0);
    });
  });
}
