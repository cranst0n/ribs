import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('Backpressure', () {
    test('Lossy Strategy should return IO[None] when no permits are available', () {
      final test = Backpressure.lossy(1).flatMap((backpressure) {
        final never = backpressure.metered(IO.never<Unit>());

        return IO.race(never, never).map((result) {
          return result.fold(identity, identity).isEmpty;
        });
      });

      expect(test, ioSucceeded(true));
    });

    test('Lossless Strategy should complete effects even when no permits are available', () {
      final test = Backpressure.lossless(1).flatMap((backpressure) {
        return backpressure
            .metered(IO.sleep(1.second).productR(() => IO.pure(1)))
            .start()
            .flatMap((f1) {
          return backpressure
              .metered(IO.sleep(1.second).productR(() => IO.pure(2)))
              .start()
              .flatMap((f2) {
            return f1.joinWithNever().flatMap((res1) {
              return f2.joinWithNever().map((res2) {
                return (res1, res2);
              });
            });
          });
        });
      });

      expect(test, ioSucceeded((const Some(1), const Some(2))));
    });
  });
}
