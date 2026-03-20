import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

final class LimitReachedException implements Exception {}

abstract class Limiter {
  static Resource<Limiter> start(
    Duration minInterval, {
    int? maxConcurrent,
    int? maxQueued,
  }) {
    final maxConcurrent0 = maxConcurrent ?? Integer.MaxValue;
    final maxQueued0 = maxQueued ?? Integer.MaxValue;

    assert(maxQueued0 > 0, "maxQueued must be > 0, was $maxQueued");
    assert(maxConcurrent0 > 0, "maxConcurrent must be > 0, was $maxConcurrent");

    throw UnimplementedError();
  }

  IO<A> submit<A>(
    IO<A> job, {
    int priority = 0,
  });

  IO<int> get pending;

  IO<Duration> get minInterval;

  IO<Unit> setMinInterval(Duration newMinInterval);

  IO<Unit> updateMinInterval(Function1<Duration, Duration> update);

  IO<int> get maxConcurrent;

  IO<Unit> setMaxConcurrent(int newMaxConcurrent);

  IO<Unit> updateMaxConcurrent(Function1<int, int> update);
}
