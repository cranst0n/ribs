import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('ISet', () {
    test('empty', () {
      expect(const ISet<int>.empty().size, 0);
    });

    test('fromIList', () {
      expect(ISet.fromIList(nil<int>()).size, 0);
      expect(ISet.fromIList(ilist([1, 2, 3])), iset([1, 2, 3]));
      expect(ISet.fromIList(ilist([1, 2, 3, 2])), iset([1, 2, 3]));
    });

    test('incl', () {
      expect(iset({1, 2}) + 3, iset({1, 2, 3}));
      expect(iset({1, 2}) + 2, iset({1, 2}));
    });

    test('excl', () {
      expect(iset({1, 2}) - 3, iset({1, 2}));
      expect(iset({1, 2}) - 2, iset({1}));
    });

    test('contains', () {
      expect(iset({1, 2}).contains(0), isFalse);
      expect(iset({1, 2})(1), isTrue);
    });

    test('concat', () {
      expect(iset({1, 2}).concat(nil<int>()), iset({1, 2}));
      expect(iset({1, 2}).concat(ilist([3, 4])), iset({1, 2, 3, 4}));
      expect(iset({1, 2}).concat(ilist([2, 3, 4])), iset({1, 2, 3, 4}));
      expect(iset<int>({}).concat(ilist([2, 3, 4])), iset({2, 3, 4}));
    });

    test('count', () {
      expect(iset<int>({}).count((a) => a.isEven), 0);
      expect(iset({1, 2, 3}).count((a) => a.isEven), 1);
      expect(iset({1, 2, 3}).count((a) => a.isOdd), 2);
    });

    test('diff', () {
      expect(iset<int>({}).diff(iset<int>({})), iset<int>({}));
      expect(iset({1, 2}).diff(iset<int>({})), iset({1, 2}));
      expect(iset({1, 2}).diff(iset<int>({1, 2})), iset<int>({}));
      expect(iset({1, 2}).diff(iset({2, 3, 4})), iset({1}));
    });

    test('exists', () {
      expect(iset<int>({}).exists((a) => a.isEven), isFalse);
      expect(iset({1, 2, 3}).exists((a) => a.isEven), isTrue);
      expect(iset({1, 2, 3}).exists((a) => a > 10), isFalse);
    });

    test('filter', () {
      expect(iset<int>({}).filter((x) => x > 0), iset<int>({}));
      expect(iset({1, 2, 3}).filter((x) => x > 0), iset({1, 2, 3}));
      expect(iset({1, -2, 3}).filter((x) => x > 0), iset({1, 3}));
      expect(iset({-1, -2, -3}).filter((x) => x > 0), iset<int>({}));
    });

    test('filterNot', () {
      expect(iset<int>({}).filterNot((x) => x > 0), iset<int>({}));
      expect(iset({1, 2, 3}).filterNot((x) => x > 0), iset<int>({}));
      expect(iset({1, -2, 3}).filterNot((x) => x > 0), iset({-2}));
      expect(iset({-1, -2, -3}).filterNot((x) => x > 0), iset({-1, -2, -3}));
    });

    test('find', () {
      expect(iset<int>({}).find((x) => x < 0), none<int>());
      expect(iset({1, 2, 3}).find((x) => x < 0), none<int>());
      expect(iset({-1, 2, 3}).find((x) => x < 0), isSome(-1));
      expect(iset({-1, -2, 3}).find((x) => x < 0), isSome(-1));
    });

    test('flatMap', () {
      List<int> f(int x) => [x - 1, x, x + 1];

      expect(iset<int>({}).flatMap(f), iset<int>({}));
      expect(iset([1, 2, 3]).flatMap(f), iset({0, 1, 2, 3, 4}));
    });

    test('fold', () {
      double op(double a, double b) => a / b;

      expect(iset<double>({}).fold(100000.0, op), 100000.0);
      expect(iset([10000.0, 1000.0, 100.0]).fold(1.0, op), 1e-9);
    });

    test('forall', () {
      expect(iset<int>({}).forall((x) => x < 0), isTrue);
      expect(iset({1, 2, 3}).forall((x) => x > 0), isTrue);
      expect(iset({-1, 2, 3}).forall((x) => x < 0), isFalse);
      expect(iset({-1, -2, 3}).forall((x) => x > 0), isFalse);
    });

    test('groupBy', () {
      final s = iset({1, 2, 3, 4, 5, 6, 7, 8, 9});

      expect(
        s.groupBy((a) => a % 3),
        imap({
          0: iset({3, 6, 9}),
          1: iset({1, 4, 7}),
          2: iset({2, 5, 8}),
        }),
      );
    });

    test('groupMap', () {
      final s = iset({1, 2, 3, 4, 5, 6, 7, 8, 9});

      expect(
        s.groupMap((a) => a % 3, (a) => a * 2),
        imap({
          0: iset({6, 12, 18}),
          1: iset({2, 8, 14}),
          2: iset({4, 10, 16}),
        }),
      );
    });

    test('isEmpty', () {
      expect(iset({}).isEmpty, isTrue);
      expect(iset({}).isNotEmpty, isFalse);

      expect(iset({1, 2}).isEmpty, isFalse);
      expect(iset({1, 2}).isNotEmpty, isTrue);
    });

    test('map', () {
      expect(iset<int>({}).map((a) => a * 2), iset({}));
      expect(iset<int>({1, 2, 3}).map((a) => a * 2), iset({2, 4, 6}));

      expect(iset<int>({1, 2, 3}).map((a) => a.isEven ? 0 : 1), iset({1, 0}));
    });

    test('mkString', () {
      expect(iset<int>({}).mkString(sep: ','), '');
      expect(
          iset({1, 2, 3}).mkString(start: '[', sep: '|', end: '>'), '[1|2|3>');
    });

    test('reduceOption', () {
      expect(const ISet<int>.empty().reduceOption((a, b) => a + b), isNone());
      expect(iset({1}).reduceOption((a, b) => a + b), isSome(1));
      expect(iset({1, 2, 3}).reduceOption((a, b) => a + b), isSome(6));
    });

    test('removedAll', () {
      expect(iset<int>({}).removedAll([1, 2, 3]), iset<int>({}));
      expect(iset<int>({2, 4, 6}).removedAll([1, 2, 3]), iset<int>({4, 6}));
      expect(iset<int>({1, 2, 3}).removedAll([1, 2, 3, 1]), iset<int>({}));
    });

    test('subsetOf', () {
      expect(iset<int>({}).subsetOf(iset<int>({})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4, 6})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4, 6, 8})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4})), isFalse);
    });
  });
}
