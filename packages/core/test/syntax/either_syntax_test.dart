import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_core/src/syntax/all.dart';
import 'package:test/test.dart';

void main() {
  group('Either syntax', () {
    test('tupled', () {
      final tupled =
          (
            1.asRight<String>(),
            2.asRight<String>(),
            3.asRight<String>(),
            4.asRight<String>(),
            5.asRight<String>(),
          ).tupled;

      // ignore: inference_failure_on_function_invocation
      expect(tupled, isRight());
    });
  });
}
