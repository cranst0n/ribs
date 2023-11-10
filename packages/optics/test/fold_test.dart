import 'package:ribs_optics/src/getter.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  group('Fold', () {
    test('exists', () {
      final testG = Getter<AppConfig, Version>((c) => c.version);

      final hasHost = testG.exists((v) => v == '1.0.2');
      expect(hasHost(AppConfig.test), isTrue);
    });
  });
}
