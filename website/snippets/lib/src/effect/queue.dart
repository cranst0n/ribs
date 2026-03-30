// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// #region queue-basic
IO<Unit> basicQueueExample() => Queue.bounded<int>(10).flatMap(
  (queue) => queue
      .offer(1)
      .flatMap((_) => queue.offer(2))
      .flatMap((_) => queue.offer(3))
      .flatMap((_) => queue.take())
      .flatMap((a) => IO.print('took: $a')),
); // took: 1
// #endregion queue-basic

// #region queue-backpressure
IO<Unit> backpressureExample() => Queue.bounded<int>(2).flatMap((queue) {
  // Producer: the third offer suspends because the queue is full.
  // It only unblocks once the consumer takes an element.
  final producer = queue
      .offer(1)
      .flatMap((_) => queue.offer(2))
      .flatMap((_) => queue.offer(3)) // suspends here until consumer takes
      .flatMap((_) => IO.print('all offered'));

  final consumer =
      IO
          .sleep(100.milliseconds)
          .productR(queue.take())
          .flatMap((n) => IO.print('took: $n'))
          .replicate_(3)
          .voided();

  return IO.both(producer, consumer).voided();
});
// #endregion queue-backpressure

// #region queue-pub-sub
/// A simple pub-sub dispatcher: each call to [subscribe] returns a new
/// [Queue] that independently receives every published event.
IO<Unit> pubSubExample() => IO
    .both(
      Queue.bounded<double>(16), // alert subscriber's inbox
      Queue.bounded<double>(16), // logger subscriber's inbox
    )
    .flatMap((inboxes) {
      final (alertInbox, logInbox) = inboxes;

      // Fan-out: deliver the same reading to every subscriber inbox
      IO<Unit> publish(double celsius) =>
          alertInbox.offer(celsius).flatMap((_) => logInbox.offer(celsius));

      // Subscriber 1: raise an alert on high temperatures
      final alertWorker =
          alertInbox
              .take()
              .flatMap(
                (t) =>
                    t > 38.0 ? IO.print('ALERT: high temperature — $t°C!') : IO.print('OK: $t°C'),
              )
              .replicate_(4)
              .voided();

      // Subscriber 2: record every reading to a log
      final logWorker =
          logInbox.take().flatMap((t) => IO.print('LOG: reading $t°C')).replicate_(4).voided();

      // Publisher: simulate a temperature sensor emitting four readings
      final sensor = ilist<double>([36.6, 39.2, 37.1, 38.5]).traverseIO_(publish);

      // Run the publisher and both subscribers concurrently.
      // parSequence_() starts all three as independent fibers and waits for all to finish.
      return ilist([alertWorker, logWorker, sensor]).parSequence_();
    });
// #endregion queue-pub-sub
