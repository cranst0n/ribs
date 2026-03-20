import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IChain', () {
    test('empty', () {
      expect(IChain.empty<int>().size, 0);
    });

    test('one', () {
      expect(IChain.one(1).size, 1);
    });

    test('take', () {
      expect(ichain([1, 2, 3]).take(2).toList(), [1, 2]);
    });

    test('reverse', () {
      expect(
        ichain([1, 2, 3]).concat(IChain.one(4)).concat(ichain([5, 6, 7])).reverse().toList(),
        [7, 6, 5, 4, 3, 2, 1],
      );
    });

    test('fromSeq empty', () {
      expect(IChain.fromSeq(IList.empty<int>()).isEmpty, isTrue);
    });

    test('fromSeq singleton', () {
      expect(IChain.fromSeq(ilist([42])).toList(), [42]);
    });

    test('fromSeq multi', () {
      expect(IChain.fromSeq(ilist([1, 2, 3])).toList(), [1, 2, 3]);
    });

    test('from IChain returns same instance', () {
      final c = ichain([1, 2, 3]);
      expect(IChain.from(c), same(c));
    });

    test('from RSeq', () {
      expect(IChain.from(ilist([1, 2, 3])).toList(), [1, 2, 3]);
    });

    test('from RIterableOnce (non-seq)', () {
      expect(IChain.from(ilist([1, 2, 3]).iterator).toList(), [1, 2, 3]);
    });

    test('operator [] singleton', () {
      expect(IChain.one(99)[0], 99);
    });

    test('operator [] in append chain', () {
      final c = ichain([1, 2]).concat(ichain([3, 4]));
      expect(c[0], 1);
      expect(c[2], 3);
      expect(c[3], 4);
    });

    test('operator [] out of bounds', () {
      expect(() => ichain([1, 2, 3])[5], throwsRangeError);
      expect(() => IChain.empty<int>()[0], throwsRangeError);
    });

    test('appended', () {
      expect(ichain([1, 2]).appended(3).toList(), [1, 2, 3]);
      expect(IChain.empty<int>().appended(1).toList(), [1]);
    });

    test('appendedAll', () {
      expect(ichain([1, 2]).appendedAll(ilist([3, 4])).toList(), [1, 2, 3, 4]);
      expect(IChain.empty<int>().appendedAll(ilist([1, 2])).toList(), [1, 2]);
    });

    test('collect', () {
      expect(
        ichain([1, 2, 3, 4, 5]).collect((a) => a.isEven ? Some(a * 10) : none<int>()).toList(),
        [20, 40],
      );
      expect(IChain.empty<int>().collect((a) => Some(a)).toList(), <int>[]);
    });

    test('dropWhile', () {
      expect(ichain([1, 2, 3, 4]).dropWhile((x) => x < 3).toList(), [3, 4]);
      expect(ichain([1, 2, 3]).dropWhile((x) => x < 10).toList(), <int>[]);
      expect(ichain([1, 2, 3]).dropWhile((x) => false).toList(), [1, 2, 3]);
      expect(IChain.empty<int>().dropWhile((x) => true).toList(), <int>[]);
    });

    test('filter', () {
      expect(ichain([1, 2, 3, 4, 5]).filter((x) => x.isEven).toList(), [2, 4]);
      expect(IChain.empty<int>().filter((x) => true).toList(), <int>[]);
    });

    test('filterNot', () {
      expect(ichain([1, 2, 3, 4, 5]).filterNot((x) => x.isEven).toList(), [1, 3, 5]);
    });

    test('flatMap', () {
      expect(
        ichain([1, 2, 3]).flatMap((x) => ichain([x, x * 10])).toList(),
        [1, 10, 2, 20, 3, 30],
      );
      expect(IChain.empty<int>().flatMap((x) => ichain([x])).toList(), <int>[]);
    });

    test('foldLeft', () {
      expect(ichain([1, 2, 3, 4]).foldLeft(0, (acc, x) => acc + x), 10);
      expect(IChain.empty<int>().foldLeft(0, (acc, x) => acc + x), 0);
    });

    test('foldRight', () {
      expect(
        ichain([1, 2, 3]).foldRight('', (x, acc) => '$x$acc'),
        '123',
      );
      expect(IChain.empty<int>().foldRight(0, (x, acc) => acc + x), 0);
    });

    test('headOption', () {
      expect(ichain([1, 2, 3]).headOption, const Some(1));
      expect(IChain.empty<int>().headOption, isA<None>());
    });

    test('head', () {
      expect(ichain([1, 2, 3]).head, 1);
      expect(IChain.one(42).head, 42);
    });

    test('isEmpty / nonEmpty', () {
      expect(IChain.empty<int>().isEmpty, isTrue);
      expect(IChain.empty<int>().nonEmpty, isFalse);
      expect(ichain([1]).isEmpty, isFalse);
      expect(ichain([1]).nonEmpty, isTrue);
    });

    test('init', () {
      expect(ichain([1, 2, 3]).init.toList(), [1, 2]);
      expect(IChain.one(1).init.toList(), <int>[]);
      expect(IChain.empty<int>().init.toList(), <int>[]);
    });

    test('initLast singleton', () {
      final result = IChain.one(42).initLast();
      expect(result.isDefined, isTrue);
      expect(result.getOrElse(() => (IChain.empty(), 0)).$2, 42);
    });

    test('initLast append chain', () {
      final c = ichain([1, 2]).concat(ichain([3, 4]));
      final result = c.initLast();
      expect(result.isDefined, isTrue);
      final (init, last) = result.getOrElse(() => (IChain.empty<int>(), 0));
      expect(init.toList(), [1, 2, 3]);
      expect(last, 4);
    });

    test('initLast wrap', () {
      final c = IChain.fromSeq(ilist([1, 2, 3]));
      final result = c.initLast();
      expect(result.isDefined, isTrue);
      final (init, last) = result.getOrElse(() => (IChain.empty<int>(), 0));
      expect(init.toList(), [1, 2]);
      expect(last, 3);
    });

    test('initLast empty', () {
      expect(IChain.empty<int>().initLast(), isA<None>());
    });

    test('knownSize', () {
      expect(IChain.empty<int>().knownSize, 0);
      expect(IChain.one(1).knownSize, 1);
      // Append has unknown size
      expect(IChain.one(1).concat(IChain.one(2)).knownSize, -1);
    });

    test('lastOption', () {
      expect(ichain([1, 2, 3]).lastOption, const Some(3));
      expect(IChain.one(99).lastOption, const Some(99));
      expect(IChain.empty<int>().lastOption, isA<None>());
    });

    test('length / size for complex chains', () {
      // Singleton + Singleton (Append)
      expect(IChain.one(1).concat(IChain.one(2)).length, 2);
      // Wrap inside Append
      final c = ichain([1, 2, 3]).concat(ichain([4, 5]));
      expect(c.length, 5);
      // Nested Appends
      final nested = ichain([1, 2]).concat(ichain([3, 4])).concat(ichain([5]));
      expect(nested.length, 5);
    });

    test('map on Wrap', () {
      expect(IChain.fromSeq(ilist([1, 2, 3])).map((x) => x * 2).toList(), [2, 4, 6]);
    });

    test('map on Singleton and Append', () {
      expect(IChain.one(5).map((x) => x * 2).toList(), [10]);
      expect(
        IChain.one(1).concat(IChain.one(2)).map((x) => x * 10).toList(),
        [10, 20],
      );
    });

    test('prepended', () {
      expect(ichain([2, 3]).prepended(1).toList(), [1, 2, 3]);
      expect(IChain.empty<int>().prepended(1).toList(), [1]);
    });

    test('reverse singleton', () {
      expect(IChain.one(1).reverse().toList(), [1]);
    });

    test('reverse wrap', () {
      expect(IChain.fromSeq(ilist([1, 2, 3])).reverse().toList(), [3, 2, 1]);
    });

    test('reverseIterator singleton', () {
      final it = IChain.one(42).reverseIterator();
      expect(it.hasNext, isTrue);
      expect(it.next(), 42);
      expect(it.hasNext, isFalse);
    });

    test('reverseIterator append chain', () {
      final c = ichain([1, 2]).concat(ichain([3, 4]));
      expect(c.reverseIterator().toList(), [4, 3, 2, 1]);
    });

    test('reverseIterator wrap', () {
      expect(IChain.fromSeq(ilist([1, 2, 3])).reverseIterator().toList(), [3, 2, 1]);
    });

    test('reverseIterator empty', () {
      expect(IChain.empty<int>().reverseIterator().hasNext, isFalse);
    });

    test('tail', () {
      expect(ichain([1, 2, 3]).tail.toList(), [2, 3]);
      expect(IChain.one(1).tail.toList(), <int>[]);
      expect(IChain.empty<int>().tail.toList(), <int>[]);
    });

    test('takeWhile', () {
      expect(ichain([1, 2, 3, 4]).takeWhile((x) => x < 3).toList(), [1, 2]);
      expect(ichain([1, 2, 3]).takeWhile((x) => false).toList(), <int>[]);
      expect(ichain([1, 2, 3]).takeWhile((x) => true).toList(), [1, 2, 3]);
    });

    test('uncons singleton', () {
      final result = IChain.one(42).uncons();
      expect(result.isDefined, isTrue);
      final (hd, tl) = result.getOrElse(() => (0, IChain.empty<int>()));
      expect(hd, 42);
      expect(tl.isEmpty, isTrue);
    });

    test('uncons append chain', () {
      final c = ichain([1, 2]).concat(ichain([3, 4]));
      final result = c.uncons();
      expect(result.isDefined, isTrue);
      final (hd, tl) = result.getOrElse(() => (0, IChain.empty<int>()));
      expect(hd, 1);
      expect(tl.toList(), [2, 3, 4]);
    });

    test('uncons empty', () {
      expect(IChain.empty<int>().uncons(), isA<None>());
    });

    test('equality', () {
      expect(ichain([1, 2, 3]), ichain([1, 2, 3]));
      expect(ichain([1, 2, 3]) == ichain([1, 2, 4]), isFalse);
      expect(ichain([1, 2]) == ichain([1, 2, 3]), isFalse);
      expect(ichain([1, 2, 3]) == ichain([1, 2]), isFalse);
      expect(IChain.empty<int>() == IChain.empty<int>(), isTrue);
    });

    test('equality identical', () {
      final c = ichain([1, 2, 3]);
      expect(c == c, isTrue);
    });

    test('equality non-IChain', () {
      // ignore: unrelated_type_equality_checks
      expect(ichain([1, 2, 3]) == [1, 2, 3], isFalse);
    });

    test('hashCode consistent with equality', () {
      expect(ichain([1, 2, 3]).hashCode, ichain([1, 2, 3]).hashCode);
    });

    test('iterator over append with wrap segments', () {
      // Exercises _ChainRIterator with _Wrap nodes
      final c = IChain.fromSeq(ilist([1, 2])).concat(IChain.fromSeq(ilist([3, 4])));
      expect(c.toList(), [1, 2, 3, 4]);
    });

    test('iterator noSuchElement on _ChainRIterator', () {
      final c = IChain.one(1).concat(IChain.one(2));
      final it = c.iterator;
      it.next();
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('reverseIterator noSuchElement on _ChainReverseRIterator', () {
      final c = IChain.one(1).concat(IChain.one(2));
      final it = c.reverseIterator();
      expect(it.next(), 2);
      expect(it.next(), 1);
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('toIList', () {
      expect(ichain([1, 2, 3]).toIList(), ilist([1, 2, 3]));
    });

    test('forall / exists', () {
      expect(ichain([2, 4, 6]).forall((x) => x.isEven), isTrue);
      expect(ichain([2, 3, 6]).forall((x) => x.isEven), isFalse);
      expect(ichain([1, 3, 4]).exists((x) => x.isEven), isTrue);
      expect(ichain([1, 3, 5]).exists((x) => x.isEven), isFalse);
    });

    test('dropWhile on append chain', () {
      final c = ichain([1, 2]).concat(ichain([3, 4]));
      expect(c.dropWhile((x) => x < 3).toList(), [3, 4]);
    });

    test('large nested append length', () {
      // Tests the while loop in length with multiple _Append nodes on the stack
      var c = IChain.one(0);
      for (var i = 1; i <= 10; i++) {
        c = c.concat(IChain.one(i));
      }
      expect(c.length, 11);
    });

    test('concat empty + non-empty', () {
      expect(IChain.empty<int>().concat(ichain([1, 2])).toList(), [1, 2]);
    });

    test('concat non-empty + empty', () {
      expect(ichain([1, 2]).concat(IChain.empty<int>()).toList(), [1, 2]);
    });
  });
}
