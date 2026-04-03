import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

/// A [SqlConnection] backed directly by a `sqlite3` [Database] instance.
///
/// This is the low-level connection used by [SqliteTransactor]. It executes
/// all operations synchronously on the calling isolate via [IO.delay].
final class SqliteConnection extends SqlConnection {
  final sqlite.Database _db;

  /// Creates a [SqliteConnection] wrapping the given sqlite3 [Database].
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
  Rill<Row> streamQuery(String sql, StatementParameters params, {int chunkSize = 64}) {
    return Rill.bracket(
      IO.delay(() => _db.prepare(sql)),
      (stmt) => IO.exec(() => stmt.close()),
    ).flatMap(
      (stmt) => Rill.fromIterator(
        stmt.selectCursor(params.toList),
        chunkSize: chunkSize,
      ).map((x) => Row(x.values.toIList())),
    );
  }

  @override
  IO<Unit> close() => IO.exec(() => _db.close());
}
