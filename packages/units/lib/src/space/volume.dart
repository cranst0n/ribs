import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Volume extends Quantity<Volume> {
  Volume(super.value, super.unit);

  Volume get toCubicMeters => to(cubicMeters).cubicMeters;
  Volume get toLitres => to(litres).litres;
  Volume get toNanolitres => to(nanolitres).nanolitres;
  Volume get toMicrolitres => to(microlitres).microlitres;
  Volume get toMillilitres => to(millilitres).millilitres;
  Volume get toCentilitres => to(centilitres).centilitres;
  Volume get toDecilitres => to(decilitres).decilitres;
  Volume get toHectolitres => to(hectolitres).hectolitres;
  Volume get toCubicUsMiles => to(cubicUsMiles).cubicUsMiles;
  Volume get toCubicYards => to(cubicYards).cubicYards;
  Volume get toCubicFeet => to(cubicFeet).cubicFeet;
  Volume get toCubicInches => to(cubicInches).cubicInches;
  Volume get toUsGallons => to(usGallons).usGallons;
  Volume get toUsQuarts => to(usQuarts).usQuarts;
  Volume get toUsPints => to(usPints).usPints;
  Volume get toUsCups => to(usCups).usCups;
  Volume get toFluidOunces => to(fluidOunces).fluidOunces;
  Volume get toTablespoons => to(tablespoons).tablespoons;
  Volume get toTeaspoons => to(teaspoons).teaspoons;

  static const cubicMeters = CubicMeters._();
  static const litres = Litres._();
  static const nanolitres = Nanolitres._();
  static const microlitres = Microlitres._();
  static const millilitres = Millilitres._();
  static const centilitres = Centilitres._();
  static const decilitres = Decilitres._();
  static const hectolitres = Hectolitres._();
  static const cubicUsMiles = CubicUsMiles._();
  static const cubicYards = CubicYards._();
  static const cubicFeet = CubicFeet._();
  static const cubicInches = CubicInches._();
  static const usGallons = UsGallons._();
  static const usQuarts = UsQuarts._();
  static const usPints = UsPints._();
  static const usCups = UsCups._();
  static const fluidOunces = FluidOunces._();
  static const tablespoons = Tablespoons._();
  static const teaspoons = Teaspoons._();

  static const units = {
    cubicMeters,
    litres,
    nanolitres,
    microlitres,
    millilitres,
    centilitres,
    decilitres,
    hectolitres,
    cubicUsMiles,
    cubicYards,
    cubicFeet,
    cubicInches,
    usGallons,
    usQuarts,
    usPints,
    usCups,
    fluidOunces,
    tablespoons,
    teaspoons,
  };

  static Option<Volume> parse(String s) => Quantity.parse(s, units);
}

const _LitresConversionFactor = 1e-3;
const _UsGallonsConversionFactor = _LitresConversionFactor * MetricSystem.Milli * 3.785411784e3;

abstract class VolumeUnit extends BaseUnit<Volume> {
  const VolumeUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Volume call(num value) => Volume(value.toDouble(), this);
}

final class CubicMeters extends VolumeUnit {
  const CubicMeters._() : super('cubic meter', 'm³', 1);
}

final class Litres extends VolumeUnit {
  const Litres._() : super('litre', 'L', _LitresConversionFactor);
}

final class Nanolitres extends VolumeUnit {
  const Nanolitres._() : super('nanolitre', 'nl', _LitresConversionFactor * MetricSystem.Nano);
}

final class Microlitres extends VolumeUnit {
  const Microlitres._() : super('microlitre', 'µl', _LitresConversionFactor * MetricSystem.Micro);
}

final class Millilitres extends VolumeUnit {
  const Millilitres._() : super('millilitre', 'ml', _LitresConversionFactor * MetricSystem.Milli);
}

final class Centilitres extends VolumeUnit {
  const Centilitres._() : super('centilitre', 'cl', _LitresConversionFactor * MetricSystem.Centi);
}

final class Decilitres extends VolumeUnit {
  const Decilitres._() : super('decilitre', 'dl', _LitresConversionFactor * MetricSystem.Deci);
}

final class Hectolitres extends VolumeUnit {
  const Hectolitres._() : super('hectolitre', 'hl', _LitresConversionFactor * MetricSystem.Hecto);
}

final class CubicUsMiles extends VolumeUnit {
  const CubicUsMiles._() : super('cubic mile', 'mi³', 4168206834.581550443);
}

final class CubicYards extends VolumeUnit {
  const CubicYards._() : super('cubic yard', 'yd³', 0.764559445);
}

final class CubicFeet extends VolumeUnit {
  const CubicFeet._() : super('cubic feet', 'ft³', 0.028317016);
}

final class CubicInches extends VolumeUnit {
  const CubicInches._() : super('cubic inch', 'in³', 0.000016387);
}

final class UsGallons extends VolumeUnit {
  const UsGallons._() : super('gallon', 'gal', _UsGallonsConversionFactor);
}

final class UsQuarts extends VolumeUnit {
  const UsQuarts._() : super('quart', 'qt', _UsGallonsConversionFactor / 4);
}

final class UsPints extends VolumeUnit {
  const UsPints._() : super('pint', 'pt', _UsGallonsConversionFactor / 8);
}

final class UsCups extends VolumeUnit {
  const UsCups._() : super('cup', 'c', _UsGallonsConversionFactor / 16);
}

final class FluidOunces extends VolumeUnit {
  const FluidOunces._() : super('ounce', 'oz', _UsGallonsConversionFactor / 128);
}

final class Tablespoons extends VolumeUnit {
  const Tablespoons._() : super('tablespoon', 'tbsp', _UsGallonsConversionFactor / 128 / 2);
}

final class Teaspoons extends VolumeUnit {
  const Teaspoons._() : super('teaspon', 'tsp', _UsGallonsConversionFactor / 128 / 6);
}

extension VolumeOps on num {
  Volume get cubicMeters => Volume.cubicMeters(this);
  Volume get litres => Volume.litres(this);
  Volume get nanolitres => Volume.nanolitres(this);
  Volume get microlitres => Volume.microlitres(this);
  Volume get millilitres => Volume.millilitres(this);
  Volume get centilitres => Volume.centilitres(this);
  Volume get decilitres => Volume.decilitres(this);
  Volume get hectolitres => Volume.hectolitres(this);
  Volume get cubicUsMiles => Volume.cubicUsMiles(this);
  Volume get cubicYards => Volume.cubicYards(this);
  Volume get cubicFeet => Volume.cubicFeet(this);
  Volume get cubicInches => Volume.cubicInches(this);
  Volume get usGallons => Volume.usGallons(this);
  Volume get usQuarts => Volume.usQuarts(this);
  Volume get usPints => Volume.usPints(this);
  Volume get usCups => Volume.usCups(this);
  Volume get fluidOunces => Volume.fluidOunces(this);
  Volume get tablespoons => Volume.tablespoons(this);
  Volume get teaspoons => Volume.teaspoons(this);
}
