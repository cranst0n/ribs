// ignore_for_file: unused_local_variable

import 'package:ribs_optics/ribs_optics.dart';

import 'package:snippets/src/optics/domain.dart';

// #region overview-problem
// Without optics, updating a nested field requires threading the change
// through every intermediate copy() call by hand.
AppConfig bumpPortManual(AppConfig cfg) => cfg.copy(
  dbConfig: cfg.dbConfig.copy(port: cfg.dbConfig.port + 1),
);
// #endregion overview-problem

// #region overview-lens-solution
// Define a Lens for each layer once...
final dbConfigL = Lens<AppConfig, DBConfig>(
  (cfg) => cfg.dbConfig,
  (db) => (cfg) => cfg.copy(dbConfig: db),
);

final portL = Lens<DBConfig, int>(
  (db) => db.port,
  (p) => (db) => db.copy(port: p),
);

// ...then compose them into a single optic that reaches the target directly.
final dbPortL = dbConfigL.andThenL(portL);

AppConfig bumpPortWithLens(AppConfig cfg) => dbPortL.modify((p) => p + 1)(cfg);
// #endregion overview-lens-solution

// #region overview-hierarchy
// The four primary optic types and their guarantees:
//
//   Iso<S,A>      — total, bidirectional   (S <-> A, no information lost)
//   Lens<S,A>     — total read-write       (A always present inside S)
//   Prism<S,A>    — partial, constructible (A may or may not match)
//   Optional<S,A> — partial read-write     (A may or may not be present)
//
// Subtype relationships (every Iso is also a Lens, etc.):
//   Iso  ⊆  Lens  ⊆  Optional  ⊇  Prism
// #endregion overview-hierarchy

// #region overview-compose
// Optics compose via typed andThen* methods:
//   andThenL  — Lens composed with Lens  -> Lens
//   andThenO  — Lens/Optional with Optional -> Optional
//   andThenP  — Prism composed with Prism -> Prism
//   andThenG  — any optic with Getter -> Getter (read-only)
//   andThenS  — any Setter with Setter -> Setter (write-only)
// #endregion overview-compose
