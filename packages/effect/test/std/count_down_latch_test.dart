import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_test/ribs_test_effect.dart';
import 'package:test/test.dart';

void main() {
  group('CountDownLatch', () {
    test('create with n < 1 throws ArgumentError', () {
      expect(() => CountDownLatch.create(0), throwsArgumentError);
      expect(() => CountDownLatch.create(-1), throwsArgumentError);
    });

    test('await blocks while the count is above zero', () {
      final test = CountDownLatch.create(2).flatMap((latch) {
        return latch.release().productR(latch.await());
      });

      expect(test, nonTerminating);
    });

    test('await completes once the count reaches zero', () {
      final test = CountDownLatch.create(2).flatMap((latch) {
        return latch.release().productR(latch.release()).productR(latch.await());
      });

      expect(test, succeeds());
    });

    test('await returns immediately when the count is already zero', () {
      final test = CountDownLatch.create(1).flatMap((latch) {
        return latch.release().productR(latch.await()).productR(latch.await());
      });

      expect(test, succeeds());
    });

    test('releases beyond zero are no-ops', () {
      final test = CountDownLatch.create(1).flatMap((latch) {
        return latch
            .release()
            .productR(latch.release())
            .productR(latch.release())
            .productR(latch.await());
      });

      expect(test, succeeds());
    });

    test('blocked await is released by another fiber', () {
      final test = CountDownLatch.create(2).flatMap((latch) {
        return latch.await().start().flatMap((waiter) {
          return latch.release().productR(latch.release()).productR(waiter.join());
        });
      });

      expect(test, succeeds(Outcome.succeeded(Unit())));
    });

    test('multiple waiters are all released', () {
      final test = CountDownLatch.create(1).flatMap((latch) {
        return IO
            .both(
              (latch.await(), latch.await(), latch.await()).parTupled,
              IO.sleep(100.milliseconds).productR(latch.release()),
            )
            .voided();
      });

      expect(test, succeeds());
    });

    test('await is cancelable', () {
      final test = CountDownLatch.create(
        1,
      ).flatMap((latch) => latch.await()).timeoutTo(1.second, IO.unit);

      expect(test, succeeds());
    });
  });
}
