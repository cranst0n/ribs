import 'package:ribs_units/src/quantity.dart';

/// Abstract base for all units of measure.
///
/// A [UnitOfMeasure] knows how to:
/// - Construct a [Quantity] of type [A] via [call].
/// - Report its canonical [unit] name and display [symbol].
/// - Convert a raw value *from* this unit into a common internal base
///   ([converterFrom]) and *to* this unit from that base ([converterTo]).
///
/// The internal base is chosen per quantity type (e.g. meters for [Length],
/// milliseconds for [Time]) and is never exposed directly to callers.
abstract class UnitOfMeasure<A extends Quantity<A>> {
  const UnitOfMeasure();

  /// Creates a quantity of [value] expressed in this unit.
  A call(num value);

  /// The canonical name of this unit (e.g. `'meter'`, `'kilogram'`).
  String get unit;

  /// The display symbol for this unit (e.g. `'m'`, `'kg'`).
  String get symbol;

  /// Converts [value] expressed in this unit to the internal base value.
  double converterFrom(double value);

  /// Converts [value] expressed in the internal base to this unit.
  double converterTo(double value);

  /// Convenience wrapper: converts [value] to this unit's representation
  /// from the internal base.
  double convertTo(num value) => converterTo(value.toDouble());

  /// Convenience wrapper: converts [value] in this unit to the internal base.
  double convertFrom(num value) => converterFrom(value.toDouble());
}

/// A [UnitOfMeasure] whose conversion is a simple multiplicative factor.
///
/// [converterFrom] multiplies by [conversionFactor]; [converterTo] divides.
/// This covers the vast majority of SI and derived units.
abstract class UnitConverter<A extends Quantity<A>> extends UnitOfMeasure<A> {
  const UnitConverter();

  /// The factor that converts a value in this unit to the internal base.
  double get conversionFactor;

  @override
  double converterFrom(double value) => value * conversionFactor;

  @override
  double converterTo(double value) => value / conversionFactor;
}

/// A concrete, immutable [UnitConverter] with a fixed [unit] name, [symbol],
/// and [conversionFactor].
///
/// Most unit singletons (e.g. [Meters], [Kilograms]) extend [BaseUnit] and
/// are constructed once as `const` values.
abstract class BaseUnit<A extends Quantity<A>> extends UnitConverter<A> {
  @override
  final String unit;

  @override
  final String symbol;

  @override
  final double conversionFactor;

  const BaseUnit(this.unit, this.symbol, this.conversionFactor);

  @override
  A call(num value);
}
