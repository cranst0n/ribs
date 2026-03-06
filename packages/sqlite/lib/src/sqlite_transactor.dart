import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/src/sqlite_connection.dart';
import 'package:sqlite3/sqlite3.dart';

/// A [Transactor] backed by an SQLite database via the `sqlite3` package.
///
/// Create one with [SqliteTransactor.memory] for an in-memory database or
/// [SqliteTransactor.file] for a file-based database.
///
/// Example:
/// ```dart
/// final xa = SqliteTransactor.memory();
///
/// await 'CREATE TABLE person (id INTEGER PRIMARY KEY, name TEXT NOT NULL)'
///     .update0
///     .run()
///     .transact(xa)
///     .unsafeRunFuture();
///
/// final people = await 'SELECT id, name FROM person'
///     .query((Read.integer, Read.string).tupled)
///     .ilist()
///     .transact(xa)
///     .unsafeRunFuture();
/// ```
final class SqliteTransactor implements Transactor {
  /// The connection resource. For in-memory databases this is a shared
  /// persistent connection (using [Resource.pure]) so the database survives
  /// across multiple [transact] calls. For file-based databases a fresh
  /// connection is opened and closed per transaction.
  final Resource<SqlConnection> _connection;

  SqliteTransactor._(this._connection);

  /// Creates a [SqliteTransactor] backed by a single shared in-memory SQLite
  /// database. The connection is opened once and reused for every [transact]
  /// call so schema and data persist across calls.
  factory SqliteTransactor.memory() {
    final conn = SqliteConnection(sqlite3.openInMemory());
    return SqliteTransactor._(Resource.pure(conn));
  }

  /// Creates a [SqliteTransactor] backed by the SQLite file at [path].
  /// A new connection is opened and closed for each [transact] call.
  factory SqliteTransactor.file(String path) => SqliteTransactor._(
    Resource.make(
      IO.delay(() => SqliteConnection(sqlite3.open(path))),
      (conn) => conn.close(),
    ),
  );

  @override
  Resource<SqlConnection> connection() => _connection;

  @override
  IO<A> transact<A>(ConnectionIO<A> cio) => _connection.use((conn) => cio.run(conn));

  @override
  Rill<A> stream<A>(Query<A> query) {
    return Rill.resource(_connection).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}
