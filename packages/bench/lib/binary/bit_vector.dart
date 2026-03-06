import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_binary/ribs_binary.dart';

// Builds a _Chunks tree by concating [chunkBits]-sized _Bytes nodes.
// The resulting structure exercises _Append / _Chunks traversal paths.
BitVector _buildBvChunks(int totalBits, [int chunkBits = 64]) {
  var bv = BitVector.empty;
  final count = totalBits ~/ chunkBits;
  for (var i = 0; i < count; i++) {
    bv = bv.concat(BitVector.high(chunkBits));
  }
  return bv;
}

// ─── Concat ───────────────────────────────────────────────────────────────────

/// Concat two _Bytes leaf nodes.
class BitVectorConcatBytesBenchmark extends BenchmarkBase {
  final int n; // bytes; vector size = n*8 bits
  late BitVector left;
  late BitVector right;

  BitVectorConcatBytesBenchmark(this.n) : super('bitvec-concat-bytes-$n');

  @override
  void setup() {
    left = BitVector.high(n * 4); // half the bits
    right = BitVector.high(n * 4);
  }

  @override
  void run() => left.concat(right);
}

/// Concat a new _Bytes leaf onto an existing _Chunks tree.
/// Exercises the _Chunks.concat rebalancing path.
class BitVectorConcatChunksBenchmark extends BenchmarkBase {
  final int n;
  late BitVector left; // _Chunks tree
  late BitVector right; // _Bytes leaf

  BitVectorConcatChunksBenchmark(this.n) : super('bitvec-concat-chunks-$n');

  @override
  void setup() {
    left = _buildBvChunks(n * 8);
    right = BitVector.high(64);
  }

  @override
  void run() => left.concat(right);
}

// ─── Get ──────────────────────────────────────────────────────────────────────

/// Get a bit from a _Bytes node (direct array lookup).
class BitVectorGetBytesBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Bytes

  BitVectorGetBytesBenchmark(this.n) : super('bitvec-get-bytes-$n');

  @override
  void setup() => bv = BitVector.high(n * 8);

  @override
  void run() => bv.get(n * 4);
}

/// Get a bit from a _Drop node (access must add offset before indexing).
class BitVectorGetDropBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Drop (non-aligned drop of 5 bits)

  BitVectorGetDropBenchmark(this.n) : super('bitvec-get-drop-$n');

  @override
  void setup() => bv = BitVector.high(n * 8 + 5).drop(5);

  @override
  void run() => bv.get(n * 4);
}

/// Get a bit from a _Chunks tree (must walk the append structure).
class BitVectorGetChunksBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Chunks

  BitVectorGetChunksBenchmark(this.n) : super('bitvec-get-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n * 8);

  @override
  void run() => bv.get(n * 4);
}

/// Get a bit from a _Buffer node (dispatch through buffer head).
class BitVectorGetBufferBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Buffer wrapping _Bytes

  BitVectorGetBufferBenchmark(this.n) : super('bitvec-get-buffer-$n');

  @override
  void setup() => bv = BitVector.high(n * 8).bufferBy();

  @override
  void run() => bv.get(n * 4);
}

// ─── Drop ─────────────────────────────────────────────────────────────────────

/// Drop byte-aligned bits from a _Bytes node (returns a new _Bytes).
class BitVectorDropByteAlignedBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Bytes

  BitVectorDropByteAlignedBenchmark(this.n) : super('bitvec-drop-aligned-$n');

  @override
  void setup() => bv = BitVector.high(n * 8);

  @override
  void run() => bv.drop(n * 4); // byte-aligned → slices ByteVector
}

/// Drop non-byte-aligned bits from _Bytes (creates a _Drop node cheaply).
class BitVectorDropUnalignedBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Bytes

  BitVectorDropUnalignedBenchmark(this.n) : super('bitvec-drop-unaligned-$n');

  @override
  void setup() => bv = BitVector.high(n * 8 + 5);

  @override
  void run() => bv.drop(5); // non-aligned → wraps in _Drop
}

/// Drop from an existing _Drop node (stacks a second offset).
class BitVectorDropFromDropBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Drop

  BitVectorDropFromDropBenchmark(this.n) : super('bitvec-drop-drop-$n');

  @override
  void setup() => bv = BitVector.high(n * 8 + 5).drop(5);

  @override
  void run() => bv.drop(3); // _Drop.drop stacks offsets
}

/// Drop from a _Chunks tree (walks the append tree to find the split point).
class BitVectorDropChunksBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Chunks

  BitVectorDropChunksBenchmark(this.n) : super('bitvec-drop-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n * 8);

  @override
  void run() => bv.drop(n * 4);
}

// ─── Take ─────────────────────────────────────────────────────────────────────

/// Take bits from a _Bytes node (trims the size field).
class BitVectorTakeBytesBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Bytes

  BitVectorTakeBytesBenchmark(this.n) : super('bitvec-take-bytes-$n');

  @override
  void setup() => bv = BitVector.high(n * 8);

  @override
  void run() => bv.take(n * 4);
}

/// Take bits from a _Drop node.
class BitVectorTakeDropBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Drop

  BitVectorTakeDropBenchmark(this.n) : super('bitvec-take-drop-$n');

  @override
  void setup() => bv = BitVector.high(n * 8 + 5).drop(5);

  @override
  void run() => bv.take(n * 4);
}

/// Take bits from a _Chunks tree (traverses the append tree from the left).
class BitVectorTakeChunksBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Chunks

  BitVectorTakeChunksBenchmark(this.n) : super('bitvec-take-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n * 8);

  @override
  void run() => bv.take(n * 4);
}

// ─── Bytes (align / materialize) ──────────────────────────────────────────────

/// .bytes on a _Bytes node — already contiguous, nearly free.
class BitVectorBytesBytesBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Bytes

  BitVectorBytesBytesBenchmark(this.n) : super('bitvec-bytes-bytes-$n');

  @override
  void setup() => bv = BitVector.high(n * 8);

  @override
  void run() => bv.bytes;
}

/// .bytes on a _Drop node — must call interpretDrop() to shift bits.
class BitVectorBytesDropBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Drop

  BitVectorBytesDropBenchmark(this.n) : super('bitvec-bytes-drop-$n');

  @override
  void setup() => bv = BitVector.high(n * 8 + 5).drop(5);

  @override
  void run() => bv.bytes;
}

/// .bytes on a _Chunks tree — must compact the entire append tree.
class BitVectorBytesChunksBenchmark extends BenchmarkBase {
  final int n;
  late BitVector bv; // _Chunks

  BitVectorBytesChunksBenchmark(this.n) : super('bitvec-bytes-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n * 8);

  @override
  void run() => bv.bytes;
}
