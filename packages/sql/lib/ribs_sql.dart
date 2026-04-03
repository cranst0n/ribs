/// Purely functional, type-safe SQL query execution and composition.
///
/// Provides combinators for building SQL queries, parameter binding,
/// and a `Transactor` abstraction for executing `IO` operations against
/// various database backends.
library;

export 'src/connection_io.dart';
export 'src/connection_rill.dart';
export 'src/fragment.dart';
export 'src/generated/read_syntax.dart';
export 'src/generated/read_write_syntax.dart';
export 'src/generated/write_syntax.dart';
export 'src/get.dart';
export 'src/put.dart';
export 'src/query.dart';
export 'src/read.dart';
export 'src/read_write.dart';
export 'src/row.dart';
export 'src/sql_connection.dart';
export 'src/statement_parameters.dart';
export 'src/transactor.dart';
export 'src/update.dart';
export 'src/write.dart';
