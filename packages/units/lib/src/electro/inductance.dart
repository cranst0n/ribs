import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Inductance extends Quantity<Inductance> {
  Inductance(super.value, super.unit);

  Inductance operator +(Inductance that) => Inductance(value + that.to(unit), unit);
  Inductance operator -(Inductance that) => Inductance(value - that.to(unit), unit);

  Inductance get toPicohenries => to(picohenries).picohenries;
  Inductance get toNanohenries => to(nanohenries).nanohenries;
  Inductance get toMicrohenries => to(microhenries).microhenries;
  Inductance get toMillihenries => to(millihenries).millihenries;
  Inductance get toHenries => to(henries).henries;

  static const InductanceUnit picohenries = Picohenries._();
  static const InductanceUnit nanohenries = Nanohenries._();
  static const InductanceUnit microhenries = Microhenries._();
  static const InductanceUnit millihenries = Millihenries._();
  static const InductanceUnit henries = Henries._();

  static const units = {
    picohenries,
    nanohenries,
    microhenries,
    millihenries,
    henries,
  };

  static Option<Inductance> parse(String s) => Quantity.parse(s, units);
}

abstract class InductanceUnit extends BaseUnit<Inductance> {
  const InductanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Inductance call(num value) => Inductance(value.toDouble(), this);
}

final class Picohenries extends InductanceUnit {
  const Picohenries._() : super('picohenry', 'pH', MetricSystem.Pico);
}

final class Nanohenries extends InductanceUnit {
  const Nanohenries._() : super('nanohenry', 'nH', MetricSystem.Nano);
}

final class Microhenries extends InductanceUnit {
  const Microhenries._() : super('microhenry', 'µH', MetricSystem.Micro);
}

final class Millihenries extends InductanceUnit {
  const Millihenries._() : super('millihenry', 'mH', MetricSystem.Milli);
}

final class Henries extends InductanceUnit {
  const Henries._() : super('henry', 'H', 1.0);
}

extension InductanceOps on num {
  Inductance get picohenries => Inductance.picohenries(this);
  Inductance get nanohenries => Inductance.nanohenries(this);
  Inductance get microhenries => Inductance.microhenries(this);
  Inductance get millihenries => Inductance.millihenries(this);
  Inductance get henries => Inductance.henries(this);
}
