import 'dart:async';

import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [Transactor] backed by a PostgreSQL connection pool via the `postgres`
/// package's built-in [pg.Pool].
///
/// [transact] borrows a session from the pool, runs the [ConnectionIO] inside
/// a database transaction, then returns the session to the pool.
///
/// Example:
/// ```dart
/// PostgresPoolTransactor.withEndpoints(
///   [pg.Endpoint(host: 'localhost', database: 'mydb')],
///   settings: pg.PoolSettings(maxConnectionCount: 10),
/// ).use((xa) {
///   final people = await 'SELECT id, name FROM person'
///       .query((Read.integer, Read.string).tupled)
///       .ilist()
///       .transact(xa)
/// });
/// ```
final class PostgresPoolTransactor extends Transactor {
  final pg.Pool<dynamic> _pool;

  PostgresPoolTransactor._(this._pool, super.strategy);

  /// Creates a [Resource] wrapping a pool transactor from a list of
  /// [endpoints]. The pool is closed when the [Resource] is released.
  ///
  /// Connections are distributed across the endpoints using round-robin
  /// selection. Use [settings] to cap the pool size and configure timeouts.
  static Resource<Transactor> withEndpoints(
    List<pg.Endpoint> endpoints, {
    pg.PoolSettings? settings,
    Strategy? strategy,
  }) {
    return Resource.make(
      IO.delay(() => pg.Pool<Never>.withEndpoints(endpoints, settings: settings)),
      (pool) => IO.fromFutureF(() => pool.close()).voided(),
    ).map((pool) => PostgresPoolTransactor._(pool, strategy));
  }

  /// Creates a [Resource] wrapping a pool transactor from a PostgreSQL
  /// connection [url] of the form
  /// `postgresql://[user:password@]host[:port][/database][?params]`.
  /// The pool is closed when the [Resource] is released.
  static Resource<Transactor> withUrl(
    String url, {
    Strategy? strategy,
  }) {
    return Resource.make(
      IO.delay(() => pg.Pool<Never>.withUrl(url)),
      (pool) => IO.fromFutureF(() => pool.close()).voided(),
    ).map((pool) => PostgresPoolTransactor._(pool, strategy));
  }

  @override
  Resource<SqlConnection> connect() {
    return Resource.apply(
      IO.async((cb) {
        final signalDone = Completer<void>();

        // Call pg.PoolwithConnection with async callback.
        // The connection is held open until `signalDone` is completed
        // by the release action.
        _pool
            .withConnection((pg.Connection conn) async {
              cb(
                Right((
                  PostgresConnection(conn),

                  IO.delay(() {
                    if (!signalDone.isCompleted) signalDone.complete();
                  }).voided(),
                )),
              );

              // Hold the connection until the Resource scope ends.
              await signalDone.future;
            })
            .catchError((Object err) {
              if (!signalDone.isCompleted) cb(Left(err));
            });

        // If we're canceled, unblock withConnection
        return IO.pure(
          Some(
            IO.delay(() {
              if (!signalDone.isCompleted) signalDone.complete();
            }).voided(),
          ),
        );
      }),
    );
  }
}
