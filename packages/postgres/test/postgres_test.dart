import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  late TestainersPostgresql container;
  late Transactor xa;
  late IO<Unit> release;

  setUpAll(() async {
    container = TestainersPostgresql();
    await container.start();
  });

  tearDownAll(() async {
    await container.stop();
  });

  setUp(() async {
    (xa, release) =
        await PostgresPoolTransactor.withEndpoints(
          [
            pg.Endpoint(
              host: 'localhost',
              port: container.port,
              database: container.database,
              username: container.username,
              password: container.password,
            ),
          ],
          settings: const pg.PoolSettings(sslMode: pg.SslMode.disable),
        ).allocated().unsafeRunFuture();
  });

  tearDown(() async {
    await release.unsafeRunFuture();
  });

  group('DDL', () {
    test('create table', () async {
      await _createTable().transact(xa).unsafeRunFuture();
    });
  });

  group('Update / Insert', () {
    setUp(() async {
      await _resetTable().transact(xa).unsafeRunFuture();
    });

    test('insert single row', () async {
      final rows =
          await 'INSERT INTO person (name, age) VALUES (?, ?)'
              .update((Write.string, Write.integer).tupled)
              .run(('Alice', 30))
              .transact(xa)
              .unsafeRunFuture();

      expect(rows, equals(1));
    });

    test('insert many rows', () async {
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
      await _resetTable().transact(xa).unsafeRunFuture();
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
      await _resetTable().transact(xa).unsafeRunFuture();
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
      await _resetTable().transact(xa).unsafeRunFuture();
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
      await _resetTableWithId().transact(xa).unsafeRunFuture();
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

  group('Transaction rollback', () {
    setUp(() async {
      await _resetTable().transact(xa).unsafeRunFuture();
    });

    test('rolls back on error', () async {
      final program = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('Rollback', 42))
          .flatMap((_) => ConnectionIO.raiseError<Unit>(Exception('boom')))
          .transact(xa);

      await program.attempt().unsafeRunFuture();

      final count =
          await 'SELECT COUNT(*) FROM person'
              .query(Read.integer)
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(count, equals(0));
    });

    test('rolls back on fiber cancellation', () async {
      final program = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('Rollback', 42))
          .flatMap((_) => ConnectionIO.never<Unit>())
          .transact(xa);

      await program.start().flatMap((fiber) => fiber.cancel()).unsafeRunFuture();

      final count =
          await 'SELECT COUNT(*) FROM person'
              .query(Read.integer)
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(count, equals(0));
    });
  });

  group('Connection lifecycle', () {
    late Transactor singleXa;
    late IO<Unit> releasePool;

    setUp(() async {
      (singleXa, releasePool) =
          await PostgresPoolTransactor.withEndpoints(
            [
              pg.Endpoint(
                host: 'localhost',
                port: container.port,
                database: container.database,
                username: container.username,
                password: container.password,
              ),
            ],
            settings: const pg.PoolSettings(
              sslMode: pg.SslMode.disable,
              maxConnectionCount: 1,
            ),
          ).allocated().unsafeRunFuture();
    });

    tearDown(() async {
      await releasePool.unsafeRunFuture();
    });

    test('connection is returned to pool after successful transaction', () async {
      await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();
      // Would hang forever if the connection was not returned.
      await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();
    });

    test('connection is returned to pool after failed transaction', () async {
      await ConnectionIO.raiseError<Unit>(
        Exception('boom'),
      ).transact(singleXa).attempt().unsafeRunFuture();
      // Would block if the connection leaked on error.
      await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();
    });

    test('connection is returned to pool after fiber cancellation', () async {
      final acquired = await Deferred.of<Unit>().unsafeRunFuture();

      final fiber =
          await ConnectionIO.lift(
            acquired.complete(Unit()),
          ).flatMap((_) => ConnectionIO.never<Unit>()).transact(singleXa).start().unsafeRunFuture();

      await acquired.value().unsafeRunFuture(); // wait until fiber holds the connection
      await fiber.cancel().unsafeRunFuture();

      // Would block if cancellation didn't trigger the signalDone Completer.
      await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();
    });

    test('connection is held for the duration of a transaction', () async {
      final acquired = await Deferred.of<Unit>().unsafeRunFuture();
      final proceed = await Deferred.of<Unit>().unsafeRunFuture();

      final fiber =
          await ConnectionIO.lift(acquired.complete(Unit()))
              .flatMap((_) => ConnectionIO.lift(proceed.value()))
              .transact(singleXa)
              .start()
              .unsafeRunFuture();

      await acquired.value().unsafeRunFuture(); // fiber now holds the sole connection

      // With pool size 1 exhausted, a second transaction must block.
      final blocked =
          await 'SELECT 1'
              .query(Read.integer)
              .unique()
              .transact(singleXa)
              .timeout(const Duration(milliseconds: 500))
              .attempt()
              .unsafeRunFuture();

      expect(
        blocked.isLeft,
        isTrue,
        reason: 'second transaction should be blocked by pool exhaustion',
      );

      // Release the connection.
      await proceed.complete(Unit()).unsafeRunFuture();
      await fiber.join().unsafeRunFuture();

      // Connection is back in the pool; this must now succeed.
      final value =
          await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();
      expect(value, equals(1));
    });
  });

  group('ReadWrite codec', () {
    setUp(() async {
      await _resetTable().transact(xa).unsafeRunFuture();
    });

    test('string roundtrip', () async {
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

ConnectionIO<Unit> _resetTable() =>
    'DROP TABLE IF EXISTS person'.update0.run().flatMap((_) => _createTable().map((_) => Unit()));

ConnectionIO<int> _createTable() =>
    '''
CREATE TABLE person (
  name TEXT NOT NULL,
  age  INTEGER NOT NULL
)'''.update0.run();

ConnectionIO<Unit> _resetTableWithId() => 'DROP TABLE IF EXISTS item'.update0.run().flatMap(
  (_) => _createTableWithId().map((_) => Unit()),
);

ConnectionIO<int> _createTableWithId() =>
    '''
CREATE TABLE item (
  id    SERIAL PRIMARY KEY,
  label TEXT NOT NULL
)'''.update0.run();

ConnectionIO<Unit> _insertPeople() => 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled)
    .runMany([('Alice', 30), ('Bob', 25), ('Carol', 35)]);
