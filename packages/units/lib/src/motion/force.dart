import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing force.
final class Force extends Quantity<Force> {
  Force(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Force].
  Force operator +(Force that) => Force(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Force].
  Force operator -(Force that) => Force(value - that.to(unit), unit);

  /// Multiplies this force by [that] length to produce [Energy] in joules.
  Energy operator *(Length that) => Energy.joules(toNewtons.value * that.toMeters.value);

  /// Divides this force by [that] area to produce [Pressure] in pascals.
  Pressure operator /(Area that) => Pressure.pascals(toNewtons.value / that.toSquareMeters.value);

  /// Converts this to micronewtons (µN).
  Force get toMicronewtons => to(micronewtons).micronewtons;

  /// Converts this to millinewtons (mN).
  Force get toMillinewtons => to(millinewtons).millinewtons;

  /// Converts this to newtons (N).
  Force get toNewtons => to(newtons).newtons;

  /// Converts this to kilonewtons (kN).
  Force get toKilonewtons => to(kilonewtons).kilonewtons;

  /// Converts this to meganewtons (MN).
  Force get toMeganewtons => to(meganewtons).meganewtons;

  /// Converts this to pounds-force (lbf).
  Force get toPoundsForce => to(poundsForce).poundsForce;

  /// Converts this to kiloponds (kp).
  Force get toKiloponds => to(kiloponds).kiloponds;

  /// Converts this to poundals (pdl).
  Force get toPoundals => to(poundals).poundals;

  /// Converts this to dynes (dyn).
  Force get toDynes => to(dynes).dynes;

  /// Converts this to kips (kip).
  Force get toKips => to(kips).kips;

  /// Unit for micronewtons (µN).
  static const ForceUnit micronewtons = Micronewtons._();

  /// Unit for millinewtons (mN).
  static const ForceUnit millinewtons = Millinewtons._();

  /// Unit for newtons (N) — the SI unit of force.
  static const ForceUnit newtons = Newtons._();

  /// Unit for kilonewtons (kN).
  static const ForceUnit kilonewtons = Kilonewtons._();

  /// Unit for meganewtons (MN).
  static const ForceUnit meganewtons = Meganewtons._();

  /// Unit for pounds-force (lbf).
  static const ForceUnit poundsForce = PoundsForce._();

  /// Unit for kiloponds (kp) — equal to the force exerted by 1 kg under standard gravity.
  static const ForceUnit kiloponds = Kiloponds._();

  /// Unit for poundals (pdl) — the CGS-like imperial unit of force.
  static const ForceUnit poundals = Poundals._();

  /// Unit for dynes (dyn) — the CGS unit of force.
  static const ForceUnit dynes = Dynes._();

  /// Unit for kips (kip) — 1 000 pounds-force.
  static const ForceUnit kips = Kips._();

  /// All supported [Force] units.
  static const units = {
    micronewtons,
    millinewtons,
    newtons,
    kilonewtons,
    meganewtons,
    poundsForce,
    kiloponds,
    poundals,
    dynes,
    kips,
  };

  /// Parses [s] into a [Force], returning [None] if parsing fails.
  static Option<Force> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Force] units.
abstract class ForceUnit extends BaseUnit<Force> {
  const ForceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Force call(num value) => Force(value.toDouble(), this);
}

/// Micronewtons (µN).
final class Micronewtons extends ForceUnit {
  const Micronewtons._() : super('micronewton', 'µN', MetricSystem.Micro);
}

/// Millinewtons (mN).
final class Millinewtons extends ForceUnit {
  const Millinewtons._() : super('millinewton', 'mN', MetricSystem.Milli);
}

/// Newtons (N) — the SI unit of force.
final class Newtons extends ForceUnit {
  const Newtons._() : super('newton', 'N', 1.0);
}

/// Kilonewtons (kN).
final class Kilonewtons extends ForceUnit {
  const Kilonewtons._() : super('kilonewton', 'kN', MetricSystem.Kilo);
}

/// Meganewtons (MN).
final class Meganewtons extends ForceUnit {
  const Meganewtons._() : super('meganewton', 'MN', MetricSystem.Mega);
}

/// Pounds-force (lbf).
final class PoundsForce extends ForceUnit {
  const PoundsForce._() : super('pound-force', 'lbf', 4.4482216152605);
}

/// Kiloponds (kp) — force exerted by a mass of 1 kg under standard gravity.
final class Kiloponds extends ForceUnit {
  const Kiloponds._() : super('kilopond', 'kp', 9.80665);
}

/// Poundals (pdl).
final class Poundals extends ForceUnit {
  const Poundals._() : super('poundal', 'pdl', 0.138254954376);
}

/// Dynes (dyn) — the CGS unit of force (10⁻⁵ N).
final class Dynes extends ForceUnit {
  const Dynes._() : super('dyne', 'dyn', 1e-5);
}

/// Kips (kip) — 1 000 pounds-force.
final class Kips extends ForceUnit {
  const Kips._() : super('kip', 'kip', 4448.2216152605);
}

/// Extension methods for constructing [Force] values from [num].
extension ForceOps on num {
  /// Creates a [Force] of this value in micronewtons.
  Force get micronewtons => Force.micronewtons(this);

  /// Creates a [Force] of this value in millinewtons.
  Force get millinewtons => Force.millinewtons(this);

  /// Creates a [Force] of this value in newtons.
  Force get newtons => Force.newtons(this);

  /// Creates a [Force] of this value in kilonewtons.
  Force get kilonewtons => Force.kilonewtons(this);

  /// Creates a [Force] of this value in meganewtons.
  Force get meganewtons => Force.meganewtons(this);

  /// Creates a [Force] of this value in pounds-force.
  Force get poundsForce => Force.poundsForce(this);

  /// Creates a [Force] of this value in kiloponds.
  Force get kiloponds => Force.kiloponds(this);

  /// Creates a [Force] of this value in poundals.
  Force get poundals => Force.poundals(this);

  /// Creates a [Force] of this value in dynes.
  Force get dynes => Force.dynes(this);

  /// Creates a [Force] of this value in kips.
  Force get kips => Force.kips(this);
}
