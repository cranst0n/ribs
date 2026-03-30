import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_core/src/collection/immutable/set/hash_set.dart';
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

  group('small set type transitions', () {
    test('empty → set1 on incl', () {
      final s = ISet.empty<int>() + 1;
      expect(s.size, 1);
      expect(s.contains(1), isTrue);
      expect(s.contains(2), isFalse);
    });

    test('set1 → set2 on incl', () {
      final s = iset({1}) + 2;
      expect(s.size, 2);
      expect(s.contains(1), isTrue);
      expect(s.contains(2), isTrue);
    });

    test('set2 → set3 on incl', () {
      final s = iset({1, 2}) + 3;
      expect(s.size, 3);
      expect(s.contains(3), isTrue);
    });

    test('set3 → set4 on incl', () {
      final s = iset({1, 2, 3}) + 4;
      expect(s.size, 4);
      expect(s.contains(4), isTrue);
    });

    test('set4 → IHashSet on incl (5th element)', () {
      final s = iset({1, 2, 3, 4}) + 5;
      expect(s.size, 5);
      expect(s, isA<IHashSet<int>>());
      expect(s.contains(5), isTrue);
    });

    test('set1 → empty on excl', () {
      final s = iset({99}) - 99;
      expect(s.isEmpty, isTrue);
    });

    test('set2 → set1 on excl', () {
      expect((iset({1, 2}) - 1).size, 1);
      expect((iset({1, 2}) - 2).size, 1);
      expect((iset({1, 2}) - 3).size, 2); // element not present
    });

    test('set3 → set2 on excl', () {
      expect(iset({1, 2, 3}) - 1, iset({2, 3}));
      expect(iset({1, 2, 3}) - 2, iset({1, 3}));
      expect(iset({1, 2, 3}) - 3, iset({1, 2}));
      expect((iset({1, 2, 3}) - 4).size, 3); // element not present
    });

    test('set4 → set3 on excl', () {
      expect(iset({1, 2, 3, 4}) - 1, iset({2, 3, 4}));
      expect(iset({1, 2, 3, 4}) - 2, iset({1, 3, 4}));
      expect(iset({1, 2, 3, 4}) - 3, iset({1, 2, 4}));
      expect(iset({1, 2, 3, 4}) - 4, iset({1, 2, 3}));
      expect((iset({1, 2, 3, 4}) - 5).size, 4); // element not present
    });

    test('incl is idempotent on each small set type', () {
      expect(iset({1}) + 1, iset({1}));
      expect(iset({1, 2}) + 1, iset({1, 2}));
      expect(iset({1, 2}) + 2, iset({1, 2}));
      expect(iset({1, 2, 3}) + 2, iset({1, 2, 3}));
      expect(iset({1, 2, 3, 4}) + 3, iset({1, 2, 3, 4}));
    });
  });

  group('_EmptySet', () {
    test('diff returns empty', () {
      expect(ISet.empty<int>().diff(iset({1, 2})), iset<int>({}));
    });

    test('intersect returns empty', () {
      expect(ISet.empty<int>().intersect(iset({1, 2})), iset<int>({}));
    });

    test('removedAll returns empty', () {
      expect(ISet.empty<int>().removedAll(ilist([1, 2, 3])), iset<int>({}));
    });

    test('subsetOf any set', () {
      expect(ISet.empty<int>().subsetOf(ISet.empty()), isTrue);
      expect(ISet.empty<int>().subsetOf(iset({1, 2})), isTrue);
    });

    test('filter / filterNot return empty', () {
      expect(ISet.empty<int>().filter((_) => true), iset<int>({}));
      expect(ISet.empty<int>().filterNot((_) => false), iset<int>({}));
    });
  });

  group('_Set1', () {
    test('head and tail', () {
      expect(iset({42}).head, 42);
      expect(iset({42}).tail, iset<int>({}));
    });

    test('exists / find / forall', () {
      expect(iset({5}).exists((x) => x == 5), isTrue);
      expect(iset({5}).exists((x) => x == 6), isFalse);
      expect(iset({5}).find((x) => x == 5), isSome(5));
      expect(iset({5}).find((x) => x == 6), isNone());
      expect(iset({5}).forall((x) => x > 0), isTrue);
      expect(iset({5}).forall((x) => x < 0), isFalse);
    });

    test('iterator yields single element', () {
      final it = iset({7}).iterator;
      expect(it.hasNext, isTrue);
      expect(it.next(), 7);
      expect(it.hasNext, isFalse);
    });
  });

  group('_Set2', () {
    test('head and tail', () {
      final s = iset({1, 2});
      expect(s.head, 1);
      expect(s.tail, iset({2}));
    });

    test('filter: both pass', () => expect(iset({1, 2}).filter((_) => true), iset({1, 2})));
    test('filter: first passes only', () => expect(iset({1, 2}).filter((x) => x == 1), iset({1})));
    test('filter: second passes only', () => expect(iset({1, 2}).filter((x) => x == 2), iset({2})));
    test('filter: none pass', () => expect(iset({1, 2}).filter((_) => false), iset<int>({})));

    test('filterNot delegates to filter complement', () {
      expect(iset({1, 2}).filterNot((x) => x == 1), iset({2}));
      expect(iset({1, 2}).filterNot((_) => false), iset({1, 2}));
    });

    test('exists / find / forall', () {
      expect(iset({3, 7}).exists((x) => x == 3), isTrue);
      expect(iset({3, 7}).exists((x) => x == 7), isTrue);
      expect(iset({3, 7}).exists((x) => x == 5), isFalse);
      expect(iset({3, 7}).find((x) => x == 7), isSome(7));
      expect(iset({3, 7}).find((x) => x == 5), isNone());
      expect(iset({3, 7}).forall((x) => x > 0), isTrue);
      expect(iset({3, 7}).forall((x) => x > 5), isFalse);
    });

    test('iterator yields both elements', () {
      final elems = iset({10, 20}).iterator.toIList();
      expect(elems.size, 2);
    });
  });

  group('_Set3', () {
    test('head and tail', () {
      final s = iset({1, 2, 3});
      expect(s.head, 1);
      expect(s.tail, iset({2, 3}));
    });

    test('filter: all pass', () => expect(iset({1, 2, 3}).filter((_) => true), iset({1, 2, 3})));
    test('filter: none pass', () => expect(iset({1, 2, 3}).filter((_) => false), iset<int>({})));
    test('filter: first only', () => expect(iset({1, 2, 3}).filter((x) => x == 1), iset({1})));
    test('filter: second only', () => expect(iset({1, 2, 3}).filter((x) => x == 2), iset({2})));
    test('filter: third only', () => expect(iset({1, 2, 3}).filter((x) => x == 3), iset({3})));
    test('filter: first two', () => expect(iset({1, 2, 3}).filter((x) => x <= 2), iset({1, 2})));
    test('filter: last two', () => expect(iset({1, 2, 3}).filter((x) => x >= 2), iset({2, 3})));
    test(
      'filter: first and third',
      () => expect(iset({1, 2, 3}).filter((x) => x != 2), iset({1, 3})),
    );

    test('exists / find / forall', () {
      expect(iset({1, 2, 3}).exists((x) => x == 3), isTrue);
      expect(iset({1, 2, 3}).exists((x) => x > 10), isFalse);
      expect(iset({1, 2, 3}).find((x) => x == 2), isSome(2));
      expect(iset({1, 2, 3}).find((x) => x == 3), isSome(3));
      expect(iset({1, 2, 3}).find((x) => x > 10), isNone());
      expect(iset({1, 2, 3}).forall((x) => x > 0), isTrue);
      expect(iset({1, 2, 3}).forall((x) => x > 1), isFalse);
    });
  });

  group('_Set4', () {
    test('head and tail', () {
      final s = iset({1, 2, 3, 4});
      expect(s.head, 1);
      expect(s.tail, iset({2, 3, 4}));
    });

    test(
      'filter: all pass',
      () => expect(iset({1, 2, 3, 4}).filter((_) => true), iset({1, 2, 3, 4})),
    );
    test('filter: none pass', () => expect(iset({1, 2, 3, 4}).filter((_) => false), iset<int>({})));
    test('filter: first only', () => expect(iset({1, 2, 3, 4}).filter((x) => x == 1), iset({1})));
    test('filter: second only', () => expect(iset({1, 2, 3, 4}).filter((x) => x == 2), iset({2})));
    test('filter: third only', () => expect(iset({1, 2, 3, 4}).filter((x) => x == 3), iset({3})));
    test('filter: fourth only', () => expect(iset({1, 2, 3, 4}).filter((x) => x == 4), iset({4})));
    test(
      'filter: three elements',
      () => expect(iset({1, 2, 3, 4}).filter((x) => x <= 3), iset({1, 2, 3})),
    );

    test('exists / find / forall', () {
      expect(iset({1, 2, 3, 4}).exists((x) => x == 4), isTrue);
      expect(iset({1, 2, 3, 4}).exists((x) => x > 10), isFalse);
      expect(iset({1, 2, 3, 4}).find((x) => x == 3), isSome(3));
      expect(iset({1, 2, 3, 4}).find((x) => x == 4), isSome(4));
      expect(iset({1, 2, 3, 4}).find((x) => x > 10), isNone());
      expect(iset({1, 2, 3, 4}).forall((x) => x > 0), isTrue);
      expect(iset({1, 2, 3, 4}).forall((x) => x > 2), isFalse);
    });
  });

  group('ISetBuilder', () {
    test('builds small sets up to size 4', () {
      final b = ISet.builder<int>();
      for (var i = 1; i <= 4; i++) {
        b.addOne(i);
      }
      expect(b.result(), iset({1, 2, 3, 4}));
      expect(b.result(), isNot(isA<IHashSet<int>>()));
    });

    test('switches to IHashSet at 5th distinct element', () {
      final b = ISet.builder<int>();
      for (var i = 1; i <= 5; i++) {
        b.addOne(i);
      }
      expect(b.result(), isA<IHashSet<int>>());
      expect(b.result().size, 5);
    });

    test('duplicate elements do not trigger hash-set switch', () {
      final b = ISet.builder<int>();
      // add 4 distinct + duplicates — should stay as small set
      for (var i = 0; i < 10; i++) {
        b.addOne(i % 4); // only 4 distinct values
      }
      expect(b.result().size, 4);
      expect(b.result(), isNot(isA<IHashSet<int>>()));
    });

    test('addAll works like repeated addOne', () {
      final b = ISet.builder<int>()..addAll(ilist([1, 2, 3, 2, 1]));
      expect(b.result(), iset({1, 2, 3}));
    });

    test('result() is stable (returns same object on repeated calls)', () {
      final b = ISet.builder<int>()..addAll(ilist([10, 20, 30, 40, 50]));
      expect(identical(b.result(), b.result()), isTrue);
    });

    test('clear() resets builder', () {
      final b = ISet.builder<int>()..addAll(ilist([1, 2, 3]));
      b.clear();
      expect(b.result().isEmpty, isTrue);
    });

    test('clear() then reuse builds fresh set', () {
      final b = ISet.builder<int>()..addAll(ilist([1, 2, 3, 4, 5]));
      b.clear();
      b.addAll(ilist([7, 8]));
      expect(b.result(), iset({7, 8}));
    });
  });

  group('_SetNIterator', () {
    test('drop advances iterator', () {
      // Set2 uses _SetNIterator(2, ...)
      final it = iset({10, 20}).iterator;
      it.drop(1);
      expect(it.hasNext, isTrue);
      expect(it.knownSize, 1);
      it.next();
      expect(it.hasNext, isFalse);
    });

    test('drop past end yields empty iterator', () {
      final it = iset({1, 2, 3}).iterator; // _SetNIterator(3, ...)
      it.drop(10);
      expect(it.hasNext, isFalse);
      expect(it.knownSize, 0);
    });

    test('knownSize tracks remaining elements', () {
      final it = iset({1, 2, 3, 4}).iterator; // _SetNIterator(4, ...)
      expect(it.knownSize, 4);
      it.next();
      expect(it.knownSize, 3);
      it.next();
      expect(it.knownSize, 2);
    });

    test('drop(0) is a no-op', () {
      final it = iset({1, 2}).iterator;
      it.drop(0);
      expect(it.knownSize, 2);
    });
  });

  group('IHashSet', () {
    // Helpers
    ISet<int> large() => iset({1, 2, 3, 4, 5, 6, 7, 8, 9, 10});

    test('is IHashSet for 5+ elements', () {
      expect(iset({1, 2, 3, 4, 5}), isA<IHashSet<int>>());
    });

    test('head and last', () {
      final s = iset({1, 2, 3, 4, 5});
      // head and last must be members; order depends on hash so just check membership
      expect(s.contains(s.head), isTrue);
      expect(s.contains(s.last), isTrue);
    });

    test('isEmpty / knownSize / size are consistent', () {
      final s = large();
      expect(s.isEmpty, isFalse);
      expect(s.isNotEmpty, isTrue);
      expect(s.size, 10);
      expect(s.knownSize, 10);
    });

    test('concat two IHashSets (fast CHAMP merge)', () {
      final a = iset({1, 2, 3, 4, 5});
      final b = iset({5, 6, 7, 8, 9});
      final result = a.concat(b);
      expect(result.size, 9);
      for (var i = 1; i <= 9; i++) {
        expect(result.contains(i), isTrue);
      }
    });

    test('concat IHashSet with empty IHashSet returns other', () {
      final a = IHashSet.empty<int>();
      final b = iset({1, 2, 3, 4, 5});
      expect(a.concat(b), b);
    });

    test('concat IHashSet with itself is idempotent', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s.concat(s), s);
    });

    test('concat IHashSet with non-IHashSet iterable', () {
      final s = iset({1, 2, 3, 4, 5});
      final result = s.concat(ilist([6, 7, 8, 9, 10]));
      expect(result.size, 10);
    });

    test('diff two IHashSets (fast CHAMP diff)', () {
      final a = iset({1, 2, 3, 4, 5});
      final b = iset({3, 4, 5, 6, 7});
      expect(a.diff(b), iset({1, 2}));
    });

    test('diff with empty IHashSet returns self', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s.diff(IHashSet.empty()), s);
    });

    test('diff that empties set returns empty', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s.diff(s), iset<int>({}));
    });

    test('diff IHashSet against small ISet', () {
      final a = iset({1, 2, 3, 4, 5});
      final b = iset({2, 3}); // small set (Set2)
      expect(a.diff(b), iset({1, 4, 5}));
    });

    test('empty IHashSet diff anything is empty', () {
      expect(IHashSet.empty<int>().diff(iset({1, 2, 3, 4, 5})), iset<int>({}));
    });

    test('filter keeps matching elements', () {
      final s = iset({1, 2, 3, 4, 5, 6});
      expect(s.filter((x) => x.isEven), iset({2, 4, 6}));
    });

    test('filter returning all elements returns same set object', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(identical(s.filter((_) => true), s), isTrue);
    });

    test('filter returning no elements returns empty', () {
      expect(iset({1, 2, 3, 4, 5}).filter((_) => false), iset<int>({}));
    });

    test('filterNot is complement of filter', () {
      final s = iset({1, 2, 3, 4, 5, 6});
      expect(s.filterNot((x) => x.isEven), iset({1, 3, 5}));
    });

    test('removedAll with another ISet uses diff fast-path', () {
      final a = iset({1, 2, 3, 4, 5});
      final b = iset({2, 4});
      expect(a.removedAll(b), iset({1, 3, 5}));
    });

    test('removedAll with non-ISet iterable', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s.removedAll(ilist([1, 3, 5])), iset({2, 4}));
    });

    test('equality: same rootNode → equal', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s == s, isTrue); // identical shortcut
    });

    test('equality: same elements, different instances', () {
      expect(iset({1, 2, 3, 4, 5}) == iset({5, 4, 3, 2, 1}), isTrue);
    });

    test('equality: different elements → not equal', () {
      expect(iset({1, 2, 3, 4, 5}) == iset({1, 2, 3, 4, 6}), isFalse);
    });

    test('equality: IHashSet vs small ISet with same elements', () {
      // iset({1,2,3,4,5}) is IHashSet; iset({1,2,3}) is _Set3
      expect(iset({1, 2, 3, 4, 5}) == iset({1, 2, 3, 4, 5}), isTrue);
      expect(iset({1, 2, 3, 4, 5}) == iset({1, 2, 3}), isFalse);
    });

    test('hashCode is consistent with equality', () {
      final a = iset({1, 2, 3, 4, 5});
      final b = iset({5, 4, 3, 2, 1});
      expect(a.hashCode, b.hashCode);
    });

    test('ISet.from(IHashSet) returns same instance', () {
      final s = iset({1, 2, 3, 4, 5}) as IHashSet<int>;
      expect(identical(IHashSet.from(s), s), isTrue);
    });

    test('IHashSet.empty has size 0', () {
      expect(IHashSet.empty<int>().size, 0);
      expect(IHashSet.empty<int>().isEmpty, isTrue);
    });

    test('init removes last element', () {
      final s = iset({1, 2, 3, 4, 5});
      expect(s.init.size, 4);
      expect(s.init.contains(s.last), isFalse);
    });

    test('inits produces n+1 sets', () {
      final s = iset({1, 2, 3, 4, 5});
      final all = s.inits.toIList();
      expect(all.size, 6); // s, s.init, ..., empty
    });

    test('tail removes head element', () {
      final s = iset({1, 2, 3, 4, 5});
      final t = s.tail;
      expect(t.size, 4);
      expect(t.contains(s.head), isFalse);
    });

    test('large set round-trip through builder', () {
      final elems = List.generate(100, (i) => i);
      final s = iset(elems);
      expect(s.size, 100);
      for (final e in elems) {
        expect(s.contains(e), isTrue);
      }
    });

    test('ISet.from fast paths preserve type', () {
      final empty = ISet.empty<int>();
      expect(identical(ISet.from(empty), empty), isTrue);

      final s1 = iset({1});
      expect(identical(ISet.from(s1), s1), isTrue);

      final s2 = iset({1, 2});
      expect(identical(ISet.from(s2), s2), isTrue);

      final s3 = iset({1, 2, 3});
      expect(identical(ISet.from(s3), s3), isTrue);

      final s4 = iset({1, 2, 3, 4});
      expect(identical(ISet.from(s4), s4), isTrue);

      final hs = iset({1, 2, 3, 4, 5}) as IHashSet<int>;
      expect(identical(ISet.from(hs), hs), isTrue);
    });
  });

  group('ISet.flatten', () {
    test('empty outer set', () {
      expect(ISet.empty<ISet<int>>().flatten(), iset<int>({}));
    });

    test('outer set containing empty inner sets', () {
      final s = iset<ISet<int>>({iset<int>({}), iset<int>({})});
      expect(s.flatten(), iset<int>({}));
    });

    test('flattens nested sets with deduplication', () {
      final s = iset<ISet<int>>({
        iset({1, 2}),
        iset({2, 3}),
        iset({4}),
      });
      expect(s.flatten(), iset({1, 2, 3, 4}));
    });

    test('flattens into large IHashSet', () {
      final inner1 = iset({1, 2, 3, 4, 5});
      final inner2 = iset({6, 7, 8, 9, 10});
      final outer = iset<ISet<int>>({inner1, inner2});
      expect(outer.flatten().size, 10);
    });
  });
}
