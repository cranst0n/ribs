import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Acceleration extends Quantity<Acceleration> {
  Acceleration(super.value, super.unit);

  Acceleration operator +(Acceleration that) => Acceleration(value + that.to(unit), unit);
  Acceleration operator -(Acceleration that) => Acceleration(value - that.to(unit), unit);

  Acceleration get toMetersPerSecondSquared => to(metersPerSecondSquared).metersPerSecondSquared;
  Acceleration get toFeetPerSecondSquared => to(feetPerSecondSquared).feetPerSecondSquared;
  Acceleration get toEarthGravities => to(earthGravities).earthGravities;

  static const AccelerationUnit metersPerSecondSquared = MetersPerSecondSquared._();
  static const AccelerationUnit feetPerSecondSquared = FeetPerSecondSquared._();
  static const AccelerationUnit earthGravities = EarthGravities._();

  static const units = {
    metersPerSecondSquared,
    feetPerSecondSquared,
    earthGravities,
  };

  static Option<Acceleration> parse(String s) => Quantity.parse(s, units);
}

abstract class AccelerationUnit extends BaseUnit<Acceleration> {
  const AccelerationUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Acceleration call(num value) => Acceleration(value.toDouble(), this);
}

final class MetersPerSecondSquared extends AccelerationUnit {
  const MetersPerSecondSquared._() : super('meters/second²', 'm/s²', 1.0);
}

final class FeetPerSecondSquared extends AccelerationUnit {
  const FeetPerSecondSquared._() : super('feet/second²', 'ft/s²', Length.FeetConversionFactor);
}

final class EarthGravities extends AccelerationUnit {
  const EarthGravities._() : super('earth gravity', 'g', 9.80665);
}

extension AccelerationOps on num {
  Acceleration get metersPerSecondSquared => Acceleration.metersPerSecondSquared(this);
  Acceleration get feetPerSecondSquared => Acceleration.feetPerSecondSquared(this);
  Acceleration get earthGravities => Acceleration.earthGravities(this);
}
