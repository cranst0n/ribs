import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  group('Pull', () {
    test('unsafe Pull.flatMap', () {
      Pull<String, Unit> go() {
        final pull = Pull.output1(123);
        return pull.flatMap((_) => Pull.output1('123'));
      }

      expect(() => go(), throwsA(isA<TypeError>()));
    });
  });

  test('flatMapOutput preserves the original error stackTrace', () async {
    final originalTrace = StackTrace.fromString('original-trace-sentinel');

    // The source pull itself raises the error so flatMapOutput's _StepError
    // branch is triggered, exercising the stackTrace forwarding fix.
    final s = Rill.raiseError<int>('BOOM', originalTrace).flatMap((_) => Rill.empty<int>());

    final outcome = await s.compile.drain.unsafeRunFutureOutcome();

    outcome.fold(
      () => fail('should not be canceled'),
      (err, st) {
        expect(err, 'BOOM');
        expect(
          identical(st, originalTrace),
          isTrue,
          reason:
              'stackTrace must be the exact original object, not a substitute from StackTrace.current',
        );
      },
      (_) => fail('should not succeed'),
    );
  });
}
