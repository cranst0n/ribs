import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('Cyclic Barrier', () {
    IO<CyclicBarrier> newBarrier(int n) => CyclicBarrier.withCapacity(n);

    test('await is blocking', () {
      final test = newBarrier(2).flatMap((barrier) => barrier.await());

      expect(test, ioSucceeded());
    }, skip: 'Expected to be non-terminating');

    test('await is cancelable', () {
      final test = newBarrier(2).flatMap((barrier) => barrier.await()).timeoutTo(1.second, IO.unit);

      expect(test, ioSucceeded());
    });

    test('await releases all fibers', () {
      final test = newBarrier(2).flatMap((barrier) {
        return (barrier.await(), barrier.await()).parTupled().voided();
      });

      expect(test, ioSucceeded());
    });

    test('should reset once full', () {
      final test = newBarrier(2).flatMap((barrier) {
        return (barrier.await(), barrier.await()).parTupled().productR(() => barrier.await());
      });

      expect(test, ioSucceeded());
    }, skip: 'Expected to be non-terminating');

    test('should clean up upon cancelation of await', () {
      final test = newBarrier(2).flatMap((barrier) {
        return barrier.await().timeoutTo(1.second, IO.unit).productR(() => barrier.await());
      });

      expect(test, ioSucceeded());
    }, skip: 'Expected to be non-terminating');

    test('barrier of capacity 1 is a no op', () {
      expect(
        newBarrier(1).flatMap((barrier) => barrier.await()),
        ioSucceeded(),
      );
    });

    test('race fiber cancel and barrier full', () {
      const iterations = 100;

      final run = newBarrier(2).flatMap((barrier) {
        return barrier.await().start().flatMap((fiber) {
          return IO.race(barrier.await(), fiber.cancel()).flatMap((result) {
            return result.fold(
              (_) => (barrier.await(), barrier.await()).parTupled().voided(),
              (_) => IO.unit,
            );
          });
        });
      });

      expect(IList.fill(iterations, run).sequence(), ioSucceeded());
    });
  });
}
