import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

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
  }) => AppConfig(
    baseDir ?? this.baseDir,
    version ?? this.version,
    dbConfig ?? this.dbConfig,
    languages ?? this.languages,
  );

  @override
  String toString() => 'AppConfig($baseDir, $version, $dbConfig,$languages)';

  static final test = AppConfig(
    '/tmp',
    '1.0.2',
    DBConfig(Credentials('user', 'pass'), 1234, 'dbhost'.some),
    Languages(
      nel(Language('en', 'English'), [
        Language('es', 'Spanish'),
        Language('fr', 'French'),
        Language('de', 'German'),
      ]),
    ),
  );

  static final versionG = Getter<AppConfig, Version>((cfg) => cfg.version);
  static final baseDirS = Setter<AppConfig, String>(
    (f) => (cfg) => cfg.copy(baseDir: f(cfg.baseDir)),
  );

  static final dbConfigL = Lens<AppConfig, DBConfig>(
    (cfg) => cfg.dbConfig,
    (db) => (app) => app.copy(dbConfig: db),
  );
  static final dbConfigG = Getter<AppConfig, DBConfig>((aC) => aC.dbConfig);
  static final dbConfigS = Setter<AppConfig, DBConfig>(
    (f) => (cfg) => cfg.copy(dbConfig: f(cfg.dbConfig)),
  );

  static final dbPortG = dbConfigG.andThenG(DBConfig.portG);
  static final dbPortS = dbConfigS.andThenS(DBConfig.portS);

  static final languagesL = Lens<AppConfig, Languages>(
    (cfg) => cfg.languages,
    (lang) => (cfg) => cfg.copy(languages: lang),
  );

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
  }) => DBConfig(
    credentials ?? this.credentials,
    port ?? this.port,
    host ?? this.host,
  );

  @override
  String toString() => 'DBConfig($credentials, $port, $host)';

  static final portG = Getter<DBConfig, int>((cfg) => cfg.port);
  static final portS = Setter<DBConfig, int>((f) => (cfg) => cfg.copy(port: f(cfg.port)));

  static final hostL = Lens<DBConfig, Option<String>>(
    (cfg) => cfg.host,
    (h) => (cfg) => cfg.copy(host: h),
  );
}

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);

  Credentials copy({
    String? username,
    String? password,
  }) => Credentials(
    username ?? this.username,
    password ?? this.password,
  );

  @override
  String toString() => 'Credentials($username, $password)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Credentials && other.username == username && other.password == password);

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
  }) => Languages(supported ?? this.supported);

  @override
  String toString() => 'Languages($supported)';

  // Non-sensical but whatever...
  static Lens<Languages, Option<Language>> replaceLang(String langCode) =>
      Lens<Languages, Option<Language>>(
        (langs) => langs.supported.find((a) => a.code == langCode),
        (langOpt) =>
            (langs) => langOpt.fold(
              () => langs,
              (lang) => langs.copy(
                supported: langs.supported.map((a) => a.code != langCode ? a : lang),
              ),
            ),
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
  }) => Language(code ?? this.code, comment ?? this.comment);

  @override
  String toString() => 'Language($code, $comment)';

  @override
  bool operator ==(Object other) => other is Language && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
