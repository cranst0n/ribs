import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class AngularVelocity extends Quantity<AngularVelocity> {
  AngularVelocity(super.value, super.unit);

  AngularVelocity operator +(AngularVelocity that) => AngularVelocity(value + that.to(unit), unit);
  AngularVelocity operator -(AngularVelocity that) => AngularVelocity(value - that.to(unit), unit);

  AngularVelocity get toRadiansPerSecond => to(radiansPerSecond).radiansPerSecond;
  AngularVelocity get toDegreesPerSecond => to(degreesPerSecond).degreesPerSecond;
  AngularVelocity get toRevolutionsPerSecond => to(revolutionsPerSecond).revolutionsPerSecond;
  AngularVelocity get toRevolutionsPerMinute =>
      AngularVelocity(to(revolutionsPerMinute), revolutionsPerMinute);
  AngularVelocity get toRadiansPerMinute => to(radiansPerMinute).radiansPerMinute;
  AngularVelocity get toRadiansPerHour => to(radiansPerHour).radiansPerHour;

  static const AngularVelocityUnit radiansPerSecond = RadiansPerSecond._();
  static const AngularVelocityUnit degreesPerSecond = DegreesPerSecond._();
  static const AngularVelocityUnit revolutionsPerSecond = RevolutionsPerSecond._();
  static const AngularVelocityUnit revolutionsPerMinute = AngularRevolutionsPerMinute._();
  static const AngularVelocityUnit radiansPerMinute = RadiansPerMinute._();
  static const AngularVelocityUnit radiansPerHour = RadiansPerHour._();

  static const units = {
    radiansPerSecond,
    degreesPerSecond,
    revolutionsPerSecond,
    revolutionsPerMinute,
    radiansPerMinute,
    radiansPerHour,
  };

  static Option<AngularVelocity> parse(String s) => Quantity.parse(s, units);
}

abstract class AngularVelocityUnit extends BaseUnit<AngularVelocity> {
  const AngularVelocityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  AngularVelocity call(num value) => AngularVelocity(value.toDouble(), this);
}

final class RadiansPerSecond extends AngularVelocityUnit {
  const RadiansPerSecond._() : super('radian/second', 'rad/s', 1.0);
}

final class DegreesPerSecond extends AngularVelocityUnit {
  const DegreesPerSecond._() : super('degree/second', '°/s', math.pi / 180.0);
}

final class RevolutionsPerSecond extends AngularVelocityUnit {
  const RevolutionsPerSecond._() : super('revolution/second', 'rev/s', 2.0 * math.pi);
}

final class AngularRevolutionsPerMinute extends AngularVelocityUnit {
  const AngularRevolutionsPerMinute._() : super('revolution/minute', 'rpm', 2.0 * math.pi / 60.0);
}

final class RadiansPerMinute extends AngularVelocityUnit {
  const RadiansPerMinute._() : super('radian/minute', 'rad/min', 1.0 / 60.0);
}

final class RadiansPerHour extends AngularVelocityUnit {
  const RadiansPerHour._() : super('radian/hour', 'rad/h', 1.0 / 3600.0);
}

extension AngularVelocityOps on num {
  AngularVelocity get radiansPerSecond => AngularVelocity.radiansPerSecond(this);
  AngularVelocity get degreesPerSecond => AngularVelocity.degreesPerSecond(this);
  AngularVelocity get revolutionsPerSecond => AngularVelocity.revolutionsPerSecond(this);
  AngularVelocity get radiansPerMinute => AngularVelocity.radiansPerMinute(this);
  AngularVelocity get radiansPerHour => AngularVelocity.radiansPerHour(this);
}
