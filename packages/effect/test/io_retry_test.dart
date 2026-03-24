import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:test/test.dart';

void main() {
  test('RetryPolicy.meet', () {
    expect(
      RetryPolicy.alwaysGiveUp().meet(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus.initial()),
      RetryDecision.giveUp(),
    );

    expect(
      RetryPolicy.limitRetries(5).meet(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus.initial()),
      RetryDecision.delayAndRetry(Duration.zero),
    );

    expect(
      RetryPolicy.limitRetries(
        3,
      ).meet(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus(3, Duration.zero, none())),
      RetryDecision.giveUp(),
    );

    expect(
      RetryPolicy.alwaysGiveUp()
          .meet(RetryPolicy.constantDelay(1.second))
          .decideOn(RetryStatus.initial()),
      RetryDecision.delayAndRetry(1.second),
    );

    expect(
      RetryPolicy.alwaysGiveUp()
          .meet(RetryPolicy.exponentialBackoff(1.second))
          .decideOn(RetryStatus.initial()),
      RetryDecision.delayAndRetry(1.second),
    );

    expect(
      RetryPolicy.alwaysGiveUp()
          .meet(RetryPolicy.exponentialBackoff(1.second))
          .decideOn(const RetryStatus(1, Duration.zero, Some(Duration.zero))),
      RetryDecision.delayAndRetry(2.seconds),
    );
  });

  test('RetryPolicy.join', () {
    expect(
      RetryPolicy.alwaysGiveUp().join(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus.initial()),
      RetryDecision.giveUp(),
    );

    expect(
      RetryPolicy.limitRetries(5).join(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus.initial()),
      RetryDecision.giveUp(),
    );

    expect(
      RetryPolicy.limitRetries(3)
          .join(RetryPolicy.constantDelay(Duration.zero))
          .decideOn(RetryStatus(3, Duration.zero, none())),
      RetryDecision.giveUp(),
    );

    // both policies want to retry: takes the max delay
    expect(
      RetryPolicy.constantDelay(
        1.second,
      ).join(RetryPolicy.constantDelay(2.seconds)).decideOn(RetryStatus.initial()),
      RetryDecision.delayAndRetry(2.seconds),
    );
  });

  test('RetryPolicy.followedBy', () {
    // this gives up -> followedBy also gives up
    expect(
      RetryPolicy.alwaysGiveUp()
          .followedBy(RetryPolicy.constantDelay(1.second))
          .decideOn(RetryStatus.initial()),
      RetryDecision.giveUp(),
    );

    // this retries -> decision deferred to the other policy (which gives up)
    expect(
      RetryPolicy.constantDelay(
        500.milliseconds,
      ).followedBy(RetryPolicy.alwaysGiveUp()).decideOn(RetryStatus.initial()),
      RetryDecision.giveUp(),
    );

    // this retries -> decision deferred to the other policy (which also retries)
    expect(
      RetryPolicy.constantDelay(
        500.milliseconds,
      ).followedBy(RetryPolicy.constantDelay(1.second)).decideOn(RetryStatus.initial()),
      RetryDecision.delayAndRetry(1.second),
    );
  });

  test('RetryStatus equality, hashCode, toString', () {
    final s1 = RetryStatus(2, 5.seconds, Some(2.seconds));
    final s2 = RetryStatus(2, 5.seconds, Some(2.seconds));
    final s3 = RetryStatus(3, 5.seconds, Some(2.seconds));

    expect(s1, s2);
    expect(s1, isNot(s3));
    expect(s1.hashCode, s2.hashCode);
    expect(s1.toString(), contains('retriesSoFar: 2'));
  });

  test('RetryStatus.retryAfter', () {
    final s = RetryStatus.initial().retryAfter(1.second);
    expect(s.retriesSoFar, 1);
    expect(s.cumulativeDelay, 1.second);
    expect(s.previousDelay, Some(1.second));
  });

  test('RetryDecision.delayAndRetry toString and hashCode', () {
    final d1 = RetryDecision.delayAndRetry(1.second);
    final d2 = RetryDecision.delayAndRetry(1.second);
    expect(d1.toString(), contains('DelayAndRetry'));
    expect(d1.hashCode, d2.hashCode);
  });

  test('RetryPolicy.fullJitter produces non-giving-up decision within range', () {
    final decision = RetryPolicy.fullJitter(1.second).decideOn(RetryStatus.initial());
    expect(decision.isGivingUp, isFalse);
    expect(decision.delay.inMicroseconds, greaterThanOrEqualTo(0));
    expect(decision.delay.inMicroseconds, lessThanOrEqualTo(1.second.inMicroseconds));
  });

  test('RetryPolicy.giveUpAfterCumulativeDelay (succeed)', () async {
    int attempts = 0;

    final io = IO
        .delay(() => attempts += 1)
        .flatMap((x) => x > 2 ? IO.pure(x) : IO.raiseError<int>('fail: $x'));

    final retryable = io.retrying(
      RetryPolicy.constantDelay(Duration.zero).giveUpAfterCumulativeDelay(1.second),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => fail('retryable finished with error: $err'),
      (a) {
        expect(a, 3);
        expect(attempts, 3);
      },
    );
  });

  test('RetryPolicy.giveUpAfterCumulativeDelay (fail)', () async {
    int attempts = 0;

    final io = IO.delay(() => attempts += 1).productR(() => IO.raiseError<int>('fail'));

    // zero-limit gives up immediately (0 >= 0)
    final retryable = io.retrying(
      RetryPolicy.constantDelay(Duration.zero).giveUpAfterCumulativeDelay(Duration.zero),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) {
        expect(err, 'Retry giving up.');
        expect(attempts, 1);
      },
      (a) => fail('retryable succeeded'),
    );
  });

  test('alwaysGiveUp', () async {
    final io = IO.raiseError<int>('fail');
    final retryable = io.retrying(RetryPolicy.alwaysGiveUp());
    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => expect(err, 'Retry giving up.'),
      (a) => fail('retryable succeeded'),
    );
  });

  test('limitRetries (succeed)', () async {
    int attempts = 0;

    final io = IO
        .delay(() => attempts += 1)
        .flatMap((x) => x > 3 ? IO.pure(x) : IO.raiseError<int>('attempts: $x'));

    final retryable = io.retrying(
      RetryPolicy.constantDelay(Duration.zero).join(RetryPolicy.limitRetries(3)),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => fail('retryable finished with error: $err'),
      (a) {
        expect(a, 4);
        expect(attempts, 4);
      },
    );
  });

  test('limitRetries (fail)', () async {
    final io = IO.raiseError<int>('fail');

    final retryable = io.retrying(
      RetryPolicy.constantDelay(Duration.zero).join(RetryPolicy.limitRetries(2)),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => expect(err, 'Retry giving up.'),
      (a) => fail('retryable succeeded'),
    );
  });

  test('giveUpAfterDelay (succeed)', () async {
    int attempts = 0;

    final io = IO
        .delay(() => attempts += 1)
        .flatMap((x) => x > 2 ? IO.pure(x) : IO.raiseError<int>('attempts: $x'));

    final retryable = io.retrying(
      RetryPolicy.exponentialBackoff(1.second).giveUpAfterDelay(5.seconds),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => fail('retryable finished with error: $err'),
      (a) {
        expect(a, 3);
        expect(attempts, 3);
      },
    );
  });

  test('isWorthRetrying stops on non-retriable error', () async {
    int attempts = 0;

    final io = IO
        .delay(() => attempts += 1)
        .flatMap((x) => x == 1 ? IO.raiseError<int>('retriable') : IO.raiseError<int>('fatal'));

    final retryable = io.retrying(
      RetryPolicy.limitRetries(10),
      isWorthRetrying: (err) => err != 'fatal',
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) {
        expect(err, 'fatal');
        expect(attempts, 2);
      },
      (a) => fail('retryable succeeded'),
    );
  });

  test('wasSuccessful retries until predicate satisfied, calls onFailure', () async {
    int attempts = 0;
    final failureDetails = <RetryDetails>[];

    final io = IO.delay(() => ++attempts);

    final retryable = io.retrying(
      RetryPolicy.limitRetries(10),
      wasSuccessful: (a) => a >= 3,
      onFailure: (a, details) => IO.exec(() => failureDetails.add(details)),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) => fail('retryable finished with error: $err'),
      (a) {
        expect(a, 3);
        expect(attempts, 3);
        expect(failureDetails.length, 2);
        expect(failureDetails.first.toString(), contains('retriesSoFar'));
      },
    );
  });

  test('onError is called with RetryDetails on each failure', () async {
    final errorDetails = <RetryDetails>[];

    final io = IO.raiseError<int>('err');

    final retryable = io.retrying(
      RetryPolicy.constantDelay(Duration.zero).join(RetryPolicy.limitRetries(2)),
      onError: (err, details) => IO.exec(() => errorDetails.add(details)),
    );

    await retryable.unsafeRunFutureOutcome();

    // onError is called before each retry, but not on the final give-up
    expect(errorDetails.length, 2);
    expect(errorDetails.every((d) => !d.givingUp), isTrue);
    expect(errorDetails.first.toString(), contains('retriesSoFar'));
  });

  test('giveUpAfterDelay (fail)', () async {
    int attempts = 0;

    final io = IO
        .delay(() => attempts += 1)
        .flatMap((x) => x > 4 ? IO.pure(x) : IO.raiseError<int>('attempts: $x'));

    final retryable = io.retrying(
      RetryPolicy.exponentialBackoff(1.second).giveUpAfterDelay(2.seconds).capDelay(3.seconds),
    );

    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err, _) {
        expect(err, 'Retry giving up.');
        expect(attempts, 3);
      },
      (a) => fail('retryable succeeded'),
    );
  });
}
