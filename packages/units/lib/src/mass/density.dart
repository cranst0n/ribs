import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing volumetric mass density (mass per unit volume).
final class Density extends Quantity<Density> {
  Density(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Density].
  Density operator +(Density that) => Density(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Density].
  Density operator -(Density that) => Density(value - that.to(unit), unit);

  /// Converts this to kilograms per cubic meter (kg/m³).
  Density get toKilogramsPerCubicMeter => to(kilogramsPerCubicMeter).kilogramsPerCubicMeter;

  /// Converts this to grams per cubic centimeter (g/cm³).
  Density get toGramsPerCubicCentimeter => to(gramsPerCubicCentimeter).gramsPerCubicCentimeter;

  /// Converts this to kilograms per liter (kg/L).
  Density get toKilogramsPerLiter => to(kilogramsPerLiter).kilogramsPerLiter;

  /// Converts this to pounds per cubic foot (lb/ft³).
  Density get toPoundsPerCubicFoot => to(poundsPerCubicFoot).poundsPerCubicFoot;

  /// Converts this to pounds per cubic inch (lb/in³).
  Density get toPoundsPerCubicInch => to(poundsPerCubicInch).poundsPerCubicInch;

  /// Converts this to kilograms per cubic foot (kg/ft³).
  Density get toKilogramsPerCubicFoot => to(kilogramsPerCubicFoot).kilogramsPerCubicFoot;

  /// Unit for kilograms per cubic meter (kg/m³) — the SI unit of density.
  static const DensityUnit kilogramsPerCubicMeter = KilogramsPerCubicMeter._();

  /// Unit for grams per cubic centimeter (g/cm³).
  static const DensityUnit gramsPerCubicCentimeter = GramsPerCubicCentimeter._();

  /// Unit for kilograms per liter (kg/L).
  static const DensityUnit kilogramsPerLiter = KilogramsPerLiter._();

  /// Unit for pounds per cubic foot (lb/ft³).
  static const DensityUnit poundsPerCubicFoot = PoundsPerCubicFoot._();

  /// Unit for pounds per cubic inch (lb/in³).
  static const DensityUnit poundsPerCubicInch = PoundsPerCubicInch._();

  /// Unit for kilograms per cubic foot (kg/ft³).
  static const DensityUnit kilogramsPerCubicFoot = KilogramsPerCubicFoot._();

  /// All supported [Density] units.
  static const units = {
    kilogramsPerCubicMeter,
    gramsPerCubicCentimeter,
    kilogramsPerLiter,
    poundsPerCubicFoot,
    poundsPerCubicInch,
    kilogramsPerCubicFoot,
  };

  /// Parses [s] into a [Density], returning [None] if parsing fails.
  static Option<Density> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Density] units.
abstract class DensityUnit extends BaseUnit<Density> {
  const DensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Density call(num value) => Density(value.toDouble(), this);
}

/// Kilograms per cubic meter (kg/m³) — the SI unit of density.
final class KilogramsPerCubicMeter extends DensityUnit {
  const KilogramsPerCubicMeter._() : super('kilogram/cubic meter', 'kg/m³', 1.0);
}

/// Grams per cubic centimeter (g/cm³) — also known as specific gravity relative to water.
final class GramsPerCubicCentimeter extends DensityUnit {
  const GramsPerCubicCentimeter._() : super('gram/cubic centimeter', 'g/cm³', 1000.0);
}

/// Kilograms per liter (kg/L).
final class KilogramsPerLiter extends DensityUnit {
  const KilogramsPerLiter._() : super('kilogram/liter', 'kg/L', 1000.0);
}

/// Pounds per cubic foot (lb/ft³).
final class PoundsPerCubicFoot extends DensityUnit {
  const PoundsPerCubicFoot._() : super('pound/cubic foot', 'lb/ft³', 16.01846337396014);
}

/// Pounds per cubic inch (lb/in³).
final class PoundsPerCubicInch extends DensityUnit {
  const PoundsPerCubicInch._() : super('pound/cubic inch', 'lb/in³', 27679.9047102031);
}

/// Kilograms per cubic foot (kg/ft³).
final class KilogramsPerCubicFoot extends DensityUnit {
  const KilogramsPerCubicFoot._() : super('kilogram/cubic foot', 'kg/ft³', 35.3146667214886);
}

/// Extension methods for constructing [Density] values from [num].
extension DensityOps on num {
  /// Creates a [Density] of this value in kilograms per cubic meter.
  Density get kilogramsPerCubicMeter => Density.kilogramsPerCubicMeter(this);

  /// Creates a [Density] of this value in grams per cubic centimeter.
  Density get gramsPerCubicCentimeter => Density.gramsPerCubicCentimeter(this);

  /// Creates a [Density] of this value in kilograms per liter.
  Density get kilogramsPerLiter => Density.kilogramsPerLiter(this);

  /// Creates a [Density] of this value in pounds per cubic foot.
  Density get poundsPerCubicFoot => Density.poundsPerCubicFoot(this);

  /// Creates a [Density] of this value in pounds per cubic inch.
  Density get poundsPerCubicInch => Density.poundsPerCubicInch(this);

  /// Creates a [Density] of this value in kilograms per cubic foot.
  Density get kilogramsPerCubicFoot => Density.kilogramsPerCubicFoot(this);
}
