/// SQLite driver integration for `ribs_sql`.
///
/// Provides a `Transactor` and connection abstractions for executing
/// purely functional, type-safe SQL queries against SQLite databases.
library;

export 'src/sqlite_connection.dart';
export 'src/sqlite_pool_transactor.dart';
export 'src/sqlite_transactor.dart';
