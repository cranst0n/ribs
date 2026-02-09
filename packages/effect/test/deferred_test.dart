import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  test('additional writes ignored', () {
    final d = Deferred.unsafe<int>();

    final writeA = d.complete(42).delayBy(100.milliseconds);
    final writeB = d.complete(43).delayBy(150.milliseconds);

    expect(
      (writeA, writeB, d.value()).parTupled(),
      ioSucceeded((true, false, 42)),
    );
  });

  test('writer / reader', () async {
    final d = Deferred.unsafe<int>();

    bool readerNotified = false;

    final reader = d.value().flatTap((a) => IO.exec(() => readerNotified = true)).start();

    final writer = IO.defer(() => d.complete(42)).delayBy(200.milliseconds);

    final (_, writerSuccessful) = await IO.both(reader, writer).unsafeRunFuture();

    expect(writerSuccessful, isTrue);
    expect(readerNotified, isTrue);
  });

  test('reader canceled', () async {
    final d = Deferred.unsafe<int>();

    bool readerNotified = false;

    final reader = d
        .value()
        .flatTap((a) => IO.exec(() => readerNotified = true))
        .start()
        .flatMap((f) => f.cancel().delayBy(100.milliseconds));

    final writer = IO.defer(() => d.complete(42)).delayBy(200.milliseconds);

    final (_, writerSuccessful) = await IO.both(reader, writer).unsafeRunFuture();

    expect(writerSuccessful, isTrue);
    expect(readerNotified, isFalse);
  });

  test('tryValue return None for unset Deferred', () {
    final test = IO.deferred<Unit>().flatMap((op) {
      return op.tryValue();
    });

    expect(test, ioSucceeded(isNone()));
  });

  test('tryValue return Some() for set Deferred', () {
    final test = IO.deferred<Unit>().flatMap((op) {
      return op.complete(Unit()).flatMap((_) {
        return op.tryValue();
      });
    });

    expect(test, ioSucceeded(isSome(Unit())));
  });
}
