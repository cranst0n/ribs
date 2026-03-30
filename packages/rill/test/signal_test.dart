import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';

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

      expect(test, succeeds());
    },
  );

  group('SignallingRef', () {
    group('value', () {
      test('returns the initial value', () {
        expect(
          SignallingRef.of(42).flatMap((ref) => ref.value()),
          succeeds(42),
        );
      });
    });

    group('setValue', () {
      test('updates the current value', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.setValue(99).productR(ref.value());
          }),
          succeeds(99),
        );
      });
    });

    group('update', () {
      test('applies function to current value', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.update((n) => n * 2).productR(ref.value());
          }),
          succeeds(20),
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
          succeeds((1, 2)),
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
          succeeds((5, 6)),
        );
      });
    });

    group('updateAndGet', () {
      test('returns new value after applying function', () {
        expect(
          SignallingRef.of(3).flatMap((ref) => ref.updateAndGet((n) => n * 3)),
          succeeds(9),
        );
      });
    });

    group('modify', () {
      test('updates value and returns associated result', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.modify((n) => (n + 5, 'was $n'));
          }),
          succeeds('was 10'),
        );
      });

      test('value is updated after modify', () {
        expect(
          SignallingRef.of(10).flatMap((ref) {
            return ref.modify((n) => (n + 5, n)).productR(ref.value());
          }),
          succeeds(15),
        );
      });
    });

    group('tryUpdate', () {
      test('returns true when update succeeds', () {
        expect(
          SignallingRef.of(0).flatMap((ref) => ref.tryUpdate((n) => n + 1)),
          succeeds(isTrue),
        );
      });

      test('value is updated after tryUpdate', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.tryUpdate((n) => n + 1).productR(ref.value());
          }),
          succeeds(1),
        );
      });
    });

    group('flatModify', () {
      test('updates value and executes returned IO', () {
        expect(
          SignallingRef.of(0).flatMap((ref) {
            return ref.flatModify((n) => (n + 1, ref.value()));
          }),
          succeeds(1),
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
          succeeds(14),
        );
      });
    });

    group('access', () {
      test('setter returns true when state is unchanged', () {
        final result = SignallingRef.of(0).flatMap((ref) {
          return ref.access().flatMap((t) {
            final (_, setter) = t;
            return setter(42);
          });
        });

        expect(result, succeeds(true));
      });

      test('setter returns false when state was modified between access and set', () {
        final result = SignallingRef.of(0).flatMap((ref) {
          return ref.access().flatMap((t) {
            final (_, setter) = t;
            return ref.update((n) => n + 1).productR(setter(42));
          });
        });

        expect(result, succeeds(false));
      });

      test('returns current value', () {
        expect(
          SignallingRef.of(55).flatMap((ref) {
            return ref.access().mapN((a, _) => a);
          }),
          succeeds(55),
        );
      });
    });

    group('discrete', () {
      test('emits initial value immediately', () {
        final result = SignallingRef.of(10).flatMap((ref) {
          return ref.discrete.take(1).compile.toIList;
        });

        expect(result, succeeds(ilist([10])));
      });

      test('emits updated values after changes', () {
        final result = SignallingRef.of(0).flatMap((ref) {
          final updates = ref.discrete.take(3).compile.toIList;

          final changes = IO
              .sleep(10.milliseconds)
              .productR(ref.setValue(1))
              .productR(IO.sleep(10.milliseconds))
              .productR(ref.setValue(2));

          return IO.both(updates, changes).mapN((a, _) => a);
        });

        expect(result, succeeds(ilist([0, 1, 2])));
      });
    });

    group('continuous', () {
      test('emits the current value on every poll', () {
        final result = SignallingRef.of(5).flatMap((ref) {
          return ref.continuous.take(3).compile.toIList;
        });

        expect(result, succeeds(ilist([5, 5, 5])));
      });

      test('reflects latest value after update', () {
        final result = SignallingRef.of(0).flatMap((ref) {
          return ref
              .setValue(99)
              .productR(
                ref.continuous.take(1).compile.toIList,
              );
        });

        expect(result, succeeds(ilist([99])));
      });
    });

    group('changes', () {
      test('changes() signal filters consecutive duplicate values', () {
        // ref.changes() wraps discrete with filterWithPrevious((a,b) => a!=b),
        // so writes of the same value are suppressed.
        final result = SignallingRef.of(0).flatMap((ref) {
          final stream = ref.changes().discrete.take(3).compile.toIList;
          final writes = IO
              .sleep(10.milliseconds)
              .productR(ref.setValue(1))
              .productR(IO.sleep(10.milliseconds))
              .productR(ref.setValue(1)) // same value — filtered out
              .productR(IO.sleep(10.milliseconds))
              .productR(ref.setValue(2));
          return IO.both(stream, writes).mapN((a, _) => a);
        });

        // 0 (initial), 1 (first change), 2 (third write, second distinct change)
        expect(result, succeeds(ilist([0, 1, 2])));
      });
    });

    group('getAndDiscreteUpdates', () {
      test('returns current value paired with update stream', () {
        final result = SignallingRef.of(42).flatMap((ref) {
          return ref.getAndDiscreteUpdates().use((t) {
            final (initial, updates) = t;
            final recv = updates.take(1).compile.toIList.map((l) => (initial, l));
            final write = IO.sleep(10.milliseconds).productR(ref.setValue(99));
            return IO.both(recv, write).map((t2) => t2.$1);
          });
        });

        expect(result, succeeds((42, ilist([99]))));
      });
    });

    group('waitUntil', () {
      test('completes immediately when predicate is already true', () {
        expect(
          SignallingRef.of(10).flatMap((ref) => ref.waitUntil((n) => n > 5)),
          succeeds(Unit()),
        );
      });

      test('blocks until predicate becomes true', () {
        final test = SignallingRef.of(0).flatMap((ref) {
          final wait = ref.waitUntil((n) => n >= 3);
          final increments = IO
              .sleep(20.milliseconds)
              .productR(ref.setValue(1))
              .productR(IO.sleep(20.milliseconds))
              .productR(ref.setValue(2))
              .productR(IO.sleep(20.milliseconds))
              .productR(ref.setValue(3));
          return IO.both(wait, increments).voided();
        });

        expect(test, succeeds());
      });
    });
  });

  group('Signal.map extension', () {
    test('maps values from discrete', () {
      final result = SignallingRef.of(3).flatMap((ref) {
        final mapped = ref.map((n) => n * 10);
        final recv = mapped.discrete.take(1).compile.toIList;
        return recv;
      });

      expect(result, succeeds(ilist([30])));
    });

    test('maps value()', () {
      expect(
        SignallingRef.of(7).flatMap((ref) => ref.map((n) => '$n').value()),
        succeeds('7'),
      );
    });

    test('maps continuous emissions', () {
      final result = SignallingRef.of(4).flatMap((ref) {
        return ref.map((n) => n * 2).continuous.take(2).compile.toIList;
      });

      expect(result, succeeds(ilist([8, 8])));
    });

    test('getAndDiscreteUpdates maps initial and updates', () {
      final result = SignallingRef.of(5).flatMap((ref) {
        final mapped = ref.map((n) => n * 10);
        return mapped.getAndDiscreteUpdates().use((t) {
          final (initial, updates) = t;
          final recv = updates.take(1).compile.toIList.map((l) => (initial, l));
          final write = IO.sleep(10.milliseconds).productR(ref.setValue(9));
          return IO.both(recv, write).map((pair) => pair.$1);
        });
      });

      expect(result, succeeds((50, ilist([90]))));
    });
  });
}
