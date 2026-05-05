// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_test/ribs_test.dart';
import 'package:test/test.dart';

// This file demonstrates the matchers provided by ribs_test.
//
// Run with: dart test example/example.dart

void main() {
  // ---------------------------------------------------------------------------
  // Option matchers
  // ---------------------------------------------------------------------------

  group('Option', () {
    test('isSome matches a present value', () {
      final result = Option('hello');
      expect(result, isSome('hello'));
    });

    test('isSome with a nested matcher', () {
      final result = Option(42);
      expect(result, isSome(greaterThan(0)));
    });

    test('isNone matches an absent value', () {
      final result = none<String>();
      expect(result, isNone());
    });
  });

  // ---------------------------------------------------------------------------
  // Either matchers
  // ---------------------------------------------------------------------------

  group('Either', () {
    Either<String, int> parse(String s) {
      final n = int.tryParse(s);
      return n != null ? Either.right(n) : Either.left('not a number: $s');
    }

    test('isRight matches a successful parse', () {
      expect(parse('42'), isRight(42));
    });

    test('isLeft matches a failed parse', () {
      expect(parse('abc'), isLeft(contains('not a number')));
    });
  });

  // ---------------------------------------------------------------------------
  // Validated matchers
  // ---------------------------------------------------------------------------

  group('Validated', () {
    ValidatedNel<String, int> validateAge(int age) =>
        age >= 0 ? age.validNel() : 'Age must be non-negative'.invalidNel();

    test('isValidNel matches a valid value', () {
      expect(validateAge(30), isValidNel(30));
    });

    test('isInvalid matches a rejected value', () {
      expect(validateAge(-1), isInvalid());
    });
  });

  // ---------------------------------------------------------------------------
  // IO matchers
  // ---------------------------------------------------------------------------

  group('IO', () {
    test('succeeds asserts a successful outcome', () {
      final io = IO.pure(42).map((n) => n * 2);
      expect(io, succeeds(84));
    });

    test('errors asserts a failed outcome', () {
      final io = IO.raiseError<int>(Exception('boom'));
      expect(io, errors(isA<Exception>()));
    });

    test('cancels asserts a canceled outcome', () {
      expect(IO.canceled, cancels);
    });

    test('expectIO composes assertions inside an IO program', () {
      final program = IO
          .pure(41)
          .map((n) => n + 1)
          .flatMap((n) => expectIO(IO.pure(n), succeeds(42)));

      expect(program, succeeds());
    });
  });

  // ---------------------------------------------------------------------------
  // IO time-controlled testing with Ticker
  // ---------------------------------------------------------------------------

  group('Ticker', () {
    test('advances the test clock without real wall-clock delays', () {
      final io = IO.sleep(const Duration(seconds: 30)).as('done');
      final ticker = io.ticked;

      // Without this, the IO would be stuck waiting.
      ticker.advanceAndTick(const Duration(seconds: 30));

      expect(ticker, succeeds('done'));
    });

    test('nonTerminating detects IO that never completes', () {
      expect(IO.never<int>(), nonTerminating);
    });

    test('terminates detects IO that does complete', () {
      expect(IO.pure(Unit()), terminates);
    });
  });

  // ---------------------------------------------------------------------------
  // Rill stream matchers
  // ---------------------------------------------------------------------------

  group('Rill', () {
    test('producesInOrder checks exact ordered output', () {
      final rill = Rill.emits([1, 2, 3]);
      expect(rill, producesInOrder([1, 2, 3]));
    });

    test('producesOnly checks a single emitted element', () {
      expect(Rill.emit(42), producesOnly(42));
    });

    test('producesNothing checks an empty stream', () {
      expect(Rill.empty<int>(), producesNothing());
    });

    test('producesUnordered ignores emission order', () {
      final rill = Rill.emits([3, 1, 2]);
      expect(rill, producesUnordered([1, 2, 3]));
    });

    test('producesError checks a stream that fails', () {
      final rill = Rill.raiseError<int>('something went wrong');
      expect(rill, producesError(isA<String>()));
    });

    test('producesSameAs compares two streams element-by-element', () {
      final a = Rill.emits([1, 2, 3]);
      final b = Rill.emits([1, 2, 3]);
      expect(a, producesSameAs<int>(b));
    });
  });
}
