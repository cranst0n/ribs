import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IVector', () {
    // 0, 2^5, 2^10, 2^15, 2^20, 2^25
    final vectorNBounds = [0, 32, 1024, 32768, 1048576, 33554432].expand((n) => [n, n + 1]);

    test('sandbox', () {
      vectorNBounds.forEach((n) {
        final v = IVector.fill(n, 0);
        // ignore: avoid_print
        print('($n) ${v.runtimeType}');
      });
    }, skip: true);

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

    test('view', () {
      final v0 = IVector.tabulate(5, (a) => a);
      final v1 = v0.view.map((a) => a + 1).take(4).takeRight(3).toList();

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
  });
}
