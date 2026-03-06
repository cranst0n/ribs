import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Abstract interface for a database connection.
///
/// Implementations provide the low-level operations for executing SQL
/// against a specific database backend (SQLite, PostgreSQL, etc.).
abstract class SqlConnection {
  /// Executes a SELECT query and returns all rows as lists of column values.
  IO<IList<Row>> executeQuery(String sql, StatementParameters params);

  /// Executes an INSERT, UPDATE, or DELETE statement and returns the number
  /// of rows affected.
  IO<int> executeUpdate(String sql, StatementParameters params);

  /// Streams rows from a SELECT query, emitting each [Row].
  /// Suitable for large result sets that should not be fully buffered.
  Rill<Row> streamQuery(String sql, StatementParameters params);

  /// Closes this connection and releases any associated resources.
  IO<Unit> close();
}
