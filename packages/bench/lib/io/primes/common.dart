import 'dart:math';

const searchLimit = 100000000;
const chunkSize = 10000;

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
