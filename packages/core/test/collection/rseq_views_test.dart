import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/rseq_views.dart' as seqview;
import 'package:test/test.dart';

List<A> toList<A>(RIterableOnce<A> col) => col.iterator.toIList().toList();

void main() {
  group('rseq_views', () {
    group('Id', () {
      test('operator[] returns element at index', () {
        final v = seqview.Id(ivec([10, 20, 30]));
        expect(v[0], 10);
        expect(v[1], 20);
        expect(v[2], 30);
      });

      test('length mirrors underlying', () {
        expect(seqview.Id(ivec([1, 2, 3])).length, 3);
      });

      test('knownSize mirrors underlying (known)', () {
        expect(seqview.Id(ivec([1, 2, 3])).knownSize, 3);
      });

      test('knownSize mirrors underlying (unknown)', () {
        expect(seqview.Id(ilist([1, 2])).knownSize, -1);
      });

      test('isEmpty is true for empty underlying', () {
        expect(seqview.Id(ivec(<int>[])).isEmpty, isTrue);
      });

      test('isEmpty is false for non-empty underlying', () {
        expect(seqview.Id(ivec([1])).isEmpty, isFalse);
      });

      test('iterator yields all elements', () {
        expect(toList(seqview.Id(ivec([1, 2, 3]))), [1, 2, 3]);
      });
    });

    group('Appended', () {
      test('operator[] returns existing elements at correct indices', () {
        final v = seqview.Appended(ivec([1, 2, 3]), 4);
        expect(v[0], 1);
        expect(v[1], 2);
        expect(v[2], 3);
      });

      test('operator[] returns appended element at last index', () {
        final v = seqview.Appended(ivec([1, 2, 3]), 99);
        expect(v[3], 99);
      });

      test('operator[] on empty seq returns appended element at index 0', () {
        final v = seqview.Appended(ivec(<int>[]), 7);
        expect(v[0], 7);
      });

      test('length is underlying length + 1', () {
        expect(seqview.Appended(ivec([1, 2]), 3).length, 3);
      });

      test('iterator yields all elements including appended', () {
        expect(toList(seqview.Appended(ivec([1, 2]), 3)), [1, 2, 3]);
      });
    });

    group('Concat', () {
      test('operator[] indexes into prefix', () {
        final v = seqview.Concat(ivec([10, 20]), ivec([30, 40]));
        expect(v[0], 10);
        expect(v[1], 20);
      });

      test('operator[] indexes into suffix after prefix length', () {
        final v = seqview.Concat(ivec([10, 20]), ivec([30, 40]));
        expect(v[2], 30);
        expect(v[3], 40);
      });

      test('length is sum of both sequences', () {
        expect(seqview.Concat(ivec([1, 2]), ivec([3, 4, 5])).length, 5);
      });

      test('length with empty prefix equals suffix length', () {
        expect(seqview.Concat(ivec(<int>[]), ivec([1, 2, 3])).length, 3);
      });

      test('iterator yields all elements in order', () {
        expect(toList(seqview.Concat(ivec([1, 2]), ivec([3, 4]))), [1, 2, 3, 4]);
      });
    });

    group('Drop', () {
      test('operator[] returns element shifted by drop amount', () {
        final v = seqview.Drop(ivec([10, 20, 30, 40]), 2);
        expect(v[0], 30);
        expect(v[1], 40);
      });

      test('length is underlying length minus n', () {
        expect(seqview.Drop(ivec([1, 2, 3, 4]), 2).length, 2);
      });

      test('length is 0 when n >= underlying length', () {
        expect(seqview.Drop(ivec([1, 2]), 5).length, 0);
      });

      test('drop chaining adds n values', () {
        // Drop.drop overrides to combine drops
        final v = seqview.Drop(ivec([1, 2, 3, 4, 5]), 1).drop(2);
        expect(toList(v), [4, 5]);
      });

      test('iterator yields remaining elements after drop', () {
        expect(toList(seqview.Drop(ivec([1, 2, 3, 4]), 2)), [3, 4]);
      });
    });

    group('DropRight', () {
      test('operator[] returns elements by original index', () {
        final v = seqview.DropRight(ivec([10, 20, 30, 40]), 2);
        expect(v[0], 10);
        expect(v[1], 20);
      });

      test('length is underlying length minus n', () {
        expect(seqview.DropRight(ivec([1, 2, 3, 4]), 2).length, 2);
      });

      test('length is 0 when n >= underlying length', () {
        expect(seqview.DropRight(ivec([1, 2]), 5).length, 0);
      });

      test('iterator yields first (size - n) elements', () {
        expect(toList(seqview.DropRight(ivec([1, 2, 3, 4]), 2)), [1, 2]);
      });

      test('dropping 0 returns all elements', () {
        expect(toList(seqview.DropRight(ivec([1, 2, 3]), 0)), [1, 2, 3]);
      });
    });

    group('Map', () {
      test('operator[] returns mapped element at index', () {
        final v = seqview.Map(ivec([1, 2, 3]), (int n) => n * 10);
        expect(v[0], 10);
        expect(v[1], 20);
        expect(v[2], 30);
      });

      test('length equals underlying length', () {
        expect(seqview.Map(ivec([1, 2, 3]), (int n) => n).length, 3);
      });

      test('iterator yields mapped elements', () {
        expect(
          toList(seqview.Map(ivec([1, 2, 3]), (int n) => n * 2)),
          [2, 4, 6],
        );
      });

      test('map with type change works correctly', () {
        final v = seqview.Map(ivec([1, 2, 3]), (int n) => n.toString());
        expect(v[0], '1');
        expect(v[2], '3');
        expect(v.length, 3);
      });
    });

    group('Prepended', () {
      test('operator[] returns prepended element at index 0', () {
        final v = seqview.Prepended(99, ivec([1, 2, 3]));
        expect(v[0], 99);
      });

      test('operator[] returns underlying elements shifted by 1', () {
        final v = seqview.Prepended(99, ivec([1, 2, 3]));
        expect(v[1], 1);
        expect(v[2], 2);
        expect(v[3], 3);
      });

      test('length is underlying length + 1', () {
        expect(seqview.Prepended(0, ivec([1, 2])).length, 3);
      });

      test('iterator yields prepended element then underlying elements', () {
        expect(toList(seqview.Prepended(0, ivec([1, 2, 3]))), [0, 1, 2, 3]);
      });
    });

    group('Reverse', () {
      test('operator[] returns elements in reverse order', () {
        final v = seqview.Reverse(ivec([1, 2, 3]));
        expect(v[0], 3);
        expect(v[1], 2);
        expect(v[2], 1);
      });

      test('length equals underlying length', () {
        expect(seqview.Reverse(ivec([1, 2, 3])).length, 3);
      });

      test('knownSize mirrors underlying', () {
        expect(seqview.Reverse(ivec([1, 2, 3])).knownSize, 3);
      });

      test('isEmpty is true for empty underlying', () {
        expect(seqview.Reverse(ivec(<int>[])).isEmpty, isTrue);
      });

      test('isEmpty is false for non-empty underlying', () {
        expect(seqview.Reverse(ivec([1])).isEmpty, isFalse);
      });

      test('iterator yields elements in reverse order', () {
        expect(toList(seqview.Reverse(ivec([1, 2, 3]))), [3, 2, 1]);
      });

      test('reverse of single element is same element', () {
        expect(toList(seqview.Reverse(ivec([42]))), [42]);
      });
    });

    group('Take', () {
      test('operator[] returns element at index within taken range', () {
        final v = seqview.Take(ivec([10, 20, 30, 40]), 3);
        expect(v[0], 10);
        expect(v[1], 20);
        expect(v[2], 30);
      });

      test('operator[] throws RangeError for index >= n', () {
        final v = seqview.Take(ivec([10, 20, 30, 40]), 2);
        expect(() => v[2], throwsRangeError);
      });

      test('length is min(underlying length, n)', () {
        expect(seqview.Take(ivec([1, 2, 3, 4]), 2).length, 2);
      });

      test('length is underlying length when n > underlying length', () {
        expect(seqview.Take(ivec([1, 2]), 10).length, 2);
      });

      test('iterator yields first n elements', () {
        expect(toList(seqview.Take(ivec([1, 2, 3, 4, 5]), 3)), [1, 2, 3]);
      });

      test('take 0 yields empty', () {
        expect(toList(seqview.Take(ivec([1, 2, 3]), 0)), isEmpty);
      });
    });

    group('TakeRight', () {
      test('operator[] returns elements from the right portion', () {
        final v = seqview.TakeRight(ivec([1, 2, 3, 4, 5]), 3);
        // delta = max(5 - 3, 0) = 2; so v[0] = seq[0+2] = 3
        expect(v[0], 3);
        expect(v[1], 4);
        expect(v[2], 5);
      });

      test('length is n when n <= underlying length', () {
        expect(seqview.TakeRight(ivec([1, 2, 3, 4]), 2).length, 2);
      });

      test('length is underlying length when n > underlying length', () {
        expect(seqview.TakeRight(ivec([1, 2]), 10).length, 2);
      });

      test('iterator yields last n elements', () {
        expect(toList(seqview.TakeRight(ivec([1, 2, 3, 4, 5]), 3)), [3, 4, 5]);
      });

      test('take right 0 yields empty', () {
        expect(toList(seqview.TakeRight(ivec([1, 2, 3]), 0)), isEmpty);
      });
    });

    group('Sorted', () {
      test('operator[] returns element in sorted order', () {
        final v = seqview.Sorted(ivec([3, 1, 4, 1, 5]), Order.ints, 5);
        expect(v[0], 1);
        expect(v[1], 1);
        expect(v[2], 3);
        expect(v[3], 4);
        expect(v[4], 5);
      });

      test('length equals original length', () {
        expect(seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3).length, 3);
      });

      test('knownSize equals len parameter', () {
        expect(seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3).knownSize, 3);
      });

      test('isEmpty is true when len is 0', () {
        expect(seqview.Sorted(ivec(<int>[]), Order.ints).isEmpty, isTrue);
      });

      test('isEmpty is false when len > 0', () {
        expect(seqview.Sorted(ivec([1]), Order.ints, 1).isEmpty, isFalse);
      });

      test('iterator yields elements in sorted order', () {
        expect(
          toList(seqview.Sorted(ivec([5, 3, 1, 4, 2]), Order.ints, 5)),
          [1, 2, 3, 4, 5],
        );
      });

      test('sorted with same order returns same instance', () {
        final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
        expect(s.sorted(Order.ints), same(s));
      });

      test('sorted with a different order re-sorts the elements', () {
        final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
        final r = s.sorted(Order.ints.reverse());
        expect(toList(r), [3, 2, 1]);
      });

      test('reverse returns elements in descending order', () {
        final s = seqview.Sorted(ivec([3, 1, 4, 2]), Order.ints, 4);
        expect(toList(s.reverse()), [4, 3, 2, 1]);
      });

      group('_ReverseSorted (via Sorted.reverse())', () {
        test('operator[] returns elements from sorted (ascending) by index', () {
          // _ReverseSorted.operator[] delegates to outer._sorted[idx]
          // (ascending order) while iterator uses the reversed order
          final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
          final r = s.reverse();
          // iterator should be descending
          expect(toList(r), [3, 2, 1]);
        });

        test('isEmpty mirrors outer sorted isEmpty', () {
          final s = seqview.Sorted(ivec(<int>[]), Order.ints);
          expect(s.reverse().isEmpty, isTrue);
        });

        test('length mirrors outer sorted length', () {
          final s = seqview.Sorted(ivec([1, 2, 3]), Order.ints, 3);
          expect(s.reverse().length, 3);
        });

        test('knownSize mirrors outer sorted knownSize', () {
          final s = seqview.Sorted(ivec([1, 2, 3]), Order.ints, 3);
          expect(s.reverse().knownSize, 3);
        });

        test('reverse of _ReverseSorted returns original Sorted', () {
          final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
          final r = s.reverse();
          expect(r.reverse(), same(s));
        });

        test('sorted with same order as original returns original Sorted', () {
          final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
          final r = s.reverse();
          expect(r.sorted(Order.ints), same(s));
        });

        test('sorted with a different order re-sorts', () {
          final s = seqview.Sorted(ivec([3, 1, 2]), Order.ints, 3);
          final r = s.reverse();
          final r2 = r.sorted(Order.ints);
          expect(toList(r2), [1, 2, 3]);
        });
      });
    });
  });
}
