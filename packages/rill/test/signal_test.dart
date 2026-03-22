import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';

import 'package:ribs_rill/src/signal.dart';
import 'package:test/test.dart';

void main() {
  test(
    'SignallingRef.tryModify works correctly',
    () {
      final test = SignallingRef.of(0).flatMap((ref) {
        // Attempt to modify optimistically
        return ref
            .tryModify((current) {
              if (current < 10) {
                return (current + 1, "incremented");
              } else {
                return (current, "limit reached"); // No change
              }
            })
            .flatMap((result) {
              if (result.isDefined && result.getOrElse(() => "") == "incremented") {
                return IO.unit;
              } else {
                return IO.raiseError<Unit>(
                  Exception("Expected Some('incremented'), got $result"),
                );
              }
            });
      });

      expect(test, ioSucceeded());
    },
  );

  group('SignallingRef', () {
    group('value', () {
      test('returns the initial value', () {
        expect(
          SignallingRef.of(42).flatMap((ref) => ref.value()),
          ioSucceeded(42),
        );
      });
    });

    group('setValue', () {
      test('updates the current value', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.setValue(99).productR(() => ref.value());
          }),
          ioSucceeded(99),
        );
      });
    });

    group('update', () {
      test('applies function to current value', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.update((n) => n * 2).productR(() => ref.value());
          }),
          ioSucceeded(20),
        );
      });
    });

    group('getAndSet', () {
      test('returns old value and stores new value', () {
        expect(
          SignallingRef.of(1).flatMap((ref) {
            return ref.getAndSet(2).flatMap((old) {
              return ref.value().map((current) => (old, current));
            });
          }),
          ioSucceeded((1, 2)),
        );
      });
    });

    group('getAndUpdate', () {
      test('returns old value after applying function', () {
        expect(
          SignallingRef.of(5).flatMap((ref) {
            return ref.getAndUpdate((n) => n + 1).flatMap((old) {
              return ref.value().map((current) => (old, current));
            });
          }),
          ioSucceeded((5, 6)),
        );
      });
    });

    group('updateAndGet', () {
      test('returns new value after applying function', () {
        expect(
          SignallingRef.of(3).flatMap((ref) => ref.updateAndGet((n) => n * 3)),
          ioSucceeded(9),
        );
      });
    });

    group('modify', () {
      test('updates value and returns associated result', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.modify((n) => (n + 5, 'was $n'));
          }),
          ioSucceeded('was 10'),
        );
      });

      test('value is updated after modify', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.modify((n) => (n + 5, n)).productR(() => ref.value());
          }),
          ioSucceeded(15),
        );
      });
    });

    group('tryUpdate', () {
      test('returns true when update succeeds', () {
        expect(
          SignallingRef.of(0).flatMap((ref) => ref.tryUpdate((n) => n + 1)),
          ioSucceeded(isTrue),
        );
      });

      test('value is updated after tryUpdate', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.tryUpdate((n) => n + 1).productR(() => ref.value());
          }),
          ioSucceeded(1),
        );
      });
    });

    group('flatModify', () {
      test('updates value and executes returned IO', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.flatModify((n) => (n + 1, ref.value()));
          }),
          ioSucceeded(1),
        );
      });
    });

    group('flatModifyFull', () {
      test('provides poll and updates value', () {
        expect(
          SignallingRef.of(7).flatMap((ref) {
            return ref.flatModifyFull((tuple) {
              final (_, n) = tuple;
              return (n * 2, ref.value());
            });
          }),
          ioSucceeded(14),
        );
      });
    });

    group('access', () {
      test('setter returns true when state is unchanged', () async {
        final result =
            await SignallingRef.of(0).flatMap((ref) {
              return ref.access().flatMap((t) {
                final (_, setter) = t;
                return setter(42);
              });
            }).unsafeRunFuture();

        expect(result, isTrue);
      });

      test('setter returns false when state was modified between access and set', () async {
        final result =
            await SignallingRef.of(0).flatMap((ref) {
              return ref.access().flatMap((t) {
                final (_, setter) = t;
                return ref.update((n) => n + 1).productR(() => setter(42));
              });
            }).unsafeRunFuture();

        expect(result, isFalse);
      });

      test('returns current value', () {
        expect(
          SignallingRef.of(55).flatMap((ref) {
            return ref.access().mapN((a, _) => a);
          }),
          ioSucceeded(55),
        );
      });
    });

    group('discrete', () {
      test('emits initial value immediately', () async {
        final result =
            await SignallingRef.of(10).flatMap((ref) {
              return ref.discrete.take(1).compile.toIList;
            }).unsafeRunFuture();

        expect(result, ilist([10]));
      });

      test('emits updated values after changes', () async {
        final result =
            await SignallingRef.of(0).flatMap((ref) {
              final updates = ref.discrete.take(3).compile.toIList;
              final changes = IO
                  .sleep(10.milliseconds)
                  .productR(() => ref.setValue(1))
                  .productR(() => IO.sleep(10.milliseconds))
                  .productR(() => ref.setValue(2));
              return IO.both(updates, changes).mapN((a, _) => a);
            }).unsafeRunFuture();

        expect(result, ilist([0, 1, 2]));
      });
    });

    group('continuous', () {
      test('emits the current value on every poll', () async {
        final result =
            await SignallingRef.of(5).flatMap((ref) {
              return ref.continuous.take(3).compile.toIList;
            }).unsafeRunFuture();

        expect(result, ilist([5, 5, 5]));
      });

      test('reflects latest value after update', () async {
        final result =
            await SignallingRef.of(0).flatMap((ref) {
              return ref
                  .setValue(99)
                  .productR(
                    () => ref.continuous.take(1).compile.toIList,
                  );
            }).unsafeRunFuture();

        expect(result, ilist([99]));
      });
    });

    group('changes', () {
      test('changes() signal filters consecutive duplicate values', () async {
        // ref.changes() wraps discrete with filterWithPrevious((a,b) => a!=b),
        // so writes of the same value are suppressed.
        final result =
            await SignallingRef.of(0).flatMap((ref) {
              final stream = ref.changes().discrete.take(3).compile.toIList;
              final writes = IO
                  .sleep(10.milliseconds)
                  .productR(() => ref.setValue(1))
                  .productR(() => IO.sleep(10.milliseconds))
                  .productR(() => ref.setValue(1)) // same value — filtered out
                  .productR(() => IO.sleep(10.milliseconds))
                  .productR(() => ref.setValue(2));
              return IO.both(stream, writes).mapN((a, _) => a);
            }).unsafeRunFuture();

        // 0 (initial), 1 (first change), 2 (third write, second distinct change)
        expect(result, ilist([0, 1, 2]));
      });
    });

    group('getAndDiscreteUpdates', () {
      test('returns current value paired with update stream', () async {
        final result =
            await SignallingRef.of(42).flatMap((ref) {
              return ref.getAndDiscreteUpdates().use((t) {
                final (initial, updates) = t;
                final recv = updates.take(1).compile.toIList.map((l) => (initial, l));
                final write = IO.sleep(10.milliseconds).productR(() => ref.setValue(99));
                return IO.both(recv, write).map((t2) => t2.$1);
              });
            }).unsafeRunFuture();

        expect(result.$1, 42);
        expect(result.$2, ilist([99]));
      });
    });

    group('waitUntil', () {
      test('completes immediately when predicate is already true', () {
        expect(
          SignallingRef.of(10).flatMap((ref) => ref.waitUntil((n) => n > 5)),
          ioSucceeded(Unit()),
        );
      });

      test('blocks until predicate becomes true', () async {
        final test = SignallingRef.of(0).flatMap((ref) {
          final wait = ref.waitUntil((n) => n >= 3);
          final increments = IO
              .sleep(20.milliseconds)
              .productR(() => ref.setValue(1))
              .productR(() => IO.sleep(20.milliseconds))
              .productR(() => ref.setValue(2))
              .productR(() => IO.sleep(20.milliseconds))
              .productR(() => ref.setValue(3));
          return IO.both(wait, increments).voided();
        });

        await expectLater(test.unsafeRunFuture(), completes);
      });
    });
  });

  group('Signal.map extension', () {
    test('maps values from discrete', () async {
      final result =
          await SignallingRef.of(3).flatMap((ref) {
            final mapped = ref.map((n) => n * 10);
            final recv = mapped.discrete.take(1).compile.toIList;
            return recv;
          }).unsafeRunFuture();

      expect(result, ilist([30]));
    });

    test('maps value()', () {
      expect(
        SignallingRef.of(7).flatMap((ref) {
          return ref.map((n) => '$n').value();
        }),
        ioSucceeded('7'),
      );
    });

    test('maps continuous emissions', () async {
      final result =
          await SignallingRef.of(4).flatMap((ref) {
            return ref.map((n) => n * 2).continuous.take(2).compile.toIList;
          }).unsafeRunFuture();

      expect(result, ilist([8, 8]));
    });

    test('getAndDiscreteUpdates maps initial and updates', () async {
      final result =
          await SignallingRef.of(5).flatMap((ref) {
            final mapped = ref.map((n) => n * 10);
            return mapped.getAndDiscreteUpdates().use((t) {
              final (initial, updates) = t;
              final recv = updates.take(1).compile.toIList.map((l) => (initial, l));
              final write = IO.sleep(10.milliseconds).productR(() => ref.setValue(9));
              return IO.both(recv, write).map((pair) => pair.$1);
            });
          }).unsafeRunFuture();

      expect(result.$1, 50);
      expect(result.$2, ilist([90]));
    });
  });
}
