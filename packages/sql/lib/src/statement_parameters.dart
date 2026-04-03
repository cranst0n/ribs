import 'package:ribs_core/ribs_core.dart';

/// Wrapper type for parameters that can be applied to a statement that has
/// parameter bindings.
extension type StatementParameters(IList<Object?> _parameters) {
  /// Creates an empty [StatementParameters] with no bound values.
  static StatementParameters empty() => StatementParameters(nil());

  /// Returns a new [StatementParameters] with [value] set at position [n].
  ///
  /// The parameter list is automatically padded with `null` values if [n]
  /// is beyond the current length.
  StatementParameters setParameter<A>(int n, A value) =>
      StatementParameters(_parameters.padTo(n + 1, null).updated(n, value));

  /// Concatenates this instance with [other], appending all of its
  /// parameters after the current ones.
  StatementParameters concat(StatementParameters other) =>
      StatementParameters(_parameters.concat(other._parameters));

  /// Converts the parameters to a mutable [List] for use with database
  /// drivers that require one.
  List<Object?> get toList => _parameters.toList();
}
