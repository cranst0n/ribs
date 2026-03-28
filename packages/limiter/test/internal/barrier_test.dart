import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_limiter/src/internal/barrier.dart';
import 'package:test/test.dart';

void main() {
  IO<Unit> fillBarrier(Barrier barrier) =>
      barrier.limit.flatMap((limit) => barrier.enter().replicate_(limit)).voided();

  Resource<IO<Duration>> timedStart<A>(IO<A> fa) => fa.timed().background().map((foc) {
    return foc.flatMap((oc) => oc.embedNever().map((tuple) => tuple.$1));
  });

  test('enter the barrier immediately if below the limit', () {
    final test = Barrier.create(10).flatMap((b) => b.enter());
    expect(test, succeeds());
  });

  test('enter blocks when the limit is hit', () {
    final test = Barrier.create(2).flatMap((b) => fillBarrier(b).productR(b.enter()));
    expect(test, nonTerminating);
  });

  test('enter is unblocked by exit', () {
    final test = Barrier.create(1).flatMap((barrier) {
      return fillBarrier(barrier).productR(
        timedStart(barrier.enter()).use((getResult) {
          return IO.sleep(1.second).productR(barrier.exit()).productR(getResult);
        }),
      );
    });

    expect(test.ticked, succeeds(1.second));
  });

  test('enter is unblocked by exit the corret number of times', () {
    final test = Barrier.create(3).flatMap((barrier) {
      return fillBarrier(barrier).flatMap((_) {
        return timedStart(barrier.enter().productR(barrier.enter())).use((getResult) {
          return IO
              .sleep(1.second)
              .productR(barrier.exit())
              .product(IO.sleep(1.second))
              .productR(barrier.exit())
              .productR(getResult);
        });
      });
    });

    expect(test.ticked, succeeds(2.seconds));
  });

  test('only one fiber can block on enter at the same time', () {
    final test = Barrier.create(5).flatMap(
      (barrier) => fillBarrier(barrier).productR((barrier.enter(), barrier.enter()).parTupled),
    );

    expect(test, errors());
  });

  test('cannot call exit without entering', () {
    final test = Barrier.create(5).flatMap((barrier) => barrier.exit().productR(barrier.enter()));

    expect(test, errors());
  });

  test('calls to exit cannot outnumber calls to enter', () {
    final test = Barrier.create(2).flatMap(
      (barrier) => barrier
          .enter()
          .productR(barrier.enter())
          .productR(barrier.exit())
          .productR(barrier.exit())
          .productR(barrier.exit()),
    );

    expect(test, errors());
  });

  test('cannot create a barrier with non-positive limit', () {
    expect(Barrier.create(0), errors());
    expect(Barrier.create(-1), errors());
  });

  test('cannot change the limit to non-positive limit', () {
    expect(Barrier.create(1).flatMap((barrier) => barrier.setLimit(0)), errors());
    expect(Barrier.create(1).flatMap((barrier) => barrier.setLimit(-1)), errors());
  });

  test('A blocked enter is immediately unblocked if the limit is expanded', () {
    final test = Barrier.create(3).flatMap((barrier) {
      return fillBarrier(barrier).flatMap((_) {
        return timedStart(barrier.enter().productR(barrier.enter())).use((getResult) {
          return IO
              .sleep(1.second)
              .productR(barrier.setLimit(4))
              .productR(IO.sleep(1.second))
              .product(barrier.setLimit(5))
              .productR(getResult);
        });
      });
    });

    expect(test.ticked, succeeds(2.seconds));
  });

  test('A blocked enter is not unblocked prematurely if the limit is shrunk', () {
    final test = Barrier.create(3).flatMap((barrier) {
      return fillBarrier(barrier).flatMap((_) {
        return timedStart(barrier.enter()).use((getResult) {
          return barrier
              .setLimit(2)
              .productR(IO.sleep(1.second))
              .productR(barrier.exit())
              .productR(getResult);
        });
      });
    });

    expect(test, nonTerminating);
  });

  test('Sequential limit changes', () {
    final test = Barrier.create(3).flatMap((barrier) {
      return fillBarrier(barrier).flatMap((_) {
        return timedStart(barrier.enter()).use((_) {
          return barrier
              .setLimit(5)
              .productR(barrier.enter())
              .productR(barrier.setLimit(2))
              .productR(barrier.exit())
              .productR(barrier.exit())
              .productR(barrier.enter());
        });
      });
    });

    expect(test, nonTerminating);
  });
}
