import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('additional writes ignored', () async {
    final d = Deferred.unsafe<int>();

    final writeA = d.complete(42).delayBy(const Duration(milliseconds: 100));
    final writeB = d.complete(43).delayBy(const Duration(milliseconds: 150));

    final result = await Tuple3(writeA, writeB, d.value())
        .parSequence()
        .unsafeRunToFuture();

    result((aSucceeded, bSucceeded, finalValue) {
      expect(aSucceeded, isTrue);
      expect(bSucceeded, isFalse);
      expect(finalValue, 42);
    });
  });

  test('writer / reader', () async {
    final d = Deferred.unsafe<int>();

    bool readerNotified = false;

    final reader =
        d.value().flatTap((a) => IO.exec(() => readerNotified = true)).start();

    final writer = IO
        .defer(() => d.complete(42))
        .delayBy(const Duration(milliseconds: 200));

    final result = await IO.both(reader, writer).unsafeRunToFuture();

    result(
      (_, writerSuccessful) {
        expect(writerSuccessful, isTrue);
        expect(readerNotified, isTrue);
      },
    );
  });

  test('reader canceled', () async {
    final d = Deferred.unsafe<int>();

    bool readerNotified = false;

    final reader = d
        .value()
        .flatTap((a) => IO.exec(() => readerNotified = true))
        .start()
        .flatMap((f) => f.cancel().delayBy(const Duration(milliseconds: 100)));

    final writer = IO
        .defer(() => d.complete(42))
        .delayBy(const Duration(milliseconds: 200));

    final result = await IO.both(reader, writer).unsafeRunToFuture();

    result(
      (_, writerSuccessful) {
        expect(writerSuccessful, isTrue);
        expect(readerNotified, isFalse);
      },
    );
  });
}
