// ignore_for_file: avoid_print
//
// Demonstrates the ribs_sql DSL — Fragments, Read/Write codecs,
// ConnectionIO composition, parameterized queries, updates, and streaming.
//
// This file defines the SQL program as a pure description.
// Pair with ribs_sqlite or ribs_postgres to obtain a Transactor and run it:
//
//   SqliteTransactor.memory().use((xa) => program.transact(xa)).unsafeRunFuture();
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';

final class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);

  @override
  String toString() => 'Person($name, age: $age)';
}

void main() {
  // Read two columns and map to a Person.
  final personRead = (Read.string, Read.integer).tupled.map((t) => Person(t.$1, t.$2));

  // Write a Person into two SQL parameters.
  final personWrite = (
    Write.string,
    Write.integer,
  ).tupled.contramap<Person>((p) => (p.name, p.age));

  // ---------------------------------------------------------------------------
  // DDL
  // ---------------------------------------------------------------------------

  final createTable =
      '''
CREATE TABLE IF NOT EXISTS person (
  name TEXT    NOT NULL,
  age  INTEGER NOT NULL
)'''.update0;

  final createItemTable =
      '''
CREATE TABLE IF NOT EXISTS item (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  label TEXT    NOT NULL
)'''.update0;

  // ---------------------------------------------------------------------------
  // Updates
  // ---------------------------------------------------------------------------

  final insertPerson = 'INSERT INTO person (name, age) VALUES (?, ?)'.update(personWrite);

  final insertItem = 'INSERT INTO item (label) VALUES (?) RETURNING id'.updateReturning(
    Write.string,
    Read.integer,
  );

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  // All rows — no parameters.
  final findAll = 'SELECT name, age FROM person ORDER BY name'.query(personRead);

  // Fragment-based query with a typed parameter.
  Query<Person> findOlderThan(int minAge) =>
      (Fragment.raw('SELECT name, age FROM person WHERE age > ') +
              Fragment.param(minAge, Put.integer) +
              Fragment.raw(' ORDER BY name'))
          .query(personRead);

  // Reusable parameterized query.
  final findByName = ParameterizedQuery(
    'SELECT name, age FROM person WHERE name = ?',
    personRead,
    Write.string,
  );

  // ---------------------------------------------------------------------------
  // Program — pure description, nothing runs until .transact(xa)
  // ---------------------------------------------------------------------------

  final seedPeople = insertPerson.runMany([
    const Person('Alice', 30),
    const Person('Bob', 25),
    const Person('Carol', 35),
    const Person('Dave', 28),
  ]);

  final seedItems = insertItem
      .runMany(ilist(['Widget', 'Gadget', 'Doohickey']))
      .flatMap<Unit>(
        (ids) => ConnectionIO.lift(IO.print('Inserted item ids: ${ids.toList()}')),
      );

  final printAll = findAll.ilist().flatMap<Unit>(
    (people) => ConnectionIO.lift(
      IO
          .print('\nAll people:')
          .productR<Unit>(
            IO.exec(() => people.foreach((Person p) => print('  $p'))),
          ),
    ),
  );

  final printOlderThan27 = findOlderThan(27).ilist().flatMap<Unit>(
    (people) => ConnectionIO.lift(
      IO
          .print('\nOlder than 27:')
          .productR<Unit>(
            IO.exec(() => people.foreach((Person p) => print('  $p'))),
          ),
    ),
  );

  final findAlice = findByName
      .unique('Alice')
      .flatMap<Unit>(
        (Person p) => ConnectionIO.lift(IO.print('\nFound by name: $p')),
      );

  final program = createTable
      .run()
      .productR<int>(createItemTable.run())
      .productR<Unit>(seedPeople)
      .productR<Unit>(seedItems)
      .productR<Unit>(printAll)
      .productR<Unit>(printOlderThan27)
      .productR<Unit>(findAlice);

  // Streaming variant — keeps the connection open for the Rill lifetime.
  final stream = findAll.stream();

  // program and stream are pure values — execute them with a Transactor:
  //   SqliteTransactor.memory().use((xa) => program.transact(xa)).unsafeRunFuture()
  //   xa.stream(stream.query, ...).compile.drain.unsafeRunFuture()
  print('SQL program defined: $program');
  print('Stream query: ${stream.query.fragment.sql.trim()}');
}
