// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';

// #region iset-construction
final isetEmpty = ISet.empty<int>();
final isetFromLiteral = iset([1, 2, 3]);
final isetFromDart = ISet.of([4, 5, 6]);
final isetFromCollection = ISet.from(ilist([7, 8, 9]));
// #endregion iset-construction

// #region iset-ops
final base = iset([1, 2, 3, 4, 5]);

// operator + / - return a new ISet; the original is unchanged
final withSix = base + 6; // {1, 2, 3, 4, 5, 6}
final withoutThree = base - 3; // {1, 2, 4, 5}

final hasTwo = base.contains(2); // true
final hasTen = base.contains(10); // false

final a = iset([1, 2, 3]);
final b = iset([2, 3, 4]);

final unionAB = a.union(b); // {1, 2, 3, 4}
final diffAB = a.diff(b); // {1}   — in a but not b
final intersectAB = a.intersect(b); // {2, 3} — in both

final isSubset = iset([1, 2]).subsetOf(a); // true

// Remove several elements at once
final stripped = base.removedAll(ilist([1, 3, 5])); // {2, 4}

// All distinct subsets of size 2
final size2 = iset([1, 2, 3]).subsets(length: 2).toIList();
// #endregion iset-ops

// #region mset-ops
void msetExample() {
  final s = MSet.empty<String>();

  // add returns true when the element is newly inserted
  final added1 = s.add('hello'); // true
  final added2 = s.add('hello'); // false — already present
  final added3 = s.add('world'); // true

  final hasHello = s.contains('hello'); // true

  // remove returns true when the element was present
  final removed1 = s.remove('hello'); // true
  final removed2 = s.remove('hello'); // false — no longer present
}
// #endregion mset-ops

// #region imultiset-construction
final msEmpty = IMultiSet.empty<String>();

// Duplicate elements are counted, not deduplicated
final msFromLiteral = imultiset(['a', 'a', 'b', 'c', 'c', 'c']);

// Build from explicit (element, count) pairs
final msFromOccurrences = IMultiSet.fromOccurences(
  ilist([('a', 2), ('b', 1), ('c', 3)]),
);
// #endregion imultiset-construction

// #region imultiset-ops
final ms = imultiset(['a', 'a', 'b', 'c', 'c', 'c']);

// Count of each element; 0 for absent elements
final countA = ms.get('a'); // 2
final countB = ms.get('b'); // 1
final countD = ms.get('d'); // 0

// occurrences exposes the underlying IMap<A, int>
final occ = ms.occurrences; // IMap { 'a': 2, 'b': 1, 'c': 3 }

// + adds one occurrence; - removes one occurrence
final withExtraA = ms + 'a'; // 'a' count becomes 3
final withoutOneC = ms - 'c'; // 'c' count becomes 2

final hasA = ms.contains('a'); // true
final hasD = ms.contains('d'); // false
// #endregion imultiset-ops
