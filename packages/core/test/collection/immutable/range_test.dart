import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    test('apply', () {
      final r = Range.exclusive(0, 10);

      expect(() => r[-1], throwsRangeError);
      expect(r[0], 0);
      expect(r[9], 9);
      expect(() => r[10], throwsRangeError);
    });

    test('contains', () {
      final r0 = Range.exclusive(0, 10);

      expect(r0.contains(-1), isFalse);
      expect(r0.contains(0), isTrue);
      expect(r0.contains(1), isTrue);
      expect(r0.contains(10), isFalse);

      final r1 = Range.inclusive(0, 10, 2);

      expect(r1.contains(-1), isFalse);
      expect(r1.contains(0), isTrue);
      expect(r1.contains(1), isFalse);
      expect(r1.contains(2), isTrue);
      expect(r1.contains(10), isTrue);
    });

    test('drop', () {
      expect(Range.exclusive(0, 5).drop(3), Range.exclusive(3, 5));
    });

    test('equality', () {
      final r0 = Range.inclusive(1, 10);
      final r1 = Range.inclusive(1, 10);

      expect(r0 == r1, isTrue);
    });

    test('foreach', () {
      var countExclusive = 0;
      var countInclusive = 0;

      Range.exclusive(0, 4).foreach((n) => countExclusive += n);
      Range.inclusive(0, 4).foreach((n) => countInclusive += n);

      expect(countExclusive, 6);
      expect(countInclusive, 10);
    });

    test('take', () {
      expect(Range.exclusive(0, 5).take(3), Range.exclusive(0, 3));
    });
  });
}
