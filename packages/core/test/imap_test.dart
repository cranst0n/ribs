import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('IMap.empty', () {
    expect(imap({}).size, 0);
    expect(imap({}), imap({}));
  });

  test('IMap.andThen', () {
    final m = imap({1: 2, 3: 4}).andThen((n) => n * 2);

    expect(m(1), const Some(4));
    expect(m(2), none<int>());
    expect(m(3), const Some(8));
  });

  test('IMap.compose', () {
    final f = imap({0: 2, 2: 4})
        .compose((String n) => n.codeUnitAt(0) - 'A'.codeUnitAt(0));

    expect(f('A'), const Some(2));
    expect(f('B'), none<int>());
    expect(f('C'), const Some(4));
  });

  test('IMap.concat', () {
    final m1 = imap({1: 1, 3: 3});
    final m2 = imap({2: 2, 4: 4});

    final m = m1.concat(m2);

    expect(m, imap({1: 1, 2: 2, 3: 3, 4: 4}));
  });

  test('IMap.contains', () {
    final m = imap({1: 1, 3: 3});

    expect(m.contains(1), isTrue);
    expect(m.contains(2), isFalse);
  });

  test('IMap.count', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.count((k, _) => k.isOdd), 3);
    expect(m.count((k, v) => k + v <= 5), 2);
  });

  test('IMap.exists', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.exists((k, v) => k == v), isTrue);
    expect(m.exists((k, v) => k != v), isFalse);
  });

  test('IMap.filter', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.filter((k, _) => k.isEven), imap({2: 2, 4: 4}));
    expect(m.filter((k, _) => k > 10), imap({}));
  });

  test('IMap.filterNot', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.filterNot((k, _) => k.isEven), imap({1: 1, 3: 3, 5: 5}));
    expect(m.filterNot((k, _) => k > 10), m);
  });

  test('IMap.find', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.find((k, v) => k + v > 5), const Some((3, 3)));
    expect(m.find((k, v) => k + v > 10), none<(int, int)>());
  });

  test('IMap.flatMap', () {
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

  test('IMap.foldLeft', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.foldLeft(1, (acc, k, v) => acc * k), 120);
  });

  test('IMap.forall', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.forall((k, v) => k + v < 100), isTrue);
    expect(m.forall((k, v) => k + v < 10), isFalse);
  });

  test('IMap.get', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.get(0), none<int>());
    expect(m.get(1), const Some(1));
    expect(m.get(5), const Some(5));
    expect(m.get(7), none<int>());
  });

  test('IMap.getOrElse', () {
    final m = imap({1: 1, 2: 2, 3: 3, 4: 4, 5: 5});

    expect(m.getOrElse(0, () => 100), 100);
    expect(m.getOrElse(1, () => 100), 1);
    expect(m.getOrElse(5, () => 100), 5);
    expect(m.getOrElse(7, () => 100), 100);
  });

  test('IMap.partition', () {
    final m = imap({1: 1, 2: 2, 3: 3});

    expect(
      m.partition((k, v) => k + v < 5),
      (imap({1: 1, 2: 2}), imap({3: 3})),
    );
  });

  test('IMap.removed', () {
    final m = imap({1: 1, 2: 2, 3: 3});

    expect(m.removed(0), m);
    expect(m.removed(1), imap({2: 2, 3: 3}));
  });

  test('IMap.updated', () {
    final m = imap({1: 1, 2: 2, 3: 3});

    expect(m.updated(0, 0), imap({0: 0, 1: 1, 2: 2, 3: 3}));
    expect(m.updated(1, 2), imap({1: 2, 2: 2, 3: 3}));
  });

  test('IMap.updatedWith', () {
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

  test('IMap.values', () {
    final m = imap({1: 1, 2: 2, 3: 3});

    expect(m.values, ilist([1, 2, 3]));
  });

  test('IMap.withDefault', () {
    final m = imap({1: 1, 2: 2, 3: 3}).withDefault((k) => k * 2);

    expect(m.get(0), const Some(0));
    expect(m.get(1), const Some(1));
    expect(m.get(3), const Some(3));
    expect(m.get(10), const Some(20));
  });
}
