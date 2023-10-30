import 'dart:async';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  test('pure', () {
    expect(IO.pure(42), ioSucceeded(42));
  });

  test('raiseError', () {
    expect(IO.raiseError<int>(RuntimeException('boom')), ioErrored());
  });

  test('delay', () {
    expect(IO.delay(() => 2 * 21), ioSucceeded(42));
  });

  test('fromFuture success', () {
    final io = IO.fromFuture(IO.delay(
        () => Future.delayed(const Duration(milliseconds: 250), () => 42)));

    expect(io, ioSucceeded(42));
  });

  test('fromFuture error', () {
    final io = IO.fromFuture(IO.delay(() => Future<int>.delayed(
        const Duration(milliseconds: 250), () => Future.error('boom'))));

    expect(io, ioErrored((RuntimeException ex) => ex.message == 'boom'));
  });

  test('fromCancelableOperation success', () {
    bool opWasCanceled = false;

    final io = IO
        .fromCancelableOperation(IO.delay(() => CancelableOperation.fromFuture(
              Future.delayed(const Duration(milliseconds: 200), () => 42),
              onCancel: () => opWasCanceled = true,
            )));

    expect(io, ioSucceeded(42));
    expect(opWasCanceled, isFalse);
  });

  test('fromCancelableOperation canceled', () async {
    bool opWasCanceled = false;

    final io = IO
        .fromCancelableOperation(IO.delay(() => CancelableOperation.fromFuture(
              Future.delayed(const Duration(milliseconds: 500), () => 42),
              onCancel: () => opWasCanceled = true,
            )));

    final fiber = await io.start().unsafeRunToFuture();

    fiber
        .cancel()
        .delayBy(const Duration(milliseconds: 100))
        .unsafeRunAndForget();

    final oc = await fiber.join().unsafeRunToFuture();

    expect(oc, const Canceled());
    expect(opWasCanceled, true);
  });

  test('map pure', () {
    const n = 200;

    IO<int> build(IO<int> io, int loop) =>
        loop <= 0 ? io : build(io.map((x) => x + 1), loop - 1);

    final io = build(IO.pure(0), n);

    expect(io, ioSucceeded(n));
  });

  test('map error', () {
    expect(
      IO.pure(42).map((a) => a ~/ 0),
      ioErrored((RuntimeException ex) => ex.message is UnsupportedError),
    );
  });

  test('flatMap pure', () {
    final io = IO.pure(42).flatMap((i) => IO.pure('$i / ${i * 2}'));
    expect(io, ioSucceeded('42 / 84'));
  });

  test('flatMap error', () {
    final io = IO
        .pure(42)
        .flatMap((i) => IO.raiseError<String>(RuntimeException('boom')));

    expect(io, ioErrored((RuntimeException ex) => ex.message == 'boom'));
  });

  test('flatMap delay', () {
    final io = IO.delay(() => 3).flatMap((i) => IO.delay(() => '*' * i));
    expect(io, ioSucceeded('***'));
  });

  test('attempt pure', () {
    final io = IO.pure(42).attempt();
    expect(io, ioSucceeded(42.asRight<RuntimeException>()));
  });

  test('attempt error', () {
    final io = IO.raiseError<int>(RuntimeException('boom')).attempt();
    expect(io, ioSucceeded((Either<RuntimeException, int> e) => e.isLeft));
  });

  test('attempt delay success', () {
    final io = IO.delay(() => 42).attempt();
    expect(io, ioSucceeded(42.asRight<RuntimeException>()));
  });

  test('attempt delay error', () {
    final io = IO.delay(() => 42 ~/ 0).attempt();
    expect(io, ioSucceeded((Either<RuntimeException, int> e) => e.isLeft));
  });

  test('attempt and map', () {
    final io = IO
        .delay(() => throw StateError('boom'))
        .attempt()
        .map((x) => x.fold((a) => 0, (a) => 1));

    expect(io, ioSucceeded(0));
  });

  test('sleep', () async {
    final io = IO.sleep(const Duration(milliseconds: 250));
    expect(io, ioSucceeded(Unit()));
  });

  test('handleErrorWith pure', () {
    final io = IO.pure(42).handleErrorWith((_) => IO.pure(0));
    expect(io, ioSucceeded(42));
  });

  test('handleErrorWith error', () {
    final io = IO.delay(() => 1 ~/ 0).handleErrorWith((_) => IO.pure(42));
    expect(io, ioSucceeded(42));
  });

  test('async simple', () async {
    bool finalized = false;

    final io = IO.async<int>((cb) => IO.delay(() {
          Future.delayed(const Duration(seconds: 2), () => 42)
              .then((value) => cb(value.asRight()));

          return IO.exec(() => finalized = true).some;
        }));

    final fiber = await io.start().unsafeRunToFuture();

    fiber.cancel().unsafeRunAndForget();

    final outcome = await fiber.join().unsafeRunToFuture();

    expect(outcome, const Canceled());
    expect(finalized, isTrue);
  });

  test('async_ simple', () async {
    final io = IO.async_<int>((cb) {
      Future.delayed(const Duration(milliseconds: 100), () => 42)
          .then((value) => cb(value.asRight()));
    });

    expect(io, ioSucceeded(42));
  });

  test('unsafeRunToFuture success', () async {
    expect(await IO.pure(42).unsafeRunToFuture(), 42);
    expect(IO.raiseError<int>(RuntimeException('boom')).unsafeRunToFuture(),
        throwsA('boom'));
  });

  test('start simple', () async {
    final io = IO
        .pure(0)
        .flatTap((_) => IO.sleep(const Duration(milliseconds: 200)))
        .as(42);

    final fiber = await io.start().unsafeRunToFuture();
    final outcome = await fiber.join().unsafeRunToFuture();

    expect(outcome, const Succeeded(42));
  });

  test('onError success', () async {
    int count = 0;

    final io = IO.pure(0).onError((_) => IO.exec(() => count += 1)).as(42);

    expect(io, ioSucceeded(42));
    expect(count, 0);
  });

  test('onError error', () async {
    int count = 0;

    final io = IO
        .delay<int>(() => 1 ~/ 0)
        .onError((_) => IO.exec(() => count += 1))
        .onError((_) => IO.exec(() => count += 2))
        .onError((_) => IO.exec(() => count += 3))
        .as(42);

    await expectLater(io, ioErrored());
    expect(count, 6);
  });

  test('onCancel success', () async {
    int count = 0;

    final io = IO
        .pure(0)
        .onCancel(IO.exec(() => count += 100))
        .flatTap((_) => IO.sleep(const Duration(seconds: 1)))
        .as(42)
        .onCancel(IO.exec(() => count += 1))
        .onCancel(IO.exec(() => count += 2))
        .onCancel(IO.exec(() => count += 3));

    final fiber = await io.start().unsafeRunToFuture();
    final outcome = await fiber.join().unsafeRunToFuture();

    expect(outcome, const Succeeded(42));
    expect(count, 0);
  });

  test('onCancel error', () async {
    int count = 0;

    final io = IO
        .delay(() => 1 ~/ 0)
        .onCancel(IO.exec(() => count += 100))
        .flatTap((_) => IO.sleep(const Duration(seconds: 1)))
        .as(42)
        .onCancel(IO.exec(() => count += 1))
        .onCancel(IO.exec(() => count += 2))
        .onCancel(IO.exec(() => count += 3));

    final fiber = await io.start().unsafeRunToFuture();
    final outcome = await fiber.join().unsafeRunToFuture();

    expect(outcome, isA<Errored<int>>());
    expect(count, 0);
  });

  test('onCancel canceled', () async {
    int count = 0;

    final io = IO
        .pure(0)
        .onCancel(IO.exec(() => count += 100))
        .flatTap((_) => IO.sleep(const Duration(seconds: 1)))
        .as(42)
        .onCancel(IO.exec(() => count += 1))
        .onCancel(IO.exec(() => count += 2))
        .onCancel(IO.exec(() => count += 3));

    final fiber = await io.start().unsafeRunToFuture();

    fiber.cancel().unsafeRunAndForget();

    final outcome = await fiber.join().unsafeRunToFuture();

    expect(outcome, const Canceled());
    expect(count, 6);
  });

  test('cede', () async {
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    void expensiveStuff(int initial) {
      for (int i = initial; i < 100000000; i++) {}
    }

    final expensive = IO
        .delay(() => expensiveStuff(0))
        .flatTap((_) => appendOutput('step 1'))
        .guarantee(IO.cede)
        .map((_) => expensiveStuff(10))
        .flatTap((_) => appendOutput('step 2'))
        .guarantee(IO.cede)
        .as(42);

    final generous = appendOutput('hello')
        .guarantee(IO.cede)
        .flatTap((a) => appendOutput('world!'));

    final fiber = expensive.start().unsafeRunToFuture();
    generous.start().unsafeRunAndForget();

    final outcome = await fiber.then((f) => f.join().unsafeRunToFuture());

    expect(outcome, const Succeeded(42));
    expect(output, ['step 1', 'hello', 'step 2', 'world!']);
  });

  test('guaranteeCase', () async {
    var count = 0;

    IO<Unit> fin(Outcome<Unit> oc) => oc.fold(
          () => IO.exec(() => count += 1),
          (_) => IO.exec(() => count += 2),
          (_) => IO.exec(() => count += 3),
        );

    await expectLater(
      IO.unit.guaranteeCase(fin),
      ioSucceeded(),
    );

    expect(count, 3);

    count = 0;

    await expectLater(
      IO.raiseError<Unit>(RuntimeException('boom')).guaranteeCase(fin),
      ioErrored(),
    );

    expect(count, 2);

    count = 0;

    await expectLater(IO.canceled.guaranteeCase(fin), ioCanceled());

    expect(count, 1);
  });

  test('timed', () async {
    final ioa = IO.pure(42).delayBy(const Duration(milliseconds: 250)).timed();

    final (elapsed, value) = await ioa.unsafeRunToFuture();

    expect(value, 42);
    expect(elapsed.inMilliseconds, closeTo(250, 50));
  });

  test('map3', () async {
    final ioa = IO.pure(1).delayBy(const Duration(milliseconds: 200));
    final iob = IO.pure(2).delayBy(const Duration(milliseconds: 200));
    final ioc = IO.pure(3).delayBy(const Duration(milliseconds: 200));

    final (elapsed, value) = await (ioa, iob, ioc)
        .mapN((a, b, c) => a + b + c)
        .timed()
        .unsafeRunToFuture();

    expect(value, 6);
    expect(elapsed.inMilliseconds, closeTo(600, 50));
  });

  test('asyncMapN', () async {
    final ioa = IO.pure(1).delayBy(const Duration(milliseconds: 500));
    final iob = IO.pure(2).delayBy(const Duration(milliseconds: 500));
    final ioc = IO.pure(3).delayBy(const Duration(milliseconds: 500));

    final (elapsed, value) = await (ioa, iob, ioc)
        .parMapN((a, b, c) => a + b + c)
        .timed()
        .unsafeRunToFuture();

    expect(value, 6);
    expect(elapsed.inMilliseconds, closeTo(500, 150));
  });

  test('timeoutTo initial', () {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 200))
        .timeoutTo(const Duration(milliseconds: 100), IO.pure(0));

    expect(io, ioSucceeded(0));
  });

  test('timeoutTo fallback', () {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 100))
        .timeoutTo(const Duration(milliseconds: 200), IO.pure(0));

    expect(io, ioSucceeded(42));
  });

  test('timeout success', () {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 100))
        .timeout(const Duration(milliseconds: 200));

    expect(io, ioSucceeded(42));
  });

  test('timeout failure', () {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 200))
        .timeout(const Duration(milliseconds: 100));

    expect(
      io,
      ioErrored((RuntimeException ex) => ex.message is TimeoutException),
    );
  });

  test('short circuit cancelation', () async {
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    final io = IO
        .pure(1)
        .flatTap((_) => appendOutput('x'))
        .map((a) => a - 1)
        .flatTap((_) => appendOutput('y'))
        .flatTap((i) => i > 0 ? IO.unit : IO.canceled)
        .flatTap((_) => appendOutput('z'))
        .as(42);

    await expectLater(io, ioCanceled());
    expect(output, ['x', 'y']);
  });

  test('uncancelable', () async {
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    final io = IO.uncancelable((_) => appendOutput('A')
        .flatTap((_) => appendOutput('B'))
        .flatMap((a) => IO.canceled)
        .flatTap((_) => appendOutput('C')));

    await expectLater(io, ioSucceeded());
    expect(output, ['A', 'B', 'C']);
  });

  test('uncancelable poll', () async {
    bool innerFinalized = false;
    bool outerFinalized = false;
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    final io = IO.uncancelable((poll) {
      return appendOutput('A')
          .flatTap((_) => appendOutput('B'))
          .flatMap((a) => IO.canceled) // Mark fiber for cancelation
          .flatTap((_) => appendOutput('C'))
          .flatMap(
            (_) => poll(
              // We're canceled, so this flatMap never proceed because we're inside a now-cancelable block
              appendOutput('D')
                  .flatMap((a) => IO.canceled)
                  .flatTap((_) => appendOutput('ZZZ'))
                  .onCancel(IO.exec(() => innerFinalized = true)),
            ),
          )
          .flatTap((_) => appendOutput('E'))
          .onCancel(IO.exec(() => outerFinalized = true));
    });

    await expectLater(io, ioCanceled());

    expect(output, ['A', 'B', 'C']);
    expect(innerFinalized, false);
    expect(outerFinalized, isTrue);
  });

  test('nested uncancelable', () async {
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    final io = IO
        .uncancelable((outer) {
          return IO
              .uncancelable((inner) {
                return inner(
                  appendOutput('A')
                      .productR(() => IO.canceled)
                      .flatTap((_) => appendOutput('B'))
                      .onCancel(appendOutput('task canceled')),
                );
              })
              .flatTap((_) => appendOutput('inner proceeding'))
              .onCancel(appendOutput('inner canceled'));
        })
        .flatTap((_) => appendOutput('outer proceeding'))
        .onCancel(appendOutput('outer canceled'));

    await expectLater(io, ioCanceled());
    expect(output, ['A', 'B', 'inner proceeding', 'outer canceled']);
  });

  test('replicate_', () async {
    var count = 0;
    const n = 100000;

    await expectLater(IO.exec(() => count += 1).replicate_(n), ioSucceeded());
    expect(count, n);
  });

  test('parReplicate_', () async {
    var count = 0;
    const n = 10;

    final (elapsed, _) = await IO
        .exec(() => count += 1)
        .delayBy(const Duration(milliseconds: 200))
        .parReplicate_(n)
        .timed()
        .unsafeRunToFuture();

    expect(elapsed.inMilliseconds, closeTo(225, 150));
    expect(count, n);
  });

  test('racePair A wins', () async {
    final ioa = IO.pure(123).delayBy(const Duration(milliseconds: 150));
    final iob = IO.pure('abc').delayBy(const Duration(milliseconds: 210));

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('racePair A wins should not cancel'),
      (err) => fail('racePair A wins should not error: $err'),
      (a) => a.fold(
        (aWon) => expect(aWon.$1, const Succeeded(123)),
        (bWon) => fail('racePair A wins should not have B win: $bWon'),
      ),
    );

    // Not sure why this is necessary but previous bugs would only appear
    // when this was added
    await Future.delayed(const Duration(seconds: 1), () {});
  });

  test('racePair B wins', () async {
    final ioa = IO.pure(123).delayBy(const Duration(milliseconds: 150));
    final iob = IO.pure('abc').delayBy(const Duration(milliseconds: 50));

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('racePair B wins should not cancel'),
      (err) => fail('racePair B wins should not error: $err'),
      (a) => a.fold(
        (aWon) => fail('racePair B wins should not have A win: $aWon'),
        (bWon) => expect(bWon.$2, const Succeeded('abc')),
      ),
    );

    // Not sure why this is necessary but previous bugs would only appear
    // when this was added
    await Future.delayed(const Duration(seconds: 1), () {});
  });

  test('race', () async {
    bool aCanceled = false;
    bool bCanceled = false;

    final ioa = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 100))
        .onCancel(IO.exec(() => aCanceled = true));

    final iob = IO
        .pure('B')
        .delayBy(const Duration(milliseconds: 200))
        .onCancel(IO.exec(() => bCanceled = true));

    await expectLater(IO.race(ioa, iob), ioSucceeded(42.asLeft<String>()));
    expect(aCanceled, isFalse);
    expect(bCanceled, isTrue);
  });

  test('both success', () {
    final ioa = IO.pure(0).delayBy(const Duration(milliseconds: 200));
    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 100));

    expect(IO.both(ioa, iob), ioSucceeded((0, 1)));
  });

  test('both error', () {
    final ioa = IO
        .pure(0)
        .delayBy(const Duration(milliseconds: 200))
        .productR(() => IO.raiseError<int>(RuntimeException('boom')));

    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 100));

    expect(IO.both(ioa, iob), ioErrored());
  });

  test('both (A canceled)', () {
    final ioa = IO
        .pure(0)
        .productR(() => IO.canceled)
        .delayBy(const Duration(milliseconds: 100));

    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 200));

    expect(IO.both(ioa, iob), ioCanceled());
  });

  test('both (B canceled)', () {
    final ioa = IO.pure(0).delayBy(const Duration(milliseconds: 200));

    final iob = IO
        .pure(1)
        .productR(() => IO.canceled)
        .delayBy(const Duration(milliseconds: 100));

    expect(IO.both(ioa, iob), ioCanceled());
  });

  test('background (child finishes)', () async {
    int count = 0;
    bool canceled = false;

    final tinyTask = IO
        .exec(() => count += 1)
        .delayBy(const Duration(milliseconds: 50))
        .iterateWhile((_) => count < 5)
        .onCancel(IO.exec(() => canceled = true));

    final test =
        tinyTask.background().surround(IO.sleep(const Duration(seconds: 1)));

    await expectLater(test, ioSucceeded());
    expect(count, 5);
    expect(canceled, isFalse);
  });

  test('background (child canceled)', () async {
    int count = 0;
    bool canceled = false;

    final foreverTask = IO
        .exec(() => count += 1)
        .delayBy(const Duration(milliseconds: 50))
        .foreverM()
        .onCancel(IO.exec(() => canceled = true));

    final test = foreverTask
        .background()
        .use((_) => IO.sleep(const Duration(seconds: 1)));

    await expectLater(test, ioSucceeded());
    expect(count, 19);
    expect(canceled, isTrue);
  });

  test('whileM', () {
    final start = DateTime.now();
    final cond = IO.delay(() => DateTime.now().difference(start).inSeconds < 1);
    final test =
        IO.pure(1).delayBy(const Duration(milliseconds: 200)).whilelM(cond);

    expect(test, ioSucceeded(IList.fill(5, 1)));
  });

  test('whileM_', () async {
    int count = 0;
    final cond = IO.delay(() => count < 100);
    final test = IO.exec(() => count++).whileM_(cond);

    await expectLater(test, ioSucceeded());
    expect(count, 100);
  });

  test('untilM', () {
    int count = 0;
    final cond = IO.delay(() => count == 100);
    final test = IO.exec(() => count++).untilM(cond);

    expect(test, ioSucceeded(IList.fill(100, Unit())));
  });

  test('untilM_', () async {
    int count = 0;
    final cond = IO.delay(() => count == 100);
    final test = IO.exec(() => count++).untilM_(cond);

    await expectLater(test, ioSucceeded());
    expect(count, 100);
  });

  test('toSyncIO', () {
    final syncIO = IO
        .pure(21)
        .flatMap((x) => IO.pure(x * 2))
        .toSyncIO(100)
        .unsafeRunSync();

    syncIO.fold(
      (io) => fail('IO -> SyncIO failed!'),
      (syncIO) => expect(syncIO, 42),
    );
  });
}
