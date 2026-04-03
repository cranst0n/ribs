import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electrical capacitance.
final class Capacitance extends Quantity<Capacitance> {
  Capacitance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Capacitance].
  Capacitance operator +(Capacitance that) => Capacitance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Capacitance].
  Capacitance operator -(Capacitance that) => Capacitance(value - that.to(unit), unit);

  /// Converts this to femtofarads (fF).
  Capacitance get toFemtofarads => to(femtofarads).femtofarads;

  /// Converts this to picofarads (pF).
  Capacitance get toPicofarads => to(picofarads).picofarads;

  /// Converts this to nanofarads (nF).
  Capacitance get toNanofarads => to(nanofarads).nanofarads;

  /// Converts this to microfarads (µF).
  Capacitance get toMicrofarads => to(microfarads).microfarads;

  /// Converts this to millifarads (mF).
  Capacitance get toMillifarads => to(millifarads).millifarads;

  /// Converts this to farads (F).
  Capacitance get toFarads => to(farads).farads;

  /// Unit for femtofarads (fF).
  static const CapacitanceUnit femtofarads = Femtofarads._();

  /// Unit for picofarads (pF).
  static const CapacitanceUnit picofarads = Picofarads._();

  /// Unit for nanofarads (nF).
  static const CapacitanceUnit nanofarads = Nanofarads._();

  /// Unit for microfarads (µF).
  static const CapacitanceUnit microfarads = Microfarads._();

  /// Unit for millifarads (mF).
  static const CapacitanceUnit millifarads = Millifarads._();

  /// Unit for farads (F) — the SI unit of capacitance.
  static const CapacitanceUnit farads = Farads._();

  /// All supported [Capacitance] units.
  static const units = {
    femtofarads,
    picofarads,
    nanofarads,
    microfarads,
    millifarads,
    farads,
  };

  /// Parses [s] into a [Capacitance], returning [None] if parsing fails.
  static Option<Capacitance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Capacitance] units.
abstract class CapacitanceUnit extends BaseUnit<Capacitance> {
  const CapacitanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Capacitance call(num value) => Capacitance(value.toDouble(), this);
}

/// Femtofarads (fF).
final class Femtofarads extends CapacitanceUnit {
  const Femtofarads._() : super('femtofarad', 'fF', MetricSystem.Femto);
}

/// Picofarads (pF).
final class Picofarads extends CapacitanceUnit {
  const Picofarads._() : super('picofarad', 'pF', MetricSystem.Pico);
}

/// Nanofarads (nF).
final class Nanofarads extends CapacitanceUnit {
  const Nanofarads._() : super('nanofarad', 'nF', MetricSystem.Nano);
}

/// Microfarads (µF).
final class Microfarads extends CapacitanceUnit {
  const Microfarads._() : super('microfarad', 'µF', MetricSystem.Micro);
}

/// Millifarads (mF).
final class Millifarads extends CapacitanceUnit {
  const Millifarads._() : super('millifarad', 'mF', MetricSystem.Milli);
}

/// Farads (F) — the SI unit of capacitance.
final class Farads extends CapacitanceUnit {
  const Farads._() : super('farad', 'F', 1.0);
}

/// Extension methods for constructing [Capacitance] values from [num].
extension CapacitanceOps on num {
  /// Creates a [Capacitance] of this value in femtofarads.
  Capacitance get femtofarads => Capacitance.femtofarads(this);

  /// Creates a [Capacitance] of this value in picofarads.
  Capacitance get picofarads => Capacitance.picofarads(this);

  /// Creates a [Capacitance] of this value in nanofarads.
  Capacitance get nanofarads => Capacitance.nanofarads(this);

  /// Creates a [Capacitance] of this value in microfarads.
  Capacitance get microfarads => Capacitance.microfarads(this);

  /// Creates a [Capacitance] of this value in millifarads.
  Capacitance get millifarads => Capacitance.millifarads(this);

  /// Creates a [Capacitance] of this value in farads.
  Capacitance get farads => Capacitance.farads(this);
}
