import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('ILazyList', () {
    test('empty', () {
      expect(ILazyList.empty<int>().isEmpty, isTrue);
    });

    test('equality', () {
      final s = ILazyList.ints(0);

      expect(s.prepended(1).prepended(0), s.prepended(1).prepended(0));
    });

    test('does not not force head', () {
      var i = 0;
      int f() => i += 1;

      // ignore: unused_local_variable
      final s = ILazyList.empty<int>().prependedLazy(f).prependedLazy(f);

      expect(i, 0);
    });

    group('toString', () {
      test('empty toString', () {
        expect(ILazyList.empty<int>().toString(), 'ILazyList()');
      });

      test('toString when head and tail both are not evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        expect(l.toString(), 'ILazyList(<not computed>)');
      });

      test('toString when only head is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.head;

        // expect(l.head, 1);
        expect(l.toString(), 'ILazyList(1, <not computed>)');
      });

      test('toString when head and tail is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.head;
        l.tail;

        expect(l.toString(), 'ILazyList(1, <not computed>)');
      });

      test('toString when head and tail head is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.head;
        l.tail.head;

        expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
      });

      test('toString when head is not evaluated and only tail is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.tail;

        expect(l.toString(), 'ILazyList(1, <not computed>)');
      });

      test('toString when head is not evaluated and tail head is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.tail.head;

        expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
      });

      test('toString when head is not evaluated and tail.tail is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.tail.tail;

        expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
      });

      test('toString when head is not evaluated and tail.tail.head is evaluated', () {
        final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
        l.tail.tail.head;

        expect(l.toString(), 'ILazyList(1, 2, 3, <not computed>)');
      });

      test('toString when lazy list is forced to list', () {
        final l = ILazyList.empty<int>()
            .prependedLazy(() => 4)
            .prependedLazy(() => 3)
            .prependedLazy(() => 2)
            .prependedLazy(() => 1);

        l.toIList();

        expect(l.toString(), 'ILazyList(1, 2, 3, 4)');
      });

      test('toString when ILazyList is empty', () {
        // cached empty
        final l1 = ILazyList.empty<int>();
        expect(l1.toString(), 'ILazyList()');

        // non-cached empty
        final l2 = ILazyList.unfold(0, (_) => none());
        expect(l2.toString(), 'ILazyList(<not computed>)');
      });

      test('toString for single element list', () {
        final l = ILazyList.from(ilist([1]));
        l.force();

        expect(l.toString(), 'ILazyList(1)');
      });

      test('toString when ILazyList has cyclic reference', () {
        late ILazyList<int> cyc;

        cyc = ILazyList.from(
          ilist([1]),
        ).appended(2).appended(3).appended(4).lazyAppendedAll(() => cyc);

        final l = cyc;
        expect(l.toString(), 'ILazyList(<not computed>)');

        l.head;
        expect(l.toString(), 'ILazyList(1, <not computed>)');

        l.tail;
        expect(l.toString(), 'ILazyList(1, <not computed>)');

        l.tail.head;
        expect(l.toString(), 'ILazyList(1, 2, <not computed>)');

        l.tail.tail.head;
        expect(l.toString(), 'ILazyList(1, 2, 3, <not computed>)');

        l.tail.tail.tail.head;
        expect(l.toString(), 'ILazyList(1, 2, 3, 4, <not computed>)');

        l.tail.tail.tail.tail.head;
        expect(l.toString(), 'ILazyList(1, 2, 3, 4, <cycle>)');
      });
    });

    test('drop', () {
      expect(<int>[], ILazyList.empty<int>().drop(2).toList());
      expect(<int>[], ILazyList.from(ilist([1])).drop(2).toList());
      expect(<int>[], ILazyList.from(ilist([1, 2])).drop(2).toList());
      expect(<int>[3], ILazyList.from(ilist([1, 2, 3])).drop(2).toList());
      expect(<int>[3, 4], ILazyList.from(ilist([1, 2, 3, 4])).drop(2).toList());
    });

    test('force returns evaluated ILazyList', () {
      var i = 0;
      int f() => i += 1;
      final xs = ILazyList.from(RIterator.tabulate(3, (_) => f()));

      expect(i, 0);

      xs.force();
      expect(i, 3);

      expect(xs.toString(), 'ILazyList(1, 2, 3)');
    });

    test('same elements', () {
      ILazyList<A> ll<A>(List<A> xs) => ILazyList.from(xs.toIList());

      late ILazyList<int> cycle1;
      late ILazyList<int> cycle2;

      cycle1 = ll([1, 2]).lazyAppendedAll(() => cycle1);
      cycle2 = ll([1, 2, 3]).lazyAppendedAll(() => cycle2);

      expect(ll([]).sameElements(ll([])), isTrue);
      expect(ILazyList.empty<int>().sameElements(ll([1])), isFalse);
      expect(ll([1, 2]).sameElements(ll([1, 2])), isTrue);
      expect(ll([1, 2]).sameElements(ll([1])), isFalse);
      expect(ll([1]).sameElements(ll([1, 2])), isFalse);
      expect(ll([1]).sameElements(ll([2])), isFalse);

      expect(cycle1.sameElements(cycle1), isTrue);
      expect(cycle1.sameElements(cycle2), isFalse);
    });

    test('toString is stack safe', () {
      final l = ILazyList.from(Range.inclusive(1, 10000));
      l.foreach((_) {});
      final s = l.toString();

      expect(s, isNotEmpty); // no stack overflow
    });

    test('laziness', () {
      late ILazyList<int> fibs;

      fibs = ILazyList.from(
        ilist([0]),
      ).appended(1).lazyAppendedAll(() => fibs.zip(fibs.tail).map((t) => t.$1 + t.$2));

      expect(fibs.take(4).toList(), [0, 1, 1, 2]);

      var lazeCount = 0;
      int lazeL(int i) {
        lazeCount += 1;
        return i;
      }

      // ignore: unused_local_variable
      final xs21 = ILazyList.empty<int>()
          .prependedLazy(() => lazeL(3))
          .prependedLazy(() => lazeL(2))
          .prependedLazy(() => lazeL(1));

      expect(lazeCount, 0);
    });

    test('must compute head only once', () {
      var seedCounter = 0;
      var fCounter = 0;

      int seed() {
        seedCounter += 1;
        return 1;
      }

      int f(int x) {
        fCounter += 1;
        return x + 1;
      }

      final xs = ILazyList.iterate(seed, f);

      expect(seedCounter, 0);
      expect(fCounter, 0);

      xs.head;
      expect(seedCounter, 1);
      expect(fCounter, 0);

      xs.tail;
      expect(seedCounter, 1);
      expect(fCounter, 0);

      xs.tail.head;
      expect(seedCounter, 1);
      expect(fCounter, 1);

      xs.tail.tail;
      expect(seedCounter, 1);
      expect(fCounter, 1);

      xs.tail.tail.head;
      expect(seedCounter, 1);
      expect(fCounter, 2);

      xs.take(10).toList();
      expect(seedCounter, 1);
      expect(fCounter, 9);
    });

    test('updated', () {
      final lazyList = ILazyList.ints(0).take(4);
      final list = lazyList.toIList();

      lazyList.indices().foreach(
        (i) => expect(list.updated(i, -1), lazyList.updated(i, -1).toIList()),
      );

      expect(() => lazyList.updated(-1, -1), throwsRangeError);
    });

    test('tapEach', () {
      void checkIt(Function0<ILazyList<int>> makeLL) {
        final lb = ListBuffer<int>();
        final ll = makeLL().tapEach(lb.addOne);

        expect(lb.isEmpty, isTrue);
        expect(ll.take(2).toIVector(), ivec([1, 2]));
        expect(lb, ListBuffer<int>().addAll(ilist([1, 2])));
        expect(ll[3], 4);
        expect(lb, ListBuffer<int>().addAll(ilist([1, 2, 3, 4])));
        expect(ll.toIVector(), ivec([1, 2, 3, 4, 5]));
        expect(lb, ListBuffer<int>().addAll(ilist([1, 2, 3, 4, 5])));
      }

      checkIt(() => ILazyList.from(ivec([1, 2, 3, 4, 5])));
      checkIt(() => ILazyList.from(RIterator.tabulate(5, (x) => x + 1)));
    });

    test('lazyAppendedAll executes once', () {
      var count = 0;

      ILazyList.from(ilist([1])).lazyAppendedAll(() {
        count += 1;
        return ilist([2]);
      }).toIList();

      expect(count, 1);
    });

    test('reverse', () {
      final ll0 = ILazyList.ints(0).take(5);
      final ll1 = ll0.reverse();

      expect(ll0.toIList(), ilist([0, 1, 2, 3, 4]));
      expect(ll1.toIList(), ilist([4, 3, 2, 1, 0]));
    });

    test('builder', () {
      final b = ILazyList.builder<int>();
      b.addOne(1);
      b.addOne(2);
      b.addOne(3);
      expect(b.result().toIList(), ilist([1, 2, 3]));
    });

    test('builder addAll', () {
      final b = ILazyList.builder<int>();
      b.addAll(ilist([1, 2, 3]));
      b.addAll(ilist([4, 5]));
      expect(b.result().toIList(), ilist([1, 2, 3, 4, 5]));
    });

    test('builder clear', () {
      final b =
          ILazyList.builder<int>()
            ..addOne(1)
            ..addOne(2);
      b.clear();
      b.addOne(9);
      expect(b.result().toIList(), ilist([9]));
    });

    test('continually', () {
      expect(ILazyList.continually(42).take(4).toIList(), ilist([42, 42, 42, 42]));
    });

    test('fill', () {
      expect(ILazyList.fill(0, 7).toIList(), ilist(<int>[]));
      expect(ILazyList.fill(3, 7).toIList(), ilist([7, 7, 7]));
    });

    test('tabulate', () {
      expect(ILazyList.tabulate(0, (i) => i).toIList(), ilist(<int>[]));
      expect(ILazyList.tabulate(4, (i) => i * 2).toIList(), ilist([0, 2, 4, 6]));
    });

    test('unfold empty', () {
      final l = ILazyList.unfold(0, (_) => none<(int, int)>());
      expect(l.isEmpty, isTrue);
    });

    test('operator [] out of bounds', () {
      expect(() => ILazyList.from(ilist([1, 2, 3]))[5], throwsRangeError);
    });

    test('appended on empty', () {
      final l = ILazyList.empty<int>().appended(42);
      expect(l.toIList(), ilist([42]));
    });

    test('appendedAll', () {
      expect(
        ILazyList.empty<int>().appendedAll(ilist([1, 2])).toIList(),
        ilist([1, 2]),
      );
      expect(
        ILazyList.from(ilist([1, 2])).appendedAll(ilist([3, 4])).toIList(),
        ilist([1, 2, 3, 4]),
      );
    });

    test('collect', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      expect(
        l.collect((a) => a.isEven ? Some(a * 10) : none<int>()).toIList(),
        ilist([20, 40]),
      );
      expect(ILazyList.empty<int>().collect((a) => Some(a)).toIList(), ilist(<int>[]));
    });

    test('collectFirst', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4]));
      expect(l.collectFirst((a) => a > 2 ? Some(a * 10) : none<int>()), const Some(30));
      expect(l.collectFirst((a) => a > 10 ? Some(a) : none<int>()), isA<None>());
      expect(ILazyList.empty<int>().collectFirst((a) => Some(a)), isA<None>());
    });

    test('concat', () {
      expect(
        ILazyList.from(ilist([1, 2])).concat(ilist([3, 4])).toIList(),
        ilist([1, 2, 3, 4]),
      );
    });

    test('diff', () {
      final l = ILazyList.from(ilist([1, 2, 3, 2, 1]));
      // diff removes first occurrences; remaining 2 and 1 pass through
      expect(l.diff(ilist([1, 2])).toIList(), ilist([3, 2, 1]));
    });

    test('distinct', () {
      expect(
        ILazyList.from(ilist([1, 2, 1, 3, 2])).distinct().toIList(),
        ilist([1, 2, 3]),
      );
    });

    test('distinctBy', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).distinctBy((x) => x % 2).toIList(),
        ilist([1, 2]),
      );
    });

    test('dropRight', () {
      expect(ILazyList.empty<int>().dropRight(2).toIList(), ilist(<int>[]));
      expect(ILazyList.from(ilist([1, 2, 3])).dropRight(0).toIList(), ilist([1, 2, 3]));
      expect(ILazyList.from(ilist([1, 2, 3])).dropRight(2).toIList(), ilist([1]));
      expect(ILazyList.from(ilist([1, 2, 3])).dropRight(5).toIList(), ilist(<int>[]));
    });

    test('dropWhile', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).dropWhile((x) => x < 3).toIList(),
        ilist([3, 4]),
      );
      expect(ILazyList.empty<int>().dropWhile((x) => true).toIList(), ilist(<int>[]));
    });

    test('filter / filterNot', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      expect(l.filter((x) => x.isEven).toIList(), ilist([2, 4]));
      expect(l.filterNot((x) => x.isEven).toIList(), ilist([1, 3, 5]));
    });

    test('find', () {
      expect(ILazyList.from(ilist([1, 2, 3])).find((x) => x > 1), const Some(2));
      expect(ILazyList.from(ilist([1, 2, 3])).find((x) => x > 10), isA<None>());
      expect(ILazyList.empty<int>().find((x) => true), isA<None>());
    });

    test('flatMap', () {
      final l = ILazyList.from(ilist([1, 2, 3]));
      expect(
        l.flatMap((x) => ILazyList.from(ilist([x, x * 10]))).toIList(),
        ilist([1, 10, 2, 20, 3, 30]),
      );
      expect(ILazyList.empty<int>().flatMap((x) => ilist([x])).toIList(), ilist(<int>[]));
    });

    test('foldLeft', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).foldLeft(0, (acc, x) => acc + x),
        10,
      );
    });

    test('grouped / sliding', () {
      // grouped produces an iterator of windows
      final grouped = ILazyList.from(ilist([1, 2, 3, 4, 5])).grouped(2);
      expect(grouped.hasNext, isTrue);
      expect(grouped.next().nonEmpty, isTrue);

      expect(ILazyList.empty<int>().grouped(2).hasNext, isFalse);

      // sliding produces windows with given step
      final sliding = ILazyList.from(ilist([1, 2, 3, 4])).sliding(2, 1);
      expect(sliding.hasNext, isTrue);
      expect(sliding.next().nonEmpty, isTrue);
    });

    test('init', () {
      expect(ILazyList.from(ilist([1, 2, 3])).init.toIList(), ilist([1, 2]));
    });

    test('intersect', () {
      final l = ILazyList.from(ilist([1, 2, 3, 2]));
      expect(l.intersect(ilist([2, 3])).toIList(), ilist([2, 3]));
    });

    test('intersperse', () {
      expect(
        ILazyList.from(ilist([1, 2, 3])).intersperse(0).toIList(),
        ilist([1, 0, 2, 0, 3, 0]),
      );
      expect(ILazyList.empty<int>().intersperse(0).toIList(), ilist(<int>[]));
    });

    test('iterator noSuchElement', () {
      final it = ILazyList.from(ilist([1])).iterator;
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('knownNonEmpty', () {
      final empty = ILazyList.empty<int>();
      expect(empty.knownNonEmpty, isFalse);

      final l = ILazyList.from(ilist([1, 2, 3]));
      expect(l.knownNonEmpty, isFalse); // not yet evaluated
      l.head;
      expect(l.knownNonEmpty, isTrue);
    });

    test('lazyAppendedAll with empty suffix', () {
      final l = ILazyList.from(ilist([1, 2])).lazyAppendedAll(() => ilist(<int>[]));
      expect(l.toIList(), ilist([1, 2]));
    });

    test('map on empty', () {
      expect(ILazyList.empty<int>().map((x) => x * 2).toIList(), ilist(<int>[]));
    });

    test('map', () {
      expect(
        ILazyList.from(ilist([1, 2, 3])).map((x) => x * 2).toIList(),
        ilist([2, 4, 6]),
      );
    });

    test('padTo', () {
      expect(
        ILazyList.from(ilist([1, 2])).padTo(5, 0).toIList(),
        ilist([1, 2, 0, 0, 0]),
      );
      expect(
        ILazyList.from(ilist([1, 2, 3])).padTo(2, 0).toIList(),
        ilist([1, 2, 3]),
      );
      expect(ILazyList.from(ilist(<int>[])).padTo(3, 7).toIList(), ilist([7, 7, 7]));
    });

    test('partition', () {
      final (evens, odds) = ILazyList.from(ilist([1, 2, 3, 4, 5])).partition((x) => x.isEven);
      expect(evens.toIList(), ilist([2, 4]));
      expect(odds.toIList(), ilist([1, 3, 5]));
    });

    test('partitionMap', () {
      final (lefts, rights) = ILazyList.from(ilist([1, 2, 3, 4])).partitionMap(
        (x) => x.isEven ? Either.right<String, int>(x * 10) : Either.left<String, int>('odd$x'),
      );
      expect(lefts.toIList(), ilist(['odd1', 'odd3']));
      expect(rights.toIList(), ilist([20, 40]));
    });

    test('patch', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4, 5])).patch(1, ilist([20, 30]), 2).toIList(),
        ilist([1, 20, 30, 4, 5]),
      );
      expect(
        ILazyList.empty<int>().patch(0, ilist([1, 2]), 0).toIList(),
        ilist([1, 2]),
      );
    });

    test('reduceLeft', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).reduceLeft((a, b) => a + b),
        10,
      );
      expect(() => ILazyList.empty<int>().reduceLeft((a, b) => a + b), throwsUnsupportedError);
    });

    test('scan / scanLeft / scanRight', () {
      expect(
        ILazyList.from(ilist([1, 2, 3])).scanLeft(0, (acc, x) => acc + x).toIList(),
        ilist([0, 1, 3, 6]),
      );
      expect(
        ILazyList.empty<int>().scanLeft(0, (acc, x) => acc + x).toIList(),
        ilist([0]),
      );
      expect(
        ILazyList.from(ilist([1, 2, 3])).scan(0, (acc, x) => acc + x).toIList(),
        ilist([0, 1, 3, 6]),
      );
      expect(
        ILazyList.from(ilist([1, 2, 3])).scanRight(0, (x, acc) => x + acc).toIList(),
        ilist([6, 5, 3, 0]),
      );
    });

    test('slice', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4, 5])).slice(1, 4).toIList(),
        ilist([2, 3, 4]),
      );
    });

    test('span', () {
      final (prefix, suffix) = ILazyList.from(ilist([1, 2, 3, 4])).span((x) => x < 3);
      expect(prefix.toIList(), ilist([1, 2]));
      expect(suffix.toIList(), ilist([3, 4]));
    });

    test('splitAt', () {
      final (left, right) = ILazyList.from(ilist([1, 2, 3, 4])).splitAt(2);
      expect(left.toIList(), ilist([1, 2]));
      expect(right.toIList(), ilist([3, 4]));
    });

    test('tails', () {
      final ts = ILazyList.from(ilist([1, 2, 3])).tails.toIList();
      expect(ts.length, 4);
      expect(ts[0].toIList(), ilist([1, 2, 3]));
      expect(ts[1].toIList(), ilist([2, 3]));
      expect(ts[2].toIList(), ilist([3]));
      expect(ts[3].toIList(), ilist(<int>[]));
    });

    test('take on empty', () {
      expect(ILazyList.empty<int>().take(5).toIList(), ilist(<int>[]));
    });

    test('takeRight', () {
      expect(ILazyList.from(ilist([1, 2, 3, 4, 5])).takeRight(3).toIList(), ilist([3, 4, 5]));
      expect(ILazyList.from(ilist([1, 2, 3])).takeRight(0).toIList(), ilist(<int>[]));
      expect(ILazyList.from(ilist([1, 2, 3])).takeRight(10).toIList(), ilist([1, 2, 3]));
      expect(ILazyList.empty<int>().takeRight(2).toIList(), ilist(<int>[]));
    });

    test('takeWhile', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).takeWhile((x) => x < 3).toIList(),
        ilist([1, 2]),
      );
      expect(ILazyList.empty<int>().takeWhile((x) => true).toIList(), ilist(<int>[]));
    });

    test('traverseEither', () {
      final result = ILazyList.from(
        ilist([1, 2, 3]),
      ).traverseEither((x) => Either.right<String, int>(x * 2));
      expect(result.isRight, isTrue);
      expect(result.getOrElse(() => ILazyList.empty()).toIList(), ilist([2, 4, 6]));

      expect(
        ILazyList.from(ilist([1, 2, 3]))
            .traverseEither(
              (x) => x == 2 ? Either.left<String, int>('bad') : Either.right<String, int>(x),
            )
            .isLeft,
        isTrue,
      );
    });

    test('traverseOption', () {
      expect(
        ILazyList.from(ilist([1, 2, 3])).traverseOption((x) => Some(x * 2)).map((l) => l.toIList()),
        Some(ilist([2, 4, 6])),
      );
      expect(
        ILazyList.from(ilist([1, 2, 3])).traverseOption((x) => x == 2 ? none<int>() : Some(x)),
        isA<None>(),
      );
    });

    test('updated out of bounds (beyond end)', () {
      expect(
        () => ILazyList.from(ilist([1, 2, 3])).updated(5, -1).toIList(),
        throwsRangeError,
      );
    });

    test('zip', () {
      expect(
        ILazyList.from(ilist([1, 2, 3])).zip(ilist(['a', 'b', 'c'])).toIList(),
        ilist([(1, 'a'), (2, 'b'), (3, 'c')]),
      );
      expect(ILazyList.empty<int>().zip(ilist([1, 2])).toIList(), ilist(<(int, int)>[]));
      // zip stops at shorter
      expect(
        ILazyList.from(ilist([1, 2])).zip(ilist(['a', 'b', 'c'])).toIList(),
        ilist([(1, 'a'), (2, 'b')]),
      );
    });

    test('zipAll', () {
      // right shorter than left: padding right with thatElem
      expect(
        ILazyList.from(ilist([1, 2, 3])).zipAll(ilist([10, 20]), 0, -1).toIList(),
        ilist([(1, 10), (2, 20), (3, -1)]),
      );
      // left known empty: pad with thisElem
      expect(
        ILazyList.empty<int>().zipAll(ilist([10, 20]), 0, -1).toIList(),
        ilist([(0, 10), (0, 20)]),
      );
    });

    test('zipWithIndex', () {
      expect(
        ILazyList.from(ilist(['a', 'b', 'c'])).zipWithIndex().toIList(),
        ilist([('a', 0), ('b', 1), ('c', 2)]),
      );
    });

    test('groupBy', () {
      final groups = ILazyList.from(ilist([1, 2, 3, 4])).groupBy((x) => x.isEven);
      expect(groups[true].toIList(), ilist([2, 4]));
      expect(groups[false].toIList(), ilist([1, 3]));
    });

    test('toString cycle with prefix', () {
      // Tests the cycle-detection branch that walks the prefix (lines 1015, 1027, 1031)
      late ILazyList<int> cyc;
      cyc = ILazyList.from(ilist([1, 2, 3])).lazyAppendedAll(() => cyc);

      cyc.force();
      final s = cyc.toString();
      expect(s, contains('<cycle>'));
    });

    test('prependedAll', () {
      expect(
        ILazyList.from(ilist([3, 4])).prependedAll(ilist([1, 2])).toIList(),
        ilist([1, 2, 3, 4]),
      );
      expect(
        ILazyList.from(ilist([1, 2])).prependedAll(IList.empty<int>()).toIList(),
        ilist([1, 2]),
      );
      expect(
        ILazyList.empty<int>().prependedAll(ilist([1, 2])).toIList(),
        ilist([1, 2]),
      );
    });

    test('removeAt', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 4])).removeAt(2).toIList(),
        ilist([1, 2, 4]),
      );
      expect(() => ILazyList.from(ilist([1, 2, 3])).removeAt(-1), throwsRangeError);
    });

    test('removeFirst', () {
      expect(
        ILazyList.from(ilist([1, 2, 3, 2])).removeFirst((x) => x == 2).toIList(),
        ilist([1, 3, 2]),
      );
      expect(
        ILazyList.empty<int>().removeFirst((x) => true).toIList(),
        ilist(<int>[]),
      );
    });

    test('length', () {
      expect(ILazyList.from(ilist([1, 2, 3])).length, 3);
      expect(ILazyList.empty<int>().length, 0);
    });

    test('unfold terminates', () {
      // unfold with None on first call produces empty list
      final l = ILazyList.unfold<int, int>(10, (s) => s <= 0 ? none() : Some((s, s - 1)));
      expect(l.toIList(), ilist([10, 9, 8, 7, 6, 5, 4, 3, 2, 1]));
    });
  });
}
