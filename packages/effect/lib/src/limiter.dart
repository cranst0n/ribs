// import 'dart:collection';

// import 'package:ribs_core/ribs_core.dart';

// class RateLimiter {
//   final Duration interval;
//   final Ref<Option<DateTime>> nextAllowable;

//   final Queue<IO<Unit>> _pending;

//   RateLimiter._(this.interval, this.nextAllowable) : _pending = Queue();

//   IO<A> submit<A>(IO<A> job) {
//     IO<A> run() => nextAllowable
//         .setValue(Some(DateTime.now().add(interval)))
//         .productR(() => job);

//     final x = nextAllowable.value().flatMap((nextOpt) {
//       return nextOpt.fold(
//         () => run(),
//         (next) {
//           if (DateTime.now().isAfter(next)) {
//             return run();
//           } else {
//             return job.delayBy(next.difference(DateTime.now()));
//           }
//         },
//       );
//     });

//     return x;
//   }

//   static IO<RateLimiter> create(Duration interval) => Ref.of(none<DateTime>())
//       .map((nextAllowable) => RateLimiter._(interval, nextAllowable));
// }

// class Task<A> {
//   final IO<A> task;
//   final Deferred<Outcome<A>> result;
//   final Deferred<Unit> stopSignal;

//   Task._(this.task, this.result, this.stopSignal);

//   IO<A> awaitResult() => result.value().flatMap(
//       (outcome) => outcome.embed(IO.canceled.productR(() => IO.never())));

//   IO<Unit> cancel() => IO.uncancelable((_) =>
//       stopSignal.complete(Unit()).productR(() => result.value().voided()));

//   IO<Unit> executable() {
//     return IO.uncancelable((poll) {
//       return poll(IO.racePair(task, stopSignal.value()))
//           .onCancel(result.complete(Outcome.canceled()).voided())
//           .flatMap(
//             (winner) => winner.fold(
//               (aWon) {
//                 final (taskResult, waitForStopSignal) = aWon;

//                 return waitForStopSignal
//                     .cancel()
//                     .productR(() => result.complete(taskResult));
//               },
//               (bWon) {
//                 final (runningTask, _) = bWon;

//                 return runningTask.cancel().productR(
//                     () => runningTask.join().flatMap(result.complete));
//               },
//             ),
//           )
//           .voided();
//     });
//   }

//   static IO<Task<A>> create<A>(IO<A> ioa) => (
//         Deferred.of<Outcome<A>>(),
//         Deferred.of<Unit>()
//       ).mapN((res, ss) => Task._(ioa, res, ss));
// }

// typedef QueueId = IO<bool>;

// abstract class TaskQueue<A> {
//   IO<QueueId> enqueue(A a);
// }
