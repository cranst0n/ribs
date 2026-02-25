// ignore_for_file: avoid_print

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:chalkdart/chalk.dart';

// anything within this threshold (us) of the median will be dampened
const DampenThreshold = 20.0;
// anything within this percentage of the minimum will be dampened
const FloorThreshold = 0.05;

class RibsBenchmark extends PrintEmitter {
  final scores = <(String, double)>[];

  static void runAndReport(List<BenchmarkBase> benchmarks) {
    final emitter = RibsBenchmark();

    for (final bench in benchmarks) {
      _WrappedBenchmark(bench, bench.name, emitter: emitter).report();
    }

    emitter._printScores();
  }

  static Future<void> runAndReportAsync(List<AsyncBenchmarkBase> benchmarks) async {
    final emitter = RibsBenchmark();

    for (final bench in benchmarks) {
      await _WrappedAsyncBenchmark(bench, bench.name, emitter: emitter).report();
    }

    emitter._printScores();
  }

  @override
  void emit(String name, double value) {
    scores.add((name, value));
  }

  void _printScores() {
    if (scores.isNotEmpty) {
      final minValue = scores.map((t) => t.$2).reduce(min);
      final median = getMedian(scores.map((t) => t.$2).toList());

      // Calculate Median Absolute Deviation: how far, on average, are points from the median?
      final deviations = scores.map((t) => (t.$2 - median).abs()).toList();
      double mad = getMedian(deviations);

      // Provide a fallback based on a small percentage of the median to avoid division by zero
      if (mad == 0) mad = (median == 0) ? 1.0 : median * 0.1;

      for (final (name, value) in scores) {
        final namePadded = name.padLeft(35);
        final valuePadded = value.toStringAsFixed(2).padLeft(12);

        final colorize = _getChalk(value, minValue, median, mad);

        print(colorize('$namePadded $valuePadded us'));
      }

      print('');
    }
  }

  double getMedian(List<double> list) {
    final sorted = List<double>.from(list)..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2.0;
  }

  Chalk _getChalk(double value, double minValue, double median, double mad) {
    final distance = value - median;

    // Base statistical intensity (Z-score based)
    final z = (distance / mad).clamp(0.0, 3.5);
    double t = z / 3.5;

    // Significance Dampening (Distance from Median)
    if (distance < DampenThreshold && distance > 0) {
      t *= distance / DampenThreshold;
    } else if (distance <= 0) {
      t = 0;
    }

    // Check if the value is close to the minimum value and apply an additional dampening factor.
    final floorLimit = minValue * (1 + FloorThreshold);
    if (value <= floorLimit) {
      t *= 0.1;
    }

    // Calculate RGB
    int r;
    int g;

    if (t < 0.4) {
      r = (t / 0.4 * 255).toInt();
      g = 255;
    } else {
      final localT = (t - 0.4) / 0.6;
      r = 255;
      g = (255 - (localT * 200)).toInt();
    }

    return chalk.rgb(r, g, 0);
  }
}

class _WrappedBenchmark extends BenchmarkBase {
  final BenchmarkBase outer;

  _WrappedBenchmark(this.outer, super.name, {super.emitter});

  @override
  void setup() => outer.setup();

  @override
  void teardown() => outer.teardown();

  @override
  void run() => outer.run();
}

class _WrappedAsyncBenchmark extends AsyncBenchmarkBase {
  final AsyncBenchmarkBase outer;

  _WrappedAsyncBenchmark(this.outer, super.name, {super.emitter});

  @override
  Future<void> setup() => outer.setup();

  @override
  Future<void> teardown() => outer.teardown();

  @override
  Future<void> run() => outer.run();
}
