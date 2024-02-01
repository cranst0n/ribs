import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('NonEmptyIList', () {
    test('fromIterable', () {
      expect(NonEmptyIList.fromDart(<int>[]), none<NonEmptyIList<int>>());
      expect(NonEmptyIList.fromDart([1]), Some(nel(1)));
      expect(NonEmptyIList.fromDart([1, 2, 3]), Some(nel(1, [2, 3])));
    });

    test('fromIterableUnsafe', () {
      expect(NonEmptyIList.fromDartUnsafe([1]), nel(1));
      expect(NonEmptyIList.fromDartUnsafe([1, 2, 3]), nel(1, [2, 3]));
      expect(() => NonEmptyIList.fromDartUnsafe(<int>[]), throwsStateError);
    });

    test('NonEmptyIList[]', () {
      expect(nel(1, [2, 3])[0], 1);
      expect(nel(1, [2, 3])[1], 2);
      expect(nel(1, [2, 3])[2], 3);
      expect(() => nel(1, [2, 3])[5], throwsRangeError);
    });

    test('append', () {
      expect(nel(1).appended(42), nel(1, [42]));
      expect(nel(1).appended(2), nel(1, [2]));
    });

    test('concat', () {
      expect(nel(1).concat(ilist([])), nel(1));
      expect(nel(1).concat(ilist([2, 3])), nel(1, [2, 3]));
      expect(nel(1, [2, 3]).concat(ilist([2, 3])), nel(1, [2, 3, 2, 3]));
    });

    test('concatNel', () {
      expect(nel(1).concatNel(nel(2, [3])), nel(1, [2, 3]));
      expect(nel(1, [2, 3]).concatNel(nel(4)), nel(1, [2, 3, 4]));
    });

    test('contains', () {
      expect(nel(1).contains(1), isTrue);
      expect(nel(1).contains(2), isFalse);
      expect(nel(1, [2, 3]).contains(2), isTrue);
      expect(nel(1, [2, 3]).contains(4), isFalse);
    });

    test('distinct', () {
      expect(nel(1, [2, 3]).distinct(), nel(1, [2, 3]));
      expect(nel(3, [1, 2, 3]).distinct(), nel(3, [1, 2]));
      expect(nel(2, [1, 2, 3, 2, 2]).distinct(), nel(2, [1, 3]));
    });

    test('drop', () {
      expect(nel(1).drop(1), nil<int>());
      expect(nel(1, [2, 3]).drop(0), ilist([1, 2, 3]));
      expect(nel(1, [2, 3]).drop(1), ilist([2, 3]));
      expect(nel(1, [2, 3]).drop(100), nil<int>());
    });

    test('dropRight', () {
      expect(nel(1, [2, 3]).dropRight(0), ilist([1, 2, 3]));
      expect(nel(1, [2, 3]).dropRight(2), ilist([1]));
      expect(nel(1, [2, 3]).dropRight(1000), nil<int>());
    });

    test('dropWhile', () {
      expect(nel(1, [2, 3]).dropWhile((x) => x > 0), nil<int>());
      expect(nel(-1, [2, 3]).dropWhile((x) => x > 0), ilist([-1, 2, 3]));
      expect(nel(1, [-2, 3]).dropWhile((x) => x > 0), ilist([-2, 3]));
    });

    test('exists', () {
      expect(nel(1, [2, 3]).exists((a) => a.isEven), isTrue);
      expect(nel(1, [3]).exists((a) => a.isEven), isFalse);
    });

    test('filter', () {
      expect(nel(1, [2, 3]).filter((x) => x > 0), ilist([1, 2, 3]));
      expect(nel(1, [-2, 3]).filter((x) => x > 0), ilist([1, 3]));
      expect(nel(-1, [-2, -3]).filter((x) => x > 0), nil<int>());
    });

    test('filterNot', () {
      expect(nel(1, [2, 3]).filterNot((x) => x > 0), nil<int>());
      expect(nel(1, [-2, 3]).filterNot((x) => x > 0), ilist([-2]));
      expect(nel(-1, [-2, -3]).filterNot((x) => x > 0), ilist([-1, -2, -3]));
    });

    test('find', () {
      expect(nel(1, [2, 3]).find((x) => x < 0), none<int>());
      expect(nel(-1, [2, 3]).find((x) => x < 0), isSome(-1));
      expect(nel(-1, [-2, 3]).find((x) => x < 0), isSome(-1));
    });

    test('findLast', () {
      expect(nel(1, [2, 3, 4]).findLast((a) => a > 5), isNone());
      expect(nel(1, [2, 3, 4]).findLast((a) => a.isEven), isSome(4));
      expect(nel(1, [2, 3, 4]).findLast((a) => a.isOdd), isSome(3));
    });

    test('flatMap', () {
      expect(nel(1, [2, 3]).flatMap((n) => nel(n - 1, [n, n + 1])),
          nel(0, [1, 2, 1, 2, 3, 2, 3, 4]));
    });

    test('flatTraverseIO', () {
      IO<IList<int>> f(int i) => IO.pure(ilist([i - 1, i, i + 1]));

      expect(
        ilist([1, 2, 3]).flatTraverseIO(f),
        ioSucceeded(ilist([0, 1, 2, 1, 2, 3, 2, 3, 4])),
      );
    });

    test('flatten', () {
      final l = nel(1, [2, 3]);
      final ll = nel(l, [l, l]);

      expect(ll.flatten(), l.concatNel(l).concatNel(l));
    });

    test('foldLeft', () {
      double op(double a, double b) => a / b;

      expect(nel(10000.0, [1000.0, 100.0]).foldLeft(1.0, op), 1e-9);
    });

    test('foldRight', () {
      double op(double a, double b) => a / b;

      expect(nel(10000.0, [1000.0, 100.0]).foldRight(1.0, op), 1000.0);
    });

    test('forAll', () {
      expect(nel(1, [2, 3]).forall((a) => a.isEven), isFalse);
      expect(nel(1, [2, 3]).forall((a) => a < 10), isTrue);
    });

    test('foreach', () {
      var count = 0;

      nel(1, [2, 3]).foreach((a) => count += a);

      expect(count, 6);
    });

    test('groupBy', () {
      final l = nel(1, [2, 3, 4, 5, 6, 7, 8, 9]);

      expect(
        l.groupBy((a) => a % 3),
        imap({
          0: nel(3, [6, 9]),
          1: nel(1, [4, 7]),
          2: nel(2, [5, 8]),
        }),
      );
    });

    test('groupMap', () {
      final l = nel(1, [2, 3, 4, 5, 6, 7, 8, 9]);

      expect(
        l.groupMap((a) => a % 3, (a) => a * 2),
        imap({
          0: nel(6, [12, 18]),
          1: nel(2, [8, 14]),
          2: nel(4, [10, 16]),
        }),
      );
    });

    test('init', () {
      expect(nel(1).init(), nil<int>());
      expect(nel(1, [2, 3]).init(), ilist([1, 2]));
    });

    test('last', () {
      expect(nel(1).last, 1);
      expect(nel(1, [2, 3]).last, 3);
    });

    test('lastIndexOf', () {
      expect(nel(1, [2, 3, 1, 2, 3]).lastIndexOf(0), isNone());
      expect(nel(1, [2, 3, 1, 2, 3]).lastIndexOf(1), isSome(3));
    });

    test('lift', () {
      expect(nel(1, [2, 3]).lift(0), isSome(1));
      expect(nel(1, [2, 3]).lift(-1), isNone());
      expect(nel(1, [2, 3]).lift(3), isNone());
    });

    test('map', () {
      expect(nel(1, [2, 3]).map((x) => x + 1), nel(2, [3, 4]));
    });

    test('maxBy', () {
      expect(
        nel('a', ['bc', 'def']).maxByOption((a) => a.length, Order.ints),
        const Some('def'),
      );
    });

    test('minBy', () {
      expect(
        nel('a', ['bc', 'def']).minByOption((a) => a.length, Order.ints),
        const Some('a'),
      );
    });

    test('mkString', () {
      expect(
        nel(1, [2, 3]).mkString(start: '[', sep: '|', end: '>'),
        '[1|2|3>',
      );
    });

    test('padTo', () {
      expect(nel(1, [2, 3]).padTo(1, 42), nel(1, [2, 3]));
      expect(nel(1, [2, 3]).padTo(3, 42), nel(1, [2, 3]));
      expect(nel(1, [2, 3]).padTo(5, 42), nel(1, [2, 3, 42, 42]));
    });

    test('parTraverseIO_', () {
      final io = nel(1, [2, 3]).parTraverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('prepend', () {
      expect(nel(1, [2, 3]).prepended(0), nel(0, [1, 2, 3]));
    });

    test('prependAll', () {
      expect(nel(1).prependedAll(nil()), nel(1));
      expect(nel(3).prependedAll(ilist([0, 1, 2])), nel(0, [1, 2, 3]));
    });

    test('removeFirst', () {
      expect(nel(1, [-2, -3]).removeFirst((x) => x < 0), ilist([1, -3]));
      expect(nel(1, [-2, -3]).removeFirst((x) => x > 10), ilist([1, -2, -3]));
    });

    test('replace', () {
      expect(nel(1, [2, 3]).replace(1, 42), nel(1, [42, 3]));
      expect(nel(1, [2, 3]).replace(100, 42), nel(1, [2, 3]));
    });

    test('reverse', () {
      expect(nel(1, [2, 3]).reverse(), nel(3, [2, 1]));
    });

    test('scan', () {
      expect(nel(1).scan(0, (a, b) => a + b), nel(0, [1]));
      expect(nel(1, [2, 3]).scan(0, (a, b) => a + b), nel(0, [1, 3, 6]));
    });

    test('scanLeft', () {
      expect(nel(1).scanLeft(0, (a, b) => a + b), nel(0, [1]));
      expect(nel(1, [2, 3]).scanLeft(0, (a, b) => a + b), nel(0, [1, 3, 6]));
    });

    test('scanRight', () {
      expect(nel(1).scanRight(0, (a, b) => a + b), nel(1, [0]));
      expect(nel(1, [2, 3]).scanRight(0, (a, b) => a + b), nel(6, [5, 3, 0]));
    });

    test('sort', () {
      expect(nel(2, [3, 1]).sorted(Order.ints), nel(1, [2, 3]));
    });

    test('sortBy', () {
      final m1 = imap({1: 'one'});
      final m2 = imap({1: 'one', 2: 'two'});
      final m3 = imap({1: 'one', 2: 'two', 3: 'three'});

      final l = nel(m2, [m3, m1]);

      expect(l.sortBy(Order.ints, (a) => a.size), nel(m1, [m2, m3]));
    });

    test('sortWith', () {
      expect(nel(4, [2, 8, 1]).sortWith((a, b) => a < b), nel(1, [2, 4, 8]));
    });

    test('sorted', () {
      expect(nel(4, [2, 8, 1]).sorted(Order.ints), nel(1, [2, 4, 8]));
    });

    test('startsWith', () {
      expect(nel(1, [2]).startsWith(nil()), isTrue);

      expect(nel(1, [2, 3, 4, 5]).startsWith(ilist([1, 2])), isTrue);
      expect(nel(1).startsWith(ilist([1, 2])), isFalse);
    });

    test('startsWithNel', () {
      expect(nel(1, [2, 3, 4, 5]).startsWithNel(nel(1, [2])), isTrue);
      expect(nel(1).startsWithNel(nel(1, [2])), isFalse);
    });

    test('take', () {
      expect(nel(1, [2, 3]).take(10), ilist([1, 2, 3]));
      expect(nel(1, [2, 3]).take(2), ilist([1, 2]));
      expect(nel(1, [2, 3]).take(0), nil<int>());
    });

    test('takeRight', () {
      expect(nel(1, [2, 3]).takeRight(10), ilist([1, 2, 3]));
      expect(nel(1, [2, 3]).takeRight(2), ilist([2, 3]));
      expect(nel(1, [2, 3]).takeRight(0), nil<int>());
    });

    test('takeWhile', () {
      expect(nel(1, [2, 3]).takeWhile((x) => x < 3), ilist([1, 2]));
      expect(nel(1, [2, 3]).takeWhile((x) => x < 5), ilist([1, 2, 3]));
      expect(nel(1, [2, 3]).takeWhile((x) => x < 0), nil<int>());
    });

    test('traverseEither', () {
      expect(
        nel(1, [2, 3]).traverseEither((a) => Either.pure<String, int>(a * 2)),
        nel(2, [4, 6]).asRight<String>(),
      );

      expect(
        nel(1, [2, 3]).traverseEither(
            (a) => Either.cond(() => a.isEven, () => a, () => 'odd')),
        'odd'.asLeft<int>(),
      );
    });

    test('traverseIO', () {
      final io = nel(1, [2, 3]).traverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(nel(2, [4, 6])));
    });

    test('traverseIO_', () {
      final io = nel(1, [2, 3]).traverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('parTraverseIO', () {
      final io = nel(1, [2, 3]).parTraverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(nel(2, [4, 6])));
    });

    test('traverseFilterIO', () {
      final io = nel(1, [2, 3]).traverseFilterIO(
          (a) => IO.pure(Option.when(() => a.isOdd, () => a)));

      expect(io, ioSucceeded(ilist([1, 3])));
    });

    test('traverseOption', () {
      expect(
        nel(1, [2, 3]).traverseOption((a) => Option.pure(a * 2)),
        nel(2, [4, 6]).some,
      );

      expect(
        nel(1, [2, 3])
            .traverseOption((a) => Option.when(() => a.isEven, () => a)),
        isNone(),
      );
    });

    test('updated', () {
      expect(nel(1, [2, 3]).updated(-1, 0), nel(1, [2, 3]));
      expect(nel(1, [2, 3]).updated(0, 2), nel(2, [2, 3]));
      expect(nel(1, [2, 3]).updated(1, 3), nel(1, [3, 3]));
      expect(nel(1, [2, 3]).updated(2, 4), nel(1, [2, 4]));
      expect(nel(1, [2, 3]).updated(3, 5), nel(1, [2, 3]));
    });

    test('zip', () {
      final a = nel(1, [2, 3, 4, 5]);
      final b = nel(5, [4, 3, 2, 1]);
      final c = nel(5, [4, 3]);

      expect(a.zip(b), ilist([(1, 5), (2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(b.zip(a), ilist([(5, 1), (4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(a.zip(c), ilist([(1, 5), (2, 4), (3, 3)]));
      expect(c.zip(a), ilist([(5, 1), (4, 2), (3, 3)]));
    });

    test('zipAll', () {
      final a = nel(1, [2, 3, 4, 5]);
      final b = nel(5, [4, 3, 2, 1]);
      final c = nel(5, [4, 3]);

      expect(a.zipAll(b, 0, 1), nel((1, 5), [(2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(b.zipAll(a, 0, 1), nel((5, 1), [(4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(a.zipAll(c, 0, 1), nel((1, 5), [(2, 4), (3, 3), (4, 1), (5, 1)]));
      expect(c.zipAll(a, 0, 1), nel((5, 1), [(4, 2), (3, 3), (0, 4), (0, 5)]));
    });

    test('zipWithIndex', () {
      expect(nel(0, [1, 2]).zipWithIndex(), nel((0, 0), [(1, 1), (2, 2)]));
    });
  });
}
