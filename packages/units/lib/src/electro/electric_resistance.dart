import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ElectricResistance extends Quantity<ElectricResistance> {
  ElectricResistance(super.value, super.unit);

  ElectricResistance operator +(ElectricResistance that) =>
      ElectricResistance(value + that.to(unit), unit);
  ElectricResistance operator -(ElectricResistance that) =>
      ElectricResistance(value - that.to(unit), unit);

  ElectricResistance get toMicroohms => to(microohms).microohms;
  ElectricResistance get toMilliohms => to(milliohms).milliohms;
  ElectricResistance get toOhms => to(ohms).ohms;
  ElectricResistance get toKiloohms => to(kiloohms).kiloohms;
  ElectricResistance get toMegaohms => to(megaohms).megaohms;
  ElectricResistance get toGigaohms => to(gigaohms).gigaohms;

  static const ElectricResistanceUnit microohms = Microohms._();
  static const ElectricResistanceUnit milliohms = Milliohms._();
  static const ElectricResistanceUnit ohms = Ohms._();
  static const ElectricResistanceUnit kiloohms = Kiloohms._();
  static const ElectricResistanceUnit megaohms = Megaohms._();
  static const ElectricResistanceUnit gigaohms = Gigaohms._();

  static const units = {
    microohms,
    milliohms,
    ohms,
    kiloohms,
    megaohms,
    gigaohms,
  };

  static Option<ElectricResistance> parse(String s) => Quantity.parse(s, units);
}

abstract class ElectricResistanceUnit extends BaseUnit<ElectricResistance> {
  const ElectricResistanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricResistance call(num value) => ElectricResistance(value.toDouble(), this);
}

final class Microohms extends ElectricResistanceUnit {
  const Microohms._() : super('microohm', 'µΩ', MetricSystem.Micro);
}

final class Milliohms extends ElectricResistanceUnit {
  const Milliohms._() : super('milliohm', 'mΩ', MetricSystem.Milli);
}

final class Ohms extends ElectricResistanceUnit {
  const Ohms._() : super('ohm', 'Ω', 1.0);
}

final class Kiloohms extends ElectricResistanceUnit {
  const Kiloohms._() : super('kiloohm', 'kΩ', MetricSystem.Kilo);
}

final class Megaohms extends ElectricResistanceUnit {
  const Megaohms._() : super('megaohm', 'MΩ', MetricSystem.Mega);
}

final class Gigaohms extends ElectricResistanceUnit {
  const Gigaohms._() : super('gigaohm', 'GΩ', MetricSystem.Giga);
}

extension ElectricResistanceOps on num {
  ElectricResistance get microohms => ElectricResistance.microohms(this);
  ElectricResistance get milliohms => ElectricResistance.milliohms(this);
  ElectricResistance get ohms => ElectricResistance.ohms(this);
  ElectricResistance get kiloohms => ElectricResistance.kiloohms(this);
  ElectricResistance get megaohms => ElectricResistance.megaohms(this);
  ElectricResistance get gigaohms => ElectricResistance.gigaohms(this);
}
