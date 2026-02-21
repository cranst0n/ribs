// ignore_for_file: avoid_print

import 'dart:async';
import 'package:benchmark_harness/benchmark_harness.dart';

Stream<int> numbers(int start) async* {
  int i = start;
  while (true) {
    yield i++;
  }
}

Stream<int> sieve(Stream<int> s) async* {
  final primes = <int>[];

  await for (final n in s) {
    bool isPrime = true;
    for (int i = 0; i < primes.length; i++) {
      final p = primes[i];
      if (p * p > n) break; // Optimization: only test up to sqrt(n)
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

class PrimeStreamBenchmark extends AsyncBenchmarkBase {
  PrimeStreamBenchmark() : super('Stream Primes (N=100)');

  @override
  Future<void> run() async {
    final primes = sieve(numbers(2)).take(100000);
    await primes.drain<void>();
  }
}

void main() async {
  print('Running Stream benchmark...');
  final res = await PrimeStreamBenchmark().measure();
  print('Stream: ${res.round()} us');

  // Print first 10 for validation
  final list = await sieve(numbers(2)).take(10).toList();
  print('First 10 primes: $list');
}
