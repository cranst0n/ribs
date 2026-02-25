import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int attemptSadN = 10000;

class FutureAttemptSadBenchmark extends AsyncBenchmarkBase {
  FutureAttemptSadBenchmark() : super('future-attempt-sad', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() {
    Future<int> x = Future.value(0);

    for (int i = 0; i < attemptSadN; i++) {
      x = x.then((a) => (i == attemptSadN ~/ 2) ? Future.error('boom') : Future.value(a + 1));
    }

    return x.catchError((error, stackTrace) => Future.value(0));
  }
}

class RibsAttemptSadBenchmark extends AsyncBenchmarkBase {
  RibsAttemptSadBenchmark() : super('ribs-attempt-sad', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() {
    IO<int> x = IO.pure(0);

    for (int i = 0; i < attemptSadN; i++) {
      x = x.flatMap(
        (a) => (i == attemptSadN ~/ 2) ? IO.raiseError('boom') : IO.pure(a + 1),
      );
    }

    return x.attempt().unsafeRunFuture();
  }
}
