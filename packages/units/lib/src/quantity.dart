import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/src/unit_of_measure.dart';

/// Base class for all typed physical quantities in ribs_units.
///
/// Each [Quantity] has a [value] (a raw [double]) and a [unit] that gives
/// the value its meaning. Conversion between units is performed via [to].
///
/// Subclasses are typically `final` and self-referential:
///
/// ```dart
/// final class Length extends Quantity<Length> { ... }
/// ```
///
/// Comparison operators (`>`, `<`, `>=`, `<=`) convert [that] to the same
/// unit as `this` before comparing, so mixed-unit comparisons are safe.
abstract class Quantity<A extends Quantity<A>> {
  /// The raw numeric value of this quantity expressed in [unit].
  final double value;

  /// The unit of measure that [value] is expressed in.
  final UnitOfMeasure<A> unit;

  /// Creates a quantity with [value] in [unit].
  Quantity(this.value, this.unit);

  /// Returns true if this quantity is greater than [that].
  ///
  /// [that] is converted to [unit] before comparing.
  bool operator >(A that) => value > that.to(unit);

  /// Returns true if this quantity is less than [that].
  ///
  /// [that] is converted to [unit] before comparing.
  bool operator <(A that) => value < that.to(unit);

  /// Returns true if this quantity is greater than or equal to [that].
  ///
  /// [that] is converted to [unit] before comparing.
  bool operator >=(A that) => value >= that.to(unit);

  /// Returns true if this quantity is less than or equal to [that].
  ///
  /// [that] is converted to [unit] before comparing.
  bool operator <=(A that) => value <= that.to(unit);

  /// Converts this quantity to [uom] and returns the raw [double] value.
  ///
  /// If [uom] equals [unit], the current [value] is returned unchanged.
  double to(UnitOfMeasure<A> uom) => uom == unit ? value : uom.convertTo(unit.convertFrom(value));

  /// Returns true if this quantity represents the same physical magnitude as
  /// [other], regardless of which unit each is expressed in.
  bool equivalentTo(Quantity<A> other) => other.to(unit) == value;

  @override
  String toString() => '$value ${unit.symbol}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quantity<A> && other.value == value && other.unit == unit);

  @override
  int get hashCode => Object.hash(value, unit);

  /// Attempts to parse [s] into a quantity of type [A] using [units].
  ///
  /// Recognizes a numeric literal (including optional sign and exponent)
  /// followed by optional whitespace and a unit name, pluralized name, or
  /// symbol drawn from [units]. Returns [None] if [s] does not match.
  ///
  /// Example:
  /// ```dart
  /// Quantity.parse('5 km', Length.units) // Some(5.kilometers)
  /// ```
  static Option<A> parse<A extends Quantity<A>>(
    String s,
    Set<UnitOfMeasure<A>> units,
  ) => Option(_unitsRegex(units).firstMatch(s)).flatMap(
    (match) => (
      Option(match.group(1)).flatMap((str) => Option(num.tryParse(str))),
      Option(match.group(2)).flatMap(
        (str) => IList.fromDart(
          units.toList(),
        ).find((a) => a.unit == str.trim() || '${a.unit}s' == str.trim() || a.symbol == str.trim()),
      ),
    ).mapN((value, unit) => unit(value)),
  );

  static RegExp _unitsRegex<A extends Quantity<A>>(
    Set<UnitOfMeasure<A>> units,
  ) {
    final unitsStr = units
        .expand((u) => [u.unit, '${u.unit}s', u.symbol])
        .reduce((a, b) => '$a|$b');
    final regStr = '^([-+]?[0-9]*\\.?[0-9]+(?:[eE][-+]?[0-9]+)?) *($unitsStr)\$';

    return RegExp(regStr);
  }
}
