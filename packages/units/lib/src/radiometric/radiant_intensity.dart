import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class RadiantIntensity extends Quantity<RadiantIntensity> {
  RadiantIntensity(super.value, super.unit);

  RadiantIntensity operator +(RadiantIntensity that) =>
      RadiantIntensity(value + that.to(unit), unit);
  RadiantIntensity operator -(RadiantIntensity that) =>
      RadiantIntensity(value - that.to(unit), unit);

  RadiantIntensity get toMilliwattsPerSteradian =>
      to(milliwattsPerSteradian).milliwattsPerSteradian;
  RadiantIntensity get toWattsPerSteradian => to(wattsPerSteradian).wattsPerSteradian;

  static const RadiantIntensityUnit milliwattsPerSteradian = MilliwattsPerSteradian._();
  static const RadiantIntensityUnit wattsPerSteradian = WattsPerSteradian._();

  static const units = {
    milliwattsPerSteradian,
    wattsPerSteradian,
  };

  static Option<RadiantIntensity> parse(String s) => Quantity.parse(s, units);
}

abstract class RadiantIntensityUnit extends BaseUnit<RadiantIntensity> {
  const RadiantIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  RadiantIntensity call(num value) => RadiantIntensity(value.toDouble(), this);
}

final class MilliwattsPerSteradian extends RadiantIntensityUnit {
  const MilliwattsPerSteradian._() : super('milliwatt/steradian', 'mW/sr', MetricSystem.Milli);
}

final class WattsPerSteradian extends RadiantIntensityUnit {
  const WattsPerSteradian._() : super('watt/steradian', 'W/sr', 1.0);
}

extension RadiantIntensityOps on num {
  RadiantIntensity get milliwattsPerSteradian => RadiantIntensity.milliwattsPerSteradian(this);
  RadiantIntensity get wattsPerSteradian => RadiantIntensity.wattsPerSteradian(this);
}
