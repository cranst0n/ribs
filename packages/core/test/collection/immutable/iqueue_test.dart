import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('IQueue', () {
    test('equality', () {
      expect(iqueue([]), iqueue([]));
      expect(iqueue([1, 2, 3]), iqueue([1, 2, 3]));
      expect(iqueue([10, 20, 30]), iqueue([30, 20, 10]).reverse());
    });

    test('basic', () {
      final q0 = iqueue([0, 1, 2, 3]);
      final (a, q1) = q0.dequeue();
      final (b, q2) = q1.dequeue();
      final (c, q3) = q2.dequeue();
      final (d, q4) = q3.dequeue();

      expect((a, b, c, d), (0, 1, 2, 3));

      expect(q1[2], 3);

      expect(q0.front, 0);
      expect(q1.front, 1);
      expect(q2.front, 2);
      expect(q3.front, 3);
      expect(() => q4.front, throwsRangeError);

      expect(q0.last, 3);
      expect(q1.last, 3);
      expect(q2.last, 3);
      expect(q3.last, 3);
      expect(() => q4.last, throwsRangeError);

      expect(q0.reverse().toIList(), ilist([3, 2, 1, 0]));

      expect(q4.dequeueOption(), isNone());
      expect(q4.enqueue(42).dequeue(), (42, IQueue.empty<int>()));

      expect(
        q0.enqueueAll(ilist([4, 5, 6, 7])).toIList(),
        ilist([0, 1, 2, 3, 4, 5, 6, 7]),
      );

      expect(q0.prepended(42).dequeue(), (42, q0));
    });

    test('from returns same instance for IQueue', () {
      final q = iqueue([1, 2, 3]);
      expect(identical(IQueue.from(q), q), isTrue);
    });

    test('from wraps non-IQueue', () {
      final q = IQueue.from(ilist([1, 2, 3]));
      expect(q.toIList(), ilist([1, 2, 3]));
    });

    test('dequeue from _in-only queue (reversal path)', () {
      // enqueue builds into _in; dequeue with empty _out triggers reversal
      final q = IQueue.empty<int>().enqueue(1).enqueue(2).enqueue(3);
      final (a, q1) = q.dequeue();
      final (b, q2) = q1.dequeue();
      final (c, q3) = q2.dequeue();
      expect((a, b, c), (1, 2, 3));
      expect(q3.isEmpty, isTrue);
    });

    test('head when _out empty but _in non-empty', () {
      final q = IQueue.empty<int>().enqueue(10).enqueue(20);
      expect(q.head, 10);
    });

    test('last when _in empty but _out non-empty', () {
      final q = iqueue([1, 2, 3]);
      // iqueue puts elements into _out; _in is nil
      expect(q.last, 3);
    });

    test('tail when _out is empty', () {
      final q = IQueue.empty<int>().enqueue(1).enqueue(2).enqueue(3);
      expect(q.tail.toIList(), ilist([2, 3]));
    });

    test('tail on empty throws', () {
      expect(() => IQueue.empty<int>().tail, throwsRangeError);
    });

    test('operator [] indexes into _in portion', () {
      // iqueue([0,1,2]) puts [0,1,2] in _out; enqueue(3) prepends to _in
      final q = iqueue([0, 1, 2]).enqueue(3);
      expect(q[0], 0);
      expect(q[1], 1);
      expect(q[2], 2);
      expect(q[3], 3);
    });

    test('operator [] out of range throws', () {
      expect(() => iqueue([1, 2, 3])[5], throwsRangeError);
      expect(() => IQueue.empty<int>()[0], throwsRangeError);
    });

    test('appendedAll with IQueue suffix', () {
      final q1 = iqueue([1, 2, 3]);
      final q2 = iqueue([4, 5, 6]);
      expect(q1.appendedAll(q2).toIList(), ilist([1, 2, 3, 4, 5, 6]));
    });

    test('appendedAll with non-IQueue suffix', () {
      final q = iqueue([1, 2, 3]);
      expect(q.appendedAll(ilist([4, 5, 6])).toIList(), ilist([1, 2, 3, 4, 5, 6]));
    });

    test('appendedAll with empty suffix returns same', () {
      final q = iqueue([1, 2, 3]);
      expect(q.appendedAll(ilist([])), q);
    });

    test('concat', () {
      expect(iqueue([1, 2]).concat(iqueue([3, 4])).toIList(), ilist([1, 2, 3, 4]));
    });

    test('prependedAll', () {
      final q = iqueue([3, 4, 5]);
      expect(q.prependedAll(ilist([1, 2])).toIList(), ilist([1, 2, 3, 4, 5]));
    });

    test('drop', () {
      expect(iqueue([1, 2, 3, 4, 5]).drop(2).toIList(), ilist([3, 4, 5]));
      expect(iqueue([1, 2]).drop(5).toIList(), ilist([]));
    });

    test('dropRight', () {
      expect(iqueue([1, 2, 3, 4, 5]).dropRight(2).toIList(), ilist([1, 2, 3]));
      expect(iqueue([1, 2]).dropRight(5).toIList(), ilist([]));
    });

    test('dropWhile', () {
      expect(
        iqueue([1, 2, 3, 4, 5]).dropWhile((x) => x < 3).toIList(),
        ilist([3, 4, 5]),
      );
    });

    test('take', () {
      expect(iqueue([1, 2, 3, 4, 5]).take(3).toIList(), ilist([1, 2, 3]));
      expect(iqueue([1, 2]).take(10).toIList(), ilist([1, 2]));
    });

    test('takeRight', () {
      expect(iqueue([1, 2, 3, 4, 5]).takeRight(2).toIList(), ilist([4, 5]));
      expect(iqueue([1, 2]).takeRight(0).toIList(), ilist([]));
    });

    test('takeWhile', () {
      expect(
        iqueue([1, 2, 3, 4, 5]).takeWhile((x) => x < 4).toIList(),
        ilist([1, 2, 3]),
      );
    });

    test('filter / filterNot', () {
      final q = iqueue([1, 2, 3, 4, 5]);
      expect(q.filter((x) => x.isEven).toIList(), ilist([2, 4]));
      expect(q.filterNot((x) => x.isEven).toIList(), ilist([1, 3, 5]));
    });

    test('exists / forall', () {
      final q = iqueue([1, 2, 3]);
      expect(q.exists((x) => x == 2), isTrue);
      expect(q.exists((x) => x > 10), isFalse);
      expect(q.forall((x) => x > 0), isTrue);
      expect(q.forall((x) => x.isEven), isFalse);
    });

    test('map', () {
      expect(iqueue([1, 2, 3]).map((x) => x * 2).toIList(), ilist([2, 4, 6]));
    });

    test('flatMap', () {
      expect(
        iqueue([1, 2, 3]).flatMap((x) => iqueue([x, x * 10])).toIList(),
        ilist([3, 30, 2, 20, 1, 10]),
      );
    });

    test('tapEach', () {
      final seen = <int>[];
      final result = iqueue([1, 2, 3]).tapEach(seen.add);
      expect(seen, [1, 2, 3]);
      expect(identical(result, iqueue([1, 2, 3])) || result == iqueue([1, 2, 3]), isTrue);
    });

    test('partition', () {
      final (evens, odds) = iqueue([1, 2, 3, 4, 5]).partition((x) => x.isEven);
      expect(evens.toIList(), ilist([2, 4]));
      expect(odds.toIList(), ilist([1, 3, 5]));
    });

    test('partitionMap', () {
      final (lefts, rights) = iqueue([1, 2, 3, 4]).partitionMap(
        (x) => x.isEven ? Either.right<String, int>(x) : Either.left<String, int>('odd'),
      );
      expect(lefts.toIList(), ilist(['odd', 'odd']));
      expect(rights.toIList(), ilist([2, 4]));
    });

    test('span', () {
      final (prefix, suffix) = iqueue([1, 2, 3, 4, 5]).span((x) => x < 3);
      expect(prefix.toIList(), ilist([1, 2]));
      expect(suffix.toIList(), ilist([3, 4, 5]));
    });

    test('splitAt', () {
      final (a, b) = iqueue([1, 2, 3, 4, 5]).splitAt(3);
      expect(a.toIList(), ilist([1, 2, 3]));
      expect(b.toIList(), ilist([4, 5]));
    });

    test('scanLeft', () {
      expect(
        iqueue([1, 2, 3]).scanLeft(0, (acc, x) => acc + x).toIList(),
        ilist([0, 1, 3, 6]),
      );
    });

    test('scanRight', () {
      expect(
        iqueue([1, 2, 3]).scanRight(0, (x, acc) => x + acc).toIList(),
        ilist([6, 5, 3, 0]),
      );
    });

    test('scan', () {
      expect(
        iqueue([1, 2, 3]).scan(0, (acc, x) => acc + x).toIList(),
        ilist([0, 1, 3, 6]),
      );
    });

    test('sorted', () {
      expect(
        iqueue([3, 1, 4, 1, 5]).sorted(Order.ints).toIList(),
        ilist([1, 1, 3, 4, 5]),
      );
    });

    test('sortBy', () {
      expect(
        iqueue(['banana', 'apple', 'cherry']).sortBy(Order.strings, (s) => s).toIList(),
        ilist(['apple', 'banana', 'cherry']),
      );
    });

    test('sortWith', () {
      expect(
        iqueue([3, 1, 2]).sortWith((a, b) => a < b).toIList(),
        ilist([1, 2, 3]),
      );
    });

    test('intersect', () {
      expect(
        iqueue([1, 2, 3, 2]).intersect(iqueue([2, 2, 4])).toIList(),
        ilist([2, 2]),
      );
    });

    test('intersperse', () {
      expect(iqueue([1, 2, 3]).intersperse(0).toIList().length, greaterThan(0));
    });

    test('padTo', () {
      expect(iqueue([1, 2]).padTo(5, 0).toIList(), ilist([1, 2, 0, 0, 0]));
      expect(iqueue([1, 2, 3]).padTo(2, 0).toIList(), ilist([1, 2, 3]));
    });

    test('patch', () {
      expect(
        iqueue([1, 2, 3, 4, 5]).patch(1, iqueue([20, 30]), 2).toIList(),
        ilist([1, 20, 30, 4, 5]),
      );
    });

    test('removeAt', () {
      expect(iqueue([1, 2, 3, 4]).removeAt(2).toIList(), ilist([1, 2, 4]));
    });

    test('removeFirst', () {
      expect(
        iqueue([1, 2, 3, 2, 1]).removeFirst((x) => x == 2).toIList(),
        ilist([1, 3, 2, 1]),
      );
    });

    test('updated', () {
      expect(iqueue([1, 2, 3]).updated(1, 99).toIList(), ilist([1, 99, 3]));
    });

    test('init', () {
      expect(iqueue([1, 2, 3]).init.toIList(), ilist([1, 2]));
    });

    test('inits', () {
      final inits = iqueue([1, 2, 3]).inits;
      expect(inits.next().toIList(), ilist([1, 2, 3]));
      expect(inits.next().toIList(), ilist([1, 2]));
      expect(inits.next().toIList(), ilist([1]));
      expect(inits.next().toIList(), ilist([]));
      expect(inits.hasNext, isFalse);
    });

    test('zip', () {
      expect(
        iqueue([1, 2, 3]).zip(iqueue(['a', 'b', 'c'])).toIList(),
        ilist([(1, 'a'), (2, 'b'), (3, 'c')]),
      );
    });

    test('zipAll', () {
      expect(
        iqueue([1, 2, 3]).zipAll(iqueue([10, 20]), 0, 99).toIList(),
        ilist([(1, 10), (2, 20), (3, 99)]),
      );
    });

    test('zipWithIndex', () {
      expect(
        iqueue(['a', 'b', 'c']).zipWithIndex().toIList(),
        ilist([('a', 0), ('b', 1), ('c', 2)]),
      );
    });

    test('length / isEmpty / nonEmpty', () {
      expect(IQueue.empty<int>().length, 0);
      expect(IQueue.empty<int>().isEmpty, isTrue);
      expect(IQueue.empty<int>().nonEmpty, isFalse);
      expect(iqueue([1, 2, 3]).length, 3);
      expect(iqueue([1, 2, 3]).isEmpty, isFalse);
      expect(iqueue([1, 2, 3]).nonEmpty, isTrue);
    });

    test('hashCode consistent with equality', () {
      expect(iqueue([1, 2, 3]).hashCode, iqueue([1, 2, 3]).hashCode);
    });

    test('equality with non-IQueue returns false', () {
      expect((iqueue([1, 2, 3]) as Object) == ilist([1, 2, 3]), isFalse);
    });
  });
}
