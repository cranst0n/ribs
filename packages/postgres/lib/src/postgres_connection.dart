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
  Rill<Row> streamQuery(String sql, StatementParameters params) {
    return Rill.bracket(
      IO.fromFutureF(() => _session.prepare(_toPositional(sql))),
      (statement) => IO.fromFutureF(() => statement.dispose()).voided(),
    ).flatMap(
      (statement) => Rill.fromStream(
        statement.bind(params.toList),
      ).map((postgresRow) => Row(postgresRow.toIList())),
    );
  }

  /// Converts `?` positional placeholders to postgres package style `$1, $2, ...`.
  static String _toPositional(String sql) {
    var n = 0;
    return sql.replaceAllMapped(RegExp(r'\?'), (_) => '\$${++n}');
  }

  @override
  IO<Unit> close() => IO.unit;
}
