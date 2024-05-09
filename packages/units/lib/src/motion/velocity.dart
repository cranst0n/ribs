import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Velocity extends Quantity<Velocity> {
  Velocity(super.value, super.unit);

  Velocity get toFeetPerSecond => to(feetPerSecond).feetPerSecond;
  Velocity get toMillimetersPerSecond =>
      to(millimetersPerSecond).millimetersPerSecond;
  Velocity get toMetersPerSecond => to(metersPerSecond).metersPerSecond;
  Velocity get toKilometersPerSecond =>
      to(kilometersPerSecond).kilometersPerSecond;
  Velocity get toKilometersPerHour => to(kilometersPerHour).kilometersPerHour;
  Velocity get toUsMilesPerHour => to(usMilesPerHour).usMilesPerHour;
  Velocity get toKnots => to(knots).knots;

  static final VelocityUnit feetPerSecond = FeetPerSecond._();
  static final VelocityUnit millimetersPerSecond = MillimetersPerSecond._();
  static final VelocityUnit metersPerSecond = MetersPerSecond._();
  static final VelocityUnit kilometersPerSecond = KilometersPerSecond._();
  static final VelocityUnit kilometersPerHour = KilometersPerHour._();
  static final VelocityUnit usMilesPerHour = UsMilesPerHour._();
  static final VelocityUnit knots = Knots._();

  static final units = {
    feetPerSecond,
    millimetersPerSecond,
    metersPerSecond,
    kilometersPerSecond,
    kilometersPerHour,
    usMilesPerHour,
    knots,
  };

  static Option<Velocity> parse(String s) => Quantity.parse(s, units);
}

abstract class VelocityUnit extends BaseUnit<Velocity> {
  VelocityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Velocity call(num value) => Velocity(value.toDouble(), this);
}

final class FeetPerSecond extends VelocityUnit {
  FeetPerSecond._()
      : super('feet/second', 'ft/s',
            Length.feet.conversionFactor / Length.meters.conversionFactor);
}

final class MillimetersPerSecond extends VelocityUnit {
  MillimetersPerSecond._()
      : super(
            'millimeters/second',
            'mm/s',
            Length.millimeters.conversionFactor /
                Length.meters.conversionFactor);
}

final class MetersPerSecond extends VelocityUnit {
  MetersPerSecond._() : super('meters/second', 'm/s', 1.0);
}

final class KilometersPerSecond extends VelocityUnit {
  KilometersPerSecond._()
      : super(
            'kilometers/second',
            'km/s',
            Length.kilometers.conversionFactor /
                Length.meters.conversionFactor);
}

final class KilometersPerHour extends VelocityUnit {
  KilometersPerHour._()
      : super(
            'kilometers/hour',
            'km/h',
            Length.kilometers.conversionFactor /
                Length.meters.conversionFactor /
                Duration.secondsPerHour);
}

final class UsMilesPerHour extends VelocityUnit {
  UsMilesPerHour._()
      : super(
            'miles/hour',
            'mph',
            Length.usMiles.conversionFactor /
                Length.meters.conversionFactor /
                Duration.secondsPerHour);
}

final class Knots extends VelocityUnit {
  Knots._()
      : super(
            'knot',
            'kn',
            Length.nauticalMiles.conversionFactor /
                Length.meters.conversionFactor /
                Duration.secondsPerHour);
}

extension VelocityOps on num {
  Velocity get feetPerSecond => Velocity.feetPerSecond(this);
  Velocity get millimetersPerSecond => Velocity.millimetersPerSecond(this);
  Velocity get metersPerSecond => Velocity.metersPerSecond(this);
  Velocity get kilometersPerSecond => Velocity.kilometersPerSecond(this);
  Velocity get kilometersPerHour => Velocity.kilometersPerHour(this);
  Velocity get usMilesPerHour => Velocity.usMilesPerHour(this);
  Velocity get knots => Velocity.knots(this);
}
