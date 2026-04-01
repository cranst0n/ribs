// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

// A self-contained example using an in-memory SQLite database.

// ---------------------------------------------------------------------------
// Domain model
// ---------------------------------------------------------------------------

final class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);

  @override
  String toString() => 'Person($name, age: $age)';
}

// ---------------------------------------------------------------------------
// Codecs
// ---------------------------------------------------------------------------

final personRead = (Read.string, Read.integer).tupled.map((t) => Person(t.$1, t.$2));
final personWrite = (Write.string, Write.integer).tupled.contramap<Person>((p) => (p.name, p.age));

// ---------------------------------------------------------------------------
// DDL
// ---------------------------------------------------------------------------

final createPersonTable =
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
// SQL operations
// ---------------------------------------------------------------------------

final insertPerson = 'INSERT INTO person (name, age) VALUES (?, ?)'.update(personWrite);

final insertItemReturning = 'INSERT INTO item (label) VALUES (?) RETURNING id'.updateReturning(
  Write.string,
  Read.integer,
);

final findAll = 'SELECT name, age FROM person ORDER BY name'.query(personRead);

Query<Person> findOlderThan(int minAge) =>
    (Fragment.raw('SELECT name, age FROM person WHERE age > ') +
            Fragment.param(minAge, Put.integer))
        .query(personRead);

final findByName = ParameterizedQuery(
  'SELECT name, age FROM person WHERE name = ?',
  personRead,
  Write.string,
);

final countAll = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique();

// ---------------------------------------------------------------------------
// Program
// ---------------------------------------------------------------------------

ConnectionIO<Unit> program() {
  final setup = createPersonTable.run().productR<int>(createItemTable.run());

  final seed = insertPerson.runMany([
    const Person('Alice', 30),
    const Person('Bob', 25),
    const Person('Carol', 35),
    const Person('Dave', 28),
  ]);

  final insertItems = insertItemReturning
      .runMany(ilist(['Widget', 'Gadget', 'Doohickey']))
      .flatMap<Unit>((ids) => ConnectionIO.lift(IO.print('Item IDs: ${ids.toList()}')));

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

  return setup
      .productR<Unit>(seed)
      .productR<Unit>(insertItems)
      .productR<Unit>(printAll)
      .productR<Unit>(printOlderThan27)
      .productR<Unit>(findAlice);
}

// ---------------------------------------------------------------------------
// Rollback demo — runs as a separate IO so xa is in scope
// ---------------------------------------------------------------------------

IO<Unit> rollbackDemo(Transactor xa) {
  final insertAndFail = insertPerson
      .run(const Person('Rollback', 99))
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
// Streaming — keeps the connection open for the lifetime of the Rill
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
  await SqliteTransactor.memory().use((Transactor xa) {
    return program()
        .transact(xa)
        .productR<Unit>(streamExample(xa))
        .productR<Unit>(rollbackDemo(xa));
  }).unsafeRunFuture();
}
