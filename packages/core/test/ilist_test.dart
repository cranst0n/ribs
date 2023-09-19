import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('IList.empty', () {
    expect(nil<int>(), nil<int>());
    expect(nil<int>().size, 0);
  });

  test('IList.fill', () {
    expect(IList.fill(5, 1).toList(), [1, 1, 1, 1, 1]);
  });

  test('IList.of', () {
    expect(IList.of([1, 2, 3, 4]), ilist([1, 2, 3, 4]));
  });

  test('IList.pure', () {
    expect(IList.pure(42), ilist([42]));
  });

  test('IList.range', () {
    expect(IList.range(0, 3), ilist([0, 1, 2]));
    expect(IList.range(2, 5), ilist([2, 3, 4]));
    expect(IList.range(-1, 2), ilist([-1, 0, 1]));
  });

  test('IList.reduceOption', () {
    expect(IList.empty<int>().reduceOption((a, b) => a + b), none<int>());
    expect(ilist([1]).reduceOption((a, b) => a + b), const Some(1));
    expect(ilist([1, 2, 3]).reduceOption((a, b) => a + b), const Some(6));
  });

  test('IList.tabulate', () {
    expect(IList.tabulate(3, (ix) => ix * 2), ilist([0, 2, 4]));
  });

  test('IList.uncons', () {
    expect(ilist([1, 2, 3]).uncons((x) => x.isDefined), isTrue);
    expect(nil<int>().uncons((x) => x.isEmpty), isTrue);
  });

  test('IList[]', () {
    final l = ilist([0, 1, 2, 3, 4, 5]);

    expect(l[0], 0);
    expect(l[5], 5);

    expect(() => l[6], throwsRangeError);
  });

  test('IList.append', () {
    expect(nil<int>().append(1), ilist([1]));
    expect(ilist([0]).append(1), ilist([0, 1]));
  });

  test('IList.concat', () {
    expect(nil<int>().concat(nil<int>()), nil<int>());
    expect(ilist([1, 2, 3]).concat(nil<int>()), ilist([1, 2, 3]));
    expect(nil<int>().concat(ilist([1, 2, 3])), ilist([1, 2, 3]));
    expect(
        ilist([1, 2, 3]).concat(ilist([1, 2, 3])), ilist([1, 2, 3, 1, 2, 3]));
  });

  test('IList.contains', () {
    expect(nil<int>().contains(1), isFalse);
    expect(ilist([1, 2, 3]).contains(1), isTrue);
    expect(ilist([1, 2, 3]).contains(5), isFalse);
  });

  test('IList.deleteFirst', () {
    expect(nil<int>().deleteFirst((x) => x > 0), none<(int, IList<int>)>());
    expect(ilist([0, 1, 2]).deleteFirst((x) => x > 0), (1, ilist([0, 2])).some);
    expect(ilist([-2, -1, 0]).deleteFirst((x) => x > 0),
        none<(int, IList<int>)>());
  });

  test('IList.distinct', () {
    expect(nil<int>().distinct(), nil<int>());
    expect(ilist([1, 2, 3]).distinct(), ilist([1, 2, 3]));
    expect(ilist([3, 1, 2, 3]).distinct(), ilist([3, 1, 2]));
    expect(ilist([2, 1, 2, 3, 2, 2]).distinct(), ilist([2, 1, 3]));
  });

  test('IList.drop', () {
    expect(nil<int>().drop(1), nil<int>());
    expect(ilist([1]).drop(1), nil<int>());
    expect(ilist([1, 2, 3]).drop(0), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).drop(1), ilist([2, 3]));
    expect(ilist([1, 2, 3]).drop(100), nil<int>());
  });

  test('IList.dropRight', () {
    expect(nil<int>().dropRight(2), nil<int>());
    expect(ilist([1, 2, 3]).dropRight(0), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).dropRight(2), ilist([1]));
    expect(ilist([1, 2, 3]).dropRight(1000), nil<int>());
  });

  test('IList.dropWhile', () {
    expect(nil<int>().dropWhile((x) => x > 0), nil<int>());
    expect(ilist([1, 2, 3]).dropWhile((x) => x > 0), nil<int>());
    expect(ilist([-1, 2, 3]).dropWhile((x) => x > 0), ilist([-1, 2, 3]));
    expect(ilist([1, -2, 3]).dropWhile((x) => x > 0), ilist([-2, 3]));
  });

  test('IList.filter', () {
    expect(nil<int>().filter((x) => x > 0), nil<int>());
    expect(ilist([1, 2, 3]).filter((x) => x > 0), ilist([1, 2, 3]));
    expect(ilist([1, -2, 3]).filter((x) => x > 0), ilist([1, 3]));
    expect(ilist([-1, -2, -3]).filter((x) => x > 0), nil<int>());
  });

  test('IList.filterNot', () {
    expect(nil<int>().filterNot((x) => x > 0), nil<int>());
    expect(ilist([1, 2, 3]).filterNot((x) => x > 0), nil<int>());
    expect(ilist([1, -2, 3]).filterNot((x) => x > 0), ilist([-2]));
    expect(ilist([-1, -2, -3]).filterNot((x) => x > 0), ilist([-1, -2, -3]));
  });

  test('IList.find', () {
    expect(nil<int>().find((x) => x < 0), none<int>());
    expect(ilist([1, 2, 3]).find((x) => x < 0), none<int>());
    expect(ilist([-1, 2, 3]).find((x) => x < 0), (-1).some);
    expect(ilist([-1, -2, 3]).find((x) => x < 0), (-1).some);
  });

  test('IList.findLast', () {
    expect(nil<int>().findLast((x) => x < 0), none<int>());
    expect(ilist([1, 2, 3]).findLast((x) => x < 0), none<int>());
    expect(ilist([-1, 2, 3]).findLast((x) => x < 0), (-1).some);
    expect(ilist([-1, -2, 3]).findLast((x) => x < 0), (-2).some);
  });

  test('IList.flatMap', () {
    IList<int> f(int x) => IList.of([x - 1, x, x + 1]);

    expect(nil<int>().flatMap(f), nil<int>());
    expect(ilist([1, 2, 3]).flatMap(f), ilist([0, 1, 2, 1, 2, 3, 2, 3, 4]));
  });

  test('IList.foldLeft', () {
    double op(double a, double b) => a / b;

    expect(nil<double>().foldLeft(100000.0, op), 100000.0);
    expect(ilist([10000.0, 1000.0, 100.0]).foldLeft(1.0, op), 1e-9);
  });

  test('IList.foldRight', () {
    double op(double a, double b) => a / b;

    expect(nil<double>().foldRight(100000.0, op), 100000.0);
    expect(ilist([10000.0, 1000.0, 100.0]).foldRight(1.0, op), 1000.0);
  });

  test('IList.groupBy', () {
    final l = ilist([1, 2, 3, 4, 5, 6, 7, 8, 9]);

    expect(
      l.groupBy((a) => a % 3),
      imap({
        0: ilist([3, 6, 9]),
        1: ilist([1, 4, 7]),
        2: ilist([2, 5, 8]),
      }),
    );
  });

  test('IList.groupMap', () {
    final l = ilist([1, 2, 3, 4, 5, 6, 7, 8, 9]);

    expect(
      l.groupMap((a) => a % 3, (a) => a * 2),
      imap({
        0: ilist([6, 12, 18]),
        1: ilist([2, 8, 14]),
        2: ilist([4, 10, 16]),
      }),
    );
  });

  test('IList.headOption', () {
    expect(nil<int>().headOption, none<int>());
    expect(ilist([1, 2, 3]).headOption, 1.some);
  });

  test('IList.init', () {
    expect(nil<int>().init(), nil<int>());
    expect(ilist([1]).init(), nil<int>());
    expect(ilist([1, 2, 3]).init(), ilist([1, 2]));
  });

  test('IList.insertAt', () {
    expect(nil<int>().insertAt(0, 42), ilist([42]));
    expect(nil<int>().insertAt(1, 42), nil<int>());

    expect(ilist([1, 2, 3]).insertAt(-1, 42), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).insertAt(0, 42), ilist([42, 1, 2, 3]));
    expect(ilist([1, 2, 3]).insertAt(1, 42), ilist([1, 42, 2, 3]));
    expect(ilist([1, 2, 3]).insertAt(2, 42), ilist([1, 2, 42, 3]));
    expect(ilist([1, 2, 3]).insertAt(3, 42), ilist([1, 2, 3, 42]));
    expect(ilist([1, 2, 3]).insertAt(100, 999), ilist([1, 2, 3]));
  });

  test('intersperse', () {
    expect(ilist([1, 2, 3]).intersperse(sep: 0), ilist([1, 0, 2, 0, 3]));
    expect(ilist([1, 2, 3]).intersperse(start: -1, sep: 0, end: 1),
        ilist([-1, 1, 0, 2, 0, 3, 1]));
  });

  test('IList.lastOption', () {
    expect(nil<int>().lastOption, none<int>());
    expect(ilist([1]).lastOption, 1.some);
  });

  test('IList.lift', () {
    expect(nil<int>().lift(0), none<int>());
    expect(ilist([1, 2, 3]).lift(0), 1.some);
    expect(ilist([1, 2, 3]).lift(-1), none<int>());
    expect(ilist([1, 2, 3]).lift(3), none<int>());
  });

  test('IList.map', () {
    expect(nil<int>().map((x) => x + 1), nil<int>());
    expect(ilist([1, 2, 3]).map((x) => x + 1), ilist([2, 3, 4]));
  });

  test('IList.mkString', () {
    expect(nil<int>().mkString(sep: ','), '');
    expect(
        ilist([1, 2, 3]).mkString(start: '[', sep: '|', end: '>'), '[1|2|3>');
  });

  test('IList.padTo', () {
    expect(nil<int>().padTo(0, 42), nil<int>());
    expect(nil<int>().padTo(2, 42), ilist([42, 42]));
    expect(ilist([1, 2, 3]).padTo(1, 42), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).padTo(3, 42), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).padTo(5, 42), ilist([1, 2, 3, 42, 42]));
  });

  test('IList.partition', () {
    expect(nil<int>().partition((x) => x < 0), (nil<int>(), nil<int>()));
    expect(ilist([1, -2, 3, 4]).partition((x) => x < 0),
        (ilist([-2]), ilist([1, 3, 4])));
  });

  test('IList.prepend', () {
    expect(nil<int>().prepend(1), ilist([1]));
    expect(ilist([1, 2, 3]).prepend(0), ilist([0, 1, 2, 3]));
  });

  test('IList.removeAt', () {
    expect(nil<int>().removeAt(1), nil<int>());
    expect(ilist([1, 2, 3]).removeAt(1), ilist([1, 3]));

    expect(ilist([1, 2, 3]).removeAt(-1), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).removeAt(3), ilist([1, 2, 3]));
  });

  test('IList.removeFirst', () {
    expect(nil<int>().removeFirst((x) => x < 0), nil<int>());
    expect(ilist([1, -2, -3]).removeFirst((x) => x < 0), ilist([1, -3]));
  });

  test('IList.replace', () {
    expect(nil<int>().replace(0, 42), nil<int>());
    expect(ilist([1, 2, 3]).replace(1, 42), ilist([1, 42, 3]));
  });

  test('IList.reverse', () {
    expect(nil<int>().reverse(), nil<int>());
    expect(ilist([1, 2, 3]).reverse(), ilist([3, 2, 1]));
  });

  test('IList.slice', () {
    expect(ilist([1, 2, 3]).slice(0, 2), ilist([1, 2]));
    expect(ilist([1, 2, 3]).slice(0, 20), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).slice(-2, 20), ilist([1, 2, 3]));
    expect(ilist([1, 2, 3]).slice(3, 1), nil<int>());
  });

  test('IList.sliding', () {
    expect(
        ilist([1, 2, 3, 4, 5]).sliding(2, 1),
        ilist([
          ilist([1, 2]),
          ilist([2, 3]),
          ilist([3, 4]),
          ilist([4, 5]),
        ]));

    expect(
        ilist([1, 2, 3, 4, 5]).sliding(1, 2),
        ilist([
          ilist([1]),
          ilist([3]),
          ilist([5]),
        ]));
  });

  test('IList.sortWith', () {
    expect(ilist([4, 2, 8, 1]).sortWith((a, b) => a < b), ilist([1, 2, 4, 8]));
  });

  test('IList.splitAt', () {
    expect(nil<int>().splitAt(3), (nil<int>(), nil<int>()));
    expect(ilist([1]).splitAt(0), (nil<int>(), ilist([1])));
    expect(ilist([1, 2]).splitAt(1), (ilist([1]), ilist([2])));
  });

  test('IList.startsWith', () {
    expect(nil<int>().startsWith(nil()), isTrue);
    expect(nil<int>().startsWith(ilist([1, 2])), isFalse);
    expect(ilist([1, 2]).startsWith(nil()), isTrue);

    expect(ilist([1, 2, 3, 4, 5]).startsWith(ilist([1, 2])), isTrue);
    expect(ilist([1]).startsWith(ilist([1, 2])), isFalse);
  });

  test('IList.sequenceEither', () {
    expect(
      ilist([1.asRight<int>(), 2.asRight<int>(), 3.asRight<int>()]).sequence(),
      ilist([1, 2, 3]).asRight<String>(),
    );

    expect(
      ilist([1.asRight<int>(), 42.asLeft<int>(), 3.asRight<int>()]).sequence(),
      42.asLeft<int>(),
    );
  });

  test('IList.traverseEither', () {
    expect(
      ilist([1, 2, 3]).traverseEither((a) => Either.pure<String, int>(a * 2)),
      ilist([2, 4, 6]).asRight<String>(),
    );

    expect(
      ilist([1, 2, 3]).traverseEither(
          (a) => Either.cond(() => a.isEven, () => a, () => 'odd')),
      'odd'.asLeft<int>(),
    );
  });

  test('IList.traverseIO', () async {
    final result = await ilist([1, 2, 3])
        .traverseIO((a) => IO.pure(a * 2))
        .unsafeRunToFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('IList.parTraverseIO', () async {
    final result = await ilist([1, 2, 3])
        .parTraverseIO((a) => IO.pure(a * 2))
        .unsafeRunToFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('IList.traverseFilterIO', () async {
    final result = await ilist([1, 2, 3])
        .traverseFilterIO((a) => IO.pure(Option.when(() => a.isOdd, () => a)))
        .unsafeRunToFuture();

    expect(result, ilist([1, 3]));
  });

  test('IList.traverseOption', () {
    expect(
      ilist([1, 2, 3]).traverseOption((a) => Option.pure(a * 2)),
      ilist([2, 4, 6]).some,
    );

    expect(
      ilist([1, 2, 3])
          .traverseOption((a) => Option.when(() => a.isEven, () => a)),
      none<IList<int>>(),
    );
  });

  test('IList.ap', () {
    expect(
      ilist([0, 1, 2]).ap(ilist([
        (int x) => '*' * x,
        (int x) => x.toString() * 2,
      ])),
      ilist(['', '00', '*', '11', '**', '22']),
    );
  });

  test('IList.unNone', () {
    expect(
      ilist([0.some, none<int>(), 2.some, 3.some]).unNone(),
      ilist([0, 2, 3]),
    );
  });
}
