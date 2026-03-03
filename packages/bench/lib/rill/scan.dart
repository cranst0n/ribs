// ignore_for_file: avoid_print

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_rill/ribs_rill.dart';

// Running prefix-sum over N integers.
//
// Exercises how each implementation accumulates state across elements.
// Rill's scan operates on full Chunks at once (scanLeftCarry), producing
// one output element per input element but amortising allocation across
// the chunk. The Stream version must invoke the closure once per element
// with no chunk awareness.

const scanN = 1000000;

class StreamScanBenchmark extends AsyncBenchmarkBase {
  StreamScanBenchmark() : super('stream-scan');

  @override
  Future<void> run() async {
    var acc = 0;
    final stream = Stream.fromIterable(Iterable.generate(scanN, (i) => i)).map((x) => acc += x);

    await for (final _ in stream) {}
  }
}

class RillScanBenchmark extends AsyncBenchmarkBase {
  RillScanBenchmark() : super('rill-scan');

  @override
  Future<void> run() async {
    await Rill.range(0, scanN).scan(0, (acc, x) => acc + x).compile.drain.unsafeRunFuture();
  }
}
