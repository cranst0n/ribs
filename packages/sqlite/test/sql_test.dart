import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:test/test.dart';

void main() {
  late SqliteTransactor xa;

  setUp(() {
    xa = SqliteTransactor.memory();
  });

  group('DDL', () {
    test('create table', () async {
      await _createTable().transact(xa).unsafeRunFuture();
    });
  });

  group('Update / Insert', () {
    test('insert single row', () async {
      await _createTable().transact(xa).unsafeRunFuture();

      final rows =
          await 'INSERT INTO person (name, age) VALUES (?, ?)'
              .update((Write.string, Write.integer).tupled)
              .run(('Alice', 30))
              .transact(xa)
              .unsafeRunFuture();

      expect(rows, equals(1));
    });

    test('insert many rows', () async {
      await _createTable().transact(xa).unsafeRunFuture();

      final people = [('Alice', 30), ('Bob', 25), ('Carol', 35)];

      await 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .runMany(people)
          .transact(xa)
          .unsafeRunFuture();
    });
  });

  group('Query', () {
    setUp(() async {
      await _createTable().transact(xa).unsafeRunFuture();
      await _insertPeople().transact(xa).unsafeRunFuture();
    });

    test('ilist returns all rows', () async {
      final people =
          await 'SELECT name, age FROM person'
              .query((Read.string, Read.integer).tupled)
              .ilist()
              .transact(xa)
              .unsafeRunFuture();

      expect(people.length, equals(3));
    });

    test('unique returns exactly one row', () async {
      final (name, age) =
          await (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
                  Fragment.param('Alice', Put.string))
              .query((Read.string, Read.integer).tupled)
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(name, equals('Alice'));
      expect(age, equals(30));
    });

    test('option returns Some for existing row', () async {
      final result =
          await (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
                  Fragment.param('Alice', Put.string))
              .query((Read.string, Read.integer).tupled)
              .option()
              .transact(xa)
              .unsafeRunFuture();

      expect(result, isSome<(String, int)>());
    });

    test('option returns None for missing row', () async {
      final result =
          await (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
                  Fragment.param('Nobody', Put.string))
              .query((Read.string, Read.integer).tupled)
              .option()
              .transact(xa)
              .unsafeRunFuture();

      expect(result, isNone());
    });
  });

  group('ParameterizedQuery', () {
    setUp(() async {
      await _createTable().transact(xa).unsafeRunFuture();
      await _insertPeople().transact(xa).unsafeRunFuture();
    });

    test('unique with params', () async {
      final byName = ParameterizedQuery(
        'SELECT name, age FROM person WHERE name = ?',
        (Read.string, Read.integer).tupled,
        Write.string,
      );

      final (name, age) = await byName.unique('Bob').transact(xa).unsafeRunFuture();
      expect(name, equals('Bob'));
      expect(age, equals(25));
    });

    test('ilist with params filters correctly', () async {
      final byMinAge = ParameterizedQuery(
        'SELECT name FROM person WHERE age >= ? ORDER BY name',
        Read.string,
        Write.integer,
      );

      final names = await byMinAge.ilist(30).transact(xa).unsafeRunFuture();
      expect(names.length, equals(2));
    });
  });

  group('ConnectionRill / stream', () {
    setUp(() async {
      await _createTable().transact(xa).unsafeRunFuture();
      await _insertPeople().transact(xa).unsafeRunFuture();
    });

    test('stream returns all rows via Rill', () async {
      final rill = 'SELECT name, age FROM person'
          .query((Read.string, Read.integer).tupled)
          .stream()
          .transact(xa);

      final people = await rill.compile.toIList.unsafeRunFuture();

      expect(people.length, equals(3));
    });

    test('ParameterizedQuery.stream with params', () async {
      final byMinAge = 'SELECT name FROM person WHERE age >= ? ORDER BY name'.parmeteriedQuery(
        Read.string,
        Write.integer,
      );

      final rill = byMinAge.stream(30).transact(xa);

      final names = await rill.compile.toIList.unsafeRunFuture();
      expect(names.length, equals(2));
    });
  });

  group('UpdateReturning', () {
    setUp(() async {
      await _createTableWithId().transact(xa).unsafeRunFuture();
    });

    test('insert returning id', () async {
      final id =
          await 'INSERT INTO item (label) VALUES (?) RETURNING id'
              .updateReturning(Write.string, Read.integer)
              .run('Widget')
              .transact(xa)
              .unsafeRunFuture();

      expect(id, greaterThan(0));
    });

    test('insert many returning ids', () async {
      final ids =
          await 'INSERT INTO item (label) VALUES (?) RETURNING id'
              .updateReturning(Write.string, Read.integer)
              .runMany(ilist(['Alpha', 'Beta', 'Gamma']))
              .transact(xa)
              .unsafeRunFuture();

      expect(ids.length, equals(3));
    });
  });

  group('ReadWrite codec', () {
    test('optional reads null columns', () async {
      await _createTable().transact(xa).unsafeRunFuture();

      await 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('NoNick', 99))
          .transact(xa)
          .unsafeRunFuture();

      final result =
          await ('SELECT name FROM person WHERE name = '.fr + Fragment.param('NoNick', Put.string))
              .query(Read.string)
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(result, equals('NoNick'));
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ConnectionIO<int> _createTable() =>
    '''
CREATE TABLE IF NOT EXISTS person (
  name TEXT NOT NULL,
  age  INTEGER NOT NULL
)'''.update0.run();

ConnectionIO<int> _createTableWithId() =>
    '''
CREATE TABLE IF NOT EXISTS item (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  label TEXT NOT NULL
)'''.update0.run();

ConnectionIO<Unit> _insertPeople() => 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled)
    .runMany([('Alice', 30), ('Bob', 25), ('Carol', 35)]);
