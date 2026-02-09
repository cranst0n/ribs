import 'package:ribs_core/src/syntax/all.dart';
import 'package:ribs_core/test_matchers.dart';
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
            6.asRight<String>(),
            7.asRight<String>(),
            8.asRight<String>(),
            9.asRight<String>(),
            10.asRight<String>(),
            11.asRight<String>(),
            12.asRight<String>(),
            13.asRight<String>(),
            14.asRight<String>(),
            15.asRight<String>(),
            16.asRight<String>(),
            17.asRight<String>(),
            18.asRight<String>(),
            19.asRight<String>(),
            20.asRight<String>(),
            21.asRight<String>(),
            22.asRight<String>(),
          ).tupled();

      // ignore: inference_failure_on_function_invocation
      expect(tupled, isRight());
    });
  });
}
