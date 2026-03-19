import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class SpectralPower extends Quantity<SpectralPower> {
  SpectralPower(super.value, super.unit);

  SpectralPower operator +(SpectralPower that) => SpectralPower(value + that.to(unit), unit);
  SpectralPower operator -(SpectralPower that) => SpectralPower(value - that.to(unit), unit);

  SpectralPower get toMilliwattsPerMeter => to(milliwattsPerMeter).milliwattsPerMeter;
  SpectralPower get toWattsPerMeter => to(wattsPerMeter).wattsPerMeter;

  static const SpectralPowerUnit milliwattsPerMeter = MilliwattsPerMeter._();
  static const SpectralPowerUnit wattsPerMeter = WattsPerMeter._();

  static const units = {
    milliwattsPerMeter,
    wattsPerMeter,
  };

  static Option<SpectralPower> parse(String s) => Quantity.parse(s, units);
}

abstract class SpectralPowerUnit extends BaseUnit<SpectralPower> {
  const SpectralPowerUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SpectralPower call(num value) => SpectralPower(value.toDouble(), this);
}

final class MilliwattsPerMeter extends SpectralPowerUnit {
  const MilliwattsPerMeter._() : super('milliwatt/meter', 'mW/m', MetricSystem.Milli);
}

final class WattsPerMeter extends SpectralPowerUnit {
  const WattsPerMeter._() : super('watt/meter', 'W/m', 1.0);
}

extension SpectralPowerOps on num {
  SpectralPower get milliwattsPerMeter => SpectralPower.milliwattsPerMeter(this);
  SpectralPower get wattsPerMeter => SpectralPower.wattsPerMeter(this);
}
