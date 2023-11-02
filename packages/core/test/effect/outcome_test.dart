import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/test/io.dart';
import 'package:test/test.dart';

void main() {
  group('Outcome.is', () {
    test('success', () {
      expect(Outcome.succeeded(Unit()).isSuccess, isTrue);
      expect(Outcome.succeeded(Unit()).isError, isFalse);
      expect(Outcome.succeeded(Unit()).isCanceled, isFalse);
    });

    test('errored', () {
      expect(Outcome.errored<Unit>(RuntimeException('')).isSuccess, isFalse);
      expect(Outcome.errored<Unit>(RuntimeException('')).isError, isTrue);
      expect(Outcome.errored<Unit>(RuntimeException('')).isCanceled, isFalse);
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
      expect(Outcome.succeeded<Object>(Unit()) == Outcome.succeeded<Object>(42),
          isFalse);

      expect(
        Outcome.succeeded(Unit()) ==
            Outcome.errored<Unit>(RuntimeException('')),
        isFalse,
      );

      expect(Outcome.succeeded(Unit()) == Outcome.canceled<Unit>(), isFalse);
    });

    test('errored', () {
      final err = Outcome.errored<Unit>(RuntimeException(''));

      expect(err == err, isTrue);

      expect(
        err == Outcome.errored<Unit>(RuntimeException('')),
        isFalse,
      );

      expect(
        Outcome.errored<Unit>(RuntimeException('')) == Outcome.canceled<Unit>(),
        isFalse,
      );
    });

    test('canceled', () {
      expect(Outcome.canceled<Unit>() == Outcome.canceled<Unit>(), isTrue);
    });
  });

  group('embed', () {
    test('succeeded', () {
      final test = Outcome.succeeded(42).embed(IO.pure(0));
      expect(test, ioSucceeded(42));
    });

    test('errored', () {
      final test = Outcome.errored<int>(RuntimeException('')).embed(IO.pure(0));
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
