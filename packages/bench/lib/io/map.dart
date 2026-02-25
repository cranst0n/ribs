import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_effect/ribs_effect.dart';

const mapN = 10000;

class FutureMapBenchmark extends AsyncBenchmarkBase {
  FutureMapBenchmark() : super('future-map');

  @override
  Future<void> run() {
    Future<int> fut = Future.value(0);
    for (int i = 0; i < mapN; i++) {
      fut = fut.then((a) => a + 1);
    }

    return fut;
  }
}

class RibsMapBenchmark extends AsyncBenchmarkBase {
  RibsMapBenchmark() : super('io-map');

  @override
  Future<void> run() {
    IO<int> io = IO.pure(0);
    for (int i = 0; i < mapN; i++) {
      io = io.map((a) => a + 1);
    }

    return io.unsafeRunFuture();
  }
}

class FpdartMapBenchmark extends AsyncBenchmarkBase {
  late fpdart.Task<int> task;

  FpdartMapBenchmark() : super('fpdart-map') {
    task = fpdart.Task.of(0);
    for (int i = 0; i < mapN; i++) {
      task = task.map((a) => a + 1);
    }
  }

  @override
  Future<void> run() => task.run();
}
