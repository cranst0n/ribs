// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

// #region testing-matchers
void matchersTests() {
  // succeeds asserts the IO completes with a value matching the given matcher.
  test('IO succeeds with 42', () {
    expect(IO.pure(42), succeeds(42));
  });

  // succeeds() with no argument only checks that the IO succeeds.
  test('IO succeeds (value unchecked)', () {
    expect(IO.print('hello'), succeeds());
  });

  // errors asserts the IO raises an error.
  test('IO fails with expected error', () {
    expect(IO.raiseError<int>('boom'), errors('boom'));
  });

  // errors() with no argument only checks that the IO errored.
  test('IO fails (error unchecked)', () {
    expect(IO.raiseError<int>(Exception('oops')), errors());
  });

  // cancels asserts the IO was canceled before completing.
  test('IO is canceled', () {
    expect(IO.canceled, cancels);
  });
}
// #endregion testing-matchers

// #region testing-matchers-advanced
void advancedMatchersTests() {
  // succeeds accepts *any* standard test Matcher for the value.
  test('result satisfies a condition', () {
    expect(IO.pure(ilist([1, 2, 3])).map((xs) => xs.length), succeeds(greaterThan(2)));
  });

  test('result is the right type', () {
    expect(IO.pure(42).map((n) => n.toString()), succeeds(isA<String>()));
  });

  // errors also accepts a matcher for the raised error.
  test('error message contains keyword', () {
    final io = IO.raiseError<Unit>('connection refused: timeout');
    expect(io, errors(contains('timeout')));
  });
}
// #endregion testing-matchers-advanced

// #region testing-ticker
void tickerTests() {
  // Pass io.ticked directly to any matcher — the matcher calls tickAll()
  // automatically, so virtual time advances and the test completes instantly.
  test('IO.sleep fast-forwards with ticked', () {
    expect(IO.sleep(10.hours).productR(IO.pure('woke up')).ticked, succeeds('woke up'));
  });

  // You can also use timed() to assert how much virtual time elapsed.
  test('IO.sleep takes the right virtual duration', () {
    expect(IO.sleep(3.seconds).timed().map((t) => t.$1).ticked, succeeds(3.seconds));
  });

  // The nonTerminating matcher accepts IO or Ticker directly.
  // It fast-forwards all pending timers and asserts the IO has not completed.
  test('IO waiting on an unset Deferred never terminates', () {
    final d = Deferred.unsafe<int>();
    expect(d.value(), nonTerminating);
  });

  // terminates asserts the IO eventually completes (succeeds, errors, or cancels).
  test('IO.sleep eventually terminates', () {
    expect(IO.sleep(1.second), terminates);
  });
}
// #endregion testing-ticker

// #region testing-ticker-realworld
/// Polls [check] repeatedly, sleeping [interval] between attempts, until it
/// returns [Some]. This is a typical pattern for waiting on external state.
IO<A> pollUntil<A>(IO<Option<A>> check, {Duration interval = const Duration(seconds: 1)}) =>
    check.flatMap(
      (result) => result.fold(
        () => IO.sleep(interval).productR(pollUntil(check, interval: interval)),
        IO.pure,
      ),
    );

void realWorldTickerTest() {
  test('pollUntil retries until state is ready', () {
    int attempts = 0;

    // Simulated external check: returns None for the first 4 calls, then Some.
    final mockCheck = IO.delay(() {
      attempts++;
      return attempts >= 5 ? Some(attempts) : none<int>();
    });

    // Without Ticker, this would sleep for 4 seconds.
    // Passing .ticked to succeeds() advances all virtual sleeps instantaneously.
    expect(pollUntil(mockCheck).ticked, succeeds(5));
    expect(attempts, 5);
  });
}
// #endregion testing-ticker-realworld

void main() {
  group('IO matchers', matchersTests);
  group('advanced matchers', advancedMatchersTests);
  group('Ticker', tickerTests);
  group('Ticker real-world', realWorldTickerTest);
}
