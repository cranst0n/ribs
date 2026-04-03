import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A dimensionless quantity representing a count of discrete items.
final class Each extends Quantity<Each> {
  Each(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Each].
  Each operator +(Each that) => Each(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Each].
  Each operator -(Each that) => Each(value - that.to(unit), unit);

  /// Converts this to individual items.
  Each get toEach => to(each).each;

  /// Converts this to dozens (12 each).
  Each get toDozen => to(dozen).dozen;

  /// Converts this to scores (20 each).
  Each get toScore => to(score).score;

  /// Converts this to gross (144 each).
  Each get toGross => to(gross).gross;

  /// Converts this to great gross (1 728 each).
  Each get toGreatGross => to(greatGross).greatGross;

  /// Unit for individual items.
  static const EachUnit each = Eaches._();

  /// Unit for dozens (12 items).
  static const EachUnit dozen = Dozens._();

  /// Unit for scores (20 items).
  static const EachUnit score = Scores._();

  /// Unit for gross (144 items = 12 dozen).
  static const EachUnit gross = Gross._();

  /// Unit for great gross (1 728 items = 12 gross).
  static const EachUnit greatGross = GreatGross._();

  /// All supported [Each] units.
  static const units = {
    each,
    dozen,
    score,
    gross,
    greatGross,
  };

  /// Parses [s] into an [Each], returning [None] if parsing fails.
  static Option<Each> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Each] units.
abstract class EachUnit extends BaseUnit<Each> {
  const EachUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Each call(num value) => Each(value.toDouble(), this);
}

/// Individual items (each).
final class Eaches extends EachUnit {
  const Eaches._() : super('each', 'ea', 1.0);
}

/// Dozens (dz) — 12 items.
final class Dozens extends EachUnit {
  const Dozens._() : super('dozen', 'dz', 12.0);
}

/// Scores — 20 items.
final class Scores extends EachUnit {
  const Scores._() : super('score', 'score', 20.0);
}

/// Gross (gr) — 144 items (12 dozen).
final class Gross extends EachUnit {
  const Gross._() : super('gross', 'gr', 144.0);
}

/// Great gross (gg) — 1 728 items (12 gross).
final class GreatGross extends EachUnit {
  const GreatGross._() : super('great gross', 'gg', 1728.0);
}

/// Extension methods for constructing [Each] values from [num].
extension EachOps on num {
  /// Creates an [Each] of this value as individual items.
  Each get each => Each.each(this);

  /// Creates an [Each] of this value in dozens.
  Each get dozen => Each.dozen(this);

  /// Creates an [Each] of this value in scores.
  Each get score => Each.score(this);

  /// Creates an [Each] of this value in gross.
  Each get gross => Each.gross(this);

  /// Creates an [Each] of this value in great gross.
  Each get greatGross => Each.greatGross(this);
}
