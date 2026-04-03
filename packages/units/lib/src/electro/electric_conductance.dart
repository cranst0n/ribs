import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electrical conductance (the reciprocal of resistance).
final class ElectricConductance extends Quantity<ElectricConductance> {
  ElectricConductance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ElectricConductance].
  ElectricConductance operator +(ElectricConductance that) =>
      ElectricConductance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ElectricConductance].
  ElectricConductance operator -(ElectricConductance that) =>
      ElectricConductance(value - that.to(unit), unit);

  /// Converts this to picosiemens (pS).
  ElectricConductance get toPicosiemens => to(picosiemens).picosiemens;

  /// Converts this to microsiemens (µS).
  ElectricConductance get toMicrosiemens => to(microsiemens).microsiemens;

  /// Converts this to millisiemens (mS).
  ElectricConductance get toMillisiemens => to(millisiemens).millisiemens;

  /// Converts this to siemens (S).
  ElectricConductance get toSiemens => to(siemens).siemens;

  /// Unit for picosiemens (pS).
  static const ElectricConductanceUnit picosiemens = Picosiemens._();

  /// Unit for microsiemens (µS).
  static const ElectricConductanceUnit microsiemens = Microsiemens._();

  /// Unit for millisiemens (mS).
  static const ElectricConductanceUnit millisiemens = Millisiemens._();

  /// Unit for siemens (S) — the SI unit of electrical conductance.
  static const ElectricConductanceUnit siemens = Siemens._();

  /// All supported [ElectricConductance] units.
  static const units = {
    picosiemens,
    microsiemens,
    millisiemens,
    siemens,
  };

  /// Parses [s] into an [ElectricConductance], returning [None] if parsing fails.
  static Option<ElectricConductance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ElectricConductance] units.
abstract class ElectricConductanceUnit extends BaseUnit<ElectricConductance> {
  const ElectricConductanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricConductance call(num value) => ElectricConductance(value.toDouble(), this);
}

/// Picosiemens (pS).
final class Picosiemens extends ElectricConductanceUnit {
  const Picosiemens._() : super('picosiemens', 'pS', MetricSystem.Pico);
}

/// Microsiemens (µS).
final class Microsiemens extends ElectricConductanceUnit {
  const Microsiemens._() : super('microsiemens', 'µS', MetricSystem.Micro);
}

/// Millisiemens (mS).
final class Millisiemens extends ElectricConductanceUnit {
  const Millisiemens._() : super('millisiemens', 'mS', MetricSystem.Milli);
}

/// Siemens (S) — the SI unit of electrical conductance.
final class Siemens extends ElectricConductanceUnit {
  const Siemens._() : super('siemens', 'S', 1.0);
}

/// Extension methods for constructing [ElectricConductance] values from [num].
extension ElectricConductanceOps on num {
  /// Creates an [ElectricConductance] of this value in picosiemens.
  ElectricConductance get picosiemens => ElectricConductance.picosiemens(this);

  /// Creates an [ElectricConductance] of this value in microsiemens.
  ElectricConductance get microsiemens => ElectricConductance.microsiemens(this);

  /// Creates an [ElectricConductance] of this value in millisiemens.
  ElectricConductance get millisiemens => ElectricConductance.millisiemens(this);

  /// Creates an [ElectricConductance] of this value in siemens.
  ElectricConductance get siemens => ElectricConductance.siemens(this);
}
