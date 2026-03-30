// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

import 'package:snippets/src/optics/domain.dart';

// #region optional-define
// An Optional<S, A> focuses on a value that may or may not be present.
// It generalises both Lens (always present) and Prism (variant matching).
//
// It requires two functions:
//   getOrModify : S -> Either<S, A>   (Right when the value is present)
//   set         : (A, S) -> S         (replace — only applied when present)

// Focus on the optional host field inside DBConfig.
final hostO = Optional<DBConfig, String>(
  (db) => db.host.toRight(() => db),
  (h) => (db) => db.copy(host: h.some),
);
// #endregion optional-define

// #region optional-use
void optionalUsage() {
  final withHost = DBConfig(
    const Credentials('admin', 's3cr3t'),
    5432,
    'db.local'.some,
  );

  final noHost = DBConfig(const Credentials('admin', 's3cr3t'), 5432, none());

  // getOption — Some when present, None when absent
  final h1 = hostO.getOption(withHost); // Some('db.local')
  final h2 = hostO.getOption(noHost); // None

  // replace — updates only when the value is present; no-op otherwise
  final updated = hostO.replace('prod.db')(withHost); // host = 'prod.db'
  final unchanged = hostO.replace('prod.db')(noHost); // host still absent

  // modify — same conditional semantics
  final upper = hostO.modify((h) => h.toUpperCase())(withHost);

  // modifyOption — Some(updated S) when present, None when absent
  final opt = hostO.modifyOption((h) => h.toUpperCase())(withHost);
  final none_ = hostO.modifyOption((h) => h.toUpperCase())(noHost);
}
// #endregion optional-use

// #region optional-compose
// Compose a Lens with an Optional using andThenO.
// The result is an Optional that digs through both layers.
final dbConfigL = Lens<AppConfig, DBConfig>(
  (cfg) => cfg.dbConfig,
  (db) => (cfg) => cfg.copy(dbConfig: db),
);

final appHostO = dbConfigL.andThenO(hostO);

void composeUsage() {
  // Reads the host two levels deep; None when absent at either level.
  final host = appHostO.getOption(sampleConfig); // Some('db.local')

  // Updates the host two levels deep in one step.
  final updated = appHostO.replace('new.host')(sampleConfig);
}
// #endregion optional-compose
