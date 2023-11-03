import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  test('additional writes ignored', () {
    final d = Deferred.unsafe<int>();

    final writeA = d.complete(42).delayBy(const Duration(milliseconds: 100));
    final writeB = d.complete(43).delayBy(const Duration(milliseconds: 150));

    expect(
      (writeA, writeB, d.value()).parTupled(),
      ioSucceeded((true, false, 42)),
    );
  });

  test('writer / reader', () async {
    final d = Deferred.unsafe<int>();

    bool readerNotified = false;

    final reader =
        d.value().flatTap((a) => IO.exec(() => readerNotified = true)).start();

    final writer = IO
        .defer(() => d.complete(42))
        .delayBy(const Duration(milliseconds: 200));

    final (_, writerSuccessful) =
        await IO.both(reader, writer).unsafeRunFuture();

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
        .flatMap((f) => f.cancel().delayBy(const Duration(milliseconds: 100)));

    final writer = IO
        .defer(() => d.complete(42))
        .delayBy(const Duration(milliseconds: 200));

    final (_, writerSuccessful) =
        await IO.both(reader, writer).unsafeRunFuture();

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