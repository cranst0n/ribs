// ignore_for_file: avoid_print

import 'package:ribs_bench/binary/bit_vector.dart';
import 'package:ribs_bench/binary/byte_vector.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  // n is in bytes; BitVector benchmarks operate on n*8 bits.
  const ns = [8, 128, 8192];

  for (final n in ns) {
    print('=== BitVector / n=$n bytes (${n * 8} bits) ===\n');

    RibsBenchmark.runAndReport([
      BitVectorConcatBytesBenchmark(n),
      BitVectorConcatChunksBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      BitVectorGetBytesBenchmark(n),
      BitVectorGetDropBenchmark(n),
      BitVectorGetChunksBenchmark(n),
      BitVectorGetBufferBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      BitVectorDropByteAlignedBenchmark(n),
      BitVectorDropUnalignedBenchmark(n),
      BitVectorDropFromDropBenchmark(n),
      BitVectorDropChunksBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      BitVectorTakeBytesBenchmark(n),
      BitVectorTakeDropBenchmark(n),
      BitVectorTakeChunksBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      BitVectorBytesBytesBenchmark(n),
      BitVectorBytesDropBenchmark(n),
      BitVectorBytesChunksBenchmark(n),
    ]);
  }

  for (final n in ns) {
    print('=== ByteVector / n=$n bytes ===\n');

    RibsBenchmark.runAndReport([
      ByteVectorConcatChunkBenchmark(n),
      ByteVectorConcatChunksBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      ByteVectorGetChunkBenchmark(n),
      ByteVectorGetChunksBenchmark(n),
      ByteVectorGetBufferBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      ByteVectorDropChunkBenchmark(n),
      ByteVectorDropChunksBenchmark(n),
      ByteVectorDropBufferBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      ByteVectorTakeChunkBenchmark(n),
      ByteVectorTakeChunksBenchmark(n),
      ByteVectorTakeBufferBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      ByteVectorToByteArrayChunkBenchmark(n),
      ByteVectorToByteArrayChunksBenchmark(n),
      ByteVectorToByteArrayBufferBenchmark(n),
    ]);
  }
}
