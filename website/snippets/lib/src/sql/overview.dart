// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

// #region sql-domain
// A plain Dart class with no special annotations or generated code required.
final class Person {
  final String name;
  final int age;

  const Person(this.name, this.age);
}

// Describe how to read a Person from two consecutive columns.
final personRead = (Read.string, Read.integer).tupled.map(
  (t) => Person(t.$1, t.$2),
);

// Describe how to write a Person's fields as two SQL parameters.
final personWrite = (Write.string, Write.integer).tupled.contramap(
  (Person p) => (p.name, p.age),
);
// #endregion sql-domain

// #region sql-transactor
// SqliteTransactor.memory() gives a Resource<Transactor> backed by an
// in-memory SQLite database. Use .file(path) for a persistent database.
// Resource ensures the connection is closed on success, error, or
// cancellation.
IO<Unit> runWithTransactor() => SqliteTransactor.memory().use((xa) {
  // xa : Transactor — passed to .transact() on every ConnectionIO
  return IO.unit;
});
// #endregion sql-transactor

// #region sql-ddl
// update0 is an extension on String that creates an Update0 — a
// parameterless write statement. Use it for DDL and any SQL that
// takes no bound parameters.
ConnectionIO<int> createTable() =>
    '''
CREATE TABLE IF NOT EXISTS person (
  name TEXT NOT NULL,
  age  INTEGER NOT NULL
)'''.update0.run();
// #endregion sql-ddl

// #region sql-insert
// update<A>(Write<A>) creates an Update<A>.
// run(value)    — execute once, returns affected row count.
// runMany(list) — execute for each element in the list.
ConnectionIO<int> insertOne() => 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled)
    .run(('Alice', 30));

ConnectionIO<Unit> insertMany() => 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled)
    .runMany([('Alice', 30), ('Bob', 25), ('Carol', 35)]);
// #endregion sql-insert

// #region sql-query
// query<A>(Read<A>) creates a Query<A>.
// ilist()  — collect all rows into an IList<A>.
// unique() — expect exactly one row; error otherwise.
// option() — Some if one row, None if zero; error if more than one.
ConnectionIO<IList<Person>> queryAll() => 'SELECT name, age FROM person'.query(personRead).ilist();

ConnectionIO<Option<Person>> queryByName(String name) =>
    (Fragment.raw('SELECT name, age FROM person WHERE name = ') + Fragment.param(name, Put.string))
        .query(personRead)
        .option();
// #endregion sql-query

// #region sql-parameterized
// ParameterizedQuery bundles a SQL template, a Read, and a Write.
// Bind parameters lazily via unique(), option(), ilist(), or stream().
final byName = ParameterizedQuery(
  'SELECT name, age FROM person WHERE name = ?',
  personRead,
  Write.string,
);

final byMinAge = ParameterizedQuery(
  'SELECT name, age FROM person WHERE age >= ? ORDER BY name',
  personRead,
  Write.integer,
);

ConnectionIO<Person> lookupPerson(String name) => byName.unique(name);

ConnectionIO<IList<Person>> adults() => byMinAge.ilist(18);
// #endregion sql-parameterized

// #region sql-stream
// .stream() returns a ConnectionRill<A> — a lazy, streaming query.
// Call .transact(xa) to obtain a Rill<A> that emits rows one at a time.
// The connection stays open for the duration of the stream and is
// released automatically when the stream terminates.
IO<IList<Person>> streamAll(Transactor xa) =>
    'SELECT name, age FROM person'.query(personRead).stream().transact(xa).compile.toIList;
// #endregion sql-stream

// #region sql-returning
// updateReturning<A, B>(Write<A>, Read<B>) supports INSERT ... RETURNING.
// run(value)    — execute and read the single returned row.
// runMany(list) — execute for each element; collect all returned rows.
ConnectionIO<int> insertReturningId(String label) =>
    'INSERT INTO item (label) VALUES (?) RETURNING id'
        .updateReturning(Write.string, Read.integer)
        .run(label);
// #endregion sql-returning

// #region sql-strategy
// Strategy controls the four transaction lifecycle hooks. The default strategy
// issues BEGIN before the ConnectionIO, COMMIT on success, and ROLLBACK on any
// error or fiber cancellation. Override individual hooks when needed — for
// example to use SAVEPOINTs or to add application-level auditing.
final customStrategy = Strategy(
  before: ConnectionIO.fromConnection((conn) => conn.beginTransaction()),
  after: ConnectionIO.fromConnection((conn) => conn.commit()),
  oops: ConnectionIO.fromConnection((conn) => conn.rollback()),
  always: ConnectionIO.unit, // runs unconditionally after the above
);

// Pass a custom Strategy to any transactor constructor.
final Resource<Transactor> xa = SqliteTransactor.memory(strategy: customStrategy);
// #endregion sql-strategy

// #region sql-transaction
// .transact(xa) wraps the entire ConnectionIO in BEGIN / COMMIT.
// Any error — including fiber cancellation — triggers an automatic ROLLBACK.
IO<Unit> runTransaction(Transactor xa2) =>
    createTable().flatMap((_) => insertMany()).flatMap((_) => queryAll()).transact(xa2).voided();
// #endregion sql-transaction
