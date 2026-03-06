import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/src/sqlite_rill.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

final class SqliteConnection implements SqlConnection {
  final sqlite.Database _db;

  SqliteConnection(this._db);

  @override
  IO<IList<Row>> executeQuery(String sql, StatementParameters params) => IO.delay(
    () =>
        _db
            .select(sql, params.toList)
            .map((sqliteRow) => Row(sqliteRow.values.toIList()))
            .toIList(),
  );

  @override
  IO<int> executeUpdate(String sql, StatementParameters params) => IO.delay(() {
    _db.execute(sql, params.toList);
    return _db.updatedRows;
  });

  @override
  Rill<Row> streamQuery(String sql, StatementParameters params) {
    return Rill.bracket(
      IO.delay(() => _db.prepare(sql)),
      (stmt) => IO.exec(() => stmt.close()),
    ).flatMap((stmt) => rillFromSqliteCursor(stmt.selectCursor(params.toList)));
  }

  @override
  IO<Unit> close() => IO.exec(() => _db.close());
}
