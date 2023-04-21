import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Mass extends Quantity<Mass> {
  Mass(super.value, super.unit);

  Mass get toGrams => to(grams).grams;
  Mass get toNanograms => to(nanograms).nanograms;
  Mass get toMicrograms => to(micrograms).micrograms;
  Mass get toMilligrams => to(milligrams).milligrams;
  Mass get toKilograms => to(kilograms).kilograms;
  Mass get toTonnes => to(tonnes).tonnes;
  Mass get toOunces => to(ounces).ounces;
  Mass get toPounds => to(pounds).pounds;
  Mass get toKilopounds => to(kilopounds).kilopounds;
  Mass get toMegapounds => to(megapounds).megapounds;
  Mass get toStone => to(stone).stone;
  Mass get toTroyGrains => to(troyGrains).troyGrains;
  Mass get toPennyweights => to(pennyweights).pennyweights;
  Mass get toTroyOunces => to(troyOunces).troyOunces;
  Mass get toTroyPounds => to(troyPounds).troyPounds;
  Mass get toTolas => to(tolas).tolas;
  Mass get toCarats => to(carats).carats;

  static const MassUnit grams = Grams._();
  static const MassUnit nanograms = Nanograms._();
  static const MassUnit micrograms = Micrograms._();
  static const MassUnit milligrams = Milligrams._();
  static const MassUnit kilograms = Kilograms._();
  static const MassUnit tonnes = Tonnes._();
  static const MassUnit ounces = Ounces._();
  static const MassUnit pounds = Pounds._();
  static const MassUnit kilopounds = Kilopounds._();
  static const MassUnit megapounds = Megapounds._();
  static const MassUnit stone = Stone._();
  static const MassUnit troyGrains = TroyGrains._();
  static const MassUnit pennyweights = Pennyweights._();
  static const MassUnit troyOunces = TroyOunces._();
  static const MassUnit troyPounds = TroyPounds._();
  static const MassUnit tolas = Tolas._();
  static const MassUnit carats = Carats._();

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

  static Option<Mass> parse(String s) => Quantity.parse(s, units);
}

const _PoundConversionFactor = MetricSystem.Kilo * 4.5359237e-1;
const _TroyGrainsConversionFactor = MetricSystem.Milli * 64.79891;

abstract class MassUnit extends BaseUnit<Mass> {
  const MassUnit(super.symbol, super.conversionFactor);

  @override
  Mass call(num value) => Mass(value.toDouble(), this);
}

final class Grams extends MassUnit {
  const Grams._() : super('g', 1);
}

final class Nanograms extends MassUnit {
  const Nanograms._() : super('ng', MetricSystem.Nano);
}

final class Micrograms extends MassUnit {
  const Micrograms._() : super('mcg', MetricSystem.Micro);
}

final class Milligrams extends MassUnit {
  const Milligrams._() : super('mg', MetricSystem.Milli);
}

final class Kilograms extends MassUnit {
  const Kilograms._() : super('kg', MetricSystem.Kilo);
}

final class Tonnes extends MassUnit {
  const Tonnes._() : super('t', MetricSystem.Mega);
}

final class Ounces extends MassUnit {
  const Ounces._() : super('oz', _PoundConversionFactor / 16.0);
}

final class Pounds extends MassUnit {
  const Pounds._() : super('lb', _PoundConversionFactor);
}

final class Kilopounds extends MassUnit {
  const Kilopounds._()
      : super('klb', _PoundConversionFactor * MetricSystem.Kilo);
}

final class Megapounds extends MassUnit {
  const Megapounds._()
      : super('Mlb', _PoundConversionFactor * MetricSystem.Mega);
}

final class Stone extends MassUnit {
  const Stone._() : super('st', _PoundConversionFactor * 14);
}

final class TroyGrains extends MassUnit {
  const TroyGrains._() : super('gr', _TroyGrainsConversionFactor);
}

final class Pennyweights extends MassUnit {
  const Pennyweights._() : super('dwt', _TroyGrainsConversionFactor * 24);
}

final class TroyOunces extends MassUnit {
  const TroyOunces._() : super('oz t', _TroyGrainsConversionFactor * 480);
}

final class TroyPounds extends MassUnit {
  const TroyPounds._() : super('lb t', _TroyGrainsConversionFactor * 480 * 12);
}

final class Tolas extends MassUnit {
  const Tolas._() : super('tola', _TroyGrainsConversionFactor * 180);
}

final class Carats extends MassUnit {
  const Carats._() : super('ct', MetricSystem.Milli * 200);
}

final class Dalton extends MassUnit {
  const Dalton._() : super('Da', MetricSystem.Kilo * 1.66053906660e-27);
}

extension MassOps on num {
  Mass get grams => Mass.grams(this);
  Mass get nanograms => Mass.nanograms(this);
  Mass get micrograms => Mass.micrograms(this);
  Mass get milligrams => Mass.milligrams(this);
  Mass get kilograms => Mass.kilograms(this);
  Mass get tonnes => Mass.tonnes(this);
  Mass get ounces => Mass.ounces(this);
  Mass get pounds => Mass.pounds(this);
  Mass get kilopounds => Mass.kilopounds(this);
  Mass get megapounds => Mass.megapounds(this);
  Mass get stone => Mass.stone(this);
  Mass get troyGrains => Mass.troyGrains(this);
  Mass get pennyweights => Mass.pennyweights(this);
  Mass get troyOunces => Mass.troyOunces(this);
  Mass get troyPounds => Mass.troyPounds(this);
  Mass get tolas => Mass.tolas(this);
  Mass get carats => Mass.carats(this);
}
