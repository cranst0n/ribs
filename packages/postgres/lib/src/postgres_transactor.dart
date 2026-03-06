import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [Transactor] backed by a PostgreSQL database via the `postgres` package.
///
/// Each call to [transact] opens a dedicated connection, runs the
/// [ConnectionIO] inside a database transaction (BEGIN/COMMIT/ROLLBACK), then
/// closes the connection.  [stream] keeps the connection open for the lifetime
/// of the [Rill].
///
/// Example:
/// ```dart
/// final xa = PostgresTransactor(
///   pg.Endpoint(host: 'localhost', database: 'mydb', username: 'user', password: 'pass'),
/// );
///
/// final people = await 'SELECT id, name FROM person'
///     .query((Read.integer, Read.string).tupled)
///     .ilist()
///     .transact(xa)
///     .unsafeRunFuture();
/// ```
final class PostgresTransactor implements Transactor {
  final pg.Endpoint _endpoint;
  final pg.ConnectionSettings? _settings;

  const PostgresTransactor(this._endpoint, {pg.ConnectionSettings? settings})
    : _settings = settings;

  IO<pg.Connection> _openConnection() => IO.fromFutureF(
    () => pg.Connection.open(_endpoint, settings: _settings),
  );

  @override
  Resource<SqlConnection> connection() => Resource.make(
    _openConnection().map(PostgresConnection.new),
    (conn) => conn.close(),
  );

  @override
  IO<A> transact<A>(ConnectionIO<A> cio) {
    return IO
        .fromFutureF(() => pg.Connection.open(_endpoint, settings: _settings))
        .bracket(
          (conn) => IO.fromFutureF(
            () => conn.runTx(
              (txSession) => cio.run(PostgresConnection(txSession)).unsafeRunFuture(),
            ),
          ),
          (conn) => IO.fromFutureF(() => conn.close()).voided(),
        );
  }

  @override
  Rill<A> stream<A>(Query<A> query) {
    return Rill.bracket(
      _openConnection().map(PostgresConnection.new),
      (conn) => conn.close(),
    ).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}
