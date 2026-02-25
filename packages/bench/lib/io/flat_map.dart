import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int flatMapN = 10000;

class FutureFlatmapBenchmark extends AsyncBenchmarkBase {
  FutureFlatmapBenchmark() : super('future-flatmap');

  @override
  Future<void> run() => Future.value(0).replicate_(flatMapN);
}

class RibsFlatmapBenchmark extends AsyncBenchmarkBase {
  RibsFlatmapBenchmark() : super('io-flatmap');

  @override
  Future<void> run() => IO.pure(0).replicate_(flatMapN).unsafeRunFuture();
}

class FpdartFlatmapBenchmark extends AsyncBenchmarkBase {
  FpdartFlatmapBenchmark() : super('fpdart-flatmap');

  @override
  Future<void> run() => fpdart.Task.of(0).replicate_(flatMapN).run();
}

extension<A> on Future<A> {
  Future<Unit> replicate_(int n) => n <= 0 ? Future.value(Unit()) : then((_) => replicate_(n - 1));
}

extension<A> on fpdart.Task<A> {
  fpdart.Task<Unit> replicate_(int n) =>
      n <= 0 ? fpdart.Task.of(Unit()) : flatMap((_) => replicate_(n - 1));
}
