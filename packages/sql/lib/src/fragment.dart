import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A composable SQL fragment consisting of a SQL string and its bound parameters.
///
/// Fragments can be composed using [+] to build up complex SQL statements.
/// Parameters are embedded via [Fragment.param] which inserts a `?` placeholder
/// and records the encoded value.
///
/// Example:
/// ```dart
/// final frag =
///     Fragment.sql('SELECT * FROM person WHERE age > ') +
///     Fragment.param(18, Put.integer) +
///     Fragment.sql(' AND city = ') +
///     Fragment.param('NYC', Put.string);
/// ```
final class Fragment {
  final String sql;
  final StatementParameters params;

  const Fragment._(this.sql, this.params);

  /// Creates a [Fragment] from a plain SQL string with no parameters.
  factory Fragment.raw(String s) => Fragment._(s, StatementParameters(nil()));

  /// Creates a [Fragment] for a single typed parameter, inserting a `?` placeholder.
  static Fragment param<A>(A value, Put<A> put) =>
      Fragment._('?', StatementParameters(ilist([put.encode(value)])));

  /// Concatenates two fragments, joining their SQL strings and [StatementParameters].
  Fragment operator +(Fragment other) =>
      Fragment._('$sql${other.sql}', params.concat(other.params));

  /// Creates a [Fragment] from pre-encoded parts. Generally for internal use by query/codec types.
  static Fragment fromParts(String sql, StatementParameters params) => Fragment._(sql, params);
}

extension FragmentStringOps on String {
  /// Wraps this SQL string in a [Fragment] with no parameters.
  Fragment get fr => Fragment.raw(this);
}
