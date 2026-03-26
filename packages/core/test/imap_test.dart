import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test.dart';
import 'package:test/test.dart';

void main() {
  group('IMap', () {
    test('basic equality', () {
      final m0 = imap(<String, int>{});
      final m1 = imap({'A': 1, 'B': 2});
      final m2 = imap({'A': 1, 'B': 2});
      final m3 = imap({'A': 1, 'B': 2, 'C': 3});

      expect(m0 == m0, isTrue);
      expect(m0 == m1, isFalse);
      expect(m0 == m2, isFalse);
      expect(m0 == m3, isFalse);

      expect(m1 == m0, isFalse);
      expect(m1 == m1, isTrue);
      expect(m1 == m2, isTrue);
      expect(m1 == m3, isFalse);

      expect(m2 == m0, isFalse);
      expect(m2 == m1, isTrue);
      expect(m2 == m2, isTrue);
      expect(m2 == m3, isFalse);

      expect(m3 == m0, isFalse);
      expect(m3 == m1, isFalse);
      expect(m3 == m2, isFalse);
      expect(m3 == m3, isTrue);
    });

    Gen.imapOf(
      Gen.chooseInt(0, 10),
      Gen.alphaLowerChar,
      Gen.chooseInt(-10, 10),
    ).forAll('equality (property)', (map) => expect(map == map, isTrue));

    test('empty', () {
      expect(imap({}).size, 0);
      expect(imap({}), imap({}));
    });

    test('+', () {
      expect(imap<String, int>({}) + ('key', 1), imap({'key': 1}));
    });

    test('-', () {
      expect(imap<String, int>({}) - 'key', imap({}));
      expect(imap({'key': 1}) - 'key', imap({}));
    });

    test('andThen', () {
      final m = imap({1: 2, 3: 4}).andThen((n) => n * 2);

      expect(m(1), const Some(4));
      expect(m(2), none<int>());
      expect(m(3), const Some(8));
    });

    test('compose', () {
      final f = imap({0: 2, 2: 4}).compose((String n) => n.codeUnitAt(0) - 'A'.codeUnitAt(0));

      expect(f('A'), isSome(2));
      expect(f('B'), isNone());
      expect(f('C'), isSome(4));
    });

    test('concat', () {
      final m1 = imap({1: 1, 3: 3});
      final m2 = imap({2: 2, 4: 4});

      final m = m1.concat(m2);

      expect(m, imap({1: 1, 2: 2, 3: 3, 4: 4}));
    });

    test('contains', () {
      final m = imap({1: 1, 3: 3});

      expect(m.contains(1), isTrue);
      expect(m.contains(2), isFalse);
    });

    test('count', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.count((kv) => kv.$1.isOdd), 3);
      expect(m.count((kv) => kv.$1 + kv.$2 <= 5), 2);
    });

    test('exists', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.exists((kv) => kv.$1 == kv.$2), isTrue);
      expect(m.exists((kv) => kv.$1 != kv.$2), isFalse);
    });

    test('filter', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.filter((kv) => kv.$1.isEven), imap({2: 2, 4: 4}));
      expect(m.filter((kv) => kv.$1 > 10), imap({}));
    });

    test('filterNot', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.filterNot((kv) => kv.$1.isEven), imap({1: 1, 3: 3, 5: 5}));
      expect(m.filterNot((kv) => kv.$1 > 10), m);
    });

    test('find', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.find((kv) => kv.$1 + kv.$2 > 5), isSome());
      expect(m.find((kv) => kv.$1 + kv.$2 > 10), isNone());
    });

    test('flatMap', () {
      final m = imap({0: 0, 5: 5});

      expect(
        m
            .flatMap(
              (kv) => ilist([
                ((kv.$1 + 1).toString(), kv.$2 + 1),
                ((kv.$1 + 2).toString(), kv.$2 + 2),
              ]),
            )
            .toIList(),
        imap({'1': 1, '2': 2, '6': 6, '7': 7}).toIList(),
      );
    });

    test('foldLeft', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4});

      expect(m.foldLeft(1, (acc, kv) => acc * kv.$1), 24);
    });

    test('forall', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4});

      expect(m.forall((kv) => kv.$1 + kv.$2 < 100), isTrue);
      expect(m.forall((kv) => kv.$1 + kv.$2 < 8), isFalse);
    });

    test('foreach', () {
      var count = 0;

      imap({}).foreach((_) => count += 1);
      expect(count, 0);

      imap({1: 1, 2: 2}).foreach((_) => count += 1);
      expect(count, 2);

      imap({1: 1, 2: 2}).foreach((t) => count += t.$1);
      expect(count, 5);
    });

    test('get', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4});

      expect(m.get(0), isNone());
      expect(m.get(1), isSome(1));
      expect(m.get(7), isNone());
    });

    test('getOrElse', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4});

      expect(m.getOrElse(0, () => 100), 100);
      expect(m.getOrElse(1, () => 100), 1);
      expect(m.getOrElse(7, () => 100), 100);
    });

    test('keys', () {
      expect(imap<int, int>({}).keys.isEmpty, isTrue);
      expect(imap({1: 1, 3: 3}).keys, iset([1, 3]));
    });

    test('map', () {
      expect(imap<int, int>({}).map((kv) => kv.$1 + kv.$2).isEmpty, isTrue);
      expect(imap({1: 1, 2: 2, 3: 3}).map((kv) => kv.$1 + kv.$2).toIList(), ilist([2, 4, 6]));
    });

    test('mapValues', () {
      expect(imap<int, int>({}).mapValues((a) => a + 1), imap<int, int>({}));

      expect(
        imap({1: 1, 2: 2, 3: 3}).mapValues((a) => a + 1),
        imap({1: 2, 2: 3, 3: 4}),
      );
    });

    test('partition', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(
        m.partition((kv) => kv.$1 + kv.$2 < 5),
        (imap({1: 1, 2: 2}), imap({3: 3})),
      );
    });

    test('reduceOption', () {
      (int, int) f((int, int) a, (int, int) b) => (a.$1 + b.$1, a.$2 + b.$2);

      expect(imap<int, int>({}).reduceOption(f), isNone());
      expect(imap({1: 1, 2: 2, 3: 3}).reduceOption(f), isSome((6, 6)));
    });

    test('removed', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(m.removed(0), m);
      expect(m.removed(1), imap({2: 2, 3: 3}));
    });

    test('removedAll', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(m.removedAll(ilist([0])), m);
      expect(m.removedAll(ilist([1, 3, 4])), imap({2: 2}));
    });

    test('tapEach', () {
      var keySum = 0;
      var valueSum = 0;

      void f((int, int) kv) {
        keySum += kv.$1;
        valueSum += kv.$2;
      }

      imap<int, int>({}).tapEach(f);
      expect(keySum, 0);
      expect(valueSum, 0);

      imap({1: 2, 3: 4}).tapEach(f);
      expect(keySum, 4);
      expect(valueSum, 6);
    });

    test('toIList', () {
      expect(imap<int, int>({}).toIList(), nil<(int, int)>());
      expect(imap({1: 1, 3: 3}).toIList(), ilist([(1, 1), (3, 3)]));
    });

    test('transform', () {
      String f(int k, int v) => '$k:$v';

      expect(imap<int, int>({}).transform(f), imap<int, String>({}));
      expect(imap({1: 1, 3: 3}).transform(f), imap({1: '1:1', 3: '3:3'}));
    });

    test('unzip', () {
      expect(imap<int, int>({}).unzip(), (nil<int>(), nil<int>()));
      expect(imap({1: 2, 3: 4}).unzip(), (ilist([1, 3]), ilist([2, 4])));
    });

    test('updated', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(m.updated(0, 0), imap({0: 0, 1: 1, 2: 2, 3: 3}));
      expect(m.updated(1, 2), imap({1: 2, 2: 2, 3: 3}));
    });

    test('updatedWith', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(
        m.updatedWith(0, (v) => v.map((a) => a * 2)),
        m,
      );

      expect(
        m.updatedWith(0, (v) => v.orElse(() => const Some(100))),
        m.updated(0, 100),
      );

      expect(
        m.updatedWith(3, (v) => v.map((a) => a * 2)),
        imap({1: 1, 2: 2, 3: 6}),
      );
    });

    test('values', () {
      expect(imap<int, int>({}).values.toIList(), nil<int>());
      expect(imap({1: 1, 2: 2, 3: 3}).values.toIList(), ilist([1, 2, 3]));
    });

    test('withDefault', () {
      final m = imap({1: 1, 2: 2, 3: 3}).withDefault((k) => k * 2);

      expect(m[0], 0);
      expect(m[1], 1);
      expect(m[3], 3);
      expect(m[10], 20);
    });

    test('withDefaultValue', () {
      final m = imap({1: 1, 2: 2, 3: 3}).withDefaultValue(42);

      expect(m[0], 42);
      expect(m[1], 1);
      expect(m[3], 3);
      expect(m[10], 42);
    });

    test('zip', () {
      final m = imap({1: 1, 2: 2, 3: 3});
      final l = ilist([9, 8, 7]);

      expect(m.zip(nil<int>()).toIList(), nil<((int, int), int)>());
      expect(imap<int, int>({}).zip(l).toIList(), nil<((int, int), int)>());

      expect(
        m.zip(l).toIList(),
        ilist([
          ((1, 1), 9),
          ((2, 2), 8),
          ((3, 3), 7),
        ]),
      );
    });

    test('drop / dropRight / dropWhile', () {
      final m = imap({1: 1, 2: 2, 3: 3});
      expect(m.drop(0).size, 3);
      expect(m.drop(3), imap<int, int>({}));
      expect(m.dropRight(0).size, 3);
      expect(m.dropRight(3), imap<int, int>({}));
      expect(m.dropWhile((_) => true), imap<int, int>({}));
      expect(m.dropWhile((_) => false).size, 3);
    });

    test('groupBy', () {
      final grouped = imap({1: 1, 2: 2, 3: 3, 4: 4}).groupBy(
        ((int, int) kv) => kv.$1.isEven,
      );
      expect(grouped.get(true), isSome(imap({2: 2, 4: 4})));
      expect(grouped.get(false), isSome(imap({1: 1, 3: 3})));
    });

    test('grouped', () {
      expect(imap({1: 1, 2: 2, 3: 3}).grouped(2).toIList().size, 2);
      expect(imap({1: 1, 2: 2, 3: 3}).grouped(3).toIList().size, 1);
    });

    test('init / inits', () {
      expect(imap({1: 1, 2: 2, 3: 3}).init.size, 2);
      expect(imap({1: 1, 2: 2}).inits.toIList().size, 3);
    });

    test('slice', () {
      expect(imap({1: 1, 2: 2, 3: 3}).slice(0, 3).size, 3);
      expect(imap({1: 1, 2: 2, 3: 3}).slice(1, 3).size, 2);
      expect(imap({1: 1, 2: 2, 3: 3}).slice(0, 0), imap<int, int>({}));
    });

    test('sliding', () {
      expect(imap({1: 1, 2: 2, 3: 3}).sliding(2).toIList().size, 2);
    });

    test('span', () {
      final (all, none_) = imap({1: 1, 2: 2, 3: 3}).span((_) => true);
      expect(all.size, 3);
      expect(none_, imap<int, int>({}));

      final (none2, all2) = imap({1: 1, 2: 2, 3: 3}).span((_) => false);
      expect(none2, imap<int, int>({}));
      expect(all2.size, 3);
    });

    test('splitAt', () {
      final (first, second) = imap({1: 1, 2: 2, 3: 3}).splitAt(2);
      expect(first.size, 2);
      expect(second.size, 1);
    });

    test('tail / tails', () {
      expect(imap({1: 1, 2: 2, 3: 3}).tail.size, 2);
      expect(imap({1: 1, 2: 2}).tails.toIList().size, 3);
    });

    test('take / takeRight / takeWhile', () {
      final m = imap({1: 1, 2: 2, 3: 3});
      expect(m.take(0), imap<int, int>({}));
      expect(m.take(3).size, 3);
      expect(m.takeRight(0), imap<int, int>({}));
      expect(m.takeRight(3).size, 3);
      expect(m.takeWhile((_) => false), imap<int, int>({}));
      expect(m.takeWhile((_) => true).size, 3);
    });

    test('withDefault - operations preserve default', () {
      final m = imap({1: 1, 2: 2, 3: 3}).withDefault((int k) => k * 10);

      expect(m.size, 3);
      expect(m.isEmpty, isFalse);
      expect(m.keys, iset([1, 2, 3]));
      expect(m.values.toISet(), iset([1, 2, 3]));
      expect(m.iterator.toIList().size, 3);

      // removed preserves the default function
      final m2 = m.removed(1);
      expect(m2[1], 10);
      expect(m2[2], 2);

      // updated preserves the default function
      final m3 = m.updated(5, 500);
      expect(m3[5], 500);
      expect(m3[9], 90);
    });
  });
}
