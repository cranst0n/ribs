import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('Ref', () {
    test('get and set successfully', () {
      final op = IO.ref(0).flatMap((r) {
        return r.getAndSet(1).flatMap((getAndSetResult) {
          return r.value().map((getResult) {
            return getAndSetResult == 0 && getResult == 1;
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('get and update successfully', () {
      final op = IO.ref(0).flatMap((r) {
        return r.getAndUpdate((a) => a + 1).flatMap((getAndUpdateResult) {
          return r.value().map((getResult) {
            return getAndUpdateResult == 0 && getResult == 1;
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('update and get successfully', () {
      final op = IO.ref(0).flatMap((r) {
        return r.updateAndGet((a) => a + 1).flatMap((updateAndGetResult) {
          return r.value().map((getResult) {
            return updateAndGetResult == 1 && getResult == 1;
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('access successfully', () {
      final op = IO.ref(0).flatMap((r) {
        return r.access().flatMap((valueAndSetter) {
          final (value, setter) = valueAndSetter;
          return setter(value + 1).flatMap((success) {
            return r.value().map((result) {
              return success && result == 1;
            });
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('access - setter should fail if value is modified before setter is called', () {
      final op = IO.ref(0).flatMap((r) {
        return r.access().flatMap((valueAndSetter) {
          final (value, setter) = valueAndSetter;
          return r.setValue(5).flatMap((_) {
            return setter(value + 1).flatMap((success) {
              return r.value().map((result) {
                return !success && result == 5;
              });
            });
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('tryUpdate - modification occurs successfully', () {
      final op = IO.ref(0).flatMap((r) {
        return r.tryUpdate((a) => a + 1).flatMap((result) {
          return r.value().map((value) {
            return result && value == 1;
          });
        });
      });

      expect(op, ioSucceeded(true));
    });

    test('flatModify - finalizer should be uncancelable', () async {
      var passed = false;

      final op = IO.ref(0).flatMap((r) {
        return r
            .flatModify((_) => (1, IO.canceled.productR(() => IO.exec(() => passed = true))))
            .start()
            .flatMap((f) => f.join())
            .voided()
            .flatMap((_) {
              return r.value().map((result) {
                return result == 1;
              });
            });
      });

      await expectLater(op, ioSucceeded(true));
      expect(passed, isTrue);
    });

    test('flatModifyFull - finalizer should mask cancellation', () async {
      var passed = false;
      var failed = false;

      final op = IO.ref(0).flatMap((ref) {
        return ref
            .flatModifyFull((t) {
              final (poll, _) = t;
              return (
                1,
                poll(
                  IO.canceled.productR(() => IO.exec(() => failed = true)),
                ).onCancel(IO.exec(() => passed = true)),
              );
            })
            .start()
            .flatMap((f) => f.join())
            .voided()
            .flatMap((_) {
              return ref.value().map((result) {
                return result == 1;
              });
            });
      });

      await expectLater(op, ioSucceeded(true));
      expect(passed, isTrue);
      expect(failed, isFalse);
    });
  });

  test('getAndUpdate', () {
    final test = Ref.of(0).flatMap((ref) => ref.getAndUpdate((a) => a + 1).product(ref.value()));

    expect(test, ioSucceeded((0, 1)));
  });

  test('getAndSet', () {
    final test = Ref.of(0).flatMap((ref) => ref.getAndSet(42).product(ref.value()));

    expect(test, ioSucceeded((0, 42)));
  });

  test('access successful set', () {
    final test = Ref.of(
      0,
    ).flatMap((ref) => ref.access().flatMap((t) => t.$2(42)).product(ref.value()));

    expect(test, ioSucceeded((true, 42)));
  });

  test('access failed set', () {
    final test = Ref.of(0).flatMap(
      (ref) => ref
          .access()
          .flatMap((t) => ref.setValue(10).flatMap((_) => t.$2(42)))
          .product(ref.value()),
    );

    expect(test, ioSucceeded((false, 10)));
  });

  test('tryModify', () {
    final test = Ref.of(
      0,
    ).flatMap((ref) => ref.tryModify((x) => (x + 3, x.toString())).product(ref.value()));

    expect(test, ioSucceeded(('0'.some, 3)));
  });
}
