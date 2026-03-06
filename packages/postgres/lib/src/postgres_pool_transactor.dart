import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [Transactor] backed by a PostgreSQL connection pool via the `postgres`
/// package's built-in [pg.Pool].
///
/// [transact] borrows a session from the pool, runs the [ConnectionIO] inside
/// a database transaction (BEGIN/COMMIT/ROLLBACK), then returns the session to
/// the pool. [stream] opens a dedicated connection for the lifetime of the
/// [Rill], independent of the pool.
///
/// Example:
/// ```dart
/// final xa = PostgresPoolTransactor.withEndpoints(
///   [pg.Endpoint(host: 'localhost', database: 'mydb')],
///   settings: pg.PoolSettings(maxConnectionCount: 10),
/// );
///
/// final people = await 'SELECT id, name FROM person'
///     .query((Read.integer, Read.string).tupled)
///     .ilist()
///     .transact(xa)
///     .unsafeRunFuture();
/// ```
final class PostgresPoolTransactor implements Transactor {
  final pg.Pool<dynamic> _pool;
  final List<pg.Endpoint> _endpoints;
  final pg.ConnectionSettings? _connectionSettings;

  const PostgresPoolTransactor._(
    this._pool,
    this._endpoints,
    this._connectionSettings,
  );

  /// Creates a pool transactor from a list of [endpoints].
  ///
  /// Connections are distributed across the endpoints using round-robin
  /// selection. Use [settings] to cap the pool size and configure timeouts.
  factory PostgresPoolTransactor.withEndpoints(
    List<pg.Endpoint> endpoints, {
    pg.PoolSettings? settings,
  }) => PostgresPoolTransactor._(
    pg.Pool.withEndpoints(endpoints, settings: settings),
    endpoints,
    settings,
  );

  /// Creates a pool transactor from a PostgreSQL connection [url] of the form
  /// `postgresql://[user:password@]host[:port][/database][?params]`.
  factory PostgresPoolTransactor.withUrl(String url) {
    final pool = pg.Pool<Never>.withUrl(url);
    return PostgresPoolTransactor._(pool, [], null);
  }

  @override
  Resource<SqlConnection> connection() => Resource.make(
    IO
        .fromFutureF(
          () => pg.Connection.open(
            _endpoints.first,
            settings: _connectionSettings,
          ),
        )
        .map(PostgresConnection.new),
    (conn) => conn.close(),
  );

  /// Borrows a session from the pool, runs [cio] inside a transaction, then
  /// returns the session to the pool. The transaction is automatically rolled
  /// back on error.
  @override
  IO<A> transact<A>(ConnectionIO<A> cio) => IO.fromFutureF(
    () => _pool.runTx(
      (txSession) => cio.run(PostgresConnection(txSession)).unsafeRunFuture(),
    ),
  );

  /// Opens a dedicated connection for the duration of the [Rill]. The
  /// connection is closed when the stream terminates or is interrupted.
  @override
  Rill<A> stream<A>(Query<A> query) {
    final acquire = IO
        .fromFutureF(
          () => pg.Connection.open(
            _endpoints.first,
            settings: _connectionSettings,
          ),
        )
        .map(PostgresConnection.new);

    return Rill.bracket(
      acquire,
      (conn) => conn.close(),
    ).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}
