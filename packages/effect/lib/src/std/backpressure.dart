import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A concurrency primitive that limits the rate of effect execution.
///
/// [Backpressure] wraps an [IO] effect with a [Semaphore]-based gate. When
/// the concurrency limit ([bound]) is reached, the behavior depends on the
/// chosen [BackpressureStategy]:
///
/// - [BackpressureStategy.lossy]: excess calls return [None] immediately,
///   dropping the work.
/// - [BackpressureStategy.lossless]: excess calls block (semantically) until
///   a permit becomes available.
abstract class Backpressure {
  /// Creates a [Backpressure] with the given [strategy] and concurrency
  /// [bound].
  static IO<Backpressure> create(BackpressureStategy strategy, int bound) =>
      Semaphore.permits(bound).map(
        (sem) => switch (strategy) {
          BackpressureStategy.lossy => _BackpressureLossy(bound, sem),
          BackpressureStategy.lossless => _BackpressureLossless(bound, sem),
        },
      );

  /// Creates a lossless [Backpressure] that blocks when the [bound] is reached.
  static IO<Backpressure> lossless(int bound) => create(BackpressureStategy.lossless, bound);

  /// Creates a lossy [Backpressure] that drops work when the [bound] is
  /// reached.
  static IO<Backpressure> lossy(int bound) => create(BackpressureStategy.lossy, bound);

  /// Runs [io] if a permit is available, returning [Some] with the result.
  ///
  /// Behavior when no permit is available depends on the strategy:
  /// - **Lossy**: returns [None] immediately.
  /// - **Lossless**: blocks until a permit is available, then runs [io].
  IO<Option<A>> metered<A>(IO<A> io);
}

/// The strategy used by [Backpressure] when the concurrency limit is reached.
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
