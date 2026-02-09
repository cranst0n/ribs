import 'package:test/test.dart';

import 'config.dart';

void main() {
  group('Setter', () {
    test('modify', () {
      expect(
        AppConfig.baseDirS.modify((a) => a.toUpperCase())(AppConfig.test).baseDir,
        '/TMP',
      );
    });

    test('replace', () {
      expect(
        AppConfig.dbPortS.replace(8888)(AppConfig.test).dbConfig.port,
        8888,
      );
    });
  });
}
