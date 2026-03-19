import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Capacitance extends Quantity<Capacitance> {
  Capacitance(super.value, super.unit);

  Capacitance operator +(Capacitance that) => Capacitance(value + that.to(unit), unit);
  Capacitance operator -(Capacitance that) => Capacitance(value - that.to(unit), unit);

  Capacitance get toFemtofarads => to(femtofarads).femtofarads;
  Capacitance get toPicofarads => to(picofarads).picofarads;
  Capacitance get toNanofarads => to(nanofarads).nanofarads;
  Capacitance get toMicrofarads => to(microfarads).microfarads;
  Capacitance get toMillifarads => to(millifarads).millifarads;
  Capacitance get toFarads => to(farads).farads;

  static const CapacitanceUnit femtofarads = Femtofarads._();
  static const CapacitanceUnit picofarads = Picofarads._();
  static const CapacitanceUnit nanofarads = Nanofarads._();
  static const CapacitanceUnit microfarads = Microfarads._();
  static const CapacitanceUnit millifarads = Millifarads._();
  static const CapacitanceUnit farads = Farads._();

  static const units = {
    femtofarads,
    picofarads,
    nanofarads,
    microfarads,
    millifarads,
    farads,
  };

  static Option<Capacitance> parse(String s) => Quantity.parse(s, units);
}

abstract class CapacitanceUnit extends BaseUnit<Capacitance> {
  const CapacitanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Capacitance call(num value) => Capacitance(value.toDouble(), this);
}

final class Femtofarads extends CapacitanceUnit {
  const Femtofarads._() : super('femtofarad', 'fF', MetricSystem.Femto);
}

final class Picofarads extends CapacitanceUnit {
  const Picofarads._() : super('picofarad', 'pF', MetricSystem.Pico);
}

final class Nanofarads extends CapacitanceUnit {
  const Nanofarads._() : super('nanofarad', 'nF', MetricSystem.Nano);
}

final class Microfarads extends CapacitanceUnit {
  const Microfarads._() : super('microfarad', 'µF', MetricSystem.Micro);
}

final class Millifarads extends CapacitanceUnit {
  const Millifarads._() : super('millifarad', 'mF', MetricSystem.Milli);
}

final class Farads extends CapacitanceUnit {
  const Farads._() : super('farad', 'F', 1.0);
}

extension CapacitanceOps on num {
  Capacitance get femtofarads => Capacitance.femtofarads(this);
  Capacitance get picofarads => Capacitance.picofarads(this);
  Capacitance get nanofarads => Capacitance.nanofarads(this);
  Capacitance get microfarads => Capacitance.microfarads(this);
  Capacitance get millifarads => Capacitance.millifarads(this);
  Capacitance get farads => Capacitance.farads(this);
}
