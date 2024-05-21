import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Backpressure {
  static IO<Backpressure> create(BackpressureStategy strategy, int bound) =>
      Semaphore.permits(bound).map(
        (sem) => switch (strategy) {
          BackpressureStategy.lossy => _BackpressureLossy(bound, sem),
          BackpressureStategy.lossless => _BackpressureLossless(bound, sem)
        },
      );

  static IO<Backpressure> lossless(int bound) =>
      create(BackpressureStategy.lossless, bound);

  static IO<Backpressure> lossy(int bound) =>
      create(BackpressureStategy.lossy, bound);

  IO<Option<A>> metered<A>(IO<A> io);
}

enum BackpressureStategy { lossy, lossless }

final class _BackpressureLossy extends Backpressure {
  final int bound;
  final Semaphore semaphore;

  _BackpressureLossy(
    this.bound,
    this.semaphore,
  ) : assert(bound > 0);

  @override
  IO<Option<A>> metered<A>(IO<A> io) => semaphore.tryAcquire().bracket(
        (acquired) => acquired ? io.map(Some.new) : IO.none<A>(),
        (acquired) => acquired ? semaphore.release() : IO.unit,
      );
}

final class _BackpressureLossless extends Backpressure {
  final int bound;
  final Semaphore semaphore;

  _BackpressureLossless(
    this.bound,
    this.semaphore,
  ) : assert(bound > 0);

  @override
  IO<Option<A>> metered<A>(IO<A> io) => semaphore.acquire().bracket(
        (_) => io.map(Some.new),
        (_) => semaphore.release(),
      );
}
