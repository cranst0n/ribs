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
/// final xa = SqlitePoolTransactor(pool);
/// ```
final class SqlitePoolTransactor implements Transactor {
  final SqliteConnectionPool _pool;

  const SqlitePoolTransactor(this._pool);

  @override
  Resource<SqlConnection> connection() => Resource.make(
    IO.fromFutureF(() async => _SqliteLeaseConnection(await _pool.writer())),
    (conn) => conn.close(),
  );

  @override
  IO<A> transact<A>(ConnectionIO<A> cio) => IO.fromFutureF(() => _pool.writer()).bracket((lease) {
    final conn = _SqliteLeaseConnection(lease);
    IO<Unit> leaseExecute(String sql) => IO.fromFutureF(() => lease.execute(sql)).voided();

    return leaseExecute('BEGIN')
        .productR(() => cio.run(conn))
        .productL(() => leaseExecute('COMMIT'))
        .handleErrorWith((err) => leaseExecute('ROLLBACK').productR(() => IO.raiseError(err)));
  }, (lease) => IO.exec(lease.returnLease));

  @override
  Rill<A> stream<A>(Query<A> query) {
    return Rill.bracket(
      IO.fromFutureF(() => _pool.reader()).map(_SqliteLeaseConnection.new),
      (conn) => conn.close(),
    ).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}

/// [SqlConnection] backed by a [ConnectionLease] from [SqliteConnectionPool].
///
/// [close] returns the lease to the pool — do not call the underlying
/// sqlite3 [Database.close] directly.
final class _SqliteLeaseConnection implements SqlConnection {
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
