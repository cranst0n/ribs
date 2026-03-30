// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

import 'package:snippets/src/optics/domain.dart';

// #region lens-define
// A Lens<S, A> requires two functions:
//   get  : S -> A         (read the focused field)
//   set  : (A, S) -> S    (replace the focused field, returning a new S)

final dbConfigL = Lens<AppConfig, DBConfig>(
  (cfg) => cfg.dbConfig,
  (db) => (cfg) => cfg.copy(dbConfig: db),
);

final portL = Lens<DBConfig, int>(
  (db) => db.port,
  (p) => (db) => db.copy(port: p),
);
// #endregion lens-define

// #region lens-use
void lensUsage() {
  // get — read the focused value
  final db = dbConfigL.get(sampleConfig); // DBConfig(...)
  final port = portL.get(sampleConfig.dbConfig); // 5432

  // replace — return a new AppConfig with dbConfig replaced
  final newConfig = dbConfigL.replace(
    const DBConfig(Credentials('admin', 's3cr3t'), 6543, None()),
  )(sampleConfig);

  // modify — apply a function to the focused value
  final bumped = portL.modify((p) => p + 1)(sampleConfig.dbConfig);
}
// #endregion lens-use

// #region lens-compose
// Lenses compose with andThenL, producing a new Lens that focuses deeper.
final dbPortL = dbConfigL.andThenL(portL);

void composeUsage() {
  final port = dbPortL.get(sampleConfig); // 5432

  // Update the port two levels deep in one step.
  final updated = dbPortL.replace(9999)(sampleConfig);
}
// #endregion lens-compose

// #region lens-andtheng
// andThenG composes a Lens with a read-only Getter.
// Useful when the target type has derived values you want to project.
final versionMajorG = Lens<AppConfig, String>(
  (cfg) => cfg.version,
  (v) => (cfg) => cfg.copy(version: v),
).andThenG(Getter((String v) => int.parse(v.split('.').first)));

void getterUsage() {
  final major = versionMajorG.get(sampleConfig); // 2
}

// #endregion lens-andtheng
