import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing linear acceleration.
final class Acceleration extends Quantity<Acceleration> {
  Acceleration(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Acceleration].
  Acceleration operator +(Acceleration that) => Acceleration(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Acceleration].
  Acceleration operator -(Acceleration that) => Acceleration(value - that.to(unit), unit);

  /// Converts this to meters per second squared (m/s²).
  Acceleration get toMetersPerSecondSquared => to(metersPerSecondSquared).metersPerSecondSquared;

  /// Converts this to feet per second squared (ft/s²).
  Acceleration get toFeetPerSecondSquared => to(feetPerSecondSquared).feetPerSecondSquared;

  /// Converts this to Earth standard gravities (g ≈ 9.807 m/s²).
  Acceleration get toEarthGravities => to(earthGravities).earthGravities;

  /// Unit for meters per second squared (m/s²) — the SI unit of acceleration.
  static const AccelerationUnit metersPerSecondSquared = MetersPerSecondSquared._();

  /// Unit for feet per second squared (ft/s²).
  static const AccelerationUnit feetPerSecondSquared = FeetPerSecondSquared._();

  /// Unit for standard Earth gravity (g ≈ 9.80665 m/s²).
  static const AccelerationUnit earthGravities = EarthGravities._();

  /// All supported [Acceleration] units.
  static const units = {
    metersPerSecondSquared,
    feetPerSecondSquared,
    earthGravities,
  };

  /// Parses [s] into an [Acceleration], returning [None] if parsing fails.
  static Option<Acceleration> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Acceleration] units.
abstract class AccelerationUnit extends BaseUnit<Acceleration> {
  const AccelerationUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Acceleration call(num value) => Acceleration(value.toDouble(), this);
}

/// Meters per second squared (m/s²) — the SI unit of acceleration.
final class MetersPerSecondSquared extends AccelerationUnit {
  const MetersPerSecondSquared._() : super('meters/second²', 'm/s²', 1.0);
}

/// Feet per second squared (ft/s²).
final class FeetPerSecondSquared extends AccelerationUnit {
  const FeetPerSecondSquared._() : super('feet/second²', 'ft/s²', Length.FeetConversionFactor);
}

/// Standard Earth gravity (g ≈ 9.80665 m/s²).
final class EarthGravities extends AccelerationUnit {
  const EarthGravities._() : super('earth gravity', 'g', 9.80665);
}

/// Extension methods for constructing [Acceleration] values from [num].
extension AccelerationOps on num {
  /// Creates an [Acceleration] of this value in meters per second squared.
  Acceleration get metersPerSecondSquared => Acceleration.metersPerSecondSquared(this);

  /// Creates an [Acceleration] of this value in feet per second squared.
  Acceleration get feetPerSecondSquared => Acceleration.feetPerSecondSquared(this);

  /// Creates an [Acceleration] of this value in standard Earth gravities.
  Acceleration get earthGravities => Acceleration.earthGravities(this);
}
