import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing luminance — the luminous intensity per unit area
/// of a surface emitting or reflecting light in a given direction.
final class Luminance extends Quantity<Luminance> {
  Luminance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Luminance].
  Luminance operator +(Luminance that) => Luminance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Luminance].
  Luminance operator -(Luminance that) => Luminance(value - that.to(unit), unit);

  /// Converts this to nits (cd/m²).
  Luminance get toNits => to(nits).nits;

  /// Converts this to stilbs (sb).
  Luminance get toStilbs => to(stilbs).stilbs;

  /// Converts this to footlamberts (fL).
  Luminance get toFootlamberts => to(footlamberts).footlamberts;

  /// Converts this to lamberts (L).
  Luminance get toLamberts => to(lamberts).lamberts;

  /// Unit for nits (cd/m²) — the SI unit of luminance.
  static const LuminanceUnit nits = Nits._();

  /// Unit for stilbs (sb) — CGS unit of luminance (1 sb = 10 000 cd/m²).
  static const LuminanceUnit stilbs = Stilbs._();

  /// Unit for footlamberts (fL).
  static const LuminanceUnit footlamberts = Footlamberts._();

  /// Unit for lamberts (L).
  static const LuminanceUnit lamberts = Lamberts._();

  /// All supported [Luminance] units.
  static const units = {
    nits,
    stilbs,
    footlamberts,
    lamberts,
  };

  /// Parses [s] into a [Luminance], returning [None] if parsing fails.
  static Option<Luminance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Luminance] units.
abstract class LuminanceUnit extends BaseUnit<Luminance> {
  const LuminanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Luminance call(num value) => Luminance(value.toDouble(), this);
}

/// Nits (cd/m²) — the SI unit of luminance.
final class Nits extends LuminanceUnit {
  const Nits._() : super('nit', 'cd/m²', 1.0);
}

/// Stilbs (sb) — CGS unit of luminance; 1 sb = 10 000 cd/m².
final class Stilbs extends LuminanceUnit {
  const Stilbs._() : super('stilb', 'sb', 1e4);
}

/// Footlamberts (fL).
final class Footlamberts extends LuminanceUnit {
  const Footlamberts._() : super('footlambert', 'fL', 3.42625909963539);
}

/// Lamberts (L).
final class Lamberts extends LuminanceUnit {
  const Lamberts._() : super('lambert', 'L', 3183.09886183791);
}

/// Extension methods for constructing [Luminance] values from [num].
extension LuminanceOps on num {
  /// Creates a [Luminance] of this value in nits.
  Luminance get nits => Luminance.nits(this);

  /// Creates a [Luminance] of this value in stilbs.
  Luminance get stilbs => Luminance.stilbs(this);

  /// Creates a [Luminance] of this value in footlamberts.
  Luminance get footlamberts => Luminance.footlamberts(this);

  /// Creates a [Luminance] of this value in lamberts.
  Luminance get lamberts => Luminance.lamberts(this);
}
