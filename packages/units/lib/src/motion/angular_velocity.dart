import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing angular velocity (rate of change of angle).
final class AngularVelocity extends Quantity<AngularVelocity> {
  AngularVelocity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [AngularVelocity].
  AngularVelocity operator +(AngularVelocity that) => AngularVelocity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [AngularVelocity].
  AngularVelocity operator -(AngularVelocity that) => AngularVelocity(value - that.to(unit), unit);

  /// Converts this to radians per second (rad/s).
  AngularVelocity get toRadiansPerSecond => to(radiansPerSecond).radiansPerSecond;

  /// Converts this to degrees per second (°/s).
  AngularVelocity get toDegreesPerSecond => to(degreesPerSecond).degreesPerSecond;

  /// Converts this to revolutions per second (rev/s).
  AngularVelocity get toRevolutionsPerSecond => to(revolutionsPerSecond).revolutionsPerSecond;

  /// Converts this to revolutions per minute (rpm).
  AngularVelocity get toRevolutionsPerMinute =>
      AngularVelocity(to(revolutionsPerMinute), revolutionsPerMinute);

  /// Converts this to radians per minute (rad/min).
  AngularVelocity get toRadiansPerMinute => to(radiansPerMinute).radiansPerMinute;

  /// Converts this to radians per hour (rad/h).
  AngularVelocity get toRadiansPerHour => to(radiansPerHour).radiansPerHour;

  /// Unit for radians per second (rad/s) — the SI unit of angular velocity.
  static const AngularVelocityUnit radiansPerSecond = RadiansPerSecond._();

  /// Unit for degrees per second (°/s).
  static const AngularVelocityUnit degreesPerSecond = DegreesPerSecond._();

  /// Unit for revolutions per second (rev/s).
  static const AngularVelocityUnit revolutionsPerSecond = RevolutionsPerSecond._();

  /// Unit for revolutions per minute (rpm).
  static const AngularVelocityUnit revolutionsPerMinute = AngularRevolutionsPerMinute._();

  /// Unit for radians per minute (rad/min).
  static const AngularVelocityUnit radiansPerMinute = RadiansPerMinute._();

  /// Unit for radians per hour (rad/h).
  static const AngularVelocityUnit radiansPerHour = RadiansPerHour._();

  /// All supported [AngularVelocity] units.
  static const units = {
    radiansPerSecond,
    degreesPerSecond,
    revolutionsPerSecond,
    revolutionsPerMinute,
    radiansPerMinute,
    radiansPerHour,
  };

  /// Parses [s] into an [AngularVelocity], returning [None] if parsing fails.
  static Option<AngularVelocity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [AngularVelocity] units.
abstract class AngularVelocityUnit extends BaseUnit<AngularVelocity> {
  const AngularVelocityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  AngularVelocity call(num value) => AngularVelocity(value.toDouble(), this);
}

/// Radians per second (rad/s) — the SI unit of angular velocity.
final class RadiansPerSecond extends AngularVelocityUnit {
  const RadiansPerSecond._() : super('radian/second', 'rad/s', 1.0);
}

/// Degrees per second (°/s).
final class DegreesPerSecond extends AngularVelocityUnit {
  const DegreesPerSecond._() : super('degree/second', '°/s', math.pi / 180.0);
}

/// Revolutions per second (rev/s).
final class RevolutionsPerSecond extends AngularVelocityUnit {
  const RevolutionsPerSecond._() : super('revolution/second', 'rev/s', 2.0 * math.pi);
}

/// Revolutions per minute (rpm).
final class AngularRevolutionsPerMinute extends AngularVelocityUnit {
  const AngularRevolutionsPerMinute._() : super('revolution/minute', 'rpm', 2.0 * math.pi / 60.0);
}

/// Radians per minute (rad/min).
final class RadiansPerMinute extends AngularVelocityUnit {
  const RadiansPerMinute._() : super('radian/minute', 'rad/min', 1.0 / 60.0);
}

/// Radians per hour (rad/h).
final class RadiansPerHour extends AngularVelocityUnit {
  const RadiansPerHour._() : super('radian/hour', 'rad/h', 1.0 / 3600.0);
}

/// Extension methods for constructing [AngularVelocity] values from [num].
extension AngularVelocityOps on num {
  /// Creates an [AngularVelocity] of this value in radians per second.
  AngularVelocity get radiansPerSecond => AngularVelocity.radiansPerSecond(this);

  /// Creates an [AngularVelocity] of this value in degrees per second.
  AngularVelocity get degreesPerSecond => AngularVelocity.degreesPerSecond(this);

  /// Creates an [AngularVelocity] of this value in revolutions per second.
  AngularVelocity get revolutionsPerSecond => AngularVelocity.revolutionsPerSecond(this);

  /// Creates an [AngularVelocity] of this value in radians per minute.
  AngularVelocity get radiansPerMinute => AngularVelocity.radiansPerMinute(this);

  /// Creates an [AngularVelocity] of this value in radians per hour.
  AngularVelocity get radiansPerHour => AngularVelocity.radiansPerHour(this);
}
