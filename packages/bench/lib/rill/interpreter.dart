import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

class RillRangeMapFilter extends AsyncBenchmarkBase {
  RillRangeMapFilter() : super('RillRangeMapFilter (50M)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 50000000).map((x) => x * 2).filter((x) => x % 3 == 0);
    return rill.compile.last.unsafeRunFuture();
  }
}

class RillFlatMapNested extends AsyncBenchmarkBase {
  RillFlatMapNested() : super('RillFlatMapNested (1M x 50)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 1000000).flatMap((x) => Rill.range(0, 50));
    return rill.compile.drain.unsafeRunFuture();
  }
}

class RillEvalLoop extends AsyncBenchmarkBase {
  RillEvalLoop() : super('RillEvalLoop (10M)');

  @override
  Future<void> run() {
    final rill = Rill.repeatEval(IO.pure(1)).take(10000000);
    return rill.compile.drain.unsafeRunFuture();
  }
}

class RillScopeNested extends AsyncBenchmarkBase {
  RillScopeNested() : super('RillScopeNested (1M)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 1000000).flatMap((x) => Rill.emit(x).scope);
    return rill.compile.drain.unsafeRunFuture();
  }
}

/// Exercises compile.fold which calls chunk.foldLeft per chunk.
/// Represents real-world numeric aggregation (sum, count, statistics).
class RillSumRange extends AsyncBenchmarkBase {
  RillSumRange() : super('RillSumRange (10M)');

  @override
  Future<void> run() {
    return Rill.range(0, 10000000)
        .compile
        .fold(0, (acc, x) => acc + x)
        .unsafeRunFuture();
  }
}

/// Exercises chunk.scanLeftCarry which uses chunk.foreach internally.
/// Represents real-world running-total / prefix-sum patterns.
class RillScanRange extends AsyncBenchmarkBase {
  RillScanRange() : super('RillScanRange (1M)');

  @override
  Future<void> run() {
    return Rill.range(0, 1000000)
        .scan(0, (acc, x) => acc + x)
        .compile
        .last
        .unsafeRunFuture();
  }
}

/// Exercises _SliceChunk.map via mapChunks + Chunk.take.
/// Represents real-world windowed / partial-batch processing
/// (e.g. take first N items from each page of results, then transform).
class RillSlicedMap extends AsyncBenchmarkBase {
  RillSlicedMap() : super('RillSlicedMap (1M)');

  @override
  Future<void> run() {
    // mapChunks + take creates _SliceChunk; subsequent map operates on it
    return Rill.range(0, 1000000)
        .mapChunks((c) => c.take(c.size ~/ 2))
        .map((x) => x * 2)
        .compile
        .drain
        .unsafeRunFuture();
  }
}

Future<void> main() async {
  await RillRangeMapFilter().report();
  await RillFlatMapNested().report();
  await RillEvalLoop().report();
  await RillScopeNested().report();
  await RillSumRange().report();
  await RillScanRange().report();
  await RillSlicedMap().report();
}
