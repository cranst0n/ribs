import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing a solid angle (the 3-D analogue of a plane angle).
final class SolidAngle extends Quantity<SolidAngle> {
  SolidAngle(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [SolidAngle].
  SolidAngle operator +(SolidAngle that) => SolidAngle(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [SolidAngle].
  SolidAngle operator -(SolidAngle that) => SolidAngle(value - that.to(unit), unit);

  /// Converts this to millisteradians (msr).
  SolidAngle get toMillisteradians => to(millisteradians).millisteradians;

  /// Converts this to steradians (sr).
  SolidAngle get toSteradians => to(steradians).steradians;

  /// Converts this to square degrees (deg²).
  SolidAngle get toSquareDegrees => to(squareDegrees).squareDegrees;

  /// Unit for millisteradians (msr).
  static const SolidAngleUnit millisteradians = Millisteradians._();

  /// Unit for steradians (sr) — the SI unit of solid angle.
  static const SolidAngleUnit steradians = Steradians._();

  /// Unit for square degrees (deg²).
  static const SolidAngleUnit squareDegrees = SquareDegrees._();

  /// All supported [SolidAngle] units.
  static const units = {
    millisteradians,
    steradians,
    squareDegrees,
  };

  /// Parses [s] into a [SolidAngle], returning [None] if parsing fails.
  static Option<SolidAngle> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [SolidAngle] units.
abstract class SolidAngleUnit extends BaseUnit<SolidAngle> {
  const SolidAngleUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SolidAngle call(num value) => SolidAngle(value.toDouble(), this);
}

/// Millisteradians (msr).
final class Millisteradians extends SolidAngleUnit {
  const Millisteradians._() : super('millisteradian', 'msr', MetricSystem.Milli);
}

/// Steradians (sr) — the SI unit of solid angle.
final class Steradians extends SolidAngleUnit {
  const Steradians._() : super('steradian', 'sr', 1.0);
}

/// Square degrees (deg²).
final class SquareDegrees extends SolidAngleUnit {
  const SquareDegrees._() : super('square degree', 'deg²', (math.pi / 180.0) * (math.pi / 180.0));
}

/// Extension methods for constructing [SolidAngle] values from [num].
extension SolidAngleOps on num {
  /// Creates a [SolidAngle] of this value in millisteradians.
  SolidAngle get millisteradians => SolidAngle.millisteradians(this);

  /// Creates a [SolidAngle] of this value in steradians.
  SolidAngle get steradians => SolidAngle.steradians(this);

  /// Creates a [SolidAngle] of this value in square degrees.
  SolidAngle get squareDegrees => SolidAngle.squareDegrees(this);
}
