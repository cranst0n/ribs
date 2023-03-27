import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// Mostly complete port of cats-retry.

class RetryStatus {
  /// Retries attempted thus far.
  final int retriesSoFar;

  /// Total delay between successive retries.
  final Duration cumulativeDelay;

  /// Delay taken before attempting the previous retry.
  final Option<Duration> previousDelay;

  const RetryStatus(
    this.retriesSoFar,
    this.cumulativeDelay,
    this.previousDelay,
  );

  /// Create initial status used when running first task attempt.
  factory RetryStatus.initial() => RetryStatus(0, Duration.zero, none());

  /// Create new status that indicates an additional retry was taken after
  /// the given delay.
  RetryStatus retryAfter(Duration delay) =>
      RetryStatus(retriesSoFar + 1, cumulativeDelay + delay, delay.some);
}

abstract class RetryDecision {
  const RetryDecision._();

  /// Indicates if this decision is to give up retrying.
  bool get isGivingUp;

  /// Delay to take before the next retry.
  Duration get delay;

  /// Create a decision to give up and stop retrying.
  factory RetryDecision.giveUp() => _GiveUp();

  /// Create a decision to retry the task after the provided delay.
  factory RetryDecision.delayAndRetry(Duration delay) =>
      _DelayAndRetry._(delay);

  /// Builds [RetryDetails] from the given status.
  RetryDetails _detailsFromStatus(RetryStatus status) {
    return RetryDetails(
      status.retriesSoFar + (isGivingUp ? 0 : 1),
      status.cumulativeDelay + delay,
      isGivingUp,
      delay.some.filter((_) => !isGivingUp),
    );
  }

  RetryStatus _updateStatus(RetryStatus status) =>
      isGivingUp ? status : status.retryAfter(delay);
}

class _GiveUp extends RetryDecision {
  static const _GiveUp _singleton = _GiveUp._();

  factory _GiveUp() => _singleton;

  const _GiveUp._() : super._();

  @override
  bool get isGivingUp => true;

  @override
  Duration get delay => Duration.zero;

  @override
  String toString() => 'RetryDecision.GiveUp';

  @override
  bool operator ==(Object other) => identical(this, other) || other is _GiveUp;

  @override
  int get hashCode => _singleton.hashCode;
}

class _DelayAndRetry extends RetryDecision {
  @override
  final Duration delay;

  const _DelayAndRetry._(this.delay) : super._();

  @override
  bool get isGivingUp => false;

  @override
  String toString() => 'RetryDecision.DelayAndRetry($delay)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _DelayAndRetry && other.delay == delay);

  @override
  int get hashCode => delay.hashCode;
}

class RetryPolicy {
  final Function1<RetryStatus, RetryDecision> decideOn;

  RetryPolicy(this.decideOn);

  factory RetryPolicy.alwaysGiveUp() =>
      RetryPolicy((_) => RetryDecision.giveUp());

  factory RetryPolicy.limitRetries(int maxRetries) => RetryPolicy((status) {
        if (status.retriesSoFar >= maxRetries) {
          return RetryDecision.giveUp();
        } else {
          return RetryDecision.delayAndRetry(Duration.zero);
        }
      });

  factory RetryPolicy.constantDelay(Duration delay) =>
      RetryPolicy((status) => RetryDecision.delayAndRetry(delay));

  factory RetryPolicy.exponentialBackoff(Duration baseDelay) =>
      RetryPolicy((status) => RetryDecision.delayAndRetry(
          _safeMultiply(baseDelay, BigInt.from(2).pow(status.retriesSoFar))));

  /// See https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
  factory RetryPolicy.fullJitter(Duration baseDelay) => RetryPolicy((status) {
        final maxDelay =
            _safeMultiply(baseDelay, BigInt.from(2).pow(status.retriesSoFar));
        return RetryDecision.delayAndRetry(maxDelay * Random().nextDouble());
      });

  static Duration _safeMultiply(Duration duration, BigInt factor) {
    final micros = BigInt.from(duration.inMicroseconds) * factor;

    return Duration(
      microseconds: micros.isValidInt ? micros.toInt() : 9223372036854775807,
    );
  }

  RetryPolicy capDelay(Duration maxDelay) =>
      mapDelay((d) => d > maxDelay ? maxDelay : d);

  RetryPolicy giveUpAfterDelay(Duration cumulativeDelay) =>
      RetryPolicy((status) =>
          status.previousDelay.getOrElse(() => Duration.zero) >= cumulativeDelay
              ? RetryDecision.giveUp()
              : decideOn(status));

  RetryPolicy giveUpAfterCumulativeDelay(Duration cumulativeDelay) =>
      RetryPolicy((status) => status.cumulativeDelay >= cumulativeDelay
          ? RetryDecision.giveUp()
          : decideOn(status));

  RetryPolicy followedBy(RetryPolicy policy) => RetryPolicy((status) {
        final thisDecision = decideOn(status);

        return thisDecision.isGivingUp ? thisDecision : policy.decideOn(status);
      });

  RetryPolicy join(RetryPolicy policy) => RetryPolicy((status) {
        final thisDecision = decideOn(status);
        final thatDecision = policy.decideOn(status);

        if (thisDecision.isGivingUp || thatDecision.isGivingUp) {
          return RetryDecision.giveUp();
        } else {
          return RetryDecision.delayAndRetry(
            Duration(
              microseconds: max(
                thisDecision.delay.inMicroseconds,
                thatDecision.delay.inMicroseconds,
              ),
            ),
          );
        }
      });

  RetryPolicy meet(RetryPolicy policy) => RetryPolicy((status) {
        final thisDecision = decideOn(status);
        final thatDecision = policy.decideOn(status);

        if (!thisDecision.isGivingUp && !thatDecision.isGivingUp) {
          return RetryDecision.delayAndRetry(
            Duration(
              microseconds: min(
                thisDecision.delay.inMicroseconds,
                thatDecision.delay.inMicroseconds,
              ),
            ),
          );
        } else if (thisDecision.isGivingUp) {
          return thatDecision;
        } else if (thatDecision.isGivingUp) {
          return thisDecision;
        } else {
          return RetryDecision.giveUp();
        }
      });

  RetryPolicy mapDelay(Function1<Duration, Duration> f) => RetryPolicy(
        (status) {
          final decision = decideOn(status);

          if (decision.isGivingUp) {
            return RetryDecision.giveUp();
          } else {
            return RetryDecision.delayAndRetry(f(decision.delay));
          }
        },
      );
}

class RetryDetails {
  final int retriesSoFar;
  final Duration cumulativeDelay;
  final bool givingUp;
  final Option<Duration> upcomingDelay;

  RetryDetails(
    this.retriesSoFar,
    this.cumulativeDelay,
    this.givingUp,
    this.upcomingDelay,
  );

  @override
  String toString() => 'RetryDetails('
      'retriesSoFar = $retriesSoFar, '
      'cumulativeDelay = $cumulativeDelay, '
      'givingUp = $givingUp, '
      'upcomingDelay = $upcomingDelay)';
}

extension RetryOps<A> on IO<A> {
  IO<A> retrying(
    RetryPolicy policy, {
    Function1<A, bool>? wasSuccessful,
    Function1<Object, bool>? isWorthRetrying,
    Function2<Object, RetryDetails, IO<Unit>>? onError,
    Function2<A, RetryDetails, IO<Unit>>? onFailure,
  }) =>
      _retryingImpl(
        policy,
        wasSuccessful ?? (_) => true,
        isWorthRetrying ?? (_) => true,
        onError ?? (_, __) => IO.unit,
        onFailure ?? (_, __) => IO.unit,
        RetryStatus.initial(),
        this,
      );

  IO<A> _retryingImpl(
    RetryPolicy policy,
    Function1<A, bool> wasSuccessful,
    Function1<Object, bool> isWorthRetrying,
    Function2<Object, RetryDetails, IO<Unit>> onError,
    Function2<A, RetryDetails, IO<Unit>> onFailure,
    RetryStatus status,
    IO<A> action,
  ) {
    return action.attempt().flatMap((result) {
      return result.fold(
        (err) => isWorthRetrying(err)
            ? _onFailureOrError(policy, wasSuccessful, isWorthRetrying, onError,
                onFailure, status, action, (details) => onError(err, details))
            : IO.raiseError(err.toString()),
        (a) => wasSuccessful(a)
            ? IO.pure(a)
            : _onFailureOrError(policy, wasSuccessful, isWorthRetrying, onError,
                onFailure, status, action, (details) => onFailure(a, details)),
      );
    });
  }

  IO<A> _onFailureOrError(
    RetryPolicy policy,
    Function1<A, bool> wasSuccessful,
    Function1<Object, bool> isWorthRetrying,
    Function2<Object, RetryDetails, IO<Unit>> onError,
    Function2<A, RetryDetails, IO<Unit>> onFailure,
    RetryStatus status,
    IO<A> action,
    Function1<RetryDetails, IO<Unit>> beforeRecurse,
  ) {
    final decision = policy.decideOn(status);
    final newStatus = decision._updateStatus(status);
    final details = decision._detailsFromStatus(newStatus);

    return IO.pure(decision.isGivingUp).ifM(
          () => IO.raiseError('Retry giving up.'),
          () => beforeRecurse(details)
              .productR(() => IO.sleep(decision.delay))
              .productR(() => _retryingImpl(policy, wasSuccessful,
                  isWorthRetrying, onError, onFailure, newStatus, action)),
        );
  }
}
