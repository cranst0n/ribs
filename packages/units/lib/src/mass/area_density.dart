import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing areal (surface) mass density (mass per unit area).
final class AreaDensity extends Quantity<AreaDensity> {
  AreaDensity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [AreaDensity].
  AreaDensity operator +(AreaDensity that) => AreaDensity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [AreaDensity].
  AreaDensity operator -(AreaDensity that) => AreaDensity(value - that.to(unit), unit);

  /// Converts this to kilograms per square meter (kg/m²).
  AreaDensity get toKilogramsPerSquareMeter => to(kilogramsPerSquareMeter).kilogramsPerSquareMeter;

  /// Converts this to grams per square centimeter (g/cm²).
  AreaDensity get toGramsPerSquareCentimeter =>
      to(gramsPerSquareCentimeter).gramsPerSquareCentimeter;

  /// Converts this to pounds per square foot (lb/ft²).
  AreaDensity get toPoundsPerSquareFoot => to(poundsPerSquareFoot).poundsPerSquareFoot;

  /// Unit for kilograms per square meter (kg/m²) — the SI unit of areal density.
  static const AreaDensityUnit kilogramsPerSquareMeter = KilogramsPerSquareMeter._();

  /// Unit for grams per square centimeter (g/cm²).
  static const AreaDensityUnit gramsPerSquareCentimeter = GramsPerSquareCentimeter._();

  /// Unit for pounds per square foot (lb/ft²).
  static const AreaDensityUnit poundsPerSquareFoot = PoundsPerSquareFoot._();

  /// All supported [AreaDensity] units.
  static const units = {
    kilogramsPerSquareMeter,
    gramsPerSquareCentimeter,
    poundsPerSquareFoot,
  };

  /// Parses [s] into an [AreaDensity], returning [None] if parsing fails.
  static Option<AreaDensity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [AreaDensity] units.
abstract class AreaDensityUnit extends BaseUnit<AreaDensity> {
  const AreaDensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  AreaDensity call(num value) => AreaDensity(value.toDouble(), this);
}

/// Kilograms per square meter (kg/m²).
final class KilogramsPerSquareMeter extends AreaDensityUnit {
  const KilogramsPerSquareMeter._() : super('kilogram/square meter', 'kg/m²', 1.0);
}

/// Grams per square centimeter (g/cm²).
final class GramsPerSquareCentimeter extends AreaDensityUnit {
  const GramsPerSquareCentimeter._() : super('gram/square centimeter', 'g/cm²', 10.0);
}

/// Pounds per square foot (lb/ft²).
final class PoundsPerSquareFoot extends AreaDensityUnit {
  const PoundsPerSquareFoot._() : super('pound/square foot', 'lb/ft²', 4.88242763638);
}

/// Extension methods for constructing [AreaDensity] values from [num].
extension AreaDensityOps on num {
  /// Creates an [AreaDensity] of this value in kilograms per square meter.
  AreaDensity get kilogramsPerSquareMeter => AreaDensity.kilogramsPerSquareMeter(this);

  /// Creates an [AreaDensity] of this value in grams per square centimeter.
  AreaDensity get gramsPerSquareCentimeter => AreaDensity.gramsPerSquareCentimeter(this);

  /// Creates an [AreaDensity] of this value in pounds per square foot.
  AreaDensity get poundsPerSquareFoot => AreaDensity.poundsPerSquareFoot(this);
}
