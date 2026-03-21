// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// cdl-basic
/// A latch of 3 requires 3 [release] calls before [await] unblocks.
IO<Unit> countDownLatchBasic() => CountDownLatch.create(3).flatMap((latch) {
  // Three worker fibers each do their work, then release the latch.
  IO<Unit> worker(int id) => IO
      .sleep((id * 50).milliseconds)
      .productR(() => IO.print('worker $id: done'))
      .productR(() => latch.release());

  // The coordinator blocks until all three workers have released.
  final coordinator = latch.await().productR(() => IO.print('all workers done — proceeding'));

  return ilist([worker(1), worker(2), worker(3), coordinator]).parSequence_();
});
// cdl-basic

// cdl-await-multiple
/// Multiple fibers can call [await] simultaneously; they are all unblocked
/// at the same instant when the last [release] fires.
IO<Unit> multipleAwaiters() => CountDownLatch.create(1).flatMap((latch) {
  IO<Unit> waiter(int id) => latch.await().productR(() => IO.print('waiter $id: unblocked'));

  final starter = IO
      .sleep(100.milliseconds)
      .productR(() => IO.print('releasing'))
      .productR(() => latch.release());

  return ilist([waiter(1), waiter(2), waiter(3), starter]).parSequence_();
});
// cdl-await-multiple

// cdl-already-done
/// Once the count reaches zero, subsequent [await] calls return immediately —
/// the latch stays open forever.
IO<Unit> awaitAlreadyDone() => CountDownLatch.create(1).flatMap((latch) {
  return latch
      .release()
      .productR(() => latch.await()) // returns immediately
      .productR(() => latch.await()) // also returns immediately
      .productR(() => IO.print('done'));
});
// cdl-already-done

// cdl-parallel-init
/// Real-world example: parallel service initialisation.
///
/// Three services start up concurrently. An HTTP server must not begin
/// accepting requests until every service has signalled readiness.
/// [CountDownLatch] acts as the synchronisation point.
IO<Unit> parallelServiceInit() => CountDownLatch.create(3).flatMap((ready) {
  // Each service performs its startup work, then decrements the latch.
  IO<Unit> startService(String name, Duration startupTime, int port) => IO
      .sleep(startupTime)
      .productR(() => IO.print('[$name] listening on :$port'))
      .productR(() => ready.release());

  // The HTTP gateway waits for every service to be ready before it
  // starts routing traffic.
  final gateway = ready.await().productR(
    () => IO.print('[gateway] all services ready — accepting requests'),
  );

  return ilist([
    startService('auth', 150.milliseconds, 8081),
    startService('catalog', 200.milliseconds, 8082),
    startService('billing', 120.milliseconds, 8083),
    gateway,
  ]).parSequence_();
});
// cdl-parallel-init
