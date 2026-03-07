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
  /// Acquires a connection, runs [cio] within a transaction, then commits
  /// (or rolls back on error) and releases the connection.
  IO<A> transact<A>(ConnectionIO<A> cio);

  /// Streams results from [query], keeping a connection open for the duration
  /// of the stream. The connection is released when the [Rill] terminates.
  Rill<A> stream<A>(Query<A> query);
}
