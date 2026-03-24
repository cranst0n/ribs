import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
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

    test('unique errors when 0 rows returned', () async {
      final result =
          await ('SELECT name FROM person WHERE name = '.fr + Fragment.param('Ghost', Put.string))
              .query(Read.string)
              .unique()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
    });

    test('unique errors when multiple rows returned', () async {
      final result =
          await 'SELECT name FROM person'
              .query(Read.string)
              .unique()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
    });

    test('option errors when multiple rows returned', () async {
      final result =
          await 'SELECT name FROM person'
              .query(Read.string)
              .option()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
    });

    test('nel returns NonEmptyIList', () async {
      final result =
          await 'SELECT name FROM person ORDER BY name'
              .query(Read.string)
              .nel()
              .transact(xa)
              .unsafeRunFuture();

      expect(result.head, equals('Alice'));
      expect(result.toIList().length, equals(3));
    });

    test('nel errors when 0 rows returned', () async {
      final result =
          await ('SELECT name FROM person WHERE name = '.fr + Fragment.param('Ghost', Put.string))
              .query(Read.string)
              .nel()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
    });

    test('ivector returns all rows', () async {
      final people =
          await 'SELECT name FROM person ORDER BY name'
              .query(Read.string)
              .ivector()
              .transact(xa)
              .unsafeRunFuture();

      expect(people.size, equals(3));
      expect(people[0], equals('Alice'));
    });

    test('invalid SQL raises an error', () async {
      final result =
          await 'NOT VALID SQL !!!!'
              .query(Read.integer)
              .ilist()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
    });

    test('Read.map transforms values', () async {
      final upper =
          await 'SELECT name FROM person ORDER BY name'
              .query(Read.string.map((s) => s.toUpperCase()))
              .ilist()
              .transact(xa)
              .unsafeRunFuture();

      expect(upper.head, equals('ALICE'));
    });

    test('Read.emap errors for invalid decoded value', () async {
      final alwaysFails = Read.integer.emap((_) => Either.left<String, int>('always fails'));

      final result =
          await 'SELECT age FROM person'
              .query(alwaysFails)
              .ilist()
              .transact(xa)
              .attempt()
              .unsafeRunFuture();

      expect(result.isLeft, isTrue);
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

  group('Transaction rollback', () {
    setUp(() async {
      await _createTable().transact(xa).unsafeRunFuture();
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

    test('connection is returned to pool after successful transaction', () async {
      await 'SELECT 1'.query(Read.integer).unique().transact(poolXa).unsafeRunFuture();
      // Would hang forever if the connection was not returned.
      await 'SELECT 1'.query(Read.integer).unique().transact(poolXa).unsafeRunFuture();
    });

    test('connection is returned to pool after failed transaction', () async {
      await ConnectionIO.raiseError<Unit>(
        Exception('boom'),
      ).transact(poolXa).attempt().unsafeRunFuture();
      // Would block if the connection leaked on error.
      await 'SELECT 1'.query(Read.integer).unique().transact(poolXa).unsafeRunFuture();
    });

    test('connection is returned to pool after fiber cancellation', () async {
      final acquired = await Deferred.of<Unit>().unsafeRunFuture();

      final fiber =
          await ConnectionIO.lift(
            acquired.complete(Unit()),
          ).flatMap((_) => ConnectionIO.never<Unit>()).transact(poolXa).start().unsafeRunFuture();

      await acquired.value().unsafeRunFuture(); // wait until fiber holds the connection
      await fiber.cancel().unsafeRunFuture();

      // Would block if cancellation didn't return the lease to the pool.
      await 'SELECT 1'.query(Read.integer).unique().transact(poolXa).unsafeRunFuture();
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

    test('streamQuery works with pool transactor', () async {
      await _createTable().transact(poolXa).unsafeRunFuture();
      await _insertPeople().transact(poolXa).unsafeRunFuture();

      final rill = 'SELECT name FROM person ORDER BY name'.query(Read.string).stream().transact(poolXa);

      final names = await rill.compile.toIList.unsafeRunFuture();

      expect(names.length, equals(3));
      expect(names.head, equals('Alice'));
    });

    test('multiple readers can operate concurrently', () async {
      final r1Acquired = await Deferred.of<Unit>().unsafeRunFuture();
      final r2Acquired = await Deferred.of<Unit>().unsafeRunFuture();
      final proceed = await Deferred.of<Unit>().unsafeRunFuture();

      // Fiber 1: hold reader 1 until 'proceed' fires.
      final fiber1 =
          await poolXa
              .connectReader()
              .use((conn) {
                return r1Acquired.complete(Unit()).flatMap((_) => proceed.value());
              })
              .start()
              .unsafeRunFuture();

      // Fiber 2: hold reader 2 until 'proceed' fires.
      final fiber2 =
          await poolXa
              .connectReader()
              .use((conn) {
                return r2Acquired.complete(Unit()).flatMap((_) => proceed.value());
              })
              .start()
              .unsafeRunFuture();

      // Both readers must be acquired while fiber 1 still holds its connection.
      await r1Acquired.value().unsafeRunFuture();
      await r2Acquired.value().unsafeRunFuture(); // would block if readers were serialized

      await proceed.complete(Unit()).unsafeRunFuture();
      await fiber1.join().unsafeRunFuture();
      await fiber2.join().unsafeRunFuture();
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

    test('Read.optional returns None for a null column', () async {
      await 'CREATE TABLE nullable_demo (id INTEGER PRIMARY KEY, label TEXT)'
          .update0
          .run()
          .transact(xa)
          .unsafeRunFuture();

      await 'INSERT INTO nullable_demo (id) VALUES (1)'.update0.run().transact(xa).unsafeRunFuture();

      final result =
          await 'SELECT label FROM nullable_demo WHERE id = 1'
              .query(Read.string.optional())
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(result, isNone());
    });

    test('Write.optional inserts None as null and Some as a value', () async {
      await 'CREATE TABLE nullable_write (id INTEGER PRIMARY KEY, label TEXT)'
          .update0
          .run()
          .transact(xa)
          .unsafeRunFuture();

      await 'INSERT INTO nullable_write (id, label) VALUES (?, ?)'
          .update((Write.integer, Write.string.optional()).tupled)
          .run((1, none<String>()))
          .transact(xa)
          .unsafeRunFuture();

      await 'INSERT INTO nullable_write (id, label) VALUES (?, ?)'
          .update((Write.integer, Write.string.optional()).tupled)
          .run((2, const Some('hello')))
          .transact(xa)
          .unsafeRunFuture();

      final nullRow =
          await 'SELECT label FROM nullable_write WHERE id = 1'
              .query(Read.string.optional())
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      final someRow =
          await 'SELECT label FROM nullable_write WHERE id = 2'
              .query(Read.string.optional())
              .unique()
              .transact(xa)
              .unsafeRunFuture();

      expect(nullRow, isNone());
      expect(someRow, isSome<String>());
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

    test('persists data and closes the connection on release', () async {
      await SqliteTransactor.file(dbPath).use((fileXa) {
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
      }).unsafeRunFuture();
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
