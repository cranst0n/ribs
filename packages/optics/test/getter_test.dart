import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_optics/src/getter.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  group('Getter', () {
    test('andThenG', () {
      expect(
        AppConfig.dbConfigG
            .andThenG(Getter<DBConfig, Option<String>>((cfg) => cfg.host))
            .get(AppConfig.test),
        isSome('dbhost'),
      );
    });

    test('get', () {
      expect(AppConfig.versionG.get(AppConfig.test), AppConfig.test.version);
      expect(AppConfig.dbPortG.get(AppConfig.test), 1234);
    });

    test('find', () {
      // ignore: prefer_function_declarations_over_variables
      final hasPort = (int port) => AppConfig.dbPortG.find((p) => p == port);

      expect(hasPort(1234)(AppConfig.test), isSome(1234));
      expect(hasPort(0)(AppConfig.test), isNone());
    });
  });
}
