import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing linear momentum (mass × velocity).
final class Momentum extends Quantity<Momentum> {
  Momentum(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Momentum].
  Momentum operator +(Momentum that) => Momentum(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Momentum].
  Momentum operator -(Momentum that) => Momentum(value - that.to(unit), unit);

  /// Converts this to newton-seconds (N·s).
  Momentum get toNewtonSeconds => to(newtonSeconds).newtonSeconds;

  /// Converts this to pound-force-seconds (lbf·s).
  Momentum get toPoundForceSeconds => to(poundForceSeconds).poundForceSeconds;

  /// Unit for newton-seconds (N·s) — the SI unit of momentum.
  static const MomentumUnit newtonSeconds = NewtonSeconds._();

  /// Unit for pound-force-seconds (lbf·s).
  static const MomentumUnit poundForceSeconds = PoundForceSeconds._();

  /// All supported [Momentum] units.
  static const units = {
    newtonSeconds,
    poundForceSeconds,
  };

  /// Parses [s] into a [Momentum], returning [None] if parsing fails.
  static Option<Momentum> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Momentum] units.
abstract class MomentumUnit extends BaseUnit<Momentum> {
  const MomentumUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Momentum call(num value) => Momentum(value.toDouble(), this);
}

/// Newton-seconds (N·s) — the SI unit of momentum.
final class NewtonSeconds extends MomentumUnit {
  const NewtonSeconds._() : super('newton-second', 'N·s', 1.0);
}

/// Pound-force-seconds (lbf·s).
final class PoundForceSeconds extends MomentumUnit {
  const PoundForceSeconds._() : super('pound-force-second', 'lbf·s', 4.4482216152605);
}

/// Extension methods for constructing [Momentum] values from [num].
extension MomentumOps on num {
  /// Creates a [Momentum] of this value in newton-seconds.
  Momentum get newtonSeconds => Momentum.newtonSeconds(this);

  /// Creates a [Momentum] of this value in pound-force-seconds.
  Momentum get poundForceSeconds => Momentum.poundForceSeconds(this);
}
