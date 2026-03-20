import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    test('apply', () {
      final r = Range.exclusive(0, 10);

      expect(() => r[-1], throwsRangeError);
      expect(r[0], 0);
      expect(r[9], 9);
      expect(() => r[10], throwsRangeError);
    });

    test('contains', () {
      final r0 = Range.exclusive(0, 10);

      expect(r0.contains(-1), isFalse);
      expect(r0.contains(0), isTrue);
      expect(r0.contains(1), isTrue);
      expect(r0.contains(10), isFalse);

      final r1 = Range.inclusive(0, 10, 2);

      expect(r1.contains(-1), isFalse);
      expect(r1.contains(0), isTrue);
      expect(r1.contains(1), isFalse);
      expect(r1.contains(2), isTrue);
      expect(r1.contains(10), isTrue);
    });

    test('drop', () {
      expect(Range.exclusive(0, 5).drop(3), Range.exclusive(3, 5));
    });

    test('equality', () {
      final r0 = Range.inclusive(1, 10);
      final r1 = Range.inclusive(1, 10);

      expect(r0 == r1, isTrue);
    });

    test('foreach', () {
      var countExclusive = 0;
      var countInclusive = 0;

      Range.exclusive(0, 4).foreach((n) => countExclusive += n);
      Range.inclusive(0, 4).foreach((n) => countInclusive += n);

      expect(countExclusive, 6);
      expect(countInclusive, 10);
    });

    test('take', () {
      expect(Range.exclusive(0, 5).take(3), Range.exclusive(0, 3));
    });

    test('by', () {
      final r = Range.exclusive(0, 10).by(2);
      expect(r.toList(), [0, 2, 4, 6, 8]);
      expect(r.step, 2);
    });

    test('exclusive() conversion', () {
      final incl = Range.inclusive(1, 5);
      final excl = incl.exclusive();
      expect(excl.isInclusive, isFalse);
      expect(excl.toList(), [1, 2, 3, 4]);

      // already exclusive → same instance
      final already = Range.exclusive(1, 5);
      expect(already.exclusive(), same(already));
    });

    test('inclusive() conversion', () {
      final excl = Range.exclusive(1, 5);
      final incl = excl.inclusive();
      expect(incl.isInclusive, isTrue);
      expect(incl.toList(), [1, 2, 3, 4, 5]);

      // already inclusive → same instance
      final already = Range.inclusive(1, 5);
      expect(already.inclusive(), same(already));
    });

    test('contains with negative step', () {
      final r = Range.inclusive(10, 0, -1);
      expect(r.contains(5), isTrue);
      expect(r.contains(11), isFalse);
      expect(r.contains(-1), isFalse);

      final r2 = Range.inclusive(10, 0, -2);
      expect(r2.contains(4), isTrue);
      expect(r2.contains(3), isFalse); // not on step
      expect(r2.contains(0), isTrue);
    });

    test('contains exclusive end', () {
      final r = Range.exclusive(0, 10);
      expect(r.contains(10), isFalse);
    });

    test('dropRight', () {
      expect(Range.exclusive(0, 5).dropRight(0), Range.exclusive(0, 5));
      expect(Range.exclusive(0, 5).dropRight(2), Range.inclusive(0, 2));
      expect(Range.exclusive(0, 5).dropRight(10).isEmpty, isTrue);
      expect(Range.inclusive(0, 6, 2).dropRight(2), Range.inclusive(0, 2, 2));
    });

    test('dropWhile', () {
      expect(Range.exclusive(0, 5).dropWhile((x) => x < 3).toList(), [3, 4]);
      // all pass predicate → empty
      expect(Range.exclusive(0, 5).dropWhile((x) => x < 10).isEmpty, isTrue);
      // none pass → returns this
      final r = Range.exclusive(0, 5);
      expect(r.dropWhile((x) => false), same(r));
      // empty range
      expect(Range.exclusive(5, 5).dropWhile((x) => true).isEmpty, isTrue);
    });

    test('grouped', () {
      final groups = Range.exclusive(0, 6).grouped(2);
      expect(groups.hasNext, isTrue);
      expect(groups.next().toList(), [0, 1]);
      expect(groups.next().toList(), [2, 3]);
      expect(groups.next().toList(), [4, 5]);
      expect(groups.hasNext, isFalse);
    });

    test('head', () {
      expect(Range.exclusive(3, 10).head, 3);
      expect(Range.inclusive(5, 10).head, 5);
      expect(() => Range.exclusive(5, 5).head, throwsRangeError);
    });

    test('indexOf', () {
      final r = Range.exclusive(0, 10, 2);
      expect(r.indexOf(4), const Some(2));
      expect(r.indexOf(3), isA<None>());
      expect(r.indexOf(4, 3), isA<None>()); // from > pos
    });

    test('init', () {
      expect(Range.exclusive(0, 5).init.toList(), [0, 1, 2, 3]);
      expect(() => Range.exclusive(5, 5).init, throwsRangeError);
    });

    test('inits', () {
      final inits = Range.exclusive(0, 3).inits;
      expect(inits.hasNext, isTrue);
      expect(inits.next().toList(), [0, 1, 2]);
      expect(inits.next().toList(), [0, 1]);
      expect(inits.next().toList(), [0]);
      expect(inits.hasNext, isFalse);
    });

    test('last', () {
      expect(Range.exclusive(0, 5).last, 4);
      expect(Range.inclusive(0, 5).last, 5);
      expect(() => Range.exclusive(5, 5).last, throwsRangeError);
    });

    test('lastIndexOf', () {
      final r = Range.exclusive(0, 10, 2);
      expect(r.lastIndexOf(4), const Some(2));
      expect(r.lastIndexOf(3), isA<None>());
      expect(r.lastIndexOf(6, 2), isA<None>()); // end < pos
    });

    test('length', () {
      expect(Range.exclusive(0, 5).length, 5);
      expect(Range.inclusive(0, 5).length, 6);
      expect(Range.exclusive(0, 6, 2).length, 3);
      expect(Range.exclusive(5, 5).length, 0);
    });

    test('map', () {
      expect(Range.exclusive(0, 4).map((x) => x * 2).toList(), [0, 2, 4, 6]);
    });

    test('reverse', () {
      expect(Range.exclusive(0, 5).reverse().toList(), [4, 3, 2, 1, 0]);
      expect(Range.inclusive(1, 4).reverse().toList(), [4, 3, 2, 1]);
      expect(Range.exclusive(5, 5).reverse().isEmpty, isTrue);
    });

    test('sameElements with Range', () {
      // length 0
      expect(
        Range.exclusive(5, 5).sameElements(Range.exclusive(3, 3)),
        isTrue,
      );
      // length 1
      expect(
        Range.exclusive(0, 1).sameElements(Range.inclusive(0, 0)),
        isTrue,
      );
      expect(
        Range.exclusive(0, 1).sameElements(Range.inclusive(1, 1)),
        isFalse,
      );
      // length > 1: same start and step
      expect(
        Range.exclusive(0, 6, 2).sameElements(Range.exclusive(0, 6, 2)),
        isTrue,
      );
      expect(
        Range.exclusive(0, 6, 2).sameElements(Range.exclusive(0, 6, 3)),
        isFalse,
      );
    });

    test('slice', () {
      expect(Range.exclusive(0, 10).slice(2, 6).toList(), [2, 3, 4, 5]);
      expect(Range.exclusive(0, 10).slice(0, 4).toList(), [0, 1, 2, 3]);
      expect(Range.exclusive(0, 10).slice(3, 10).toList(), [3, 4, 5, 6, 7, 8, 9]);
      expect(Range.exclusive(0, 10).slice(5, 5).isEmpty, isTrue);
    });

    test('sorted with Order.ints', () {
      final ascending = Range.exclusive(0, 5);
      expect(ascending.sorted(Order.ints).toList(), [0, 1, 2, 3, 4]);

      final descending = Range.inclusive(5, 0, -1);
      expect(descending.sorted(Order.ints).toList(), [0, 1, 2, 3, 4, 5]);
    });

    test('span', () {
      final (prefix, suffix) = Range.exclusive(0, 5).span((x) => x < 3);
      expect(prefix.toList(), [0, 1, 2]);
      expect(suffix.toList(), [3, 4]);

      // none match → empty prefix
      final (p2, s2) = Range.exclusive(0, 5).span((x) => false);
      expect(p2.isEmpty, isTrue);
      expect(s2.toList(), [0, 1, 2, 3, 4]);

      // all match → empty suffix
      final (p3, s3) = Range.exclusive(0, 5).span((x) => true);
      expect(p3.toList(), [0, 1, 2, 3, 4]);
      expect(s3.isEmpty, isTrue);
    });

    test('splitAt', () {
      final (left, right) = Range.exclusive(0, 5).splitAt(3);
      expect(left.toList(), [0, 1, 2]);
      expect(right.toList(), [3, 4]);
    });

    test('tail', () {
      expect(Range.exclusive(0, 5).tail.toList(), [1, 2, 3, 4]);
      expect(Range.exclusive(0, 1).tail.isEmpty, isTrue);
      expect(Range.inclusive(0, 1).tail.toList(), [1]);
      expect(() => Range.exclusive(5, 5).tail, throwsRangeError);
    });

    test('tails', () {
      final tails = Range.exclusive(0, 3).tails;
      expect(tails.hasNext, isTrue);
      expect(tails.next().toList(), [0, 1, 2]);
      expect(tails.next().toList(), [1, 2]);
      expect(tails.next().toList(), [2]);
      expect(tails.hasNext, isFalse);
    });

    test('takeRight', () {
      expect(Range.exclusive(0, 5).takeRight(3).toList(), [2, 3, 4]);
      expect(Range.exclusive(0, 5).takeRight(0).isEmpty, isTrue);
      expect(Range.exclusive(0, 5).takeRight(10).toList(), [0, 1, 2, 3, 4]);
    });

    test('takeWhile', () {
      expect(Range.exclusive(0, 5).takeWhile((x) => x < 3).toList(), [0, 1, 2]);
      expect(Range.exclusive(0, 5).takeWhile((x) => false).isEmpty, isTrue);
      final r = Range.exclusive(0, 5);
      expect(r.takeWhile((x) => true), same(r));
    });

    test('toString', () {
      expect(Range.exclusive(0, 5).toString(), 'Range 0 until 5');
      expect(Range.inclusive(1, 10).toString(), 'Range 1 to 10');
      expect(Range.exclusive(0, 6, 2).toString(), 'Range 0 until 6 by 2');
      expect(Range.exclusive(5, 5).toString(), contains('empty'));
      // non-exact range (step doesn't divide gap evenly)
      expect(Range.exclusive(0, 7, 2).toString(), contains('inexact'));
    });

    test('equality between empty ranges', () {
      // All empty ranges represent the same empty sequence and must be equal
      // (previously threw RangeError because last was called on empty range)
      expect(Range.exclusive(3, 3) == Range.exclusive(3, 3), isTrue);
      expect(Range.exclusive(3, 3) == Range.exclusive(7, 7), isTrue);
      expect(Range.exclusive(0, 0) == Range.inclusive(5, 3), isTrue);
    });

    test('equality differing ranges', () {
      expect(Range.exclusive(0, 5) == Range.exclusive(0, 6), isFalse);
      expect(Range.exclusive(0, 5) == Range.exclusive(1, 6), isFalse);
      expect(Range.exclusive(0, 6, 2) == Range.exclusive(0, 6, 3), isFalse);
      // non-empty vs empty
      expect(Range.exclusive(0, 5) == Range.exclusive(5, 5), isFalse);
    });

    test('equality non-Range', () {
      // ignore: unrelated_type_equality_checks
      expect(Range.exclusive(0, 5) == 'not a range', isFalse);
    });

    test('hashCode', () {
      expect(
        Range.exclusive(0, 10).hashCode,
        Range.exclusive(0, 10).hashCode,
      );
    });

    test('isEmpty', () {
      expect(Range.exclusive(5, 5).isEmpty, isTrue);
      expect(Range.exclusive(5, 0).isEmpty, isTrue); // start > end, step > 0
      expect(Range.exclusive(0, 5, -1).isEmpty, isTrue); // start < end, step < 0
      expect(Range.exclusive(0, 5).isEmpty, isFalse);
    });

    test('descending range iteration', () {
      expect(Range.inclusive(5, 1, -1).toList(), [5, 4, 3, 2, 1]);
      expect(Range.exclusive(5, 1, -1).toList(), [5, 4, 3, 2]);
    });

    test('_RangeIterator drop', () {
      final it = Range.exclusive(0, 10).iterator.drop(3);
      expect(it.hasNext, isTrue);
      expect(it.next(), 3);
    });

    test('_RangeIterator knownSize', () {
      final it = Range.exclusive(0, 5).iterator;
      expect(it.knownSize, 5);
      it.next();
      expect(it.knownSize, 4);
    });

    test('_RangeIterator next throws when exhausted', () {
      final it = Range.exclusive(0, 1).iterator;
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('_RangeInitsIterator noSuchElement', () {
      final it = Range.exclusive(0, 1).inits;
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('_RangeTailsIterator noSuchElement', () {
      final it = Range.exclusive(0, 1).tails;
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('_RangeGroupedIterator noSuchElement', () {
      final it = Range.exclusive(0, 2).grouped(2);
      it.next();
      expect(() => it.next(), throwsA(isA<Object>()));
    });

    test('elementCount', () {
      expect(Range.elementCount(0, 5, 1), 5);
      expect(Range.elementCount(0, 5, 1, isInclusive: true), 6);
      expect(Range.elementCount(0, 6, 2), 3);
      expect(Range.elementCount(5, 0, -1), 5);
      expect(Range.elementCount(5, 5, 1, isInclusive: true), 1);
      expect(Range.elementCount(5, 5, 1), 0);
      expect(Range.elementCount(0, 5, -1), 0); // wrong direction
      expect(() => Range.elementCount(0, 5, 0), throwsArgumentError);
    });

    test('step == 0 throws', () {
      // _lastElementFn throws when step == 0
      expect(
        () => Range.exclusive(0, 5, 0).toList(),
        throwsArgumentError,
      );
    });

    test('step -1 lastElement', () {
      expect(Range.inclusive(5, 0, -1).last, 0);
      expect(Range.exclusive(5, 0, -1).last, 1);
    });

    test('step > 1 non-exact lastElement', () {
      // 0 until 7 by 2 → elements: 0,2,4,6 (7-0=7, 7%2=1≠0, last = 7-1=6)
      expect(Range.exclusive(0, 7, 2).last, 6);
    });

    test('step > 1 exact inclusive lastElement', () {
      // 0 to 6 by 2 → elements: 0,2,4,6 (6%2==0, inclusive → last=end=6)
      expect(Range.inclusive(0, 6, 2).last, 6);
    });

    test('step > 1 exact exclusive lastElement', () {
      // 0 until 8 by 2 → elements: 0,2,4,6 (8%2==0, exclusive → last=end-step=6)
      expect(Range.exclusive(0, 8, 2).last, 6);
    });

    test('drop n <= 0', () {
      final r = Range.exclusive(0, 5);
      expect(r.drop(0), same(r));
      expect(r.drop(-1), same(r));
    });

    test('drop n >= length', () {
      expect(Range.exclusive(0, 5).drop(5).isEmpty, isTrue);
      expect(Range.exclusive(0, 5).drop(10).isEmpty, isTrue);
    });

    test('take n <= 0 or empty', () {
      expect(Range.exclusive(0, 5).take(0).isEmpty, isTrue);
      expect(Range.exclusive(5, 5).take(3).isEmpty, isTrue);
    });

    test('take n >= length', () {
      final r = Range.exclusive(0, 5);
      expect(r.take(10), same(r));
    });

    test('_RangeIterator drop negative step', () {
      final it = Range.inclusive(10, 0, -1).iterator.drop(3);
      expect(it.next(), 7);
    });
  });
}
