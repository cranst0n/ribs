import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_core/src/syntax/all.dart';
import 'package:test/test.dart';

void main() {
  group('Option syntax', () {
    test('tupled', () {
      final tupled =
          (
            1.some,
            2.some,
            3.some,
            4.some,
            5.some,
          ).tupled;

      // ignore: inference_failure_on_function_invocation
      expect(tupled, isSome());
    });
  });
}
