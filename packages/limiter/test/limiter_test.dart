import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_limiter/ribs_limiter.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('submit semantics should return the result of the submitted job', () {
    final test = IO.ref(false).flatMap((complete) {
      return Limiter.start(200.milliseconds).use((limiter) {
        return limiter.submit(complete.setValue(true).as('done')).product(complete.value());
      });
    });

    expect(test, succeeds(('done', true)));
  });

  test('submit semantics should report errors of a failed task', () {
    final test = Limiter.start(200.milliseconds).use((limiter) {
      return limiter.submit(IO.raiseError<int>(StateError('BOOM')));
    });

    expect(test, errors(StateError('BOOM')));
  });

  IO<IVector<Duration>> simulation({
    required Duration desiredInterval,
    required int maxConcurrent,
    required Duration productionInterval,
    required int producers,
    required int jobsPerProducer,
    required Duration jobCompletion,
    Function1<Limiter, IO<Unit>>? control,
  }) {
    return Limiter.start(desiredInterval, maxConcurrent: maxConcurrent).use((limiter) {
      final job = IO.now.productL(IO.sleep(jobCompletion));

      final producer = Rill.emit(job)
          .repeatN(jobsPerProducer)
          .meteredStartImmediately(productionInterval)
          .mapAsyncUnordered(Integer.maxValue, (job) => limiter.submit(job));

      final runProducers = Rill.emit(producer).repeatN(producers).parJoinUnbounded();

      final results =
          runProducers.sliding(2).map((ab) => ab[1].difference(ab[0])).compile.toIVector;

      final control0 = control ?? (_) => IO.unit;

      return control0(limiter).background().surround(results);
    });
  }

  test('multiple fast producers, fast non-failing jobs', () {
    final test = simulation(
      desiredInterval: 200.milliseconds,
      maxConcurrent: Integer.maxValue,
      productionInterval: 1.millisecond,
      producers: 4,
      jobsPerProducer: 100,
      jobCompletion: 0.seconds,
    ).map((results) => results.forall((d) => d == 200.milliseconds));

    expect(test.ticked, succeeds(true));
  });

  test('slow producer, no unnecessary delays', () {
    final test = simulation(
      desiredInterval: 200.milliseconds,
      maxConcurrent: Integer.maxValue,
      productionInterval: 300.milliseconds,
      producers: 1,
      jobsPerProducer: 100,
      jobCompletion: 0.seconds,
    ).map((results) => results.forall((d) => d == 300.milliseconds));

    expect(test.ticked, succeeds(true));
  });

  test('maximum concurrency', () {
    final test = simulation(
      desiredInterval: 50.milliseconds,
      maxConcurrent: 3,
      productionInterval: 1.millisecond,
      producers: 1,
      jobsPerProducer: 10,
      jobCompletion: 300.milliseconds,
    );

    final expected = ivec([50, 50, 200, 50, 50, 200, 50, 50, 200]).map((n) => n.milliseconds);

    expect(test.ticked, succeeds(expected));
  });

  test('interval change', () {
    final test = simulation(
      desiredInterval: 200.milliseconds,
      maxConcurrent: Integer.maxValue,
      productionInterval: 1.millisecond,
      producers: 1,
      jobsPerProducer: 10,
      jobCompletion: 0.seconds,
      control:
          (limiter) =>
              IO.sleep(1100.milliseconds).productR(limiter.setMinInterval(300.milliseconds)),
    );

    final expected = ivec([200, 200, 200, 200, 200, 300, 300, 300, 300]).map((n) => n.milliseconds);

    expect(test.ticked, succeeds(expected));
  });

  test('descheduling a job while blocked on the time limit should not ffect the interval', () {
    final test = Limiter.start(500.milliseconds).use((limiter) {
      final job = limiter.submit(IO.now);
      final skew = IO.sleep(10.milliseconds); // to ensure we queue jobs as desired

      return (
        job,
        skew.productR(job.voided().timeoutTo(200.milliseconds, IO.unit)),
        skew.productR(skew).productR(job),
      ).parMapN((t1, _, t3) => t3.difference(t1));
    });

    expect(test.ticked, succeeds(500.milliseconds));
  });

  test(
    'descheduling a job while blocked on the concurrency limit should not affect the interval',
    () {
      final test = Limiter.start(30.milliseconds, maxConcurrent: 1).use((limiter) {
        final job = limiter.submit(IO.now.productL(IO.sleep(500.milliseconds)));
        final skew = IO.sleep(10.milliseconds); // to ensure we queue jobs as desired

        return (
          job,
          skew.productR(job.voided().timeoutTo(200.milliseconds, IO.unit)),
          skew.productR(skew).productR(job),
        ).parMapN((t1, _, t3) => t3.difference(t1));
      });

      expect(test.ticked, succeeds(500.milliseconds));
    },
  );

  test('canceling job, interval slot gets taken', () {
    throw UnimplementedError();
  });

  test('max concurrency shrinks before interval elapses, should be respected', () {
    throw UnimplementedError();
  });

  test('max concurrency shrinks after interval elapses, should be no-op', () {
    throw UnimplementedError();
  });
}
