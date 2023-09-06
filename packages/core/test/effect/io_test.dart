import 'dart:async';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('pure', () async {
    final io = IO.pure(42);
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('pure should not cancel'),
      (err) => fail('pure should not error: $err'),
      (value) => expect(value, 42),
    );
  });

  test('raiseError', () async {
    final io = IO.raiseError<int>(IOError('boom'));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('raiseError should not fail!'),
      (err) => expect(err.message, 'boom'),
      (value) => fail('raiseError should not succeed: $value'),
    );
  });

  test('delay', () async {
    final io = IO.delay(() => 2 * 21);
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('delay should not cancel'),
      (err) => fail('delay should not fail: $err'),
      (value) => expect(value, 42),
    );
  });

  test('fromFuture success', () async {
    final io = IO.fromFuture(IO.delay(
        () => Future.delayed(const Duration(milliseconds: 250), () => 42)));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('fromFuture success should not cancel'),
      (err) => fail('fromFuture success should not error: $err'),
      (value) => expect(value, 42),
    );
  });

  test('fromFuture error', () async {
    await suppressExceptions(() async {
      final io = IO.fromFuture(IO.delay(() => Future<int>.delayed(
          const Duration(milliseconds: 250), () => Future.error('boom'))));
      final outcome = await io.unsafeRunToFutureOutcome();

      outcome.fold(
        () => fail('fromFuture error should not cancel'),
        (err) => expect(err.message, 'boom'),
        (a) => fail('fromFuture error should not succeed: $a'),
      );
    });
  });

  test('fromCancelableOperation success', () async {
    bool opWasCanceled = false;

    final io = IO
        .fromCancelableOperation(IO.delay(() => CancelableOperation.fromFuture(
              Future.delayed(const Duration(milliseconds: 200), () => 42),
              onCancel: () => opWasCanceled = true,
            )));

    final oc = await io.unsafeRunToFutureOutcome();

    expect(oc, const Succeeded(42));
    expect(opWasCanceled, false);
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

  test('map pure', () async {
    const n = 200;

    IO<int> build(IO<int> io, int loop) =>
        loop <= 0 ? io : build(io.map((x) => x + 1), loop - 1);

    final io = build(IO.pure(0), n);
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('map pure should not cancel'),
      (err) => fail('map pure should not fail: $err'),
      (value) => expect(value, n),
    );
  });

  test('map error', () async {
    final io = IO.pure(42).map((a) => a ~/ 0);
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('map error should not cancel'),
      (err) => expect(err.message, isA<UnsupportedError>()),
      (value) => fail('map error should not succeed: $value'),
    );
  });

  test('flatMap pure', () async {
    final io = IO.pure(42).flatMap((i) => IO.pure('$i / ${i * 2}'));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('flatMap pure should not cancel'),
      (err) => fail('flatMap pure should not fail: $err'),
      (value) => expect(value, '42 / 84'),
    );
  });

  test('flatMap error', () async {
    final io =
        IO.pure(42).flatMap((i) => IO.raiseError<String>(IOError('boom')));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('flatMap error should not cancel'),
      (err) => expect(err.message, 'boom'),
      (value) => fail('flatMap error should not succeed: $value'),
    );
  });

  test('flatMap delay', () async {
    final io = IO.delay(() => 3).flatMap((i) => IO.delay(() => '*' * i));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('flatMap delay should not cancel'),
      (err) => fail('flatMap delay should not fail: $err'),
      (value) => expect(value, '***'),
    );
  });

  test('attempt pure', () async {
    final io = IO.pure(42).attempt();
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('attempt pure should not cancel'),
      (err) => fail('attempt pure should not fail: $err'),
      (value) => expect(value, 42.asRight<IOError>()),
    );
  });

  test('attempt error', () async {
    final io = IO.raiseError<int>(IOError('boom')).attempt();
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('attempt error should not cancel'),
      (err) => fail('attempt error should not fail: $err'),
      (value) => value.fold((err) => expect(err.message, 'boom'),
          (a) => fail('attempt error should not be right: $a')),
    );
  });

  test('attempt delay success', () async {
    final io = IO.delay(() => 42).attempt();
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('attempt delay success should not cancel'),
      (err) => fail('attempt delay success should not fail: $err'),
      (value) => expect(value, 42.asRight<IOError>()),
    );
  });

  test('attempt delay error', () async {
    final io = IO.delay(() => 42 ~/ 0).attempt();
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('attempt delay error should not cancel'),
      (err) => fail('attempt delay error should not fail: $err'),
      (value) => value.fold(
        (err) => expect(err.message, isA<UnsupportedError>()),
        (value) => fail('attempt delay error should not be right: $value'),
      ),
    );
  });

  test('attempt and map', () async {
    final io = IO
        .delay(() => throw StateError('boom'))
        .attempt()
        .map((x) => x.fold((a) => 0, (a) => 1));

    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('attempt and map should not cancel'),
      (err) => fail('attempt and map should not fail: $err'),
      (value) => expect(value, 0),
    );
  });

  test('sleep', () async {
    final io = IO.sleep(const Duration(milliseconds: 250));
    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, Succeeded(Unit()));
  });

  test('handleErrorWith pure', () async {
    final io = IO.pure(42).handleErrorWith((_) => IO.pure(0));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('handleErrorWith pure should not cancel'),
      (err) => fail('handleErrorWith pure should not fail: $err'),
      (value) => expect(value, 42),
    );
  });

  test('handleErrorWith error', () async {
    final io = IO.delay(() => 1 ~/ 0).handleErrorWith((_) => IO.pure(42));
    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('handleErrorWith error should not cancel'),
      (err) => fail('handleErrorWith error should not fail: $err'),
      (value) => expect(value, 42),
    );
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

    final outcome = await io.unsafeRunToFutureOutcome();

    outcome.fold(
      () => fail('async simple should not cancel'),
      (err) => fail('async simple should not fail: $err'),
      (value) => expect(value, 42),
    );
  });

  test('unsafeRunToFuture success', () async {
    expect(await IO.pure(42).unsafeRunToFuture(), 42);
    expect(IO.raiseError<int>(IOError('boom')).unsafeRunToFuture(),
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

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, const Succeeded(42));
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

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(count, 6);

    outcome.fold(
      () => fail('onError error should not cancel'),
      (err) => expect(err.message, isA<UnsupportedError>()),
      (a) => fail('onError error should not succeed: $a'),
    );
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

    await IO.unit.guaranteeCase(fin).unsafeRunToFuture();

    expect(count, 3);

    count = 0;

    await IO
        .raiseError<Unit>(IOError('boom'))
        .guaranteeCase(fin)
        .unsafeRunToFutureOutcome();

    expect(count, 2);

    count = 0;

    await IO.canceled.guaranteeCase(fin).unsafeRunToFutureOutcome();

    expect(count, 1);
  });

  test('timed', () async {
    final ioa = IO.pure(42).delayBy(const Duration(milliseconds: 250)).timed();

    final result = await ioa.unsafeRunToFuture();

    result(
      (elapsed, value) {
        expect(value, 42);
        expect(elapsed.inMilliseconds, closeTo(250, 50));
      },
    );
  });

  test('map3', () async {
    final ioa = IO.pure(1).delayBy(const Duration(milliseconds: 200));
    final iob = IO.pure(2).delayBy(const Duration(milliseconds: 200));
    final ioc = IO.pure(3).delayBy(const Duration(milliseconds: 200));

    final result = await (ioa, iob, ioc)
        .mapN((a, b, c) => a + b + c)
        .timed()
        .unsafeRunToFuture();

    result(
      (elapsed, value) {
        expect(value, 6);
        expect(elapsed.inMilliseconds, closeTo(600, 50));
      },
    );
  });

  test('asyncMapN', () async {
    final ioa = IO.pure(1).delayBy(const Duration(milliseconds: 200));
    final iob = IO.pure(2).delayBy(const Duration(milliseconds: 200));
    final ioc = IO.pure(3).delayBy(const Duration(milliseconds: 200));

    final result = await (ioa, iob, ioc)
        .parMapN((a, b, c) => a + b + c)
        .timed()
        .unsafeRunToFuture();

    result(
      (elapsed, value) {
        expect(value, 6);
        expect(elapsed.inMilliseconds, closeTo(200, 50));
      },
    );
  });

  test('timeoutTo initial', () async {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 200))
        .timeoutTo(const Duration(milliseconds: 100), IO.pure(0));

    final outcome = await io.unsafeRunToFuture();

    expect(outcome, 0);
  });

  test('timeoutTo fallback', () async {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 100))
        .timeoutTo(const Duration(milliseconds: 200), IO.pure(0));

    final outcome = await io.unsafeRunToFuture();

    expect(outcome, 42);
  });

  test('timeout success', () async {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 100))
        .timeout(const Duration(milliseconds: 200));

    final oc = await io.unsafeRunToFutureOutcome();

    expect(oc, const Succeeded(42));
  });

  test('timeout failure', () async {
    final io = IO
        .pure(42)
        .delayBy(const Duration(milliseconds: 200))
        .timeout(const Duration(milliseconds: 100));

    final oc = await io.unsafeRunToFutureOutcome();

    oc.fold(
      () => fail('timeout failure should not cancel'),
      (err) => expect(err.message, isA<TimeoutException>()),
      (a) => fail('timeout failure should not succeed: $a'),
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

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, const Canceled());
    expect(output, ['x', 'y']);
  });

  test('uncancelable', () async {
    final output = List<String>.empty(growable: true);

    IO<Unit> appendOutput(String s) => IO.exec(() => output.add(s));

    final io = IO.uncancelable((_) => appendOutput('A')
        .flatTap((_) => appendOutput('B'))
        .flatMap((a) => IO.canceled)
        .flatTap((_) => appendOutput('C')));

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, Succeeded(Unit()));
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

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, const Canceled());
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

    final outcome = await io.unsafeRunToFutureOutcome();

    expect(outcome, const Canceled());
    expect(output, ['A', 'B', 'inner proceeding', 'outer canceled']);
  });

  test('replicate_', () async {
    var count = 0;
    const n = 100000;

    final io = IO.exec(() => count += 1).replicate_(n);

    await io.unsafeRunToFutureOutcome();

    expect(count, n);
  });

  test('racePair A wins', () async {
    final ioa = IO.pure(123).delayBy(const Duration(milliseconds: 150));
    final iob = IO.pure('abc').delayBy(const Duration(milliseconds: 210));

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunToFutureOutcome();

    // wait for the loser
    await outcome
        .fold(
          () => IO.unit,
          (_) => IO.unit,
          (winner) => winner.fold(
            (aWon) => aWon.$2.join().voided(),
            (bWon) => bWon.$1.join().voided(),
          ),
        )
        .unsafeRunToFuture();

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
    final ioa = IO.pure(123).delayBy(const Duration(milliseconds: 500));
    final iob = IO.pure('abc').delayBy(const Duration(milliseconds: 50));

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunToFutureOutcome();

    // wait for the loser
    await outcome
        .fold(
          () => IO.unit,
          (_) => IO.unit,
          (winner) => winner.fold(
            (aWon) => aWon.$2.join().voided(),
            (bWon) => bWon.$1.join().voided(),
          ),
        )
        .unsafeRunToFuture();

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
        .delayBy(const Duration(milliseconds: 180))
        .onCancel(IO.exec(() => bCanceled = true));

    final outcome = await IO.race(ioa, iob).unsafeRunToFuture();

    expect(outcome, 42.asLeft<String>());
    expect(aCanceled, isFalse);
    expect(bCanceled, isTrue);
  });

  test('both success', () async {
    final ioa = IO.pure(0).delayBy(const Duration(milliseconds: 200));
    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 100));

    final oc = await IO.both(ioa, iob).unsafeRunToFutureOutcome();

    expect(oc, const Succeeded((0, 1)));
  });

  test('both error', () async {
    final ioa = IO
        .pure(0)
        .delayBy(const Duration(milliseconds: 200))
        .productR(() => IO.raiseError<int>(IOError('boom')));
    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 100));

    final oc = await IO.both(ioa, iob).unsafeRunToFutureOutcome();

    expect(oc.isError, isTrue);
  });

  test('both [winner (A) canceled]', () async {
    final ioa = IO
        .pure(0)
        .productR(() => IO.canceled)
        .delayBy(const Duration(milliseconds: 100));

    final iob = IO.pure(1).delayBy(const Duration(milliseconds: 200));

    final oc = await IO.both(ioa, iob).unsafeRunToFutureOutcome();

    expect(oc.isCanceled, isTrue);
  });

  test('both [winner (B) canceled]', () async {
    final ioa = IO.pure(0).delayBy(const Duration(milliseconds: 200));

    final iob = IO
        .pure(1)
        .productR(() => IO.canceled)
        .delayBy(const Duration(milliseconds: 100));

    final oc = await IO.both(ioa, iob).unsafeRunToFutureOutcome();

    expect(oc.isCanceled, isTrue);
  });
}

// (Probably terrible) method of not failing a test that uses/expects a throw or Future.error
Future<void> suppressExceptions(Function0<FutureOr<void>> f) async {
  final zone = Zone.current.fork(
    specification: ZoneSpecification(
      handleUncaughtError: (self, parent, zone, error, stackTrace) {
        if (error is TestFailure) throw error;
      },
    ),
  );

  final c = Completer<void>();

  zone.runGuarded(() async {
    try {
      await f();
    } finally {
      c.complete();
    }
  });

  await c.future;
}
