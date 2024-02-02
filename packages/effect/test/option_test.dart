import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('Option effects', () {
    test('traverseIO', () {
      expect(
        const Some(1).traverseIO((a) => IO.pure(a * 2)),
        ioSucceeded(const Some(2)),
      );

      expect(
        none<int>().traverseIO((a) => IO.pure(a * 2)),
        ioSucceeded(none<int>()),
      );
    });

    test('traverseIO_', () async {
      var count = 0;

      await expectLater(
        const Some(1).traverseIO((a) => IO.exec(() => count += 1)),
        ioSucceeded(),
      );
      expect(count, 1);

      await expectLater(
        none<int>().traverseIO_((a) => IO.exec(() => count += 1)),
        ioSucceeded(),
      );
      expect(count, 1);
    });
  });
}
