import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('Outcome.is', () {
    test('success', () {
      expect(Outcome.succeeded(Unit()).isSuccess, isTrue);
      expect(Outcome.succeeded(Unit()).isError, isFalse);
      expect(Outcome.succeeded(Unit()).isCanceled, isFalse);
    });

    test('errored', () {
      expect(Outcome.errored<Unit>('').isSuccess, isFalse);
      expect(Outcome.errored<Unit>('').isError, isTrue);
      expect(Outcome.errored<Unit>('').isCanceled, isFalse);
    });

    test('canceled', () {
      expect(Outcome.canceled<Unit>().isSuccess, isFalse);
      expect(Outcome.canceled<Unit>().isError, isFalse);
      expect(Outcome.canceled<Unit>().isCanceled, isTrue);
    });
  });

  group('Outcome equality', () {
    test('success', () {
      expect(Outcome.succeeded(Unit()) == Outcome.succeeded(Unit()), isTrue);
      expect(Outcome.succeeded<Object>(Unit()) == Outcome.succeeded<Object>(42), isFalse);

      expect(
        Outcome.succeeded(Unit()) == Outcome.errored<Unit>(''),
        isFalse,
      );

      expect(Outcome.succeeded(Unit()) == Outcome.canceled<Unit>(), isFalse);
    });

    test('errored', () {
      final err = Outcome.errored<Unit>('');

      expect(err == err, isTrue);
      expect(err == Outcome.errored<Unit>(''), isTrue);
      expect(Outcome.errored<Unit>('') == Outcome.canceled<Unit>(), isFalse);
    });

    test('canceled', () {
      expect(Outcome.canceled<Unit>() == Outcome.canceled<Unit>(), isTrue);
    });

    test('isSameType', () {
      const err = 'boom';

      expect(Outcome.succeeded('a').isSameType(Outcome.succeeded(42)), isTrue);
      expect(Outcome.errored<int>(err).isSameType(Outcome.errored<Unit>(err)), isTrue);
      expect(Outcome.canceled<int>().isSameType(Outcome.canceled<Unit>()), isTrue);

      expect(Outcome.succeeded(0).isSameType(Outcome.canceled<int>()), isFalse);
      expect(Outcome.canceled<Unit>().isSameType(Outcome.errored<int>(err)), isFalse);
    });
  });

  group('embed', () {
    test('succeeded', () {
      final test = Outcome.succeeded(42).embed(IO.pure(0));
      expect(test, ioSucceeded(42));
    });

    test('errored', () {
      final test = Outcome.errored<int>('').embed(IO.pure(0));
      expect(test, ioErrored());
    });

    test('canceled', () {
      final test = Outcome.canceled<int>().embed(IO.pure(0));
      expect(test, ioSucceeded(0));
    });

    test('never', () {
      final test = Outcome.canceled<int>().embed(IO.pure(0));
      expect(test, ioSucceeded(0));
    });
  });
}
