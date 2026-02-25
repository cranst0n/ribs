import 'package:benchmark_harness/benchmark_harness.dart';

class RibsBenchmarkEmitter extends PrintEmitter {
  @override
  void emit(String name, double value) {
    final namePadded = name.padLeft(35);
    final valuePadded = value.toStringAsFixed(2).padLeft(12);

    // ignore: avoid_print
    print('$namePadded $valuePadded us');
  }
}
