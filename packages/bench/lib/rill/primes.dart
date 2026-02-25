import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

const primesN = 1000000;

class StreamPrimesBenchmark extends AsyncBenchmarkBase {
  StreamPrimesBenchmark() : super('stream-primes', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async {
    final primes = sieve(numbers(2)).take(primesN);
    await primes.drain<void>();
  }

  Stream<int> numbers(int start) async* {
    var n = start;
    while (true) {
      yield n++;
    }
  }

  Stream<int> sieve(Stream<int> nums) async* {
    final primes = <int>[];

    await for (final n in nums) {
      bool isPrime = true;

      for (int i = 0; i < primes.length; i++) {
        final p = primes[i];

        if (p * p > n) break;
        if (n % p == 0) {
          isPrime = false;
          break;
        }
      }

      if (isPrime) {
        primes.add(n);
        yield n;
      }
    }
  }
}

class RillPrimesBenchmark extends AsyncBenchmarkBase {
  RillPrimesBenchmark() : super('rill-primes', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async {
    final numbers = Rill.range(2, Integer.MaxValue);
    final primes = sieve(numbers.pull.echo).rillNoScope.take(primesN);
    await primes.compile.drain.unsafeRunFuture();
  }

  Pull<int, Unit> sieve(Pull<int, Unit> pull) {
    final primes = <int>[];

    return pull.unconsFlatMap((chunk) {
      if (chunk.isEmpty) return Pull.done;

      final out = <int>[];

      for (int j = 0; j < chunk.length; j++) {
        final n = chunk[j];
        bool isPrime = true;

        for (int i = 0; i < primes.length; i++) {
          final p = primes[i];
          if (p * p > n) break;
          if (n % p == 0) {
            isPrime = false;
            break;
          }
        }

        if (isPrime) {
          primes.add(n);
          out.add(n);
        }
      }

      return Pull.output(Chunk.fromList(out));
    });
  }
}
