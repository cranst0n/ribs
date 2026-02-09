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
  });

  test('alwaysGiveUp', () async {
    final io = IO.raiseError<int>('fail');
    final retryable = io.retrying(RetryPolicy.alwaysGiveUp());
    final result = await retryable.unsafeRunFutureOutcome();

    result.fold(
      () => fail('retryable was canceled'),
      (err) => expect(err, 'Retry giving up.'),
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
      (err) => fail('retryable finished with error: $err'),
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
      (err) => expect(err, 'Retry giving up.'),
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
      (err) => fail('retryable finished with error: $err'),
      (a) {
        expect(a, 3);
        expect(attempts, 3);
      },
    );
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
      (err) {
        expect(err, 'Retry giving up.');
        expect(attempts, 3);
      },
      (a) => fail('retryable succeeded'),
    );
  });
}
