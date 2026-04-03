import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing three-dimensional volume.
final class Volume extends Quantity<Volume> {
  Volume(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Volume].
  Volume operator +(Volume that) => Volume(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Volume].
  Volume operator -(Volume that) => Volume(value - that.to(unit), unit);

  /// Divides this volume by [that] time to produce a [VolumeFlow] in m³/s.
  VolumeFlow operator /(Time that) =>
      VolumeFlow.cubicMetersPerSecond(toCubicMeters.value / that.toSeconds.value);

  /// Converts this to cubic meters (m³).
  Volume get toCubicMeters => to(cubicMeters).cubicMeters;

  /// Converts this to litres (L).
  Volume get toLitres => to(litres).litres;

  /// Converts this to nanolitres (nl).
  Volume get toNanolitres => to(nanolitres).nanolitres;

  /// Converts this to microlitres (µl).
  Volume get toMicrolitres => to(microlitres).microlitres;

  /// Converts this to millilitres (ml).
  Volume get toMillilitres => to(millilitres).millilitres;

  /// Converts this to centilitres (cl).
  Volume get toCentilitres => to(centilitres).centilitres;

  /// Converts this to decilitres (dl).
  Volume get toDecilitres => to(decilitres).decilitres;

  /// Converts this to hectolitres (hl).
  Volume get toHectolitres => to(hectolitres).hectolitres;

  /// Converts this to cubic US miles (mi³).
  Volume get toCubicUsMiles => to(cubicUsMiles).cubicUsMiles;

  /// Converts this to cubic yards (yd³).
  Volume get toCubicYards => to(cubicYards).cubicYards;

  /// Converts this to cubic feet (ft³).
  Volume get toCubicFeet => to(cubicFeet).cubicFeet;

  /// Converts this to cubic inches (in³).
  Volume get toCubicInches => to(cubicInches).cubicInches;

  /// Converts this to US gallons (gal).
  Volume get toUsGallons => to(usGallons).usGallons;

  /// Converts this to US quarts (qt).
  Volume get toUsQuarts => to(usQuarts).usQuarts;

  /// Converts this to US pints (pt).
  Volume get toUsPints => to(usPints).usPints;

  /// Converts this to US cups (c).
  Volume get toUsCups => to(usCups).usCups;

  /// Converts this to fluid ounces (oz).
  Volume get toFluidOunces => to(fluidOunces).fluidOunces;

  /// Converts this to tablespoons (tbsp).
  Volume get toTablespoons => to(tablespoons).tablespoons;

  /// Converts this to teaspoons (tsp).
  Volume get toTeaspoons => to(teaspoons).teaspoons;

  /// Unit for cubic meters (m³).
  static const cubicMeters = CubicMeters._();

  /// Unit for litres (L).
  static const litres = Litres._();

  /// Unit for nanolitres (nl).
  static const nanolitres = Nanolitres._();

  /// Unit for microlitres (µl).
  static const microlitres = Microlitres._();

  /// Unit for millilitres (ml).
  static const millilitres = Millilitres._();

  /// Unit for centilitres (cl).
  static const centilitres = Centilitres._();

  /// Unit for decilitres (dl).
  static const decilitres = Decilitres._();

  /// Unit for hectolitres (hl).
  static const hectolitres = Hectolitres._();

  /// Unit for cubic US miles (mi³).
  static const cubicUsMiles = CubicUsMiles._();

  /// Unit for cubic yards (yd³).
  static const cubicYards = CubicYards._();

  /// Unit for cubic feet (ft³).
  static const cubicFeet = CubicFeet._();

  /// Unit for cubic inches (in³).
  static const cubicInches = CubicInches._();

  /// Unit for US gallons (gal).
  static const usGallons = UsGallons._();

  /// Unit for US quarts (qt).
  static const usQuarts = UsQuarts._();

  /// Unit for US pints (pt).
  static const usPints = UsPints._();

  /// Unit for US cups (c).
  static const usCups = UsCups._();

  /// Unit for fluid ounces (oz).
  static const fluidOunces = FluidOunces._();

  /// Unit for tablespoons (tbsp).
  static const tablespoons = Tablespoons._();

  /// Unit for teaspoons (tsp).
  static const teaspoons = Teaspoons._();

  /// All supported [Volume] units.
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

  /// Parses [s] into a [Volume], returning [None] if parsing fails.
  static Option<Volume> parse(String s) => Quantity.parse(s, units);
}

const _LitresConversionFactor = 1e-3;
const _UsGallonsConversionFactor = _LitresConversionFactor * MetricSystem.Milli * 3.785411784e3;

/// Base class for all [Volume] units.
abstract class VolumeUnit extends BaseUnit<Volume> {
  const VolumeUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Volume call(num value) => Volume(value.toDouble(), this);
}

/// Cubic meters (m³) — the SI unit of volume.
final class CubicMeters extends VolumeUnit {
  const CubicMeters._() : super('cubic meter', 'm³', 1);
}

/// Litres (L).
final class Litres extends VolumeUnit {
  const Litres._() : super('litre', 'L', _LitresConversionFactor);
}

/// Nanolitres (nl).
final class Nanolitres extends VolumeUnit {
  const Nanolitres._() : super('nanolitre', 'nl', _LitresConversionFactor * MetricSystem.Nano);
}

/// Microlitres (µl).
final class Microlitres extends VolumeUnit {
  const Microlitres._() : super('microlitre', 'µl', _LitresConversionFactor * MetricSystem.Micro);
}

/// Millilitres (ml).
final class Millilitres extends VolumeUnit {
  const Millilitres._() : super('millilitre', 'ml', _LitresConversionFactor * MetricSystem.Milli);
}

/// Centilitres (cl).
final class Centilitres extends VolumeUnit {
  const Centilitres._() : super('centilitre', 'cl', _LitresConversionFactor * MetricSystem.Centi);
}

/// Decilitres (dl).
final class Decilitres extends VolumeUnit {
  const Decilitres._() : super('decilitre', 'dl', _LitresConversionFactor * MetricSystem.Deci);
}

/// Hectolitres (hl).
final class Hectolitres extends VolumeUnit {
  const Hectolitres._() : super('hectolitre', 'hl', _LitresConversionFactor * MetricSystem.Hecto);
}

/// Cubic US miles (mi³).
final class CubicUsMiles extends VolumeUnit {
  const CubicUsMiles._() : super('cubic mile', 'mi³', 4168206834.581550443);
}

/// Cubic yards (yd³).
final class CubicYards extends VolumeUnit {
  const CubicYards._() : super('cubic yard', 'yd³', 0.764559445);
}

/// Cubic feet (ft³).
final class CubicFeet extends VolumeUnit {
  const CubicFeet._() : super('cubic feet', 'ft³', 0.028317016);
}

/// Cubic inches (in³).
final class CubicInches extends VolumeUnit {
  const CubicInches._() : super('cubic inch', 'in³', 0.000016387);
}

/// US gallons (gal).
final class UsGallons extends VolumeUnit {
  const UsGallons._() : super('gallon', 'gal', _UsGallonsConversionFactor);
}

/// US quarts (qt) — one quarter of a US gallon.
final class UsQuarts extends VolumeUnit {
  const UsQuarts._() : super('quart', 'qt', _UsGallonsConversionFactor / 4);
}

/// US pints (pt) — one eighth of a US gallon.
final class UsPints extends VolumeUnit {
  const UsPints._() : super('pint', 'pt', _UsGallonsConversionFactor / 8);
}

/// US cups (c) — one sixteenth of a US gallon.
final class UsCups extends VolumeUnit {
  const UsCups._() : super('cup', 'c', _UsGallonsConversionFactor / 16);
}

/// Fluid ounces (oz) — one 128th of a US gallon.
final class FluidOunces extends VolumeUnit {
  const FluidOunces._() : super('ounce', 'oz', _UsGallonsConversionFactor / 128);
}

/// Tablespoons (tbsp) — one half of a fluid ounce.
final class Tablespoons extends VolumeUnit {
  const Tablespoons._() : super('tablespoon', 'tbsp', _UsGallonsConversionFactor / 128 / 2);
}

/// Teaspoons (tsp) — one third of a tablespoon.
final class Teaspoons extends VolumeUnit {
  const Teaspoons._() : super('teaspon', 'tsp', _UsGallonsConversionFactor / 128 / 6);
}

/// Extension methods for constructing [Volume] values from [num].
extension VolumeOps on num {
  /// Creates a [Volume] of this value in cubic meters.
  Volume get cubicMeters => Volume.cubicMeters(this);

  /// Creates a [Volume] of this value in litres.
  Volume get litres => Volume.litres(this);

  /// Creates a [Volume] of this value in nanolitres.
  Volume get nanolitres => Volume.nanolitres(this);

  /// Creates a [Volume] of this value in microlitres.
  Volume get microlitres => Volume.microlitres(this);

  /// Creates a [Volume] of this value in millilitres.
  Volume get millilitres => Volume.millilitres(this);

  /// Creates a [Volume] of this value in centilitres.
  Volume get centilitres => Volume.centilitres(this);

  /// Creates a [Volume] of this value in decilitres.
  Volume get decilitres => Volume.decilitres(this);

  /// Creates a [Volume] of this value in hectolitres.
  Volume get hectolitres => Volume.hectolitres(this);

  /// Creates a [Volume] of this value in cubic US miles.
  Volume get cubicUsMiles => Volume.cubicUsMiles(this);

  /// Creates a [Volume] of this value in cubic yards.
  Volume get cubicYards => Volume.cubicYards(this);

  /// Creates a [Volume] of this value in cubic feet.
  Volume get cubicFeet => Volume.cubicFeet(this);

  /// Creates a [Volume] of this value in cubic inches.
  Volume get cubicInches => Volume.cubicInches(this);

  /// Creates a [Volume] of this value in US gallons.
  Volume get usGallons => Volume.usGallons(this);

  /// Creates a [Volume] of this value in US quarts.
  Volume get usQuarts => Volume.usQuarts(this);

  /// Creates a [Volume] of this value in US pints.
  Volume get usPints => Volume.usPints(this);

  /// Creates a [Volume] of this value in US cups.
  Volume get usCups => Volume.usCups(this);

  /// Creates a [Volume] of this value in fluid ounces.
  Volume get fluidOunces => Volume.fluidOunces(this);

  /// Creates a [Volume] of this value in tablespoons.
  Volume get tablespoons => Volume.tablespoons(this);

  /// Creates a [Volume] of this value in teaspoons.
  Volume get teaspoons => Volume.teaspoons(this);
}
