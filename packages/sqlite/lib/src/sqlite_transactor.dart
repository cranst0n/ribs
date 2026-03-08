import 'package:ribs_effect/ribs_effect.dart';
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
/// await SqliteTransactor.memory().use((xa) async {
///   await 'CREATE TABLE person (id INTEGER PRIMARY KEY, name TEXT NOT NULL)'
///       .update0
///       .run()
///       .transact(xa)
///       .unsafeRunFuture();
///
///   final people = await 'SELECT id, name FROM person'
///       .query((Read.integer, Read.string).tupled)
///       .ilist()
///       .transact(xa)
///       .unsafeRunFuture();
/// }).unsafeRunFuture();
/// ```
final class SqliteTransactor extends Transactor {
  final SqlConnection _connection;

  SqliteTransactor._(this._connection, super.strategy);

  /// Creates a [Resource] wrapping a [SqliteTransactor] backed by a single
  /// shared in-memory SQLite database. The connection is opened once and
  /// reused for every [transact] call so schema and data persist across calls.
  /// The connection is closed when the [Resource] is released.
  static Resource<Transactor> memory({Strategy? strategy}) => Resource.make(
    IO.delay(() => SqliteConnection(sqlite3.openInMemory())),
    (conn) => conn.close(),
  ).map<Transactor>((connection) => SqliteTransactor._(connection, strategy));

  /// Creates a [Resource] wrapping a [SqliteTransactor] backed by the SQLite
  /// file at [path]. The connection is opened once when the [Resource] is
  /// acquired, reused for every [transact] call, and closed when the
  /// [Resource] is released.
  static Resource<Transactor> file(String path, {Strategy? strategy}) => Resource.make(
    IO.delay(() => SqliteConnection(sqlite3.open(path))),
    (conn) => conn.close(),
  ).map<Transactor>((connection) => SqliteTransactor._(connection, strategy));

  @override
  Resource<SqlConnection> connect() => Resource.pure(_connection);
}
