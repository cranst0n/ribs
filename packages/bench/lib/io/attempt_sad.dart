import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_effect/ribs_effect.dart';

// fpdart Task is not stack safe. Keep this number lower
const int attemptSadN = 5000;

class FutureAttemptSadBenchmark extends AsyncBenchmarkBase {
  FutureAttemptSadBenchmark() : super('future-attempt-sad');

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
  RibsAttemptSadBenchmark() : super('io-attempt-sad');

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

class FpdartAttemptSadBenchmark extends AsyncBenchmarkBase {
  late fpdart.TaskEither<Object, int> task;

  FpdartAttemptSadBenchmark() : super('fpdart-attempt-sad') {
    fpdart.TaskEither<Object, int> x = fpdart.TaskEither.of(0);
    for (int i = 0; i < attemptSadN; i++) {
      x = x.flatMap(
        (a) =>
            (i == attemptSadN ~/ 2) ? fpdart.TaskEither.left('boom') : fpdart.TaskEither.of(a + 1),
      );
    }

    task = x;
  }

  @override
  Future<void> run() => task.run();
}
