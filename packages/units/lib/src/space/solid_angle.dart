import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class SolidAngle extends Quantity<SolidAngle> {
  SolidAngle(super.value, super.unit);

  SolidAngle operator +(SolidAngle that) => SolidAngle(value + that.to(unit), unit);
  SolidAngle operator -(SolidAngle that) => SolidAngle(value - that.to(unit), unit);

  SolidAngle get toMillisteradians => to(millisteradians).millisteradians;
  SolidAngle get toSteradians => to(steradians).steradians;
  SolidAngle get toSquareDegrees => to(squareDegrees).squareDegrees;

  static const SolidAngleUnit millisteradians = Millisteradians._();
  static const SolidAngleUnit steradians = Steradians._();
  static const SolidAngleUnit squareDegrees = SquareDegrees._();

  static const units = {
    millisteradians,
    steradians,
    squareDegrees,
  };

  static Option<SolidAngle> parse(String s) => Quantity.parse(s, units);
}

abstract class SolidAngleUnit extends BaseUnit<SolidAngle> {
  const SolidAngleUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SolidAngle call(num value) => SolidAngle(value.toDouble(), this);
}

final class Millisteradians extends SolidAngleUnit {
  const Millisteradians._() : super('millisteradian', 'msr', MetricSystem.Milli);
}

final class Steradians extends SolidAngleUnit {
  const Steradians._() : super('steradian', 'sr', 1.0);
}

final class SquareDegrees extends SolidAngleUnit {
  const SquareDegrees._() : super('square degree', 'deg²', (math.pi / 180.0) * (math.pi / 180.0));
}

extension SolidAngleOps on num {
  SolidAngle get millisteradians => SolidAngle.millisteradians(this);
  SolidAngle get steradians => SolidAngle.steradians(this);
  SolidAngle get squareDegrees => SolidAngle.squareDegrees(this);
}
