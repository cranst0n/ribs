import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// An internal wrapper around an [IO] job that provides cancellation and
/// result signalling for the limiter's executor.
final class Task<A> {
  final IO<A> task;
  final Deferred<Outcome<A>> result;
  final Deferred<Unit> stopSignal;

  /// Creates a [Task] wrapping [fa], with fresh [Deferred] values for
  /// result delivery and cancellation signalling.
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

  /// An [IO] that runs the task, races it against the [stopSignal], and
  /// completes [result] with the [Outcome].
  IO<Unit> get executable => IO.uncancelable((poll) {
    return poll(
      IO.racePair(task, stopSignal.value()),
    ).onCancel(result.complete(Outcome.canceled()).voided()).flatMap((winner) {
      return winner.fold(
        (taskWon) {
          final (taskResult, waitForStopSignal) = taskWon;
          return waitForStopSignal.cancel().productR(result.complete(taskResult)).voided();
        },
        (cancelWon) {
          final (runningTask, _) = cancelWon;

          return runningTask
              .cancel()
              .productR(runningTask.join().flatMap((oc) => result.complete(oc)))
              .voided();
        },
      );
    });
  });

  /// Signals the task to cancel, then waits for the result to be
  /// populated.
  IO<Unit> get cancel =>
      IO.uncancelable((_) => stopSignal.complete(Unit()).productR(result.value().voided()));

  /// Waits for the task's [Outcome] and re-raises errors or propagates
  /// cancellation.
  IO<A> get awaitResult =>
      result.value().flatMap((value) => value.embed(IO.canceled.productR(IO.never())));
}
