import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_effect/ribs_effect.dart';

final fibonacciN = BigInt.from(1000000);

final class FibonacciFutureBenchmark extends AsyncBenchmarkBase {
  FibonacciFutureBenchmark() : super('future-fibonacci');

  @override
  Future<void> run() => fib(fibonacciN, BigInt.zero, BigInt.one);

  Future<BigInt> fib(BigInt n, BigInt a, BigInt b) {
    return Future(() => a + b).then((b2) {
      return n > BigInt.zero ? fib(n - BigInt.one, b, b2) : Future.value(b2);
    });
  }
}

final class FibonacciIOBenchmark extends AsyncBenchmarkBase {
  FibonacciIOBenchmark() : super('io-fibonacci');

  @override
  Future<void> run() => fib(fibonacciN, BigInt.zero, BigInt.one).unsafeRunFuture();

  IO<BigInt> fib(BigInt n, BigInt a, BigInt b) {
    return IO.delay(() => a + b).flatMap((b2) {
      return n > BigInt.zero ? fib(n - BigInt.one, b, b2) : IO.pure(b2);
    });
  }
}

final class FibonacciFpdartBenchmark extends AsyncBenchmarkBase {
  FibonacciFpdartBenchmark() : super('fpdart-fibonacci');

  @override
  Future<void> run() => fib(fibonacciN, BigInt.zero, BigInt.one).run();

  fpdart.Task<BigInt> fib(BigInt n, BigInt a, BigInt b) {
    return fpdart.Task(() => Future(() => a + b)).flatMap((b2) {
      return n > BigInt.zero ? fib(n - BigInt.one, b, b2) : fpdart.Task.of(b2);
    });
  }
}
