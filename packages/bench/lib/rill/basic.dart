import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_rill/ribs_rill.dart';

const basicN = 1000000;

class StreamBasicBenchmark extends AsyncBenchmarkBase {
  StreamBasicBenchmark() : super('stream-basic', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async {
    final stream = Stream.fromIterable(
      Iterable.generate(basicN, (i) => i).map((x) => x * 2).where((x) => x % 3 == 0),
    );

    await for (final _ in stream) {}
  }
}

class RillBasicBenchmark extends AsyncBenchmarkBase {
  RillBasicBenchmark() : super('rill-basic', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async {
    final rill = Rill.range(0, basicN).map((x) => x * 2).filter((x) => x % 3 == 0);

    await rill.compile.drain.unsafeRunFuture();
  }
}
