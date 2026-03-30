import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:test/test.dart';

void main() {
  group('stack-safety', () {
    test('use', () {
      final r =
          IList.range(1, 50000)
              .foldLeft(Resource.eval(IO.unit), (r, _) => r.flatMap((_) => Resource.eval(IO.unit)))
              .use_();

      expect(r, succeeds(Unit()));
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

      expect(p(n).use(IO.pure), succeeds(n));
    });

    test('attempt', () {
      final r =
          IList.range(1, 10000)
              .foldLeft(Resource.eval(IO.unit), (r, _) => r.flatMap((_) => Resource.eval(IO.unit)))
              .attempt();

      expect(r.use_(), succeeds(Unit()));
    });

    test('allocatedCase', () {
      final res = Resource.make(IO.unit, (_) => IO.unit);
      final r = IList.range(
        1,
        50000,
      ).foldLeft(res, (r, _) => r.flatMap((_) => res)).allocatedCase().mapN((a, _) => a);

      expect(r, succeeds(Unit()));
    });
  });

  test('makes acquires non interruptible', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.sleep(5.seconds).onCancel(interrupted.setValue(true));

      return Resource.make(
        fa,
        (_) => IO.unit,
      ).use_().timeout(1.second).attempt().productR(interrupted.value());
    });

    expect(test.ticked, succeeds(false));
  });

  test('makes acquires non interruptible, overriding uncancelable', () {
    final test = IO.ref(false).flatMap((interrupted) {
      final fa = IO.uncancelable(
        (poll) => poll(IO.sleep(5.seconds)).onCancel(interrupted.setValue(true)),
      );

      return Resource.make(
        fa,
        (_) => IO.unit,
      ).use_().timeout(1.second).attempt().productR(interrupted.value());
    });

    expect(test.ticked, succeeds(false));
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
          .productR((acquireFin.value(), resourceFin.value()).tupled);
    });

    expect(test.ticked, succeeds((false, true)));
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
          .productR((acquireFin.value(), resourceFin.value()).tupled);
    });

    expect(test.ticked, succeeds((true, false)));
  });

  test('supports interruptible acquires, respecting uncancelable', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(1.second);
    const timeout = Duration(milliseconds: 500);

    final test = (flag, flag, flag, flag).tupled.flatMap((ft) {
      final (acquireFin, resourceFin, a, b) = ft;

      final io = IO.uncancelable(
        (poll) => sleep.onCancel(a.setValue(true)).productR(poll(sleep).onCancel(b.setValue(true))),
      );

      final resource = Resource.makeFull(
        (poll) => poll(io).onCancel(acquireFin.setValue(true)),
        (_) => resourceFin.setValue(true),
      );

      return resource
          .use_()
          .timeout(timeout)
          .attempt()
          .productR((a.value(), b.value(), acquireFin.value(), resourceFin.value()).tupled);
    });

    expect(test.ticked, succeeds((false, true, true, false)));
  });

  test('release is always uninterruptible', () {
    final flag = IO.ref(false);
    final sleep = IO.sleep(1.second);

    final test = flag.flatMap((releaseComplete) {
      final release = sleep.productR(releaseComplete.setValue(true));
      final resource = Resource.applyFull((poll) => IO.delay(() => (Unit(), (_) => poll(release))));

      return resource.use_().timeout(500.milliseconds).attempt().productR(releaseComplete.value());
    });

    expect(test.ticked, succeeds(true));
  });

  test('pure', () {
    final res = Resource.pure(42).map((a) => a * 2).flatMap((a) => Resource.pure('abc'));

    final test = res.use((a) => IO.pure('${a}123'));

    expect(test, succeeds('abc123'));
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

    expect(p, succeeds(1));
  });

  test('evalTap with error fails during use', () {
    const error = 'BOOM';

    expect(
      Resource.eval(IO.pure(0)).evalTap((_) => IO.raiseError<Unit>(error)).voided().use(IO.pure),
      errors(error),
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

    await expectLater(test, succeeds(Unit()));
    expect(a, isTrue);
    expect(b, isTrue);
  });

  Gen.ilistOf(
    Gen.chooseInt(0, 20),
    (Gen.integer, Gen.either<Object, Unit>(Gen.constant('boom'), Gen.constant(Unit()))).tupled,
  ).forAll(
    'allocated releases resources in reverse order of acquisition',
    (as) {
      var released = nil<int>();

      final r = as.traverseResource((tuple) {
        final (a, e) = tuple;

        return Resource.make(
          IO.pure(a),
          (a) => IO.delay(() => released = released.prepended(a)).productR(IO.fromEither(e)),
        );
      });

      final test = r.use_().attempt().voided();

      expect(test.ticked, succeeds(Unit()));
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

    expect(test, succeeds(Unit()));
  });

  test('safe attempt suspended resource', () {
    const err = 'BOOM';
    final suspend = Resource.suspend(IO.raiseError(err));
    expect(suspend.use_(), errors(err));
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

      await expectLater(test, succeeds(85));
      expect(aReleased, isTrue);
      expect(bReleased, isTrue);
    });

    (
      Gen.ilistOf(
        Gen.chooseInt(0, 20),
        (Gen.integer, Gen.either<Object, Unit>(Gen.constant('boom'), Gen.constant(Unit()))).tupled,
      ),
      Gen.boolean,
    ).forAll(
      'releases resources in rever order of acquisition',
      (as, rhs) {
        var released = nil<int>();

        final r = as.traverseResource((tuple) {
          final (a, e) = tuple;

          return Resource.make(
            IO.pure(a),
            (a) => IO.delay(() => released = released.prepended(a)).productR(IO.fromEither(e)),
          );
        });

        final p = rhs ? Resource.both(r, Resource.unit) : Resource.both(Resource.unit, r);
        final test = p.use_().attempt().voided();

        expect(test.ticked, succeeds(Unit()));
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
        wait.productR(IO.exec(() => leftAllocated = true)),
        (_) => IO
            .exec(() => leftReleasing = true)
            .productR(wait)
            .productR(IO.exec(() => leftReleased = true)),
      );

      final rhs = Resource.make(
        wait.productR(IO.exec(() => rightAllocated = true)),
        (_) => IO
            .exec(() => rightReleasing = true)
            .productR(wait)
            .productR(IO.exec(() => rightReleased = true)),
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
        wait(1).productR(IO.exec(() => leftAllocated = true)),
        (_) => IO
            .exec(() => leftReleasing = true)
            .productR(wait(1))
            .productR(IO.exec(() => leftReleased = true)),
      ).flatMap((_) => Resource.eval(wait(1).productR(IO.raiseError<Unit>('BOOM'))));

      final rhs = Resource.make(
        wait(1).productR(IO.exec(() => rightAllocated = true)),
        (_) => IO
            .exec(() => rightReleasing = true)
            .productR(wait(1))
            .productR(IO.exec(() => rightReleased = true)),
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

        await expectLater(Resource.both(r, Resource.unit).use_(), succeeds(Unit()));
        expect(got, ExitCase.succeeded());
      });

      test('use successfully, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(Resource.unit, r).use_(), succeeds(Unit()));
        expect(got, ExitCase.succeeded());
      });

      test('use errored, test left', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(Resource.unit, r).use((_) => IO.raiseError<Unit>(error)),
          errors(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('use errored, test right', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(r, Resource.unit).use((_) => IO.raiseError<Unit>(error)),
          errors(error),
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
            Resource.eval(IO.sleep(1.second).productR(IO.raiseError<Unit>(error))),
          ).use_(),
          errors(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('left errored, test right', () async {
        ExitCase? got;
        const error = 'BOOM';

        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            Resource.eval(IO.sleep(1.second).productR(IO.raiseError<Unit>(error))),
            r,
          ).use_(),
          errors(error),
        );

        expect(got, ExitCase.errored(error));
      });

      test('use canceled, test left', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(r, Resource.unit).use((_) => IO.canceled), cancels);
        expect(got, ExitCase.canceled());
      });

      test('use canceled, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(Resource.both(Resource.unit, r).use((_) => IO.canceled), cancels);
        expect(got, ExitCase.canceled());
      });

      test('right canceled, test left', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            Resource.eval(IO.sleep(1.second).productR(IO.canceled)),
            r,
          ).use((_) => IO.canceled),
          cancels,
        );
        expect(got, ExitCase.canceled());
      });

      test('left canceled, test right', () async {
        ExitCase? got;
        final r = Resource.unit.onFinalizeCase((ec) => IO.exec(() => got = ec));

        await expectLater(
          Resource.both(
            r,
            Resource.eval(IO.sleep(1.second).productR(IO.canceled)),
          ).use((_) => IO.canceled),
          cancels,
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

    await expectLater(test, succeeds(Unit()));
    expect(released, isTrue);
  });

  test('attempt failure', () async {
    bool released = false;

    final res = Resource.make(
      IO.raiseError<int>('boom'),
      (_) => IO.exec(() => released = true),
    );

    final test = res.attempt().use_();

    await expectLater(test, succeeds(Unit()));
    expect(released, isFalse);
  });

  group('as', () {
    test('replaces the resource value', () {
      expect(Resource.pure(42).as('hello').use(IO.pure), succeeds('hello'));
    });

    test('finalizer still runs after as', () async {
      var released = false;
      final res = Resource.make(IO.pure(42), (_) => IO.exec(() => released = true)).as('hello');
      await expectLater(res.use(IO.pure), succeeds('hello'));
      expect(released, isTrue);
    });
  });

  group('voided', () {
    test('discards resource value', () {
      expect(Resource.pure(42).voided().use(IO.pure), succeeds(Unit()));
    });

    test('finalizer still runs after voided', () async {
      var released = false;
      final res = Resource.make(IO.pure(42), (_) => IO.exec(() => released = true)).voided();
      await expectLater(res.use(IO.pure), succeeds(Unit()));
      expect(released, isTrue);
    });
  });

  group('flatTap', () {
    test('executes side-effecting resource and returns original value', () async {
      var tapped = 0;
      final res = Resource.pure(42).flatTap(
        (a) => Resource.eval(IO.exec(() => tapped = a)),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(tapped, 42);
    });

    test('releases both resources', () async {
      var aReleased = false;
      var bReleased = false;
      final res = Resource.make(IO.pure(1), (_) => IO.exec(() => aReleased = true)).flatTap(
        (_) => Resource.make(IO.pure(2), (_) => IO.exec(() => bReleased = true)),
      );
      await expectLater(res.use(IO.pure), succeeds(1));
      expect(aReleased, isTrue);
      expect(bReleased, isTrue);
    });
  });

  group('evalMap', () {
    test('applies IO function to resource value', () {
      expect(Resource.pure(21).evalMap((a) => IO.pure(a * 2)).use(IO.pure), succeeds(42));
    });

    test('propagates IO error', () {
      expect(
        Resource.pure(0).evalMap((_) => IO.raiseError<int>('oops')).use(IO.pure),
        errors('oops'),
      );
    });
  });

  group('handleErrorWith', () {
    test('recovers from acquire error', () {
      final res = Resource.raiseError<int>('boom').handleErrorWith((_) => Resource.pure(42));
      expect(res.use(IO.pure), succeeds(42));
    });

    test('does not invoke handler on success', () async {
      var handlerCalled = false;
      final res = Resource.pure(42).handleErrorWith((_) {
        handlerCalled = true;
        return Resource.pure(0);
      });
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(handlerCalled, isFalse);
    });

    test('releases recovered resource', () async {
      var released = false;
      final res = Resource.raiseError<int>('boom').handleErrorWith(
        (_) => Resource.make(IO.pure(42), (_) => IO.exec(() => released = true)),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(released, isTrue);
    });
  });

  group('onFinalize', () {
    test('runs finalizer on success', () async {
      var finalized = false;
      final res = Resource.pure(42).onFinalize(IO.exec(() => finalized = true));
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(finalized, isTrue);
    });

    test('runs finalizer on error', () async {
      var finalized = false;
      final res = Resource.pure(
        42,
      ).onFinalize(IO.exec(() => finalized = true)).evalMap((_) => IO.raiseError<int>('boom'));
      await expectLater(res.use(IO.pure), errors('boom'));
      expect(finalized, isTrue);
    });
  });

  group('onCancel', () {
    test('runs cancellation hook when use is canceled', () {
      final test = IO.ref(false).flatMap((canceled) {
        final res = Resource.eval(IO.sleep(5.seconds)).onCancel(
          Resource.eval(IO.exec(() {})).flatTap(
            (_) => Resource.eval(canceled.setValue(true)),
          ),
        );
        return res.use_().timeout(1.second).attempt().productR(canceled.value());
      });

      expect(test.ticked, succeeds(true));
    });
  });

  group('preAllocate', () {
    test('runs IO before resource acquisition', () async {
      final order = <String>[];

      final res = Resource.make(
        IO.exec(() => order.add('acquire')),
        (_) => IO.exec(() => order.add('release')),
      ).preAllocate(IO.exec(() => order.add('pre')));

      await expectLater(res.use_(), succeeds(Unit()));
      expect(order, ['pre', 'acquire', 'release']);
    });

    test('propagates preAllocate error', () {
      final res = Resource.pure(42).preAllocate(IO.raiseError<Unit>('pre-error'));
      expect(res.use(IO.pure), errors('pre-error'));
    });
  });

  group('guaranteeCase', () {
    test('runs finalizer on success', () async {
      Outcome<int>? got;
      final res = Resource.pure(42).guaranteeCase(
        (oc) => Resource.eval(IO.exec(() => got = oc)),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(got, Outcome.succeeded(42));
    });

    test('runs finalizer on error', () async {
      Outcome<int>? got;
      const err = 'boom';
      final res = Resource.raiseError<int>(err).guaranteeCase(
        (oc) => Resource.eval(IO.exec(() => got = oc)),
      );
      await expectLater(res.use(IO.pure), errors(err));
      expect(got, Outcome.errored<int>(err));
    });

    test('runs finalizer on cancellation', () async {
      Outcome<int>? got;
      final res = Resource.canceled
          .as(42)
          .guaranteeCase(
            (oc) => Resource.eval(IO.exec(() => got = oc)),
          );
      await expectLater(res.use(IO.pure), cancels);
      expect(got, Outcome.canceled<int>());
    });
  });

  group('ref', () {
    test('creates a Ref with initial value', () {
      final test = Resource.ref(42).use((ref) => ref.value());
      expect(test, succeeds(42));
    });

    test('Ref can be updated within use', () {
      final test = Resource.ref(0).use((ref) => ref.setValue(99).flatMap((_) => ref.value()));
      expect(test, succeeds(99));
    });
  });

  group('raiseError', () {
    test('injects error into resource evaluation', () {
      expect(Resource.raiseError<int>('oops').use(IO.pure), errors('oops'));
    });

    test('is recoverable via handleErrorWith', () {
      expect(
        Resource.raiseError<int>('oops').handleErrorWith((_) => Resource.pure(0)).use(IO.pure),
        succeeds(0),
      );
    });
  });

  group('never', () {
    test('non-terminating resource is cancelable', () {
      final test = Resource.never<int>().use(IO.pure).timeout(1.second).attempt();
      expect(test.ticked, succeeds(isLeft()));
    });
  });

  group('canceled', () {
    test('immediately canceled resource cancels use', () {
      expect(Resource.canceled.use_(), cancels);
    });
  });

  group('cede', () {
    test('introduces async boundary without error', () {
      expect(Resource.cede.use_(), succeeds(Unit()));
    });
  });

  group('apply', () {
    test('creates resource from IO of (value, finalizer) pair', () async {
      var released = false;
      final res = Resource.apply(
        IO.pure((42, IO.exec(() => released = true))),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(released, isTrue);
    });
  });

  group('applyCase', () {
    test('finalizer receives exit case on success', () async {
      ExitCase? got;
      final res = Resource.applyCase(
        IO.pure((42, (ExitCase ec) => IO.exec(() => got = ec))),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(got, ExitCase.succeeded());
    });

    test('finalizer receives exit case on error', () async {
      ExitCase? got;
      const err = 'boom';
      final res = Resource.applyCase(
        IO.pure((42, (ExitCase ec) => IO.exec(() => got = ec))),
      );
      await expectLater(
        res.use((_) => IO.raiseError<int>(err)),
        errors(err),
      );
      expect(got, ExitCase.errored(err));
    });
  });

  group('makeCaseFull', () {
    test('acquire uses poll, finalizer receives exit case', () async {
      ExitCase? got;
      final res = Resource.makeCaseFull<int>(
        (poll) => poll(IO.pure(42)),
        (a, ec) => IO.exec(() => got = ec),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(got, ExitCase.succeeded());
    });
  });

  group('makeFull', () {
    test('acquire uses poll, finalizer is called', () async {
      var released = false;
      final res = Resource.makeFull<int>(
        (poll) => poll(IO.pure(42)),
        (_) => IO.exec(() => released = true),
      );
      await expectLater(res.use(IO.pure), succeeds(42));
      expect(released, isTrue);
    });
  });

  group('useForever', () {
    test('never completes and resource finalizer is not invoked until canceled', () {
      final test = IO.ref(false).flatMap((released) {
        final res = Resource.make(IO.unit, (_) => released.setValue(true));
        return res.useForever().start().flatMap(
          (fiber) => IO.sleep(1.second).flatMap((_) => fiber.cancel()).productR(released.value()),
        );
      });

      expect(test.ticked, succeeds(true));
    });
  });

  group('useEval', () {
    test('evaluates the inner IO', () {
      expect(Resource.eval(IO.pure(IO.pure(42))).useEval(), succeeds(42));
    });
  });

  group('attempt with Allocate leaf in bind chain', () {
    test('captures acquire error', () {
      const err = 'BOOM';
      final res = Resource.make(
        IO.raiseError<int>(err),
        (_) => IO.unit,
      ).flatMap((_) => Resource.pure(0));
      // Use isLeft to avoid dynamic type parameter mismatch in equality check
      expect(res.attempt().use((e) => IO.pure(e.isLeft)), succeeds(true));
    });

    test('succeeds when acquire succeeds', () {
      final res = Resource.make(IO.pure(42), (_) => IO.unit).flatMap((a) => Resource.pure(a * 2));
      expect(res.attempt().use((e) => IO.pure(e.getOrElse(() => -1))), succeeds(84));
    });
  });

  group('guaranteeCase', () {
    test('re-raises and cleans up when success finalizer errors', () async {
      const finErr = 'fin-err';
      bool cleanedUp = false;
      final res = Resource.make(
        IO.pure(42),
        (_) => IO.exec(() => cleanedUp = true),
      ).guaranteeCase((_) => Resource.eval(IO.raiseError<Unit>(finErr)));
      await expectLater(res.use(IO.pure), errors(finErr));
      expect(cleanedUp, isTrue);
    });
  });

  group('race', () {
    test('returns winner value when left wins', () {
      final left = Resource.make(IO.pure(1), (_) => IO.unit);
      final right = Resource.make(IO.sleep(5.seconds).productR(IO.pure(2)), (_) => IO.unit);
      final test = Resource.race(left, right).use(IO.pure);

      expect(test.ticked, succeeds(const Left<int, int>(1)));
    });

    test('returns winner value when right wins', () {
      final left = Resource.make(IO.sleep(5.seconds).productR(IO.pure(1)), (_) => IO.unit);
      final right = Resource.make(IO.pure(2), (_) => IO.unit);
      final test = Resource.race(left, right).use(IO.pure);

      expect(test.ticked, succeeds(const Right<int, int>(2)));
    });

    test('propagates left error', () {
      final left = Resource.eval(IO.raiseError<int>('left-boom'));
      final right = Resource.make(IO.sleep(5.seconds).productR(IO.pure(2)), (_) => IO.unit);
      final test = Resource.race(left, right).use(IO.pure);

      expect(test.ticked, errors('left-boom'));
    });

    test('propagates right error', () {
      final left = Resource.make(IO.sleep(5.seconds).productR(IO.pure(1)), (_) => IO.unit);
      final right = Resource.eval(IO.raiseError<int>('right-boom'));
      final test = Resource.race(left, right).use(IO.pure);

      expect(test.ticked, errors('right-boom'));
    });
  });
}
