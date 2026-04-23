import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('StatementParameters', () {
    test('empty has no parameters', () {
      expect(StatementParameters.empty().toList, isEmpty);
    });

    test('setParameter at index 0', () {
      final p = StatementParameters.empty().setParameter(0, 42);
      expect(p.toList, [42]);
    });

    test('setParameter pads with null when index > length', () {
      final p = StatementParameters.empty().setParameter(2, 'x');
      expect(p.toList, [null, null, 'x']);
    });

    test('setParameter overwrites existing value', () {
      final p = StatementParameters.empty().setParameter(0, 1).setParameter(0, 99);
      expect(p.toList, [99]);
    });

    test('concat combines two parameter lists', () {
      final a = StatementParameters.empty().setParameter(0, 1).setParameter(1, 2);
      final b = StatementParameters.empty().setParameter(0, 3);
      expect(a.concat(b).toList, [1, 2, 3]);
    });

    test('concat with empty is identity', () {
      final a = StatementParameters.empty().setParameter(0, 'hello');
      expect(a.concat(StatementParameters.empty()).toList, ['hello']);
      expect(StatementParameters.empty().concat(a).toList, ['hello']);
    });

    test('toList returns mutable list', () {
      final p = StatementParameters(ilist([1, 2, 3]));
      final list = p.toList;
      expect(list, [1, 2, 3]);
      // verify it's actually a mutable Dart List
      list.add(4);
      expect(list.length, 4);
    });
  });
}
