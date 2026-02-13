import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('stack-safety', () {
    test('use', () {
      final r =
          IList.range(1, 50000)
              .foldLeft(Resource.eval(IO.unit), (r, _) => r.flatMap((_) => Resource.eval(IO.unit)))
              .use_();

      expect(r, ioSucceeded(Unit()));
    });

    test('use (2)', () {
      const n = 50000;

      Resource<int> p([int i = 0, int n = n]) {
        return Resource.pure(i < n ? Left<int, int>(i + 1) : Right<int, int>(i)).flatMap((e) {
          return e.fold(
            (a) => p(a),
            (b) => Resource.pure(b),
          );
        });
      }

      expect(p(n).use(IO.pure), ioSucceeded(n));
    });

    test('attempt', () {
      final r =
          IList.range(1, 10000)
              .foldLeft(Resource.eval(IO.unit), (r, _) => r.flatMap((_) => Resource.eval(IO.unit)))
              .attempt();

      expect(r.use_(), ioSucceeded(Unit()));
    });

    test('allocatedCase', () {
      final res = Resource.make(IO.unit, (_) => IO.unit);
      final r = IList.range(
        1,
        50000,
      ).foldLeft(res, (r, _) => r.flatMap((_) => res)).allocatedCase().map((t) => t.$1);

      expect(r, ioSucceeded(Unit()));
    });
  });

  test('makes acquires non interruptible', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.sleep(5.seconds).onCancel(interrupted.setValue(true));

      return Resource.make(
        fa,
        (_) => IO.unit,
      ).use_().timeout(1.second).attempt().productR(() => interrupted.value());
    });

    final ticker = test.ticked;
    ticker.tickAll();

    expect(
      ticker.outcome,
      completion((Outcome<bool> oc) => oc == Outcome.succeeded(false)),
    );
  });

  test('makes acquires non interruptible, overriding uncancelable', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.uncancelable(
        (poll) => poll(IO.sleep(5.seconds)).onCancel(interrupted.setValue(true)),
      );

      return Resource.make(
        fa,
        (_) => IO.unit,
      ).use_().timeout(1.second).attempt().productR(() => interrupted.value());
    });

    final ticker = test.ticked..tickAll();

    expect(
      ticker.outcome,
      completion((Outcome<bool> oc) => oc == Outcome.succeeded(false)),
    );
  });

  test('releases resource if interruption happens during use', () {
    final flag = IO.ref(false);

    final test = (flag, flag).tupled.flatMapN((acquireFin, resourceFin) {
      final action = IO.sleep(1.second).onCancel(acquireFin.setValue(true));

      final fin = resourceFin.setValue(true);

      final res = Resource.makeFull((poll) => poll(action), (_) => fin);

      return res
          .surround(IO.sleep(4.seconds))
          .timeout(2.seconds)
          .attempt()
          .productR(() => (acquireFin.value(), resourceFin.value()).tupled);
    });

    final ticker = test.ticked..tickAll();

    expect(
      ticker.outcome,
      completion((Outcome<(bool, bool)> oc) => oc == Outcome.succeeded((false, true))),
    );
  });

  test('supports interruptible acquires', () {
    final flag = IO.ref(false);

    final test = (flag, flag).tupled.flatMapN((acquireFin, resourceFin) {
      final action = IO.sleep(5.seconds).onCancel(acquireFin.setValue(true));

      final fin = resourceFin.setValue(true);

      final res = Resource.makeFull((poll) => poll(action), (_) => fin);

      return res
          .use_()
          .timeout(1.second)
          .attempt()
          .productR(() => (acquireFin.value(), resourceFin.value()).tupled);
    });

    final ticker = test.ticked..tickAll();

    expect(
      ticker.outcome,
      completion((Outcome<(bool, bool)> oc) => oc == Outcome.succeeded((true, false))),
    );
  });

  test('supports interruptible acquires, respecting uncancelable', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(1.second);
    const timeout = Duration(milliseconds: 500);

    final test = (flag, flag, flag, flag).tupled.flatMap((ft) {
      final (acquireFin, resourceFin, a, b) = ft;

      final io = IO.uncancelable(
        (poll) =>
            sleep.onCancel(a.setValue(true)).productR(() => poll(sleep).onCancel(b.setValue(true))),
      );

      final resource = Resource.makeFull(
        (poll) => poll(io).onCancel(acquireFin.setValue(true)),
        (_) => resourceFin.setValue(true),
      );

      return resource
          .use_()
          .timeout(timeout)
          .attempt()
          .productR(() => (a.value(), b.value(), acquireFin.value(), resourceFin.value()).tupled);
    });

    final ticker = test.ticked..tickAll();

    expect(
      ticker.outcome,
      completion(
        (Outcome<(bool, bool, bool, bool)> oc) =>
            oc == Outcome.succeeded((false, true, true, false)),
      ),
    );
  });

  test('release is always uninterruptible', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(1.second);

    final test = flag.flatMap((releaseComplete) {
      final release = sleep.productR(() => releaseComplete.setValue(true));
      final resource = Resource.applyFull((poll) => IO.delay(() => (Unit(), (_) => poll(release))));

      return resource
          .use_()
          .timeout(500.milliseconds)
          .attempt()
          .productR(() => releaseComplete.value());
    });

    final ticker = test.ticked..tickAll();

    expect(
      ticker.outcome,
      completion((Outcome<bool> oc) => oc == Outcome.succeeded(true)),
    );
  });

  test('pure', () {
    final res = Resource.pure(42).map((a) => a * 2).flatMap((a) => Resource.pure('abc'));

    final test = res.use((a) => IO.pure('${a}123'));

    expect(test, ioSucceeded('abc123'));
  });

  test('eval - interruption', () {
    Resource<Unit> resource(Deferred<int> d) {
      return Resource.make(IO.unit, (_) => d.complete(1).voided()).flatMap((_) {
        return Resource.eval(IO.never());
      });
    }

    final p = Deferred.of<int>().flatMap((d) {
      final r = resource(d).use_();
      return r.start().flatMap((fiber) {
        return IO.sleep(200.milliseconds).flatMap((_) {
          return fiber.cancel().flatMap((_) {
            return d.value();
          });
        });
      });
    });

    expect(p, ioSucceeded(1));
  });

  test('evalTap with error fails during use', () {
    const error = 'BOOM';

    expect(
      Resource.eval(IO.pure(0)).evalTap((_) => IO.raiseError<Unit>(error)).voided().use(IO.pure),
      ioErrored(error),
    );
  });

  test('allocated releases two resources', () async {
    var a = false;
    var b = false;

    final test = Resource.make(
          IO.unit,
          (_) => IO.exec(() => a = true),
        )
        .flatMap((_) => Resource.make(IO.unit, (_) => IO.exec(() => b = true)))
        .allocated()
        .flatMap((tuple) => tuple.$2);

    await expectLater(test, ioSucceeded(Unit()));
    expect(a, isTrue);
    expect(b, isTrue);
  });

  forAll(
    'allocated releases resources in reverse order of acquisition',
    Gen.ilistOf(
      Gen.chooseInt(0, 20),
      (Gen.integer, Gen.either(Gen.constant('boom'), Gen.unit)).tupled,
    ),
    (as) {
      var released = nil<int>();

      final r = as.traverseResource((tuple) {
        final (a, e) = tuple;

        return Resource.make(
          IO.pure(a),
          (a) => IO.delay(() => released = released.prepended(a)).productR(() => IO.fromEither(e)),
        );
      });

      final test = r.use_().attempt().voided();

      final ticker = test.ticked..tickAll();

      expect(ticker.outcome, completion(Outcome.succeeded(Unit())));
      expect(released, as.map((t) => t.$1));
    },
  );

  test('allocated does not release until close is invoked', () {
    var released = false;
    final release = Resource.make(IO.unit, (_) => IO.exec(() => released = true));
    final resource = Resource.eval(IO.unit);

    final ioa = release.flatMap((_) => resource).allocated();

    final test =
        ioa.flatMap((res) {
          final (_, close) = res;

          return IO.raiseWhen(released, () => 'Should not be released yet').flatMap((_) {
            return close.flatMap((_) {
              return IO.raiseWhen(!released, () => 'Should have been released');
            });
          });
        }).voided();

    expect(test, ioSucceeded(Unit()));
  });

  test('safe attempt suspended resource', () {
    const err = 'BOOM';
    final suspend = Resource.suspend(IO.raiseError(err));
    expect(suspend.use_(), ioErrored(err));
  });

  group('both', () {
    test('successful acquire / release', () async {
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

    forAll2(
      'releases resources in rever order of acquisition',
      Gen.ilistOf(
        Gen.chooseInt(0, 20),
        (Gen.integer, Gen.either(Gen.constant('boom'), Gen.unit)).tupled,
      ),
      Gen.boolean,
      (as, rhs) {
        var released = nil<int>();

        final r = as.traverseResource((tuple) {
          final (a, e) = tuple;

          return Resource.make(
            IO.pure(a),
            (a) =>
                IO.delay(() => released = released.prepended(a)).productR(() => IO.fromEither(e)),
          );
        });

        final p = rhs ? Resource.both(r, Resource.unit) : Resource.both(Resource.unit, r);
        final test = p.use_().attempt().voided();

        final ticker = test.ticked..tickAll();

        expect(ticker.outcome, completion(Outcome.succeeded(Unit())));
        expect(released, as.map((t) => t.$1));
      },
    );

    test('parallel acquisition and release', () {
      var leftAllocated = false;
      var rightAllocated = false;
      var leftReleasing = false;
      var rightReleasing = false;
      var leftReleased = false;
      var rightReleased = false;

      final wait = IO.sleep(1.second);

      final lhs = Resource.make(
        wait.productR(() => IO.exec(() => leftAllocated = true)),
        (_) => IO
            .exec(() => leftReleasing = true)
            .productR(() => wait)
            .productR(() => IO.exec(() => leftReleased = true)),
      );

      final rhs = Resource.make(
        wait.productR(() => IO.exec(() => rightAllocated = true)),
        (_) => IO
            .exec(() => rightReleasing = true)
            .productR(() => wait)
            .productR(() => IO.exec(() => rightReleased = true)),
      );

      final ticker = Resource.both(lhs, rhs).use((_) => wait).ticked;

      ticker.tick();
      ticker.advanceAndTick(1.second);

      // after one second, allocation should have happened, use (for 1 second is next)
      expect(leftAllocated, isTrue);
      expect(rightAllocated, isTrue);
      expect(leftReleasing, isFalse);
      expect(rightReleasing, isFalse);

      // use has finished after another second, releasing should have started
      ticker.advanceAndTick(1.second);
      expect(leftReleasing, isTrue);
      expect(rightReleasing, isTrue);
      expect(leftReleased, isFalse);
      expect(rightReleased, isFalse);

      // sleep in each release should have finished and release completed
      ticker.advanceAndTick(1.second);
      expect(leftReleased, isTrue);
      expect(rightReleased, isTrue);
    });

    test('safety: lhs error during rhs interruptible region', () {
      var leftAllocated = false;
      var rightAllocated = false;
      var leftReleasing = false;
      var rightReleasing = false;
      var leftReleased = false;
      var rightReleased = false;

      IO<Unit> wait(int secs) => IO.sleep(secs.second);

      final lhs = Resource.make(
        wait(1).productR(() => IO.exec(() => leftAllocated = true)),
        (_) => IO
            .exec(() => leftReleasing = true)
            .productR(() => wait(1))
            .productR(() => IO.exec(() => leftReleased = true)),
      ).flatMap((_) => Resource.eval(wait(1).productR(() => IO.raiseError<Unit>('BOOM'))));

      final rhs = Resource.make(
        wait(1).productR(() => IO.exec(() => rightAllocated = true)),
        (_) => IO
            .exec(() => rightReleasing = true)
            .productR(() => wait(1))
            .productR(() => IO.exec(() => rightReleased = true)),
      ).flatMap((_) => Resource.eval(wait(2)));

      final ticker = Resource.both(lhs, rhs).use_().handleError((_) => Unit()).ticked;

      ticker.tick();
      ticker.advanceAndTick(1.second);

      // after one second, allocation should have happened, use (for 1 second is next)
      expect(leftAllocated, isTrue);
      expect(rightAllocated, isTrue);
      expect(leftReleasing, isFalse);
      expect(rightReleasing, isFalse);

      // use has finished after another second, releasing should have started
      ticker.advanceAndTick(1.second);
      expect(leftReleasing, isTrue);
      expect(rightReleasing, isTrue);
      expect(leftReleased, isFalse);
      expect(rightReleased, isFalse);

      // sleep (error in rhs) in each release should have finished and release completed
      ticker.advanceAndTick(1.second);
      expect(leftReleased, isTrue);
      expect(rightReleased, isTrue);
    });

    group('propogate the exit case', () {
      test('use successfully, test left', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(r, Resource.unit).use_(), ioSucceeded(Unit()));
        expect(got, ExitCase.succeeded());
      });

      test('use successfully, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(Resource.unit, r).use_(), ioSucceeded(Unit()));
        expect(got, ExitCase.succeeded());
      });

      test('use errored, test left', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(Resource.unit, r).use((_) => IO.raiseError<Unit>(error)),
          ioErrored(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('use errored, test right', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(r, Resource.unit).use((_) => IO.raiseError<Unit>(error)),
          ioErrored(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('right errored, test left', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            r,
            Resource.eval(IO.sleep(1.second).productR(() => IO.raiseError<Unit>(error))),
          ).use_(),
          ioErrored(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('left errored, test right', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            Resource.eval(IO.sleep(1.second).productR(() => IO.raiseError<Unit>(error))),
            r,
          ).use_(),
          ioErrored(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('use canceled, test left', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(r, Resource.unit).use((_) => IO.canceled), ioCanceled());
        expect(got, ExitCase.canceled());
      });

      test('use canceled, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(Resource.unit, r).use((_) => IO.canceled), ioCanceled());
        expect(got, ExitCase.canceled());
      });

      test('right canceled, test left', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            Resource.eval(IO.sleep(1.second).productR(() => IO.canceled)),
            r,
          ).use((_) => IO.canceled),
          ioCanceled(),
        );
        expect(got, ExitCase.canceled());
      });

      test('left canceled, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            r,
            Resource.eval(IO.sleep(1.second).productR(() => IO.canceled)),
          ).use((_) => IO.canceled),
          ioCanceled(),
        );
        expect(got, ExitCase.canceled());
      });
    });
  });

  group('surround', () {
    test('wrap an effect in a usage and ignore the value produced by resource', () async {
      final r = Resource.eval(IO.pure(0));
      final surroundee = IO.pure('hello');
      final surrounded = r.surround(surroundee);

      final surroundedOutcome = await surrounded.unsafeRunFutureOutcome();
      final surroundeeOutcome = await surroundee.unsafeRunFutureOutcome();

      expect(surroundedOutcome, surroundeeOutcome);
    });
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
      IO.raiseError<int>('boom'),
      (_) => IO.exec(() => released = true),
    );

    final test = res.attempt().use_();

    await expectLater(test, ioSucceeded(Unit()));
    expect(released, isFalse);
  });
}

extension<A> on IList<A> {
  Resource<IList<B>> traverseResource<B>(Function1<A, Resource<B>> f) {
    Resource<IList<B>> result = Resource.pure(nil());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }
}
