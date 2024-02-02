import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  test('makes acquires non interruptible', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.uncancelable((poll) => poll(IO
          .sleep(const Duration(seconds: 5))
          .onCancel(interrupted.setValue(true))));

      return Resource.make(fa, (_) => IO.unit)
          .use_()
          .timeout(const Duration(seconds: 1))
          .attempt()
          .productR(() => interrupted.value());
    });

    expect(test, ioSucceeded(false));
  });

  test('makes acquires non interruptible, overriding uncancelable', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.uncancelable((poll) => poll(IO
          .sleep(const Duration(seconds: 5))
          .onCancel(interrupted.setValue(true))));

      return Resource.make(fa, (_) => IO.unit)
          .use_()
          .timeout(const Duration(seconds: 1))
          .attempt()
          .productR(() => interrupted.value());
    });

    expect(test, ioSucceeded(false));
  });

  test('releases resource if interruption happens during use', () {
    final flag = IO.ref(false);

    final test = (flag, flag).tupled().flatMapN((acquireFin, resourceFin) {
      final action = IO
          .sleep(const Duration(seconds: 1))
          .onCancel(acquireFin.setValue(true));

      final fin = resourceFin.setValue(true);

      final res = Resource.makeFull((poll) => poll(action), (_) => fin);

      return res
          .surround(IO.sleep(const Duration(seconds: 4)))
          .timeout(const Duration(seconds: 2))
          .attempt()
          .productR(() => (acquireFin.value(), resourceFin.value()).tupled());
    });

    expect(test, ioSucceeded((false, true)));
  });

  test('supports interruptible acquires', () {
    final flag = IO.ref(false);

    final test = (flag, flag).tupled().flatMapN((acquireFin, resourceFin) {
      final action = IO
          .sleep(const Duration(seconds: 5))
          .onCancel(acquireFin.setValue(true));

      final fin = resourceFin.setValue(true);

      final res = Resource.makeFull((poll) => poll(action), (_) => fin);

      return res
          .use_()
          .timeout(const Duration(seconds: 1))
          .attempt()
          .productR(() => (acquireFin.value(), resourceFin.value()).tupled());
    });

    expect(test, ioSucceeded((true, false)));
  });

  test('supports interruptible acquires, respecting uncancelable', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(const Duration(seconds: 1));
    const timeout = Duration(milliseconds: 500);

    final test = (flag, flag, flag, flag).tupled().flatMap((ft) {
      final (acquireFin, resourceFin, a, b) = ft;

      final io = IO.uncancelable((poll) => sleep
          .onCancel(a.setValue(true))
          .productR(() => poll(sleep).onCancel(b.setValue(true))));

      final resource = Resource.makeFull(
          (poll) => poll(io).onCancel(acquireFin.setValue(true)),
          (_) => resourceFin.setValue(true));

      return resource.use_().timeout(timeout).attempt().productR(() => (
            a.value(),
            b.value(),
            acquireFin.value(),
            resourceFin.value()
          ).tupled());
    });

    expect(test, ioSucceeded((false, true, true, false)));
  });

  test('release is always uninterruptible', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(const Duration(seconds: 1));
    const timeout = Duration(milliseconds: 500);

    final test = flag.flatMap((releaseComplete) {
      final release = sleep.productR(() => releaseComplete.setValue(true));
      final resource = Resource.applyFull(
          (poll) => IO.delay(() => (Unit(), (_) => poll(release))));

      return resource
          .use_()
          .timeout(timeout)
          .attempt()
          .productR(() => releaseComplete.value());
    });

    expect(test, ioSucceeded(true));
  }, skip: true);

  test('pure', () {
    final res = Resource.pure(42)
        .map((a) => a * 2)
        .flatMap((a) => Resource.pure('abc'));

    final test = res.use((a) => IO.pure('${a}123'));

    expect(test, ioSucceeded('abc123'));
  });

  test('both', () async {
    bool aReleased = false;
    bool bReleased = false;

    final res = Resource.both(
      Resource.make(IO.pure(42), (a) => IO.exec(() => aReleased = true)),
      Resource.make(IO.pure(43), (a) => IO.exec(() => bReleased = true)),
    );

    final test = res.use((a) => IO.pure(a.$1 + a.$2));

    await expectLater(test, ioSucceeded(85));
    expect(aReleased, isTrue);
    expect(bReleased, isTrue);
  });

  test('attempt success', () async {
    bool released = false;

    final res = Resource.make(
      IO.pure(42),
      (_) => IO.exec(() => released = true),
    );

    final test = res.attempt().use_();

    await expectLater(test, ioSucceeded(Unit()));
    expect(released, isTrue);
  });

  test('attempt failure', () async {
    bool released = false;

    final res = Resource.make(
      IO.raiseError<int>(RuntimeException('boom')),
      (_) => IO.exec(() => released = true),
    );

    final test = res.attempt().use_();

    await expectLater(test, ioSucceeded(Unit()));
    expect(released, isFalse);
  });
}
