import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing luminous flux — the total perceived power of light
/// emitted by a source, weighted by the human visual response.
final class LuminousFlux extends Quantity<LuminousFlux> {
  LuminousFlux(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [LuminousFlux].
  LuminousFlux operator +(LuminousFlux that) => LuminousFlux(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [LuminousFlux].
  LuminousFlux operator -(LuminousFlux that) => LuminousFlux(value - that.to(unit), unit);

  /// Converts this to microlumens (µlm).
  LuminousFlux get toMicrolumens => to(microlumens).microlumens;

  /// Converts this to millilumens (mlm).
  LuminousFlux get toMillilumens => to(millilumens).millilumens;

  /// Converts this to lumens (lm).
  LuminousFlux get toLumens => to(lumens).lumens;

  /// Unit for microlumens (µlm).
  static const LuminousFluxUnit microlumens = Microlumens._();

  /// Unit for millilumens (mlm).
  static const LuminousFluxUnit millilumens = Millilumens._();

  /// Unit for lumens (lm) — the SI unit of luminous flux.
  static const LuminousFluxUnit lumens = Lumens._();

  /// All supported [LuminousFlux] units.
  static const units = {
    microlumens,
    millilumens,
    lumens,
  };

  /// Parses [s] into a [LuminousFlux], returning [None] if parsing fails.
  static Option<LuminousFlux> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [LuminousFlux] units.
abstract class LuminousFluxUnit extends BaseUnit<LuminousFlux> {
  const LuminousFluxUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  LuminousFlux call(num value) => LuminousFlux(value.toDouble(), this);
}

/// Microlumens (µlm).
final class Microlumens extends LuminousFluxUnit {
  const Microlumens._() : super('microlumen', 'µlm', MetricSystem.Micro);
}

/// Millilumens (mlm).
final class Millilumens extends LuminousFluxUnit {
  const Millilumens._() : super('millilumen', 'mlm', MetricSystem.Milli);
}

/// Lumens (lm) — the SI unit of luminous flux.
final class Lumens extends LuminousFluxUnit {
  const Lumens._() : super('lumen', 'lm', 1.0);
}

/// Extension methods for constructing [LuminousFlux] values from [num].
extension LuminousFluxOps on num {
  /// Creates a [LuminousFlux] of this value in microlumens.
  LuminousFlux get microlumens => LuminousFlux.microlumens(this);

  /// Creates a [LuminousFlux] of this value in millilumens.
  LuminousFlux get millilumens => LuminousFlux.millilumens(this);

  /// Creates a [LuminousFlux] of this value in lumens.
  LuminousFlux get lumens => LuminousFlux.lumens(this);
}
