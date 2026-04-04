import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/indexed_seq_views.dart' as iseqview;
import 'package:test/test.dart';

List<A> toList<A>(RIterableOnce<A> col) => col.iterator.toIList().toList();

void main() {
  group('indexed_seq_views', () {
    group('Id', () {
      test('operator[] returns element at index', () {
        final v = iseqview.Id(ivec([10, 20, 30]));
        expect(v[0], 10);
        expect(v[2], 30);
      });

      test('length and knownSize match underlying', () {
        final v = iseqview.Id(ivec([1, 2, 3]));
        expect(v.length, 3);
        expect(v.knownSize, 3);
      });

      test('iterator (IndexedSeqViewIterator) yields all elements', () {
        expect(toList(iseqview.Id(ivec([1, 2, 3]))), [1, 2, 3]);
      });
    });

    group('Appended', () {
      test('operator[] on last index returns appended element', () {
        final v = iseqview.Appended(ivec([1, 2]), 99);
        expect(v[2], 99);
      });

      test('iterator yields all including appended element', () {
        expect(toList(iseqview.Appended(ivec([1, 2]), 3)), [1, 2, 3]);
      });
    });

    group('Concat', () {
      test('operator[] spans both halves', () {
        final v = iseqview.Concat(ivec([10, 20]), ivec([30, 40]));
        expect(v[1], 20);
        expect(v[2], 30);
      });

      test('length is sum of both', () {
        expect(iseqview.Concat(ivec([1, 2]), ivec([3, 4, 5])).length, 5);
      });

      test('iterator yields all elements in order', () {
        expect(toList(iseqview.Concat(ivec([1, 2]), ivec([3, 4]))), [1, 2, 3, 4]);
      });
    });

    group('Drop', () {
      test('operator[] returns element shifted by drop amount', () {
        expect(iseqview.Drop(ivec([10, 20, 30, 40]), 2)[0], 30);
      });

      test('iterator yields remaining elements', () {
        expect(toList(iseqview.Drop(ivec([1, 2, 3, 4]), 2)), [3, 4]);
      });
    });

    group('DropRight', () {
      test('length is size - n', () {
        expect(iseqview.DropRight(ivec([1, 2, 3, 4]), 2).length, 2);
      });

      test('iterator yields first (size - n) elements', () {
        expect(toList(iseqview.DropRight(ivec([1, 2, 3, 4]), 2)), [1, 2]);
      });
    });

    group('Map', () {
      test('operator[] returns mapped value', () {
        expect(iseqview.Map(ivec([1, 2, 3]), (int n) => n * 10)[1], 20);
      });

      test('iterator yields all mapped elements', () {
        expect(
          toList(iseqview.Map(ivec([1, 2, 3]), (int n) => n * 2)),
          [2, 4, 6],
        );
      });
    });

    group('Prepended', () {
      test('operator[] at 0 is prepended element', () {
        expect(iseqview.Prepended(0, ivec([1, 2]))[0], 0);
      });

      test('iterator yields prepended then underlying', () {
        expect(toList(iseqview.Prepended(0, ivec([1, 2, 3]))), [0, 1, 2, 3]);
      });
    });

    group('Take', () {
      test('operator[] within range returns element', () {
        expect(iseqview.Take(ivec([10, 20, 30]), 2)[1], 20);
      });

      test('iterator yields first n elements', () {
        expect(toList(iseqview.Take(ivec([1, 2, 3, 4]), 3)), [1, 2, 3]);
      });
    });

    group('TakeRight', () {
      test('iterator yields last n elements', () {
        expect(toList(iseqview.TakeRight(ivec([1, 2, 3, 4, 5]), 3)), [3, 4, 5]);
      });
    });

    group('Reverse', () {
      test('iterator yields elements in reverse order', () {
        expect(toList(iseqview.Reverse(ivec([1, 2, 3]))), [3, 2, 1]);
      });

      test('reverse() of Reverse when underlying is IndexedSeqView returns underlying view', () {
        // Build a Reverse whose underlying is itself an IndexedSeqView
        // (e.g. iseqview.Id which mixes in IndexedSeqView).
        final base = iseqview.Id(ivec([1, 2, 3]));
        final rev = iseqview.Reverse(base);
        expect(rev.reverse(), same(base));
      });

      test(
        'reverse() of Reverse when underlying is plain IndexedSeq calls super (new Reverse)',
        () {
          // ivec itself is not an IndexedSeqView, so the else branch fires
          final rev = iseqview.Reverse(ivec([1, 2, 3]));
          final rr = rev.reverse();
          expect(toList(rr), [1, 2, 3]);
        },
      );
    });

    group('Slice', () {
      test('operator[] accesses underlying starting at lo', () {
        final s = iseqview.Slice(ivec([10, 20, 30, 40, 50]), 1, 4);
        expect(s[0], 20);
        expect(s[1], 30);
        expect(s[2], 40);
      });

      test('length is until - from for valid range', () {
        expect(iseqview.Slice(ivec([1, 2, 3, 4, 5]), 1, 4).length, 3);
      });

      test('length is 0 when from >= until', () {
        expect(iseqview.Slice(ivec([1, 2, 3]), 3, 1).length, 0);
      });

      test('length is 0 when from == until', () {
        expect(iseqview.Slice(ivec([1, 2, 3]), 2, 2).length, 0);
      });

      test('negative from is clamped to 0', () {
        final s = iseqview.Slice(ivec([1, 2, 3, 4]), -5, 2);
        expect(s.length, 2);
        expect(s[0], 1);
        expect(s[1], 2);
      });

      test('until beyond end is clamped to underlying length', () {
        final s = iseqview.Slice(ivec([1, 2, 3]), 1, 100);
        expect(s.length, 2);
        expect(s[0], 2);
        expect(s[1], 3);
      });

      test('from and until both clamped', () {
        final s = iseqview.Slice(ivec([1, 2, 3, 4, 5]), -2, 100);
        expect(s.length, 5);
        expect(toList(s), [1, 2, 3, 4, 5]);
      });

      test('iterator yields sliced elements', () {
        expect(
          toList(iseqview.Slice(ivec([1, 2, 3, 4, 5]), 1, 4)),
          [2, 3, 4],
        );
      });

      test('slice of full range returns all elements', () {
        expect(
          toList(iseqview.Slice(ivec([1, 2, 3]), 0, 3)),
          [1, 2, 3],
        );
      });
    });

    group('IndexedSeqViewIterator', () {
      test('hasNext is true for non-empty, false after exhaustion', () {
        final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1])));
        expect(it.hasNext, isTrue);
        it.next();
        expect(it.hasNext, isFalse);
      });

      test('knownSize decrements on each next()', () {
        final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3])));
        expect(it.knownSize, 3);
        it.next();
        expect(it.knownSize, 2);
        it.next();
        expect(it.knownSize, 1);
      });

      test('next() returns elements in order', () {
        final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([10, 20, 30])));
        expect(it.next(), 10);
        expect(it.next(), 20);
        expect(it.next(), 30);
      });

      test('next() throws on empty iterator', () {
        final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec(<int>[])));
        expect(it.next, throwsUnsupportedError);
      });

      group('drop()', () {
        test('drop(n) skips n elements', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3, 4, 5])));
          it.drop(2);
          expect(it.next(), 3);
          expect(it.knownSize, 2);
        });

        test('drop(0) has no effect', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3])));
          it.drop(0);
          expect(it.next(), 1);
        });

        test('drop(n) where n > remaining clamps remainder to 0', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2])));
          it.drop(10);
          expect(it.hasNext, isFalse);
          expect(it.knownSize, 0);
        });
      });

      group('sliceIterator()', () {
        test('sliceIterator(from, until) returns sub-range', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3, 4, 5])));
          it.sliceIterator(1, 4);
          expect(it.next(), 2);
          expect(it.next(), 3);
          expect(it.next(), 4);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator clips negative from to 0', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3])));
          it.sliceIterator(-1, 2);
          expect(it.next(), 1);
          expect(it.next(), 2);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator clips until beyond remainder to remainder', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3])));
          it.sliceIterator(1, 100);
          expect(it.next(), 2);
          expect(it.next(), 3);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(from, until) where until <= from yields empty', () {
          final it = iseqview.IndexedSeqViewIterator(iseqview.Id(ivec([1, 2, 3])));
          it.sliceIterator(2, 1);
          expect(it.hasNext, isFalse);
        });
      });
    });

    group('IndexedSeqViewReverseIterator', () {
      test('hasNext is true for non-empty, false after exhaustion', () {
        final it = iseqview.IndexedSeqViewReverseIterator(iseqview.Id(ivec([1])));
        expect(it.hasNext, isTrue);
        it.next();
        expect(it.hasNext, isFalse);
      });

      test('next() yields elements in reverse order', () {
        final it = iseqview.IndexedSeqViewReverseIterator(iseqview.Id(ivec([1, 2, 3])));
        expect(it.next(), 3);
        expect(it.next(), 2);
        expect(it.next(), 1);
        expect(it.hasNext, isFalse);
      });

      test('next() throws on empty iterator', () {
        final it = iseqview.IndexedSeqViewReverseIterator(iseqview.Id(ivec(<int>[])));
        expect(it.next, throwsUnsupportedError);
      });

      group('sliceIterator()', () {
        // All examples use a 5-element view [0,1,2,3,4]; reverse order is 4,3,2,1,0.

        test('sliceIterator on exhausted iterator is a no-op', () {
          final base = iseqview.Id(ivec([1, 2, 3]));
          final it = iseqview.IndexedSeqViewReverseIterator(base);
          it.next();
          it.next();
          it.next(); // exhaust
          it.sliceIterator(0, 2);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(from, _) where from >= remainder exhausts iterator', () {
          // _remainder = 5, from = 5 → _remainder = 0
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(5, 10);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(0, until) limits to until elements (no skip)', () {
          // from=0 ≤ 0, until=3 < remainder=5 → _remainder=3
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(0, 3);
          expect(it.next(), 4);
          expect(it.next(), 3);
          expect(it.next(), 2);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(0, until) where until >= remainder keeps all (no-op on limit)', () {
          // from=0 ≤ 0, until=10 not < remainder=5 → unchanged
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(0, 10);
          expect(it.next(), 4);
          expect(it.next(), 3);
          expect(it.next(), 2);
          expect(it.next(), 1);
          expect(it.next(), 0);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(from, until) skips from and limits to (until-from) elements', () {
          // from=2, until=4, remainder=5: _pos -= 2 (→ pos=2), _remainder = 4-2 = 2
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(2, 4);
          expect(it.next(), 2);
          expect(it.next(), 1);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(from, until) where until <= from exhausts iterator', () {
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(2, 1);
          expect(it.hasNext, isFalse);
        });

        test('sliceIterator(from, _) where until >= remainder skips from elements', () {
          final it = iseqview.IndexedSeqViewReverseIterator(
            iseqview.Id(ivec([0, 1, 2, 3, 4])),
          );
          it.sliceIterator(2, 10);
          expect(it.next(), 2);
          expect(it.next(), 1);
          expect(it.next(), 0);
          expect(it.hasNext, isFalse);
        });
      });
    });
  });
}
