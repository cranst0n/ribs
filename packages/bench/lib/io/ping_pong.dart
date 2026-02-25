import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const int pingPongN = 1000;

class FuturePingPongBenchmark extends AsyncBenchmarkBase {
  FuturePingPongBenchmark() : super('future-ping-pong');

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
  RibsPingPongBenchmark() : super('io-ping-pong');

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

class FpdartPingPongBenchmark extends AsyncBenchmarkBase {
  FpdartPingPongBenchmark() : super('fpdart-ping-pong');

  @override
  Future<fpdart.Unit> run() => _pingPong(pingPongN).run();

  fpdart.Task<fpdart.Unit> _pingPong(int n) {
    if (n <= 0) {
      return fpdart.Task.of(fpdart.unit);
    } else {
      return fpdart.Task(() async => await Future(() {})).andThen(() => _pingPong(n - 1));
    }
  }
}
