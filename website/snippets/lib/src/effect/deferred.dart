// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// deferred-basic
IO<Unit> deferredBasic() => Deferred.of<int>().flatMap(
  (d) =>
      IO
          .both(
            // Consumer: suspends on value() until the Deferred is completed
            d.value().flatMap((n) => IO.print('got: $n')),
            // Producer: completes the Deferred after a short delay
            IO
                .sleep(100.milliseconds)
                .productR(() => d.complete(42))
                .flatMap((won) => IO.print('completed: $won')), // completed: true
          )
          .voided(),
);
// deferred-basic

// deferred-complete-once
IO<Unit> completeOnce() => Deferred.of<String>().flatMap(
  (d) => IO
      .both(
        d.complete('first').flatMap((won) => IO.print('first: $won')), // first: true
        d.complete('second').flatMap((won) => IO.print('second: $won')), // second: false
      )
      .flatMap((_) => d.value().flatMap((v) => IO.print('value: $v'))),
); // value: first
// deferred-complete-once

// deferred-ready-gate

/// A service publishes its endpoint via [Deferred] once startup is done.
/// Any number of client fibers can call [ready.value()] and will all unblock
/// at the same instant, the moment [complete] is called.
IO<Unit> serviceReadyGate() => Deferred.of<String>().flatMap((ready) {
  IO<Unit> client(int id) =>
      ready.value().flatMap((endpoint) => IO.print('client $id: connected to $endpoint'));

  final service = IO
      .sleep(200.milliseconds)
      .productR(() => ready.complete('https://api.example.com'))
      .productR(() => IO.print('service: startup complete, clients unblocked'));

  return ilist([client(1), client(2), client(3), service]).parSequence_();
});

// deferred-ready-gate
