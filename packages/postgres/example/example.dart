// ignore_for_file: avoid_print
import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_sql/ribs_sql.dart';

// ---------------------------------------------------------------------------
// Domain model
// ---------------------------------------------------------------------------

final class Person {
  final int id;
  final String name;
  final int age;
  const Person(this.id, this.name, this.age);

  @override
  String toString() => 'Person(id: $id, $name, age: $age)';
}

// ---------------------------------------------------------------------------
// Codecs
// ---------------------------------------------------------------------------

final personRead = (
  Read.integer,
  Read.string,
  Read.integer,
).tupled.map((t) => Person(t.$1, t.$2, t.$3));
final personWrite = (Write.string, Write.integer).tupled.contramap<Person>((p) => (p.name, p.age));

// ---------------------------------------------------------------------------
// DDL
// ---------------------------------------------------------------------------

final createTable =
    '''
CREATE TABLE IF NOT EXISTS person (
  id   SERIAL  PRIMARY KEY,
  name TEXT    NOT NULL,
  age  INTEGER NOT NULL
)'''.update0;

final dropTable = 'DROP TABLE IF EXISTS person'.update0;

// ---------------------------------------------------------------------------
// SQL operations
// ---------------------------------------------------------------------------

// Note: ribs_sql uses ? placeholders; the postgres driver converts them to $1, $2, …
final insertReturning = 'INSERT INTO person (name, age) VALUES (?, ?) RETURNING id, name, age'
    .updateReturning(personWrite, personRead);

final findAll = 'SELECT id, name, age FROM person ORDER BY name'.query(personRead);

Query<Person> findOlderThan(int minAge) =>
    (Fragment.raw('SELECT id, name, age FROM person WHERE age > ') +
            Fragment.param(minAge, Put.integer))
        .query(personRead);

final findByName = ParameterizedQuery(
  'SELECT id, name, age FROM person WHERE name = ?',
  personRead,
  Write.string,
);

final countAll = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique();

// ---------------------------------------------------------------------------
// Program
// ---------------------------------------------------------------------------

ConnectionIO<Unit> program() {
  final seed = insertReturning
      .runMany(
        ilist([
          const Person(0, 'Alice', 30),
          const Person(0, 'Bob', 25),
          const Person(0, 'Carol', 35),
          const Person(0, 'Dave', 28),
        ]),
      )
      .flatMap<Unit>(
        (people) => ConnectionIO.lift(
          IO
              .print('\nInserted:')
              .productR<Unit>(
                IO.exec(() => people.foreach((Person p) => print('  $p'))),
              ),
        ),
      );

  final printAll = findAll.ilist().flatMap<Unit>(
    (people) => ConnectionIO.lift(
      IO
          .print('\nAll people (${people.length}):')
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

  return seed.productR<Unit>(printAll).productR<Unit>(printOlderThan27).productR<Unit>(findAlice);
}

// ---------------------------------------------------------------------------
// Rollback demo
// ---------------------------------------------------------------------------

IO<Unit> rollbackDemo(Transactor xa) {
  final insertAndFail = insertReturning
      .run(const Person(0, 'Rollback', 99))
      .productR<Unit>(ConnectionIO.raiseError(Exception('intentional error')));

  return insertAndFail
      .transact(xa)
      .attempt()
      .flatMap<Unit>(
        (Either<Object, Unit> result) => result.fold(
          (_) => countAll
              .transact(xa)
              .flatMap<Unit>(
                (int n) =>
                    IO.print('\nCount after failed transaction: $n (unchanged — rolled back)'),
              ),
          (_) => IO.raiseError('Expected failure'),
        ),
      );
}

// ---------------------------------------------------------------------------
// Streaming
// ---------------------------------------------------------------------------

IO<Unit> streamExample(Transactor xa) {
  return IO
      .print('\nStreaming all people:')
      .productR<Unit>(
        xa.stream(findAll).evalMap((Person p) => IO.print('  $p')).compile.drain,
      );
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

void main() async {
  final endpoint = pg.Endpoint(
    host: 'localhost',
    database: 'ribs_example',
    username: 'ribs',
    password: 'ribs',
  );

  await PostgresPoolTransactor.withEndpoints([endpoint]).use((Transactor xa) {
    return dropTable
        .run()
        .productR<int>(createTable.run())
        .transact(xa)
        .productR<Unit>(program().transact(xa))
        .productR<Unit>(streamExample(xa))
        .productR<Unit>(rollbackDemo(xa));
  }).unsafeRunFuture();
}
