import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:test/test.dart';

void main() {
  group('Semaphore', () {
    IO<Semaphore> sc(int n) => Semaphore.permits(n);

    test('execute action if permit is available for it', () {
      final test = sc(0).flatMap((sem) => sem.permit().surround(IO.unit));
      expect(test, nonTerminating);
    });

    test('tryPermit returns true if permit is available for it', () {
      final test = sc(1).flatMap((sem) => sem.tryPermit().use(IO.pure));
      expect(test, succeeds(true));
    });

    test('tryPermit returns false if no permit is available for it', () {
      final test = sc(0).flatMap((sem) => sem.tryPermit().use(IO.pure));
      expect(test, succeeds(false));
    });

    test('unblock when permit is released', () {
      final test = sc(1).flatMap((sem) {
        return IO.ref(false).flatMap((ref) {
          return sem
              .permit()
              .surround(IO.sleep(1.second).productR(ref.setValue(true)))
              .start()
              .flatMap((_) {
                return IO.sleep(500.milliseconds).flatMap((_) {
                  return sem.permit().surround(IO.unit).flatMap((_) {
                    return ref.value();
                  });
                });
              });
        });
      });

      expect(test, succeeds(true));
    });

    test('release permit if permit errors', () {
      final test = sc(1).flatMap((sem) {
        return sem.permit().surround(IO.raiseError<Unit>('boom')).attempt().flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('release permit if tryPermit errors', () {
      final test = sc(1).flatMap((sem) {
        return sem.tryPermit().surround(IO.raiseError<Unit>('boom')).attempt().flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('release permit if permit completes', () {
      final test = sc(1).flatMap((sem) {
        return sem.permit().surround(IO.unit).attempt().flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('release permit if tryPermit completes', () {
      final test = sc(1).flatMap((sem) {
        return sem.tryPermit().surround(IO.unit).attempt().flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('not release permit if tryPermit completes without acquiring a permit', () {
      final test = sc(0).flatMap((sem) {
        return sem.tryPermit().surround(IO.unit).flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, nonTerminating);
    });

    test('release permit if action gets canceled', () {
      final test = sc(1).flatMap((sem) {
        return sem.permit().surround(IO.never<Unit>()).start().flatMap((fiber) {
          return IO.sleep(1.second).flatMap((_) {
            return fiber.cancel().flatMap((_) {
              return sem.permit().surround(IO.unit);
            });
          });
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('release tryPermit if action gets canceled', () {
      final test = sc(1).flatMap((sem) {
        return sem.tryPermit().surround(IO.never<Unit>()).start().flatMap((fiber) {
          return IO.sleep(1.second).flatMap((_) {
            return fiber.cancel().flatMap((_) {
              return sem.permit().surround(IO.unit);
            });
          });
        });
      });

      expect(test, succeeds(Unit()));
    });

    test('allow cancelation if blocked waiting for permit', () {
      final test = sc(0).flatMap((sem) {
        return IO.ref(false).flatMap((ref) {
          return sem.permit().surround(IO.unit).onCancel(ref.setValue(true)).start().flatMap((f) {
            return IO.sleep(1.second).flatMap((_) {
              return f.cancel().flatMap((_) {
                return ref.value();
              });
            });
          });
        });
      });

      expect(test, succeeds(true));
    });

    test('not release permit when an acquire gets canceled', () {
      final test = sc(0).flatMap((sem) {
        return sem.permit().surround(IO.unit).timeout(1.second).attempt().flatMap((_) {
          return sem.permit().surround(IO.unit);
        });
      });

      expect(test, nonTerminating);
    });

    test('acquire n synchronosly', () {
      const n = 20;
      final op = sc(n).flatMap((sem) {
        return IList.range(0, n).traverseIO_((_) => sem.acquire()).productR(sem.available());
      });

      expect(op, succeeds(0));
    });

    test('acquireN does not leak permits upon cancelation', () {
      final op = sc(1).flatMap((sem) {
        return sem.acquireN(2).timeout(1.second).attempt().productR(sem.acquire());
      });

      expect(op, succeeds(Unit()));
    });

    test('available with no available permits', () {
      IO<(int, T)> withLock<T>(int n, Semaphore s, IO<T> check) => s
          .acquireN(n)
          .background()
          .surround(s.count().iterateUntil((i) => i < 0).flatMap((t) => check.tupleLeft(t)));

      const n = 20;

      final test = sc(n).flatMap((sem) {
        return sem.acquire().replicate(n).flatMap((_) {
          return withLock(1, sem, sem.available());
        });
      });

      expect(test, succeeds((-1, 0)));
    });

    test('tryAcquire with available permits', () {
      const n = 20;

      final test = sc(30).flatMap((sem) {
        return IList.range(0, n).traverseIO_((_) => sem.acquire()).flatMap((_) {
          return sem.tryAcquire();
        });
      });

      expect(test, succeeds(true));
    });

    test('tryAcquire with no available permits', () {
      const n = 20;

      final test = sc(20).flatMap((sem) {
        return IList.range(0, n).traverseIO_((_) => sem.acquire()).flatMap((_) {
          return sem.tryAcquire();
        });
      });

      expect(test, succeeds(false));
    });

    test('tryAcquireN all available permits', () {
      const n = 20;

      final test = sc(20).flatMap((sem) {
        return sem.tryAcquireN(n);
      });

      expect(test, succeeds(true));
    });

    test('offsetting acquires/releases - acquires parallel with releases', () {
      final permits = ilist([1, 0, 20, 4, 0, 5, 2, 1, 1, 3]);

      final test = sc(0).flatMap((sem) {
        return (
          permits.traverseIO_(sem.acquireN),
          permits.reverse().traverseIO_(sem.releaseN),
        ).parTupled.productR(sem.count());
      });

      expect(test, succeeds(0));
    });

    test('offsetting acquires/releases - individual acquires/increment in parallel', () {
      final permits = ilist([1, 0, 20, 4, 0, 5, 2, 1, 1, 3]);

      final test = sc(0).flatMap((sem) {
        return (
          permits.parTraverseIO_(sem.acquireN),
          permits.reverse().parTraverseIO_(sem.releaseN),
        ).parTupled.productR(sem.count());
      });

      expect(test, succeeds(0));
    });

    test('available with available permits', () {
      final test = sc(20).flatMap((sem) => sem.acquireN(19).flatMap((_) => sem.available()));

      expect(test, succeeds(1));
    });

    test('available with 0 available permits', () {
      final test = sc(
        20,
      ).flatMap((sem) => sem.acquireN(20).flatMap((_) => IO.cede.productR(sem.available())));

      expect(test, succeeds(0));
    });

    test('count with available permits', () {
      const n = 18;

      final test = sc(20).flatMap((sem) {
        return IList.range(0, n).traverseIO_((_) => sem.acquire()).flatMap((_) {
          return sem.available().flatMap((a) {
            return sem.count().flatMap((t) {
              return expectIO(a, t);
            });
          });
        });
      });

      expect(test, succeeds());
    });

    test('count with no available permits', () {
      const n = 8;

      final test = sc(n).flatMap((sem) {
        return sem
            .acquireN(n)
            .productR(
              sem.acquireN(n).background().use((_) => sem.count().iterateUntil((x) => x < 0)),
            );
      });

      expect(test, succeeds(-n));
    });

    test('count with 0 available permits', () {
      final test = sc(20).flatMap((sem) => sem.acquireN(20).productR(sem.count()));

      expect(test, succeeds(0));
    });
  });
}
