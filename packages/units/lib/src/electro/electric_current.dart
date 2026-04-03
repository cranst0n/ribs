import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electric current.
final class ElectricCurrent extends Quantity<ElectricCurrent> {
  ElectricCurrent(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ElectricCurrent].
  ElectricCurrent operator +(ElectricCurrent that) => ElectricCurrent(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ElectricCurrent].
  ElectricCurrent operator -(ElectricCurrent that) => ElectricCurrent(value - that.to(unit), unit);

  /// Multiplies this current by [that] resistance to produce [ElectricPotential] in volts (Ohm's law: V = IR).
  ElectricPotential operator *(ElectricResistance that) =>
      ElectricPotential.volts(toAmperes.value * that.toOhms.value);

  /// Converts this to microamperes (µA).
  ElectricCurrent get toMicroamperes => to(microamperes).microamperes;

  /// Converts this to milliamperes (mA).
  ElectricCurrent get toMilliamperes => to(milliamperes).milliamperes;

  /// Converts this to amperes (A).
  ElectricCurrent get toAmperes => to(amperes).amperes;

  /// Converts this to deciamperes (dA).
  ElectricCurrent get toDeciamperes => to(deciamperes).deciamperes;

  /// Converts this to kiloamperes (kA).
  ElectricCurrent get toKiloamperes => to(kiloamperes).kiloamperes;

  /// Unit for microamperes (µA).
  static const ElectricCurrentUnit microamperes = Microamperes._();

  /// Unit for milliamperes (mA).
  static const ElectricCurrentUnit milliamperes = Milliamperes._();

  /// Unit for amperes (A) — the SI base unit of electric current.
  static const ElectricCurrentUnit amperes = Amperes._();

  /// Unit for deciamperes (dA).
  static const ElectricCurrentUnit deciamperes = Deciamperes._();

  /// Unit for kiloamperes (kA).
  static const ElectricCurrentUnit kiloamperes = Kiloamperes._();

  /// All supported [ElectricCurrent] units.
  static const units = {
    microamperes,
    milliamperes,
    amperes,
    deciamperes,
    kiloamperes,
  };

  /// Parses [s] into an [ElectricCurrent], returning [None] if parsing fails.
  static Option<ElectricCurrent> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ElectricCurrent] units.
abstract class ElectricCurrentUnit extends BaseUnit<ElectricCurrent> {
  const ElectricCurrentUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricCurrent call(num value) => ElectricCurrent(value.toDouble(), this);
}

/// Microamperes (µA).
final class Microamperes extends ElectricCurrentUnit {
  const Microamperes._() : super('microampere', 'µA', MetricSystem.Micro);
}

/// Milliamperes (mA).
final class Milliamperes extends ElectricCurrentUnit {
  const Milliamperes._() : super('milliampere', 'mA', MetricSystem.Milli);
}

/// Amperes (A) — the SI base unit of electric current.
final class Amperes extends ElectricCurrentUnit {
  const Amperes._() : super('ampere', 'A', 1.0);
}

/// Deciamperes (dA).
final class Deciamperes extends ElectricCurrentUnit {
  const Deciamperes._() : super('deciampere', 'dA', MetricSystem.Deci);
}

/// Kiloamperes (kA).
final class Kiloamperes extends ElectricCurrentUnit {
  const Kiloamperes._() : super('kiloampere', 'kA', MetricSystem.Kilo);
}

/// Extension methods for constructing [ElectricCurrent] values from [num].
extension ElectricCurrentOps on num {
  /// Creates an [ElectricCurrent] of this value in microamperes.
  ElectricCurrent get microamperes => ElectricCurrent.microamperes(this);

  /// Creates an [ElectricCurrent] of this value in milliamperes.
  ElectricCurrent get milliamperes => ElectricCurrent.milliamperes(this);

  /// Creates an [ElectricCurrent] of this value in amperes.
  ElectricCurrent get amperes => ElectricCurrent.amperes(this);

  /// Creates an [ElectricCurrent] of this value in deciamperes.
  ElectricCurrent get deciamperes => ElectricCurrent.deciamperes(this);

  /// Creates an [ElectricCurrent] of this value in kiloamperes.
  ElectricCurrent get kiloamperes => ElectricCurrent.kiloamperes(this);
}
