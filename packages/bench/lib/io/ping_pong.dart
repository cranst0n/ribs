import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int pingPongN = 1000;

class FuturePingPongBenchmark extends AsyncBenchmarkBase {
  FuturePingPongBenchmark() : super('future-ping-pong', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async => await _pingPong(pingPongN);

  Future<void> _pingPong(int n) async {
    if (n <= 0) {
      return;
    } else {
      await Future(() {});
      return _pingPong(n - 1);
    }
  }
}

class RibsPingPongBenchmark extends AsyncBenchmarkBase {
  RibsPingPongBenchmark() : super('ribs-ping-pong', emitter: RibsBenchmarkEmitter());

  @override
  Future<void> run() async => await _pingPong(pingPongN).unsafeRunFuture();

  IO<Unit> _pingPong(int n) {
    if (n <= 0) {
      return IO.unit;
    } else {
      return IO.cede.productR(() => _pingPong(n - 1));
    }
  }
}
