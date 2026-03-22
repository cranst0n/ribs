import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension ParJoinOps<O> on Rill<Rill<O>> {
  Rill<O> parJoinUnbounded() => parJoin(Integer.maxValue);

  /// Runs [maxOpen] inner streams concurrently.
  ///
  /// - Waits for all inner streams to finish.
  /// - If any stream fails, the error is propagated and all other streams are cancelled.
  /// - If the output stream is interrupted, all running streams are cancelled.
  Rill<O> parJoin(int maxOpen) {
    assert(maxOpen > 0, 'maxOpen must be greater than 0, was: $maxOpen');

    if (maxOpen == 1) {
      return flatten();
    } else {
      final rillF = SignallingRef.of(none<Object>()).flatMap((done) {
        return Semaphore.permits(maxOpen).flatMap((available) {
          return SignallingRef.of(1).flatMap((running) {
            return Channel.unbounded<Unit>().flatMap((outcomes) {
              return Channel.unbounded<Chunk<O>>().map((output) {
                IO<Unit> stop(Option<Object> rslt) {
                  return done.update((current) {
                    return current.fold(
                      () => rslt,
                      (prev) => rslt.fold(
                        () => current, // If we're trying to set None, keep existing result (if any)
                        (err) => Some(
                          current.fold(
                            () => Some(err),
                            (prevErr) => Some('CompositeFailure($prevErr, $err)'),
                          ),
                        ),
                      ),
                    );
                  });
                }

                final incrementRunning = running.update((n) => n + 1);
                final decrementRunning = running
                    .updateAndGet((n) => n - 1)
                    .flatMap((now) => now == 0 ? outcomes.close().voided() : IO.unit);

                IO<Unit> onOutcome(
                  Outcome<Unit> oc,
                  Either<Object, Unit> cancelResult,
                ) {
                  return oc.fold(
                    () => cancelResult.fold((err) => stop(Some(err)), (_) => IO.unit),
                    (err, st) => stop(Some(err)), // TODO: composite failure
                    (fu) => cancelResult.fold(
                      (err) => stop(Some(err)),
                      (_) => outcomes.send(fu).voided(),
                    ),
                  );
                }

                IO<Unit> runInner(Rill<O> inner, Scope outerScope) {
                  return IO.uncancelable((_) {
                    return outerScope.lease().flatMap((lease) {
                      return available.acquire().productR(() => incrementRunning).flatMap((_) {
                        return inner
                            .chunks()
                            .evalMap((chunk) => output.send(chunk).voided())
                            .interruptWhenSignaled(done.map((x) => x.nonEmpty))
                            .compile
                            .drain
                            .guaranteeCase((oc) {
                              return lease.cancel
                                  .flatMap((cancelResult) => onOutcome(oc, cancelResult))
                                  .guarantee(
                                    available.release().productR(() => decrementRunning),
                                  );
                            })
                            .voidError()
                            .start()
                            .voided();
                      });
                    });
                  });
                }

                IO<Unit> runOuter() {
                  return IO.uncancelable((_) {
                    return flatMap(
                          (inner) =>
                              Pull.getScope
                                  .flatMap((outerScope) => Pull.eval(runInner(inner, outerScope)))
                                  .rillNoScope,
                        )
                        .drain()
                        .interruptWhenSignaled(done.map((x) => x.nonEmpty))
                        .compile
                        .drain
                        .guaranteeCase(
                          (oc) => onOutcome(oc, Right(Unit())).productR(() => decrementRunning),
                        )
                        .voidError();
                  });
                }

                IO<Unit> outcomeJoiner() {
                  return outcomes.rill.compile.drain.guaranteeCase((oc) {
                    return oc.fold(
                      () => stop(none()).productR(() => output.close().voided()),
                      (err, st) => stop(Some(err)).productR(() => output.close().voided()),
                      (fu) => stop(none()).productR(() => output.close().voided()),
                    );
                  }).voidError();
                }

                IO<Unit> signalResult(IOFiber<Unit> fiber) {
                  return done.value().flatMap((opt) {
                    return opt.fold(
                      () => fiber.join().voided(),
                      (err) => IO.raiseError(err),
                    );
                  });
                }

                return Rill.bracket(
                  runOuter().start().productR(() => outcomeJoiner().start()),
                  (fiber) {
                    return stop(none()).productR(
                      () =>
                      // in case of short-circuiting, the `fiberJoiner` would not have had a chance
                      // to wait until all fibers have been joined, so we need to do it manually
                      // by waiting on the counter
                      running.waitUntil((n) => n == 0).productR(() => signalResult(fiber)),
                    );
                  },
                ).flatMap((_) => output.rill.flatMap((o) => Rill.chunk(o)));
              });
            });
          });
        });
      });

      return Rill.eval(rillF).flatten();
    }
  }
}
