import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/src/sqlite_rill.dart';
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';

/// A [Transactor] backed by a SQLite connection pool via the
/// `sqlite3_connection_pool` package.
///
/// [transact] acquires a writer connection from the pool, wraps the
/// [ConnectionIO] in a SQLite transaction (BEGIN/COMMIT/ROLLBACK), then
/// returns the connection to the pool. [stream] acquires a reader connection
/// so reads can proceed concurrently with other operations.
///
/// Intended for file-based databases. Using an in-memory database with a pool
/// is not supported because each connection is an isolated in-memory instance.
///
/// Example:
/// ```dart
/// final pool = SqliteConnectionPool.open(
///   name: '/path/to/my.db',
///   openConnections: () {
///     Database open(bool write) {
///       final db = sqlite3.open('/path/to/my.db');
///       db.execute('PRAGMA journal_mode = WAL;');
///       if (!write) db.execute('PRAGMA query_only = true;');
///       return db;
///     }
///     return PoolConnections(open(true), [for (var i = 0; i < 4; i++) open(false)]);
///   },
/// );
///
/// await SqlitePoolTransactor.create(pool).use((xa) {
///   // use xa here
/// });
/// ```
final class SqlitePoolTransactor extends Transactor {
  final SqliteConnectionPool _pool;

  SqlitePoolTransactor._(this._pool, super.strategy);

  /// Creates a [Resource] wrapping a [SqlitePoolTransactor] that owns [pool].
  /// The pool is closed when the [Resource] is released.
  static Resource<Transactor> create(
    SqliteConnectionPool pool, {
    Strategy? strategy,
  }) => Resource.make(
    IO.pure(SqlitePoolTransactor._(pool, strategy)),
    (_) => IO.exec(pool.close),
  );

  @override
  Resource<SqlConnection> connect() {
    return Resource.make(
      _acquireWriter(),
      (lease) => IO.exec(lease.returnLease),
    ).map(_SqliteLeaseConnection.new);
  }

  @override
  Resource<SqlConnection> connectReader() {
    return Resource.make(
      _acquireReader(),
      (lease) => IO.exec(lease.returnLease),
    ).map(_SqliteLeaseConnection.new);
  }

  IO<ConnectionLease> _acquireWriter() => IO.async((cb) {
    final abort = Completer<void>();

    _pool
        .writer(abortSignal: abort.future)
        .then(
          (lease) => cb(Right(lease)),
          onError: (Object err) => cb(Left(err)),
        );

    return IO.pure(
      Some(
        IO.exec(() {
          if (!abort.isCompleted) abort.complete();
        }),
      ),
    );
  });

  IO<ConnectionLease> _acquireReader() => IO.async((cb) {
    final abort = Completer<void>();

    _pool
        .reader(abortSignal: abort.future)
        .then(
          (lease) => cb(Right(lease)),
          onError: (Object err) => cb(Left(err)),
        );

    return IO.pure(
      Some(
        IO.exec(() {
          if (!abort.isCompleted) abort.complete();
        }),
      ),
    );
  });
}

/// [SqlConnection] backed by a [ConnectionLease] from [SqliteConnectionPool].
///
/// [close] returns the lease to the pool — do not call the underlying
/// sqlite3 [Database.close] directly.
final class _SqliteLeaseConnection extends SqlConnection {
  final ConnectionLease _lease;

  _SqliteLeaseConnection(this._lease);

  @override
  IO<IList<Row>> executeQuery(String sql, StatementParameters params) => IO
      .fromFutureF(() => _lease.select(sql, params.toList))
      .map((tuple) => tuple.$1)
      .map((rs) => rs.map((sqliteRow) => Row(sqliteRow.values.toIList())).toIList());

  @override
  IO<int> executeUpdate(String sql, StatementParameters params) =>
      IO.fromFutureF(() => _lease.execute(sql, params.toList)).map((res) => res.changes);

  @override
  Rill<Row> streamQuery(String sql, StatementParameters params) {
    return Rill.bracket(
      IO.delay(() => _lease.unsafeRawDatabase.prepare(sql)),
      (stmt) => IO.exec(() => stmt.close()),
    ).flatMap((stmt) => rillFromSqliteCursor(stmt.selectCursor(params.toList)));
  }

  @override
  IO<Unit> close() => IO.exec(_lease.returnLease);
}
