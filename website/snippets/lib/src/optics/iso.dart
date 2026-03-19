// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

import 'package:snippets/src/optics/domain.dart';

// iso-define

// An Iso<S, A> is a lossless, bidirectional conversion between S and A.
// It requires two total functions that are mutual inverses:
//   get        : S -> A   (forward conversion)
//   reverseGet : A -> S   (backward conversion)

// Credentials can be treated as a plain (username, password) tuple — no
// information is gained or lost in either direction.
final credsIso = Iso<Credentials, (String, String)>(
  (c) => (c.username, c.password),
  (t) => t(Credentials.new),
);

// iso-define

// iso-use

void isoUsage() {
  const creds = Credentials('admin', 's3cr3t');

  // get — convert S -> A
  final tuple = credsIso.get(creds); // ('admin', 's3cr3t')

  // reverseGet — convert A -> S
  final back = credsIso.reverseGet(('bob', 'hunter2')); // Credentials('bob','hunter2')

  // modify — apply a function in A-space, return a new S
  final renamed = credsIso.modify((t) => (t.$1.toUpperCase(), t.$2))(creds);
  // Credentials('ADMIN', 's3cr3t')
}

// iso-use

// iso-reverse

void reverseUsage() {
  // reverse() flips the direction: the result is an Iso<A, S>.
  final tupleToCredentials = credsIso.reverse();

  final creds = tupleToCredentials.get(('alice', 'pass')); // Credentials('alice','pass')
}

// iso-reverse

// iso-compose

// andThen composes two Isos into a single Iso.
final credsToLengths = credsIso.andThen(
  Iso<(String, String), (int, int)>(
    (t) => (t.$1.length, t.$2.length),
    (i) => (i.$1.toString(), i.$2.toString()),
  ),
);

void composeUsage() {
  const creds = Credentials('user', 'p');
  final lengths = credsToLengths.get(creds); // (4, 1)
}

// iso-compose

// iso-as-lens

// An Iso is a Lens, so it can be composed with andThenL in a chain of optics
// that span product and sum types alike.
final dbCredsIso = Lens<AppConfig, DBConfig>(
      (cfg) => cfg.dbConfig,
      (db) => (cfg) => cfg.copy(dbConfig: db),
    )
    .andThenL(
      Lens<DBConfig, Credentials>(
        (db) => db.credentials,
        (c) => (db) => db.copy(credentials: c),
      ),
    )
    .andThenL(
      // An Iso satisfies the PLens interface, so andThenL accepts it directly.
      Lens<Credentials, String>(
        (c) => credsIso.get(c).$1,
        (u) => (c) => credsIso.modify((t) => (u, t.$2))(c),
      ),
    );

// iso-as-lens
