import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart' as sq;
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';
import 'package:test/test.dart';

void main() {
  late Transactor xa;
  late IO<Unit> release;

  setUp(() async {
    (xa, release) = await SqliteTransactor.memory().allocated().unsafeRunFuture();
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
      await _createTable().transact(xa).unsafeRunFuture();
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

      final test = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .runMany(people)
          .transact(xa);

      expect(test, ioSucceeded());
    });
  });

  group('Query', () {
    setUp(() async {
      await _createTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
    });

    test('ilist returns all rows', () {
      final people = 'SELECT name, age FROM person'
          .query((Read.string, Read.integer).tupled)
          .ilist()
          .transact(xa);

      expect(people, ioSucceeded(hasLength(3)));
    });

    test('unique returns exactly one row', () {
      final result = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Alice', Put.string))
          .query((Read.string, Read.integer).tupled)
          .unique()
          .transact(xa);

      expect(result, ioSucceeded(('Alice', 30)));
    });

    test('option returns Some for existing row', () {
      final result = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Alice', Put.string))
          .query((Read.string, Read.integer).tupled)
          .option()
          .transact(xa);

      expect(result, ioSucceeded(isSome(('Alice', 30))));
    });

    test('option returns None for missing row', () {
      final result = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
              Fragment.param('Nobody', Put.string))
          .query((Read.string, Read.integer).tupled)
          .option()
          .transact(xa);

      expect(result, ioSucceeded(isNone()));
    });

    test('unique errors when 0 rows returned', () {
      final result =
          ('SELECT name FROM person WHERE name = '.fr + Fragment.param('Ghost', Put.string))
              .query(Read.string)
              .unique()
              .transact(xa)
              .attempt();

      expect(result, ioSucceeded(isLeft()));
    });

    test('unique errors when multiple rows returned', () {
      final result = 'SELECT name FROM person'.query(Read.string).unique().transact(xa).attempt();

      expect(result, ioSucceeded(isLeft()));
    });

    test('option errors when multiple rows returned', () {
      final result = 'SELECT name FROM person'.query(Read.string).option().transact(xa).attempt();

      expect(result, ioSucceeded(isLeft()));
    });

    test('nel returns NonEmptyIList', () {
      final result = 'SELECT name FROM person ORDER BY name'.query(Read.string).nel().transact(xa);

      expect(result, ioSucceeded(nel('Alice', ['Bob', 'Carol'])));
    });

    test('nel errors when 0 rows returned', () {
      final result =
          ('SELECT name FROM person WHERE name = '.fr + Fragment.param('Ghost', Put.string))
              .query(Read.string)
              .nel()
              .transact(xa)
              .attempt();

      expect(result, ioSucceeded(isLeft()));
    });

    test('ivector returns all rows', () {
      final people = 'SELECT name FROM person ORDER BY name'
          .query(Read.string)
          .ivector()
          .transact(xa);

      expect(people, ioSucceeded(ivec(['Alice', 'Bob', 'Carol'])));
    });

    test('invalid SQL raises an error', () {
      final result = 'NOT VALID SQL !!!!'.query(Read.integer).ilist().transact(xa).attempt();

      expect(result, ioSucceeded(isLeft()));
    });

    test('Read.map transforms values', () {
      final upper = 'SELECT name FROM person ORDER BY name'
          .query(Read.string.map((s) => s.toUpperCase()))
          .ilist()
          .transact(xa);

      expect(upper, ioSucceeded(ivec(['ALICE', 'BOB', 'CAROL'])));
    });

    test('Read.emap errors for invalid decoded value', () {
      final alwaysFails = Read.integer.emap((_) => Either.left<String, int>('always fails'));
      final result = 'SELECT age FROM person'.query(alwaysFails).ilist().transact(xa).attempt();

      expect(result, ioSucceeded(isLeft()));
    });
  });

  group('ParameterizedQuery', () {
    setUp(() async {
      await _createTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
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
      await _createTable().productR(() => _insertPeople()).transact(xa).unsafeRunFuture();
    });

    test('stream returns all rows via Rill', () {
      final rill = 'SELECT name, age FROM person'
          .query((Read.string, Read.integer).tupled)
          .stream()
          .transact(xa);

      expect(rill.compile.toIList, ioSucceeded(hasLength(3)));
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
      await _createTableWithId().transact(xa).unsafeRunFuture();
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
      await _createTable().transact(xa).unsafeRunFuture();
    });

    test('rolls back on error', () {
      final insertAndRollback =
          'INSERT INTO person (name, age) VALUES (?, ?)'
              .update((Write.string, Write.integer).tupled)
              .run(('Rollback', 42))
              .flatMap((_) => ConnectionIO.raiseError<Unit>(Exception('boom')))
              .transact(xa)
              .attempt();

      final count = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique().transact(xa);

      expect(
        insertAndRollback.productR(() => count),
        ioSucceeded(0),
      );
    });

    test('rolls back on fiber cancellation', () {
      final insertAndHang = 'INSERT INTO person (name, age) VALUES (?, ?)'
          .update((Write.string, Write.integer).tupled)
          .run(('Rollback', 42))
          .flatMap((_) => ConnectionIO.never<Unit>())
          .transact(xa);

      final insertAndCancel = insertAndHang.start().flatMap((fiber) => fiber.cancel());

      final count = 'SELECT COUNT(*) FROM person'.query(Read.integer).unique().transact(xa);

      expect(
        insertAndCancel.productR(() => count),
        ioSucceeded(0),
      );
    });
  });

  group('Connection lifecycle', () {
    late Transactor poolXa;
    late IO<Unit> releasePoolXa;
    late File dbFile;

    setUp(() async {
      dbFile = File(
        '${Directory.systemTemp.path}/ribs_sqlite_test_${DateTime.now().microsecondsSinceEpoch}.db',
      );

      final pool = SqliteConnectionPool.open(
        name: dbFile.path,
        openConnections: () {
          sq.Database open(bool write) {
            final db = sq.sqlite3.open(dbFile.path);
            db.execute('PRAGMA journal_mode = WAL;');
            if (!write) db.execute('PRAGMA query_only = true;');
            return db;
          }

          return PoolConnections(open(true), [open(false), open(false)]);
        },
      );

      (poolXa, releasePoolXa) =
          await SqlitePoolTransactor.create(pool).allocated().unsafeRunFuture();
    });

    tearDown(() async {
      await releasePoolXa.unsafeRunFuture();
      if (dbFile.existsSync()) dbFile.deleteSync();
    });

    test('connection is returned to pool after successful transaction', () {
      final select1 = 'SELECT 1'.query(Read.integer).unique().transact(poolXa);

      // Would hang forever if the connection was not returned.
      expect(select1.productR(() => select1), ioSucceeded());
    });

    test('connection is returned to pool after failed transaction', () {
      final raise = ConnectionIO.raiseError<Unit>(Exception('boom')).transact(poolXa).attempt();
      final select1 = 'SELECT 1'.query(Read.integer).unique().transact(poolXa);

      // Would block if the connection leaked on error.
      expect(raise.productR(() => select1), ioSucceeded());
    });

    test('connection is returned to pool after fiber cancellation', () {
      final test = Deferred.of<Unit>().flatMap((acquired) {
        return ConnectionIO.lift(acquired.complete(Unit()))
            .productR(() => ConnectionIO.never<Unit>())
            .transact(poolXa)
            .start()
            .flatMap((fiber) => acquired.value().productR(() => fiber.cancel()))
            // Would block if cancellation didn't return the lease to the pool.
            .productR(() => 'SELECT 1'.query(Read.integer).unique().transact(poolXa));
      });

      expect(test, ioSucceeded());
    });

    test('writer connection is held for the duration of a transaction', () async {
      final acquired = await Deferred.of<Unit>().unsafeRunFuture();
      final proceed = await Deferred.of<Unit>().unsafeRunFuture();
      final writerAcquired2 = await Deferred.of<Unit>().unsafeRunFuture();

      // Fiber 1: signal 'acquired' once it holds the writer, then wait for 'proceed'.
      final fiber1 =
          await ConnectionIO.lift(acquired.complete(Unit()))
              .flatMap((_) => ConnectionIO.lift(proceed.value()))
              .transact(poolXa)
              .start()
              .unsafeRunFuture();

      await acquired.value().unsafeRunFuture(); // fiber 1 now holds the sole writer

      // Fiber 2: blocks on writer acquisition; signals 'writerAcquired2' only once it gets it.
      final fiber2 =
          await ConnectionIO.lift(
            writerAcquired2.complete(Unit()),
          ).transact(poolXa).start().unsafeRunFuture();

      // Race: fiber 2 signalling vs. a short sleep.
      // Sleep must win because fiber 2 cannot acquire the writer while fiber 1 holds it.
      final raceResult =
          await IO
              .race(
                writerAcquired2.value(),
                IO.sleep(const Duration(milliseconds: 300)),
              )
              .unsafeRunFuture();

      expect(raceResult.isRight, isTrue, reason: 'fiber 2 should be blocked by pool exhaustion');

      // Release fiber 1's writer — fiber 2 can now proceed normally.
      await proceed.complete(Unit()).unsafeRunFuture();
      await fiber1.join().unsafeRunFuture();

      // Fiber 2 acquires the writer, signals writerAcquired2, and finishes.
      await writerAcquired2.value().unsafeRunFuture();
      await fiber2.join().unsafeRunFuture();
    });

    test('streamQuery works with pool transactor', () {
      final setup = _createTable().productR(() => _insertPeople()).transact(poolXa);

      final rill =
          'SELECT name FROM person ORDER BY name'
              .query(Read.string)
              .stream()
              .transact(poolXa)
              .compile
              .toIList;

      final test = setup.productR(() => rill);

      expect(test, ioSucceeded(ilist(['Alice', 'Bob', 'Carol'])));
    });

    test('multiple readers can operate concurrently', () {
      final test = (Deferred.of<Unit>(), Deferred.of<Unit>(), Deferred.of<Unit>()).flatMapN((
        r1Acquired,
        r2Acquired,
        proceed,
      ) {
        // Fiber 1: hold reader 1 until 'proceed' fires.
        final runFiber1 =
            poolXa
                .connectReader()
                .use((conn) => r1Acquired.complete(Unit()).productR(() => proceed.value()))
                .start();

        // Fiber 2: hold reader 2 until 'proceed' fires.
        final runFiber2 =
            poolXa
                .connectReader()
                .use((conn) => r2Acquired.complete(Unit()).productR(() => proceed.value()))
                .start();

        return runFiber1.product(runFiber2).flatMapN((fiber1, fiber2) {
          // Both readers must be acquired while fiber 1 still holds its connection.
          return r1Acquired
              .value()
              .product(r2Acquired.value()) // would block if readers were serialized
              .voided()
              .product(proceed.complete(Unit()))
              .product(fiber1.join())
              .product(fiber2.join())
              .voided();
        });
      });

      expect(test, ioSucceeded());
    });
  });

  group('ReadWrite codec', () {
    test('optional reads null columns', () {
      final setup = _createTable().transact(xa);

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
        setup.product(insert).productR(() => result),
        ioSucceeded('NoNick'),
      );
    });

    test('Read.optional returns None for a null column', () {
      final setup = 'CREATE TABLE nullable_demo (id INTEGER PRIMARY KEY, label TEXT)'.update0
          .run()
          .transact(xa);

      final insert = 'INSERT INTO nullable_demo (id) VALUES (1)'.update0.run().transact(xa);

      final result = 'SELECT label FROM nullable_demo WHERE id = 1'
          .query(Read.string.optional())
          .unique()
          .transact(xa);

      expect(
        setup.product(insert).productR(() => result),
        ioSucceeded(isNone()),
      );
    });

    test('Write.optional inserts None as null and Some as a value', () {
      final setup = 'CREATE TABLE nullable_write (id INTEGER PRIMARY KEY, label TEXT)'.update0
          .run()
          .transact(xa);

      final insert1 = 'INSERT INTO nullable_write (id, label) VALUES (?, ?)'
          .update((Write.integer, Write.string.optional()).tupled)
          .run((1, none<String>()))
          .transact(xa);

      final insert2 = 'INSERT INTO nullable_write (id, label) VALUES (?, ?)'
          .update((Write.integer, Write.string.optional()).tupled)
          .run((2, const Some('hello')))
          .transact(xa);

      final nullRow = 'SELECT label FROM nullable_write WHERE id = 1'
          .query(Read.string.optional())
          .unique()
          .transact(xa);

      final someRow = 'SELECT label FROM nullable_write WHERE id = 2'
          .query(Read.string.optional())
          .unique()
          .transact(xa);

      final test = setup
          .productR(() => insert1)
          .productR(() => insert2)
          .productR(() => nullRow)
          .product(someRow);

      expect(test, ioSucceeded(const (None(), Some('hello'))));
    });
  });

  group('SqliteTransactor.file', () {
    late String dbPath;

    setUp(() {
      dbPath =
          '${Directory.systemTemp.path}/ribs_sqlite_file_test_${DateTime.now().microsecondsSinceEpoch}.db';
    });

    tearDown(() {
      final f = File(dbPath);
      if (f.existsSync()) f.deleteSync();
    });

    test('persists data and closes the connection on release', () {
      final test = SqliteTransactor.file(dbPath).use((fileXa) {
        return _createTable()
            .transact(fileXa)
            .productR(
              () => 'INSERT INTO person (name, age) VALUES (?, ?)'
                  .update((Write.string, Write.integer).tupled)
                  .run(('File Person', 42))
                  .transact(fileXa),
            )
            .productR(
              () => 'SELECT COUNT(*) FROM person'.query(Read.integer).unique().transact(fileXa),
            )
            .flatMap((count) => IO.exec(() => expect(count, equals(1))));
      });

      expect(test, ioSucceeded());
    });
  });
}

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
