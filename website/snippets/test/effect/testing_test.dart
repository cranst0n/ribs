// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

// testing-matchers
void matchersTests() {
  // ioSucceeded asserts the IO completes with a value matching the given matcher.
  test('IO succeeds with 42', () {
    expect(IO.pure(42), succeeds(42));
  });

  // ioSucceeded() with no argument only checks that the IO succeeds.
  test('IO succeeds (value unchecked)', () {
    expect(IO.print('hello'), succeeds());
  });

  // ioErrored asserts the IO raises an error.
  test('IO fails with expected error', () {
    expect(IO.raiseError<int>('boom'), errors('boom'));
  });

  // ioErrored() with no argument only checks that the IO errored.
  test('IO fails (error unchecked)', () {
    expect(IO.raiseError<int>(Exception('oops')), errors());
  });

  // ioCanceled asserts the IO was canceled before completing.
  test('IO is canceled', () {
    expect(IO.canceled, cancels);
  });
}
// testing-matchers

// testing-matchers-advanced
void advancedMatchersTests() {
  // ioSucceeded accepts *any* standard test Matcher for the value.
  test('result satisfies a condition', () {
    expect(IO.pure(ilist([1, 2, 3])).map((xs) => xs.length), succeeds(greaterThan(2)));
  });

  test('result is the right type', () {
    expect(IO.pure(42).map((n) => n.toString()), succeeds(isA<String>()));
  });

  // ioErrored also accepts a matcher for the raised error.
  test('error message contains keyword', () {
    final io = IO.raiseError<Unit>('connection refused: timeout');
    expect(io, errors(contains('timeout')));
  });
}
// testing-matchers-advanced

// testing-ticker
void tickerTests() {
  // .ticked wraps an IO in a Ticker backed by a deterministic virtual clock.
  // nonTerminating() fast-forwards all pending timers and returns true if
  // the IO has still not completed — useful for asserting deadlocks.
  test('IO waiting on an unset Deferred never terminates', () {
    final d = Deferred.unsafe<int>();
    expect(d.value().ticked.nonTerminating(), isTrue);
  });

  // tickAll() advances through every scheduled sleep without waiting real time.
  // The IO below would take 10 hours on a real clock; with Ticker it is instant.
  test('IO.sleep fast-forwards with tickAll', () async {
    final ticker = IO.sleep(10.hours).productR(IO.pure('woke up')).ticked..tickAll();

    await expectLater(ticker.outcome, completion(Outcome.succeeded('woke up')));
  });
}
// testing-ticker

// testing-ticker-realworld
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
  test('pollUntil retries until state is ready', () async {
    int attempts = 0;

    // Simulated external check: returns None for the first 4 calls, then Some.
    final mockCheck = IO.delay(() {
      attempts++;
      return attempts >= 5 ? Some(attempts) : none<int>();
    });

    // Without Ticker, this would sleep for 4 seconds.
    // With Ticker, tickAll() advances all virtual sleeps instantaneously.
    final ticker = pollUntil(mockCheck).ticked..tickAll();

    await expectLater(ticker.outcome, completion(Outcome.succeeded(5)));
    expect(attempts, 5);
  });
}
// testing-ticker-realworld

void main() {
  group('IO matchers', matchersTests);
  group('advanced matchers', advancedMatchersTests);
  group('Ticker', tickerTests);
  group('Ticker real-world', realWorldTickerTest);
}
