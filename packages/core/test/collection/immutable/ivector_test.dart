import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IVector', () {
    // 0, 2^5, 2^10, 2^15, 2^20
    final vectorNBounds = [0, 32, 1024, 32768, 1048576].expand((n) => [n, n + 1]);

    test('fill / toList', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).toList().length, n);
      }
    });

    test('length', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).length, n);
      }
    });

    test('map', () {
      for (final n in vectorNBounds) {
        final l = IVector.tabulate(n, (x) => x).map((a) => a + 1).toList();

        expect(l.length, n);
        if (l.isNotEmpty) {
          expect(l.last, n);
        }
      }
    });

    test('appended', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).appended(1).toList().last, 1);
      }
    });

    test('appendedAll', () {
      for (final n in vectorNBounds) {
        final addN = max(n ~/ 2, 1);
        expect(IVector.fill(n, 0).appendedAll(IVector.fill(addN, 0)).toList().length, n + addN);
      }
    });

    test('appendedAll (random)', () {
      for (final n in vectorNBounds) {
        final addN = Random.secure().nextInt(max(n, 1));
        expect(IVector.fill(n, 0).appendedAll(IVector.fill(addN, 0)).toList().length, n + addN);
      }
    });

    test('drop', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).drop(1).toList().first, 1);
        } else {
          expect(IVector.tabulate(n, identity).drop(1).toList(), isEmpty);
        }
      }
    });

    test('dropRight', () {
      for (final n in vectorNBounds) {
        if (n > 2) {
          expect(IVector.tabulate(n, identity).dropRight(2).toList().last, n - 3);
        } else {
          expect(IVector.tabulate(n, identity).dropRight(2).toList(), isEmpty);
        }
      }
    });

    test('init', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).init.toList().last, n - 2);
        } else {
          expect(IVector.tabulate(n, identity).init.toList(), isEmpty);
        }
      }
    });

    test('prepended', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).prepended(1).toList().first, 1);
      }
    });

    test('slice', () {
      for (final n in vectorNBounds) {
        final until = max(0, n - 1);
        expect(
          IVector.tabulate(n + 1, identity).slice(0, until).toList().length,
          until,
        );
      }
    });

    test('tail', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).tail.toList().first, 1);
        } else {
          expect(IVector.tabulate(n, identity).tail.toList(), isEmpty);
        }
      }
    });

    test('take', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).take(n ~/ 2).toList().length, min(n, n ~/ 2));
      }
    });

    test('takeRight', () {
      for (final n in vectorNBounds) {
        if (n >= 5) {
          expect(
            IVector.tabulate(n, identity).takeRight(5).toList(),
            [n - 5, n - 4, n - 3, n - 2, n - 1],
          );
        } else {
          expect(IVector.tabulate(n, identity).takeRight(3).length, min(3, n));
        }
      }
    });

    test('unzip', () {
      final v = IVector.tabulate(5, (x) => (x, x + 1));

      final (x, y) = v.unzip();

      expect(x.toList(), [0, 1, 2, 3, 4]);
      expect(y.toList(), [1, 2, 3, 4, 5]);
    });

    test('map/take/takeRight chaining', () {
      final v0 = IVector.tabulate(5, (a) => a);
      final v1 = v0.map((a) => a + 1).take(4).takeRight(3).toList();

      expect(v1, [2, 3, 4]);
    });

    test('operator [] at boundary positions', () {
      for (final n in vectorNBounds) {
        if (n == 0) continue;
        final v = IVector.tabulate(n, (i) => i);
        expect(v[0], 0);
        expect(v[n - 1], n - 1);
        if (n > 1) expect(v[n ~/ 2], n ~/ 2);
        expect(() => v[-1], throwsRangeError);
        expect(() => v[n], throwsRangeError);
      }
    });

    test('operator [] on empty (Vector0) throws', () {
      expect(() => IVector.empty<int>()[0], throwsRangeError);
    });

    test('updated across sizes', () {
      for (final n in vectorNBounds) {
        if (n == 0) continue;
        final v = IVector.tabulate(n, (i) => i);
        final v2 = v.updated(0, -1);
        expect(v2[0], -1);
        if (n > 1) expect(v2[1], 1); // element 1 unchanged
        final v3 = v.updated(n - 1, -99);
        expect(v3[n - 1], -99);
        if (n > 1) expect(v3[0], 0); // element 0 unchanged
        expect(() => v.updated(-1, 0), throwsRangeError);
        expect(() => v.updated(n, 0), throwsRangeError);
      }
    });

    test('updated on empty (Vector0) throws', () {
      expect(() => IVector.empty<int>().updated(0, 1), throwsRangeError);
    });

    test('builder', () {
      final b = IVector.builder<int>();
      b.addOne(1);
      b.addOne(2);
      b.addOne(3);
      expect(b.result().toList(), [1, 2, 3]);
    });

    test('builder addAll', () {
      final b =
          IVector.builder<int>()
            ..addAll(ivec([1, 2, 3]))
            ..addAll(ivec([4, 5]));
      expect(b.result().toList(), [1, 2, 3, 4, 5]);
    });

    test('builder clear', () {
      final b =
          IVector.builder<int>()
            ..addOne(1)
            ..addOne(2);
      b.clear();
      b.addOne(9);
      expect(b.result().toList(), [9]);
    });

    test('builder knownSize / isEmpty / nonEmpty', () {
      final b = IVector.builder<int>();
      expect(b.knownSize(), 0);
      expect(b.isEmpty, isTrue);
      expect(b.nonEmpty, isFalse);
      b.addOne(1);
      expect(b.knownSize(), 1);
      expect(b.isEmpty, isFalse);
      expect(b.nonEmpty, isTrue);
    });

    test('fill2', () {
      final v = IVector.fill2(3, 2, 0);
      expect(v.length, 3);
      expect(v[0].toList(), [0, 0]);
    });

    test('fill3', () {
      final v = IVector.fill3(2, 3, 4, 0);
      expect(v.length, 2);
      expect(v[0].length, 3);
      expect(v[0][0].length, 4);
    });

    test('tabulate2', () {
      final v = IVector.tabulate2(3, 4, (i, j) => i * 10 + j);
      expect(v.length, 3);
      expect(v[0].toList(), [0, 1, 2, 3]);
      expect(v[1].toList(), [10, 11, 12, 13]);
    });

    test('tabulate3', () {
      final v = IVector.tabulate3(2, 3, 2, (i, j, k) => i * 100 + j * 10 + k);
      expect(v.length, 2);
      expect(v[0].length, 3);
      expect(v[0][0].toList(), [0, 1]);
    });

    test('from IVector returns same instance', () {
      final v = ivec([1, 2, 3]);
      expect(IVector.from(v), same(v));
    });

    test('fromDart', () {
      expect(IVector.fromDart([1, 2, 3]).toList(), [1, 2, 3]);
    });

    test('knownSize equals length', () {
      for (final n in vectorNBounds) {
        final v = IVector.fill(n, 0);
        expect(v.knownSize, n);
      }
    });

    test('concat', () {
      expect(ivec([1, 2]).concat(ivec([3, 4])).toList(), [1, 2, 3, 4]);
      expect(ivec([1, 2]).concat(IVector.empty<int>()).toList(), [1, 2]);
    });

    test('appendedAll with unknown knownSize (RIterator)', () {
      // RIterator has knownSize -1
      final suffix = ivec([3, 4]).iterator;
      expect(ivec([1, 2]).appendedAll(suffix).toList(), [1, 2, 3, 4]);
    });

    test('prependedAll with unknown knownSize', () {
      final prefix = ivec([1, 2]).iterator;
      expect(ivec([3, 4]).prependedAll(prefix).toList(), [1, 2, 3, 4]);
    });

    test('collect', () {
      expect(
        ivec([1, 2, 3, 4, 5]).collect((a) => a.isEven ? Some(a * 10) : none<int>()).toList(),
        [20, 40],
      );
    });

    test('diff', () {
      expect(ivec([1, 2, 3, 2, 1]).diff(ilist([1, 2])).toList(), [3, 2, 1]);
    });

    test('distinct / distinctBy', () {
      expect(ivec([1, 2, 1, 3, 2]).distinct().toList(), [1, 2, 3]);
      expect(ivec([1, 2, 3, 4]).distinctBy((x) => x % 2).toList(), [1, 2]);
    });

    test('dropWhile', () {
      expect(ivec([1, 2, 3, 4]).dropWhile((x) => x < 3).toList(), [3, 4]);
    });

    test('filter / filterNot', () {
      expect(ivec([1, 2, 3, 4, 5]).filter((x) => x.isEven).toList(), [2, 4]);
      expect(ivec([1, 2, 3, 4, 5]).filterNot((x) => x.isEven).toList(), [1, 3, 5]);
    });

    test('flatMap', () {
      expect(
        ivec([1, 2, 3]).flatMap((x) => ivec([x, x * 10])).toList(),
        [1, 10, 2, 20, 3, 30],
      );
    });

    test('groupBy', () {
      final groups = ivec([1, 2, 3, 4]).groupBy((x) => x.isEven);
      expect(groups[true].toList(), [2, 4]);
      expect(groups[false].toList(), [1, 3]);
    });

    test('grouped', () {
      final groups = ivec([1, 2, 3, 4, 5]).grouped(2);
      expect(groups.next().toList(), [1, 2]);
      expect(groups.next().toList(), [3, 4]);
      expect(groups.next().toList(), [5]);
      expect(groups.hasNext, isFalse);
    });

    test('groupMap', () {
      final m = ivec([1, 2, 3, 4]).groupMap((x) => x.isEven, (x) => x * 10);
      expect(m[true].toList(), [20, 40]);
      expect(m[false].toList(), [10, 30]);
    });

    test('inits', () {
      final inits = ivec([1, 2, 3]).inits;
      expect(inits.next().toList(), [1, 2, 3]);
      expect(inits.next().toList(), [1, 2]);
      expect(inits.next().toList(), [1]);
      expect(inits.next().toList(), <int>[]);
      expect(inits.hasNext, isFalse);
    });

    test('intersect', () {
      expect(ivec([1, 2, 3, 2]).intersect(ilist([2, 3])).toList(), [2, 3]);
    });

    test('intersperse', () {
      expect(ivec([1, 2, 3]).intersperse(0).toList(), [1, 0, 2, 0, 3]);
    });

    test('padTo', () {
      expect(ivec([1, 2]).padTo(5, 0).toList(), [1, 2, 0, 0, 0]);
      expect(ivec([1, 2, 3]).padTo(2, 0).toList(), [1, 2, 3]);
    });

    test('partition', () {
      final (evens, odds) = ivec([1, 2, 3, 4, 5]).partition((x) => x.isEven);
      expect(evens.toList(), [2, 4]);
      expect(odds.toList(), [1, 3, 5]);
    });

    test('partitionMap', () {
      final (lefts, rights) = ivec([1, 2, 3, 4]).partitionMap(
        (x) => x.isEven ? Either.right<String, int>(x * 10) : Either.left<String, int>('odd$x'),
      );
      expect(lefts.toList(), ['odd1', 'odd3']);
      expect(rights.toList(), [20, 40]);
    });

    test('patch', () {
      expect(ivec([1, 2, 3, 4]).patch(1, ivec([20, 30]), 2).toList(), [1, 20, 30, 4]);
    });

    test('removeAt', () {
      expect(ivec([1, 2, 3, 4]).removeAt(2).toList(), [1, 2, 4]);
    });

    test('removeFirst', () {
      expect(ivec([1, 2, 3, 2]).removeFirst((x) => x == 2).toList(), [1, 3, 2]);
    });

    test('reverse', () {
      for (final n in vectorNBounds) {
        if (n == 0) continue;
        final v = IVector.tabulate(n, (i) => i);
        expect(v.reverse()[0], n - 1);
        expect(v.reverse()[n - 1], 0);
      }
    });

    test('scan / scanLeft / scanRight', () {
      expect(ivec([1, 2, 3]).scan(0, (acc, x) => acc + x).toList(), [0, 1, 3, 6]);
      expect(ivec([1, 2, 3]).scanLeft(0, (acc, x) => acc + x).toList(), [0, 1, 3, 6]);
      expect(ivec([1, 2, 3]).scanRight(0, (x, acc) => x + acc).toList(), [6, 5, 3, 0]);
    });

    test('sliding', () {
      final slides = ivec([1, 2, 3, 4]).sliding(2, 1);
      expect(slides.next().toList(), [1, 2]);
      expect(slides.next().toList(), [2, 3]);
      expect(slides.next().toList(), [3, 4]);
    });

    test('sorted / sortBy / sortWith', () {
      expect(ivec([3, 1, 4, 1, 5]).sorted(Order.ints).toList(), [1, 1, 3, 4, 5]);
      expect(
        ivec(['banana', 'apple', 'cherry']).sortBy(Order.ints, (s) => s.length).toList(),
        ['apple', 'banana', 'cherry'],
      );
      expect(
        ivec([3, 1, 2]).sortWith((a, b) => a < b).toList(),
        [1, 2, 3],
      );
    });

    test('span', () {
      final (prefix, suffix) = ivec([1, 2, 3, 4]).span((x) => x < 3);
      expect(prefix.toList(), [1, 2]);
      expect(suffix.toList(), [3, 4]);
    });

    test('splitAt', () {
      final (left, right) = ivec([1, 2, 3, 4]).splitAt(2);
      expect(left.toList(), [1, 2]);
      expect(right.toList(), [3, 4]);
    });

    test('tails', () {
      final tails = ivec([1, 2, 3]).tails;
      expect(tails.next().toList(), [1, 2, 3]);
      expect(tails.next().toList(), [2, 3]);
      expect(tails.next().toList(), [3]);
      expect(tails.next().toList(), <int>[]);
      expect(tails.hasNext, isFalse);
    });

    test('takeWhile', () {
      expect(ivec([1, 2, 3, 4]).takeWhile((x) => x < 3).toList(), [1, 2]);
    });

    test('traverseEither', () {
      final result = ivec([1, 2, 3]).traverseEither((x) => Either.right<String, int>(x * 2));
      expect(result.isRight, isTrue);
      expect(result.getOrElse(() => IVector.empty()).toList(), [2, 4, 6]);

      expect(
        ivec([1, 2, 3])
            .traverseEither(
              (x) => x == 2 ? Either.left<String, int>('bad') : Either.right<String, int>(x),
            )
            .isLeft,
        isTrue,
      );
    });

    test('traverseOption', () {
      final result = ivec([1, 2, 3]).traverseOption((x) => Some(x * 2));
      expect(result.isDefined, isTrue);
      expect(result.getOrElse(() => IVector.empty()).toList(), [2, 4, 6]);

      expect(
        ivec([1, 2, 3]).traverseOption((x) => x == 2 ? none<int>() : Some(x)),
        isA<None>(),
      );
    });

    test('toString', () {
      expect(ivec([1, 2, 3]).toString(), 'IVector(1, 2, 3)');
      expect(IVector.empty<int>().toString(), 'IVector()');
    });

    test('equality', () {
      expect(ivec([1, 2, 3]) == ivec([1, 2, 3]), isTrue);
      expect(ivec([1, 2, 3]) == ivec([1, 2, 4]), isFalse);
      expect(ivec([1, 2]) == ivec([1, 2, 3]), isFalse);
    });

    test('hashCode consistent', () {
      expect(ivec([1, 2, 3]).hashCode, ivec([1, 2, 3]).hashCode);
    });

    test('zip / zipAll / zipWithIndex', () {
      expect(
        ivec([1, 2, 3]).zip(ivec(['a', 'b', 'c'])).toList(),
        [(1, 'a'), (2, 'b'), (3, 'c')],
      );
      expect(
        ivec([1, 2]).zipAll(ivec([10, 20, 30]), 0, -1).toList(),
        [(1, 10), (2, 20), (0, 30)],
      );
      expect(
        ivec(['a', 'b', 'c']).zipWithIndex().toList(),
        [('a', 0), ('b', 1), ('c', 2)],
      );
    });

    test('Vector2 operator[] covers all segments', () {
      // n=100 fits in Vector2; prefix1 is first chunk, data2 is middle, suffix1 is last
      final v = IVector.tabulate(100, (i) => i);
      expect(v[0], 0); // prefix1
      expect(v[31], 31); // last of prefix1
      expect(v[32], 32); // first of data2
      expect(v[63], 63); // inside data2
      expect(v[96], 96); // suffix1 area
      expect(v[99], 99); // last element
    });

    test('Vector2 updated covers all segments', () {
      final v = IVector.tabulate(100, (i) => i);
      expect(v.updated(0, -1)[0], -1); // prefix1
      expect(v.updated(50, -1)[50], -1); // data2
      expect(v.updated(99, -1)[99], -1); // suffix1
    });

    test('Vector3 operator[] covers all segments', () {
      final v = IVector.tabulate(2000, (i) => i);
      expect(v[0], 0);
      expect(v[500], 500);
      expect(v[1999], 1999);
    });

    test('Vector3 updated', () {
      final v = IVector.tabulate(2000, (i) => i);
      expect(v.updated(0, -1)[0], -1);
      expect(v.updated(1000, -1)[1000], -1);
      expect(v.updated(1999, -1)[1999], -1);
    });

    test('Vector4 operator[] covers all segments', () {
      final v = IVector.tabulate(50000, (i) => i);
      expect(v[0], 0);
      expect(v[10000], 10000);
      expect(v[49999], 49999);
    });

    test('Vector4 updated', () {
      final v = IVector.tabulate(50000, (i) => i);
      expect(v.updated(0, -1)[0], -1);
      expect(v.updated(25000, -1)[25000], -1);
      expect(v.updated(49999, -1)[49999], -1);
    });

    test('Vector5 operator[] covers all segments', () {
      final v = IVector.tabulate(1100000, (i) => i);
      expect(v[0], 0);
      expect(v[500000], 500000);
      expect(v[1099999], 1099999);
    });

    test('Vector5 updated', () {
      final v = IVector.tabulate(1100000, (i) => i);
      expect(v.updated(0, -1)[0], -1);
      expect(v.updated(500000, -1)[500000], -1);
      expect(v.updated(1099999, -1)[1099999], -1);
    });

    test('Vector6 operator[]', () {
      final v = IVector.tabulate(33554433, (i) => i);
      expect(v[0], 0);
      expect(v[16777216], 16777216);
      expect(v[33554432], 33554432);
    });

    test('Vector6 updated', () {
      final v = IVector.tabulate(33554433, (i) => i);
      expect(v.updated(0, -1)[0], -1);
      expect(v.updated(33554432, -1)[33554432], -1);
    });

    test('prepended across sizes forces prefix growth', () {
      // Build a large vector by prepending to exercise deep prepend paths
      var v = IVector.empty<int>();
      for (var i = 99; i >= 0; i--) {
        v = v.prepended(i);
      }
      expect(v.length, 100);
      expect(v[0], 0);
      expect(v[99], 99);
    });

    test('combinations', () {
      final combos = ivec([1, 2, 3]).combinations(2);
      final result = combos.toList().map((v) => v.toList()).toList();
      expect(result, [
        [1, 2],
        [1, 3],
        [2, 3],
      ]);
    });

    test('permutations', () {
      final perms = ivec([1, 2, 3]).permutations();
      expect(perms.toList().length, 6);
    });

    test('tapEach', () {
      final seen = <int>[];
      final v = ivec([1, 2, 3]).tapEach(seen.add);
      expect(seen, [1, 2, 3]);
      expect(v.toList(), [1, 2, 3]); // returns this
    });

    test('fill4', () {
      final v = IVector.fill4(2, 3, 4, 5, 0);
      expect(v.length, 2);
      expect(v[0].length, 3);
      expect(v[0][0].length, 4);
      expect(v[0][0][0].length, 5);
      expect(v[0][0][0][0], 0);
    });

    test('fill5', () {
      final v = IVector.fill5(2, 2, 2, 2, 3, 0);
      expect(v.length, 2);
      expect(v[0].length, 2);
      expect(v[0][0].length, 2);
      expect(v[0][0][0].length, 2);
      expect(v[0][0][0][0].length, 3);
      expect(v[0][0][0][0][0], 0);
    });

    test('tabulate4', () {
      final v = IVector.tabulate4(2, 3, 4, 2, (i, j, k, l) => i * 1000 + j * 100 + k * 10 + l);
      expect(v.length, 2);
      expect(v[0].length, 3);
      expect(v[0][0].length, 4);
      expect(v[0][0][0].toList(), [0, 1]);
      expect(v[1][2][3].toList(), [1230, 1231]);
    });

    test('tabulate5', () {
      final v = IVector.tabulate5(2, 2, 2, 2, 2, (i, j, k, l, m) => i + j + k + l + m);
      expect(v.length, 2);
      expect(v[0][0][0][0].toList(), [0, 1]);
      expect(v[1][1][1][1].toList(), [4, 5]);
    });

    test('Vector1 init of single-element vector is empty', () {
      final v = ivec([42]);
      expect(v.init.isEmpty, isTrue);
      expect(v.init.length, 0);
    });

    test('Vector1 tail of single-element vector is empty', () {
      final v = ivec([42]);
      expect(v.tail.isEmpty, isTrue);
      expect(v.tail.length, 0);
    });

    test('Vector2 tail when prefix1 has exactly 1 element', () {
      // Build a Vector2 whose prefix1 has length 1 by prepending to a 32-elem vector
      final base = IVector.tabulate(32, (i) => i);
      final v = base.prepended(-1); // prefix1 = [-1], rest in data/suffix
      expect(v.length, 33);
      final t = v.tail;
      expect(t.length, 32);
      expect(t[0], 0);
    });

    test('Vector2 init when suffix1 has exactly 1 element', () {
      // After filling to exactly WIDTH+1 elements the suffix1 is length 1
      final v = IVector.tabulate(33, (i) => i);
      expect(v.init.length, 32);
      expect(v.init[31], 31);
    });

    test('equality with non-RSeq returns false', () {
      // ignore: unrelated_type_equality_checks
      expect(ivec([1, 2, 3]) == 'not a sequence', isFalse);
      // ignore: unrelated_type_equality_checks
      expect(ivec([1]) == 1, isFalse);
    });

    test('equality with IList (also a RSeq) works', () {
      final RSeq<int> asRSeq = ilist([1, 2, 3]);
      expect(ivec([1, 2, 3]) == asRSeq, isTrue);
    });

    test('appendedAll with empty suffix returns same instance', () {
      final v = ivec([1, 2, 3]);
      expect(v.appendedAll(IVector.empty<int>()), same(v));
    });

    test('prependedAll with empty prefix returns same instance', () {
      final v = ivec([1, 2, 3]);
      expect(v.prependedAll(IVector.empty<int>()), same(v));
    });

    test('dropWhile always-true predicate returns empty', () {
      expect(ivec([1, 2, 3]).dropWhile((_) => true).isEmpty, isTrue);
    });

    test('dropWhile never-true predicate returns same elements', () {
      expect(ivec([1, 2, 3]).dropWhile((_) => false).toList(), [1, 2, 3]);
    });

    test('takeWhile always-true predicate returns all elements', () {
      expect(ivec([1, 2, 3]).takeWhile((_) => true).toList(), [1, 2, 3]);
    });

    test('takeWhile never-true predicate returns empty', () {
      expect(ivec([1, 2, 3]).takeWhile((_) => false).isEmpty, isTrue);
    });

    test('span on empty vector', () {
      final (a, b) = IVector.empty<int>().span((_) => true);
      expect(a.isEmpty, isTrue);
      expect(b.isEmpty, isTrue);
    });

    test('span always-true predicate: suffix is empty', () {
      final (prefix, suffix) = ivec([1, 2, 3]).span((_) => true);
      expect(prefix.toList(), [1, 2, 3]);
      expect(suffix.isEmpty, isTrue);
    });

    test('span never-true predicate: prefix is empty', () {
      final (prefix, suffix) = ivec([1, 2, 3]).span((_) => false);
      expect(prefix.isEmpty, isTrue);
      expect(suffix.toList(), [1, 2, 3]);
    });

    test('appendedAll: small.appendedAll(large) uses reverse-prepend fast path', () {
      // size < (k >>> _Log2ConcatFaster) triggers reverse-prepend onto suffix
      final small = ivec([0, 1, 2]); // size 3
      final large = IVector.tabulate(1024, (i) => i + 10); // k=1024, 3 < 1024>>>5=32
      final result = small.appendedAll(large);
      expect(result.length, 1027);
      expect(result[0], 0);
      expect(result[2], 2);
      expect(result[3], 10);
      expect(result[1026], 1033);
    });

    test('appendedAll: both large uses builder fast path', () {
      final a = IVector.tabulate(500, (i) => i);
      final b = IVector.tabulate(500, (i) => i + 500);
      final result = a.appendedAll(b);
      expect(result.length, 1000);
      expect(result[0], 0);
      expect(result[499], 499);
      expect(result[500], 500);
      expect(result[999], 999);
    });

    test('prependedAll: large prefix onto small uses builder fast path', () {
      final small = ivec([100, 101, 102]);
      final large = IVector.tabulate(1024, (i) => i);
      final result = small.prependedAll(large);
      expect(result.length, 1027);
      expect(result[0], 0);
      expect(result[1023], 1023);
      expect(result[1024], 100);
      expect(result[1026], 102);
    });

    test('builder result on fresh builder returns empty vector', () {
      final b = IVector.builder<int>();
      expect(b.result().isEmpty, isTrue);
    });

    test('builder addAll with non-IVector iterator on empty builder', () {
      final b = IVector.builder<int>();
      final it = ivec([1, 2, 3]).iterator; // RIterator, not IVector
      b.addAll(it);
      expect(b.result().toList(), [1, 2, 3]);
    });

    test('builder addAll IVector to already non-empty builder uses _addVector', () {
      final b = IVector.builder<int>()..addOne(0);
      b.addAll(ivec([1, 2, 3]));
      expect(b.result().toList(), [0, 1, 2, 3]);
    });

    test('builder addAll large IVector to non-empty builder', () {
      final b = IVector.builder<int>()..addOne(0);
      b.addAll(IVector.tabulate(100, (i) => i + 1));
      final result = b.result();
      expect(result.length, 101);
      expect(result[0], 0);
      expect(result[100], 100);
    });

    test('builder can be reused after result via clear', () {
      final b =
          IVector.builder<int>()
            ..addOne(1)
            ..addOne(2);
      final r1 = b.result();
      b.clear();
      b.addOne(9);
      final r2 = b.result();
      expect(r1.toList(), [1, 2]);
      expect(r2.toList(), [9]);
    });

    // -------------------------------------------------------------------------
    // builder.size() — line 36 (alias for knownSize)
    // -------------------------------------------------------------------------

    test('builder size() is an alias for knownSize()', () {
      final b = IVector.builder<int>();
      expect(b.size(), 0);
      b.addOne(1);
      b.addOne(2);
      expect(b.size(), 2);
    });

    // -------------------------------------------------------------------------
    // _initFromVector case 0 — lines 95-97 (addAll empty IVector to fresh builder)
    // -------------------------------------------------------------------------

    test('builder addAll empty IVector on fresh builder hits _initFromVector case 0', () {
      final b = IVector.builder<int>();
      b.addAll(IVector.empty<int>()); // triggers _initFromVector(Vector0)
      expect(b.result().isEmpty, isTrue);
    });

    test('builder addAll empty IVector then more elements', () {
      final b =
          IVector.builder<int>()
            ..addAll(IVector.empty<int>()) // _initFromVector case 0
            ..addAll(ivec([1, 2, 3])); // _addVector path
      expect(b.result().toList(), [1, 2, 3]);
    });

    test('appendedAll align path (Vector2 suffix, depth 3 _leftAlignPrefix)', () {
      final small = IVector.tabulate(200, (i) => i);
      final large = IVector.tabulate(1000, (i) => i + 200);
      final result = small.appendedAll(large);
      expect(result.length, 1200);
      expect(result[0], 0);
      expect(result[199], 199);
      expect(result[200], 200);
      expect(result[1199], 1199);
    });

    test('appendedAll align path (Vector3 suffix, depth 4 _leftAlignPrefix)', () {
      final small = IVector.tabulate(2000, (i) => i);
      final large = IVector.tabulate(32000, (i) => i + 2000);
      final result = small.appendedAll(large);
      expect(result.length, 34000);
      expect(result[0], 0);
      expect(result[1999], 1999);
      expect(result[2000], 2000);
      expect(result[33999], 33999);
    });

    test(
      'prependedAll else branch with Vector1 triggers _alignTo maxPrefixLength==1 early return',
      () {
        // this = exactly 32 elements (Vector1), prefix = 1000 elements (Vector2)
        final small = IVector.tabulate(32, (i) => i);
        final prefix = IVector.tabulate(1000, (i) => i + 100);
        final result = small.prependedAll(prefix);
        expect(result.length, 1032);
        expect(result[0], 100); // first of prefix
        expect(result[999], 1099); // last of prefix
        expect(result[1000], 0); // first of small
        expect(result[1031], 31); // last of small
      },
    );

    test('IVector.from with non-IVector RIterableOnce', () {
      final it = ilist([1, 2, 3]); // IList implements RIterableOnce but not IVector
      final v = IVector.from(it);
      expect(v.toList(), [1, 2, 3]);
    });

    test('updated does not mutate original', () {
      final original = ivec([1, 2, 3]);
      final modified = original.updated(1, 99);
      expect(original.toList(), [1, 2, 3]);
      expect(modified.toList(), [1, 99, 3]);
    });

    test('appended does not mutate original', () {
      final original = ivec([1, 2, 3]);
      original.appended(4);
      expect(original.length, 3);
    });

    test('reverseIterator across all vector sizes', () {
      for (final n in [0, 1, 32, 33, 1024, 1025]) {
        final v = IVector.tabulate(n, (i) => i);
        final rev = v.reverseIterator().toList();
        expect(rev, List.generate(n, (i) => n - 1 - i));
      }
    });

    test('appended grows through all vector types', () {
      var v = IVector.empty<int>();
      for (var i = 0; i < 1000; i++) {
        v = v.appended(i);
      }
      expect(v.length, 1000);
      expect(v[0], 0);
      expect(v[999], 999);
    });

    test('prepended grows through all vector types', () {
      var v = IVector.empty<int>();
      for (var i = 999; i >= 0; i--) {
        v = v.prepended(i);
      }
      expect(v.length, 1000);
      expect(v[0], 0);
      expect(v[999], 999);
    });

    test('Vector2 map transforms all segments', () {
      final v = IVector.tabulate(100, (i) => i);
      final mapped = v.map((x) => x * 2);
      expect(mapped.length, 100);
      expect(mapped[0], 0);
      expect(mapped[31], 62);
      expect(mapped[50], 100);
      expect(mapped[99], 198);
    });

    test('large vector map (Vector5) transforms all elements', () {
      const n = 1100000;
      final v = IVector.tabulate(n, (i) => i);
      final mapped = v.map((x) => x + 1);
      expect(mapped.length, n);
      expect(mapped[0], 1);
      expect(mapped[500000], 500001);
      expect(mapped[n - 1], n);
    });

    test('iterator on empty vector has no next', () {
      final it = IVector.empty<int>().iterator;
      expect(it.hasNext, isFalse);
    });

    test('slice with from >= until returns empty', () {
      expect(ivec([1, 2, 3]).slice(2, 2).isEmpty, isTrue);
      expect(ivec([1, 2, 3]).slice(3, 1).isEmpty, isTrue);
    });

    test('slice returning whole vector returns same instance', () {
      final v = ivec([1, 2, 3]);
      expect(v.slice(0, 3), same(v));
    });

    test('drop more than length returns empty', () {
      expect(ivec([1, 2, 3]).drop(10).isEmpty, isTrue);
    });

    test('take more than length returns all elements', () {
      expect(ivec([1, 2, 3]).take(100).toList(), [1, 2, 3]);
    });

    test('takeRight more than length returns all', () {
      expect(ivec([1, 2, 3]).takeRight(100).toList(), [1, 2, 3]);
    });

    test('dropRight more than length returns empty', () {
      expect(ivec([1, 2, 3]).dropRight(10).isEmpty, isTrue);
    });
  });
}
