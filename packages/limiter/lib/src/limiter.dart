import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart' hide Queue;
import 'package:ribs_limiter/src/internal/barrier.dart';
import 'package:ribs_limiter/src/internal/queue.dart';
import 'package:ribs_limiter/src/internal/task.dart';
import 'package:ribs_limiter/src/internal/timer.dart';

final class LimitReachedException implements Exception {}

abstract class Limiter {
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
