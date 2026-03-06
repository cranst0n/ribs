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
  final Query<A> query;

  const ConnectionRill(this.query);

  Rill<A> transact(Transactor xa) => xa.stream(query);
}
