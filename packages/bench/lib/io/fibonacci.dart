import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_effect/ribs_effect.dart';

final fibonacciN = BigInt.from(1000000);

final class FibonacciFutureBenchmark extends AsyncBenchmarkBase {
  FibonacciFutureBenchmark() : super('fibonacci-future');

  @override
  Future<void> run() {
    return fibonacciFuture(fibonacciN, BigInt.zero, BigInt.one);
  }

  Future<BigInt> fibonacciFuture(BigInt n, BigInt a, BigInt b) {
    return Future(() => a + b).then((b2) {
      return n > BigInt.zero ? fibonacciFuture(n - BigInt.one, b, b2) : Future.value(b2);
    });
  }
}

final class FibonacciIOBenchmark extends AsyncBenchmarkBase {
  FibonacciIOBenchmark() : super('fibonacci-io');

  @override
  Future<void> run() {
    return fibonacciIO(fibonacciN, BigInt.zero, BigInt.one).unsafeRunFuture();
  }

  IO<BigInt> fibonacciIO(BigInt n, BigInt a, BigInt b) {
    return IO.delay(() => a + b).flatMap((b2) {
      return n > BigInt.zero ? fibonacciIO(n - BigInt.one, b, b2) : IO.pure(b2);
    });
  }
}
