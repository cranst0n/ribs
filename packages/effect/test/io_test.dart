import 'dart:async';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('IO', () {
    group('race', () {
      test('succeed with faster side', () {
        expect(
          IO.race(
            IO.sleep(10.minutes).productR(() => IO.pure(1)),
            IO.pure(2),
          ),
          ioSucceeded(const Right<int, int>(2)),
        );
      });

      test('fail if lhs fails', () {
        const err = 'boom';
        expect(
          IO
              .race(
                IO.raiseError<int>(err),
                IO.sleep(10.milliseconds).productR(() => IO.pure(1)),
              )
              .voided(),
          ioErrored(err),
        );
      });

      test('fail if rhs fails', () {
        const err = 'boom';
        expect(
          IO
              .race(
                IO.sleep(10.milliseconds).productR(() => IO.pure(1)),
                IO.raiseError<int>(err),
              )
              .voided(),
          ioErrored(err),
        );
      });

      test('fail if lhs fails and rhs never completes', () {
        const err = 'boom';
        expect(
          IO.race(IO.raiseError<int>(err), IO.never<int>()).voided(),
          ioErrored(err),
        );
      });

      test('fail if rhs fails and lhs never completes', () {
        const err = 'boom';
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
          IO.both(IO.canceled, IO.canceled).voided().start().flatMap((f) => f.join()),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test('cancel if lhs cancels and rhs succeeds', () {
        expect(
          IO
              .race(
                IO.canceled,
                IO.sleep(1.millisecond).productR(() => IO.pure(1)),
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if rhs cancels and lhs succeeds', () {
        expect(
          IO
              .race(
                IO.sleep(1.millisecond).productR(() => IO.pure(1)),
                IO.canceled,
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if lhs cancels and rhs fails', () {
        const err = 'boom';
        expect(
          IO
              .race(
                IO.canceled,
                IO.sleep(1.millisecond).productR(() => IO.raiseError<Unit>(err)),
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('cancel if rhs cancels and lhs fails', () {
        const err = 'boom';
        expect(
          IO
              .race(
                IO.sleep(1.millisecond).productR(() => IO.raiseError<Unit>(err)),
                IO.canceled,
              )
              .voided(),
          ioCanceled(),
        );
      });

      test('evaluate a timeout using sleep and race', () {
        expect(
          IO.race(IO.never<Unit>(), IO.sleep(2.seconds)),
          ioSucceeded(Right<Unit, Unit>(Unit())),
        );
      });

      test('immediately cancel when timing out canceled', () {
        final test = IO.canceled.timeout(2.seconds).start().flatMap((f) => f.join());

        expect(test, ioSucceeded(Outcome.canceled<Unit>()));
      });

      test('immediately cancel when timing out and forgetting canceled', () {
        final test = IO
            .never<Unit>()
            .timeoutAndForget(2.seconds)
            .timeout(1.second)
            .start()
            .flatMap((f) => f.join());

        expect(test, ioSucceeded((Outcome<Unit> oc) => oc.isError));
      });

      test('return the left when racing against never', () {
        final test = IO
            .racePair(IO.pure(42), IO.never<Unit>())
            .map((a) => a.swap().map((a) => a.$1).getOrElse(() => fail('boom!')));

        expect(test, ioSucceeded(Outcome.succeeded(42)));
      });

      test('immediately cancel inner race when outer unit', () {
        final test = IO.now.flatMap(
          (start) => IO
              .race(
                IO.unit,
                IO.race(IO.never<Unit>(), IO.sleep(10.seconds)),
              )
              .flatMap((_) => IO.now.map((end) => end.difference(start))),
        );

        expect(test, ioSucceeded((Duration d) => d.inSeconds < 2));
      });
    });

    group('cancelation', () {
      test('implement never with non-terminating semantics', () {
        expect(
          IO.never<int>().timeout(2.seconds),
          ioErrored(),
        );
      });

      test('cancel an infinite chain of right-binds', () {
        IO<Unit> infinite() => IO.unit.flatMap((_) => infinite());
        expect(
          infinite().start().flatMap((f) => f.cancel().productR(() => f.join())),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test('cancel never', () {
        expect(
          IO.never<Unit>().start().flatMap((f) => f.cancel().productR(() => f.join())),
          ioSucceeded(Outcome.canceled<Unit>()),
        );
      });

      test('cancel flatMap continuations following a canceled uncancelable block', () {
        expect(
          IO.uncancelable((_) => IO.canceled).flatMap((_) => IO.unit),
          ioCanceled(),
        );
      });

      test('sequence onCancel when canceled before registration', () async {
        var passed = false;

        final test = IO.uncancelable(
          (poll) =>
              IO.canceled.productR(() => poll(IO.unit).onCancel(IO.exec(() => passed = true))),
        );

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('break out of uncancelable when canceled before poll', () async {
        var passed = true;

        final test = IO.uncancelable((poll) {
          return IO.canceled.productR(
            () => poll(IO.unit).productR(() => IO.exec(() => passed = false)),
          );
        });

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('not invoke onCancel when previously canceled within uncancelable', () async {
        var failed = false;

        final test = IO.uncancelable((_) {
          return IO.canceled.productR(() => IO.unit.onCancel(IO.exec(() => failed = true)));
        });

        await expectLater(test, ioSucceeded());
        expect(failed, isFalse);
      });

      test('support re-enablement via cancelable', () {
        final io = IO.deferred<Unit>().flatMap((gate) {
          final test = IO.deferred<Unit>().flatMap(
            (latch) => IO
                .uncancelable((_) => gate.complete(Unit()).productR(() => latch.value()))
                .cancelable(latch.complete(Unit()).voided()),
          );

          return test.start().flatMap((f) => gate.value().productR(() => f.cancel()));
        });

        expect(io, ioSucceeded(Unit()));
      });

      test('only unmask within current fiber', () async {
        var passed = false;

        final test = IO.uncancelable((poll) {
          return IO
              .uncancelable((_) {
                return poll(IO.canceled).productR(() => IO.exec(() => passed = true));
              })
              .start()
              .flatMap((f) => f.join())
              .voided();
        });

        await expectLater(test, ioSucceeded(Unit()));
        expect(passed, isTrue);
      });

      test('polls from unrelated fibers are no-ops', () {
        var canceled = false;

        final test = IO.deferred<Poll>().flatMap((deferred) {
          return IO.deferred<Unit>().flatMap((started) {
            return IO.uncancelable(deferred.complete).voided().start().flatMap((_) {
              final action = started
                  .complete(Unit())
                  .productR(
                    () => deferred.value().flatMap(
                      (poll) => poll(IO.never<Unit>()).onCancel(IO.exec(() => canceled = true)),
                    ),
                  );

              return IO.uncancelable((_) => action).start().flatMap((f) {
                return started.value().flatMap((_) {
                  return f.cancel();
                });
              });
            });
          });
        });

        expect(test.ticked.nonTerminating(), isTrue);
        expect(canceled, isFalse);
      });

      test('run three finalizers when an async is canceled while suspended', () {
        final results = List<int>.empty(growable: true);

        final body = IO.async((_) => IO.pure(Some(IO.exec(() => results.insert(0, 3)))));

        final test = body
            .onCancel(IO.exec(() => results.insert(0, 2)))
            .onCancel(IO.exec(() => results.insert(0, 1)))
            .start()
            .flatMap((f) {
              return IO.cede.flatMap((_) => f.cancel().flatMap((_) => IO.pure(results)));
            });

        expect(test, ioSucceeded([1, 2, 3]));
      });

      test('uncancelable canceled with finalizer within fiber should not block', () {
        final fab = IO
            .uncancelable((_) => IO.canceled.onCancel(IO.unit))
            .start()
            .flatMap((f) => f.join());

        expect(fab, ioSucceeded(Outcome.succeeded(Unit())));
      });

      test('uncancelable canceled with finalizer within fiber should flatMap another day', () {
        final fa = IO.pure(42);
        final fab = IO
            .uncancelable((_) => IO.canceled.onCancel(IO.unit))
            .start()
            .flatMap((f) => f.join().flatMap((_) => IO.pure((int i) => i)));

        expect(fa.ap(fab), ioSucceeded(42));
      });

      test('ignore repeated polls', () async {
        var passed = true;

        final test = IO.uncancelable(
          (poll) => poll(
            poll(IO.unit).productR(() => IO.canceled),
          ).productR(() => IO.exec(() => passed = false)),
        );

        await expectLater(test, ioCanceled());
        expect(passed, isTrue);
      });

      test('never terminate when racing infinite cancels', () {
        var started = false;

        final markStarted = IO.exec(() => started = true);

        IO<Unit> cedeUntilStarted() => IO
            .delay(() => started)
            .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        final test =
            markStarted.productR(() => IO.never<Unit>()).onCancel(IO.never()).start().flatMap((f) {
              return cedeUntilStarted().flatMap((_) {
                return IO.race(f.cancel(), f.cancel());
              });
            }).voided();

        expect(test.ticked.nonTerminating(), isTrue);
      });

      test(
        'first canceller backpressures subsequent cancellers',
        () {
          var started = false;
          var started2 = false;

          final markStarted = IO.exec(() => started = true);
          final markStarted2 = IO.exec(() => started2 = true);

          IO<Unit> cedeUntilStarted() => IO
              .delay(() => started)
              .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

          IO<Unit> cedeUntilStarted2() => IO
              .delay(() => started2)
              .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted2()));

          final test = markStarted
              .productR(() => IO.never<Unit>())
              .onCancel(IO.never())
              .start()
              .flatMap(
                (first) => cedeUntilStarted()
                    .productR(() => markStarted2)
                    .productR(() => first.cancel())
                    .start()
                    .productR(() => cedeUntilStarted2().productR(() => first.cancel())),
              );

          expect(test.ticked.nonTerminating(), isTrue);
        },
        skip: 'Expected to be non-terminating (but succeeds)',
      );

      test('reliably cancel infinite IO.unit(s)', () {
        final test = IO.unit.foreverM().start().flatMap(
          (f) => IO.sleep(50.milliseconds).productR(() => f.cancel()),
        );

        expect(test, ioSucceeded());
      });

      test('reliably cancel infinite IO.cede(s)', () {
        final test = IO.cede.foreverM().start().flatMap(
          (f) => IO.sleep(50.milliseconds).productR(() => f.cancel()),
        );

        expect(test, ioSucceeded());
      });

      test('cancel a long sleep with a short one', () {
        expect(
          IO.race(
            IO.sleep(10.seconds),
            IO.sleep(50.milliseconds),
          ),
          ioSucceeded(Right<Unit, Unit>(Unit())),
        );
      });

      test('await uncancelable blocks in cancelation', () {
        var started = false;

        final markStarted = IO.exec(() => started = true);

        IO<Unit> cedeUntilStarted() => IO
            .delay(() => started)
            .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        final test = IO
            .uncancelable((_) => markStarted.productR(() => IO.never<Unit>()))
            .start()
            .flatMap((f) => cedeUntilStarted().productR(() => f.cancel()));

        expect(test.ticked.nonTerminating(), isTrue);
      });

      test('await cancelation of cancelation of uncancelable never', () {
        var started = false;
        var started2 = false;

        final markStarted = IO.exec(() => started = true);
        final markStarted2 = IO.exec(() => started2 = true);

        IO<Unit> cedeUntilStarted() => IO
            .delay(() => started)
            .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted()));

        IO<Unit> cedeUntilStarted2() => IO
            .delay(() => started2)
            .ifM(() => IO.unit, () => IO.cede.productR(() => cedeUntilStarted2()));

        final test = IO
            .uncancelable((_) => markStarted.productR(() => IO.never<Unit>()))
            .start()
            .flatMap((first) {
              return IO
                  .uncancelable(
                    (poll) => cedeUntilStarted()
                        .productR(() => markStarted2)
                        .productR(() => poll(first.cancel())),
                  )
                  .start()
                  .flatMap((second) {
                    return cedeUntilStarted2().flatMap((_) {
                      return second.cancel();
                    });
                  });
            });

        expect(test.ticked.nonTerminating(), isTrue);
      });

      test('catch stray exceptions in uncancelable', () {
        expect(
          IO.uncancelable<Unit>((_) => throw 'boom').voidError(),
          ioSucceeded(Unit()),
        );
      });

      test('unmask following stray exceptions in uncancelable', () {
        expect(
          IO
              .uncancelable<Unit>((_) => throw 'boom')
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

        final seed = IO.unit.guaranteeCase((_) => IO.exec(() => affected = true));

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

      test('run multiple nested finalizers on completion exactly once', () async {
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

        final test = IO.sleep(2.seconds).guaranteeCase((oc) {
          return switch (oc) {
            final Succeeded<Unit> _ => IO.exec(() => passed = true),
            _ => IO.unit,
          };
        });

        await expectLater(test, ioSucceeded(Unit()));
        expect(passed, isTrue);
      });

      test('hold onto errors through multiple finalizers', () {
        const err = 'boom';

        expect(
          IO.raiseError<int>(err).guarantee(IO.unit).guarantee(IO.unit),
          ioErrored(err),
        );
      });

      test('cede unit in a finalizer', () {
        final body = IO.sleep(1.second).start().flatMap((f) => f.join()).map((_) => 42);

        expect(body.guarantee(IO.cede.as(Unit())), ioSucceeded(42));
      });

      test('ensure async callback is suppressed during suspension of async finalizers', () {
        Function1<Either<Object, Unit>, void>? cb;

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

      test('not finalize after uncancelable with suppressed cancelation (succeeded)', () async {
        var finalized = false;

        final test =
            IO
                .uncancelable((_) => IO.canceled.productR(() => IO.pure(42)))
                .onCancel(IO.exec(() => finalized = true))
                .voided();

        await expectLater(test, ioSucceeded(Unit()));
        expect(finalized, isFalse);
      });

      test('not finalize after uncancelable with suppressed cancelation (errored)', () async {
        const err = 'boom';

        var finalized = false;

        final test =
            IO
                .uncancelable((_) => IO.canceled.productR(() => IO.raiseError<int>(err)))
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
                (_, _) => ref.setValue(true),
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

        final test = IList.range(0, n).traverseIO((_) => IO.deferred<Unit>()).flatMap((latches) {
          final awaitAll = latches.parTraverseIO_((a) => a.value());
          final subjects = latches.map((l) => l.complete(Unit()).productR(() => awaitAll));
          return subjects.parTraverseIO_((act) => IO.delay(() => act.unsafeRunAndForget()));
        });

        expect(test, ioSucceeded(Unit()));
      });
    });
  });

  test('pure', () {
    expect(IO.pure(42), ioSucceeded(42));
  });

  test('raiseError', () {
    expect(IO.raiseError<int>('boom'), ioErrored());
  });

  test('delay', () {
    expect(IO.delay(() => 2 * 21), ioSucceeded(42));
  });

  test('fromFuture success', () {
    final io = IO.fromFuture(IO.delay(() => Future.delayed(250.milliseconds, () => 42)));

    expect(io, ioSucceeded(42));
  });

  test('fromFuture error', () {
    final io = IO.fromFuture(
      IO.delay(() => Future<int>.delayed(250.milliseconds, () => Future.error('boom'))),
    );

    expect(io, ioErrored('boom'));
  });

  test('fromCancelableOperation success', () {
    bool opWasCanceled = false;

    final io = IO.fromCancelableOperation(
      IO.delay(
        () => CancelableOperation.fromFuture(
          Future.delayed(200.milliseconds, () => 42),
          onCancel: () => opWasCanceled = true,
        ),
      ),
    );

    expect(io, ioSucceeded(42));
    expect(opWasCanceled, isFalse);
  });

  test('fromCancelableOperation canceled', () async {
    bool opWasCanceled = false;

    final io = IO.fromCancelableOperation(
      IO.delay(
        () => CancelableOperation.fromFuture(
          Future.delayed(500.milliseconds, () => 42),
          onCancel: () => opWasCanceled = true,
        ),
      ),
    );

    final fiber = await io.start().unsafeRunFuture();

    fiber.cancel().delayBy(100.milliseconds).unsafeRunAndForget();

    final oc = await fiber.join().unsafeRunFuture();

    expect(oc, Canceled<int>());
    expect(opWasCanceled, true);
  });

  test('fromEither', () {
    expect(IO.fromEither(42.asRight<String>()), ioSucceeded(42));
    expect(IO.fromEither('boom'.asLeft<int>()), ioErrored());
  });

  test('fromOption', () {
    expect(IO.fromOption(const Some(42), () => 'boom'), ioSucceeded(42));
    expect(IO.fromOption(none<int>(), () => 'boom'), ioErrored());
  });

  test('bothOutcome', () {
    const err = 'boom';

    expect(
      IO.bothOutcome(IO.canceled, IO.raiseError<Unit>(err)),
      ioSucceeded((Outcome.canceled<Unit>(), Outcome.errored<Unit>(err))),
    );

    expect(
      IO.bothOutcome(IO.canceled, IO.pure(Unit())),
      ioSucceeded((Outcome.canceled<Unit>(), Outcome.succeeded<Unit>(Unit()))),
    );

    expect(
      IO.bothOutcome(
        IO.unit.delayBy(100.milliseconds),
        IO.unit.delayBy(200.milliseconds),
      ),
      ioSucceeded(
        (Outcome.succeeded<Unit>(Unit()), Outcome.succeeded<Unit>(Unit())),
      ),
    );

    expect(
      IO.bothOutcome(
        IO.unit.delayBy(200.milliseconds),
        IO.unit.delayBy(100.milliseconds),
      ),
      ioSucceeded(
        (Outcome.succeeded<Unit>(Unit()), Outcome.succeeded<Unit>(Unit())),
      ),
    );
  });

  test('raceOutcome', () {
    expect(
      IO.raceOutcome(IO.canceled, IO.pure(42)),
      ioSucceeded(Outcome.canceled<Unit>().asLeft<Outcome<int>>()),
    );

    expect(
      IO.raceOutcome(IO.pure(42), IO.canceled),
      ioSucceeded(Outcome.succeeded(42).asLeft<Outcome<Unit>>()),
    );

    expect(
      IO.raceOutcome(
        IO.pure(0).delayBy(200.milliseconds),
        IO.pure(42).delayBy(100.milliseconds),
      ),
      ioSucceeded(Outcome.succeeded(42).asRight<Outcome<int>>()),
    );

    expect(
      IO.raceOutcome(
        IO.pure(0).delayBy(100.milliseconds),
        IO.pure(42).delayBy(200.milliseconds),
      ),
      ioSucceeded(Outcome.succeeded(0).asLeft<Outcome<int>>()),
    );
  });

  test('map pure', () {
    const n = 200;

    IO<int> build(IO<int> io, int loop) => loop <= 0 ? io : build(io.map((x) => x + 1), loop - 1);

    final io = build(IO.pure(0), n);

    expect(io, ioSucceeded(n));
  });

  test('map error', () {
    expect(
      IO.pure(42).map((a) => a ~/ 0),
      ioErrored(isA<UnsupportedError>()),
    );
  });

  test('flatMap pure', () {
    final io = IO.pure(42).flatMap((i) => IO.pure('$i / ${i * 2}'));
    expect(io, ioSucceeded('42 / 84'));
  });

  test('flatMap error', () {
    final io = IO.pure(42).flatMap((i) => IO.raiseError<String>('boom'));

    expect(io, ioErrored('boom'));
  });

  test('flatMap delay', () {
    final io = IO.delay(() => 3).flatMap((i) => IO.delay(() => '*' * i));
    expect(io, ioSucceeded('***'));
  });

  test('attempt pure', () {
    final io = IO.pure(42).attempt();
    expect(io, ioSucceeded(42.asRight<Object>()));
  });

  test('attempt error', () {
    final io = IO.raiseError<int>('boom').attempt();
    expect(io, ioSucceeded((Either<Object, int> e) => e.isLeft));
  });

  test('attempt delay success', () {
    final io = IO.delay(() => 42).attempt();
    expect(io, ioSucceeded(42.asRight<Object>()));
  });

  test('attempt delay error', () {
    final io = IO.delay(() => 42 ~/ 0).attempt();
    expect(io, ioSucceeded((Either<Object, int> e) => e.isLeft));
  });

  test('attempt and map', () {
    final io = IO
        .delay(() => throw StateError('boom'))
        .attempt()
        .map((x) => x.fold((a) => 0, (a) => 1));

    expect(io, ioSucceeded(0));
  });

  test('sleep', () {
    final io = IO.sleep(250.milliseconds);
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

    final io = IO.async<int>(
      (cb) => IO.delay(() {
        Future.delayed(2.seconds, () => 42).then((value) => cb(value.asRight()));

        return IO.exec(() => finalized = true).some;
      }),
    );

    final fiber = await io.start().unsafeRunFuture();

    fiber.cancel().unsafeRunAndForget();

    final outcome = await fiber.join().unsafeRunFuture();

    expect(outcome, Canceled<int>());
    expect(finalized, isTrue);
  });

  test('async_ simple', () {
    final io = IO.async_<int>((cb) {
      Future.delayed(100.milliseconds, () => 42).then((value) => cb(value.asRight()));
    });

    expect(io, ioSucceeded(42));
  });

  test('unsafeRunFuture success', () async {
    expect(await IO.pure(42).unsafeRunFuture(), 42);
    expect(IO.raiseError<int>('boom').unsafeRunFuture(), throwsA('boom'));
  });

  test('start simple', () async {
    final io = IO.pure(0).flatTap((_) => IO.sleep(200.milliseconds)).as(42);

    final fiber = await io.start().unsafeRunFuture();
    final outcome = await fiber.join().unsafeRunFuture();

    expect(outcome, const Succeeded(42));
  });

  test('onError success', () {
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
        .flatTap((_) => IO.sleep(1.second))
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
        .flatTap((_) => IO.sleep(1.second))
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
        .flatTap((_) => IO.sleep(1.second))
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

    final generous = appendOutput(
      'hello',
    ).guarantee(IO.cede).flatTap((a) => appendOutput('world!'));

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
      (_, _) => IO.exec(() => count += 2),
      (_) => IO.exec(() => count += 3),
    );

    await expectLater(
      IO.unit.guaranteeCase(fin),
      ioSucceeded(),
    );

    expect(count, 3);

    count = 0;

    await expectLater(
      IO.raiseError<Unit>('boom').guaranteeCase(fin),
      ioErrored(),
    );

    expect(count, 2);

    count = 0;

    await expectLater(IO.canceled.guaranteeCase(fin), ioCanceled());

    expect(count, 1);
  });

  test('timed', () async {
    final ioa = IO.pure(42).delayBy(250.milliseconds).timed();

    final (elapsed, value) = await ioa.unsafeRunFuture();

    expect(value, 42);
    expect(elapsed.inMilliseconds, closeTo(250, 75));
  });

  test('map3', () async {
    final ioa = IO.pure(1).delayBy(200.milliseconds);
    final iob = IO.pure(2).delayBy(200.milliseconds);
    final ioc = IO.pure(3).delayBy(200.milliseconds);

    final (elapsed, value) =
        await (ioa, iob, ioc).mapN((a, b, c) => a + b + c).timed().unsafeRunFuture();

    expect(value, 6);
    expect(elapsed.inMilliseconds, closeTo(600, 50));
  });

  test('asyncMapN', () async {
    final ioa = IO.pure(1).delayBy(500.milliseconds);
    final iob = IO.pure(2).delayBy(500.milliseconds);
    final ioc = IO.pure(3).delayBy(500.milliseconds);

    final (elapsed, value) =
        await (ioa, iob, ioc).parMapN((a, b, c) => a + b + c).timed().unsafeRunFuture();

    expect(value, 6);
    expect(elapsed.inMilliseconds, closeTo(500, 150));
  });

  test('bracket', () async {
    var count = 0;

    await expectLater(
      IO.pure(41).bracket((a) => IO.delay(() => a + 1), (_) => IO.exec(() => count += 1)),
      ioSucceeded(42),
    );

    expect(count, 1);

    await expectLater(
      IO
          .pure(41)
          .bracket(
            (a) => IO.delay(() => a + 1).productR(() => IO.raiseError<int>('boom')),
            (_) => IO.exec(() => count += 1),
          ),
      ioErrored(),
    );

    expect(count, 2);

    await expectLater(
      IO
          .pure(41)
          .bracket(
            (a) => IO.delay(() => a + 1).productR(() => IO.canceled),
            (_) => IO.exec(() => count += 1),
          ),
      ioCanceled(),
    );

    expect(count, 3);
  });

  test('iterateUntil', () {
    var count = 0;

    expect(
      IO.exec(() => count += 1).flatMap((a) => IO.pure(count)).iterateUntil((a) => a == 42),
      ioSucceeded(42),
    );
  });

  test('option', () {
    expect(IO.pure(42).option(), ioSucceeded(const Some(42)));
    expect(IO.raiseError<int>('boom').option(), ioSucceeded(none<int>()));
    expect(IO.canceled.option(), ioCanceled());
  });

  test('orElse', () {
    expect(IO.pure(42).orElse(() => IO.pure(0)), ioSucceeded(42));
    expect(IO.raiseError<int>('boom').orElse(() => IO.pure(0)), ioSucceeded(0));
    expect(IO.canceled.orElse(() => IO.pure(Unit())), ioCanceled());
  });

  test('raiseUnless', () {
    expect(IO.raiseUnless(false, () => 'boom'), ioErrored());
    expect(IO.raiseUnless(true, () => 'boom'), ioSucceeded());
  });

  test('raiseWhen', () {
    expect(IO.raiseWhen(true, () => 'boom'), ioErrored());
    expect(IO.raiseWhen(false, () => 'boom'), ioSucceeded());
  });

  test('redeem', () {
    expect(
      IO.pure(42).redeem((err) => 'a', (a) => a.toString()),
      ioSucceeded('42'),
    );

    expect(
      IO.raiseError<int>('boom').redeem((err) => 'a', (a) => a.toString()),
      ioSucceeded('a'),
    );
  });

  test('redeemWith', () {
    expect(
      IO.pure(42).redeemWith((err) => IO.pure('a'), (a) => IO.pure(a.toString())),
      ioSucceeded('42'),
    );

    expect(
      IO.raiseError<int>('boom').redeemWith((err) => IO.pure('a'), (a) => IO.pure(a.toString())),
      ioSucceeded('a'),
    );
  });

  test('tupleLeft', () {
    expect(IO.pure(42).tupleLeft('hi'), ioSucceeded(('hi', 42)));
  });

  test('tupleRight', () {
    expect(IO.pure(42).tupleRight('hi'), ioSucceeded((42, 'hi')));
  });

  test('unlessA', () async {
    var count = 0;

    await expectLater(IO.unlessA(true, () => IO.exec(() => count += 1)), ioSucceeded());

    expect(count, 0);

    await expectLater(IO.unlessA(false, () => IO.exec(() => count += 1)), ioSucceeded());

    expect(count, 1);
  });

  test('whenA', () async {
    var count = 0;

    await expectLater(IO.whenA(true, () => IO.exec(() => count += 1)), ioSucceeded());

    expect(count, 1);

    await expectLater(IO.whenA(false, () => IO.exec(() => count += 1)), ioSucceeded());

    expect(count, 1);
  });

  test('expect', () {
    expect(IO.stub, ioErrored());
  });

  test('andWait', () {
    expect(IO.pure(42).andWait(Duration.zero), ioSucceeded());
  });

  test('timeoutTo initial', () {
    final io = IO.pure(42).delayBy(200.milliseconds).timeoutTo(100.milliseconds, IO.pure(0));

    expect(io, ioSucceeded(0));
  });

  test('timeoutTo fallback', () {
    final io = IO.pure(42).delayBy(100.milliseconds).timeoutTo(200.milliseconds, IO.pure(0));

    expect(io, ioSucceeded(42));
  });

  test('timeout success', () {
    final io = IO.pure(42).delayBy(100.milliseconds).timeout(200.milliseconds);

    expect(io, ioSucceeded(42));
  });

  test('timeout failure', () {
    final io = IO.pure(42).delayBy(200.milliseconds).timeout(100.milliseconds);

    expect(
      io,
      ioErrored(isA<TimeoutException>()),
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

    final io = IO.uncancelable(
      (_) => appendOutput('A')
          .flatTap((_) => appendOutput('B'))
          .flatMap((a) => IO.canceled)
          .flatTap((_) => appendOutput('C')),
    );

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

    final (elapsed, _) =
        await IO
            .exec(() => count += 1)
            .delayBy(200.milliseconds)
            .parReplicate_(n)
            .timed()
            .unsafeRunFuture();

    expect(elapsed.inMilliseconds, closeTo(225, 150));
    expect(count, n);
  });

  test('racePair A wins', () async {
    final ioa = IO.pure(123).delayBy(150.milliseconds);
    final iob = IO.pure('abc').delayBy(210.milliseconds);

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunFutureOutcome();

    outcome.fold(
      () => fail('racePair A wins should not cancel'),
      (err, _) => fail('racePair A wins should not error: $err'),
      (a) => a.fold(
        (aWon) => expect(aWon.$1, const Succeeded(123)),
        (bWon) => fail('racePair A wins should not have B win: $bWon'),
      ),
    );

    // Not sure why this is necessary but previous bugs would only appear
    // when this was added
    await Future.delayed(1.second, () {});
  });

  test('racePair B wins', () async {
    final ioa = IO.pure(123).delayBy(150.milliseconds);
    final iob = IO.pure('abc').delayBy(50.milliseconds);

    final race = IO.racePair(ioa, iob);

    final outcome = await race.unsafeRunFutureOutcome();

    outcome.fold(
      () => fail('racePair B wins should not cancel'),
      (err, _) => fail('racePair B wins should not error: $err'),
      (a) => a.fold(
        (aWon) => fail('racePair B wins should not have A win: $aWon'),
        (bWon) => expect(bWon.$2, const Succeeded('abc')),
      ),
    );

    // Not sure why this is necessary but previous bugs would only appear
    // when this was added
    await Future.delayed(1.second, () {});
  });

  test('race', () async {
    bool aCanceled = false;
    bool bCanceled = false;

    final ioa = IO.pure(42).delayBy(100.milliseconds).onCancel(IO.exec(() => aCanceled = true));
    final iob = IO.pure('B').delayBy(200.milliseconds).onCancel(IO.exec(() => bCanceled = true));

    await expectLater(IO.race(ioa, iob), ioSucceeded(42.asLeft<String>()));
    expect(aCanceled, isFalse);
    expect(bCanceled, isTrue);
  });

  test('both success', () {
    final ioa = IO.pure(0).delayBy(200.milliseconds);
    final iob = IO.pure(1).delayBy(100.milliseconds);

    expect(IO.both(ioa, iob), ioSucceeded((0, 1)));
  });

  test('both error', () {
    final ioa = IO.pure(0).delayBy(200.milliseconds).productR(() => IO.raiseError<int>('boom'));
    final iob = IO.pure(1).delayBy(100.milliseconds);

    expect(IO.both(ioa, iob), ioErrored());
  });

  test('both (A canceled)', () {
    final ioa = IO.pure(0).productR(() => IO.canceled).delayBy(100.milliseconds);
    final iob = IO.pure(1).delayBy(200.milliseconds);

    expect(IO.both(ioa, iob), ioCanceled());
  });

  test('both (B canceled)', () {
    final ioa = IO.pure(0).delayBy(200.milliseconds);
    final iob = IO.pure(1).productR(() => IO.canceled).delayBy(100.milliseconds);

    expect(IO.both(ioa, iob), ioCanceled());
  });

  test('background (child finishes)', () async {
    int count = 0;
    bool canceled = false;

    final tinyTask = IO
        .exec(() => count += 1)
        .delayBy(50.milliseconds)
        .iterateWhile((_) => count < 5)
        .onCancel(IO.exec(() => canceled = true));

    final test = tinyTask.background().surround(IO.sleep(1.second));
    final ticker = test.ticked..tickAll();

    await expectLater(ticker.outcome, completion(Outcome.succeeded(Unit())));
    expect(count, 5);
    expect(canceled, isFalse);
  });

  test('background (child canceled)', () async {
    int count = 0;
    bool canceled = false;

    final foreverTask = IO
        .exec(() => count += 1)
        .delayBy(50.milliseconds)
        .foreverM()
        .onCancel(IO.exec(() => canceled = true));

    final test = foreverTask.background().use((_) => IO.sleep(1.second));
    final ticker = test.ticked..tickAll();

    await expectLater(ticker.outcome, completion(Outcome.succeeded(Unit())));
    expect(count, 19);
    expect(canceled, isTrue);
  });

  test('whileM', () {
    final start = DateTime.now();
    final cond = IO.now.map((now) => now.difference(start).inSeconds < 1);
    final test = IO.pure(1).delayBy(200.milliseconds).whilelM(cond);

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
    final syncIO = IO.pure(21).flatMap((x) => IO.pure(x * 2)).toSyncIO(100).unsafeRunSync();

    syncIO.fold(
      (io) => fail('IO -> SyncIO failed!'),
      (syncIO) => expect(syncIO, 42),
    );
  });

  test('stale Sleep timer triggers NPE during unassociated AutoCede suspension', () async {
    // This test reproduces a NullPointerException where a stale Sleep timer
    // fires while the fiber is suspended for an AutoCede (yielding control).
    //
    // 1. Fiber starts a Sleep.
    // 2. Fiber is canceled, and starts running its finalizers.
    // 3. One finalizer runs long enough to trigger an AutoCede (yielding).
    // 4. The stale Sleep timer fires, sees the fiber is suspended, and
    //    incorrectly resumes it, consuming the `_resumeIO`.
    // 5. The legitimate AutoCede resumption fires later and finds `_resumeIO`
    //    is null, causing the crash.
    final cedeN = IORuntime.defaultRuntime.autoCedeN;
    final finalizerFinished = Completer<void>();

    IO<Unit> loop(int n) {
      if (n <= 0) {
        return IO.async((cb) {
          Future.delayed(250.milliseconds, () {
            cb(Right(Unit()));
            finalizerFinished.complete();
          });

          return IO.pure(none());
        });
      } else {
        return IO.unit.flatMap((_) => loop(n - 1));
      }
    }

    final f = IO.sleep(100.milliseconds).onCancel(loop(cedeN + 10)).start();

    final io = f.flatMap((fiber) {
      return IO.sleep(10.milliseconds).productR(() => fiber.cancel()).productR(() => fiber.join());
    });

    await expectLater(io, ioSucceeded(isA<Canceled<Unit>>()));
    await expectLater(finalizerFinished.future, completes);
  });

  test('stale Sleep timer triggers continuation type miscast during Async suspension', () async {
    // This test reproduces a TypeError where a stale Sleep timer fires while
    // the fiber is suspended in an Async block.
    //
    // 1. Fiber starts a Sleep.
    // 2. Fiber is canceled.
    // 3. Finalizer starts an Async operation and suspends.
    // 4. The stale Sleep timer fires and injects a `Unit` value into the
    //    continuation stack.
    // 5. If the continuation stack was expecting a different type (e.g., String),
    //    the `Unit` injection causes a TypeError when the next continuation
    //    is invoked.
    final finalizerFinished = Completer<void>();

    final finalizer =
        IO
            .sleep(200.milliseconds)
            .flatMap(
              (_) => IO
                  .async<int>((cb) {
                    Future.delayed(350.milliseconds, () => cb(const Right(42)));
                    return IO.pure(none());
                  })
                  .map((int x) => x + 1),
            )
            .flatMap((x) {
              if (x == 43) finalizerFinished.complete();
              return IO.unit;
            })
            .voided();

    final f = IO.sleep(100.milliseconds).onCancel(finalizer).start();

    final io = f.flatMap((fiber) {
      return IO.sleep(10.milliseconds).productR(() => fiber.cancel()).productR(() => fiber.join());
    });

    await expectLater(io, ioSucceeded(isA<Canceled<Unit>>()));
    await expectLater(finalizerFinished.future, completes);
  });
}
