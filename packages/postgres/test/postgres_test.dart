import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
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
    test('create table', () {
      expect(_createTable().transact(xa), ioSucceeded());
    });
  });

  group('Update / Insert', () {
    setUp(() async {
      await _resetTable().transact(xa).unsafeRunFuture();
    });

    test('insert single row', () {
      final rows = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('Alice', 30))
          .transact(xa);

      expect(rows, ioSucceeded(1));
    });

    test('insert many rows', () {
      final people = [('Alice', 30), ('Bob', 25), ('Carol', 35)];

      final insertMany = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .runMany(people)
          .transact(xa);

      expect(insertMany, ioSucceeded());
    });
  });

  group('Query', () {
    setUp(() async {
      await _resetTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
    });

    test('ilist returns all rows', () {
      final people = 'SELECT name, age FROM person'
          .query((Read.string, Read.integer).tupled)
          .ilist()
          .transact(xa);

      expect(people, ioSucceeded(hasLength(3)));
    });

    test('unique returns exactly one row', () {
      final test = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Alice', Put.string))
          .query((Read.string, Read.integer).tupled)
          .unique()
          .transact(xa);

      expect(test, ioSucceeded(('Alice', 30)));
    });

    test('option returns Some for existing row', () {
      final result = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Alice', Put.string))
          .query((Read.string, Read.integer).tupled)
          .option()
          .transact(xa);

      expect(result, ioSucceeded(isSome()));
    });

    test('option returns None for missing row', () {
      final result = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Nobody', Put.string))
          .query((Read.string, Read.integer).tupled)
          .option()
          .transact(xa);

      expect(result, ioSucceeded(isNone()));
    });
  });

  group('ParameterizedQuery', () {
    setUp(() async {
      await _resetTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
    });

    test('unique with params', () {
      final byName = ParameterizedQuery(
        'SELECT name, age FROM person WHERE name = ?',
        (Read.string, Read.integer).tupled,
        Write.string,
      );

      expect(
        byName.unique('Bob').transact(xa),
        ioSucceeded(('Bob', 25)),
      );
    });

    test('ilist with params filters correctly', () {
      final byMinAge = ParameterizedQuery(
        'SELECT name FROM person WHERE age >= ? ORDER BY name',
        Read.string,
        Write.integer,
      );

      expect(
        byMinAge.ilist(30).transact(xa),
        ioSucceeded(hasLength(2)),
      );
    });
  });

  group('ConnectionRill / stream', () {
    setUp(() async {
      await _resetTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
    });

    test('stream returns all rows via Rill', () {
      final rill = 'SELECT name, age FROM person'
          .query((Read.string, Read.integer).tupled)
          .stream()
          .transact(xa);

      expect(
        rill.compile.toIList,
        ioSucceeded(hasLength(3)),
      );
    });

    test('ParameterizedQuery.stream with params', () {
      final byMinAge = 'SELECT name FROM person WHERE age >= ? ORDER BY name'.parmeteriedQuery(
        Read.string,
        Write.integer,
      );

      expect(
        byMinAge.stream(30).transact(xa).compile.toIList,
        ioSucceeded(hasLength(2)),
      );
    });
  });

  group('UpdateReturning', () {
    setUp(() async {
      await _resetTableWithId().transact(xa).unsafeRunFuture();
    });

    test('insert returning id', () {
      final id = 'INSERT INTO item (label) VALUES (?) RETURNING id'
          .updateReturning(Write.string, Read.integer)
          .run('Widget')
          .transact(xa);

      expect(id, ioSucceeded(greaterThan(0)));
    });

    test('insert many returning ids', () {
      final ids = 'INSERT INTO item (label) VALUES (?) RETURNING id'
          .updateReturning(Write.string, Read.integer)
          .runMany(ilist(['Alpha', 'Beta', 'Gamma']))
          .transact(xa);

      expect(ids, ioSucceeded(hasLength(3)));
    });
  });

  group('Transaction rollback', () {
    setUp(() async {
      await _resetTable().transact(xa).unsafeRunFuture();
    });

    test('rolls back on error', () {
      final insert =
          'INSERT INTO person (name, age) VALUES (?, ?)'
              .update((Write.string, Write.integer).tupled)
              .run(('Rollback', 42))
              .flatMap((_) => ConnectionIO.raiseError<Unit>(Exception('boom')))
              .transact(xa)
              .attempt();

      final count = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique().transact(xa);

      expect(
        insert.productR(() => count),
        ioSucceeded(0),
      );
    });

    test('rolls back on fiber cancellation', () {
      final insert = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('Rollback', 42))
          .flatMap((_) => ConnectionIO.never<Unit>())
          .transact(xa);

      final canceledInsert = insert.start().flatMap((fiber) => fiber.cancel());

      final count = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique().transact(xa);

      expect(
        canceledInsert.productR(() => count),
        ioSucceeded(0),
      );
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

    test('connection is returned to pool after successful transaction', () {
      final select1 = 'SELECT 1'.query(Read.integer).unique().transact(singleXa);

      expect(
        // Would hang forever if the connection was not returned.
        select1.productR(() => select1),
        ioSucceeded(),
      );
    });

    test('connection is returned to pool after failed transaction', () {
      final raise = ConnectionIO.raiseError<Unit>(Exception('boom')).transact(singleXa).attempt();

      final select1 = 'SELECT 1'.query(Read.integer).unique().transact(singleXa);

      expect(
        // Would block if the connection leaked on error.
        raise.productR(() => select1),
        ioSucceeded(),
      );
    });

    test('connection is returned to pool after fiber cancellation', () {
      final test = Deferred.of<Unit>().flatMap((acquired) {
        return ConnectionIO.lift(
          acquired.complete(Unit()),
        ).flatMap((_) => ConnectionIO.never<Unit>()).transact(singleXa).start().flatMap((fiber) {
          return acquired.value().productR(() => fiber.cancel()).productR(() {
            // Would block if cancellation didn't trigger the signalDone Completer.
            return 'SELECT 1'.query(Read.integer).unique().transact(singleXa);
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test(
      'connection is returned to pool after stream query fiber cancellation',
      () async {
        // A streaming query that blocks for 30 s server-side, holding the pool's
        // sole connection for the duration unless the fiber is cancelled first.
        final fiber =
            await 'SELECT pg_sleep(30)::text'
                .query(Read.string)
                .stream()
                .transact(singleXa)
                .compile
                .drain
                .start()
                .unsafeRunFuture();

        // Wait briefly so the connection is acquired and the query is executing.
        await IO.sleep(const Duration(milliseconds: 200)).unsafeRunFuture();

        await fiber.cancel().unsafeRunFuture();

        // With pool size 1, this would hang forever if the connection was not
        // returned via the Rill.resource cleanup path.
        final value =
            await 'SELECT 1'.query(Read.integer).unique().transact(singleXa).unsafeRunFuture();

        expect(value, equals(1));
      },
      skip: 'TBD',
    );

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

    test('string roundtrip', () {
      final insert = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('NoNick', 99))
          .transact(xa);

      final result = ('SELECT name FROM person WHERE name = '.fr +
              Fragment.param('NoNick', Put.string))
          .query(Read.string)
          .unique()
          .transact(xa);

      expect(
        insert.productR(() => result),
        ioSucceeded('NoNick'),
      );
    });
  });
}

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
