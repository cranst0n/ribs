import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int flatMapN = 10000;

class FutureFlatmapBenchmark extends AsyncBenchmarkBase {
  FutureFlatmapBenchmark() : super('future-flatmap', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() => Future.value(0).replicate_(flatMapN);
}

// Could build IO in the setup() method and just run it in run() to avoid
// the overhead of building it during the benchmark.
class RibsFlatmapBenchmark extends AsyncBenchmarkBase {
  RibsFlatmapBenchmark() : super('ribs-flatmap', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() => IO.pure(0).replicate_(flatMapN).unsafeRunFuture();
}

extension<A> on Future<A> {
  Future<Unit> replicate_(int n) => n <= 0 ? Future.value(Unit()) : then((_) => replicate_(n - 1));
}
