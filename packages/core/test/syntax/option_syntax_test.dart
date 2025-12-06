import 'package:ribs_core/src/syntax/all.dart';
import 'package:ribs_core/test_matchers.dart';
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
            6.some,
            7.some,
            8.some,
            9.some,
            10.some,
            11.some,
            12.some,
            13.some,
            14.some,
            15.some,
            16.some,
            17.some,
            18.some,
            19.some,
            20.some,
            21.some,
            22.some,
          ).tupled();

      // ignore: inference_failure_on_function_invocation
      expect(tupled, isSome());
    });
  });
}
