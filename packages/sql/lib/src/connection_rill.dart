import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A deferred streaming query that produces a [Rill] that output elements of
/// type [A] when transacted.
///
/// Analogous to [ConnectionIO] but for streaming: the database connection is
/// kept open for the lifetime of the [Rill] and released when it terminates.
///
/// Obtain one via [Query.stream] or [ParameterizedQuery.stream], then execute
/// with [transact].
final class ConnectionRill<A> {
  /// The query to execute when this program is transacted.
  final Query<A> query;

  /// The number of rows to fetch per chunk from the database.
  final int chunkSize;

  /// Creates a [ConnectionRill] that will execute [query], fetching rows
  /// in batches of [chunkSize] (defaults to 64).
  const ConnectionRill(this.query, {this.chunkSize = 64});

  /// Executes this streaming query within a transaction managed by [xa],
  /// returning a [Rill] of decoded result rows.
  Rill<A> transact(Transactor xa) => xa.stream(query, chunkSize: chunkSize);
}
