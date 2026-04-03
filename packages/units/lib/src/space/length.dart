import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing length or distance.
final class Length extends Quantity<Length> {
  Length(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Length].
  Length operator +(Length that) => Length(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Length].
  Length operator -(Length that) => Length(value - that.to(unit), unit);

  /// Divides this length by [that] time to produce a [Velocity] in m/s.
  Velocity operator /(Time that) => Velocity.metersPerSecond(toMeters.value / that.toSeconds.value);

  /// Multiplies this length by [that] to produce an [Area].
  ///
  /// The result unit is chosen to match the unit of `this` where possible
  /// (e.g. `feet * feet → squareFeet`); otherwise defaults to square meters.
  Area operator *(Length that) {
    if (unit == centimeters) {
      return Area.squareCentimeters(value * that.toCentimeters.value);
    } else if (unit == kilometers) {
      return Area.squareKilometers(value * that.toKilometers.value);
    } else if (unit == usMiles) {
      return Area.squareUsMiles(value * that.toUsMiles.value);
    } else if (unit == yards) {
      return Area.squareYards(value * that.toYards.value);
    } else if (unit == feet) {
      return Area.squareFeet(value * that.toFeet.value);
    } else if (unit == inches) {
      return Area.squareInches(value * that.toInches.value);
    } else {
      return Area.squareMeters(toMeters.value * that.toMeters.value);
    }
  }

  /// Converts this to nanometers (nm).
  Length get toNanometers => to(nanometers).nanometers;

  /// Converts this to microns (µm).
  Length get toMicrons => to(microns).microns;

  /// Converts this to millimeters (mm).
  Length get toMillimeters => to(millimeters).millimeters;

  /// Converts this to centimeters (cm).
  Length get toCentimeters => to(centimeters).centimeters;

  /// Converts this to decimeters (dm).
  Length get toDecimeters => to(decimeters).decimeters;

  /// Converts this to meters (m).
  Length get toMeters => to(meters).meters;

  /// Converts this to decameters (dam).
  Length get toDecameters => to(decameters).decameters;

  /// Converts this to hectometers (hm).
  Length get toHectometers => to(hectometers).hectometers;

  /// Converts this to kilometers (km).
  Length get toKilometers => to(kilometers).kilometers;

  /// Converts this to inches (in).
  Length get toInches => to(inches).inches;

  /// Converts this to feet (ft).
  Length get toFeet => to(feet).feet;

  /// Converts this to yards (yd).
  Length get toYards => to(yards).yards;

  /// Converts this to US miles (mi).
  Length get toUsMiles => to(usMiles).usMiles;

  /// Converts this to nautical miles (nmi).
  Length get toNauticalMiles => to(nauticalMiles).nauticalMiles;

  /// Conversion factor from feet to meters.
  static const FeetConversionFactor = 3.048006096e-1;

  /// Unit for nanometers (nm).
  static const LengthUnit nanometers = Nanometers._();

  /// Unit for microns / micrometers (µm).
  static const LengthUnit microns = Microns._();

  /// Unit for millimeters (mm).
  static const LengthUnit millimeters = Millimeters._();

  /// Unit for centimeters (cm).
  static const LengthUnit centimeters = Centimeters._();

  /// Unit for decimeters (dm).
  static const LengthUnit decimeters = Decimeters._();

  /// Unit for meters (m) — the SI base unit of length.
  static const LengthUnit meters = Meters._();

  /// Unit for decameters (dam).
  static const LengthUnit decameters = Decameters._();

  /// Unit for hectometers (hm).
  static const LengthUnit hectometers = Hectometers._();

  /// Unit for kilometers (km).
  static const LengthUnit kilometers = Kilometers._();

  /// Unit for inches (in).
  static const LengthUnit inches = Inches._();

  /// Unit for feet (ft).
  static const LengthUnit feet = Feet._();

  /// Unit for yards (yd).
  static const LengthUnit yards = Yards._();

  /// Unit for US survey miles (mi).
  static const LengthUnit usMiles = UsMiles._();

  /// Unit for nautical miles (nmi).
  static const LengthUnit nauticalMiles = NauticalMiles._();

  /// All supported [Length] units.
  static const units = {
    nanometers,
    microns,
    millimeters,
    centimeters,
    decimeters,
    meters,
    decameters,
    hectometers,
    kilometers,
    inches,
    feet,
    yards,
    usMiles,
    nauticalMiles,
  };

  /// Parses [s] into a [Length], returning [None] if parsing fails.
  static Option<Length> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Length] units.
abstract class LengthUnit extends BaseUnit<Length> {
  const LengthUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Length call(num value) => Length(value.toDouble(), this);
}

/// Nanometers (nm).
final class Nanometers extends LengthUnit {
  const Nanometers._() : super('nanometer', 'nm', MetricSystem.Nano);
}

/// Microns / micrometers (µm).
final class Microns extends LengthUnit {
  const Microns._() : super('micron', 'µm', MetricSystem.Micro);
}

/// Millimeters (mm).
final class Millimeters extends LengthUnit {
  const Millimeters._() : super('millimeter', 'mm', MetricSystem.Milli);
}

/// Centimeters (cm).
final class Centimeters extends LengthUnit {
  const Centimeters._() : super('centimeter', 'cm', MetricSystem.Centi);
}

/// Decimeters (dm).
final class Decimeters extends LengthUnit {
  const Decimeters._() : super('decimeter', 'dm', MetricSystem.Deci);
}

/// Meters (m) — the SI base unit of length.
final class Meters extends LengthUnit {
  const Meters._() : super('meter', 'm', 1.0);
}

/// Decameters (dam).
final class Decameters extends LengthUnit {
  const Decameters._() : super('decameter', 'dam', MetricSystem.Deca);
}

/// Hectometers (hm).
final class Hectometers extends LengthUnit {
  const Hectometers._() : super('hectometer', 'hm', MetricSystem.Hecto);
}

/// Kilometers (km).
final class Kilometers extends LengthUnit {
  const Kilometers._() : super('kilometer', 'km', MetricSystem.Kilo);
}

/// Inches (in).
final class Inches extends LengthUnit {
  const Inches._() : super('inch', 'in', Length.FeetConversionFactor / 12);
}

/// Feet (ft).
final class Feet extends LengthUnit {
  const Feet._() : super('feet', 'ft', Length.FeetConversionFactor);
}

/// Yards (yd).
final class Yards extends LengthUnit {
  const Yards._() : super('yard', 'yd', Length.FeetConversionFactor * 3);
}

/// US survey miles (mi).
final class UsMiles extends LengthUnit {
  const UsMiles._() : super('mile', 'mi', Length.FeetConversionFactor * 5.28e3);
}

/// Nautical miles (nmi).
final class NauticalMiles extends LengthUnit {
  const NauticalMiles._() : super('nautical mile', 'nmi', 1.852e3);
}

/// Extension methods for constructing [Length] values from [num].
extension LengthOps on num {
  /// Creates a [Length] of this value in nanometers.
  Length get nanometers => Length.nanometers(this);

  /// Creates a [Length] of this value in microns.
  Length get microns => Length.microns(this);

  /// Creates a [Length] of this value in millimeters.
  Length get millimeters => Length.millimeters(this);

  /// Creates a [Length] of this value in centimeters.
  Length get centimeters => Length.centimeters(this);

  /// Creates a [Length] of this value in decimeters.
  Length get decimeters => Length.decimeters(this);

  /// Creates a [Length] of this value in meters.
  Length get meters => Length.meters(this);

  /// Creates a [Length] of this value in decameters.
  Length get decameters => Length.decameters(this);

  /// Creates a [Length] of this value in hectometers.
  Length get hectometers => Length.hectometers(this);

  /// Creates a [Length] of this value in kilometers.
  Length get kilometers => Length.kilometers(this);

  /// Creates a [Length] of this value in inches.
  Length get inches => Length.inches(this);

  /// Creates a [Length] of this value in feet.
  Length get feet => Length.feet(this);

  /// Creates a [Length] of this value in yards.
  Length get yards => Length.yards(this);

  /// Creates a [Length] of this value in US miles.
  Length get usMiles => Length.usMiles(this);

  /// Creates a [Length] of this value in nautical miles.
  Length get nauticalMiles => Length.nauticalMiles(this);
}
