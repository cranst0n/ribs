import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ElectricConductance extends Quantity<ElectricConductance> {
  ElectricConductance(super.value, super.unit);

  ElectricConductance operator +(ElectricConductance that) =>
      ElectricConductance(value + that.to(unit), unit);
  ElectricConductance operator -(ElectricConductance that) =>
      ElectricConductance(value - that.to(unit), unit);

  ElectricConductance get toPicosiemens => to(picosiemens).picosiemens;
  ElectricConductance get toMicrosiemens => to(microsiemens).microsiemens;
  ElectricConductance get toMillisiemens => to(millisiemens).millisiemens;
  ElectricConductance get toSiemens => to(siemens).siemens;

  static const ElectricConductanceUnit picosiemens = Picosiemens._();
  static const ElectricConductanceUnit microsiemens = Microsiemens._();
  static const ElectricConductanceUnit millisiemens = Millisiemens._();
  static const ElectricConductanceUnit siemens = Siemens._();

  static const units = {
    picosiemens,
    microsiemens,
    millisiemens,
    siemens,
  };

  static Option<ElectricConductance> parse(String s) => Quantity.parse(s, units);
}

abstract class ElectricConductanceUnit extends BaseUnit<ElectricConductance> {
  const ElectricConductanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricConductance call(num value) => ElectricConductance(value.toDouble(), this);
}

final class Picosiemens extends ElectricConductanceUnit {
  const Picosiemens._() : super('picosiemens', 'pS', MetricSystem.Pico);
}

final class Microsiemens extends ElectricConductanceUnit {
  const Microsiemens._() : super('microsiemens', 'µS', MetricSystem.Micro);
}

final class Millisiemens extends ElectricConductanceUnit {
  const Millisiemens._() : super('millisiemens', 'mS', MetricSystem.Milli);
}

final class Siemens extends ElectricConductanceUnit {
  const Siemens._() : super('siemens', 'S', 1.0);
}

extension ElectricConductanceOps on num {
  ElectricConductance get picosiemens => ElectricConductance.picosiemens(this);
  ElectricConductance get microsiemens => ElectricConductance.microsiemens(this);
  ElectricConductance get millisiemens => ElectricConductance.millisiemens(this);
  ElectricConductance get siemens => ElectricConductance.siemens(this);
}
