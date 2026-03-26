import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

final class Task<A> {
  final IO<A> task;
  final Deferred<Outcome<A>> result;
  final Deferred<Unit> stopSignal;

  static IO<Task<A>> create<A>(IO<A> fa) {
    return (
      Deferred.of<Outcome<A>>(),
      Deferred.of<Unit>(),
    ).mapN((result, stopSignal) => Task._(fa, result, stopSignal));
  }

  const Task._(
    this.task,
    this.result,
    this.stopSignal,
  );

  IO<Unit> get executable => IO.uncancelable((poll) {
    return poll(
      IO.racePair(task, stopSignal.value()),
    ).onCancel(result.complete(Outcome.canceled()).voided()).flatMap((winner) {
      return winner.fold(
        (taskWon) {
          final (taskResult, waitForStopSignal) = taskWon;
          return waitForStopSignal.cancel().productR(() => result.complete(taskResult)).voided();
        },
        (cancelWon) {
          final (runningTask, _) = cancelWon;

          return runningTask
              .cancel()
              .productR(() => runningTask.join().flatMap((oc) => result.complete(oc)))
              .voided();
        },
      );
    });
  });

  IO<Unit> get cancel =>
      IO.uncancelable((_) => stopSignal.complete(Unit()).productR(() => result.value().voided()));

  IO<A> get awaitResult =>
      result.value().flatMap((value) => value.embed(IO.canceled.productR(() => IO.never())));
}
