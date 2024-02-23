import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Current status of a retry strategy. Accumulates efforts so far to retry
/// a failed [IO].
final class RetryStatus {
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
      RetryStatus(retriesSoFar + 1, cumulativeDelay + delay, Some(delay));

  @override
  String toString() =>
      'RetryStatus(retriesSoFar: $retriesSoFar, cumulativeDelay: $cumulativeDelay, previousDelay: $previousDelay)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetryStatus &&
          other.retriesSoFar == retriesSoFar &&
          other.cumulativeDelay == cumulativeDelay &&
          other.previousDelay == previousDelay);

  @override
  int get hashCode => Object.hash(retriesSoFar, cumulativeDelay, previousDelay);
}

/// Rendered decision on whether or not to retry an [IO] based on the
/// [RetryPolicy].
sealed class RetryDecision {
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
      Some(delay).filter((_) => !isGivingUp),
    );
  }

  RetryStatus _updateStatus(RetryStatus status) =>
      isGivingUp ? status : status.retryAfter(delay);
}

final class _GiveUp extends RetryDecision {
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
  int get hashCode => 0;
}

final class _DelayAndRetry extends RetryDecision {
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

/// Policy that will render decisions on whether or not to attempt to retry a
/// failed [IO].
class RetryPolicy {
  /// Function that that will render a decision on the given [RetryStatus].
  final Function1<RetryStatus, RetryDecision> decideOn;

  RetryPolicy(this.decideOn);

  /// Creates a new policy that will alway decide to give up.
  factory RetryPolicy.alwaysGiveUp() =>
      RetryPolicy((_) => RetryDecision.giveUp());

  /// Creates a new policy that will decide to retry an operation until
  /// [maxRetries] attempts have already been made, then deciding to give up.
  factory RetryPolicy.limitRetries(int maxRetries) => RetryPolicy((status) {
        if (status.retriesSoFar >= maxRetries) {
          return RetryDecision.giveUp();
        } else {
          return RetryDecision.delayAndRetry(Duration.zero);
        }
      });

  /// Creates a new policy that will always decide to retry an operation after
  /// waiting for the given [Duration].
  factory RetryPolicy.constantDelay(Duration delay) =>
      RetryPolicy((status) => RetryDecision.delayAndRetry(delay));

  /// Creates a new policy that will always decide to retry an operation,
  /// while increasing the delay between attempts exponentially, starting with
  /// a delay of [baseDelay].
  factory RetryPolicy.exponentialBackoff(Duration baseDelay) =>
      RetryPolicy((status) => RetryDecision.delayAndRetry(
          _safeMultiply(baseDelay, BigInt.from(2).pow(status.retriesSoFar))));

  /// Creates a new policy that will always decide to retry an operation using
  /// the [algorithm described here](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/)
  /// to determine the delay between each retry.
  factory RetryPolicy.fullJitter(Duration baseDelay) => RetryPolicy((status) {
        final maxDelay =
            _safeMultiply(baseDelay, BigInt.from(2).pow(status.retriesSoFar));
        return RetryDecision.delayAndRetry(maxDelay * Random().nextDouble());
      });

  static Duration _safeMultiply(Duration duration, BigInt factor) {
    final micros = BigInt.from(duration.inMicroseconds) * factor;

    return Duration(
      microseconds: micros.isValidInt ? micros.toInt() : Integer.MaxValue,
    );
  }

  /// Limit the delay between any 2 retry attempts to [maxDelay].
  RetryPolicy capDelay(Duration maxDelay) =>
      mapDelay((d) => d > maxDelay ? maxDelay : d);

  /// Limits the amount of delay between any 2 retry attempts to [previousDelay]
  /// before deciding to give up.
  RetryPolicy giveUpAfterDelay(Duration previousDelay) =>
      RetryPolicy((status) =>
          status.previousDelay.getOrElse(() => Duration.zero) >= previousDelay
              ? RetryDecision.giveUp()
              : decideOn(status));

  /// Limits the total amount of delay during retry(s) that this policy will
  /// allow before deciding to give up.
  RetryPolicy giveUpAfterCumulativeDelay(Duration cumulativeDelay) =>
      RetryPolicy((status) => status.cumulativeDelay >= cumulativeDelay
          ? RetryDecision.giveUp()
          : decideOn(status));

  /// Combine this policy with another policy, giving up if this policy wants
  /// to, and if not, following the decision of the other policy.
  RetryPolicy followedBy(RetryPolicy policy) => RetryPolicy((status) {
        final thisDecision = decideOn(status);

        return thisDecision.isGivingUp ? thisDecision : policy.decideOn(status);
      });

  /// Combine this policy with another policy, giving up when either of the
  /// policies want to give up and choosing the maximum of the two delays when
  /// both of the schedules want to delay the next retry. The opposite of the
  /// `meet` operation.
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

  /// Combine this policy with another policy, giving up when both of the
  /// policies want to give up and choosing the minimum of the two delays when
  /// both of the schedules want to delay the next retry. The opposite of the
  /// `join` operation.
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

  /// Applies [f] to the delay of any decision to eventually retry an
  /// operation.
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

/// Current and cumulative retry information provided in the event of a failure.
final class RetryDetails {
  /// Retry attempts so far.
  final int retriesSoFar;

  /// Cumulative delay taken so far between all attempts.
  final Duration cumulativeDelay;

  /// Indicates if the current retry iteration is giving up.
  final bool givingUp;

  /// The delay before the next retry attempt, if any.
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

/// Extension provides the hook into retry capabilities for [IO].
extension RetryOps<A> on IO<A> {
  /// Applies the given [policy] to this [IO] and will attempt to retry any
  /// failed attempts according to the policy.
  ///
  /// [wasSuccessful] can be provided to further filter any successful
  /// evalations with undesirable results, so they may be retried.
  ///
  /// [isWorthRetrying] can be provided to short-circuit any attempt to retry
  /// if some kind of error is encountered that may eliminate any need to retry.
  ///
  /// [onError] can be provided to perform the given side-effect for each
  /// error eencounted.
  ///
  /// [onFailure] can be provided in conjunction with [wasSuccessful] to
  /// perform the given side-effect when a successful evaluation fails to
  /// satisfy the [wasSuccessful] predicate.
  IO<A> retrying(
    RetryPolicy policy, {
    Function1<A, bool>? wasSuccessful,
    Function1<RuntimeException, bool>? isWorthRetrying,
    Function2<RuntimeException, RetryDetails, IO<Unit>>? onError,
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
    Function1<RuntimeException, bool> isWorthRetrying,
    Function2<RuntimeException, RetryDetails, IO<Unit>> onError,
    Function2<A, RetryDetails, IO<Unit>> onFailure,
    RetryStatus status,
    IO<A> action,
  ) {
    return action.attempt().flatMap((result) {
      return result.fold(
        (err) => isWorthRetrying(err)
            ? _onFailureOrError(policy, wasSuccessful, isWorthRetrying, onError,
                onFailure, status, action, (details) => onError(err, details))
            : IO.raiseError(RuntimeException(err.toString())),
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
    Function1<RuntimeException, bool> isWorthRetrying,
    Function2<RuntimeException, RetryDetails, IO<Unit>> onError,
    Function2<A, RetryDetails, IO<Unit>> onFailure,
    RetryStatus status,
    IO<A> action,
    Function1<RetryDetails, IO<Unit>> beforeRecurse,
  ) {
    final decision = policy.decideOn(status);
    final newStatus = decision._updateStatus(status);
    final details = decision._detailsFromStatus(newStatus);

    return IO.pure(decision.isGivingUp).ifM(
          () => IO.raiseError(RuntimeException('Retry giving up.')),
          () => beforeRecurse(details)
              .productR(() => IO.sleep(decision.delay))
              .productR(() => _retryingImpl(policy, wasSuccessful,
                  isWorthRetrying, onError, onFailure, newStatus, action)),
        );
  }
}
