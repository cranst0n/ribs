import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('MSet', () {
    test('simple', () {
      final s = MSet.empty<int>();

      expect(s.size, 0);
      expect(s.isEmpty, isTrue);

      expect(s + 0, isTrue);
      expect(s.size, 1);

      expect(s + 0, isFalse);
      expect(s.size, 1);

      expect(s + 1, isTrue);
      expect(s.size, 2);

      expect(s.concat(ilist([2, 3, 4])).toList(), [0, 1, 2, 3, 4]);
    });

    test('equality', () {
      expect(mset({}), mset({}));
      expect(mset({1, 2, 3}), mset({1, 2, 3}));
      expect(mset({1, 2, 3})..add(10), mset({1, 10, 2, 3}));
    });

    test('large concat', () {
      final s1 = MSet.from(IList.tabulate(100, (a) => a + 1));
      final s2 = IList.tabulate(100, (a) => -a);

      expect(s1.size, 100);
      expect(s1.concat(s1).size, 100);

      expect(s1.concat(s2).size, 200);
    });
  });
}
