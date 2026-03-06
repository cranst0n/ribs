import 'package:ribs_core/ribs_core.dart';

/// Wrapper type for parameters that can be applied to a statement that has
/// parameter bindings.
extension type StatementParameters(IList<Object?> _parameters) {
  static StatementParameters empty() => StatementParameters(nil());

  StatementParameters setParameter<A>(int n, A value) =>
      StatementParameters(_parameters.padTo(n + 1, null).updated(n, value));

  StatementParameters concat(StatementParameters other) =>
      StatementParameters(_parameters.concat(other._parameters));

  List<Object?> get toList => _parameters.toList();
}
