import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('Write tuple syntax', () {
    group('Tuple2', () {
      final write = (Write.integer, Write.string).tupled;

      test('length is sum of slot counts', () {
        expect(write.length, 2);
      });

      test('encodes both values in order', () {
        expect(write.encode((42, 'hello')).toList, [42, 'hello']);
      });

      test('puts list has 2 entries', () {
        expect(write.puts.length, 2);
      });
    });

    group('Tuple3', () {
      final write = (Write.integer, Write.string, Write.dubble).tupled;

      test('length is 3', () {
        expect(write.length, 3);
      });

      test('encodes all three values', () {
        expect(write.encode((1, 'a', 2.5)).toList, [1, 'a', 2.5]);
      });
    });

    group('Tuple4', () {
      final write = (Write.integer, Write.string, Write.dubble, Write.boolean).tupled;

      test('length is 4', () {
        expect(write.length, 4);
      });

      test('encodes all four values', () {
        // Write stores Dart bool directly; no 0/1 conversion at this level
        expect(write.encode((10, 'b', 3.0, true)).toList, [10, 'b', 3.0, true]);
      });
    });

    group('setParameter at offset', () {
      test('encodes into existing params at non-zero offset', () {
        final write = (Write.integer, Write.string).tupled;
        final base = StatementParameters.empty().setParameter(0, 'prefix');
        final result = write.setParameter(base, 1, (99, 'x'));
        expect(result.toList, ['prefix', 99, 'x']);
      });
    });
  });
}
