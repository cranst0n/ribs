import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing radiance — the radiant flux emitted, reflected, or
/// received per unit solid angle per unit projected area.
final class Radiance extends Quantity<Radiance> {
  Radiance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Radiance].
  Radiance operator +(Radiance that) => Radiance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Radiance].
  Radiance operator -(Radiance that) => Radiance(value - that.to(unit), unit);

  /// Converts this to milliwatts per steradian per square meter (mW/sr/m²).
  Radiance get toMilliwattsPerSteradianPerSquareMeter =>
      to(milliwattsPerSteradianPerSquareMeter).milliwattsPerSteradianPerSquareMeter;

  /// Converts this to watts per steradian per square meter (W/sr/m²).
  Radiance get toWattsPerSteradianPerSquareMeter =>
      to(wattsPerSteradianPerSquareMeter).wattsPerSteradianPerSquareMeter;

  /// Unit for milliwatts per steradian per square meter (mW/sr/m²).
  static const RadianceUnit milliwattsPerSteradianPerSquareMeter =
      MilliwattsPerSteradianPerSquareMeter._();

  /// Unit for watts per steradian per square meter (W/sr/m²) — the SI unit of radiance.
  static const RadianceUnit wattsPerSteradianPerSquareMeter = WattsPerSteradianPerSquareMeter._();

  /// All supported [Radiance] units.
  static const units = {
    milliwattsPerSteradianPerSquareMeter,
    wattsPerSteradianPerSquareMeter,
  };

  /// Parses [s] into a [Radiance], returning [None] if parsing fails.
  static Option<Radiance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Radiance] units.
abstract class RadianceUnit extends BaseUnit<Radiance> {
  const RadianceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Radiance call(num value) => Radiance(value.toDouble(), this);
}

/// Milliwatts per steradian per square meter (mW/sr/m²).
final class MilliwattsPerSteradianPerSquareMeter extends RadianceUnit {
  const MilliwattsPerSteradianPerSquareMeter._()
    : super('milliwatt/steradian/square meter', 'mW/sr/m²', MetricSystem.Milli);
}

/// Watts per steradian per square meter (W/sr/m²) — the SI unit of radiance.
final class WattsPerSteradianPerSquareMeter extends RadianceUnit {
  const WattsPerSteradianPerSquareMeter._() : super('watt/steradian/square meter', 'W/sr/m²', 1.0);
}

/// Extension methods for constructing [Radiance] values from [num].
extension RadianceOps on num {
  /// Creates a [Radiance] of this value in milliwatts per steradian per square meter.
  Radiance get milliwattsPerSteradianPerSquareMeter =>
      Radiance.milliwattsPerSteradianPerSquareMeter(this);

  /// Creates a [Radiance] of this value in watts per steradian per square meter.
  Radiance get wattsPerSteradianPerSquareMeter => Radiance.wattsPerSteradianPerSquareMeter(this);
}
