import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int attemptHappyN = 10000;

class FutureAttemptHappyBenchmark extends AsyncBenchmarkBase {
  FutureAttemptHappyBenchmark() : super('future-attempt-happy');

  @override
  Future<void> run() =>
      Future(() => 0).catchError((error, stackTrace) => Future.value(0)).replicate_(attemptHappyN);
}

class RibsAttemptHappyBenchmark extends AsyncBenchmarkBase {
  RibsAttemptHappyBenchmark() : super('ribs-attempt-happy');

  @override
  Future<void> run() => IO.pure(0).attempt().replicate_(attemptHappyN).unsafeRunFuture();
}

extension<A> on Future<A> {
  Future<Unit> replicate_(int n) => n <= 0 ? Future.value(Unit()) : then((_) => replicate_(n - 1));
}
