import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electrical resistance.
final class ElectricResistance extends Quantity<ElectricResistance> {
  ElectricResistance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ElectricResistance].
  ElectricResistance operator +(ElectricResistance that) =>
      ElectricResistance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ElectricResistance].
  ElectricResistance operator -(ElectricResistance that) =>
      ElectricResistance(value - that.to(unit), unit);

  /// Converts this to microohms (µΩ).
  ElectricResistance get toMicroohms => to(microohms).microohms;

  /// Converts this to milliohms (mΩ).
  ElectricResistance get toMilliohms => to(milliohms).milliohms;

  /// Converts this to ohms (Ω).
  ElectricResistance get toOhms => to(ohms).ohms;

  /// Converts this to kiloohms (kΩ).
  ElectricResistance get toKiloohms => to(kiloohms).kiloohms;

  /// Converts this to megaohms (MΩ).
  ElectricResistance get toMegaohms => to(megaohms).megaohms;

  /// Converts this to gigaohms (GΩ).
  ElectricResistance get toGigaohms => to(gigaohms).gigaohms;

  /// Unit for microohms (µΩ).
  static const ElectricResistanceUnit microohms = Microohms._();

  /// Unit for milliohms (mΩ).
  static const ElectricResistanceUnit milliohms = Milliohms._();

  /// Unit for ohms (Ω) — the SI unit of electrical resistance.
  static const ElectricResistanceUnit ohms = Ohms._();

  /// Unit for kiloohms (kΩ).
  static const ElectricResistanceUnit kiloohms = Kiloohms._();

  /// Unit for megaohms (MΩ).
  static const ElectricResistanceUnit megaohms = Megaohms._();

  /// Unit for gigaohms (GΩ).
  static const ElectricResistanceUnit gigaohms = Gigaohms._();

  /// All supported [ElectricResistance] units.
  static const units = {
    microohms,
    milliohms,
    ohms,
    kiloohms,
    megaohms,
    gigaohms,
  };

  /// Parses [s] into an [ElectricResistance], returning [None] if parsing fails.
  static Option<ElectricResistance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ElectricResistance] units.
abstract class ElectricResistanceUnit extends BaseUnit<ElectricResistance> {
  const ElectricResistanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricResistance call(num value) => ElectricResistance(value.toDouble(), this);
}

/// Microohms (µΩ).
final class Microohms extends ElectricResistanceUnit {
  const Microohms._() : super('microohm', 'µΩ', MetricSystem.Micro);
}

/// Milliohms (mΩ).
final class Milliohms extends ElectricResistanceUnit {
  const Milliohms._() : super('milliohm', 'mΩ', MetricSystem.Milli);
}

/// Ohms (Ω) — the SI unit of electrical resistance.
final class Ohms extends ElectricResistanceUnit {
  const Ohms._() : super('ohm', 'Ω', 1.0);
}

/// Kiloohms (kΩ).
final class Kiloohms extends ElectricResistanceUnit {
  const Kiloohms._() : super('kiloohm', 'kΩ', MetricSystem.Kilo);
}

/// Megaohms (MΩ).
final class Megaohms extends ElectricResistanceUnit {
  const Megaohms._() : super('megaohm', 'MΩ', MetricSystem.Mega);
}

/// Gigaohms (GΩ).
final class Gigaohms extends ElectricResistanceUnit {
  const Gigaohms._() : super('gigaohm', 'GΩ', MetricSystem.Giga);
}

/// Extension methods for constructing [ElectricResistance] values from [num].
extension ElectricResistanceOps on num {
  /// Creates an [ElectricResistance] of this value in microohms.
  ElectricResistance get microohms => ElectricResistance.microohms(this);

  /// Creates an [ElectricResistance] of this value in milliohms.
  ElectricResistance get milliohms => ElectricResistance.milliohms(this);

  /// Creates an [ElectricResistance] of this value in ohms.
  ElectricResistance get ohms => ElectricResistance.ohms(this);

  /// Creates an [ElectricResistance] of this value in kiloohms.
  ElectricResistance get kiloohms => ElectricResistance.kiloohms(this);

  /// Creates an [ElectricResistance] of this value in megaohms.
  ElectricResistance get megaohms => ElectricResistance.megaohms(this);

  /// Creates an [ElectricResistance] of this value in gigaohms.
  ElectricResistance get gigaohms => ElectricResistance.gigaohms(this);
}
