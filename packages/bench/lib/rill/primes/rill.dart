// ignore_for_file: avoid_print

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

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

class PrimeRillBenchmark extends AsyncBenchmarkBase {
  PrimeRillBenchmark() : super('Rill Primes (N=100)');

  @override
  Future<void> run() async {
    final numbers = Rill.range(2, Integer.MaxValue);
    final primes = sieve(numbers.pull.echo).rillNoScope.take(100000);
    await primes.compile.drain.unsafeRunFuture();
  }
}

void main() async {
  print('Running Rill benchmark...');
  final res = await PrimeRillBenchmark().measure();
  print('Rill: ${res.round()} us');

  // Print first 10 for validation
  final numbers = Rill.range(2, Integer.MaxValue);
  final list = await sieve(numbers.pull.echo).rillNoScope.take(10).compile.toList.unsafeRunFuture();
  print('First 10 primes: $list');
}
