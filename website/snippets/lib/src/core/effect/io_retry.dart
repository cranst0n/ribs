// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// flaky-op
IO<Json> flakyOp() => IO.pure(HttpClient()).bracket(
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
    RetryPolicy.constantDelay(const Duration(seconds: 5)),
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
    RetryPolicy.exponentialBackoff(const Duration(seconds: 1))
        .capDelay(const Duration(seconds: 20)),
  );

  // Jitter backoff that will stop any retries after 1 minute
  flakyOp().retrying(
    RetryPolicy.fullJitter(const Duration(seconds: 2))
        .giveUpAfterCumulativeDelay(const Duration(minutes: 1)),
  );

  // Retry every 2 seconds, giving up after 10 seconds, but then retry
  // an additional 5 times
  flakyOp().retrying(RetryPolicy.constantDelay(const Duration(seconds: 2))
      .giveUpAfterCumulativeDelay(const Duration(seconds: 10))
      .followedBy(RetryPolicy.limitRetries(5)));
  // custom-policy-1

  // custom-policy-2
  // Join 2 policies, where retry is stopped when *either* policy wants to
  // and the maximum delay is chosen between the two policies
  flakyOp().retrying(
    RetryPolicy.exponentialBackoff(const Duration(seconds: 1))
        .giveUpAfterDelay(const Duration(seconds: 10))
        .join(RetryPolicy.limitRetries(10)),
  );

  // Meet results in a policy that will retry until *both* policies want to
  // give up and the minimum delay is chosen between the two policies
  flakyOp().retrying(
    RetryPolicy.exponentialBackoff(const Duration(seconds: 1))
        .giveUpAfterDelay(const Duration(seconds: 10))
        .meet(RetryPolicy.limitRetries(10)),
  );
  // custom-policy-2
}
