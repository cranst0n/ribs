import 'package:ribs_core/ribs_core.dart';
import 'package:sqlite3/sqlite3.dart';

class IStatementParameters {
  final IList<Object?> params;

  const IStatementParameters(this.params);

  static IStatementParameters empty() => IStatementParameters(nil());

  IStatementParameters setParameter<A>(int n, A value) =>
      IStatementParameters(params.padTo(n + 1, null).updated(n, value));

  StatementParameters toStatementParameters() => StatementParameters(params.toList());
}
