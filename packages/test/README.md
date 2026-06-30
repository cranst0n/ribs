# ribs_test

Test utilities and custom matchers for the [ribs](https://cranst0n.github.io/ribs/) functional programming framework. Provides `package:test`-compatible matchers for `Option`, `Either`, `Validated`, `IO`, and `Rill`, plus a deterministic `TestIORuntime` for time-controlled `IO` tests.

## Installation

Add to your `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  ribs_test: ^1.0.0
  test: ^1.0.0
```

## Imports

| Import | Covers |
|---|---|
| `package:ribs_test/ribs_test.dart` | Everything (core + effect + rill) |
| `package:ribs_test/ribs_test_core.dart` | `Option`, `Either`, `Validated` matchers |
| `package:ribs_test/ribs_test_effect.dart` | `IO` matchers + `TestIORuntime` |
| `package:ribs_test/ribs_test_rill.dart` | `Rill` stream matchers |

## Core matchers

Matchers for `ribs_core` algebraic data types.

```dart
import 'package:ribs_test/ribs_test_core.dart';
import 'package:test/test.dart';

test('Option matchers', () {
  expect(Some(42), isSome(42));
  expect(none<int>(), isNone());
  expect(Option('hello'), isSome(isA<String>()));
});

test('Either matchers', () {
  expect(Either.right(1), isRight(1));
  expect(Either.left('oops'), isLeft('oops'));
  expect(Either.left('oops'), isLeft(isA<String>()));
});

test('Validated matchers', () {
  expect(42.validNel<String>(), isValidNel(42));
  expect('bad input'.invalidNel<int>(), isInvalid());
});
```

## IO matchers

Matchers for asserting on the outcome of `IO` programs.

```dart
import 'package:ribs_test/ribs_test_effect.dart';
import 'package:test/test.dart';

test('IO succeeds', () {
  expect(IO.pure(42), succeeds(42));
});

test('IO fails', () {
  expect(IO.raiseError(Exception('boom')), errors(isA<Exception>()));
});

test('IO is canceled', () {
  expect(IO.canceled, cancels);
});
```

### TestIORuntime and Ticker

`TestIORuntime` replaces the real clock with a deterministic one so you can
test `IO.sleep`, timeouts, and retry delays without waiting for real time to
pass. Use the `ticked` extension or the `terminates` / `nonTerminating`
matchers for synchronous assertions:

```dart
import 'package:ribs_test/ribs_test_effect.dart';
import 'package:test/test.dart';

test('sleep does not block under test clock', () async {
  final io = IO.sleep(const Duration(hours: 1)).as(42);
  final ticker = io.ticked;

  // Advance the test clock — no real waiting required.
  ticker.advanceAndTick(const Duration(hours: 1));

  expect(ticker, succeeds(42));
});

test('IO.never does not terminate', () {
  expect(IO.never<int>(), nonTerminating);
});
```

## Rill stream matchers

Matchers for asserting on the elements emitted by a `Rill` stream.

```dart
import 'package:ribs_test/ribs_test_rill.dart';
import 'package:test/test.dart';

test('exact ordered output', () {
  expect(Rill.emits([1, 2, 3]), producesInOrder([1, 2, 3]));
});

test('single element', () {
  expect(Rill.emit(42), producesOnly(42));
});

test('empty stream', () {
  expect(Rill.empty<int>(), producesNothing());
});

test('unordered output', () {
  expect(Rill.emits([3, 1, 2]), producesUnordered([1, 2, 3]));
});

test('stream error', () {
  expect(Rill.raiseError<int>('oops'), producesError(isA<String>()));
});
```
