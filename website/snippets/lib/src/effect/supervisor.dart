// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// supervisor-basic
IO<int> supervisorBasic() => Supervisor.create().use(
  (supervisor) => supervisor.supervise(IO.pure(42)).flatMap((fiber) => fiber.joinWithNever()),
);
// supervisor-basic

// supervisor-fire-forget
/// Supervised fibers don't need to be joined.
/// When the supervisor's scope closes, all still-running fibers are canceled.
IO<Unit> fireAndForget() => Supervisor.create().use((supervisor) {
  return supervisor.supervise(IO.sleep(1.seconds).productR(IO.print('done'))).voided();
});
// supervisor-fire-forget

// supervisor-waitforall
/// With waitForAll=true, finalization blocks until every supervised fiber
/// completes naturally rather than canceling them.
IO<Unit> supervisorWaitForAll() => IO.ref(false).flatMap((completed) {
  return Supervisor.create(waitForAll: true)
      .use((supervisor) {
        return supervisor
            .supervise(
              IO.sleep(200.milliseconds).productR(completed.setValue(true)),
            )
            .voided();
      })
      .productR(completed.value())
      .flatMap((v) => IO.print('completed: $v')); // completed: true
});
// supervisor-waitforall

// supervisor-healthcheck
/// Attaches a periodic health-check to a [Resource] scope.
///
/// The check runs in a background fiber supervised by [Supervisor].
/// When the [Resource] is released the [Supervisor] cancels the loop
/// automatically — no manual fiber management required.
Resource<Unit> withHealthCheck(IO<Unit> check, Duration interval) {
  final loop = check.productR(IO.sleep(interval)).foreverM();
  return Supervisor.create().flatMap(
    (supervisor) => Resource.eval(supervisor.supervise(loop).voided()),
  );
}

IO<Unit> healthCheckExample() => IO.ref(0).flatMap((counter) {
  final check = counter
      .update((n) => n + 1)
      .productR(
        counter.value().flatMap((n) => IO.print('check #$n')),
      );

  return withHealthCheck(check, 100.milliseconds)
      .use((_) => IO.sleep(350.milliseconds))
      .productR(counter.value())
      .flatMap((n) => IO.print('ran $n checks'));
  // prints: check #1, check #2, check #3, ran 3 checks
});
// supervisor-healthcheck
