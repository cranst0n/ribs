import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing irradiance — the radiant flux received per unit area.
final class Irradiance extends Quantity<Irradiance> {
  Irradiance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Irradiance].
  Irradiance operator +(Irradiance that) => Irradiance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Irradiance].
  Irradiance operator -(Irradiance that) => Irradiance(value - that.to(unit), unit);

  /// Converts this to milliwatts per square meter (mW/m²).
  Irradiance get toMilliwattsPerSquareMeter =>
      to(milliwattsPerSquareMeter).milliwattsPerSquareMeter;

  /// Converts this to watts per square meter (W/m²).
  Irradiance get toWattsPerSquareMeter => to(wattsPerSquareMeter).wattsPerSquareMeter;

  /// Converts this to ergs per second per square centimeter (erg/s/cm²).
  Irradiance get toErgsPerSecondPerSquareCentimeter =>
      to(ergsPerSecondPerSquareCentimeter).ergsPerSecondPerSquareCentimeter;

  /// Unit for milliwatts per square meter (mW/m²).
  static const IrradianceUnit milliwattsPerSquareMeter = MilliwattsPerSquareMeter._();

  /// Unit for watts per square meter (W/m²) — the SI unit of irradiance.
  static const IrradianceUnit wattsPerSquareMeter = WattsPerSquareMeter._();

  /// Unit for ergs per second per square centimeter (erg/s/cm²).
  static const IrradianceUnit ergsPerSecondPerSquareCentimeter =
      ErgsPerSecondPerSquareCentimeter._();

  /// All supported [Irradiance] units.
  static const units = {
    milliwattsPerSquareMeter,
    wattsPerSquareMeter,
    ergsPerSecondPerSquareCentimeter,
  };

  /// Parses [s] into an [Irradiance], returning [None] if parsing fails.
  static Option<Irradiance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Irradiance] units.
abstract class IrradianceUnit extends BaseUnit<Irradiance> {
  const IrradianceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Irradiance call(num value) => Irradiance(value.toDouble(), this);
}

/// Milliwatts per square meter (mW/m²).
final class MilliwattsPerSquareMeter extends IrradianceUnit {
  const MilliwattsPerSquareMeter._() : super('milliwatt/square meter', 'mW/m²', MetricSystem.Milli);
}

/// Watts per square meter (W/m²) — the SI unit of irradiance.
final class WattsPerSquareMeter extends IrradianceUnit {
  const WattsPerSquareMeter._() : super('watt/square meter', 'W/m²', 1.0);
}

/// Ergs per second per square centimeter (erg/s/cm²).
final class ErgsPerSecondPerSquareCentimeter extends IrradianceUnit {
  const ErgsPerSecondPerSquareCentimeter._()
    : super('erg/second/square centimeter', 'erg/s/cm²', 1e-3);
}

/// Extension methods for constructing [Irradiance] values from [num].
extension IrradianceOps on num {
  /// Creates an [Irradiance] of this value in milliwatts per square meter.
  Irradiance get milliwattsPerSquareMeter => Irradiance.milliwattsPerSquareMeter(this);

  /// Creates an [Irradiance] of this value in watts per square meter.
  Irradiance get wattsPerSquareMeter => Irradiance.wattsPerSquareMeter(this);

  /// Creates an [Irradiance] of this value in ergs per second per square centimeter.
  Irradiance get ergsPerSecondPerSquareCentimeter =>
      Irradiance.ergsPerSecondPerSquareCentimeter(this);
}
