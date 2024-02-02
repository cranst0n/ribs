import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:test/test.dart';

void main() {
  group('ExitCase.is', () {
    test('succeeded', () {
      expect(ExitCase.succeeded().isSuccess, isTrue);
      expect(ExitCase.succeeded().isError, isFalse);
      expect(ExitCase.succeeded().isCanceled, isFalse);
    });

    test('errored', () {
      expect(ExitCase.errored(RuntimeException('')).isSuccess, isFalse);
      expect(ExitCase.errored(RuntimeException('')).isError, isTrue);
      expect(ExitCase.errored(RuntimeException('')).isCanceled, isFalse);
    });

    test('canceled', () {
      expect(ExitCase.canceled().isSuccess, isFalse);
      expect(ExitCase.canceled().isError, isFalse);
      expect(ExitCase.canceled().isCanceled, isTrue);
    });
  });

  group('ExitCase.toOutcome', () {
    test('succeeded', () {
      expect(ExitCase.succeeded().toOutcome(), Outcome.succeeded(Unit()));
    });

    test('errored', () {
      final err = RuntimeException('');
      expect(ExitCase.errored(err).toOutcome(), Outcome.errored<Unit>(err));
    });

    test('canceled', () {
      expect(ExitCase.canceled().toOutcome(), Outcome.canceled<Unit>());
    });
  });
}
