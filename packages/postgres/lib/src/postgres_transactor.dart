import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [Transactor] backed by a PostgreSQL database via the `postgres` package.
///
/// Backed by a single shared connection opened when the [Resource] is acquired
/// and closed on release. All [transact] and [stream] calls reuse this
/// connection sequentially. For concurrent access use [PostgresPoolTransactor].
///
/// Example:
/// ```dart
/// PostgresTransactor.create(
///   pg.Endpoint(host: 'localhost', database: 'mydb', username: 'user', password: 'pass'),
/// ).use((xa) {
///   return 'SELECT id, name FROM person'
///       .query((Read.integer, Read.string).tupled)
///       .ilist()
///       .transact(xa);
/// });
/// ```
final class PostgresTransactor extends Transactor {
  final pg.Connection _connection;

  PostgresTransactor._(this._connection, super.strategy);

  /// Creates a [Resource] wrapping a [PostgresTransactor] backed by a single
  /// shared connection. The connection is opened once when the [Resource] is
  /// acquired, reused for every [transact] and [stream] call, and closed when
  /// the [Resource] is released.
  static Resource<Transactor> create(
    pg.Endpoint endpoint, {
    pg.ConnectionSettings? settings,
    Strategy? strategy,
  }) => Resource.make(
    IO.fromFutureF(() => pg.Connection.open(endpoint, settings: settings)),
    (conn) => IO.fromFutureF(() => conn.close()).voided(),
  ).map<Transactor>((connection) => PostgresTransactor._(connection, strategy));

  @override
  Resource<SqlConnection> connect() => Resource.pure(PostgresConnection(_connection));
}
