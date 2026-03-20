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

    Gen.ilistOf(Gen.chooseInt(0, 100), Gen.integer).map((l) => l.toISet()).forAll('foreach', (
      aSet,
    ) {
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
      expect(iset({1, 2, 3}).mkString(start: '[', sep: '|', end: '>'), '[1|2|3>');
    });

    test('reduceOption', () {
      expect(ISet.empty<int>().reduceOption((a, b) => a + b), isNone());
      expect(iset({1}).reduceOption((a, b) => a + b), isSome(1));
      expect(iset({1, 2, 3}).reduceOption((a, b) => a + b), isSome(6));
    });

    test('removedAll', () {
      expect(iset<int>({}).removedAll(iset([1, 2, 3])), iset<int>({}));
      expect(iset<int>({2, 4, 6}).removedAll(iset([1, 2, 3])), iset<int>({4, 6}));
      expect(iset<int>({1, 2, 3}).removedAll(iset([1, 2, 3, 1])), iset<int>({}));
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

    Gen.chooseInt(0, 100).map((n) => IList.tabulate(n, identity)).map((a) => a.toISet()).forAll(
      'size/emptines',
      (aSet) {
        expect(aSet.size > 0, aSet.isNotEmpty);
        expect(aSet.size == 0, aSet.isEmpty);
      },
    );

    test('collect', () {
      expect(
        iset<int>({}).collect((int x) => x.isEven ? Some(x * 2) : none<int>()),
        iset<int>({}),
      );
      expect(
        iset({1, 2, 3, 4}).collect((int x) => x.isEven ? Some(x * 2) : none<int>()),
        iset({4, 8}),
      );
    });

    test('drop / dropRight / dropWhile', () {
      expect(iset({1, 2, 3}).drop(0).size, 3);
      expect(iset({1, 2, 3}).drop(3), iset<int>({}));
      expect(iset({1, 2, 3}).dropRight(0).size, 3);
      expect(iset({1, 2, 3}).dropRight(3), iset<int>({}));
      expect(iset({1, 2, 3}).dropWhile((_) => true), iset<int>({}));
      expect(iset({1, 2, 3}).dropWhile((_) => false).size, 3);
    });

    test('grouped', () {
      expect(iset({1, 2, 3}).grouped(2).toIList().size, 2);
      expect(iset({1, 2, 3}).grouped(3).toIList().size, 1);
    });

    test('init / inits', () {
      expect(iset({1, 2, 3}).init.size, 2);
      expect(iset({1, 2}).inits.toIList().size, 3); // [s, s.init, empty]
    });

    test('intersect', () {
      expect(iset<int>({}).intersect(iset({1, 2})), iset<int>({}));
      expect(iset({1, 2, 3}).intersect(iset({2, 3, 4})), iset({2, 3}));
      expect(iset({1, 2, 3}).intersect(iset<int>({})), iset<int>({}));
      expect(iset({1, 2, 3}).intersect(iset({1, 2, 3})), iset({1, 2, 3}));
    });

    test('partition', () {
      final (evens, odds) = iset({1, 2, 3, 4}).partition((int x) => x.isEven);
      expect(evens, iset({2, 4}));
      expect(odds, iset({1, 3}));
    });

    test('partitionMap', () {
      final result = iset({1, 2, 3}).partitionMap(
        (int x) => x.isEven ? Either.right<String, int>(x) : Either.left<String, int>(x.toString()),
      );
      expect(result.$1, iset({'1', '3'}));
      expect(result.$2, iset({2}));
    });

    test('scan / scanLeft / scanRight', () {
      // scanLeft produces n+1 values (initial + one per element); all distinct
      // since inputs are positive so partial sums are strictly increasing
      expect(iset({1, 2, 3}).scanLeft(0, (int a, int b) => a + b).size, 4);
      expect(iset({1, 2, 3}).scanRight(0, (int a, int b) => a + b).size, 4);
      expect(iset({1, 2, 3}).scan(0, (int a, int b) => a + b).size, 4);
    });

    test('slice', () {
      expect(iset({1, 2, 3}).slice(0, 3).size, 3);
      expect(iset({1, 2, 3}).slice(1, 3).size, 2);
      expect(iset({1, 2, 3}).slice(0, 0), iset<int>({}));
    });

    test('sliding', () {
      expect(iset({1, 2, 3}).sliding(2).toIList().size, 2);
    });

    test('span', () {
      final (all, none_) = iset({1, 2, 3}).span((_) => true);
      expect(all.size, 3);
      expect(none_, iset<int>({}));

      final (empty_, all2) = iset({1, 2, 3}).span((_) => false);
      expect(empty_, iset<int>({}));
      expect(all2.size, 3);
    });

    test('splitAt', () {
      final (first, second) = iset({1, 2, 3}).splitAt(2);
      expect(first.size, 2);
      expect(second.size, 1);
    });

    test('tail / tails', () {
      expect(iset({1, 2, 3}).tail.size, 2);
      expect(iset({1, 2}).tails.toIList().size, 3); // [s, s.tail, empty]
    });

    test('take / takeRight / takeWhile', () {
      expect(iset({1, 2, 3}).take(0), iset<int>({}));
      expect(iset({1, 2, 3}).take(3).size, 3);
      expect(iset({1, 2, 3}).takeRight(0), iset<int>({}));
      expect(iset({1, 2, 3}).takeRight(3).size, 3);
      expect(iset({1, 2, 3}).takeWhile((_) => false), iset<int>({}));
      expect(iset({1, 2, 3}).takeWhile((_) => true).size, 3);
    });

    test('tapEach', () {
      final seen = <int>{};
      iset({1, 2, 3}).tapEach(seen.add);
      expect(seen.length, 3);
    });

    test('union', () {
      expect(iset<int>({}).union(iset({1, 2})), iset({1, 2}));
      expect(iset({1, 2}).union(iset({2, 3})), iset({1, 2, 3}));
      expect(iset({1, 2}).union(iset<int>({})), iset({1, 2}));
    });

    test('zip / zipAll / zipWithIndex', () {
      expect(iset({1, 2}).zip(iset({3, 4})).size, 2);
      expect(iset({1, 2}).zip(iset<int>({})), iset<(int, int)>({}));
      expect(iset({1}).zipAll(iset({2, 3}), 0, 0).size, 2);
      expect(iset({1, 2, 3}).zipWithIndex().size, 3);
    });

    test('subsets with length', () {
      expect(iset({1, 2, 3}).subsets(length: 0).toIList().size, 1);
      expect(iset({1, 2, 3}).subsets(length: 1).toIList().size, 3);
      expect(iset({1, 2, 3}).subsets(length: 2).toIList().size, 3);
      expect(iset({1, 2, 3}).subsets(length: 3).toIList().size, 1);
      expect(iset({1, 2, 3}).subsets(length: 4).toIList().size, 0);
    });
  });
}
