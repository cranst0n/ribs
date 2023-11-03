import 'dart:async';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('IO', () {
    group('race', () {
      test('succeed with faster side', () {
        expect(
          IO.race(
            IO.sleep(const Duration(minutes: 10)).productR(() => IO.pure(1)),
            IO.pure(2),
          ),
          ioSucceeded(const Right<int, int>(2)),
        );
      });

      test('fail if lhs fails', () {
        final err = RuntimeException('boom');
        expect(
          IO
              .race(
                IO.raiseError<int>(err),
                IO
                    .sleep(const Duration(milliseconds: 10))
                    .productR(() => IO.pure(1)),
              )
              .voided(),
          ioErrored(err),
        );
      });

      test('fail if rhs fails', () {
        final err = RuntimeException('boom');
        expect(
          IO
              .race(
                IO
                    .sleep(const Duration(milliseconds: 10))
                    .productR(() => IO.pure(1)),
                IO.raiseError<int>(err),
              )
              .voided(),
          ioErrored(err),
        );
      });

      test('fail if lhs fails and rhs never completes', () {
        final err = RuntimeException('boom');
        expect(
          IO.race(IO.raiseError<int>(err), IO.never<int>()).voided(),
          ioErrored(err),
        );
      });

      test('fail if rhs fails and lhs never completes', () {
        final err = RuntimeException('boom');
        expect(
          IO.race(IO.never<int>(), IO.raiseError<int>(err)).voided(),
          ioErrored(err),
        );
      });

      test('succeed if lhs never completes', () {
        expect(
          IO.race(IO.never<int>(), IO.pure(2)),
          ioSucceeded(const Right<int, int>(2)),
        );
      });

      test('succeed if rhs never completes', () {
        expect(
          IO.race(IO.pure(2), IO.never<int>()),
          ioSucceeded(const Left<int, int>(2)),
        );
      });

      test('cancel if both sides cancel', () {
        expect(
          IO
              .both(IO.canceled, IO.canceled)
              .voided()
              .start()
              .flatMap((f) => f.join()),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test('cancel if lhs cancels and rhs succeeds', () {
        expect(
          IO
              .race(
                IO.canceled,
                IO
                    .sleep(const Duration(milliseconds: 1))
                    .productR(() => IO.pure(1)),
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if rhs cancels and lhs succeeds', () {
        expect(
          IO
              .race(
                IO
                    .sleep(const Duration(milliseconds: 1))
                    .productR(() => IO.pure(1)),
                IO.canceled,
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if lhs cancels and rhs fails', () {
        final err = RuntimeException('boom');
        expect(
          IO
              .race(
                IO.canceled,
                IO
                    .sleep(const Duration(milliseconds: 1))
                    .productR(() => IO.raiseError<Unit>(err)),
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if rhs cancels and lhs fails', () {
        final err = RuntimeException('boom');
        expect(
          IO
              .race(
                IO
                    .sleep(const Duration(milliseconds: 1))
                    .productR(() => IO.raiseError<Unit>(err)),
                IO.canceled,
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('evaluate a timeout using sleep and race', () {
        expect(
          IO.race(IO.never<Unit>(), IO.sleep(const Duration(seconds: 2))),
          ioSucceeded(Right<Unit, Unit>(Unit())),
        );
      });

      test('immediately cancel when timing out canceled', () {
        final test = IO.canceled
            .timeout(const Duration(seconds: 2))
            .start()
            .flatMap((f) => f.join());

        expect(test, ioSucceeded(Outcome.canceled<Unit>()));
      });

      test('immediately cancel when timing out and forgetting canceled', () {
        final test = IO
            .never<Unit>()
            .timeoutAndForget(const Duration(seconds: 2))
            .timeout(const Duration(seconds: 1))
            .start()
            .flatMap((f) => f.join());

        expect(test, ioSucceeded((Outcome<Unit> oc) => oc.isError));
      });

      test('return the left when racing against never', () {
        final test = IO.racePair(IO.pure(42), IO.never<Unit>()).map(
            (a) => a.swap().map((a) => a.$1).getOrElse(() => fail('boom!')));

        expect(test, ioSucceeded(Outcome.succeeded(42)));
      });

      test('immediately cancel inner race when outer unit', () {
        final test = IO.now.flatMap((start) => IO
            .race(
              IO.unit,
              IO.race(IO.never<Unit>(), IO.sleep(const Duration(seconds: 10))),
            )
            .flatMap((_) => IO.now.map((end) => end.difference(start))));

        expect(test, ioSucceeded((Duration d) => d.inSeconds < 2));
      });
    });

    group('cancelation', () {
      test('implement never with non-terminating semantics', () {
        expect(
          IO.never<int>().timeout(const Duration(seconds: 2)),
          ioErrored(),
        );
      });

      test('cancel an infinite chain of right-binds', () {
        IO<Unit> infinite() => IO.unit.flatMap((_) => infinite());
        expect(
          infinite()
              .start()
              .flatMap((f) => f.cancel().productR(() => f.join())),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test('cancel never', () {
        expect(
          IO
              .never<Unit>()
              .start()
              .flatMap((f) => f.cancel().productR(() => f.join())),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test(
          'cancel flatMap continuations following a canceled uncancelable block',
          () {
        expect(
          IO.uncancelable((_) => IO.canceled).flatMap((_) => IO.unit),
          ioCanceled(),
        );
      });

      test('sequence onCancel when canceled before registration', () async {
        var passed = false;

        final test = IO.uncancelable((poll) => IO.canceled.productR(
            () => poll(IO.unit).onCancel(IO.exec(() => passed = true))));

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('break out of uncancelable when canceled before poll', () async {
        var passed = true;

        final test = IO.uncancelable((poll) {
          return IO.canceled.productR(() =>
              poll(IO.unit).productR(() => IO.exec(() => passed = false)));
        });

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('not invoke onCancel when previously canceled within uncancelable',
          () async {
        var failed = false;

        final test = IO.uncancelable((_) {
          return IO.canceled
              .productR(() => IO.unit.onCancel(IO.exec(() => failed = true)));
        });

        await expectLater(test, ioSucceeded());
        expect(failed, isFalse);
      });

      test('support re-enablement via cancelable', () {
        final io = IO.deferred<Unit>().flatMap((gate) {
          final test = IO.deferred<Unit>().flatMap((latch) => IO
              .uncancelable(
                  (_) => gate.complete(Unit()).productR(() => latch.value()))
              .cancelable(latch.complete(Unit()).voided()));

          return test
              .start()
              .flatMap((f) => gate.value().productR(() => f.cancel()));
        });

        expect(io, ioSucceeded(Unit()));
      }, skip: 'No ticker');

      test('only unmask within current fiber', () async {
        var passed = false;

        final test = IO.uncancelable((poll) {
          return IO
              .uncancelable((_) {
                return poll(IO.canceled)
                    .productR(() => IO.exec(() => passed = true));
              })
              .start()
              .flatMap((f) => f.join())
              .voided();
        });

        await expectLater(test, ioSucceeded(Unit()));
        expect(passed, isTrue);
      });

      test('polls from unrelated fibers are no-ops', () async {
        var canceled = false;

        final test = IO.deferred<Poll>().flatMap((deferred) {
          return IO.deferred<Unit>().flatMap((started) {
            return IO
                .uncancelable(deferred.complete)
                .voided()
                .start()
                .flatMap((_) {
              final action = started.complete(Unit()).productR(() => deferred
                  .value()
                  .flatMap((poll) => poll(IO.never<Unit>())
                      .onCancel(IO.exec(() => canceled = true))));

              return IO.uncancelable((_) => action).start().flatMap((f) {
                return started.value().flatMap((_) {
                  return f.cancel();
                });
              });
            });
          });
        });

        await expectLater(test, ioErrored());
        expect(canceled, isFalse);
      }, skip: 'Expected to be non-terminating');

      test('run three finalizers when an async is canceled while suspended',
          () async {
        final results = List<int>.empty(growable: true);

        final body =
            IO.async((_) => IO.pure(Some(IO.exec(() => results.insert(0, 3)))));

        final test = body
            .onCancel(IO.exec(() => results.insert(0, 2)))
            .onCancel(IO.exec(() => results.insert(0, 1)))
            .start()
            .flatMap((f) {
          return IO.cede
              .flatMap((_) => f.cancel().flatMap((_) => IO.pure(results)));
        });

        expect(test, ioSucceeded([1, 2, 3]));
      });

      test('uncancelable canceled with finalizer within fiber should not block',
          () {
        final fab = IO
            .uncancelable((_) => IO.canceled.onCancel(IO.unit))
            .start()
            .flatMap((f) => f.join());

        expect(fab, ioSucceeded(Outcome.succeeded(Unit())));
      });

      test(
          'uncancelable canceled with finalizer within fiber should flatMap another day',
          () {
        final fa = IO.pure(42);
        final fab = IO
            .uncancelable((_) => IO.canceled.onCancel(IO.unit))
            .start()
            .flatMap((f) => f.join().flatMap((_) => IO.pure((int i) => i)));

        expect(fa.ap(fab), ioSucceeded(42));
      });

      test('ignore repeated polls', () async {
        var passed = true;

        final test = IO.uncancelable((poll) =>
            poll(poll(IO.unit).productR(() => IO.canceled))
                .productR(() => IO.exec(() => passed = false)));

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('never terminate when racing infinite cancels', () async {
        var started = false;

        final markStarted = IO.exec(() => started = true);

        IO<Unit> cedeUntilStarted() => IO.delay(() => started).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        final test = markStarted
            .productR(() => IO.never<Unit>())
            .onCancel(IO.never())
            .start()
            .flatMap((f) {
          return cedeUntilStarted().flatMap((_) {
            return IO.race(f.cancel(), f.cancel());
          });
        }).voided();

        expect(test.timeout(const Duration(seconds: 5)), ioErrored());
      }, skip: 'Expected to be non-terminating');

      test('first canceller backpressures subsequent cancellers', () async {
        var started = false;
        var started2 = false;

        final markStarted = IO.exec(() => started = true);
        final markStarted2 = IO.exec(() => started2 = true);

        IO<Unit> cedeUntilStarted() => IO.delay(() => started).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        IO<Unit> cedeUntilStarted2() => IO.delay(() => started2).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted2()));

        final test = markStarted
            .productR(() => IO.never<Unit>())
            .onCancel(IO.never())
            .start()
            .flatMap((first) {
          return cedeUntilStarted()
              .productR(() => markStarted2)
              .productR(() => first.cancel())
              .start()
              .flatMap((_) {
            return cedeUntilStarted2().productR(() => first.cancel());
          });
        });

        expect(test, ioErrored());
      }, skip: 'Expected to be non-terminating');

      test('reliably cancel infinite IO.unit(s)', () {
        final test = IO.unit.foreverM().start().flatMap((f) => IO
            .sleep(const Duration(milliseconds: 50))
            .productR(() => f.cancel()));

        expect(test, ioSucceeded());
      });

      test('reliably cancel infinite IO.cede(s)', () {
        final test = IO.cede.foreverM().start().flatMap((f) => IO
            .sleep(const Duration(milliseconds: 50))
            .productR(() => f.cancel()));

        expect(test, ioSucceeded());
      });

      test('cancel a long sleep with a short one', () {
        expect(
          IO.race(
            IO.sleep(const Duration(seconds: 10)),
            IO.sleep(const Duration(milliseconds: 50)),
          ),
          ioSucceeded(Right<Unit, Unit>(Unit())),
        );
      });

      test('await uncancelable blocks in cancelation', () async {
        var started = false;

        final markStarted = IO.exec(() => started = true);

        IO<Unit> cedeUntilStarted() => IO.delay(() => started).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        final test = IO
            .uncancelable((_) => markStarted.productR(() => IO.never<Unit>()))
            .start()
            .flatMap((f) => cedeUntilStarted().productR(() => f.cancel()));

        expect(test, ioErrored());
      }, skip: 'Expected to be non-terminating');

      test('await cancelation of cancelation of uncancelable never', () async {
        var started = false;
        var started2 = false;

        final markStarted = IO.exec(() => started = true);
        final markStarted2 = IO.exec(() => started2 = true);

        IO<Unit> cedeUntilStarted() => IO.delay(() => started).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        IO<Unit> cedeUntilStarted2() => IO.delay(() => started2).ifM(
            () => IO.unit, () => IO.cede.productR(() => cedeUntilStarted2()));

        final test = IO
            .uncancelable((_) => markStarted.productR(() => IO.never<Unit>()))
            .start()
            .flatMap((first) {
          return IO
              .uncancelable((poll) => cedeUntilStarted()
                  .productR(() => markStarted2)
                  .productR(() => poll(first.cancel())))
              .start()
              .flatMap((second) {
            return cedeUntilStarted2().flatMap((_) {
              return second.cancel();
            });
          });
        });

        expect(test, ioErrored());
      }, skip: 'Expected to be non-terminating');

      test('catch stray exceptions in uncancelable', () {
        expect(
          IO
              .uncancelable<Unit>((_) => throw RuntimeException('boom'))
              .voidError(),
          ioSucceeded(Unit()),
        );
      });

      test('unmask following stray exceptions in uncancelable', () {
        expect(
          IO
              .uncancelable<Unit>((_) => throw RuntimeException('boom'))
              .handleErrorWith((_) => IO.canceled.productR(() => IO.never())),
          ioCanceled(),
        );
      });
    });

    group('finalization', () {
      test('mapping something with a finalizer should complete', () {
        expect(IO.pure(42).onCancel(IO.unit).as(Unit()), ioSucceeded(Unit()));
      });

      test('run an identity finalizer', () async {
        var affected = false;

        await expectLater(
          IO.unit.guaranteeCase((_) => IO.exec(() => affected = true)),
          ioSucceeded(Unit()),
        );

        expect(affected, isTrue);
      });

      test('run an identity finalizer and continue', () async {
        var affected = false;

        final seed =
            IO.unit.guaranteeCase((_) => IO.exec(() => affected = true));

        await expectLater(seed.as(42), ioSucceeded(42));

        expect(affected, isTrue);
      });

      test('run multiple nested finalizers on cancel', () async {
        var inner = false;
        var outer = false;

        final test = IO.canceled
            .guarantee(IO.exec(() => inner = true))
            .guarantee(IO.exec(() => outer = true));

        await expectLater(test, ioCanceled());

        expect(inner, isTrue);
        expect(outer, isTrue);
      });

      test('run multiple nested finalizers on completion exactly once',
          () async {
        var inner = 0;
        var outer = 0;

        final test = IO.unit
            .guarantee(IO.exec(() => inner += 1))
            .guarantee(IO.exec(() => outer += 1));

        await expectLater(test, ioSucceeded(Unit()));

        expect(inner, 1);
        expect(outer, 1);
      });

      test('invoke onCase finalizer when cancelable async returns', () async {
        var passed = false;

        final test = IO.sleep(const Duration(seconds: 2)).guaranteeCase((oc) {
          return switch (oc) {
            final Succeeded<Unit> _ => IO.exec(() => passed = true),
            _ => IO.unit,
          };
        });

        await expectLater(test, ioSucceeded(Unit()));
        expect(passed, isTrue);
      });

      test('hold onto errors through multiple finalizers', () {
        final err = RuntimeException('boom');

        expect(
          IO.raiseError<int>(err).guarantee(IO.unit).guarantee(IO.unit),
          ioErrored(err),
        );
      });

      test('cede unit in a finalizer', () {
        final body = IO
            .sleep(const Duration(seconds: 1))
            .start()
            .flatMap((f) => f.join())
            .map((_) => 42);

        expect(body.guarantee(IO.cede.as(Unit())), ioSucceeded(42));
      });

      test(
          'ensure async callback is suppressed during suspension of async finalizers',
          () {
        Function1<Either<RuntimeException, Unit>, void>? cb;

        final subject = IO.async<Unit>((cb0) {
          return IO.delay(() {
            cb = cb0;
            return Some(IO.never());
          });
        });

        final test = subject.start().flatMap((f) {
          return f.cancel().start().flatMap((_) {
            return IO.delay(() => cb?.call(Right(Unit()))).voided();
          });
        });

        expect(test, ioSucceeded(Unit()));
      });

      test(
          'not finalize after uncancelable with suppressed cancelation (succeeded)',
          () async {
        var finalized = false;

        final test = IO
            .uncancelable((_) => IO.canceled.productR(() => IO.pure(42)))
            .onCancel(IO.exec(() => finalized = true))
            .voided();

        await expectLater(test, ioSucceeded(Unit()));
        expect(finalized, isFalse);
      });

      test(
          'not finalize after uncancelable with suppressed cancelation (errored)',
          () async {
        final err = RuntimeException('boom');

        var finalized = false;

        final test = IO
            .uncancelable(
                (_) => IO.canceled.productR(() => IO.raiseError<int>(err)))
            .onCancel(IO.exec(() => finalized = true))
            .voided();

        await expectLater(test, ioErrored(err));
        expect(finalized, isFalse);
      });

      test('finalize on uncaught errors in bracket use clauses', () {
        final test = IO.ref(false).flatMap((ref) {
          return IO
              .bracketFull<Unit, Unit>(
                (_) => IO.unit,
                (_) => throw Exception('borked!'),
                (_, __) => ref.setValue(true),
              )
              .attempt()
              .flatMap((_) {
            return ref.value();
          });
        });

        expect(test, ioSucceeded(true));
      });
    });

    group('miscellaneous', () {
      test('canceled through s.c.Future is errored', () {
        final test = IO
            .fromFutureF(() => IO.canceled.as(-1).unsafeRunFuture())
            .handleError((_) => 42);

        expect(test, ioSucceeded(42));
      });

      test('run a synchronous IO', () {
        final ioa = IO.delay(() => 1).map((a) => a + 2);
        final test = IO.fromFutureF(() => ioa.unsafeRunFuture());

        expect(test, ioSucceeded(3));
      });

      test('run an asynchronous IO', () {
        final ioa = IO.delay(() => 1).productL(() => IO.cede).map((a) => a + 2);
        final test = IO.fromFutureF(() => ioa.unsafeRunFuture());

        expect(test, ioSucceeded(3));
      });

      test('run several IOs back to back', () {
        var counter = 0;
        final increment = IO.exec(() => counter += 1);

        const n = 10;

        final test = IO
            .fromFutureF(() => increment.unsafeRunFuture())
            .replicate(n)
            .voided()
            .flatMap((_) => IO.delay(() => counter));

        expect(test, ioSucceeded(n));
      });

      test('run multiple IOs in parallel', () {
        const n = 10;

        final test = IList.range(0, n)
            .traverseIO((_) => IO.deferred<Unit>())
            .flatMap((latches) {
          final awaitAll = latches.parTraverseIO_((a) => a.value());
          final subjects =
              latches.map((l) => l.complete(Unit()).productR(() => awaitAll));
          return subjects.parTraverseIO_(
              (act) => IO.delay(() => act.unsafeRunAndForget()));
        });

        expect(test, ioSucceeded(Unit()));
      });
    });
  });

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

    final fiber = await io.start().unsafeRunFuture();

    fiber
        .cancel()
        .delayBy(const Duration(milliseconds: 100))
        .unsafeRunAndForget();

    final oc = await fiber.join().unsafeRunFuture();

    expect(oc, Canceled<int>());
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

    final fiber = await io.start().unsafeRunFuture();

    fiber.cancel().unsafeRunAndForget();

    final outcome = await fiber.join().unsafeRunFuture();

    expect(outcome, Canceled<int>());
    expect(finalized, isTrue);
  });

  test('async_ simple', () async {
    final io = IO.async_<int>((cb) {
      Future.delayed(const Duration(milliseconds: 100), () => 42)
          .then((value) => cb(value.asRight()));
    });

    expect(io, ioSucceeded(42));
  });

  test('unsafeRunFuture success', () async {
    expect(await IO.pure(42).unsafeRunFuture(), 42);
    expect(IO.raiseError<int>(RuntimeException('boom')).unsafeRunFuture(),
        throwsA('boom'));
  });

  test('start simple', () async {
    final io = IO
        .pure(0)
        .flatTap((_) => IO.sleep(const Duration(milliseconds: 200)))
        .as(42);

    final fiber = await io.start().unsafeRunFuture();
    final outcome = await fiber.join().unsafeRunFuture();

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

    final fiber = await io.start().unsafeRunFuture();
    final outcome = await fiber.join().unsafeRunFuture();

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

    final fiber = await io.start().unsafeRunFuture();
    final outcome = await fiber.join().unsafeRunFuture();

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

    final fiber = await io.start().unsafeRunFuture();

    fiber.cancel().unsafeRunAndForget();

    final outcome = await fiber.join().unsafeRunFuture();

    expect(outcome, Canceled<int>());
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

    final fiber = expensive.start().unsafeRunFuture();
    generous.start().unsafeRunAndForget();

    final outcome = await fiber.then((f) => f.join().unsafeRunFuture());

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

    final (elapsed, value) = await ioa.unsafeRunFuture();

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
        .unsafeRunFuture();

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
        .unsafeRunFuture();

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
        .unsafeRunFuture();

    expect(elapsed.inMilliseconds, closeTo(225, 150));
    expect(count, n);
  });

  test('racePair A wins', () async {
    final ioa = IO.pure(123).delayBy(const Duration(milliseconds: 150));
    final iob = IO.pure('abc').delayBy(const Duration(milliseconds: 210));

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunFutureOutcome();

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

    final outcome = await race.unsafeRunFutureOutcome();

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
