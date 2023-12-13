import 'package:ribs_core/src/function.dart';

/// Defines a total ordering for elements of type `A`.
///
/// [Order]s are most commonly used for sorting elements, but can be useful
/// for other purposes.
abstract class Order<A> {
  const Order();

  /// Creates a new [Order] that uses the [Comparable.compareTo] defined for
  /// the given type.
  static Order<A> fromComparable<A extends Comparable<dynamic>>() =>
      Order.from((A a, A b) => a.compareTo(b));

  /// Creates a new [Order] that compares 2 elements using [f].
  factory Order.from(Function2<A, A, int> f) => _OrderF(f);

  /// Creates a new [Order] for type `A` by applying [f] to and instances and
  /// comparing the resulting [Comparable].
  static Order<A> by<A, B extends Comparable<dynamic>>(Function1<A, B> f) =>
      Order.from((a, b) => f(a).compareTo(f(b)));

  /// Order for [int] type.
  static final ints = Order.fromComparable<int>();

  /// Order for [double] type.
  static final doubles = Order.fromComparable<double>();

  /// Order for [String] type.
  static final strings = Order.fromComparable<String>();

  /// Compares to instances and returns:
  ///
  /// * < 0: If [x] is considered to be less than [y]
  /// * 0: If [x] is considered to be equal to [y]
  /// * > 0: If [x] is considered to be greater than [y]
  int compare(A x, A y);

  /// Returns the greater of [x] and [y], as defined by this [Order].
  A max(A x, A y) => gt(x, y) ? x : y;

  /// Returns the lesser of [x] and [y], as defined by this [Order].
  A min(A x, A y) => lt(x, y) ? x : y;

  /// Returns `true` if [x] is equal to [y], as defined by this [Order].
  /// Otherwise, `false` is returned.
  bool eqv(A x, A y) => compare(x, y) == 0;

  /// Returns `false` if [x] is equal to [y], as defined by this [Order].
  /// Otherwise, `true` is returned.
  bool neqv(A x, A y) => !eqv(x, y);

  /// Returns `true` if [x] is less than or equal to [y], as defined by this
  /// [Order]. Otherwise, `false` is returned.
  bool lteqv(A x, A y) => compare(x, y) <= 0;

  /// Returns `true` if [x] is less than [y], as defined by this [Order].
  /// Otherwise, `false` is returned.
  bool lt(A x, A y) => compare(x, y) < 0;

  /// Returns `true` if [x] is greater than or equal to [y], as defined by this
  /// [Order]. Otherwise, `false` is returned.
  bool gteqv(A x, A y) => compare(x, y) >= 0;

  /// Returns `true` if [x] is greater than [y], as defined by this [Order].
  /// Otherwise, `false` is returned.
  bool gt(A x, A y) => compare(x, y) > 0;

  /// Returns a new [Order] that reverses the evaluation of this [Order].
  Order<A> reverse() => _OrderF((a, b) => compare(b, a));
}

final class _OrderF<A> extends Order<A> {
  final Function2<A, A, int> compareTo;

  const _OrderF(this.compareTo);

  @override
  int compare(A x, A y) => compareTo(x, y);
}
