import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ElectricPotential extends Quantity<ElectricPotential> {
  ElectricPotential(super.value, super.unit);

  ElectricPotential get toMicrovolts => to(microvolts).microvolts;
  ElectricPotential get toMillivolts => to(millivolts).millivolts;
  ElectricPotential get toVolts => to(volts).volts;
  ElectricPotential get toMilovolts => to(milovolts).milovolts;
  ElectricPotential get toMegavolts => to(megavolts).megavolts;

  static const ElectricPotentialUnit microvolts = Microvolts._();
  static const ElectricPotentialUnit millivolts = Millivolts._();
  static const ElectricPotentialUnit volts = Volts._();
  static const ElectricPotentialUnit milovolts = Kilovolts._();
  static const ElectricPotentialUnit megavolts = Megavolts._();

  static const units = {
    microvolts,
    millivolts,
    volts,
    milovolts,
    megavolts,
  };

  static Option<ElectricPotential> parse(String s) => Quantity.parse(s, units);
}

abstract class ElectricPotentialUnit extends BaseUnit<ElectricPotential> {
  const ElectricPotentialUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricPotential call(num value) =>
      ElectricPotential(value.toDouble(), this);
}

final class Microvolts extends ElectricPotentialUnit {
  const Microvolts._() : super('microvolt', 'μV', MetricSystem.Micro);
}

final class Millivolts extends ElectricPotentialUnit {
  const Millivolts._() : super('millivolt', 'mV', MetricSystem.Milli);
}

final class Volts extends ElectricPotentialUnit {
  const Volts._() : super('volt', 'V', 1.0);
}

final class Kilovolts extends ElectricPotentialUnit {
  const Kilovolts._() : super('kilovolt', 'kV', MetricSystem.Kilo);
}

final class Megavolts extends ElectricPotentialUnit {
  const Megavolts._() : super('megavolt', 'MV', MetricSystem.Mega);
}

extension ElectricPotentialOps on num {
  ElectricPotential get microvolts => ElectricPotential.microvolts(this);
  ElectricPotential get millivolts => ElectricPotential.millivolts(this);
  ElectricPotential get volts => ElectricPotential.volts(this);
  ElectricPotential get milovolts => ElectricPotential.milovolts(this);
  ElectricPotential get megavolts => ElectricPotential.megavolts(this);
}
