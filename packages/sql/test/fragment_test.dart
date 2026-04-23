import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('Fragment', () {
    test('raw has empty params', () {
      final f = Fragment.raw('SELECT 1');
      expect(f.sql, 'SELECT 1');
      expect(f.params.toList, isEmpty);
    });

    test('param inserts ? placeholder with encoded value', () {
      final f = Fragment.param(42, Put.integer);
      expect(f.sql, '?');
      expect(f.params.toList, [42]);
    });

    test('+ concatenates sql strings', () {
      final f = Fragment.raw('SELECT * FROM t WHERE id = ') + Fragment.param(1, Put.integer);
      expect(f.sql, 'SELECT * FROM t WHERE id = ?');
    });

    test('+ concatenates params in order', () {
      final f = Fragment.param(1, Put.integer) + Fragment.param('x', Put.string);
      expect(f.params.toList, [1, 'x']);
    });

    test('+ with raw fragments has no params', () {
      final f = Fragment.raw('SELECT ') + Fragment.raw('1');
      expect(f.sql, 'SELECT 1');
      expect(f.params.toList, isEmpty);
    });

    test('fromParts stores sql and params', () {
      final params = StatementParameters.empty().setParameter(0, 99);
      final f = Fragment.fromParts('SELECT ?', params);
      expect(f.sql, 'SELECT ?');
      expect(f.params.toList, [99]);
    });

    test('.fr extension wraps string as raw fragment', () {
      final f = 'SELECT 1'.fr;
      expect(f.sql, 'SELECT 1');
      expect(f.params.toList, isEmpty);
    });

    test('complex concatenation builds correct sql and params', () {
      final f =
          'SELECT * FROM person WHERE age > '.fr +
          Fragment.param(18, Put.integer) +
          ' AND city = '.fr +
          Fragment.param('NYC', Put.string);

      expect(f.sql, 'SELECT * FROM person WHERE age > ? AND city = ?');
      expect(f.params.toList, [18, 'NYC']);
    });

    test('param encodes boolean as 0/1', () {
      expect(Fragment.param(true, Put.boolean).params.toList, [1]);
      expect(Fragment.param(false, Put.boolean).params.toList, [0]);
    });
  });
}
