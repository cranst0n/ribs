import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int flatMapN = 10000;

class FutureFlatmapBenchmark extends AsyncBenchmarkBase {
  FutureFlatmapBenchmark() : super('future-flatmap');

  @override
  Future<void> run() => Future.value(0).replicate_(flatMapN);
}

class RibsFlatmapBenchmark extends AsyncBenchmarkBase {
  RibsFlatmapBenchmark() : super('ribs-flatmap');

  @override
  Future<void> run() => IO.pure(0).replicate_(flatMapN).unsafeRunFuture();
}

extension<A> on Future<A> {
  Future<Unit> replicate_(int n) => n <= 0 ? Future.value(Unit()) : then((_) => replicate_(n - 1));
}
