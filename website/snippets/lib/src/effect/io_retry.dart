// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_json/ribs_json.dart';

// flaky-op
IO<Json> flakyOp() => IO.delay(() => HttpClient()).bracket(
      (client) => IO
          .fromFutureF(() =>
              client.getUrl(Uri.parse('http://api.flaky.org/account/123')))
          .flatMap((req) => IO.fromFutureF(() => req.close()))
          .flatMap((resp) => IO.fromFutureF(() => utf8.decodeStream(resp)))
          .flatMap((bodyText) => IO.fromEither(Json.parse(bodyText))),
      (client) => IO.exec(() => client.close()),
    );
// flaky-op

void retrySimple() {
  // retry-simple
  final IO<Json> retry3Times = flakyOp().retrying(RetryPolicy.limitRetries(3));
  // retry-simple

  // custom-retrying
  final IO<Json> customRetry = flakyOp().retrying(
    RetryPolicy.constantDelay(5.seconds),
    wasSuccessful: (json) => json.isObject,
    isWorthRetrying: (error) => error.message.toString().contains('oops'),
    onError: (error, details) => IO.println('Attempt ${details.retriesSoFar}.'),
    onFailure: (json, details) => IO.println('$json failed [$details]'),
  );
  // custom-retrying
}

void customPolicies() {
  // custom-policy-1
  // Exponential backoff with a maximum delay or 20 seconds
  flakyOp().retrying(
    RetryPolicy.exponentialBackoff(1.second).capDelay(20.seconds),
  );

  // Jitter backoff that will stop any retries after 1 minute
  flakyOp().retrying(
    RetryPolicy.fullJitter(2.seconds).giveUpAfterCumulativeDelay(1.minute),
  );

  // Retry every 2 seconds, giving up after 10 seconds, but then retry
  // an additional 5 times
  flakyOp().retrying(RetryPolicy.constantDelay(2.seconds)
      .giveUpAfterCumulativeDelay(10.seconds)
      .followedBy(RetryPolicy.limitRetries(5)));
  // custom-policy-1

  // custom-policy-2
  // Join 2 policies, where retry is stopped when *either* policy wants to
  // and the maximum delay is chosen between the two policies
  flakyOp().retrying(
    RetryPolicy.exponentialBackoff(1.second)
        .giveUpAfterDelay(10.seconds)
        .join(RetryPolicy.limitRetries(10)),
  );

  // Meet results in a policy that will retry until *both* policies want to
  // give up and the minimum delay is chosen between the two policies
  flakyOp().retrying(
    RetryPolicy.exponentialBackoff(1.second)
        .giveUpAfterDelay(10.seconds)
        .meet(RetryPolicy.limitRetries(10)),
  );
  // custom-policy-2
}
