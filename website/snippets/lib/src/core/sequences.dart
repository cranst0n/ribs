// ignore_for_file: avoid_print, unused_local_variable

import 'package:ribs_core/ribs_core.dart';

// #region ilist-construction
final ilistEmpty = IList.empty<int>();
final ilistFromLiteral = ilist([1, 2, 3]);
final ilistFromDart = IList.fromDart([4, 5, 6]);
final ilistFilled = IList.fill(5, 'x');
final ilistTabulated = IList.tabulate(5, (int i) => i * i); // [0, 1, 4, 9, 16]
final ilistRanged = IList.range(0, 5); // [0, 1, 2, 3, 4]
// #endregion ilist-construction

// #region ivector-construction
final ivectorEmpty = IVector.empty<int>();
final ivectorFromLiteral = ivec([1, 2, 3]);
final ivectorFromDart = IVector.fromDart([4, 5, 6]);
final ivectorFilled = IVector.fill(5, 0);
// #endregion ivector-construction

// #region ivector-builder
IVector<String> buildVector() => IVector.builder<String>().addOne('a').addOne('b').result();
// #endregion ivector-builder

// #region ichain-construction
final ichainEmpty = IChain.empty<int>();
final ichainSingle = IChain.one(42);
final ichainFromLiteral = ichain([1, 2, 3]);
final ichainFromDart = IChain.fromDart([4, 5, 6]);
final ichainFromSeq = IChain.fromSeq(ilist([7, 8, 9]));
// #endregion ichain-construction

// #region nel-construction
final nelBasic = nel(1, [2, 3, 4]);
final nelSingle = nel(1);
final nelWithTail = NonEmptyIList<int>(1, ilist([2, 3]));
final nelFromOpt = NonEmptyIList.fromDart([1, 2, 3]); // Some(nel(1, [2, 3]))
final nelFromEmpty = NonEmptyIList.fromDart<int>([]); // None
// #endregion nel-construction

// #region range-construction
final rangeExclusive = Range.exclusive(0, 10); // 0, 1, 2, …, 9
final rangeInclusive = Range.inclusive(0, 10); // 0, 1, 2, …, 10
final rangeStepped = Range.exclusive(0, 10, 2); // 0, 2, 4, 6, 8
final rangeRestepped = Range.exclusive(0, 10).by(3); // 0, 3, 6, 9
// #endregion range-construction

// #region iqueue-ops
void iQueueExample() {
  final empty = IQueue.empty<String>();
  final withFirst = empty.enqueue('hello');
  final withSecond = withFirst.enqueue('world');

  // dequeue returns a tuple of (front element, remaining queue)
  final (front, rest) = withSecond.dequeue();
  print(front); // hello
  print(rest); // IQueue containing 'world'

  // dequeueOption returns None on an empty queue instead of throwing
  final safeDequeue = IQueue.empty<String>().dequeueOption(); // None
  print(safeDequeue);
}
// #endregion iqueue-ops

// #region ilazylist-construction
final lazyEmpty = ILazyList.empty<int>();
final lazyInfinite = ILazyList.continually(1); // 1, 1, 1, ...
final lazyFilled = ILazyList.fill(5, 'x');
final lazyFromList = ILazyList.from(ilist([1, 2, 3]));

// Take only what you need from an infinite list
final first10 = lazyInfinite.take(10).toIList(); // IList of ten 1s
// #endregion ilazylist-construction

// #region listbuffer-ops
void listBufferExample() {
  final buf = IList.builder<int>();
  buf.addOne(1);
  buf.addOne(2);
  buf.addAll(ilist([3, 4, 5]));

  // O(1) conversion — no copying
  final immutableList = buf.toIList(); // IList([1, 2, 3, 4, 5])
  print(immutableList);
}
// #endregion listbuffer-ops
