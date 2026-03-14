import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('Supervisor', () {
    test('supervised fiber completes with value', () {
      final test = Supervisor.create().use(
        (supervisor) => supervisor.supervise(IO.pure(42)).flatMap((fiber) => fiber.joinWithNever()),
      );

      expect(test, ioSucceeded(42));
    });

    test('supervised fiber error propagates via join', () {
      final test = Supervisor.create().use((supervisor) {
        return supervisor
            .supervise(IO.raiseError<int>('boom'))
            .flatMap((fiber) => fiber.join())
            .map((Outcome<int> outcome) => outcome.isError);
      });

      expect(test, ioSucceeded(true));
    });

    test('fiber error does not affect supervisor - subsequent supervise works', () {
      final test = Supervisor.create().use((supervisor) {
        return supervisor
            .supervise(IO.raiseError<int>('boom'))
            .flatMap((fiber) => fiber.join())
            .flatMap((_) => supervisor.supervise(IO.pure(99)))
            .flatMap((fiber) => fiber.joinWithNever());
      });

      expect(test, ioSucceeded(99));
    });

    test('multiple supervised fibers all complete', () {
      final test = Supervisor.create().use((supervisor) {
        return supervisor.supervise(IO.pure(1)).flatMap((fiber1) {
          return supervisor.supervise(IO.pure(2)).flatMap((fiber2) {
            return fiber1.joinWithNever().flatMap((a) {
              return fiber2.joinWithNever().map((b) => a + b);
            });
          });
        });
      });

      expect(test, ioSucceeded(3));
    });

    test('waitForAll=true: finalization waits for in-flight fibers', () {
      final test = IO.ref(false).flatMap((completed) {
        return Supervisor.create(waitForAll: true)
            .use((supervisor) {
              return supervisor.supervise(
                IO.sleep(100.milliseconds).productR(() => completed.setValue(true)),
              );
            })
            .productR(() => completed.value());
      });

      expect(test, ioSucceeded(true));
    });

    test('waitForAll=false: finalization cancels in-flight fibers', () {
      final test = IO.ref(false).flatMap((canceled) {
        return Supervisor.create()
            .use((supervisor) {
              return supervisor.supervise(
                IO.never<Unit>().onCancel(canceled.setValue(true)),
              );
            })
            .productR(() => canceled.value());
      });

      expect(test, ioSucceeded(true));
    });

    test('supervise after finalization raises error', () {
      final test = Supervisor.create().allocated().flatMap((tuple) {
        final (supervisor, close) = tuple;
        return close.productR(() => supervisor.supervise(IO.pure(1)).voided());
      });

      expect(test, ioErrored());
    });

    test('supervised fiber removes itself from tracking when complete', () {
      // Verifies cleanup: after a fiber completes, the supervisor can still
      // be finalized cleanly (no lingering fiber references).
      final test = Supervisor.create().use((supervisor) {
        return supervisor
            .supervise(IO.pure(42))
            .flatMap((fiber) => fiber.joinWithNever())
            .flatMap((_) => IO.sleep(10.milliseconds))
            .as(true);
      });

      expect(test, ioSucceeded(true));
    });
  });
}
