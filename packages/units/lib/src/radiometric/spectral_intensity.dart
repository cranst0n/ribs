import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class SpectralIntensity extends Quantity<SpectralIntensity> {
  SpectralIntensity(super.value, super.unit);

  SpectralIntensity operator +(SpectralIntensity that) =>
      SpectralIntensity(value + that.to(unit), unit);
  SpectralIntensity operator -(SpectralIntensity that) =>
      SpectralIntensity(value - that.to(unit), unit);

  SpectralIntensity get toMilliwattsPerSteradianPerMeter =>
      to(milliwattsPerSteradianPerMeter).milliwattsPerSteradianPerMeter;
  SpectralIntensity get toWattsPerSteradianPerMeter =>
      to(wattsPerSteradianPerMeter).wattsPerSteradianPerMeter;

  static const SpectralIntensityUnit milliwattsPerSteradianPerMeter =
      MilliwattsPerSteradianPerMeter._();
  static const SpectralIntensityUnit wattsPerSteradianPerMeter = WattsPerSteradianPerMeter._();

  static const units = {
    milliwattsPerSteradianPerMeter,
    wattsPerSteradianPerMeter,
  };

  static Option<SpectralIntensity> parse(String s) => Quantity.parse(s, units);
}

abstract class SpectralIntensityUnit extends BaseUnit<SpectralIntensity> {
  const SpectralIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SpectralIntensity call(num value) => SpectralIntensity(value.toDouble(), this);
}

final class MilliwattsPerSteradianPerMeter extends SpectralIntensityUnit {
  const MilliwattsPerSteradianPerMeter._()
    : super('milliwatt/steradian/meter', 'mW/sr/m', MetricSystem.Milli);
}

final class WattsPerSteradianPerMeter extends SpectralIntensityUnit {
  const WattsPerSteradianPerMeter._() : super('watt/steradian/meter', 'W/sr/m', 1.0);
}

extension SpectralIntensityOps on num {
  SpectralIntensity get milliwattsPerSteradianPerMeter =>
      SpectralIntensity.milliwattsPerSteradianPerMeter(this);
  SpectralIntensity get wattsPerSteradianPerMeter =>
      SpectralIntensity.wattsPerSteradianPerMeter(this);
}
