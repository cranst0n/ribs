/// Mixin that provides comparison operators for types that implement a total
/// ordering via [compareTo].
///
/// Extend or implement this class to gain `<`, `<=`, `>`, and `>=` operators
/// derived from [compareTo].
abstract class Ordered<A> implements Comparable<A> {
  const Ordered();

  @override
  int compareTo(A other);

  /// Returns `true` if this value is less than [that].
  bool operator <(A that) => compareTo(that) < 0;

  /// Returns `true` if this value is less than or equal to [that].
  bool operator <=(A that) => compareTo(that) <= 0;

  /// Returns `true` if this value is greater than [that].
  bool operator >(A that) => compareTo(that) > 0;

  /// Returns `true` if this value is greater than or equal to [that].
  bool operator >=(A that) => compareTo(that) >= 0;
}
