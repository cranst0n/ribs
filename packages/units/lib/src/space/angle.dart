import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing a plane angle.
final class Angle extends Quantity<Angle> {
  Angle(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Angle].
  Angle operator +(Angle that) => Angle(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Angle].
  Angle operator -(Angle that) => Angle(value - that.to(unit), unit);

  /// Divides this angle by [that] time to produce an [AngularVelocity] in rad/s.
  AngularVelocity operator /(Time that) =>
      AngularVelocity.radiansPerSecond(toRadians.value / that.toSeconds.value);

  /// Converts this to radians (rad).
  Angle get toRadians => to(radians).radians;

  /// Converts this to degrees (°).
  Angle get toDegrees => to(degrees).degrees;

  /// Converts this to gradians (grad).
  Angle get toGradians => to(gradians).gradians;

  /// Converts this to turns (full rotations).
  Angle get toTurns => to(turns).turns;

  /// Converts this to arcminutes (amin).
  Angle get toArcminutes => to(arcminutes).arcminutes;

  /// Converts this to arcseconds (asec).
  Angle get toArcseconds => to(arcseconds).arcseconds;

  /// The sine of this angle.
  double get sin => math.sin(toRadians.value);

  /// The cosine of this angle.
  double get cos => math.cos(toRadians.value);

  /// The tangent of this angle.
  double get tan => math.tan(toRadians.value);

  /// The arcsine of this angle's value (in radians).
  double get asin => math.asin(toRadians.value);

  /// The arccosine of this angle's value (in radians).
  double get acos => math.acos(toRadians.value);

  /// Unit for radians (rad).
  static const radians = Radians._();

  /// Unit for degrees (°).
  static const degrees = Degrees._();

  /// Unit for gradians (grad).
  static const gradians = Gradians._();

  /// Unit for turns (full rotations).
  static const turns = Turns._();

  /// Unit for arcminutes (amin).
  static const arcminutes = Arcminutes._();

  /// Unit for arcseconds (asec).
  static const arcseconds = Arcseconds._();

  /// All supported [Angle] units.
  static const units = {
    radians,
    degrees,
    gradians,
    turns,
    arcminutes,
    arcseconds,
  };

  /// Parses [s] into an [Angle], returning [None] if parsing fails.
  static Option<Angle> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Angle] units.
abstract class AngleUnit extends BaseUnit<Angle> {
  const AngleUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Angle call(num value) => Angle(value.toDouble(), this);
}

/// Radians (rad) — the SI unit of plane angle.
final class Radians extends AngleUnit {
  const Radians._() : super('radian', 'rad', 1);
}

/// Degrees (°) — 1/360 of a full rotation.
final class Degrees extends AngleUnit {
  const Degrees._() : super('degree', '°', math.pi / 180);
}

/// Gradians (grad) — 1/400 of a full rotation.
final class Gradians extends AngleUnit {
  const Gradians._() : super('gradian', 'grad', 2 * math.pi / 400);
}

/// Turns — one full rotation (2π radians).
final class Turns extends AngleUnit {
  const Turns._() : super('turn', 'turns', 2 * math.pi);
}

/// Arcminutes (amin) — 1/60 of a degree.
final class Arcminutes extends AngleUnit {
  const Arcminutes._() : super('arc minute', 'amin', math.pi / 10800);
}

/// Arcseconds (asec) — 1/60 of an arcminute.
final class Arcseconds extends AngleUnit {
  const Arcseconds._()
    : super('arc second', 'asec', 1 / Duration.secondsPerMinute * math.pi / 10800);
}

/// Extension methods for constructing [Angle] values from [num].
extension AngleOps on num {
  /// Creates an [Angle] of this value in radians.
  Angle get radians => Angle.radians(this);

  /// Creates an [Angle] of this value in degrees.
  Angle get degrees => Angle.degrees(this);

  /// Creates an [Angle] of this value in gradians.
  Angle get gradians => Angle.gradians(this);

  /// Creates an [Angle] of this value in turns.
  Angle get turns => Angle.turns(this);

  /// Creates an [Angle] of this value in arcminutes.
  Angle get arcminutes => Angle.arcminutes(this);

  /// Creates an [Angle] of this value in arcseconds.
  Angle get arcseconds => Angle.arcseconds(this);
}
