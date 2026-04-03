import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electric potential (voltage).
final class ElectricPotential extends Quantity<ElectricPotential> {
  ElectricPotential(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ElectricPotential].
  ElectricPotential operator +(ElectricPotential that) =>
      ElectricPotential(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ElectricPotential].
  ElectricPotential operator -(ElectricPotential that) =>
      ElectricPotential(value - that.to(unit), unit);

  /// Divides this voltage by [that] resistance to produce [ElectricCurrent] in amperes (Ohm's law: I = V/R).
  ElectricCurrent operator /(ElectricResistance that) =>
      ElectricCurrent.amperes(toVolts.value / that.toOhms.value);

  /// Multiplies this voltage by [that] current to produce [Power] in watts (P = VI).
  Power operator *(ElectricCurrent that) => Power.watts(toVolts.value * that.toAmperes.value);

  /// Converts this to microvolts (μV).
  ElectricPotential get toMicrovolts => to(microvolts).microvolts;

  /// Converts this to millivolts (mV).
  ElectricPotential get toMillivolts => to(millivolts).millivolts;

  /// Converts this to volts (V).
  ElectricPotential get toVolts => to(volts).volts;

  /// Converts this to kilovolts (kV).
  ElectricPotential get toKilovolts => ElectricPotential(to(kilovolts), kilovolts);

  /// Converts this to megavolts (MV).
  ElectricPotential get toMegavolts => to(megavolts).megavolts;

  /// Unit for microvolts (μV).
  static const ElectricPotentialUnit microvolts = Microvolts._();

  /// Unit for millivolts (mV).
  static const ElectricPotentialUnit millivolts = Millivolts._();

  /// Unit for volts (V) — the SI unit of electric potential.
  static const ElectricPotentialUnit volts = Volts._();

  /// Unit for kilovolts (kV).
  static const ElectricPotentialUnit kilovolts = Kilovolts._();

  /// Unit for megavolts (MV).
  static const ElectricPotentialUnit megavolts = Megavolts._();

  /// All supported [ElectricPotential] units.
  static const units = {
    microvolts,
    millivolts,
    volts,
    kilovolts,
    megavolts,
  };

  /// Parses [s] into an [ElectricPotential], returning [None] if parsing fails.
  static Option<ElectricPotential> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ElectricPotential] units.
abstract class ElectricPotentialUnit extends BaseUnit<ElectricPotential> {
  const ElectricPotentialUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricPotential call(num value) => ElectricPotential(value.toDouble(), this);
}

/// Microvolts (μV).
final class Microvolts extends ElectricPotentialUnit {
  const Microvolts._() : super('microvolt', 'μV', MetricSystem.Micro);
}

/// Millivolts (mV).
final class Millivolts extends ElectricPotentialUnit {
  const Millivolts._() : super('millivolt', 'mV', MetricSystem.Milli);
}

/// Volts (V) — the SI unit of electric potential.
final class Volts extends ElectricPotentialUnit {
  const Volts._() : super('volt', 'V', 1.0);
}

/// Kilovolts (kV).
final class Kilovolts extends ElectricPotentialUnit {
  const Kilovolts._() : super('kilovolt', 'kV', MetricSystem.Kilo);
}

/// Megavolts (MV).
final class Megavolts extends ElectricPotentialUnit {
  const Megavolts._() : super('megavolt', 'MV', MetricSystem.Mega);
}

/// Extension methods for constructing [ElectricPotential] values from [num].
extension ElectricPotentialOps on num {
  /// Creates an [ElectricPotential] of this value in microvolts.
  ElectricPotential get microvolts => ElectricPotential.microvolts(this);

  /// Creates an [ElectricPotential] of this value in millivolts.
  ElectricPotential get millivolts => ElectricPotential.millivolts(this);

  /// Creates an [ElectricPotential] of this value in volts.
  ElectricPotential get volts => ElectricPotential.volts(this);

  /// Creates an [ElectricPotential] of this value in kilovolts.
  ElectricPotential get kilovolts => ElectricPotential.kilovolts(this);

  /// Creates an [ElectricPotential] of this value in megavolts.
  ElectricPotential get megavolts => ElectricPotential.megavolts(this);
}
