import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electrical inductance.
final class Inductance extends Quantity<Inductance> {
  Inductance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Inductance].
  Inductance operator +(Inductance that) => Inductance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Inductance].
  Inductance operator -(Inductance that) => Inductance(value - that.to(unit), unit);

  /// Converts this to picohenries (pH).
  Inductance get toPicohenries => to(picohenries).picohenries;

  /// Converts this to nanohenries (nH).
  Inductance get toNanohenries => to(nanohenries).nanohenries;

  /// Converts this to microhenries (µH).
  Inductance get toMicrohenries => to(microhenries).microhenries;

  /// Converts this to millihenries (mH).
  Inductance get toMillihenries => to(millihenries).millihenries;

  /// Converts this to henries (H).
  Inductance get toHenries => to(henries).henries;

  /// Unit for picohenries (pH).
  static const InductanceUnit picohenries = Picohenries._();

  /// Unit for nanohenries (nH).
  static const InductanceUnit nanohenries = Nanohenries._();

  /// Unit for microhenries (µH).
  static const InductanceUnit microhenries = Microhenries._();

  /// Unit for millihenries (mH).
  static const InductanceUnit millihenries = Millihenries._();

  /// Unit for henries (H) — the SI unit of inductance.
  static const InductanceUnit henries = Henries._();

  /// All supported [Inductance] units.
  static const units = {
    picohenries,
    nanohenries,
    microhenries,
    millihenries,
    henries,
  };

  /// Parses [s] into an [Inductance], returning [None] if parsing fails.
  static Option<Inductance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Inductance] units.
abstract class InductanceUnit extends BaseUnit<Inductance> {
  const InductanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Inductance call(num value) => Inductance(value.toDouble(), this);
}

/// Picohenries (pH).
final class Picohenries extends InductanceUnit {
  const Picohenries._() : super('picohenry', 'pH', MetricSystem.Pico);
}

/// Nanohenries (nH).
final class Nanohenries extends InductanceUnit {
  const Nanohenries._() : super('nanohenry', 'nH', MetricSystem.Nano);
}

/// Microhenries (µH).
final class Microhenries extends InductanceUnit {
  const Microhenries._() : super('microhenry', 'µH', MetricSystem.Micro);
}

/// Millihenries (mH).
final class Millihenries extends InductanceUnit {
  const Millihenries._() : super('millihenry', 'mH', MetricSystem.Milli);
}

/// Henries (H) — the SI unit of inductance.
final class Henries extends InductanceUnit {
  const Henries._() : super('henry', 'H', 1.0);
}

/// Extension methods for constructing [Inductance] values from [num].
extension InductanceOps on num {
  /// Creates an [Inductance] of this value in picohenries.
  Inductance get picohenries => Inductance.picohenries(this);

  /// Creates an [Inductance] of this value in nanohenries.
  Inductance get nanohenries => Inductance.nanohenries(this);

  /// Creates an [Inductance] of this value in microhenries.
  Inductance get microhenries => Inductance.microhenries(this);

  /// Creates an [Inductance] of this value in millihenries.
  Inductance get millihenries => Inductance.millihenries(this);

  /// Creates an [Inductance] of this value in henries.
  Inductance get henries => Inductance.henries(this);
}
