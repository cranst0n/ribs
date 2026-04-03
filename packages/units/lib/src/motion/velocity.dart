import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing linear velocity (speed in a given direction).
final class Velocity extends Quantity<Velocity> {
  Velocity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Velocity].
  Velocity operator +(Velocity that) => Velocity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Velocity].
  Velocity operator -(Velocity that) => Velocity(value - that.to(unit), unit);

  /// Divides this velocity by [that] time to produce an [Acceleration] in m/s².
  Acceleration operator /(Time that) =>
      Acceleration.metersPerSecondSquared(toMetersPerSecond.value / that.toSeconds.value);

  /// Converts this to feet per second (ft/s).
  Velocity get toFeetPerSecond => to(feetPerSecond).feetPerSecond;

  /// Converts this to millimeters per second (mm/s).
  Velocity get toMillimetersPerSecond => to(millimetersPerSecond).millimetersPerSecond;

  /// Converts this to meters per second (m/s).
  Velocity get toMetersPerSecond => to(metersPerSecond).metersPerSecond;

  /// Converts this to kilometers per second (km/s).
  Velocity get toKilometersPerSecond => to(kilometersPerSecond).kilometersPerSecond;

  /// Converts this to kilometers per hour (km/h).
  Velocity get toKilometersPerHour => to(kilometersPerHour).kilometersPerHour;

  /// Converts this to US miles per hour (mph).
  Velocity get toUsMilesPerHour => to(usMilesPerHour).usMilesPerHour;

  /// Converts this to knots (kn).
  Velocity get toKnots => to(knots).knots;

  /// Unit for feet per second (ft/s).
  static final VelocityUnit feetPerSecond = FeetPerSecond._();

  /// Unit for millimeters per second (mm/s).
  static final VelocityUnit millimetersPerSecond = MillimetersPerSecond._();

  /// Unit for meters per second (m/s) — the SI unit of velocity.
  static final VelocityUnit metersPerSecond = MetersPerSecond._();

  /// Unit for kilometers per second (km/s).
  static final VelocityUnit kilometersPerSecond = KilometersPerSecond._();

  /// Unit for kilometers per hour (km/h).
  static final VelocityUnit kilometersPerHour = KilometersPerHour._();

  /// Unit for US miles per hour (mph).
  static final VelocityUnit usMilesPerHour = UsMilesPerHour._();

  /// Unit for knots (kn) — nautical miles per hour.
  static final VelocityUnit knots = Knots._();

  /// All supported [Velocity] units.
  static final units = {
    feetPerSecond,
    millimetersPerSecond,
    metersPerSecond,
    kilometersPerSecond,
    kilometersPerHour,
    usMilesPerHour,
    knots,
  };

  /// Parses [s] into a [Velocity], returning [None] if parsing fails.
  static Option<Velocity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Velocity] units.
abstract class VelocityUnit extends BaseUnit<Velocity> {
  VelocityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Velocity call(num value) => Velocity(value.toDouble(), this);
}

/// Feet per second (ft/s).
final class FeetPerSecond extends VelocityUnit {
  FeetPerSecond._()
    : super('feet/second', 'ft/s', Length.feet.conversionFactor / Length.meters.conversionFactor);
}

/// Millimeters per second (mm/s).
final class MillimetersPerSecond extends VelocityUnit {
  MillimetersPerSecond._()
    : super(
        'millimeters/second',
        'mm/s',
        Length.millimeters.conversionFactor / Length.meters.conversionFactor,
      );
}

/// Meters per second (m/s) — the SI unit of velocity.
final class MetersPerSecond extends VelocityUnit {
  MetersPerSecond._() : super('meters/second', 'm/s', 1.0);
}

/// Kilometers per second (km/s).
final class KilometersPerSecond extends VelocityUnit {
  KilometersPerSecond._()
    : super(
        'kilometers/second',
        'km/s',
        Length.kilometers.conversionFactor / Length.meters.conversionFactor,
      );
}

/// Kilometers per hour (km/h).
final class KilometersPerHour extends VelocityUnit {
  KilometersPerHour._()
    : super(
        'kilometers/hour',
        'km/h',
        Length.kilometers.conversionFactor /
            Length.meters.conversionFactor /
            Duration.secondsPerHour,
      );
}

/// US miles per hour (mph).
final class UsMilesPerHour extends VelocityUnit {
  UsMilesPerHour._()
    : super(
        'miles/hour',
        'mph',
        Length.usMiles.conversionFactor / Length.meters.conversionFactor / Duration.secondsPerHour,
      );
}

/// Knots (kn) — nautical miles per hour.
final class Knots extends VelocityUnit {
  Knots._()
    : super(
        'knot',
        'kn',
        Length.nauticalMiles.conversionFactor /
            Length.meters.conversionFactor /
            Duration.secondsPerHour,
      );
}

/// Extension methods for constructing [Velocity] values from [num].
extension VelocityOps on num {
  /// Creates a [Velocity] of this value in feet per second.
  Velocity get feetPerSecond => Velocity.feetPerSecond(this);

  /// Creates a [Velocity] of this value in millimeters per second.
  Velocity get millimetersPerSecond => Velocity.millimetersPerSecond(this);

  /// Creates a [Velocity] of this value in meters per second.
  Velocity get metersPerSecond => Velocity.metersPerSecond(this);

  /// Creates a [Velocity] of this value in kilometers per second.
  Velocity get kilometersPerSecond => Velocity.kilometersPerSecond(this);

  /// Creates a [Velocity] of this value in kilometers per hour.
  Velocity get kilometersPerHour => Velocity.kilometersPerHour(this);

  /// Creates a [Velocity] of this value in US miles per hour.
  Velocity get usMilesPerHour => Velocity.usMilesPerHour(this);

  /// Creates a [Velocity] of this value in knots.
  Velocity get knots => Velocity.knots(this);
}
