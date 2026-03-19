import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Radiance extends Quantity<Radiance> {
  Radiance(super.value, super.unit);

  Radiance operator +(Radiance that) => Radiance(value + that.to(unit), unit);
  Radiance operator -(Radiance that) => Radiance(value - that.to(unit), unit);

  Radiance get toMilliwattsPerSteradianPerSquareMeter =>
      to(milliwattsPerSteradianPerSquareMeter).milliwattsPerSteradianPerSquareMeter;
  Radiance get toWattsPerSteradianPerSquareMeter =>
      to(wattsPerSteradianPerSquareMeter).wattsPerSteradianPerSquareMeter;

  static const RadianceUnit milliwattsPerSteradianPerSquareMeter =
      MilliwattsPerSteradianPerSquareMeter._();
  static const RadianceUnit wattsPerSteradianPerSquareMeter = WattsPerSteradianPerSquareMeter._();

  static const units = {
    milliwattsPerSteradianPerSquareMeter,
    wattsPerSteradianPerSquareMeter,
  };

  static Option<Radiance> parse(String s) => Quantity.parse(s, units);
}

abstract class RadianceUnit extends BaseUnit<Radiance> {
  const RadianceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Radiance call(num value) => Radiance(value.toDouble(), this);
}

final class MilliwattsPerSteradianPerSquareMeter extends RadianceUnit {
  const MilliwattsPerSteradianPerSquareMeter._()
    : super('milliwatt/steradian/square meter', 'mW/sr/m²', MetricSystem.Milli);
}

final class WattsPerSteradianPerSquareMeter extends RadianceUnit {
  const WattsPerSteradianPerSquareMeter._() : super('watt/steradian/square meter', 'W/sr/m²', 1.0);
}

extension RadianceOps on num {
  Radiance get milliwattsPerSteradianPerSquareMeter =>
      Radiance.milliwattsPerSteradianPerSquareMeter(this);
  Radiance get wattsPerSteradianPerSquareMeter => Radiance.wattsPerSteradianPerSquareMeter(this);
}
