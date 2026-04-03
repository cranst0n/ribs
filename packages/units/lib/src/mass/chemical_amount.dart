import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing amount of chemical substance.
final class ChemicalAmount extends Quantity<ChemicalAmount> {
  ChemicalAmount(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ChemicalAmount].
  ChemicalAmount operator +(ChemicalAmount that) => ChemicalAmount(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ChemicalAmount].
  ChemicalAmount operator -(ChemicalAmount that) => ChemicalAmount(value - that.to(unit), unit);

  /// Converts this to moles (mol).
  ChemicalAmount get toMoles => to(moles).moles;

  /// Converts this to nanomoles (nmol).
  ChemicalAmount get toNanomoles => to(nanomoles).nanomoles;

  /// Converts this to micromoles (µmol).
  ChemicalAmount get toMicromoles => to(micromoles).micromoles;

  /// Converts this to millimoles (mmol).
  ChemicalAmount get toMillimoles => to(millimoles).millimoles;

  /// Converts this to kilomoles (kmol).
  ChemicalAmount get toKilomoles => to(kilomoles).kilomoles;

  /// Converts this to megamoles (Mmol).
  ChemicalAmount get toMegamoles => to(megamoles).megamoles;

  /// Unit for moles (mol) — the SI base unit of amount of substance.
  static const ChemicalAmountUnit moles = Moles._();

  /// Unit for nanomoles (nmol).
  static const ChemicalAmountUnit nanomoles = Nanomoles._();

  /// Unit for micromoles (µmol).
  static const ChemicalAmountUnit micromoles = Micromoles._();

  /// Unit for millimoles (mmol).
  static const ChemicalAmountUnit millimoles = Millimoles._();

  /// Unit for kilomoles (kmol).
  static const ChemicalAmountUnit kilomoles = Kilomoles._();

  /// Unit for megamoles (Mmol).
  static const ChemicalAmountUnit megamoles = Megamoles._();

  /// All supported [ChemicalAmount] units.
  static const units = {
    moles,
    nanomoles,
    micromoles,
    millimoles,
    kilomoles,
    megamoles,
  };

  /// Parses [s] into a [ChemicalAmount], returning [None] if parsing fails.
  static Option<ChemicalAmount> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ChemicalAmount] units.
abstract class ChemicalAmountUnit extends BaseUnit<ChemicalAmount> {
  const ChemicalAmountUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ChemicalAmount call(num value) => ChemicalAmount(value.toDouble(), this);
}

/// Moles (mol) — the SI base unit of amount of substance.
final class Moles extends ChemicalAmountUnit {
  const Moles._() : super('mole', 'mol', 1.0);
}

/// Nanomoles (nmol).
final class Nanomoles extends ChemicalAmountUnit {
  const Nanomoles._() : super('nanomole', 'nmol', MetricSystem.Nano);
}

/// Micromoles (µmol).
final class Micromoles extends ChemicalAmountUnit {
  const Micromoles._() : super('micromole', 'µmol', MetricSystem.Micro);
}

/// Millimoles (mmol).
final class Millimoles extends ChemicalAmountUnit {
  const Millimoles._() : super('millimole', 'mmol', MetricSystem.Milli);
}

/// Kilomoles (kmol).
final class Kilomoles extends ChemicalAmountUnit {
  const Kilomoles._() : super('kilomole', 'kmol', MetricSystem.Kilo);
}

/// Megamoles (Mmol).
final class Megamoles extends ChemicalAmountUnit {
  const Megamoles._() : super('megamole', 'Mmol', MetricSystem.Mega);
}

/// Extension methods for constructing [ChemicalAmount] values from [num].
extension ChemicalAmountOps on num {
  /// Creates a [ChemicalAmount] of this value in moles.
  ChemicalAmount get moles => ChemicalAmount.moles(this);

  /// Creates a [ChemicalAmount] of this value in nanomoles.
  ChemicalAmount get nanomoles => ChemicalAmount.nanomoles(this);

  /// Creates a [ChemicalAmount] of this value in micromoles.
  ChemicalAmount get micromoles => ChemicalAmount.micromoles(this);

  /// Creates a [ChemicalAmount] of this value in millimoles.
  ChemicalAmount get millimoles => ChemicalAmount.millimoles(this);

  /// Creates a [ChemicalAmount] of this value in kilomoles.
  ChemicalAmount get kilomoles => ChemicalAmount.kilomoles(this);

  /// Creates a [ChemicalAmount] of this value in megamoles.
  ChemicalAmount get megamoles => ChemicalAmount.megamoles(this);
}
