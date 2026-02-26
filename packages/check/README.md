# ribs_check

`ribs_check` is a powerful property-based testing library for Dart, inspired by [QuickCheck](https://hackage.haskell.org/package/QuickCheck) and [ScalaCheck](https://scalacheck.org/). It allows you to write tests that are more robust and comprehensive than traditional example-based tests by automatically generating a wide range of input data and verifying properties that should hold true for all inputs.

## Key Features

- **Automated Test Case Generation**: Automatically generates random data for your tests, including edge cases.
- **Shrinking**: When a test fails, `ribs_check` attempts to find the smallest possible input that still causes the failure, making debugging significantly easier.
- **Rich Generator Library**: Includes a wide variety of built-in generators for primitive types, collections, and more.
- **Integrated with `package:test`**: Works seamlessly with the standard Dart test runner.
- **Composable Generators**: Easily create complex generators by combining simpler ones using `map`, `flatMap`, and tuple syntax.
- **Repeatable**: All tests use a random seed, so you can reproduce test failures by passing the same seed to the test runner.

## Usage

### Simple Property Test

Use `.forAll` to define a property that should hold for all generated values.

```dart
import 'package:ribs_check/ribs_check.dart';
import 'package:test/test.dart';

void main() {
  Gen.alphaNumString().forAll(
    'concatenated length is sum of lengths',
    (String s) {
      final doubled = s + s;
      expect(doubled.length, equals(s.length * 2));
    },
  );
}
```

### Multiple Generators

Use `.forAll` on a record of `Gen` objects to test properties involving multiple generated values.

```dart
void main() {
  (
    Gen.chooseInt(-100, 100),
    Gen.chooseInt(-100, 100),
  ).forAll(
    'a + b == b + a',
    (int a, int b) {
      expect(a + b, equals(b + a));
    },
  );

  (
    Gen.chooseInt(-100, 100),
    Gen.chooseInt(-100, 100),
    Gen.chooseInt(-100, 100),
  ).forAll(
    '(a + b) + c == a + (b + c)',
    (int a, int b, int c) {
      expect((a + b) + c, equals(a + (b + c)));
    },
  );
}
```

### Composed Generators

Combine generators to create complex data structures.

```dart
final userGen = (
  Gen.alphaNumString(),
  Gen.chooseInt(18, 100),
).tupled.map((t) => User(t.$1, t.$2));

userGen.forAll('all users are adults', (User u) {
  expect(u.age, greaterThanOrEqualTo(18));
});
```

## Documentation

For more detailed information, guides, and API documentation, visit the [Full Ribs Documentation Site](https://cranst0n.github.io/ribs/).

## Example

Check out the full example program in [example/example.dart](example/example.dart).