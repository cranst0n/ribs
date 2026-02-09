import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  final config = AppConfig.test;

  group('Lens', () {
    final baseDirL = Lens<AppConfig, String>(
      (cfg) => cfg.baseDir,
      (b) => (s) => s.copy(baseDir: b),
    );

    final versionL = Lens<AppConfig, Version>(
      (cfg) => cfg.version,
      (v) => (s) => s.copy(version: v),
    );

    final reverseL = Lens<String, String>(
      (str) => String.fromCharCodes(str.codeUnits.reversed),
      (str) => (_) => String.fromCharCodes(str.codeUnits.reversed),
    );

    final replaceFrench = AppConfig.languagesL.andThenL(Languages.replaceLang('fr'));

    final reverseBaseDir = baseDirL.andThenL(reverseL);

    test('basic', () {
      expect(
        versionL.modify((a) => 'Ver: $a')(config).version,
        'Ver: ${config.version}',
      );

      expect(reverseBaseDir.replace('HELLO')(config).baseDir, 'OLLEH');
      expect(reverseBaseDir.getOption(config), 'pmt/'.some);
      expect(
        replaceFrench
            .replace(Language('ru', 'Russian').some)(config)
            .languages
            .supported
            .contains(Language('fr', 'French')),
        isFalse,
      );

      expect(
        AppConfig.supportedLanguages.exists((a) => a.exists((a) => a.code == 'fr'))(config),
        isTrue,
      );

      final noFrench = AppConfig.supportedLanguages.modify(
        (langs) => nel(langs.head, langs.tail.filter((a) => a.code != 'fr').toList()),
      )(config);

      expect(
        AppConfig.supportedLanguages.exists((a) => a.exists((a) => a.code == 'fr'))(noFrench),
        isFalse,
      );
    });

    test('andThenG', () {
      final versionL = Lens<AppConfig, Version>(
        (cfg) => cfg.version,
        (v) => (s) => s.copy(version: v),
      );

      final reverseString = Getter<Version, String>((v) => v.split('').reversed.join());

      expect(versionL.andThenG(reverseString).get(AppConfig.test), "2.0.1");
    });
  });
}
