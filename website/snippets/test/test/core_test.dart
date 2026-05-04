// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_test/ribs_test_core.dart';
import 'package:test/test.dart';

// #region testing-core-option
void optionTests() {
  // isSome asserts the value is Some; the optional argument checks the contained value.
  test('Some with value', () {
    expect(const Some(42), isSome(42));
    expect(const Some('hi'), isSome());
    expect(none<int>(), isNot(isSome()));
  });

  // isNone asserts the value is None.
  test('None', () {
    expect(none<int>(), isNone());
    expect(const Some(1), isNot(isNone()));
  });
}
// #endregion testing-core-option

// #region testing-core-either
void eitherTests() {
  // isLeft asserts the Either is a Left; optionally checks the contained value.
  test('Left', () {
    expect('error'.asLeft<int>(), isLeft('error'));
    expect('error'.asLeft<int>(), isLeft());
    expect(42.asRight<String>(), isNot(isLeft()));
  });

  // isRight asserts the Either is a Right; accepts any nested matcher.
  test('Right', () {
    expect(42.asRight<String>(), isRight(42));
    expect(42.asRight<String>(), isRight(greaterThan(40)));
    expect('err'.asLeft<int>(), isNot(isRight()));
  });
}
// #endregion testing-core-either

// #region testing-core-validated
void validatedTests() {
  // isValid asserts a Valid value, optionally checking the contained value.
  test('Valid', () {
    expect(Validated.valid<String, int>(42), isValid(42));
    expect(Validated.valid<String, String>('ok'), isValid());
    expect(Validated.invalid<String, int>('e'), isNot(isValid()));
  });

  // isValidNel is an alias for isValid; use it with ValidatedNel to clarify intent.
  test('ValidNel', () {
    expect(Validated.validNel<String, int>(42), isValidNel(42));
  });

  // isInvalid asserts an Invalid value, optionally inspecting the error.
  test('Invalid', () {
    expect(Validated.invalid<String, int>('oops'), isInvalid('oops'));
    expect(Validated.invalidNel<String, int>('a'), isInvalid());
    expect(Validated.valid<String, int>(1), isNot(isInvalid()));
  });
}
// #endregion testing-core-validated

// #region testing-core-composing
void composingTests() {
  // All ribs matchers accept any package:test Matcher as their optional argument.
  test('composing with standard matchers', () {
    expect(Some(ilist([1, 2, 3])), isSome(isA<IList<int>>()));
    expect('not_email'.asLeft<String>(), isLeft(isNot(contains('@'))));
    expect(
      Validated.invalidNel<String, int>('too short'),
      isInvalid(isA<NonEmptyIList<String>>()),
    );
  });
}
// #endregion testing-core-composing

void main() {
  group('Option', optionTests);
  group('Either', eitherTests);
  group('Validated', validatedTests);
  group('Composing', composingTests);
}
