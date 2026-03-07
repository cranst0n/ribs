import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [Transactor] backed by a PostgreSQL database via the `postgres` package.
///
/// Backed by a single shared connection opened when the [Resource] is acquired
/// and closed on release. All [transact] and [stream] calls reuse this
/// connection sequentially. For concurrent access use [PostgresPoolTransactor].
///
/// Example:
/// ```dart
/// await PostgresTransactor.create(
///   pg.Endpoint(host: 'localhost', database: 'mydb', username: 'user', password: 'pass'),
/// ).use((xa) async {
///   final people = await 'SELECT id, name FROM person'
///       .query((Read.integer, Read.string).tupled)
///       .ilist()
///       .transact(xa)
///       .unsafeRunFuture();
/// }).unsafeRunFuture();
/// ```
final class PostgresTransactor implements Transactor {
  final pg.Connection _connection;

  PostgresTransactor._(this._connection);

  /// Creates a [Resource] wrapping a [PostgresTransactor] backed by a single
  /// shared connection. The connection is opened once when the [Resource] is
  /// acquired, reused for every [transact] and [stream] call, and closed when
  /// the [Resource] is released.
  static Resource<Transactor> create(
    pg.Endpoint endpoint, {
    pg.ConnectionSettings? settings,
  }) => Resource.make(
    IO.fromFutureF(() => pg.Connection.open(endpoint, settings: settings)),
    (conn) => IO.fromFutureF(() => conn.close()).voided(),
  ).map<Transactor>(PostgresTransactor._);

  @override
  IO<A> transact<A>(ConnectionIO<A> cio) => IO.fromFutureF(
    () => _connection.runTx(
      (txSession) => cio.run(PostgresConnection(txSession)).unsafeRunFuture(),
    ),
  );

  @override
  Rill<A> stream<A>(Query<A> query) => PostgresConnection(_connection)
      .streamQuery(query.fragment.sql, query.fragment.params)
      .map((row) => query.read.unsafeGet(row, 0));
}
