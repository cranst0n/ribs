import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_binary/ribs_binary.dart';

// Builds a _Chunks tree by concating [chunkSize]-byte _Chunk nodes, then
// calling unbuffer() after each step so the outer _Buffer is stripped away.
// The result is a _Chunks node wrapping nested _Append nodes.
ByteVector _buildBvChunks(int totalBytes, [int chunkSize = 8]) {
  if (totalBytes <= chunkSize) return ByteVector.fill(totalBytes, 0xff);

  var bv = ByteVector.fill(chunkSize, 0xff);
  var i = chunkSize;
  while (i < totalBytes) {
    final s = (i + chunkSize <= totalBytes) ? chunkSize : (totalBytes - i);
    // unbuffer() strips the _Buffer wrapper so we accumulate _Chunks nodes.
    bv = bv.concat(ByteVector.fill(s, 0xff)).unbuffer();
    i += s;
  }
  return bv;
}

// ─── Concat ───────────────────────────────────────────────────────────────────

/// Concat two _Chunk leaf nodes.
/// Result: _Buffer(_Chunks(_Append(_Chunk, _Chunk)), empty lastChunk)
class ByteVectorConcatChunkBenchmark extends BenchmarkBase {
  final int n; // bytes
  late ByteVector left;
  late ByteVector right;

  ByteVectorConcatChunkBenchmark(this.n) : super('bytevec-concat-chunk-$n');

  @override
  void setup() {
    left = ByteVector.fill(n ~/ 2, 0xff);
    right = ByteVector.fill(n ~/ 2, 0x00);
  }

  @override
  void run() => left.concat(right);
}

/// Concat a _Chunk leaf onto an existing _Chunks tree.
/// Exercises the _Chunks.concat rebalancing path.
class ByteVectorConcatChunksBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector left; // _Chunks
  late ByteVector right; // _Chunk

  ByteVectorConcatChunksBenchmark(this.n) : super('bytevec-concat-chunks-$n');

  @override
  void setup() {
    left = _buildBvChunks(n);
    right = ByteVector.fill(8, 0xaa);
  }

  @override
  void run() => left.concat(right);
}

// ─── Get ──────────────────────────────────────────────────────────────────────

/// Get a byte from a _Chunk node (direct array lookup).
class ByteVectorGetChunkBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunk

  ByteVectorGetChunkBenchmark(this.n) : super('bytevec-get-chunk-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff);

  @override
  void run() => bv.get(n ~/ 2);
}

/// Get a byte from a _Chunks tree (must walk the append structure).
class ByteVectorGetChunksBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunks

  ByteVectorGetChunksBenchmark(this.n) : super('bytevec-get-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n);

  @override
  void run() => bv.get(n ~/ 2);
}

/// Get a byte from a _Buffer node (dispatches through buffer head).
class ByteVectorGetBufferBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Buffer wrapping _Chunk

  ByteVectorGetBufferBenchmark(this.n) : super('bytevec-get-buffer-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff).bufferBy(64);

  @override
  void run() => bv.get(n ~/ 2);
}

// ─── Drop ─────────────────────────────────────────────────────────────────────

/// Drop bytes from a _Chunk node (slices the underlying _View).
class ByteVectorDropChunkBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunk

  ByteVectorDropChunkBenchmark(this.n) : super('bytevec-drop-chunk-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff);

  @override
  void run() => bv.drop(n ~/ 2);
}

/// Drop bytes from a _Chunks tree (iterative tree traversal).
class ByteVectorDropChunksBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunks

  ByteVectorDropChunksBenchmark(this.n) : super('bytevec-drop-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n);

  @override
  void run() => bv.drop(n ~/ 2);
}

/// Drop bytes from a _Buffer node.
class ByteVectorDropBufferBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Buffer

  ByteVectorDropBufferBenchmark(this.n) : super('bytevec-drop-buffer-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff).bufferBy(64);

  @override
  void run() => bv.drop(n ~/ 2);
}

// ─── Take ─────────────────────────────────────────────────────────────────────

/// Take bytes from a _Chunk node (trims the _View).
class ByteVectorTakeChunkBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunk

  ByteVectorTakeChunkBenchmark(this.n) : super('bytevec-take-chunk-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff);

  @override
  void run() => bv.take(n ~/ 2);
}

/// Take bytes from a _Chunks tree (walks left side of append tree).
class ByteVectorTakeChunksBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunks

  ByteVectorTakeChunksBenchmark(this.n) : super('bytevec-take-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n);

  @override
  void run() => bv.take(n ~/ 2);
}

/// Take bytes from a _Buffer node.
class ByteVectorTakeBufferBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Buffer

  ByteVectorTakeBufferBenchmark(this.n) : super('bytevec-take-buffer-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff).bufferBy(64);

  @override
  void run() => bv.take(n ~/ 2);
}

// ─── toByteArray (materialize) ────────────────────────────────────────────────

/// Materialize a _Chunk to a raw Uint8List (single memcopy).
class ByteVectorToByteArrayChunkBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunk

  ByteVectorToByteArrayChunkBenchmark(this.n) : super('bytevec-tobytes-chunk-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff);

  @override
  void run() => bv.toByteArray();
}

/// Materialize a _Chunks tree (must traverse all leaves and memcopy each).
class ByteVectorToByteArrayChunksBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Chunks

  ByteVectorToByteArrayChunksBenchmark(this.n) : super('bytevec-tobytes-chunks-$n');

  @override
  void setup() => bv = _buildBvChunks(n);

  @override
  void run() => bv.toByteArray();
}

/// Materialize a _Buffer (delegates through unbuffer then traverses).
class ByteVectorToByteArrayBufferBenchmark extends BenchmarkBase {
  final int n;
  late ByteVector bv; // _Buffer

  ByteVectorToByteArrayBufferBenchmark(this.n) : super('bytevec-tobytes-buffer-$n');

  @override
  void setup() => bv = ByteVector.fill(n, 0xff).bufferBy(64);

  @override
  void run() => bv.toByteArray();
}
