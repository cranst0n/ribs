import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A [SqlConnection] backed by a PostgreSQL [pg.Session].
///
/// Wraps either a [pg.Connection] or a [pg.TxSession] so the same
/// [SqlConnection] interface works both outside and inside a transaction.
final class PostgresConnection extends SqlConnection {
  final pg.Session _session;

  PostgresConnection(this._session);

  @override
  IO<IList<Row>> executeQuery(String sql, StatementParameters params) => IO.fromFutureF(() async {
    final result = await _session.execute(_toPositional(sql), parameters: params.toList);
    return result.map((postgresRow) => Row(postgresRow.toIList())).toIList();
  });

  @override
  IO<int> executeUpdate(String sql, StatementParameters params) => IO.fromFutureF(() async {
    final result = await _session.execute(
      _toPositional(sql),
      parameters: params.toList,
      ignoreRows: true,
    );
    return result.affectedRows;
  });

  @override
  Rill<Row> streamQuery(String sql, StatementParameters params, {int chunkSize = 64}) {
    return Rill.bracketCase(
      IO.fromFutureF(() => _session.prepare(_toPositional(sql))),
      (statement, ec) {
        final dispose = IO.fromFutureF(() => statement.dispose()).voided();

        // On cancellation, the in-flight query holds the connection's internal
        // operation lock. statement.dispose() would hang indefinitely waiting
        // for that lock (which only releases when the server finishes the
        // query). Force-closing the connection first interrupts the pending
        // query, releases the lock, and turns dispose() into a no-op (it
        // checks _isClosing) so cleanup can proceed without blocking.
        if (!ec.isCanceled || _session is! pg.Connection) {
          return dispose;
        } else {
          return IO
              .fromFutureF(() => _session.close(force: true))
              .attempt()
              .productR(() => dispose);
        }
      },
    ).flatMap((statement) {
      return Rill.eval(Queue.unbounded<Either<Object, Option<pg.ResultRow>>>()).flatMap((queue) {
        final maxN = Some(chunkSize);

        Rill<Row> consumeQueue() {
          // Option 1: Chunking
          return Rill.eval(queue.tryTakeN(maxN)).flatMap((events) {
            // split into the Right<Option> prefix, and whatever is a Left
            final (rightOpts, errOpt) = events.spanRightsAndFirstLeft;

            final rows = Rill.emits(
              rightOpts.unNone().map((pgRow) => Row(pgRow.toIList())).toList(),
            );

            // A None signals the underlying Stream is done
            final continueConsume = rightOpts.forall((opt) => opt.isDefined);

            if (continueConsume) {
              // all Somes so send all
              final Rill<Row> err = errOpt.fold(
                () => Rill.empty(),
                (err) => Rill.raiseError(err),
              );

              return rows.append(() => err).append(() => consumeQueue());
            } else {
              return rows;
            }
          });

          // Option 2: No chunking
          // return Rill.eval(queue.take()).flatMap((event) {
          //   return event.fold(
          //     Rill.raiseError<Row>,
          //     (opt) => opt.fold(
          //       Rill.empty<Row>,
          //       (row) => Rill.emit(Row(row.toIList())).append(() => consumeQueue()),
          //     ),
          //   );
          // });
        }

        final acquire = IO.delay(
          () => statement
              .bind(params.toList)
              .listen(
                (row) => queue.offer(Right(Some(row))).unsafeRunAndForget(),
                onError: (Object err) => queue.offer(Left(err)).unsafeRunAndForget(),
                onDone: () => queue.offer(Right(none())).unsafeRunAndForget(),
                cancelOnError: false,
              ),
        );

        // On cancellation, skip sub.cancel() — the outer bracketCase will
        // force-close the connection, which causes the subscription to
        // terminate naturally via onError/onDone. Calling sub.cancel() here
        // would race with the force-close and could block on the operation
        // lock that the in-flight query holds.
        // On success/error the stream is already done, so cancel() is a no-op.
        return Rill.bracketCase(
          acquire,
          (sub, ec) => ec.isCanceled ? IO.unit : IO.fromFutureF(() => sub.cancel()).voided(),
        ).flatMap((_) => consumeQueue());
      });
    });
  }

  /// Converts `?` positional placeholders to postgres package style `$1, $2, ...`.
  static String _toPositional(String sql) {
    var n = 0;
    return sql.replaceAllMapped(RegExp(r'\?'), (_) => '\$${++n}');
  }

  @override
  IO<Unit> close() => IO.unit;
}

extension<A, B> on IList<Either<A, B>> {
  (IList<B>, Option<A>) get spanRightsAndFirstLeft {
    final (rightPrefix, rest) = span((ab) => ab.isRight);

    final bs = rightPrefix.map((ab) => (ab as Right<A, B>).b);
    final a = rest.headOption.map((ab) => (ab as Left<A, B>).a);

    return (bs, a);
  }
}
