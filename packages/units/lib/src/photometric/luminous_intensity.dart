import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing luminous intensity — the luminous flux emitted per
/// unit solid angle in a given direction.
final class LuminousIntensity extends Quantity<LuminousIntensity> {
  LuminousIntensity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [LuminousIntensity].
  LuminousIntensity operator +(LuminousIntensity that) =>
      LuminousIntensity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [LuminousIntensity].
  LuminousIntensity operator -(LuminousIntensity that) =>
      LuminousIntensity(value - that.to(unit), unit);

  /// Converts this to microcandelas (µcd).
  LuminousIntensity get toMicrocandelas => to(microcandelas).microcandelas;

  /// Converts this to millicandelas (mcd).
  LuminousIntensity get toMillicandelas => to(millicandelas).millicandelas;

  /// Converts this to candelas (cd).
  LuminousIntensity get toCandelas => to(candelas).candelas;

  /// Unit for microcandelas (µcd).
  static const LuminousIntensityUnit microcandelas = Microcandelas._();

  /// Unit for millicandelas (mcd).
  static const LuminousIntensityUnit millicandelas = Millicandelas._();

  /// Unit for candelas (cd) — the SI base unit of luminous intensity.
  static const LuminousIntensityUnit candelas = Candelas._();

  /// All supported [LuminousIntensity] units.
  static const units = {
    microcandelas,
    millicandelas,
    candelas,
  };

  /// Parses [s] into a [LuminousIntensity], returning [None] if parsing fails.
  static Option<LuminousIntensity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [LuminousIntensity] units.
abstract class LuminousIntensityUnit extends BaseUnit<LuminousIntensity> {
  const LuminousIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  LuminousIntensity call(num value) => LuminousIntensity(value.toDouble(), this);
}

/// Microcandelas (µcd).
final class Microcandelas extends LuminousIntensityUnit {
  const Microcandelas._() : super('microcandela', 'µcd', MetricSystem.Micro);
}

/// Millicandelas (mcd).
final class Millicandelas extends LuminousIntensityUnit {
  const Millicandelas._() : super('millicandela', 'mcd', MetricSystem.Milli);
}

/// Candelas (cd) — the SI base unit of luminous intensity.
final class Candelas extends LuminousIntensityUnit {
  const Candelas._() : super('candela', 'cd', 1.0);
}

/// Extension methods for constructing [LuminousIntensity] values from [num].
extension LuminousIntensityOps on num {
  /// Creates a [LuminousIntensity] of this value in microcandelas.
  LuminousIntensity get microcandelas => LuminousIntensity.microcandelas(this);

  /// Creates a [LuminousIntensity] of this value in millicandelas.
  LuminousIntensity get millicandelas => LuminousIntensity.millicandelas(this);

  /// Creates a [LuminousIntensity] of this value in candelas.
  LuminousIntensity get candelas => LuminousIntensity.candelas(this);
}
