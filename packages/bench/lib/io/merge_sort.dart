import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_effect/ribs_effect.dart';

const mergeSortSize = 10000000;
const mergeSortThreshold = 10000;

class MergeSortFutureBenchmark extends AsyncBenchmarkBase {
  MergeSortFutureBenchmark() : super('merge-sort-future', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() => mergeSort(generateUnsortedList(), mergeSortThreshold);

  Future<List<int>> mergeSort(List<int> list, int threshold) async {
    if (list.length <= threshold) {
      final copy = List.of(list);
      copy.sort();
      return copy;
    } else {
      final mid = list.length ~/ 2;

      final left = list.sublist(0, mid);
      final right = list.sublist(mid);

      final leftTask = Future(() => mergeSort(left, threshold));
      final rightTask = Future(() => mergeSort(right, threshold));

      final results = await Future.wait([leftTask, rightTask]);

      return merge(results[0], results[1]);
    }
  }
}

class MergeSortIOBenchmark extends AsyncBenchmarkBase {
  MergeSortIOBenchmark() : super('merge-sort-io', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() => mergeSort(generateUnsortedList(), mergeSortThreshold).unsafeRunFuture();

  IO<List<int>> mergeSort(List<int> list, int threshold) {
    if (list.length <= threshold) {
      return IO.delay(() {
        final copy = List.of(list);
        copy.sort();
        return copy;
      });
    } else {
      final mid = list.length ~/ 2;

      final left = list.sublist(0, mid);
      final right = list.sublist(mid);

      final leftTask = mergeSort(left, threshold);
      final rightTask = mergeSort(right, threshold);

      return IO.both(leftTask, rightTask).mapN((l, r) => merge(l, r));
    }
  }
}

final _random = Random();
List<int> generateUnsortedList() => List.generate(mergeSortSize, (_) => _random.nextInt(1000000));

List<int> merge(List<int> left, List<int> right) {
  final result = <int>[];

  int i = 0;
  int j = 0;

  while (i < left.length && j < right.length) {
    if (left[i] < right[j]) {
      result.add(left[i++]);
    } else {
      result.add(right[j++]);
    }
  }

  while (i < left.length) {
    result.add(left[i++]);
  }

  while (j < right.length) {
    result.add(right[j++]);
  }

  return result;
}
