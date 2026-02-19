// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ribs_bench/io/primes/common.dart';

void main(List<String> args) async {
  final primes = await segmentedSieveFuture(searchLimit, chunkSize);
  print('[future] Found ${primes.length} primes');
}

Future<List<int>> segmentedSieveFuture(int limit, int chunkSize) async {
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
