import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing magnetic flux.
final class MagneticFlux extends Quantity<MagneticFlux> {
  MagneticFlux(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [MagneticFlux].
  MagneticFlux operator +(MagneticFlux that) => MagneticFlux(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [MagneticFlux].
  MagneticFlux operator -(MagneticFlux that) => MagneticFlux(value - that.to(unit), unit);

  /// Converts this to microwebers (µWb).
  MagneticFlux get toMicrowebers => to(microwebers).microwebers;

  /// Converts this to milliwebers (mWb).
  MagneticFlux get toMilliwebers => to(milliwebers).milliwebers;

  /// Converts this to webers (Wb).
  MagneticFlux get toWebers => to(webers).webers;

  /// Unit for microwebers (µWb).
  static const MagneticFluxUnit microwebers = Microwebers._();

  /// Unit for milliwebers (mWb).
  static const MagneticFluxUnit milliwebers = Milliwebers._();

  /// Unit for webers (Wb) — the SI unit of magnetic flux.
  static const MagneticFluxUnit webers = Webers._();

  /// All supported [MagneticFlux] units.
  static const units = {
    microwebers,
    milliwebers,
    webers,
  };

  /// Parses [s] into a [MagneticFlux], returning [None] if parsing fails.
  static Option<MagneticFlux> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [MagneticFlux] units.
abstract class MagneticFluxUnit extends BaseUnit<MagneticFlux> {
  const MagneticFluxUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MagneticFlux call(num value) => MagneticFlux(value.toDouble(), this);
}

/// Microwebers (µWb).
final class Microwebers extends MagneticFluxUnit {
  const Microwebers._() : super('microweber', 'µWb', MetricSystem.Micro);
}

/// Milliwebers (mWb).
final class Milliwebers extends MagneticFluxUnit {
  const Milliwebers._() : super('milliweber', 'mWb', MetricSystem.Milli);
}

/// Webers (Wb) — the SI unit of magnetic flux.
final class Webers extends MagneticFluxUnit {
  const Webers._() : super('weber', 'Wb', 1.0);
}

/// Extension methods for constructing [MagneticFlux] values from [num].
extension MagneticFluxOps on num {
  /// Creates a [MagneticFlux] of this value in microwebers.
  MagneticFlux get microwebers => MagneticFlux.microwebers(this);

  /// Creates a [MagneticFlux] of this value in milliwebers.
  MagneticFlux get milliwebers => MagneticFlux.milliwebers(this);

  /// Creates a [MagneticFlux] of this value in webers.
  MagneticFlux get webers => MagneticFlux.webers(this);
}
