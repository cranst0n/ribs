import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ChemicalAmount extends Quantity<ChemicalAmount> {
  ChemicalAmount(super.value, super.unit);

  ChemicalAmount operator +(ChemicalAmount that) => ChemicalAmount(value + that.to(unit), unit);
  ChemicalAmount operator -(ChemicalAmount that) => ChemicalAmount(value - that.to(unit), unit);

  ChemicalAmount get toMoles => to(moles).moles;
  ChemicalAmount get toNanomoles => to(nanomoles).nanomoles;
  ChemicalAmount get toMicromoles => to(micromoles).micromoles;
  ChemicalAmount get toMillimoles => to(millimoles).millimoles;
  ChemicalAmount get toKilomoles => to(kilomoles).kilomoles;
  ChemicalAmount get toMegamoles => to(megamoles).megamoles;

  static const ChemicalAmountUnit moles = Moles._();
  static const ChemicalAmountUnit nanomoles = Nanomoles._();
  static const ChemicalAmountUnit micromoles = Micromoles._();
  static const ChemicalAmountUnit millimoles = Millimoles._();
  static const ChemicalAmountUnit kilomoles = Kilomoles._();
  static const ChemicalAmountUnit megamoles = Megamoles._();

  static const units = {
    moles,
    nanomoles,
    micromoles,
    millimoles,
    kilomoles,
    megamoles,
  };

  static Option<ChemicalAmount> parse(String s) => Quantity.parse(s, units);
}

abstract class ChemicalAmountUnit extends BaseUnit<ChemicalAmount> {
  const ChemicalAmountUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ChemicalAmount call(num value) => ChemicalAmount(value.toDouble(), this);
}

final class Moles extends ChemicalAmountUnit {
  const Moles._() : super('mole', 'mol', 1.0);
}

final class Nanomoles extends ChemicalAmountUnit {
  const Nanomoles._() : super('nanomole', 'nmol', MetricSystem.Nano);
}

final class Micromoles extends ChemicalAmountUnit {
  const Micromoles._() : super('micromole', 'µmol', MetricSystem.Micro);
}

final class Millimoles extends ChemicalAmountUnit {
  const Millimoles._() : super('millimole', 'mmol', MetricSystem.Milli);
}

final class Kilomoles extends ChemicalAmountUnit {
  const Kilomoles._() : super('kilomole', 'kmol', MetricSystem.Kilo);
}

final class Megamoles extends ChemicalAmountUnit {
  const Megamoles._() : super('megamole', 'Mmol', MetricSystem.Mega);
}

extension ChemicalAmountOps on num {
  ChemicalAmount get moles => ChemicalAmount.moles(this);
  ChemicalAmount get nanomoles => ChemicalAmount.nanomoles(this);
  ChemicalAmount get micromoles => ChemicalAmount.micromoles(this);
  ChemicalAmount get millimoles => ChemicalAmount.millimoles(this);
  ChemicalAmount get kilomoles => ChemicalAmount.kilomoles(this);
  ChemicalAmount get megamoles => ChemicalAmount.megamoles(this);
}
