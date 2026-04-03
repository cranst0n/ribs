// ignore: implementation_imports
import 'package:matcher/src/expect/async_matcher.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:test/test.dart';

/// A matcher that asserts an [IO] completes successfully.
///
/// If [matcher] is provided, the successful value is further validated
/// against it. Can be used with both raw [IO] values and [Ticker] instances.
Matcher succeeds([Object? matcher]) => _Succeeded(matcher ?? anyOf(isNotNull, isNull));

/// A matcher that asserts an [IO] completes with an error.
///
/// If [matcher] is provided, the error value is further validated against it.
Matcher errors([Object? matcher]) => _Errored(matcher ?? anyOf(isNotNull, isNull));

/// A matcher that asserts an [IO] is canceled before completion.
const Matcher cancels = _Canceled();

/// A matcher that asserts an [IO] terminates (completes in finite time)
/// when evaluated with a [TestIORuntime].
const Matcher terminates = _Terminates(true);

/// A matcher that asserts an [IO] does **not** terminate (runs forever)
/// when evaluated with a [TestIORuntime].
const Matcher nonTerminating = _Terminates(false);

/// Lifts a test expectation into [IO], allowing assertions to be composed
/// within an [IO] program.
///
/// Equivalent to calling `expectLater` and wrapping it in [IO.fromFutureF].
IO<Unit> expectIO(
  dynamic actual,
  dynamic matcher, {
  String? reason,
  Object? skip,
}) => IO.fromFutureF(() => expectLater(actual, matcher, reason: reason, skip: skip)).voided();

class _Succeeded extends AsyncMatcher {
  final Object _matcher;

  const _Succeeded(this._matcher);

  @override
  Description describe(Description description) => description.add('succeeds');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is IO) {
      return matchFutureOutcome(item.unsafeRunFutureOutcome());
    } else if (item is Ticker) {
      item.tickAll();
      return matchFutureOutcome(item.outcome);
    } else {
      return 'was not an IO';
    }
  }

  dynamic matchFutureOutcome(Future<Outcome<dynamic>> fut) {
    return fut.then((outcome) {
      return outcome.fold(
        () => fail('IO did not succeed, but canceled'),
        (err, _) => fail('IO did not succeed, but errored: $err'),
        (a) => expect(a, _matcher),
      );
    });
  }
}

class _Errored extends AsyncMatcher {
  final Object _matcher;

  const _Errored(this._matcher);

  @override
  Description describe(Description description) => description.add('errors');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is IO) {
      return matchFutureOutcome(item.unsafeRunFutureOutcome());
    } else if (item is Ticker) {
      item.tickAll();
      return matchFutureOutcome(item.outcome);
    } else {
      return 'was not an IO';
    }
  }

  dynamic matchFutureOutcome(Future<Outcome<dynamic>> fut) {
    return fut.then((outcome) {
      return outcome.fold(
        () => fail('IO did not error, but canceled'),
        (err, _) => expect(err, _matcher),
        (a) => fail('IO did not error, but succeeded as: $a'),
      );
    });
  }
}

class _Canceled extends AsyncMatcher {
  const _Canceled();

  @override
  Description describe(Description description) => description.add('cancels');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is IO) {
      return matchFutureOutcome(item.unsafeRunFutureOutcome());
    } else if (item is Ticker) {
      item.tickAll();
      return matchFutureOutcome(item.outcome);
    } else {
      return 'was not an IO';
    }
  }

  dynamic matchFutureOutcome(Future<Outcome<dynamic>> fut) {
    return fut.then((outcome) {
      return outcome.fold(
        () => expect(0, 0),
        (err, _) => fail('IO was not canceled, but errored: $err'),
        (a) => fail('IO was not canceled, but succeeded as: $a'),
      );
    });
  }
}

class _Terminates extends Matcher {
  final bool shouldTerminate;

  const _Terminates(this.shouldTerminate);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is IO) {
      return item.ticked.nonTerminating() != shouldTerminate;
    } else if (item is Ticker) {
      return item.nonTerminating() != shouldTerminate;
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) =>
      description.add(shouldTerminate ? 'terminates' : 'does not terminate');
}
