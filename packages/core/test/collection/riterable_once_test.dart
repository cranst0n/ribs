import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('RIterableOnce', () {
    // isTraversableAgain — mixin default; no override in RIterable or subtypes
    test('isTraversableAgain', () {
      expect(imultiset([1, 2, 3]).isTraversableAgain, isFalse);
      expect(RIterator.single(1).isTraversableAgain, isFalse);
    });

    // size — fast path when knownSize >= 0 (IVector overrides knownSize = length)
    test('size uses knownSize fast path', () {
      final v = ivec([1, 2, 3]);
      expect(v.knownSize, 3);
      expect(v.size, 3);
    });

    // corresponds — mixin version used by non-RSeq types (ISet, IMultiSet)
    test('corresponds', () {
      expect(iset({1}).corresponds(iset({1}), (int a, int b) => a == b), isTrue);
      expect(iset({1}).corresponds(iset({2}), (int a, int b) => a == b), isFalse);
      expect(iset({1}).corresponds(iset({1, 2}), (int a, int b) => a == b), isFalse);
      expect(
        ISet.empty<int>().corresponds(ISet.empty<int>(), (int a, int b) => a == b),
        isTrue,
      );
    });

    // reduce delegates to reduceLeft
    test('reduce', () {
      expect(ilist([1, 2, 3, 4]).reduce((int a, int b) => a + b), 10);
      expect(imultiset([1, 2, 3]).reduce((int a, int b) => a + b), 6);
    });

    // reduceLeft — IndexedSeq fast path (_foldl) and iterator path (_reduceLeftIterator)
    test('reduceLeft', () {
      // IndexedSeq path via _foldl (IVector is IndexedSeq)
      expect(ivec([1, 2, 3]).reduceLeft((int a, int b) => a + b), 6);
      expect(ivec([10, 2, 5]).reduceLeft((int a, int b) => a - b), 3);

      // Iterator path (IList is RSeq but not IndexedSeq, knownSize == -1 for Cons)
      expect(ilist([1, 2, 3]).reduceLeft((int a, int b) => a + b), 6);

      // Empty with knownSize == 0 throws (Nil.knownSize == 0)
      expect(
        () => nil<int>().reduceLeft((int a, int b) => a + b),
        throwsUnsupportedError,
      );
    });

    // reduceRight — IndexedSeq fast path (_foldr) and iterator path
    test('reduceRight', () {
      // IndexedSeq path via _foldr: op(1, op(2, 3)) = op(1, 2-3) = op(1, -1) = 2
      expect(ivec([1, 2, 3]).reduceRight((int a, int b) => a - b), 2);

      // Iterator path (IList uses _reversed().reduceLeft)
      expect(ilist([1, 2, 3]).reduceRight((int a, int b) => a - b), 2);

      // Empty with knownSize == 0 throws
      expect(
        () => nil<int>().reduceRight((int a, int b) => a + b),
        throwsUnsupportedError,
      );
    });

    // reduceRightOption — knownSize > 0 branch returns Some(reduceRight(op))
    test('reduceRightOption with known non-empty size', () {
      expect(ivec([1, 2, 3]).reduceRightOption((int a, int b) => a + b), const Some(6));
      expect(IVector.empty<int>().reduceRightOption((int a, int b) => a + b), none<int>());
    });

    // _reduceOptionIterator empty case — knownSize == -1 but iterator is empty
    test('reduceLeftOption on empty collection with unknown size', () {
      // IMultiSet.empty() has knownSize == -1 (not overridden)
      expect(
        IMultiSet.empty<int>().reduceLeftOption((int a, int b) => a + b),
        none<int>(),
      );
    });

    // toList(growable: false) — uses List.generate path
    test('toList growable: false', () {
      expect(ilist([1, 2, 3]).toList(growable: false), [1, 2, 3]);
      expect(ivec([4, 5]).toList(growable: false), [4, 5]);
    });

    // splitAt mixin (via _Spanner) — RIterator does not override splitAt
    test('splitAt on RIterator uses _Spanner', () {
      final (prefix, suffix) = RIterator.fromDart([1, 2, 3, 4].iterator).splitAt(2);
      expect(prefix.toIList(), ilist([1, 2]));
      expect(suffix.toIList(), ilist([3, 4]));
    });

    // tapEach mixin — RIterator does not override tapEach
    test('tapEach on RIterator', () {
      final seen = <int>[];
      RIterator.fromDart([1, 2, 3].iterator).tapEach(seen.add);
      expect(seen, [1, 2, 3]);
    });
  });
}
