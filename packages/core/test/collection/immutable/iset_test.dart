import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('ISet', () {
    test('empty', () {
      expect(ISet.empty<int>().size, 0);
    });

    test('fromIList', () {
      expect(ISet.from(nil<int>()).size, 0);
      expect(ISet.from(ilist([1, 2, 3])), iset([1, 2, 3]));
      expect(ISet.from(ilist([1, 2, 3, 2])), iset([1, 2, 3]));
      expect(ISet.from(ilist([1, 2, 3, 2, 4, 5, 5])), iset([1, 2, 3, 4, 5]));
    });

    test('incl', () {
      expect(iset({1, 2}) + 3, iset({1, 2, 3}));
      expect(iset({1, 2}) + 2, iset({1, 2}));
      expect(iset({1, 2, 3, 4, 5}) + 5, iset({1, 2, 3, 4, 5}));
      expect(iset({1, 2, 3, 4, 5}) + 6, iset({1, 2, 3, 4, 5, 6}));
    });

    test('excl', () {
      expect(iset({1, 2}) - 3, iset({1, 2}));
      expect(iset({1, 2}) - 2, iset({1}));
      expect(iset({1, 2, 3, 4, 5}) - 5, iset({1, 2, 3, 4}));
      expect(iset({1, 2, 3, 4, 5}) - 6, iset({1, 2, 3, 4, 5}));
    });

    test('contains', () {
      expect(iset({1, 2}).contains(0), isFalse);
      expect(iset({1, 2}).contains(2), isTrue);
      expect(iset({1, 2, 3, 4, 5}).contains(0), isFalse);
      expect(iset({1, 2, 3, 4, 5}).contains(2), isTrue);
      expect(iset({1, 2, 3, 4, 5}).contains(11), isFalse);
    });

    test('concat', () {
      expect(iset({1, 2}).concat(nil<int>()), iset({1, 2}));
      expect(iset({1, 2}).concat(ilist([3, 4])), iset({1, 2, 3, 4}));
      expect(iset({1, 2}).concat(ilist([2, 3, 4])), iset({1, 2, 3, 4}));
      expect(iset<int>({}).concat(ilist([2, 3, 4])), iset({2, 3, 4}));
      expect(
        iset({1, 2, 3, 4, 5}).concat(ilist([5, 6, 7, 8, 9])),
        iset({1, 2, 3, 4, 5, 6, 7, 8, 9}),
      );
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
      expect(iset({1, 2, 3, 4, 5}).diff(iset({2, 3, 4})), iset({1, 5}));
    });

    test('exists', () {
      expect(iset<int>({}).exists((a) => a.isEven), isFalse);
      expect(iset({1, 2, 3}).exists((a) => a.isEven), isTrue);
      expect(iset({1, 2, 3}).exists((a) => a > 10), isFalse);
    });

    test('equality', () {
      expect(iset<int>({}) == iset<int>({}), isTrue);
      expect(iset<int>({1}) == iset<int>({1}), isTrue);
      expect(iset<int>({1, 2}) == iset<int>({1, 2}), isTrue);
      expect(iset<int>({1, 2, 3}) == iset<int>({1, 2, 3}), isTrue);
      expect(iset<int>({1, 2, 3, 4}) == iset<int>({1, 2, 3, 4}), isTrue);
      expect(iset<int>({1, 2, 3, 4, 5}) == iset<int>({1, 2, 3, 4, 5}), isTrue);

      expect(iset({1, 2, 3}) == iset({1, 3, 2}), isTrue);
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
      IList<int> f(int x) => ilist([x - 1, x, x + 1]);

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

    forAll('forEach',
        Gen.ilistOf(Gen.chooseInt(0, 100), Gen.integer).map((l) => l.toISet()),
        (aSet) {
      var count = 0;
      aSet.foreach((_) => count += 1);
      expect(count, aSet.size);
    });

    test('groupBy', () {
      final s = iset({1, 2, 3, 4, 5, 6, 7, 8, 9});
      final m = s.groupBy((a) => a % 3);

      expect(m.get(0), isSome(iset({3, 6, 9})));
      expect(m.get(1), isSome(iset({1, 4, 7})));
      expect(m.get(2), isSome(iset({2, 5, 8})));
      expect(m.get(3), isNone());
    });

    test('groupMap', () {
      final s = iset({1, 2, 3, 4, 5, 6, 7, 8, 9});
      final m = s.groupMap((a) => a % 3, (a) => a * 2);

      expect(m.get(0), isSome(iset({6, 12, 18})));
      expect(m.get(1), isSome(iset({2, 8, 14})));
      expect(m.get(2), isSome(iset({4, 10, 16})));
      expect(m.get(3), isNone());
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
      expect(ISet.empty<int>().reduceOption((a, b) => a + b), isNone());
      expect(iset({1}).reduceOption((a, b) => a + b), isSome(1));
      expect(iset({1, 2, 3}).reduceOption((a, b) => a + b), isSome(6));
    });

    test('removedAll', () {
      expect(iset<int>({}).removedAll(iset([1, 2, 3])), iset<int>({}));
      expect(
          iset<int>({2, 4, 6}).removedAll(iset([1, 2, 3])), iset<int>({4, 6}));
      expect(
          iset<int>({1, 2, 3}).removedAll(iset([1, 2, 3, 1])), iset<int>({}));
    });

    test('subsetOf', () {
      expect(iset<int>({}).subsetOf(iset<int>({})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4, 6})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4, 6, 8})), isTrue);
      expect(iset<int>({2, 4, 6}).subsetOf(iset({2, 4})), isFalse);
    });

    test('subsets', () {
      expect(iset<int>({}).subsets().toList(), [iset<int>({})]);

      expect(iset({1}).subsets().toList(), [
        iset<int>({}),
        iset<int>({1}),
      ]);

      expect(iset({1, 2, 3}).subsets().toList(), [
        iset<int>({}),
        iset<int>({1}),
        iset<int>({2}),
        iset<int>({3}),
        iset<int>({1, 2}),
        iset<int>({1, 3}),
        iset<int>({2, 3}),
        iset<int>({1, 2, 3}),
      ]);
    });

    forAll(
        'size/emptines',
        Gen.chooseInt(0, 100)
            .map((n) => IList.tabulate(n, identity))
            .map((a) => a.toISet()), (aSet) {
      expect(aSet.size > 0, aSet.isNotEmpty);
      expect(aSet.size == 0, aSet.isEmpty);
    });
  });
}
