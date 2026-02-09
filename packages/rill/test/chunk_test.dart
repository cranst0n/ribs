import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_rill/src/chunk.dart';
import 'package:test/test.dart';

void main() {
  group('Chunk', () {
    test('empty', () {
      expect(Chunk.empty<int>(), Chunk.empty<int>());
      expect(Chunk.empty<int>().size, 0);
    });

    test('fill', () {
      expect(Chunk.fill(5, 1).toList(), [1, 1, 1, 1, 1]);
    });

    test('of', () {
      expect(Chunk.fromDart([1, 2, 3, 4]), chunk([1, 2, 3, 4]));
    });

    test('pure', () {
      expect(Chunk.fromDart([42]), chunk([42]));
    });

    test('Chunk[]', () {
      final l = ilist([0, 1, 2, 3, 4, 5]);

      expect(l[0], 0);
      expect(l[5], 5);

      expect(() => l[6], throwsRangeError);
    });

    test('appended', () {
      expect(Chunk.empty<int>().appended(1), chunk([1]));
      expect(chunk([0]).appended(1), chunk([0, 1]));
    });

    test('collect', () {
      final l = chunk([1, 2, 3]);
      Option<int> f(int n) => Option.when(() => n.isOdd, () => n * 2);
      Option<int> g(int n) => Option.when(() => n > 0, () => n);

      expect(l.collect(f), chunk([2, 6]));
      expect(l.collect(g), l);
    });

    test('collectFirst', () {
      final l = chunk([1, 2, 3]);
      Option<int> f(int n) => Option.when(() => n.isOdd, () => n * 2);
      Option<int> g(int n) => Option.when(() => n > 0, () => n);
      Option<int> h(int n) => Option.when(() => n == 10, () => n);

      expect(l.collectFirst(f), isSome(2));
      expect(l.collectFirst(g), isSome(1));
      expect(l.collectFirst(h), isNone());
    });

    test('concat', () {
      expect(Chunk.empty<int>().concat(Chunk.empty<int>()), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).concat(Chunk.empty<int>()), chunk([1, 2, 3]));
      expect(Chunk.empty<int>().concat(chunk([1, 2, 3])), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).concat(chunk([1, 2, 3])), chunk([1, 2, 3, 1, 2, 3]));
    });

    test('contains', () {
      expect(Chunk.empty<int>().contains(1), isFalse);
      expect(chunk([1, 2, 3]).contains(1), isTrue);
      expect(chunk([1, 2, 3]).contains(5), isFalse);
    });

    test('containsSlice', () {
      expect(Chunk.empty<int>().containsSlice(Chunk.empty<int>()), isTrue);
      expect(Chunk.empty<int>().containsSlice(chunk([2, 3])), isFalse);
      expect(chunk([1, 2, 3]).containsSlice(chunk([2, 3])), isTrue);
      expect(chunk([1, 2, 3]).containsSlice(chunk([3])), isTrue);
    });

    test('corresponds', () {
      expect(
        chunk([1, 2, 3]).corresponds(chunk([2, 5, 6]), (a, b) => a * 2 == b),
        isFalse,
      );

      expect(
        chunk([1, 2, 3]).corresponds(chunk([2, 4, 6]), (a, b) => a * 2 == b),
        isTrue,
      );

      expect(
        chunk([1, 2, 3]).corresponds(chunk([2, 4, 6, 8]), (a, b) => a * 2 == b),
        isFalse,
      );
    });

    test('diff', () {
      expect(Chunk.empty<int>().diff(chunk([1, 2, 3])), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).diff(Chunk.empty<int>()), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).diff(chunk([1, 2, 3])), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).diff(chunk([1, 3, 5])), chunk([2]));
    });

    test('distinct', () {
      expect(Chunk.empty<int>().distinct(), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).distinct(), chunk([1, 2, 3]));
      expect(chunk([3, 1, 2, 3]).distinct(), chunk([3, 1, 2]));
      expect(chunk([2, 1, 2, 3, 2, 2]).distinct(), chunk([2, 1, 3]));
    });

    test('distinctBy', () {
      expect(
        chunk(['a', 'b', 'bb', 'aa']).distinctBy((a) => a.length),
        chunk(['a', 'bb']),
      );
    });

    test('drop', () {
      expect(Chunk.empty<int>().drop(1), Chunk.empty<int>());
      expect(chunk([1]).drop(1), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).drop(0), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).drop(1), chunk([2, 3]));
      expect(chunk([1, 2, 3]).drop(100), Chunk.empty<int>());
    });

    test('dropRight', () {
      expect(Chunk.empty<int>().dropRight(2), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).dropRight(0), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).dropRight(2), chunk([1]));
      expect(chunk([1, 2, 3]).dropRight(1000), Chunk.empty<int>());
    });

    test('dropWhile', () {
      expect(Chunk.empty<int>().dropWhile((x) => x > 0), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).dropWhile((x) => x > 0), Chunk.empty<int>());
      expect(chunk([-1, 2, 3]).dropWhile((x) => x > 0), chunk([-1, 2, 3]));
      expect(chunk([1, -2, 3]).dropWhile((x) => x > 0), chunk([-2, 3]));
    });

    test('endsWith', () {
      expect(Chunk.empty<int>().endsWith(chunk([1, 2, 3])), isFalse);
      expect(chunk([1, 2, 3]).endsWith(Chunk.empty<int>()), isTrue);
      expect(chunk([1, 2, 3]).endsWith(chunk([1, 2, 3])), isTrue);
      expect(chunk([1, 2, 3]).endsWith(chunk([2, 3])), isTrue);
      expect(chunk([1, 2, 3]).endsWith(chunk([1, 2, 3, 4])), isFalse);
    });

    test('exists', () {
      expect(Chunk.empty<int>().exists((a) => a.isEven), isFalse);
      expect(chunk([1, 2, 3]).exists((a) => a.isEven), isTrue);
      expect(chunk([1, 3]).exists((a) => a.isEven), isFalse);
    });

    test('filter', () {
      expect(Chunk.empty<int>().filter((x) => x > 0), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).filter((x) => x > 0), chunk([1, 2, 3]));
      expect(chunk([1, -2, 3]).filter((x) => x > 0), chunk([1, 3]));
      expect(chunk([-1, -2, -3]).filter((x) => x > 0), Chunk.empty<int>());
    });

    test('filterNot', () {
      expect(Chunk.empty<int>().filterNot((x) => x > 0), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).filterNot((x) => x > 0), Chunk.empty<int>());
      expect(chunk([1, -2, 3]).filterNot((x) => x > 0), chunk([-2]));
      expect(chunk([-1, -2, -3]).filterNot((x) => x > 0), chunk([-1, -2, -3]));
    });

    test('find', () {
      expect(Chunk.empty<int>().find((x) => x < 0), none<int>());
      expect(chunk([1, 2, 3]).find((x) => x < 0), none<int>());
      expect(chunk([-1, 2, 3]).find((x) => x < 0), isSome(-1));
      expect(chunk([-1, -2, 3]).find((x) => x < 0), isSome(-1));
    });

    test('findLast', () {
      expect(Chunk.empty<int>().findLast((x) => x < 0), isNone());
      expect(chunk([1, 2, 3]).findLast((x) => x < 0), isNone());
      expect(chunk([-1, 2, 3]).findLast((x) => x < 0), isSome(-1));
      expect(chunk([-1, -2, 3]).findLast((x) => x < 0), isSome(-2));
    });

    test('flatMap', () {
      Chunk<int> f(int x) => Chunk.fromDart([x - 1, x, x + 1]);

      expect(Chunk.empty<int>().flatMap(f), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).flatMap(f), chunk([0, 1, 2, 1, 2, 3, 2, 3, 4]));
    });

    test('foldLeft', () {
      double op(double a, double b) => a / b;

      expect(Chunk.empty<double>().foldLeft(100000.0, op), 100000.0);
      expect(chunk([10000.0, 1000.0, 100.0]).foldLeft(1.0, op), 1e-9);
    });

    test('foldRight', () {
      double op(double a, double b) => a / b;

      expect(Chunk.empty<double>().foldRight(100000.0, op), 100000.0);
      expect(chunk([10000.0, 1000.0, 100.0]).foldRight(1.0, op), 1000.0);
    });

    test('forall', () {
      expect(Chunk.empty<int>().forall((x) => x < 0), isTrue);
      expect(chunk([1, 2, 3]).forall((x) => x > 0), isTrue);
      expect(chunk([-1, 2, 3]).forall((x) => x < 0), isFalse);
      expect(chunk([-1, -2, 3]).forall((x) => x > 0), isFalse);
    });

    test('grouped', () {
      expect(Chunk.empty<int>().grouped(2).toIList(), nil<Chunk<int>>());

      expect(
        chunk([1]).grouped(2).toIList(),
        ilist([
          chunk([1]),
        ]),
      );

      expect(
        chunk([1, 2, 3]).grouped(2).toIList(),
        ilist([
          chunk([1, 2]),
          chunk([3]),
        ]),
      );
    });

    test('groupBy', () {
      final l = chunk([1, 2, 3, 4, 5, 6, 7, 8, 9]);

      expect(
        l.groupBy((a) => a % 3),
        imap({
          0: chunk([3, 6, 9]),
          1: chunk([1, 4, 7]),
          2: chunk([2, 5, 8]),
        }),
      );
    });

    test('groupMap', () {
      final l = chunk([1, 2, 3, 4, 5, 6, 7, 8, 9]);

      expect(
        l.groupMap((a) => a % 3, (a) => a * 2),
        imap({
          0: chunk([6, 12, 18]),
          1: chunk([2, 8, 14]),
          2: chunk([4, 10, 16]),
        }),
      );
    });

    test('groupMapReduce', () {
      IMap<A, int> occurances<A>(Chunk<A> l) =>
          l.groupMapReduce(identity, (_) => 1, (a, b) => a + b);

      expect(occurances(Chunk.empty<int>()), imap({}));
      expect(occurances(chunk([1, 2, 3])), imap({1: 1, 2: 1, 3: 1}));
      expect(occurances(chunk([1, 2, 3, 2, 1])), imap({1: 2, 2: 2, 3: 1}));
    });

    test('headOption', () {
      expect(Chunk.empty<int>().headOption, none<int>());
      expect(chunk([1, 2, 3]).headOption, isSome(1));
    });

    test('indexOfSlice', () {
      expect(Chunk.empty<int>().indexOfSlice(Chunk.empty<int>()), isSome(0));
      expect(ilist([1, 2, 3]).indexOfSlice(Chunk.empty<int>()), isSome(0));
      expect(Chunk.empty<int>().indexOfSlice(ilist([1, 2, 3])), isNone());
      expect(ilist([1, 2, 3]).indexOfSlice(ilist([2, 3])), isSome(1));
      expect(ivec([1, 2, 3, 4, 5, 6]).indexOfSlice(ivec([5, 6])), isSome(4));
    });

    test('indexOf', () {
      expect(Chunk.empty<int>().indexOf(2), isNone());
      expect(chunk([1, 2, 3]).indexOf(3), isSome(2));
      expect(chunk([1, 2, 3]).indexOf(0), isNone());
    });

    test('indexWhere', () {
      expect(Chunk.empty<int>().indexWhere((a) => a.isEven), isNone());
      expect(chunk([1, 2, 3]).indexWhere((a) => a.isEven), isSome(1));
    });

    test('init', () {
      expect(Chunk.empty<int>().init, Chunk.empty<int>());
      expect(chunk([1]).init, Chunk.empty<int>());
      expect(chunk([1, 2, 3]).init, chunk([1, 2]));
    });

    test('inits', () {
      expect(Chunk.empty<int>().inits.toIList(), ilist([Chunk.empty<int>()]));

      expect(
        chunk([1]).inits.toIList(),
        ilist([
          chunk([1]),
          Chunk.empty<int>(),
        ]),
      );

      expect(
        chunk([1, 2, 3]).inits.toIList(),
        ilist([
          chunk([1, 2, 3]),
          chunk([1, 2]),
          chunk([1]),
          Chunk.empty<int>(),
        ]),
      );
    });

    test('intersect', () {
      expect(Chunk.empty<int>().intersect(chunk([1, 2, 3])), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).intersect(Chunk.empty<int>()), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).intersect(chunk([1, 2, 3])), chunk([1, 2, 3]));
      expect(chunk([3, 1, 2]).intersect(chunk([1, 2, 3])), chunk([3, 1, 2]));
      expect(chunk([1, 2, 3]).intersect(chunk([1, 3, 5])), chunk([1, 3]));
      expect(chunk([1, 2, 3, 3]).intersect(chunk([1, 3, 5])), chunk([1, 3]));
      expect(
        chunk([1, 2, 3, 3]).intersect(chunk([1, 3, 5, 3])),
        chunk([1, 3, 3]),
      );
    });

    test('intersperse', () {
      expect(Chunk.empty<int>().intersperse(0), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).intersperse(0), chunk([1, 0, 2, 0, 3]));
    });

    test('lastIndexOf', () {
      expect(Chunk.empty<int>().lastIndexOf(0), isNone());
      expect(chunk([1, 2, 3, 1, 2, 3]).lastIndexOf(0), isNone());
      expect(chunk([1, 2, 3, 1, 2, 3]).lastIndexOf(1), isSome(3));
    });

    test('lastIndexOfSlice', () {
      expect(Chunk.empty<int>().lastIndexOfSlice(Chunk.empty<int>()), isSome(0));
      expect(chunk([1, 2, 3]).lastIndexOfSlice(Chunk.empty<int>()), isSome(3));
      expect(Chunk.empty<int>().lastIndexOfSlice(chunk([1, 2, 3])), isNone());
      expect(chunk([1, 2, 3]).lastIndexOfSlice(chunk([2, 3])), isSome(1));
      expect(chunk([2, 3, 2, 3]).lastIndexOfSlice(chunk([2, 3])), isSome(2));
    });

    test('lastOption', () {
      expect(Chunk.empty<int>().lastOption, isNone());
      expect(chunk([1]).lastOption, isSome(1));
    });

    test('lift', () {
      expect(Chunk.empty<int>().lift(0), isNone());
      expect(chunk([1, 2, 3]).lift(0), isSome(1));
      expect(chunk([1, 2, 3]).lift(-1), isNone());
      expect(chunk([1, 2, 3]).lift(3), isNone());
    });

    test('map', () {
      expect(Chunk.empty<int>().map((x) => x + 1), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).map((x) => x + 1), chunk([2, 3, 4]));
    });

    test('maxByOption', () {
      expect(Chunk.empty<String>().maxByOption((a) => a.length, Order.ints), isNone());
      expect(chunk(['a', 'bc', 'def']).maxByOption((a) => a.length, Order.ints), const Some('def'));
    });

    test('maxOption', () {
      expect(Chunk.empty<int>().maxOption(Order.ints), isNone());
      expect(chunk([1, 2, 3]).maxOption(Order.ints), isSome(3));
    });

    test('minByOption', () {
      expect(Chunk.empty<String>().minByOption((a) => a.length, Order.ints), isNone());
      expect(chunk(['a', 'bc', 'def']).minByOption((a) => a.length, Order.ints), const Some('a'));
    });

    test('minOption', () {
      expect(Chunk.empty<int>().minOption(Order.ints), isNone());
      expect(chunk([1, 2, 3]).minOption(Order.ints), isSome(1));
    });

    test('mkString', () {
      expect(Chunk.empty<int>().mkString(sep: ','), '');
      expect(chunk([1, 2, 3]).mkString(start: '[', sep: '|', end: '>'), '[1|2|3>');
    });

    test('padTo', () {
      expect(Chunk.empty<int>().padTo(0, 42), Chunk.empty<int>());
      expect(Chunk.empty<int>().padTo(2, 42), chunk([42, 42]));
      expect(chunk([1, 2, 3]).padTo(1, 42), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).padTo(3, 42), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).padTo(5, 42), chunk([1, 2, 3, 42, 42]));
    });

    test('partition', () {
      expect(Chunk.empty<int>().partition((x) => x < 0), (Chunk.empty<int>(), Chunk.empty<int>()));
      expect(chunk([1, -2, 3, 4]).partition((x) => x < 0), (chunk([-2]), chunk([1, 3, 4])));
    });

    test('partitionMap', () {
      Either<String, int> f(int x) => Either.cond(() => x.isEven, () => x, () => '$x');

      expect(Chunk.empty<int>().partitionMap(f), (Chunk.empty<String>(), Chunk.empty<int>()));
      expect(chunk([1, 2, 3]).partitionMap(f), (chunk(['1', '3']), chunk([2])));
    });

    test('prepend', () {
      expect(Chunk.empty<int>().prepended(1), chunk([1]));
      expect(chunk([1, 2, 3]).prepended(0), chunk([0, 1, 2, 3]));
    });

    test('prependAll', () {
      expect(Chunk.empty<int>().prependedAll(ilist([1])), chunk([1]));
      expect(chunk([3]).prependedAll(chunk([0, 1, 2])), chunk([0, 1, 2, 3]));
    });

    test('permutations', () {
      expect(Chunk.empty<int>().permutations().toIList(), nil<Chunk<int>>());

      expect(
        chunk([1, 2, 3]).permutations().toIList(),
        ilist([
          chunk([1, 2, 3]),
          chunk([1, 3, 2]),
          chunk([2, 1, 3]),
          chunk([2, 3, 1]),
          chunk([3, 1, 2]),
          chunk([3, 2, 1]),
        ]),
      );
    });

    test('reduceOption', () {
      expect(Chunk.empty<int>().reduceOption((a, b) => a + b), isNone());
      expect(chunk([1]).reduceOption((a, b) => a + b), isSome(1));
      expect(chunk([1, 2, 3]).reduceOption((a, b) => a + b), isSome(6));
      expect(chunk([1, 2, 3]).reduceOption((a, b) => a - b), isSome(-4));
    });

    test('reduceRightOption', () {
      expect(Chunk.empty<int>().reduceRightOption((a, b) => a - b), isNone());
      expect(chunk([1]).reduceRightOption((a, b) => a - b), isSome(1));
      expect(chunk([1, 2, 3]).reduceRightOption((a, b) => a - b), isSome(2));
    });

    test('removeAt', () {
      expect(() => Chunk.empty<int>().removeAt(0), throwsRangeError);
      expect(chunk([1, 2, 3]).removeAt(1), chunk([1, 3]));

      expect(() => chunk([1, 2, 3]).removeAt(-1), throwsRangeError);
      expect(chunk([1, 2, 3]).removeAt(0), chunk([2, 3]));
      expect(chunk([1, 2, 3]).removeAt(2), chunk([1, 2]));
    });

    test('removeFirst', () {
      expect(Chunk.empty<int>().removeFirst((x) => x < 0), Chunk.empty<int>());
      expect(chunk([1, -2, -3]).removeFirst((x) => x < 0), chunk([1, -3]));
    });

    test('reverse', () {
      expect(Chunk.empty<int>().reverse(), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).reverse(), chunk([3, 2, 1]));
    });

    test('sameElements', () {
      expect(Chunk.empty<int>().sameElements(Chunk.empty<int>()), isTrue);
      expect(chunk([1, 2, 3]).sameElements(chunk([1, 2, 3])), isTrue);
      expect(chunk([1, 2, 3, 4]).sameElements(chunk([1, 2, 3])), isFalse);
      expect(chunk([1, 2, 3]).sameElements(chunk([1, 2, 3, 4])), isFalse);
      expect(chunk([1, 2, 3]).sameElements(chunk([3, 2, 1])), isFalse);
    });

    test('scan (Left)', () {
      expect(Chunk.empty<int>().scan(0, (a, b) => a + b), chunk([0]));
      expect(chunk([1]).scan(0, (a, b) => a + b), chunk([0, 1]));
      expect(chunk([1, 2, 3]).scan(0, (a, b) => a + b), chunk([0, 1, 3, 6]));
      expect(
        Chunk.from(IList.range(0, 10)).scan(0, (a, b) => a + b),
        chunk([0, 0, 1, 3, 6, 10, 15, 21, 28, 36, 45]),
      );
    });

    test('scanRight', () {
      expect(Chunk.empty<int>().scanRight(0, (a, b) => a + b), chunk([0]));
      expect(chunk([1]).scanRight(0, (a, b) => a + b), chunk([1, 0]));
      expect(chunk([1, 2, 3]).scanRight(0, (a, b) => a + b), chunk([6, 5, 3, 0]));
      expect(
        Chunk.from(IList.range(0, 10)).scanRight(0, (a, b) => a + b),
        chunk([45, 45, 44, 42, 39, 35, 30, 24, 17, 9, 0]),
      );
    });

    test('slice', () {
      expect(chunk([1, 2, 3]).slice(0, 2), chunk([1, 2]));
      expect(chunk([1, 2, 3]).slice(0, 20), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).slice(-2, 20), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).slice(3, 1), Chunk.empty<int>());
    });

    test('sliding', () {
      expect(
        chunk([1, 2]).sliding(3).toIList(),
        ilist([
          chunk([1, 2]),
        ]),
      );

      expect(
        chunk([1, 2]).sliding(2).toIList(),
        ilist([
          chunk([1, 2]),
        ]),
      );

      expect(
        chunk([1, 2, 3, 4, 5]).sliding(2).toIList(),
        ilist([
          chunk([1, 2]),
          chunk([2, 3]),
          chunk([3, 4]),
          chunk([4, 5]),
        ]),
      );

      expect(
        chunk([1, 2, 3, 4, 5]).sliding(1, 2).toIList(),
        ilist([
          chunk([1]),
          chunk([3]),
          chunk([5]),
        ]),
      );

      expect(
        chunk([1, 2, 3, 4, 5]).sliding(2, 2).toIList(),
        ilist([
          chunk([1, 2]),
          chunk([3, 4]),
          chunk([5]),
        ]),
      );

      expect(
        chunk([1, 2, 3, 4]).sliding(2, 2).toIList(),
        ilist([
          chunk([1, 2]),
          chunk([3, 4]),
        ]),
      );
    });

    test('sorted', () {
      expect(Chunk.empty<int>().sorted(Order.ints), Chunk.empty<int>());
      expect(chunk([2, 3, 1]).sorted(Order.ints), chunk([1, 2, 3]));
    });

    test('sortBy', () {
      final m1 = imap({1: 'one'});
      final m2 = imap({1: 'one', 2: 'two'});
      final m3 = imap({1: 'one', 2: 'two', 3: 'three'});

      final l = chunk([m2, m3, m1]);

      expect(l.sortBy(Order.ints, (a) => a.size), chunk([m1, m2, m3]));
    });

    test('sortWith', () {
      expect(chunk([4, 2, 8, 1]).sortWith((a, b) => a < b), chunk([1, 2, 4, 8]));
    });

    test('sorted', () {
      expect(ilist([4, 2, 8, 1]).sorted(Order.ints), ilist([1, 2, 4, 8]));
    });

    test('span', () {
      expect(Chunk.empty<int>().span((n) => n > 3), (Chunk.empty<int>(), Chunk.empty<int>()));
      expect(chunk([1, 2, 3]).span((n) => n > 3), (Chunk.empty<int>(), chunk([1, 2, 3])));
      expect(chunk([1, 2, 3]).span((n) => n < 2), (chunk([1]), chunk([2, 3])));
      expect(chunk([1, 2, 3]).span((n) => n < 3), (chunk([1, 2]), chunk([3])));
      expect(chunk([1, 2, 3, 2, 1]).span((n) => n < 3), (chunk([1, 2]), chunk([3, 2, 1])));
    });

    test('splitAt', () {
      expect(Chunk.empty<int>().splitAt(3), (Chunk.empty<int>(), Chunk.empty<int>()));
      expect(chunk([1]).splitAt(0), (Chunk.empty<int>(), chunk([1])));
      expect(chunk([1, 2]).splitAt(1), (chunk([1]), chunk([2])));
    });

    test('startsWith', () {
      expect(Chunk.empty<int>().startsWith(Chunk.empty()), isTrue);
      expect(Chunk.empty<int>().startsWith(chunk([1, 2])), isFalse);
      expect(chunk([1, 2]).startsWith(Chunk.empty()), isTrue);

      expect(chunk([1, 2, 3, 4, 5]).startsWith(chunk([1, 2])), isTrue);
      expect(chunk([1]).startsWith(chunk([1, 2])), isFalse);
    });

    // test('sequenceEither', () {
    //   expect(
    //     ilist([1.asRight<int>(), 2.asRight<int>(), 3.asRight<int>()]).sequence(),
    //     ilist([1, 2, 3]).asRight<String>(),
    //   );

    //   expect(
    //     ilist([1.asRight<int>(), 42.asLeft<int>(), 3.asRight<int>()]).sequence(),
    //     42.asLeft<int>(),
    //   );
    // });

    test('tails', () {
      expect(Chunk.empty<int>().tails.toIList(), ilist([Chunk.empty<int>()]));

      expect(
        chunk([1]).tails.toIList(),
        ilist([
          chunk([1]),
          Chunk.empty<int>(),
        ]),
      );

      expect(
        chunk([1, 2, 3]).tails.toIList(),
        ilist([
          chunk([1, 2, 3]),
          chunk([2, 3]),
          chunk([3]),
          Chunk.empty<int>(),
        ]),
      );
    });

    test('take', () {
      expect(Chunk.empty<int>().take(10), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).take(10), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).take(2), chunk([1, 2]));
      expect(chunk([1, 2, 3]).take(0), Chunk.empty<int>());
    });

    test('takeRight', () {
      expect(Chunk.empty<int>().takeRight(10), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).takeRight(10), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).takeRight(2), chunk([2, 3]));
      expect(chunk([1, 2, 3]).takeRight(0), Chunk.empty<int>());
    });

    test('takeWhile', () {
      expect(Chunk.empty<int>().takeWhile((x) => x < 3), Chunk.empty<int>());
      expect(chunk([1, 2, 3]).takeWhile((x) => x < 3), chunk([1, 2]));
      expect(chunk([1, 2, 3]).takeWhile((x) => x < 5), chunk([1, 2, 3]));
      expect(chunk([1, 2, 3]).takeWhile((x) => x < 0), Chunk.empty<int>());
    });

    test('toISet', () {
      expect(Chunk.empty<int>().toISet(), iset<int>({}));
      expect(chunk([1, 2, 3]).toISet(), iset({1, 2, 3}));
      expect(chunk([1, 2, 3, 1, 2, 3]).toISet(), iset({1, 2, 3}));
    });

    test('traverseEither', () {
      expect(
        chunk([1, 2, 3]).traverseEither((a) => Either.pure<String, int>(a * 2)),
        chunk([2, 4, 6]).asRight<String>(),
      );

      expect(
        chunk([1, 2, 3]).traverseEither((a) => Either.cond(() => a.isEven, () => a, () => 'odd')),
        'odd'.asLeft<int>(),
      );
    });

    test('traverseOption', () {
      expect(
        chunk([1, 2, 3]).traverseOption((a) => Option.pure(a * 2)),
        chunk([2, 4, 6]).some,
      );

      expect(
        chunk([1, 2, 3]).traverseOption((a) => Option.when(() => a.isEven, () => a)),
        isNone(),
      );
    });

    test('updated', () {
      expect(() => Chunk.empty<int>().updated(0, 42), throwsRangeError);
      expect(chunk([1, 2, 3]).updated(1, 42), chunk([1, 42, 3]));
      expect(chunk([1, 2, 3]).updated(2, 42), chunk([1, 2, 42]));
      expect(() => chunk([1, 2, 3]).updated(3, 42), throwsRangeError);
    });

    // test('unNone', () {
    //   expect(
    //     ilist([0.some, none<int>(), 2.some, 3.some]).unNone(),
    //     ilist([0, 2, 3]),
    //   );
    // });

    test('zip', () {
      final a = chunk([1, 2, 3, 4, 5]);
      final b = chunk([5, 4, 3, 2, 1]);
      final c = chunk([5, 4, 3]);

      expect(a.zip(b), chunk([(1, 5), (2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(b.zip(a), chunk([(5, 1), (4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(a.zip(c), chunk([(1, 5), (2, 4), (3, 3)]));
      expect(c.zip(a), chunk([(5, 1), (4, 2), (3, 3)]));
    });

    test('zipAll', () {
      final a = chunk([1, 2, 3, 4, 5]);
      final b = chunk([5, 4, 3, 2, 1]);
      final c = chunk([5, 4, 3]);

      expect(a.zipAll(b, 0, 1), chunk([(1, 5), (2, 4), (3, 3), (4, 2), (5, 1)]));
      expect(b.zipAll(a, 0, 1), chunk([(5, 1), (4, 2), (3, 3), (2, 4), (1, 5)]));

      expect(a.zipAll(c, 0, 1), chunk([(1, 5), (2, 4), (3, 3), (4, 1), (5, 1)]));
      expect(c.zipAll(a, 0, 1), chunk([(5, 1), (4, 2), (3, 3), (0, 4), (0, 5)]));
    });

    test('zipWithIndex', () {
      expect(chunk([0, 1, 2]).zipWithIndex(), chunk([(0, 0), (1, 1), (2, 2)]));
    });
  });
}
