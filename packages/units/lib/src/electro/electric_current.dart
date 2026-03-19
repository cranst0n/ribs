import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ElectricCurrent extends Quantity<ElectricCurrent> {
  ElectricCurrent(super.value, super.unit);

  ElectricCurrent operator +(ElectricCurrent that) => ElectricCurrent(value + that.to(unit), unit);
  ElectricCurrent operator -(ElectricCurrent that) => ElectricCurrent(value - that.to(unit), unit);

  ElectricPotential operator *(ElectricResistance that) =>
      ElectricPotential.volts(toAmperes.value * that.toOhms.value);

  ElectricCurrent get toMicroamperes => to(microamperes).microamperes;
  ElectricCurrent get toMilliamperes => to(milliamperes).milliamperes;
  ElectricCurrent get toAmperes => to(amperes).amperes;
  ElectricCurrent get toDeciamperes => to(deciamperes).deciamperes;
  ElectricCurrent get toKiloamperes => to(kiloamperes).kiloamperes;

  static const ElectricCurrentUnit microamperes = Microamperes._();
  static const ElectricCurrentUnit milliamperes = Milliamperes._();
  static const ElectricCurrentUnit amperes = Amperes._();
  static const ElectricCurrentUnit deciamperes = Deciamperes._();
  static const ElectricCurrentUnit kiloamperes = Kiloamperes._();

  static const units = {
    microamperes,
    milliamperes,
    amperes,
    deciamperes,
    kiloamperes,
  };

  static Option<ElectricCurrent> parse(String s) => Quantity.parse(s, units);
}

abstract class ElectricCurrentUnit extends BaseUnit<ElectricCurrent> {
  const ElectricCurrentUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricCurrent call(num value) => ElectricCurrent(value.toDouble(), this);
}

final class Microamperes extends ElectricCurrentUnit {
  const Microamperes._() : super('microampere', 'µA', MetricSystem.Micro);
}

final class Milliamperes extends ElectricCurrentUnit {
  const Milliamperes._() : super('milliampere', 'mA', MetricSystem.Milli);
}

final class Amperes extends ElectricCurrentUnit {
  const Amperes._() : super('ampere', 'A', 1.0);
}

final class Deciamperes extends ElectricCurrentUnit {
  const Deciamperes._() : super('deciampere', 'dA', MetricSystem.Deci);
}

final class Kiloamperes extends ElectricCurrentUnit {
  const Kiloamperes._() : super('kiloampere', 'kA', MetricSystem.Kilo);
}

extension ElectricCurrentOps on num {
  ElectricCurrent get microamperes => ElectricCurrent.microamperes(this);
  ElectricCurrent get milliamperes => ElectricCurrent.milliamperes(this);
  ElectricCurrent get amperes => ElectricCurrent.amperes(this);
  ElectricCurrent get deciamperes => ElectricCurrent.deciamperes(this);
  ElectricCurrent get kiloamperes => ElectricCurrent.kiloamperes(this);
}
