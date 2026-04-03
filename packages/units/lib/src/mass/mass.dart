import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing mass.
final class Mass extends Quantity<Mass> {
  Mass(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Mass].
  Mass operator +(Mass that) => Mass(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Mass].
  Mass operator -(Mass that) => Mass(value - that.to(unit), unit);

  /// Multiplies this mass by [that] acceleration to produce [Force] in newtons.
  Force operator *(Acceleration that) =>
      Force.newtons(toKilograms.value * that.toMetersPerSecondSquared.value);

  /// Divides this mass by [that] volume to produce [Density] in kg/m³.
  Density operator /(Volume that) =>
      Density.kilogramsPerCubicMeter(toKilograms.value / that.toCubicMeters.value);

  /// Converts this to grams (g).
  Mass get toGrams => to(grams).grams;

  /// Converts this to nanograms (ng).
  Mass get toNanograms => to(nanograms).nanograms;

  /// Converts this to micrograms (mcg).
  Mass get toMicrograms => to(micrograms).micrograms;

  /// Converts this to milligrams (mg).
  Mass get toMilligrams => to(milligrams).milligrams;

  /// Converts this to kilograms (kg).
  Mass get toKilograms => to(kilograms).kilograms;

  /// Converts this to metric tonnes (t).
  Mass get toTonnes => to(tonnes).tonnes;

  /// Converts this to ounces (oz).
  Mass get toOunces => to(ounces).ounces;

  /// Converts this to pounds (lb).
  Mass get toPounds => to(pounds).pounds;

  /// Converts this to kilopounds (klb).
  Mass get toKilopounds => to(kilopounds).kilopounds;

  /// Converts this to megapounds (Mlb).
  Mass get toMegapounds => to(megapounds).megapounds;

  /// Converts this to stone (st).
  Mass get toStone => to(stone).stone;

  /// Converts this to troy grains (gr).
  Mass get toTroyGrains => to(troyGrains).troyGrains;

  /// Converts this to pennyweights (dwt).
  Mass get toPennyweights => to(pennyweights).pennyweights;

  /// Converts this to troy ounces (oz t).
  Mass get toTroyOunces => to(troyOunces).troyOunces;

  /// Converts this to troy pounds (lb t).
  Mass get toTroyPounds => to(troyPounds).troyPounds;

  /// Converts this to tolas.
  Mass get toTolas => to(tolas).tolas;

  /// Converts this to carats (ct).
  Mass get toCarats => to(carats).carats;

  /// Unit for grams (g).
  static const MassUnit grams = Grams._();

  /// Unit for nanograms (ng).
  static const MassUnit nanograms = Nanograms._();

  /// Unit for micrograms (mcg).
  static const MassUnit micrograms = Micrograms._();

  /// Unit for milligrams (mg).
  static const MassUnit milligrams = Milligrams._();

  /// Unit for kilograms (kg) — the SI base unit of mass.
  static const MassUnit kilograms = Kilograms._();

  /// Unit for metric tonnes (t).
  static const MassUnit tonnes = Tonnes._();

  /// Unit for ounces (oz) — avoirdupois.
  static const MassUnit ounces = Ounces._();

  /// Unit for pounds (lb) — avoirdupois.
  static const MassUnit pounds = Pounds._();

  /// Unit for kilopounds (klb).
  static const MassUnit kilopounds = Kilopounds._();

  /// Unit for megapounds (Mlb).
  static const MassUnit megapounds = Megapounds._();

  /// Unit for stone (st) — 14 avoirdupois pounds.
  static const MassUnit stone = Stone._();

  /// Unit for troy grains (gr) — the smallest unit in the troy system.
  static const MassUnit troyGrains = TroyGrains._();

  /// Unit for pennyweights (dwt) — 24 troy grains.
  static const MassUnit pennyweights = Pennyweights._();

  /// Unit for troy ounces (oz t) — used for precious metals.
  static const MassUnit troyOunces = TroyOunces._();

  /// Unit for troy pounds (lb t).
  static const MassUnit troyPounds = TroyPounds._();

  /// Unit for tolas — a traditional South Asian unit of mass.
  static const MassUnit tolas = Tolas._();

  /// Unit for carats (ct) — used for gemstones; 1 ct = 200 mg.
  static const MassUnit carats = Carats._();

  /// All supported [Mass] units.
  static const units = {
    grams,
    nanograms,
    micrograms,
    milligrams,
    kilograms,
    tonnes,
    ounces,
    pounds,
    kilopounds,
    megapounds,
    stone,
    troyGrains,
    pennyweights,
    troyOunces,
    troyPounds,
    tolas,
    carats,
  };

  /// Parses [s] into a [Mass], returning [None] if parsing fails.
  static Option<Mass> parse(String s) => Quantity.parse(s, units);
}

const _PoundConversionFactor = MetricSystem.Kilo * 4.5359237e-1;
const _TroyGrainsConversionFactor = MetricSystem.Milli * 64.79891;

/// Base class for all [Mass] units.
abstract class MassUnit extends BaseUnit<Mass> {
  const MassUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Mass call(num value) => Mass(value.toDouble(), this);
}

/// Grams (g).
final class Grams extends MassUnit {
  const Grams._() : super('gram', 'g', 1);
}

/// Nanograms (ng).
final class Nanograms extends MassUnit {
  const Nanograms._() : super('nanogram', 'ng', MetricSystem.Nano);
}

/// Micrograms (mcg).
final class Micrograms extends MassUnit {
  const Micrograms._() : super('microgram', 'mcg', MetricSystem.Micro);
}

/// Milligrams (mg).
final class Milligrams extends MassUnit {
  const Milligrams._() : super('milligram', 'mg', MetricSystem.Milli);
}

/// Kilograms (kg) — the SI base unit of mass.
final class Kilograms extends MassUnit {
  const Kilograms._() : super('kilogram', 'kg', MetricSystem.Kilo);
}

/// Metric tonnes (t) — 1 000 kg.
final class Tonnes extends MassUnit {
  const Tonnes._() : super('tonne', 't', MetricSystem.Mega);
}

/// Ounces (oz) — avoirdupois.
final class Ounces extends MassUnit {
  const Ounces._() : super('ounce', 'oz', _PoundConversionFactor / 16.0);
}

/// Pounds (lb) — avoirdupois.
final class Pounds extends MassUnit {
  const Pounds._() : super('pound', 'lb', _PoundConversionFactor);
}

/// Kilopounds (klb).
final class Kilopounds extends MassUnit {
  const Kilopounds._() : super('kilopound', 'klb', _PoundConversionFactor * MetricSystem.Kilo);
}

/// Megapounds (Mlb).
final class Megapounds extends MassUnit {
  const Megapounds._() : super('megapound', 'Mlb', _PoundConversionFactor * MetricSystem.Mega);
}

/// Stone (st) — 14 avoirdupois pounds.
final class Stone extends MassUnit {
  const Stone._() : super('stone', 'st', _PoundConversionFactor * 14);
}

/// Troy grains (gr) — the smallest unit in the troy weight system.
final class TroyGrains extends MassUnit {
  const TroyGrains._() : super('troy grain', 'gr', _TroyGrainsConversionFactor);
}

/// Pennyweights (dwt) — 24 troy grains.
final class Pennyweights extends MassUnit {
  const Pennyweights._() : super('pennyweight', 'dwt', _TroyGrainsConversionFactor * 24);
}

/// Troy ounces (oz t) — used for precious metals; 480 troy grains.
final class TroyOunces extends MassUnit {
  const TroyOunces._() : super('troy ounce', 'oz t', _TroyGrainsConversionFactor * 480);
}

/// Troy pounds (lb t) — 12 troy ounces.
final class TroyPounds extends MassUnit {
  const TroyPounds._() : super('troy pound', 'lb t', _TroyGrainsConversionFactor * 480 * 12);
}

/// Tolas — a traditional South Asian unit of mass; 180 troy grains.
final class Tolas extends MassUnit {
  const Tolas._() : super('tola', 'tola', _TroyGrainsConversionFactor * 180);
}

/// Carats (ct) — used for gemstones; 1 ct = 200 mg.
final class Carats extends MassUnit {
  const Carats._() : super('carat', 'ct', MetricSystem.Milli * 200);
}

/// Daltons (Da) — atomic mass unit; 1 Da ≈ 1.66054 × 10⁻²⁷ kg.
final class Dalton extends MassUnit {
  const Dalton._() : super('dalton', 'Da', MetricSystem.Kilo * 1.66053906660e-27);
}

/// Extension methods for constructing [Mass] values from [num].
extension MassOps on num {
  /// Creates a [Mass] of this value in grams.
  Mass get grams => Mass.grams(this);

  /// Creates a [Mass] of this value in nanograms.
  Mass get nanograms => Mass.nanograms(this);

  /// Creates a [Mass] of this value in micrograms.
  Mass get micrograms => Mass.micrograms(this);

  /// Creates a [Mass] of this value in milligrams.
  Mass get milligrams => Mass.milligrams(this);

  /// Creates a [Mass] of this value in kilograms.
  Mass get kilograms => Mass.kilograms(this);

  /// Creates a [Mass] of this value in metric tonnes.
  Mass get tonnes => Mass.tonnes(this);

  /// Creates a [Mass] of this value in ounces.
  Mass get ounces => Mass.ounces(this);

  /// Creates a [Mass] of this value in pounds.
  Mass get pounds => Mass.pounds(this);

  /// Creates a [Mass] of this value in kilopounds.
  Mass get kilopounds => Mass.kilopounds(this);

  /// Creates a [Mass] of this value in megapounds.
  Mass get megapounds => Mass.megapounds(this);

  /// Creates a [Mass] of this value in stone.
  Mass get stone => Mass.stone(this);

  /// Creates a [Mass] of this value in troy grains.
  Mass get troyGrains => Mass.troyGrains(this);

  /// Creates a [Mass] of this value in pennyweights.
  Mass get pennyweights => Mass.pennyweights(this);

  /// Creates a [Mass] of this value in troy ounces.
  Mass get troyOunces => Mass.troyOunces(this);

  /// Creates a [Mass] of this value in troy pounds.
  Mass get troyPounds => Mass.troyPounds(this);

  /// Creates a [Mass] of this value in tolas.
  Mass get tolas => Mass.tolas(this);

  /// Creates a [Mass] of this value in carats.
  Mass get carats => Mass.carats(this);
}
