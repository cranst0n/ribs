import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/src/scope.dart';
import 'package:test/test.dart';

void main() {
  group('CompositeError', () {
    test('toString includes all errors separated by commas', () {
      final err = CompositeError(ilist(['first', 'second', 'third']));
      expect(err.toString(), 'CompositeError(first, second, third)');
    });

    test('toString with single error', () {
      final err = CompositeError(ilist(['oops']));
      expect(err.toString(), 'CompositeError(oops)');
    });

    test('toString with empty error list', () {
      final err = CompositeError(nil<Object>());
      expect(err.toString(), 'CompositeError()');
    });
  });

  group('Scope', () {
    group('create / isRoot', () {
      test('root scope has no parent', () {
        expect(Scope.create().map((s) => s.isRoot), ioSucceeded(isTrue));
      });

      test('child scope is not root', () {
        expect(
          Scope.create().flatMap((parent) {
            return Scope.create(parent).map((child) => child.isRoot);
          }),
          ioSucceeded(isFalse),
        );
      });

      test('creating child scope registers it in parent', () {
        // When the parent closes, the child scope should also close and run
        // its own finalizers.
        final test = IO.ref(false).flatMap((childFinalized) {
          return Scope.create().flatMap((parent) {
            return Scope.create(parent).flatMap((child) {
              return child
                  .register((_) => childFinalized.setValue(true))
                  .productR(() => parent.close(ExitCase.succeeded()))
                  .productR(() => childFinalized.value());
            });
          });
        });

        expect(test, ioSucceeded(isTrue));
      });
    });

    group('register', () {
      test('finalizer runs when scope closes', () {
        final test = IO.ref(false).flatMap((ran) {
          return Scope.create().flatMap((scope) {
            return scope
                .register((_) => ran.setValue(true))
                .productR(() => scope.close(ExitCase.succeeded()))
                .productR(() => ran.value());
          });
        });

        expect(test, ioSucceeded(isTrue));
      });

      test('finalizer receives the ExitCase passed to close', () {
        final test = IO.ref<ExitCase?>(null).flatMap((ref) {
          return Scope.create().flatMap((scope) {
            return scope
                .register(ref.setValue)
                .productR(() => scope.close(ExitCase.errored('boom')))
                .productR(() => ref.value());
          });
        });

        expect(test.map((ec) => ec!.isError), ioSucceeded(isTrue));
      });

      test('multiple finalizers all run on close', () {
        final test = IO.ref(nil<int>()).flatMap((ref) {
          return Scope.create().flatMap((scope) {
            return scope
                .register((_) => ref.update((l) => l.appended(1)))
                .productR(() => scope.register((_) => ref.update((l) => l.appended(2))))
                .productR(() => scope.register((_) => ref.update((l) => l.appended(3))))
                .productR(() => scope.close(ExitCase.succeeded()))
                .productR(() => ref.value());
          });
        });

        // Finalizers run LIFO: last registered runs first
        expect(test, ioSucceeded(ilist([3, 2, 1])));
      });

      test('registering on a closed scope immediately invokes with Canceled', () {
        final test = IO.ref<ExitCase?>(null).flatMap((ref) {
          return Scope.create().flatMap((scope) {
            return scope
                .close(ExitCase.succeeded())
                .productR(() => scope.register(ref.setValue))
                .productR(() => ref.value());
          });
        });

        expect(test.map((ec) => ec!.isCanceled), ioSucceeded(isTrue));
      });
    });

    group('close', () {
      test('returns Right(Unit) when no finalizers throw', () async {
        final result =
            await Scope.create()
                .flatMap((scope) => scope.close(ExitCase.succeeded()))
                .unsafeRunFuture();

        expect(result.isRight, isTrue);
      });

      test('is idempotent — second close returns Right(Unit) without re-running finalizers', () {
        final test = IO.ref(0).flatMap((counter) {
          return Scope.create().flatMap((scope) {
            return scope
                .register((_) => counter.update((n) => n + 1))
                .productR(() => scope.close(ExitCase.succeeded()))
                .productR(() => scope.close(ExitCase.succeeded()))
                .productR(() => counter.value());
          });
        });

        expect(test, ioSucceeded(1));
      });

      test('single failing finalizer returns Left with that error', () async {
        final err = Exception('finalizer failed');
        final result =
            await Scope.create().flatMap((scope) {
              return scope
                  .register((_) => IO.raiseError(err))
                  .productR(() => scope.close(ExitCase.succeeded()));
            }).unsafeRunFuture();

        expect(result.isLeft, isTrue);
        expect(result.fold((e) => e, (_) => null), same(err));
      });

      test('multiple failing finalizers returns Left(CompositeError)', () async {
        final result =
            await Scope.create().flatMap((scope) {
              return scope
                  .register((_) => IO.raiseError(Exception('first')))
                  .productR(() => scope.register((_) => IO.raiseError(Exception('second'))))
                  .productR(() => scope.close(ExitCase.succeeded()));
            }).unsafeRunFuture();

        expect(result.isLeft, isTrue);
        expect(result.fold((e) => e, (_) => null), isA<CompositeError>());
      });

      test('all finalizers run even when some throw — errors are collected', () async {
        final ran = <int>[];
        final result =
            await Scope.create().flatMap((scope) {
              return scope
                  .register((_) => IO.exec(() => ran.add(1)))
                  .productR(
                    () => scope.register((_) => IO.raiseError<Unit>(Exception('middle fails'))),
                  )
                  .productR(() => scope.register((_) => IO.exec(() => ran.add(3))))
                  .productR(() => scope.close(ExitCase.succeeded()));
            }).unsafeRunFuture();

        // Finalizers run LIFO: 3 ran, middle threw, 1 ran. All three were attempted.
        expect(ran, containsAll([1, 3]));
        expect(result.isLeft, isTrue);
      });
    });

    group('lease', () {
      test('returns a Lease on an open scope', () {
        expect(
          Scope.create().flatMap((scope) => scope.lease()),
          ioSucceeded(isA<Lease>()),
        );
      });

      test('raises StateError when scope is already closed', () {
        expect(
          Scope.create().flatMap((scope) {
            return scope.close(ExitCase.succeeded()).productR(() => scope.lease());
          }),
          ioErrored(),
        );
      });

      test('close is deferred while a lease is held', () {
        final test = IO.ref(false).flatMap((finalized) {
          return Scope.create().flatMap((scope) {
            return scope
                .register((_) => finalized.setValue(true))
                .flatMap((_) => scope.lease())
                .flatMap((lease) {
                  return scope
                      .close(ExitCase.succeeded())
                      .flatMap((_) => finalized.value())
                      .flatMap((beforeRelease) {
                        return lease.cancel
                            .flatMap((_) => finalized.value())
                            .map((afterRelease) => (beforeRelease, afterRelease));
                      });
                });
          });
        });

        // Finalizer should NOT have run before the lease is released
        expect(test, ioSucceeded((false, true)));
      });

      test('finalizers run only after the last lease is released', () {
        final test = IO.ref(0).flatMap((counter) {
          return Scope.create().flatMap((scope) {
            return scope
                .register((_) => counter.update((n) => n + 1))
                .flatMap((_) => IO.both(scope.lease(), scope.lease()))
                .flatMap((leases) {
                  final (l1, l2) = leases;
                  return scope
                      .close(ExitCase.succeeded())
                      .flatMap((_) => l1.cancel)
                      .flatMap((_) => counter.value())
                      .flatMap((afterFirst) {
                        return l2.cancel
                            .flatMap((_) => counter.value())
                            .map((afterSecond) => (afterFirst, afterSecond));
                      });
                });
          });
        });

        // Finalizer counter is 0 after first lease release, 1 after last
        expect(test, ioSucceeded((0, 1)));
      });

      test('cancel on released lease returns Right when no pending close', () async {
        final result =
            await Scope.create().flatMap((scope) {
              return scope.lease().flatMap((lease) => lease.cancel);
            }).unsafeRunFuture();

        expect(result.isRight, isTrue);
      });
    });
  });
}
