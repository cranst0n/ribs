import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('IMap', () {
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
      final f = imap({0: 2, 2: 4})
          .compose((String n) => n.codeUnitAt(0) - 'A'.codeUnitAt(0));

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

      expect(m.count((k, _) => k.isOdd), 3);
      expect(m.count((k, v) => k + v <= 5), 2);
    });

    test('exists', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.exists((k, v) => k == v), isTrue);
      expect(m.exists((k, v) => k != v), isFalse);
    });

    test('filter', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.filter((k, _) => k.isEven), imap({2: 2, 4: 4}));
      expect(m.filter((k, _) => k > 10), imap({}));
    });

    test('filterNot', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.filterNot((k, _) => k.isEven), imap({1: 1, 3: 3, 5: 5}));
      expect(m.filterNot((k, _) => k > 10), m);
    });

    test('find', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.find((k, v) => k + v > 5), isSome((3, 3)));
      expect(m.find((k, v) => k + v > 10), isNone());
    });

    test('flatMap', () {
      final m = imap({0: 0, 5: 5});

      expect(
        m.flatMap(
          (k, v) => ilist([
            ((k + 1).toString(), v + 1),
            ((k + 2).toString(), v + 2),
          ]),
        ),
        imap({'1': 1, '2': 2, '6': 6, '7': 7}),
      );
    });

    test('foldLeft', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.foldLeft(1, (acc, k, v) => acc * k), 120);
    });

    test('forall', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.forall((k, v) => k + v < 100), isTrue);
      expect(m.forall((k, v) => k + v < 10), isFalse);
    });

    test('foreach', () {
      var count = 0;

      imap({}).forEach((a, b) => count += 1);
      expect(count, 0);

      imap({1: 1, 2: 2}).forEach((a, b) => count += 1);
      expect(count, 2);
    });

    test('get', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.get(0), isNone());
      expect(m.get(1), isSome(1));
      expect(m.get(5), isSome(5));
      expect(m.get(7), isNone());
    });

    test('getOrElse', () {
      final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

      expect(m.getOrElse(0, () => 100), 100);
      expect(m.getOrElse(1, () => 100), 1);
      expect(m.getOrElse(5, () => 100), 5);
      expect(m.getOrElse(7, () => 100), 100);
    });

    test('keys', () {
      expect(imap<int, int>({}).keys, nil<int>());
      expect(imap({1: 1, 3: 3}).keys, ilist([1, 3]));
    });

    test('map', () {
      expect(imap<int, int>({}).map((a, b) => a + b), nil<int>());
      expect(imap({1: 1, 2: 2, 3: 3}).map((a, b) => a + b), ilist([2, 4, 6]));
    });

    test('partition', () {
      final m = imap({1: 1, 2: 2, 3: 3});

      expect(
        m.partition((k, v) => k + v < 5),
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

      void f(int k, int v) {
        keySum += k;
        valueSum += v;
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
      expect(imap<int, int>({}).values, nil<int>());
      expect(imap({1: 1, 2: 2, 3: 3}).values, ilist([1, 2, 3]));
    });

    test('withDefault', () {
      final m = imap({1: 1, 2: 2, 3: 3}).withDefault((k) => k * 2);

      expect(m.get(0), isSome(0));
      expect(m.get(1), isSome(1));
      expect(m.get(3), isSome(3));
      expect(m.get(10), isSome(20));
    });

    test('withDefaultValue', () {
      final m = imap({1: 1, 2: 2, 3: 3}).withDefaultValue(42);

      expect(m.get(0), isSome(42));
      expect(m.get(1), isSome(1));
      expect(m.get(3), isSome(3));
      expect(m.get(10), isSome(42));
    });

    test('zip', () {
      final m = imap({1: 1, 2: 2, 3: 3});
      final l = ilist([9, 8, 7]);

      expect(m.zip(nil<int>()), nil<((int, int), int)>());
      expect(imap<int, int>({}).zip(l), nil<((int, int), int)>());

      expect(
          m.zip(l),
          ilist([
            ((1, 1), 9),
            ((2, 2), 8),
            ((3, 3), 7),
          ]));
    });
  });
}
