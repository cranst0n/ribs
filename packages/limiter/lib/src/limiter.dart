import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart' hide Queue;
import 'package:ribs_limiter/src/internal/barrier.dart';
import 'package:ribs_limiter/src/internal/queue.dart';
import 'package:ribs_limiter/src/internal/task.dart';
import 'package:ribs_limiter/src/internal/timer.dart';

/// Thrown when a job cannot be enqueued because the limiter's maximum
/// queue size has been reached.
final class LimitReachedException implements Exception {}

/// A rate limiter that controls the throughput and concurrency of submitted
/// [IO] jobs.
///
/// Jobs are queued and executed according to a minimum interval between
/// dispatches and a maximum concurrency limit. Both parameters can be
/// adjusted at runtime.
///
/// Create a limiter with [Limiter.start], which returns a [Resource] that
/// manages the background executor fiber.
abstract class Limiter {
  /// Creates and starts a [Limiter] as a [Resource].
  ///
  /// - [minInterval]: minimum delay between dispatching consecutive jobs.
  /// - [maxConcurrent]: maximum number of jobs running at once (default:
  ///   unbounded).
  /// - [maxQueued]: maximum number of jobs waiting in the queue (default:
  ///   unbounded). Throws [LimitReachedException] if exceeded.
  ///
  /// The [Resource] manages the background executor — when released, the
  /// executor is cancelled and all pending jobs are abandoned.
  static Resource<Limiter> start(
    Duration minInterval, {
    int? maxConcurrent,
    int? maxQueued,
  }) {
    final maxConcurrent0 = maxConcurrent ?? Integer.maxValue;
    final maxQueued0 = maxQueued ?? Integer.maxValue;

    assert(maxQueued0 > 0, "maxQueued must be > 0, was $maxQueued");
    assert(maxConcurrent0 > 0, "maxConcurrent must be > 0, was $maxConcurrent");

    final resources =
        (
          Resource.eval(Queue.create<IO<Unit>>(maxQueued0)),
          Resource.eval(Barrier.create(maxConcurrent0)),
          Resource.eval(Timer.create(minInterval)),
          Supervisor.create(),
        ).tupled;

    return resources.flatMapN((queue, barrier, timer, supervisor) {
      final limiter = LimiterImpl(queue, barrier, timer, supervisor);

      IO<Unit> executor() {
        IO<Unit> go(IO<Unit> fa) {
          // IO.unit to make sure we exit the barrier even if fa is canceled before getting executed
          final job = IO.unit.productR(fa).guarantee(barrier.exit());

          return supervisor
              .supervise(job)
              .productR(timer.sleep)
              .productR(barrier.enter())
              .productR(queue.dequeue().flatMap(go));
        }

        return barrier.enter().productR(queue.dequeue().flatMap(go));
      }

      return executor().background().as(limiter);
    });
  }

  /// Submits [job] to the limiter's queue for execution.
  ///
  /// The job is enqueued with the given [priority] (higher values are
  /// dispatched first; default is 0). Returns an [IO] that completes with
  /// the job's result once it finishes. Cancelling the returned [IO]
  /// cancels the job (removing it from the queue or interrupting it if
  /// already running).
  IO<A> submit<A>(
    IO<A> job, {
    int priority = 0,
  });

  /// The number of jobs currently waiting in the queue.
  IO<int> get pending;

  /// The current minimum interval between job dispatches.
  IO<Duration> get minInterval;

  /// Sets the minimum interval to [newMinInterval].
  IO<Unit> setMinInterval(Duration newMinInterval);

  /// Atomically updates the minimum interval by applying [update].
  IO<Unit> updateMinInterval(Function1<Duration, Duration> update);

  /// The current maximum number of concurrently running jobs.
  IO<int> get maxConcurrent;

  /// Sets the maximum concurrency to [newMaxConcurrent].
  IO<Unit> setMaxConcurrent(int newMaxConcurrent);

  /// Atomically updates the maximum concurrency by applying [update].
  IO<Unit> updateMaxConcurrent(Function1<int, int> update);
}

class LimiterImpl extends Limiter {
  final Queue<IO<Unit>> queue;
  final Barrier barrier;
  final Timer timer;
  final Supervisor supervisor;

  LimiterImpl(
    this.queue,
    this.barrier,
    this.timer,
    this.supervisor,
  );

  @override
  IO<int> get maxConcurrent => barrier.limit;

  @override
  IO<Duration> get minInterval => timer.interval;

  @override
  IO<int> get pending => queue.size;

  @override
  IO<Unit> setMaxConcurrent(int newMaxConcurrent) => barrier.setLimit(newMaxConcurrent);

  @override
  IO<Unit> setMinInterval(Duration newMinInterval) => timer.setInterval(newMinInterval);

  @override
  IO<A> submit<A>(IO<A> job, {int priority = 0}) {
    return IO.uncancelable((poll) {
      return Task.create(job).flatMap((task) {
        return queue.enqueue(task.executable, priority: priority).flatMap((id) {
          final propogateCancelation = queue.delete(id).flatMap((deleted) {
            // task has already be dequeued and running
            return task.cancel.whenA(!deleted);
          });

          return poll(task.awaitResult).onCancel(propogateCancelation);
        });
      });
    });
  }

  @override
  IO<Unit> updateMaxConcurrent(Function1<int, int> update) => barrier.updateLimit(update);

  @override
  IO<Unit> updateMinInterval(Function1<Duration, Duration> update) => timer.updateInterval(update);
}
