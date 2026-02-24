import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int primesSearchLimit = 1000000;
const int primesChunkSize = 10000;

final class FuturePrimesBenchmark extends AsyncBenchmarkBase {
  FuturePrimesBenchmark() : super('primes-future');

  @override
  Future<void> run() => segmentedSieve(primesSearchLimit, primesChunkSize);

  Future<List<int>> segmentedSieve(int limit, int chunkSize) async {
    final sqrtLimit = sqrt(limit).toInt();

    final basePrimes = getBasePrimes(limit);
    final allPrimes = List.of(basePrimes);

    final tasks = <Future<List<int>>>[];

    for (int low = sqrtLimit + 1; low <= limit; low += chunkSize) {
      final high = min(low + chunkSize - 1, limit);
      tasks.add(Future(() => sieveChunk(low, high, basePrimes)));
    }

    final results = await Future.wait(tasks);

    for (final chunk in results) {
      allPrimes.addAll(chunk);
    }

    return allPrimes;
  }
}

final class RibsPrimesBenchmark extends AsyncBenchmarkBase {
  RibsPrimesBenchmark() : super('primes-ribs');

  @override
  Future<void> run() => segmentedSieve(primesSearchLimit, primesChunkSize).unsafeRunFuture();

  IO<List<int>> segmentedSieve(int limit, int chunkSize) {
    final sqrtLimit = sqrt(limit).toInt();

    final basePrimes = getBasePrimes(limit);
    final allPrimes = List.of(basePrimes);

    final tasks = <IO<List<int>>>[];

    for (int low = sqrtLimit + 1; low <= limit; low += chunkSize) {
      final high = min(low + chunkSize - 1, limit);
      tasks.add(IO.delay(() => sieveChunk(low, high, basePrimes)));
    }

    return tasks
        .toIList()
        .sequence()
        .map((chunks) => chunks.foreach(allPrimes.addAll))
        .as(allPrimes);
  }
}

List<int> getBasePrimes(int limit) {
  final sqrtLimit = sqrt(limit).toInt();

  final isPrime = List.filled(sqrtLimit + 1, true);
  final primes = <int>[];

  for (int p = 2; p * p <= sqrtLimit; p++) {
    if (isPrime[p]) {
      for (int i = p * p; i <= sqrtLimit; i += p) {
        isPrime[i] = false;
      }
    }
  }

  for (int p = 2; p <= sqrtLimit; p++) {
    if (isPrime[p]) primes.add(p);
  }

  return primes;
}

List<int> sieveChunk(int start, int end, List<int> basePrimes) {
  final isPrime = List.filled(end - start + 1, true);

  for (final p in basePrimes) {
    int startIdx = (start ~/ p) * p;

    if (startIdx < start) startIdx += p;
    if (startIdx == p) startIdx += p;

    for (int j = startIdx; j <= end; j += p) {
      isPrime[j - start] = false;
    }
  }

  final chunkPrimes = <int>[];

  for (int i = 0; i < isPrime.length; i++) {
    if (isPrime[i] && (i + start) > 1) chunkPrimes.add(i + start);
  }

  return chunkPrimes;
}
