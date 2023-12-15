import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('IList', () {
    test('empty', () {
      expect(nil<int>(), nil<int>());
      expect(nil<int>().size, 0);
    });

    test('fill', () {
      expect(IList.fill(5, 1).toList(), [1, 1, 1, 1, 1]);
    });

    test('of', () {
      expect(IList.of([1, 2, 3, 4]), ilist([1, 2, 3, 4]));
    });

    test('pure', () {
      expect(IList.pure(42), ilist([42]));
    });

    test('range', () {
      expect(IList.range(0, 0), ilist([]));
      expect(IList.range(0, 3), ilist([0, 1, 2]));
      expect(IList.range(2, 5), ilist([2, 3, 4]));
      expect(IList.range(-1, 2), ilist([-1, 0, 1]));

      expect(IList.range(0, 4, 2), ilist([0, 2]));
      expect(IList.range(0, 9, 3), ilist([0, 3, 6]));

      expect(IList.range(10, 3, -3), ilist([10, 7, 4]));
      expect(IList.range(3, -3, -1), ilist([3, 2, 1, 0, -1, -2]));

      expect(() => IList.range(0, 10, 0), throwsArgumentError);
      expect(() => IList.range(0, 3, -1), throwsArgumentError);
    });

    test('rangeTo', () {
      expect(IList.rangeTo(0, 3), ilist([0, 1, 2, 3]));
      expect(IList.rangeTo(3, 0, -1), ilist([3, 2, 1, 0]));
    });

    test('tabulate', () {
      expect(IList.tabulate(3, (ix) => ix * 2), ilist([0, 2, 4]));
    });

    test('uncons', () {
      expect(ilist([1, 2, 3]).uncons((x) => x.isDefined), isTrue);
      expect(nil<int>().uncons((x) => x.isEmpty), isTrue);
    });

    test('IList[]', () {
      final l = ilist([0, 1, 2, 3, 4, 5]);

      expect(l[0], 0);
      expect(l[5], 5);

      expect(() => l[6], throwsRangeError);
    });

    test('ap', () {
      expect(
        ilist([0, 1, 2]).ap(ilist([
          (int x) => '*' * x,
          (int x) => x.toString() * 2,
        ])),
        ilist(['', '00', '*', '11', '**', '22']),
      );
    });

    test('append', () {
      expect(nil<int>().append(1), ilist([1]));
      expect(ilist([0]).append(1), ilist([0, 1]));
      expect(ilist([0]) + 1, ilist([0, 1]));
    });

    test('collect', () {
      final l = ilist([1, 2, 3]);
      Option<int> f(int n) => Option.when(() => n.isOdd, () => n * 2);
      Option<int> g(int n) => Option.when(() => n > 0, () => n);

      expect(l.collect(f), ilist([2, 6]));
      expect(l.collect(g), l);
    });

    test('collectFirst', () {
      final l = ilist([1, 2, 3]);
      Option<int> f(int n) => Option.when(() => n.isOdd, () => n * 2);
      Option<int> g(int n) => Option.when(() => n > 0, () => n);
      Option<int> h(int n) => Option.when(() => n == 10, () => n);

      expect(l.collectFirst(f), isSome(2));
      expect(l.collectFirst(g), isSome(1));
      expect(l.collectFirst(h), isNone());
    });

    test('combinations', () {
      expect(nil<int>().combinations(2).toIList(), nil<IList<int>>());

      expect(
        ilist([1, 2, 3]).combinations(2).toIList(),
        ilist([
          ilist([1, 2]),
          ilist([1, 3]),
          ilist([2, 3]),
        ]),
      );

      expect(
        ilist([1, 2, 3, 4, 5]).combinations(3).toIList(),
        ilist([
          ilist([1, 2, 3]),
          ilist([1, 2, 4]),
          ilist([1, 2, 5]),
          ilist([1, 3, 4]),
          ilist([1, 3, 5]),
          ilist([1, 4, 5]),
          ilist([2, 3, 4]),
          ilist([2, 3, 5]),
          ilist([2, 4, 5]),
          ilist([3, 4, 5]),
        ]),
      );

      expect(
        ilist([1, 1, 2, 3, 2]).combinations(3).toIList(),
        ilist([
          ilist([1, 1, 2]),
          ilist([1, 1, 3]),
          ilist([1, 2, 2]),
          ilist([1, 2, 3]),
          ilist([2, 2, 3]),
        ]),
      );
    });

    test('concat', () {
      expect(nil<int>().concat(nil<int>()), nil<int>());
      expect(ilist([1, 2, 3]).concat(nil<int>()), ilist([1, 2, 3]));
      expect(nil<int>().concat(ilist([1, 2, 3])), ilist([1, 2, 3]));
      expect(
          ilist([1, 2, 3]).concat(ilist([1, 2, 3])), ilist([1, 2, 3, 1, 2, 3]));
    });

    test('contains', () {
      expect(nil<int>().contains(1), isFalse);
      expect(ilist([1, 2, 3]).contains(1), isTrue);
      expect(ilist([1, 2, 3]).contains(5), isFalse);
    });

    test('containsSlice', () {
      expect(nil<int>().containsSlice(nil<int>()), isTrue);
      expect(nil<int>().containsSlice(ilist([2, 3])), isFalse);
      expect(ilist([1, 2, 3]).containsSlice(ilist([2, 3])), isTrue);
      expect(ilist([1, 2, 3]).containsSlice(ilist([3])), isTrue);
    });

    test('corresponds', () {
      expect(
        ilist([1, 2, 3]).corresponds(ilist([2, 5, 6]), (a, b) => a * 2 == b),
        isFalse,
      );

      expect(
        ilist([1, 2, 3]).corresponds(ilist([2, 4, 6]), (a, b) => a * 2 == b),
        isTrue,
      );

      expect(
        ilist([1, 2, 3]).corresponds(ilist([2, 4, 6, 8]), (a, b) => a * 2 == b),
        isFalse,
      );
    });

    test('deleteFirst', () {
      expect(nil<int>().deleteFirst((x) => x > 0), isNone());
      expect(ilist([0, 1, 2]).deleteFirst((x) => x > 0),
          isSome((1, ilist([0, 2]))));
      expect(ilist([-2, -1, 0]).deleteFirst((x) => x > 0), isNone());
    });

    test('diff', () {
      expect(nil<int>().diff(ilist([1, 2, 3])), nil<int>());
      expect(ilist([1, 2, 3]).diff(nil<int>()), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).diff(ilist([1, 2, 3])), nil<int>());
      expect(ilist([1, 2, 3]).diff(ilist([1, 3, 5])), ilist([2]));
    });

    test('distinct', () {
      expect(nil<int>().distinct(), nil<int>());
      expect(ilist([1, 2, 3]).distinct(), ilist([1, 2, 3]));
      expect(ilist([3, 1, 2, 3]).distinct(), ilist([3, 1, 2]));
      expect(ilist([2, 1, 2, 3, 2, 2]).distinct(), ilist([2, 1, 3]));
    });

    test('distinctBy', () {
      expect(
        ilist(['a', 'b', 'bb', 'aa']).distinctBy((a) => a.length),
        ilist(['a', 'bb']),
      );
    });

    test('drop', () {
      expect(nil<int>().drop(1), nil<int>());
      expect(ilist([1]).drop(1), nil<int>());
      expect(ilist([1, 2, 3]).drop(0), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).drop(1), ilist([2, 3]));
      expect(ilist([1, 2, 3]).drop(100), nil<int>());
    });

    test('dropRight', () {
      expect(nil<int>().dropRight(2), nil<int>());
      expect(ilist([1, 2, 3]).dropRight(0), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).dropRight(2), ilist([1]));
      expect(ilist([1, 2, 3]).dropRight(1000), nil<int>());
    });

    test('dropWhile', () {
      expect(nil<int>().dropWhile((x) => x > 0), nil<int>());
      expect(ilist([1, 2, 3]).dropWhile((x) => x > 0), nil<int>());
      expect(ilist([-1, 2, 3]).dropWhile((x) => x > 0), ilist([-1, 2, 3]));
      expect(ilist([1, -2, 3]).dropWhile((x) => x > 0), ilist([-2, 3]));
    });

    test('endsWith', () {
      expect(nil<int>().endsWith(ilist([1, 2, 3])), isFalse);
      expect(ilist([1, 2, 3]).endsWith(nil<int>()), isTrue);
      expect(ilist([1, 2, 3]).endsWith(ilist([1, 2, 3])), isTrue);
      expect(ilist([1, 2, 3]).endsWith(ilist([2, 3])), isTrue);
      expect(ilist([1, 2, 3]).endsWith(ilist([1, 2, 3, 4])), isFalse);
    });

    test('exists', () {
      expect(nil<int>().exists((a) => a.isEven), isFalse);
      expect(ilist([1, 2, 3]).exists((a) => a.isEven), isTrue);
      expect(ilist([1, 3]).exists((a) => a.isEven), isFalse);
    });

    test('filter', () {
      expect(nil<int>().filter((x) => x > 0), nil<int>());
      expect(ilist([1, 2, 3]).filter((x) => x > 0), ilist([1, 2, 3]));
      expect(ilist([1, -2, 3]).filter((x) => x > 0), ilist([1, 3]));
      expect(ilist([-1, -2, -3]).filter((x) => x > 0), nil<int>());
    });

    test('filterNot', () {
      expect(nil<int>().filterNot((x) => x > 0), nil<int>());
      expect(ilist([1, 2, 3]).filterNot((x) => x > 0), nil<int>());
      expect(ilist([1, -2, 3]).filterNot((x) => x > 0), ilist([-2]));
      expect(ilist([-1, -2, -3]).filterNot((x) => x > 0), ilist([-1, -2, -3]));
    });

    test('find', () {
      expect(nil<int>().find((x) => x < 0), none<int>());
      expect(ilist([1, 2, 3]).find((x) => x < 0), none<int>());
      expect(ilist([-1, 2, 3]).find((x) => x < 0), isSome(-1));
      expect(ilist([-1, -2, 3]).find((x) => x < 0), isSome(-1));
    });

    test('findLast', () {
      expect(nil<int>().findLast((x) => x < 0), isNone());
      expect(ilist([1, 2, 3]).findLast((x) => x < 0), isNone());
      expect(ilist([-1, 2, 3]).findLast((x) => x < 0), isSome(-1));
      expect(ilist([-1, -2, 3]).findLast((x) => x < 0), isSome(-2));
    });

    test('flatMap', () {
      IList<int> f(int x) => IList.of([x - 1, x, x + 1]);

      expect(nil<int>().flatMap(f), nil<int>());
      expect(ilist([1, 2, 3]).flatMap(f), ilist([0, 1, 2, 1, 2, 3, 2, 3, 4]));
    });

    test('flatTraverseIO', () {
      IO<IList<int>> f(int x) => IO.delay(() => ilist([x - 1, x, x + 1]));

      expect(nil<int>().flatTraverseIO(f), ioSucceeded(nil<int>()));
      expect(ilist([1]).flatTraverseIO(f), ioSucceeded(ilist([0, 1, 2])));
    });

    test('flatten', () {
      final l = ilist([1, 2, 3]);
      final ll = ilist([l, l, l]);

      expect(ll.flatten(), l.concat(l).concat(l));
    });

    test('foldLeft', () {
      double op(double a, double b) => a / b;

      expect(nil<double>().foldLeft(100000.0, op), 100000.0);
      expect(ilist([10000.0, 1000.0, 100.0]).foldLeft(1.0, op), 1e-9);
    });

    test('foldRight', () {
      double op(double a, double b) => a / b;

      expect(nil<double>().foldRight(100000.0, op), 100000.0);
      expect(ilist([10000.0, 1000.0, 100.0]).foldRight(1.0, op), 1000.0);
    });

    test('forall', () {
      expect(nil<int>().forall((x) => x < 0), isTrue);
      expect(ilist([1, 2, 3]).forall((x) => x > 0), isTrue);
      expect(ilist([-1, 2, 3]).forall((x) => x < 0), isFalse);
      expect(ilist([-1, -2, 3]).forall((x) => x > 0), isFalse);
    });

    test('grouped', () {
      expect(nil<int>().grouped(2).toIList(), nil<IList<int>>());

      expect(
        ilist([1]).grouped(2).toIList(),
        ilist([
          ilist([1])
        ]),
      );

      expect(
        ilist([1, 2, 3]).grouped(2).toIList(),
        ilist([
          ilist([1, 2]),
          ilist([3]),
        ]),
      );
    });

    test('groupBy', () {
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

    test('groupMap', () {
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

    test('groupMapReduce', () {
      IMap<A, int> occurances<A>(IList<A> l) =>
          l.groupMapReduce(id, (_) => 1, (a, b) => a + b);

      expect(occurances(nil<int>()), imap({}));
      expect(occurances(ilist([1, 2, 3])), imap({1: 1, 2: 1, 3: 1}));
      expect(occurances(ilist([1, 2, 3, 2, 1])), imap({1: 2, 2: 2, 3: 1}));
    });

    test('headOption', () {
      expect(nil<int>().headOption, none<int>());
      expect(ilist([1, 2, 3]).headOption, isSome(1));
    });

    test('indexOfSlice', () {
      expect(nil<int>().indexOfSlice(nil<int>()), isSome(0));
      expect(ilist([1, 2, 3]).indexOfSlice(nil<int>()), isSome(0));
      expect(nil<int>().indexOfSlice(ilist([1, 2, 3])), isNone());
      expect(ilist([1, 2, 3]).indexOfSlice(ilist([2, 3])), isSome(1));
    });

    test('indexOf', () {
      expect(nil<int>().indexOf(2), isNone());
      expect(ilist([1, 2, 3]).indexOf(3), isSome(2));
      expect(ilist([1, 2, 3]).indexOf(0), isNone());
    });

    test('indexWhere', () {
      expect(nil<int>().indexWhere((a) => a.isEven), isNone());
      expect(ilist([1, 2, 3]).indexWhere((a) => a.isEven), isSome(1));
    });

    test('init', () {
      expect(nil<int>().init(), nil<int>());
      expect(ilist([1]).init(), nil<int>());
      expect(ilist([1, 2, 3]).init(), ilist([1, 2]));
    });

    test('inits', () {
      expect(nil<int>().inits(), ilist([nil<int>()]));

      expect(
        ilist([1]).inits(),
        ilist([
          ilist([1]),
          nil<int>(),
        ]),
      );

      expect(
        ilist([1, 2, 3]).inits(),
        ilist([
          ilist([1, 2, 3]),
          ilist([1, 2]),
          ilist([1]),
          nil<int>(),
        ]),
      );
    });

    test('insertAt', () {
      expect(nil<int>().insertAt(0, 42), ilist([42]));
      expect(nil<int>().insertAt(1, 42), nil<int>());

      expect(ilist([1, 2, 3]).insertAt(-1, 42), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).insertAt(0, 42), ilist([42, 1, 2, 3]));
      expect(ilist([1, 2, 3]).insertAt(1, 42), ilist([1, 42, 2, 3]));
      expect(ilist([1, 2, 3]).insertAt(2, 42), ilist([1, 2, 42, 3]));
      expect(ilist([1, 2, 3]).insertAt(3, 42), ilist([1, 2, 3, 42]));
      expect(ilist([1, 2, 3]).insertAt(100, 999), ilist([1, 2, 3]));
    });

    test('intersect', () {
      expect(nil<int>().intersect(ilist([1, 2, 3])), nil<int>());
      expect(ilist([1, 2, 3]).intersect(nil<int>()), nil<int>());
      expect(ilist([1, 2, 3]).intersect(ilist([1, 2, 3])), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).intersect(ilist([1, 3, 5])), ilist([1, 3]));
    });

    test('intersperse', () {
      expect(ilist([1, 2, 3]).intersperse(sep: 0), ilist([1, 0, 2, 0, 3]));
      expect(ilist([1, 2, 3]).intersperse(start: -1, sep: 0, end: 1),
          ilist([-1, 1, 0, 2, 0, 3, 1]));
    });

    test('lastIndexOf', () {
      expect(nil<int>().lastIndexOf(0), isNone());
      expect(ilist([1, 2, 3, 1, 2, 3]).lastIndexOf(0), isNone());
      expect(ilist([1, 2, 3, 1, 2, 3]).lastIndexOf(1), isSome(3));
    });

    test('lastIndexOfSlice', () {
      expect(nil<int>().lastIndexOfSlice(nil<int>()), isSome(0));
      expect(ilist([1, 2, 3]).lastIndexOfSlice(nil<int>()), isSome(3));
      expect(nil<int>().lastIndexOfSlice(ilist([1, 2, 3])), isNone());
      expect(ilist([1, 2, 3]).lastIndexOfSlice(ilist([2, 3])), isSome(1));
      expect(ilist([2, 3, 2, 3]).lastIndexOfSlice(ilist([2, 3])), isSome(2));
    });

    test('lastOption', () {
      expect(nil<int>().lastOption, isNone());
      expect(ilist([1]).lastOption, isSome(1));
    });

    test('lift', () {
      expect(nil<int>().lift(0), isNone());
      expect(ilist([1, 2, 3]).lift(0), isSome(1));
      expect(ilist([1, 2, 3]).lift(-1), isNone());
      expect(ilist([1, 2, 3]).lift(3), isNone());
    });

    test('map', () {
      expect(nil<int>().map((x) => x + 1), nil<int>());
      expect(ilist([1, 2, 3]).map((x) => x + 1), ilist([2, 3, 4]));
    });

    test('maxByOption', () {
      expect(nil<String>().maxByOption((a) => a.length), isNone());
      expect(ilist(['a', 'bc', 'def']).maxByOption((a) => a.length),
          const Some('def'));
    });

    test('maxOption', () {
      expect(nil<int>().maxOption(), isNone());
      expect(ilist([1, 2, 3]).maxOption(), isSome(3));
    });

    test('minByOption', () {
      expect(nil<String>().minByOption((a) => a.length), isNone());
      expect(ilist(['a', 'bc', 'def']).minByOption((a) => a.length),
          const Some('a'));
    });

    test('minOption', () {
      expect(nil<int>().minOption(), isNone());
      expect(ilist([1, 2, 3]).minOption(), isSome(1));
    });

    test('mkString', () {
      expect(nil<int>().mkString(sep: ','), '');
      expect(
          ilist([1, 2, 3]).mkString(start: '[', sep: '|', end: '>'), '[1|2|3>');
    });

    test('padTo', () {
      expect(nil<int>().padTo(0, 42), nil<int>());
      expect(nil<int>().padTo(2, 42), ilist([42, 42]));
      expect(ilist([1, 2, 3]).padTo(1, 42), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).padTo(3, 42), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).padTo(5, 42), ilist([1, 2, 3, 42, 42]));
    });

    test('partition', () {
      expect(nil<int>().partition((x) => x < 0), (nil<int>(), nil<int>()));
      expect(ilist([1, -2, 3, 4]).partition((x) => x < 0),
          (ilist([-2]), ilist([1, 3, 4])));
    });

    test('partitionMap', () {
      Either<String, int> f(int x) =>
          Either.cond(() => x.isEven, () => x, () => '$x');

      expect(nil<int>().partitionMap(f), (nil<String>(), nil<int>()));
      expect(ilist([1, 2, 3]).partitionMap(f), (ilist(['1', '3']), ilist([2])));
    });

    test('prepend', () {
      expect(nil<int>().prepend(1), ilist([1]));
      expect(ilist([1, 2, 3]).prepend(0), ilist([0, 1, 2, 3]));
    });

    test('prependAll', () {
      expect(nil<int>().prependAll(ilist([1])), ilist([1]));
      expect(ilist([3]).prependAll(ilist([0, 1, 2])), ilist([0, 1, 2, 3]));
    });

    test('permutations', () {
      expect(nil<int>().permutations().toIList(), nil<IList<int>>());

      expect(
          ilist([1, 2, 3]).permutations().toIList(),
          ilist([
            ilist([1, 2, 3]),
            ilist([1, 3, 2]),
            ilist([2, 1, 3]),
            ilist([2, 3, 1]),
            ilist([3, 1, 2]),
            ilist([3, 2, 1]),
          ]));
    });

    test('reduceOption', () {
      expect(IList.empty<int>().reduceOption((a, b) => a + b), isNone());
      expect(ilist([1]).reduceOption((a, b) => a + b), isSome(1));
      expect(ilist([1, 2, 3]).reduceOption((a, b) => a + b), isSome(6));
      expect(ilist([1, 2, 3]).reduceOption((a, b) => a - b), isSome(-4));
    });

    test('reduceRightOption', () {
      expect(IList.empty<int>().reduceRightOption((a, b) => a - b), isNone());
      expect(ilist([1]).reduceRightOption((a, b) => a - b), isSome(1));
      expect(ilist([1, 2, 3]).reduceRightOption((a, b) => a - b), isSome(0));
    });

    test('removeAt', () {
      expect(nil<int>().removeAt(1), nil<int>());
      expect(ilist([1, 2, 3]).removeAt(1), ilist([1, 3]));

      expect(ilist([1, 2, 3]).removeAt(-1), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).removeAt(3), ilist([1, 2, 3]));
    });

    test('removeFirst', () {
      expect(nil<int>().removeFirst((x) => x < 0), nil<int>());
      expect(ilist([1, -2, -3]).removeFirst((x) => x < 0), ilist([1, -3]));
      expect(ilist([1, -2, -3]) - -3, ilist([1, -2]));
    });

    test('replace', () {
      expect(nil<int>().replace(0, 42), nil<int>());
      expect(ilist([1, 2, 3]).replace(1, 42), ilist([1, 42, 3]));
      expect(ilist([1, 2, 3]).replace(100, 42), ilist([1, 2, 3]));
    });

    test('reverse', () {
      expect(nil<int>().reverse(), nil<int>());
      expect(ilist([1, 2, 3]).reverse(), ilist([3, 2, 1]));
    });

    test('sameElements', () {
      expect(nil<int>().sameElements(nil<int>()), isTrue);
      expect(ilist([1, 2, 3]).sameElements(ilist([1, 2, 3])), isTrue);
      expect(ilist([1, 2, 3, 4]).sameElements(ilist([1, 2, 3])), isFalse);
      expect(ilist([1, 2, 3]).sameElements(ilist([1, 2, 3, 4])), isFalse);
      expect(ilist([1, 2, 3]).sameElements(ilist([3, 2, 1])), isFalse);
    });

    test('scan (Left)', () {
      expect(nil<int>().scan(0, (a, b) => a + b), ilist([0]));
      expect(ilist([1]).scan(0, (a, b) => a + b), ilist([0, 1]));
      expect(ilist([1, 2, 3]).scan(0, (a, b) => a + b), ilist([0, 1, 3, 6]));
      expect(
        IList.range(0, 10).scan(0, (a, b) => a + b),
        ilist([0, 0, 1, 3, 6, 10, 15, 21, 28, 36, 45]),
      );
    });

    test('scanRight', () {
      expect(nil<int>().scanRight(0, (a, b) => a + b), ilist([0]));
      expect(ilist([1]).scanRight(0, (a, b) => a + b), ilist([1, 0]));
      expect(
          ilist([1, 2, 3]).scanRight(0, (a, b) => a + b), ilist([6, 5, 3, 0]));
      expect(
        IList.range(0, 10).scanRight(0, (a, b) => a + b),
        ilist([45, 45, 44, 42, 39, 35, 30, 24, 17, 9, 0]),
      );
    });

    test('slice', () {
      expect(ilist([1, 2, 3]).slice(0, 2), ilist([1, 2]));
      expect(ilist([1, 2, 3]).slice(0, 20), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).slice(-2, 20), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).slice(3, 1), nil<int>());
    });

    test('sliding', () {
      expect(
        ilist([1, 2]).sliding(3).toIList(),
        ilist([
          ilist([1, 2])
        ]),
      );

      expect(
        ilist([1, 2]).sliding(2).toIList(),
        ilist([
          ilist([1, 2])
        ]),
      );

      expect(
        ilist([1, 2, 3, 4, 5]).sliding(2).toIList(),
        ilist([
          ilist([1, 2]),
          ilist([2, 3]),
          ilist([3, 4]),
          ilist([4, 5]),
        ]),
      );

      expect(
        ilist([1, 2, 3, 4, 5]).sliding(1, 2).toIList(),
        ilist([
          ilist([1]),
          ilist([3]),
          ilist([5]),
        ]),
      );

      expect(
        ilist([1, 2, 3, 4, 5]).sliding(2, 2).toIList(),
        ilist([
          ilist([1, 2]),
          ilist([3, 4]),
          ilist([5]),
        ]),
      );

      expect(
        ilist([1, 2, 3, 4]).sliding(2, 2).toIList(),
        ilist([
          ilist([1, 2]),
          ilist([3, 4]),
        ]),
      );
    });

    test('sort', () {
      expect(nil<int>().sort(Order.ints), nil<int>());
      expect(ilist([2, 3, 1]).sort(Order.ints), ilist([1, 2, 3]));
    });

    test('sortBy', () {
      final m1 = imap({1: 'one'});
      final m2 = imap({1: 'one', 2: 'two'});
      final m3 = imap({1: 'one', 2: 'two', 3: 'three'});

      final l = ilist([m2, m3, m1]);

      expect(l.sortBy((a) => a.size), ilist([m1, m2, m3]));
    });

    test('sortWith', () {
      expect(
          ilist([4, 2, 8, 1]).sortWith((a, b) => a < b), ilist([1, 2, 4, 8]));
    });

    test('sorted', () {
      expect(ilist([4, 2, 8, 1]).sorted(), ilist([1, 2, 4, 8]));
    });

    test('span', () {
      expect(nil<int>().span((n) => n > 3), (nil<int>(), nil<int>()));
      expect(
          ilist([1, 2, 3]).span((n) => n > 3), (nil<int>(), ilist([1, 2, 3])));
      expect(ilist([1, 2, 3]).span((n) => n < 2), (ilist([1]), ilist([2, 3])));
      expect(ilist([1, 2, 3]).span((n) => n < 3), (ilist([1, 2]), ilist([3])));
      expect(ilist([1, 2, 3, 2, 1]).span((n) => n < 3),
          (ilist([1, 2]), ilist([3, 2, 1])));
    });

    test('splitAt', () {
      expect(nil<int>().splitAt(3), (nil<int>(), nil<int>()));
      expect(ilist([1]).splitAt(0), (nil<int>(), ilist([1])));
      expect(ilist([1, 2]).splitAt(1), (ilist([1]), ilist([2])));
    });

    test('startsWith', () {
      expect(nil<int>().startsWith(nil()), isTrue);
      expect(nil<int>().startsWith(ilist([1, 2])), isFalse);
      expect(ilist([1, 2]).startsWith(nil()), isTrue);

      expect(ilist([1, 2, 3, 4, 5]).startsWith(ilist([1, 2])), isTrue);
      expect(ilist([1]).startsWith(ilist([1, 2])), isFalse);
    });

    test('sequenceEither', () {
      expect(
        ilist([1.asRight<int>(), 2.asRight<int>(), 3.asRight<int>()])
            .sequence(),
        ilist([1, 2, 3]).asRight<String>(),
      );

      expect(
        ilist([1.asRight<int>(), 42.asLeft<int>(), 3.asRight<int>()])
            .sequence(),
        42.asLeft<int>(),
      );
    });

    test('tails', () {
      expect(nil<int>().tails(), ilist([nil<int>()]));

      expect(
        ilist([1]).tails(),
        ilist([
          ilist([1]),
          nil<int>(),
        ]),
      );

      expect(
        ilist([1, 2, 3]).tails(),
        ilist([
          ilist([1, 2, 3]),
          ilist([2, 3]),
          ilist([3]),
          nil<int>(),
        ]),
      );
    });

    test('take', () {
      expect(nil<int>().take(10), nil<int>());
      expect(ilist([1, 2, 3]).take(10), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).take(2), ilist([1, 2]));
      expect(ilist([1, 2, 3]).take(0), nil<int>());
    });

    test('takeRight', () {
      expect(nil<int>().takeRight(10), nil<int>());
      expect(ilist([1, 2, 3]).takeRight(10), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).takeRight(2), ilist([2, 3]));
      expect(ilist([1, 2, 3]).takeRight(0), nil<int>());
    });

    test('takeWhile', () {
      expect(nil<int>().takeWhile((x) => x < 3), nil<int>());
      expect(ilist([1, 2, 3]).takeWhile((x) => x < 3), ilist([1, 2]));
      expect(ilist([1, 2, 3]).takeWhile((x) => x < 5), ilist([1, 2, 3]));
      expect(ilist([1, 2, 3]).takeWhile((x) => x < 0), nil<int>());
    });

    test('toISet', () {
      expect(nil<int>().toISet(), iset<int>({}));
      expect(ilist([1, 2, 3]).toISet(), iset({1, 2, 3}));
      expect(ilist([1, 2, 3, 1, 2, 3]).toISet(), iset({1, 2, 3}));
    });

    test('toNel', () {
      expect(nil<int>().toNel(), isNone());
      expect(ilist([1, 2, 3]).toNel(), isSome(nel(1, [2, 3])));
    });

    test('traverseEither', () {
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

    test('traverseIO', () {
      final io = ilist([1, 2, 3]).traverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(ilist([2, 4, 6])));
    });

    test('traverseIO_', () {
      final io = ilist([1, 2, 3]).traverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('parTraverseIO', () {
      final io = ilist([1, 2, 3]).parTraverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(ilist([2, 4, 6])));
    });

    test('parTraverseIO_', () {
      final io = ilist([1, 2, 3]).parTraverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('traverseFilterIO', () {
      final io = ilist([1, 2, 3]).traverseFilterIO(
          (a) => IO.pure(Option.when(() => a.isOdd, () => a)));

      expect(io, ioSucceeded(ilist([1, 3])));
    });

    test('traverseOption', () {
      expect(
        ilist([1, 2, 3]).traverseOption((a) => Option.pure(a * 2)),
        ilist([2, 4, 6]).some,
      );

      expect(
        ilist([1, 2, 3])
            .traverseOption((a) => Option.when(() => a.isEven, () => a)),
        isNone(),
      );
    });

    test('unNone', () {
      expect(
        ilist([0.some, none<int>(), 2.some, 3.some]).unNone(),
        ilist([0, 2, 3]),
      );
    });

    test('zip', () {
      final a = ilist([1, 2, 3, 4, 5]);
      final b = ilist([5, 4, 3, 2, 1]);
      final c = ilist([5, 4, 3]);

      expect(a.zip(b), ilist([(1, 5), (2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(b.zip(a), ilist([(5, 1), (4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(a.zip(c), ilist([(1, 5), (2, 4), (3, 3)]));
      expect(c.zip(a), ilist([(5, 1), (4, 2), (3, 3)]));
    });

    test('zipAll', () {
      final a = ilist([1, 2, 3, 4, 5]);
      final b = ilist([5, 4, 3, 2, 1]);
      final c = ilist([5, 4, 3]);

      expect(
          a.zipAll(b, 0, 1), ilist([(1, 5), (2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(
          b.zipAll(a, 0, 1), ilist([(5, 1), (4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(
          a.zipAll(c, 0, 1), ilist([(1, 5), (2, 4), (3, 3), (4, 1), (5, 1)]));
      expect(
          c.zipAll(a, 0, 1), ilist([(5, 1), (4, 2), (3, 3), (0, 4), (0, 5)]));
    });

    test('zipWithIndex', () {
      expect(ilist([0, 1, 2]).zipWithIndex(), ilist([(0, 0), (1, 1), (2, 2)]));
    });
  });
}
