import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  group('Iso', () {
    test('basic', () {
      final creds = AppConfig.test.dbConfig.credentials;

      expect(Credentials.iso.get(creds), ('user', 'pass'));

      expect(
        Credentials.iso.modify((x) => x.copy($1: '<${x.$1}>'))(creds),
        Credentials('<user>', 'pass'),
      );

      expect(
        AppConfig.dbConfigL
            .andThenL(DBConfig.hostL)
            .modifyOption((xOpt) => xOpt.map((a) => '>> $a'))(AppConfig.test)
            .flatMap((c) => c.dbConfig.host),
        '>> ${AppConfig.test.dbConfig.host.getOrElse(() => '???')}'.some,
      );
    });
  });
}
