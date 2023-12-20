import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';
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

    test('reverse', () {
      expect(
        Credentials.iso.reverse().get(('bob', 'pass')),
        Credentials('bob', 'pass'),
      );
    });

    test('andThen', () {
      final stringLengths = Iso<(String, String), (int, int)>(
        (s) => (s.$1.length, s.$2.length),
        (i) => (i.$1.toString(), i.$2.toString()),
      );

      expect(
        Credentials.iso.andThen(stringLengths).get(Credentials('user', 'p')),
        (4, 1),
      );
    });
  });
}
