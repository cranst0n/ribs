import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('MMap', () {
    test('simple', () {
      final m = MMap.empty<int, String>();

      expect(m.isEmpty, isTrue);
      expect(m.size, 0);

      expect(m.put(0, '0'), isNone());
      expect(m.put(0, 'zero'), isSome('0'));

      expect(m.get(0), isSome('zero'));
      expect(m.get(1), isNone());

      expect(m.remove(0), isSome('zero'));
      expect(m.remove(1), isNone());

      expect(m.isEmpty, isTrue);
    });
  });

  test('equality', () {
    expect(mmap({}), mmap({}));
    expect(mmap({1: 'one', 2: 'two'}), mmap({1: 'one', 2: 'two'}));
  });
}
