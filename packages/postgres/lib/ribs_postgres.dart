/// PostgreSQL driver integration for `ribs_sql`.
///
/// Provides a `Transactor` and connection abstractions for executing
/// purely functional, type-safe SQL queries against PostgreSQL databases.
library;

export 'src/postgres_connection.dart';
export 'src/postgres_pool_transactor.dart';
export 'src/postgres_transactor.dart';
