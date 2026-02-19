// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ribs_bench/io/primes/common.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

void main(List<String> args) async {
  final primes = await segmentedSieveFuture(searchLimit, chunkSize).unsafeRunFuture();
  print('[future] Found ${primes.length} primes');
}

IO<List<int>> segmentedSieveFuture(int limit, int chunkSize) {
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
      .parSequence()
      .map((chunks) => chunks.foreach(allPrimes.addAll))
      .as(allPrimes);
}
