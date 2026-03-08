import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Manages the lifecycle of a [SqlConnection] and provides the ability to
/// run [ConnectionIO] programs using it.
///
/// A [Transactor] handles the connection acquisition, transaction handling, and
/// resource cleanup, so users only need to describe what to do with the
/// connection via [ConnectionIO].
abstract class Transactor {
  final Strategy strategy;

  Transactor(
    Strategy? strategy,
  ) : strategy = strategy ?? Strategy.defaultStrategy();

  Resource<SqlConnection> connect();

  /// Some databases (like SQLite) offer a read-only connection which can open
  /// up the opportunity for more concurrency. By default, [connectReader]
  /// delegates to [connect], but transactors for databases with separate
  /// reader/writer connections can override it to acquire a read-only connection.
  Resource<SqlConnection> connectReader() => connect();

  /// Acquires a connection, runs [cio] within a transaction using the
  /// current [strategy], then commits (or rolls back on error) and releases
  /// the connection.
  IO<A> transact<A>(ConnectionIO<A> cio) => connect().use((conn) {
    return strategy.resource(conn).surround(cio.run(conn));
  });

  /// Streams results from [query], keeping a connection open for the duration
  /// of the stream. The connection is released when the [Rill] terminates.
  Rill<A> stream<A>(Query<A> query) {
    return Rill.resource(connectReader()).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}

final class Strategy {
  final ConnectionIO<Unit> before;
  final ConnectionIO<Unit> after;
  final ConnectionIO<Unit> oops;
  final ConnectionIO<Unit> always;

  const Strategy({
    required this.before,
    required this.after,
    required this.oops,
    required this.always,
  });

  factory Strategy.defaultStrategy() => Strategy(
    before: ConnectionIO.fromConnection((conn) => conn.beginTransaction()),
    after: ConnectionIO.fromConnection((conn) => conn.commit()),
    oops: ConnectionIO.fromConnection((conn) => conn.rollback()),
    always: ConnectionIO.unit,
  );

  /// Binds this strategy to a concrete [conn], returning a [Resource] that:
  /// - acquires by running [before] (e.g. BEGIN TRANSACTION),
  /// - releases with [after] on success or [oops] on error/cancel,
  /// - and guarantees [always] runs via an outer resource.
  Resource<Unit> resource(SqlConnection conn) {
    return Resource.make(IO.pure(Unit()), (_) => always.run(conn)).flatMap(
      (_) => Resource.makeCase(before.run(conn), (_, ec) {
        return ec.fold(
          () => oops.run(conn),
          (_, _) => oops.run(conn),
          () => after.run(conn),
        );
      }),
    );
  }
}
