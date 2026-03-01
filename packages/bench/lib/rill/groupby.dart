// ignore_for_file: avoid_print

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_rill/ribs_rill.dart';

// Adjacent-grouping over a sorted integer stream.
//
// Each integer is bucketed by (value ~/ groupBySize), so consecutive runs
// of groupBySize elements share the same key, producing N ~/ groupBySize
// groups total. This pattern arises naturally when processing sorted logs,
// time-bucketed events, or paginated results.
//
// Stream: a hand-rolled async* generator that buffers elements and yields
// (key, List<int>) whenever the key changes — one allocation per group.
//
// Rill: groupAdjacentBy, which walks chunks rather than individual elements,
// splitting and combining chunk slices without per-element allocation.

const groupByN = 500000;
const groupBySize = 100; // → 5,000 groups of 100 elements each

class StreamGroupByBenchmark extends AsyncBenchmarkBase {
  StreamGroupByBenchmark() : super('stream-groupby');

  @override
  Future<void> run() async {
    final source = Stream.fromIterable(Iterable.generate(groupByN, (i) => i));
    await for (final _ in _groupAdjacent(source)) {}
  }

  Stream<(int, List<int>)> _groupAdjacent(Stream<int> source) async* {
    int? currentKey;
    final buffer = <int>[];

    await for (final x in source) {
      final k = x ~/ groupBySize;
      if (currentKey == null || k == currentKey) {
        buffer.add(x);
        currentKey = k;
      } else {
        yield (currentKey, List<int>.from(buffer));
        buffer
          ..clear()
          ..add(x);
        currentKey = k;
      }
    }

    if (buffer.isNotEmpty) yield (currentKey!, List<int>.from(buffer));
  }
}

class RillGroupByBenchmark extends AsyncBenchmarkBase {
  RillGroupByBenchmark() : super('rill-groupby');

  @override
  Future<void> run() async {
    await Rill.range(
      0,
      groupByN,
    ).groupAdjacentBy((x) => x ~/ groupBySize).compile.drain.unsafeRunFuture();
  }
}
