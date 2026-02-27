import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Angle extends Quantity<Angle> {
  Angle(super.value, super.unit);

  Angle operator +(Angle that) => Angle(value + that.to(unit), unit);
  Angle operator -(Angle that) => Angle(value - that.to(unit), unit);

  Angle get toRadians => to(radians).radians;
  Angle get toDegrees => to(degrees).degrees;
  Angle get toGradians => to(gradians).gradians;
  Angle get toTurns => to(turns).turns;
  Angle get toArcminutes => to(arcminutes).arcminutes;
  Angle get toArcseconds => to(arcseconds).arcseconds;

  double get sin => math.sin(toRadians.value);
  double get cos => math.cos(toRadians.value);
  double get tan => math.tan(toRadians.value);
  double get asin => math.asin(toRadians.value);
  double get acos => math.acos(toRadians.value);

  static const radians = Radians._();
  static const degrees = Degrees._();
  static const gradians = Gradians._();
  static const turns = Turns._();
  static const arcminutes = Arcminutes._();
  static const arcseconds = Arcseconds._();

  static const units = {
    radians,
    degrees,
    gradians,
    turns,
    arcminutes,
    arcseconds,
  };

  static Option<Angle> parse(String s) => Quantity.parse(s, units);
}

abstract class AngleUnit extends BaseUnit<Angle> {
  const AngleUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Angle call(num value) => Angle(value.toDouble(), this);
}

final class Radians extends AngleUnit {
  const Radians._() : super('radian', 'rad', 1);
}

final class Degrees extends AngleUnit {
  const Degrees._() : super('degree', '°', math.pi / 180);
}

final class Gradians extends AngleUnit {
  const Gradians._() : super('gradian', 'grad', 2 * math.pi / 400);
}

final class Turns extends AngleUnit {
  const Turns._() : super('turn', 'turns', 2 * math.pi);
}

final class Arcminutes extends AngleUnit {
  const Arcminutes._() : super('arc minute', 'amin', math.pi / 10800);
}

final class Arcseconds extends AngleUnit {
  const Arcseconds._()
    : super('arc second', 'asec', 1 / Duration.secondsPerMinute * math.pi / 10800);
}

extension AngleOps on num {
  Angle get radians => Angle.radians(this);
  Angle get degrees => Angle.degrees(this);
  Angle get gradians => Angle.gradians(this);
  Angle get turns => Angle.turns(this);
  Angle get arcminutes => Angle.arcminutes(this);
  Angle get arcseconds => Angle.arcseconds(this);
}
