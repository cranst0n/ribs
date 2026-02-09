import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('ILazyList', () {
    test('empty', () {
      expect(ILazyList.empty<int>().isEmpty, isTrue);
    });

    test('equality', () {
      final s = ILazyList.ints(0);

      expect(s == s, isTrue);
      //   expect(
      //     s.prepended(1).prepended(0) == s.prepended(1).prepended(0),
      //     isTrue,
      //   );
    });

    test('does not not force head', () {
      var i = 0;
      int f() => i += 1;

      // ignore: unused_local_variable
      final s = ILazyList.empty<int>().prependedLazy(f).prependedLazy(f);

      expect(i, 0);
    });

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

      expect(l.toString(), 'ILazyList(1, <not computed>)');
    });

    test('toString when head and tail is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.head;
      l.tail();

      expect(l.toString(), 'ILazyList(1, <not computed>)');
    });

    test('toString when head and tail head is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.head;
      l.tail().head;

      expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
    });

    test('toString when head is not evaluated and only tail is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.tail();

      expect(l.toString(), 'ILazyList(1, <not computed>)');
    });

    test('toString when head is not evaluated and tail head is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.tail().head;

      expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
    });

    test('toString when head is not evaluated and tail.tail is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.tail().tail();

      expect(l.toString(), 'ILazyList(1, 2, <not computed>)');
    });

    test('toString when head is not evaluated and tail.tail.head is evaluated', () {
      final l = ILazyList.from(ilist([1, 2, 3, 4, 5]));
      l.tail().tail().head;

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

      cyc =
          ILazyList.from(ilist([1])).appended(2).appended(3).appended(4).lazyAppendedAll(() => cyc);

      final l = cyc;
      expect(l.toString(), 'ILazyList(<not computed>)');

      l.head;
      expect(l.toString(), 'ILazyList(1, <not computed>)');

      l.tail();
      expect(l.toString(), 'ILazyList(1, <not computed>)');

      l.tail().head;
      expect(l.toString(), 'ILazyList(1, 2, <not computed>)');

      l.tail().tail().head;
      expect(l.toString(), 'ILazyList(1, 2, 3, <not computed>)');

      l.tail().tail().tail().head;
      expect(l.toString(), 'ILazyList(1, 2, 3, 4, <not computed>)');

      l.tail().tail().tail().tail().head;
      expect(l.toString(), 'ILazyList(1, 2, 3, 4, <cycle>)');
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

      fibs = ILazyList.from(ilist([0]))
          .appended(1)
          .lazyAppendedAll(() => fibs.zip(fibs.tail()).map((t) => t.$1 + t.$2));

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

      xs.tail();
      expect(seedCounter, 1);
      expect(fCounter, 0);

      xs.tail().head;
      expect(seedCounter, 1);
      expect(fCounter, 1);

      xs.tail().tail();
      expect(seedCounter, 1);
      expect(fCounter, 1);

      xs.tail().tail().head;
      expect(seedCounter, 1);
      expect(fCounter, 2);

      xs.take(10).toList();
      expect(seedCounter, 1);
      expect(fCounter, 9);
    });

    test('updated', () {
      final lazyList = ILazyList.ints(0).take(4);
      final list = lazyList.toIList();

      lazyList
          .indices()
          .foreach((i) => expect(list.updated(i, -1), lazyList.updated(i, -1).toIList()));

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
  });
}
