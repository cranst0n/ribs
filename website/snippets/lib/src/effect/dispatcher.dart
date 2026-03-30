// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// #region dispatcher-parallel
/// unsafeToFuture runs an IO and returns a Future that resolves to the result.
IO<int> parallelToFuture() => Dispatcher.parallel().use((dispatcher) {
  final future = dispatcher.unsafeToFuture(IO.pure(42));
  return IO.fromFutureF(() => future);
});

/// unsafeRunAndForget submits an IO for execution and discards the result.
/// Use when you only care about the side-effect, not the outcome.
IO<Unit> parallelFireAndForget() => Dispatcher.parallel().use((dispatcher) {
  return IO
      .delay(() {
        dispatcher.unsafeRunAndForget(IO.print('background work'));
        return Unit();
      })
      .productR(IO.sleep(10.milliseconds));
});
// #endregion dispatcher-parallel

// #region dispatcher-sequential
/// A sequential Dispatcher serializes submitted effects in FIFO order —
/// each effect runs to completion before the next one starts.
IO<IList<int>> sequentialFifo() => IO.ref(nil<int>()).flatMap((log) {
  return Dispatcher.sequential().use((dispatcher) {
    return IO
        .fromFutureF<Unit>(() async {
          await dispatcher.unsafeToFuture(log.update((IList<int> l) => l.prepended(1)));
          await dispatcher.unsafeToFuture(log.update((IList<int> l) => l.prepended(2)));
          await dispatcher.unsafeToFuture(log.update((IList<int> l) => l.prepended(3)));
          return Unit();
        })
        .productR(log.value());
  });
});
// #endregion dispatcher-sequential

// #region dispatcher-bridge
/// Simulates an impure interface — an SDK callback, platform event, or any
/// other context that calls [onMessage] from outside the IO world.
void initSdk(void Function(String) onMessage) => onMessage('hello from sdk');

/// WITHOUT a Dispatcher: IO is lazy — queue.offer() returns an `IO<Unit>`
/// description but never executes it. The message is lost.
IO<Unit> withoutDispatcher() => Queue.unbounded<String>().flatMap((queue) {
  initSdk((msg) {
    queue.offer(msg); // returns IO<Unit> and discards it — nothing runs
  });
  return queue.tryTake().flatMap((oa) => IO.print(oa.fold(() => 'nothing :(', (v) => v)));
  // prints: nothing :(
});

/// WITH a Dispatcher: unsafeRunAndForget executes the IO immediately,
/// placing the message in the queue where the IO program can consume it.
IO<Unit> withDispatcher() => Dispatcher.sequential().use((dispatcher) {
  return Queue.unbounded<String>().flatMap((queue) {
    initSdk((msg) => dispatcher.unsafeRunAndForget(queue.offer(msg)));
    return queue.take().flatMap((msg) => IO.print(msg));
    // prints: hello from sdk
  });
});
// #endregion dispatcher-bridge
