import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';
import 'package:test/test.dart';

void main() {
  final config = AppConfig(
    '/tmp',
    '1.0.2',
    DBConfig(Credentials('user', 'pass'), 1234, 'dbhost'.some),
    Languages(NonEmptyIList.of(Language('en', 'English'), [
      Language('es', 'Spanish'),
      Language('fr', 'French'),
      Language('de', 'German'),
    ])),
  );

  test('getter', () {
    expect(AppConfig.versionG.get(config), config.version);

    expect(AppConfig.dbPortG.get(config), 1234);
  });

  test('setter', () {
    expect(AppConfig.baseDirS.modify((a) => a.toUpperCase())(config).baseDir,
        '/TMP');
    expect(AppConfig.dbPortS.replace(8888)(config).dbConfig.port, 8888);
  });

  test('optional', () {
    final first = Optional<IList<int>, int>(
      (a) => a.headOption.toRight(() => a),
      (a) => (s) => s.isEmpty ? s : s.tail().prepend(a),
    );

    final second = Optional<IList<int>, int>(
      (a) => a.tail().headOption.toRight(() => a),
      (a) => (s) => s.tail().isEmpty ? s : s.replace(1, a),
    );

    final a = IList.of([1, 2, 3]);
    final b = nil<int>();

    expect(first.replace(42)(a), ilist([42, 2, 3]));
    expect(second.replace(42)(b), nil<int>());

    expect(first.modify((i) => i + 1)(a), ilist([2, 2, 3]));
    expect(second.modify((i) => i + 1)(a), ilist([1, 3, 3]));

    expect(second.getOrModify(a), 2.asRight<IList<int>>());
    expect(second.getOrModify(b), nil<int>().asLeft<int>());

    expect(first.modifyOption((i) => i + 1)(a), ilist([2, 2, 3]).some);
    expect(second.modifyOption((i) => i + 1)(b), none<IList<int>>());
  });

  test('lens', () {
    final baseDirL = Lens<AppConfig, String>(
        (cfg) => cfg.baseDir, (b) => (s) => s.copy(baseDir: b));

    final versionL = Lens<AppConfig, Version>(
        (cfg) => cfg.version, (v) => (s) => s.copy(version: v));

    final reverseL = Lens<String, String>(
      (str) => String.fromCharCodes(str.codeUnits.reversed),
      (str) => (_) => String.fromCharCodes(str.codeUnits.reversed),
    );

    final replaceFrench =
        AppConfig.languagesL.andThenL(Languages.replaceLang('fr'));

    final reverseBaseDir = baseDirL.andThenL(reverseL);

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
      AppConfig.supportedLanguages
          .exists((a) => a.exists((a) => a.code == 'fr'))(config),
      isTrue,
    );

    final noFrench = AppConfig.supportedLanguages.modify((langs) =>
        NonEmptyIList.of(langs.head,
            langs.tail.filter((a) => a.code != 'fr').toList()))(config);

    expect(
      AppConfig.supportedLanguages
          .exists((a) => a.exists((a) => a.code == 'fr'))(noFrench),
      isFalse,
    );
  });

  test('iso', () {
    final creds = config.dbConfig.credentials;

    expect(Credentials.iso.get(creds), ('user', 'pass'));

    expect(
      Credentials.iso.modify((x) => x.copy($1: '<${x.$1}>'))(creds),
      Credentials('<user>', 'pass'),
    );

    expect(
      AppConfig.dbConfigL
          .andThenL(DBConfig.hostL)
          .modifyOption((xOpt) => xOpt.map((a) => '>> $a'))(config)
          .flatMap((c) => c.dbConfig.host),
      '>> ${config.dbConfig.host.getOrElse(() => '???')}'.some,
    );
  });
}

typedef Version = String;

class AppConfig {
  final String baseDir;
  final Version version;
  final DBConfig dbConfig;
  final Languages languages;

  AppConfig(this.baseDir, this.version, this.dbConfig, this.languages);

  AppConfig copy({
    String? baseDir,
    Version? version,
    DBConfig? dbConfig,
    Languages? languages,
  }) =>
      AppConfig(
        baseDir ?? this.baseDir,
        version ?? this.version,
        dbConfig ?? this.dbConfig,
        languages ?? this.languages,
      );

  @override
  String toString() => 'AppConfig($baseDir, $version, $dbConfig,$languages)';

  static final versionG = Getter<AppConfig, Version>((cfg) => cfg.version);
  static final baseDirS = Setter<AppConfig, String>(
      (f) => (cfg) => cfg.copy(baseDir: f(cfg.baseDir)));

  static final dbConfigL = Lens<AppConfig, DBConfig>(
      (cfg) => cfg.dbConfig, (db) => (app) => app.copy(dbConfig: db));
  static final dbConfigG = Getter<AppConfig, DBConfig>((aC) => aC.dbConfig);
  static final dbConfigS = Setter<AppConfig, DBConfig>(
      (f) => (cfg) => cfg.copy(dbConfig: f(cfg.dbConfig)));

  static final dbPortG = dbConfigG.andThenG(DBConfig.portG);
  static final dbPortS = dbConfigS.andThenS(DBConfig.portS);

  static final languagesL = Lens<AppConfig, Languages>(
      (cfg) => cfg.languages, (lang) => (cfg) => cfg.copy(languages: lang));

  static final supportedLanguages = languagesL.andThenL(Languages.supportedL);
}

class DBConfig {
  final Credentials credentials;
  final int port;
  final Option<String> host;

  DBConfig(this.credentials, this.port, this.host);

  DBConfig copy({
    Credentials? credentials,
    int? port,
    Option<String>? host,
  }) =>
      DBConfig(
        credentials ?? this.credentials,
        port ?? this.port,
        host ?? this.host,
      );

  @override
  String toString() => 'DBConfig($credentials, $port, $host)';

  static final portG = Getter<DBConfig, int>((cfg) => cfg.port);
  static final portS =
      Setter<DBConfig, int>((f) => (cfg) => cfg.copy(port: f(cfg.port)));

  static final hostL = Lens<DBConfig, Option<String>>(
      (cfg) => cfg.host, (h) => (cfg) => cfg.copy(host: h));
}

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);

  Credentials copy({
    String? username,
    String? password,
  }) =>
      Credentials(
        username ?? this.username,
        password ?? this.password,
      );

  @override
  String toString() => 'Credentials($username, $password)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Credentials &&
          other.username == username &&
          other.password == password);

  @override
  int get hashCode => username.hashCode * password.hashCode;

  static final iso = Iso<Credentials, (String, String)>(
    (c) => (c.username, c.password),
    (t) => t(Credentials.new),
  );
}

class Languages {
  final NonEmptyIList<Language> supported;

  Languages(this.supported);

  Language get primary => supported.head;

  Languages copy({
    NonEmptyIList<Language>? supported,
  }) =>
      Languages(supported ?? this.supported);

  @override
  String toString() => 'Languages($supported)';

  // Non-sensical but whatever...
  static Lens<Languages, Option<Language>> replaceLang(String langCode) =>
      Lens<Languages, Option<Language>>(
        (langs) => langs.supported.find((a) => a.code == langCode),
        (langOpt) => (langs) => langOpt.fold(
            () => langs,
            (lang) => langs.copy(
                  supported:
                      langs.supported.map((a) => a.code != langCode ? a : lang),
                )),
      );

  static final Lens<Languages, NonEmptyIList<Language>> supportedL =
      Lens<Languages, NonEmptyIList<Language>>(
    (langs) => langs.supported,
    (supported) => (langs) => langs.copy(supported: supported),
  );
}

class Language {
  final String code;
  final String comment;

  Language(this.code, this.comment);

  Language copy({
    String? code,
    String? comment,
  }) =>
      Language(code ?? this.code, comment ?? this.comment);

  @override
  String toString() => 'Language($code, $comment)';

  @override
  bool operator ==(Object? other) => other is Language && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
