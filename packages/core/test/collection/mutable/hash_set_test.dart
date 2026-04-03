import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/mutable/hash_set.dart';
import 'package:test/test.dart';

void main() {
  group('MHashSet', () {
    test('empty', () {
      final s = MHashSet<int>();
      expect(s.isEmpty, isTrue);
      expect(s.size, 0);
    });

    test('from', () {
      final s = MHashSet.from(ilist([1, 2, 3, 2, 1]));
      expect(s.size, 3);
      expect(s.contains(1), isTrue);
      expect(s.contains(3), isTrue);
    });

    test('add returns true for new element, false for duplicate', () {
      final s = MHashSet<int>();
      expect(s.add(42), isTrue);
      expect(s.add(42), isFalse);
      expect(s.size, 1);
    });

    test('remove returns true when present, false when absent', () {
      final s = MHashSet.from(ilist([1, 2, 3]));
      expect(s.remove(2), isTrue);
      expect(s.contains(2), isFalse);
      expect(s.size, 2);
      expect(s.remove(99), isFalse);
    });

    test('operator -', () {
      final s = mset({1, 2, 3});
      expect(s - 2, isTrue);
      expect(s.contains(2), isFalse);
      expect(s - 99, isFalse);
    });

    test('contains', () {
      final s = mset({10, 20, 30});
      expect(s.contains(10), isTrue);
      expect(s.contains(20), isTrue);
      expect(s.contains(99), isFalse);
    });

    test('concat with MHashSet fast path', () {
      final s1 = mset({1, 2, 3});
      final s2 = mset({3, 4, 5});
      final result = s1.concat(s2);
      expect(result.size, 5);
      for (var i = 1; i <= 5; i++) {
        expect(result.contains(i), isTrue);
      }
    });

    test('concat deduplicates', () {
      final s = mset({1, 2});
      s.concat(ilist([2, 3]));
      expect(s.size, 3);
    });

    test('diff', () {
      final s1 = mset({1, 2, 3, 4});
      final s2 = mset({2, 4});
      final result = s1.diff(s2);
      expect(result, mset({1, 3}));
    });

    test('union', () {
      final s1 = mset({1, 2});
      final s2 = mset({2, 3});
      final result = s1.union(s2);
      expect(result, mset({1, 2, 3}));
    });

    test('subsetOf', () {
      expect(mset({1, 2}).subsetOf(mset({1, 2, 3})), isTrue);
      expect(mset({1, 4}).subsetOf(mset({1, 2, 3})), isFalse);
      expect(mset(<int>{}).subsetOf(mset({1})), isTrue);
    });

    test('grows table correctly under load', () {
      // Insert enough elements to trigger multiple rehashes and verify all
      // elements are still reachable via contains().
      final s = MHashSet<int>();
      for (var i = 0; i < 100; i++) {
        s.add(i);
      }
      expect(s.size, 100);
      for (var i = 0; i < 100; i++) {
        expect(s.contains(i), isTrue);
      }
    });
  });
}
