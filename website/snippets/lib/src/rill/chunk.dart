// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// #region chunk-create
IO<Unit> chunkCreate() {
  // Chunk.fromList: from a Dart List
  final fromList = Chunk.fromList([1, 2, 3, 4, 5]);

  // Chunk.tabulate: generate elements by index — allocates exactly one array
  final squares = Chunk.tabulate(5, (int i) => i * i); // [0, 1, 4, 9, 16]

  // Chunk.fill / Chunk.constant: n copies of a value, no backing array
  final filled = Chunk.fill(4, 'x'); // ['x', 'x', 'x', 'x']

  // Chunk.singleton: a one-element chunk
  final one = Chunk.singleton(42);

  // + concatenates lazily — no copying until compact() is called
  final combined = fromList + squares;

  // compact() coalesces a concatenated chunk into one contiguous array
  final compacted = combined.compact();

  return IO.print(
    'sizes — list: ${fromList.size}, '
    'squares: ${squares.size}, '
    'combined: ${combined.size}, '
    'compacted: ${compacted.size}',
  );
}
// #endregion chunk-create

// #region chunk-rill-observe
// chunks() exposes the raw Rill<Chunk<O>>, revealing how elements are batched.

IO<Unit> chunkObserve() {
  // emits() packs the whole List into a single chunk
  final singleChunk = Rill.emits([1, 2, 3, 4, 5]).chunks().compile.toIList.flatMap(
    (IList<Chunk<int>> cs) => IO.print(
      'emits → ${cs.length} chunk, sizes: ${cs.map((Chunk<int> c) => c.size)}',
    ),
  ); // emits → 1 chunk, sizes: IList(5)

  // range() emits in chunks of 64 by default; 200 elements → [64, 64, 72]
  final multiChunk = Rill.range(0, 200).chunks().compile.toIList.flatMap(
    (IList<Chunk<int>> cs) => IO.print(
      'range → ${cs.length} chunks, sizes: ${cs.map((Chunk<int> c) => c.size)}',
    ),
  ); // range → 3 chunks, sizes: IList(64, 64, 72)

  return IO.both(singleChunk, multiChunk).voided();
}
// #endregion chunk-rill-observe

// #region chunk-rill-reshape
IO<Unit> chunkReshape() {
  // chunkN(n): re-batch into fixed-size chunks, last chunk may be smaller
  final fixedSize = Rill.range(0, 25)
      .chunkN(10)
      .compile
      .toIList
      .flatMap(
        (IList<Chunk<int>> cs) => IO.print(
          'chunkN(10) sizes: ${cs.map((Chunk<int> c) => c.size)}',
        ),
      ); // IList(10, 10, 5)

  // chunkAll(): accumulate every element into one chunk — use with care on large streams
  final allInOne = Rill.range(0, 25).chunkAll().compile.toIList.flatMap(
    (IList<Chunk<int>> cs) => IO.print(
      'chunkAll sizes: ${cs.map((Chunk<int> c) => c.size)}',
    ),
  ); // IList(25)

  // chunkLimit(n): cap chunk size at n without merging smaller chunks
  final capped = Rill.emits([1, 2, 3, 4, 5, 6, 7])
      .chunkLimit(3)
      .compile
      .toIList
      .flatMap(
        (IList<Chunk<int>> cs) => IO.print(
          'chunkLimit(3) sizes: ${cs.map((Chunk<int> c) => c.size)}',
        ),
      ); // IList(3, 3, 1)

  return fixedSize.productR(allInOne).productR(capped);
}
// #endregion chunk-rill-reshape

// #region chunk-map-chunks
// mapChunks transforms each chunk as a whole, returning Rill<O2>.
// This is the same mechanism used internally by filter, map, collect, etc.

IO<Unit> chunkMapChunks() => Rill.range(0, 20)
    // Apply filter and map at chunk granularity — no per-element overhead
    .mapChunks(
      (Chunk<int> c) => c.filter((int n) => n.isEven).map((int n) => n * 10),
    )
    .compile
    .toIList
    .flatMap((IList<int> xs) => IO.print('evens x10: $xs'));
// #endregion chunk-map-chunks
