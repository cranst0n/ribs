import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

/// Converts a sqlite3 [Iterator<Row>] into a lazily-pulled [Rill].
///
/// Each [Pull.eval] step advances the cursor by one row, so only one row is
/// resident in memory at a time. The caller is responsible for closing the
/// underlying [Statement] (and thus the cursor) when the [Rill] terminates.
Rill<Row> rillFromSqliteCursor(Iterator<sqlite.Row> cursor) {
  Pull<Row, Unit> go() {
    // TODO: Do I need to introduce IO here for trampoline?
    if (cursor.moveNext()) {
      return Pull.pure(Row(cursor.current.values.toIList())).append(() => go());
    } else {
      return Pull.done;
    }
  }

  return go().rill;
}
