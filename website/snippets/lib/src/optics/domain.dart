// ignore_for_file: unused_field, unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

// optics-domain

// A realistic nested config structure — updating deeply-nested fields
// without optics requires threading the change through every layer manually.

final class AppConfig {
  final String baseDir;
  final String version;
  final DBConfig dbConfig;
  final Languages languages;

  const AppConfig(this.baseDir, this.version, this.dbConfig, this.languages);

  AppConfig copy({
    String? baseDir,
    String? version,
    DBConfig? dbConfig,
    Languages? languages,
  }) => AppConfig(
    baseDir ?? this.baseDir,
    version ?? this.version,
    dbConfig ?? this.dbConfig,
    languages ?? this.languages,
  );
}

final class DBConfig {
  final Credentials credentials;
  final int port;
  final Option<String> host;

  const DBConfig(this.credentials, this.port, this.host);

  DBConfig copy({
    Credentials? credentials,
    int? port,
    Option<String>? host,
  }) => DBConfig(
    credentials ?? this.credentials,
    port ?? this.port,
    host ?? this.host,
  );
}

final class Credentials {
  final String username;
  final String password;

  const Credentials(this.username, this.password);

  Credentials copy({String? username, String? password}) =>
      Credentials(username ?? this.username, password ?? this.password);

  // An Iso lets Credentials be treated as a plain (username, password) tuple.
  static final iso = Iso<Credentials, (String, String)>(
    (c) => (c.username, c.password),
    (t) => t(Credentials.new),
  );
}

final class Languages {
  final NonEmptyIList<Language> supported;

  const Languages(this.supported);

  Languages copy({NonEmptyIList<Language>? supported}) => Languages(supported ?? this.supported);
}

final class Language {
  final String code;
  final String comment;

  const Language(this.code, this.comment);

  Language copy({String? code, String? comment}) =>
      Language(code ?? this.code, comment ?? this.comment);

  @override
  bool operator ==(Object other) => other is Language && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

// optics-domain

// optics-domain-sample

final sampleConfig = AppConfig(
  '/var/app',
  '2.1.0',
  DBConfig(const Credentials('admin', 's3cr3t'), 5432, 'db.local'.some),
  Languages(nel(const Language('en', 'English'), [const Language('fr', 'French')])),
);

// optics-domain-sample
