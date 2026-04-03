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
  /// The transaction [Strategy] controlling begin/commit/rollback behavior.
  final Strategy strategy;

  /// Creates a [Transactor] with an optional [strategy].
  ///
  /// When [strategy] is `null`, [Strategy.defaultStrategy] is used, which
  /// wraps each program in a `BEGIN` / `COMMIT` / `ROLLBACK` transaction.
  Transactor(
    Strategy? strategy,
  ) : strategy = strategy ?? Strategy.defaultStrategy();

  /// Acquires a new [SqlConnection], returned as a [Resource] that
  /// automatically closes the connection on release.
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
  ///
  /// The returned rill will attempt to pull rows from the result in chunks sized
  /// up to [chunkSize].
  Rill<A> stream<A>(Query<A> query, {int chunkSize = 64}) {
    return Rill.resource(connectReader()).flatMap(
      (conn) => conn
          .streamQuery(query.fragment.sql, query.fragment.params, chunkSize: chunkSize)
          .map((row) => query.read.unsafeGet(row, 0)),
    );
  }
}

/// Defines the lifecycle hooks for transaction management.
///
/// A [Strategy] specifies what to run [before] the program (e.g. `BEGIN`),
/// [after] on success (e.g. `COMMIT`), on error via [oops] (e.g. `ROLLBACK`),
/// and [always] regardless of outcome (e.g. cleanup).
final class Strategy {
  /// Runs before the program (e.g. `BEGIN TRANSACTION`).
  final ConnectionIO<Unit> before;

  /// Runs after a successful program (e.g. `COMMIT`).
  final ConnectionIO<Unit> after;

  /// Runs when the program fails or is cancelled (e.g. `ROLLBACK`).
  final ConnectionIO<Unit> oops;

  /// Runs unconditionally after [after] or [oops] (e.g. cleanup).
  final ConnectionIO<Unit> always;

  /// Creates a [Strategy] with explicit lifecycle hooks.
  const Strategy({
    required this.before,
    required this.after,
    required this.oops,
    required this.always,
  });

  /// The standard strategy: `BEGIN TRANSACTION` before, `COMMIT` after,
  /// `ROLLBACK` on error, and no-op for always.
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
