import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('Dispatcher.parallel', () {
    test('unsafeRunAndForget runs the IO', () {
      final test = Deferred.of<int>().flatMap((latch) {
        return Dispatcher.parallel().use((dispatcher) {
          return IO
              .delay(
                () => dispatcher.unsafeRunAndForget(IO.pure(42).flatMap(latch.complete).voided()),
              )
              .productR(() => latch.value());
        });
      });

      expect(test, ioSucceeded(42));
    });

    test('unsafeToFuture returns correct result', () {
      final test = Dispatcher.parallel().use((dispatcher) {
        return IO.fromFutureF(() => dispatcher.unsafeToFuture(IO.pure(99)));
      });

      expect(test, ioSucceeded(99));
    });

    test('unsafeToFuture propagates errors', () {
      final test = Dispatcher.parallel().use((dispatcher) {
        return IO.fromFutureF(
          () => dispatcher
              .unsafeToFuture(IO.raiseError<int>('boom'))
              .then((_) => -1, onError: (_) => -2),
        );
      });

      expect(test, ioSucceeded(-2));
    });

    test('unsafeToFutureCancelable can cancel in-flight effect', () {
      final test = Deferred.of<Unit>().flatMap((started) {
        return Dispatcher.parallel().use((dispatcher) {
          return IO
              .delay(() {
                final (future, cancel) = dispatcher.unsafeToFutureCancelable(
                  started.complete(Unit()).voided().productR(() => IO.never<int>()),
                );
                // Silence the future: it will reject once canceled.
                future.catchError((_) => 0);
                return cancel;
              })
              .flatMap((Function0<Future<Unit>> cancel) {
                return started.value().productR(() => IO.fromFutureF(cancel));
              });
        });
      });

      expect(test, ioSucceeded(Unit()));
    });

    test('multiple effects run concurrently', () {
      final test = Dispatcher.parallel().use((dispatcher) {
        return Deferred.of<Unit>().flatMap((gate) {
          // Both effects wait on the gate — if sequential, they would deadlock.
          final f1 = dispatcher.unsafeToFuture(gate.value().as(1));
          final f2 = dispatcher.unsafeToFuture(gate.value().as(2));

          return IO
              .fromFutureF(() => gate.complete(Unit()).unsafeRunFuture())
              .productR(
                () => IO.fromFutureF(
                  () async {
                    final results = await Future.wait([f1, f2]);
                    return results[0] + results[1];
                  },
                ),
              );
        });
      });

      expect(test, ioSucceeded(3));
    });

    test('waitForAll=true: finalization waits for active effects', () {
      final test = IO.ref(false).flatMap((done) {
        return Dispatcher.parallel(waitForAll: true)
            .use((dispatcher) {
              return IO.delay(() {
                dispatcher.unsafeRunAndForget(
                  IO.sleep(100.milliseconds).productR(() => done.setValue(true)),
                );
              });
            })
            .productR(() => done.value());
      });

      expect(test, ioSucceeded(true));
    });

    test('waitForAll=false: finalization cancels active effects', () {
      final test = IO.ref(false).flatMap((canceled) {
        return Dispatcher.parallel()
            .use((dispatcher) {
              return IO.delay(() {
                dispatcher.unsafeRunAndForget(
                  IO.never<Unit>().onCancel(canceled.setValue(true).voided()),
                );
              });
            })
            .productR(() => canceled.value());
      });

      expect(test, ioSucceeded(true));
    });
  });

  group('Dispatcher.sequential', () {
    test('unsafeRunAndForget runs the IO', () {
      final test = Deferred.of<int>().flatMap((latch) {
        return Dispatcher.sequential().use((dispatcher) {
          return IO
              .delay(
                () => dispatcher.unsafeRunAndForget(IO.pure(42).flatMap(latch.complete).voided()),
              )
              .productR(() => latch.value());
        });
      });

      expect(test, ioSucceeded(42));
    });

    test('unsafeToFuture returns correct result', () {
      final test = Dispatcher.sequential().use((dispatcher) {
        return IO.fromFutureF(() => dispatcher.unsafeToFuture(IO.pure(77)));
      });

      expect(test, ioSucceeded(77));
    });

    test('tasks run in FIFO order', () {
      final test = IO.ref(nil<int>()).flatMap((log) {
        return Dispatcher.sequential().use((dispatcher) {
          return IO
              .fromFutureF(() async {
                await dispatcher.unsafeToFuture(log.update((l) => l.prepended(1)));
                await dispatcher.unsafeToFuture(log.update((l) => l.prepended(2)));
                await dispatcher.unsafeToFuture(log.update((l) => l.prepended(3)));
              })
              .productR(() => log.value());
        });
      });

      // Prepend produces reverse order
      expect(test, ioSucceeded(ilist([3, 2, 1])));
    });

    test('worker survives a task error', () {
      final test = Dispatcher.sequential().use<int>((dispatcher) {
        return IO.fromFutureF<int>(() async {
          // First task errors.
          await dispatcher
              .unsafeToFuture(IO.raiseError<int>('boom'))
              .then(
                (_) => 0,
                onError: (_) => -1,
              );
          // Second task should still run.
          return dispatcher.unsafeToFuture(IO.pure(42));
        });
      });

      expect(test, ioSucceeded(42));
    });

    test('cancel prevents pending task from completing', () {
      final test = Dispatcher.sequential().use((dispatcher) {
        return Deferred.of<Unit>().flatMap((block) {
          // Block the worker with a long-running task.
          dispatcher.unsafeRunAndForget(block.value().voided());

          // Enqueue a second task and immediately cancel it.
          final (future, cancel) = dispatcher.unsafeToFutureCancelable(IO.pure(99));

          // Attach handler immediately to avoid an unhandled-rejection race.
          final handledFuture = future.then((_) => false, onError: (_) => true);

          // Cancel the second task, then unblock the worker.
          return IO
              .fromFutureF(cancel)
              .productR(() => block.complete(Unit()).voided())
              .productR(() => IO.fromFutureF(() => handledFuture));
        });
      });

      // The canceled task should fail (true = error occurred).
      expect(test, ioSucceeded(true));
    });

    test('waitForAll=true: finalization drains pending tasks', () {
      final test = IO.ref(false).flatMap((done) {
        return Dispatcher.sequential(waitForAll: true)
            .use((dispatcher) {
              return IO.delay(() {
                dispatcher.unsafeRunAndForget(
                  IO.sleep(50.milliseconds).productR(() => done.setValue(true)),
                );
              });
            })
            .productR(() => done.value());
      });

      expect(test, ioSucceeded(true));
    });

    test('waitForAll=false: finalization stops without draining', () {
      final test = IO.ref(false).flatMap((Ref<bool> done) {
        return Dispatcher.sequential()
            .use((dispatcher) {
              return IO.delay(() {
                dispatcher.unsafeRunAndForget(
                  IO.sleep(1.second).productR(() => done.setValue(true)),
                );
              });
            })
            .productR(() => done.value());
      });

      expect(test, ioSucceeded(false));
    });
  });
}
