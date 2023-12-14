import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Length extends Quantity<Length> {
  Length(super.value, super.unit);

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

  Length get toNanometers => to(nanometers).nanometers;
  Length get toMicrons => to(microns).microns;
  Length get toMillimeters => to(millimeters).millimeters;
  Length get toCentimeters => to(centimeters).centimeters;
  Length get toDecimeters => to(decimeters).decimeters;
  Length get toMeters => to(meters).meters;
  Length get toDecameters => to(decameters).decameters;
  Length get toHectometers => to(hectometers).hectometers;
  Length get toKilometers => to(kilometers).kilometers;

  Length get toInches => to(inches).inches;
  Length get toFeet => to(feet).feet;
  Length get toYards => to(yards).yards;
  Length get toUsMiles => to(usMiles).usMiles;

  Length get toNauticalMiles => to(nauticalMiles).nauticalMiles;

  static const FeetConversionFactor = 3.048006096e-1;

  static const LengthUnit nanometers = Nanometers._();
  static const LengthUnit microns = Microns._();
  static const LengthUnit millimeters = Millimeters._();
  static const LengthUnit centimeters = Centimeters._();
  static const LengthUnit decimeters = Decimeters._();
  static const LengthUnit meters = Meters._();
  static const LengthUnit decameters = Decameters._();
  static const LengthUnit hectometers = Hectometers._();
  static const LengthUnit kilometers = Kilometers._();
  static const LengthUnit inches = Inches._();
  static const LengthUnit feet = Feet._();
  static const LengthUnit yards = Yards._();
  static const LengthUnit usMiles = UsMiles._();
  static const LengthUnit nauticalMiles = NauticalMiles._();

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

  static Option<Length> parse(String s) => Quantity.parse(s, units);
}

abstract class LengthUnit extends BaseUnit<Length> {
  const LengthUnit(super.symbol, super.conversionFactor);

  @override
  Length call(num value) => Length(value.toDouble(), this);
}

final class Nanometers extends LengthUnit {
  const Nanometers._() : super('nm', MetricSystem.Nano);
}

final class Microns extends LengthUnit {
  const Microns._() : super('µm', MetricSystem.Micro);
}

final class Millimeters extends LengthUnit {
  const Millimeters._() : super('mm', MetricSystem.Milli);
}

final class Centimeters extends LengthUnit {
  const Centimeters._() : super('cm', MetricSystem.Centi);
}

final class Decimeters extends LengthUnit {
  const Decimeters._() : super('dm', MetricSystem.Deci);
}

final class Meters extends LengthUnit {
  const Meters._() : super('m', 1.0);
}

final class Decameters extends LengthUnit {
  const Decameters._() : super('dam', MetricSystem.Deca);
}

final class Hectometers extends LengthUnit {
  const Hectometers._() : super('hm', MetricSystem.Hecto);
}

final class Kilometers extends LengthUnit {
  const Kilometers._() : super('hm', MetricSystem.Kilo);
}

final class Inches extends LengthUnit {
  const Inches._() : super('in', Length.FeetConversionFactor / 12);
}

final class Feet extends LengthUnit {
  const Feet._() : super('ft', Length.FeetConversionFactor);
}

final class Yards extends LengthUnit {
  const Yards._() : super('yd', Length.FeetConversionFactor * 3);
}

final class UsMiles extends LengthUnit {
  const UsMiles._() : super('mi', Length.FeetConversionFactor * 5.28e3);
}

final class NauticalMiles extends LengthUnit {
  const NauticalMiles._() : super('nmi', 1.852e3);
}

extension LengthOps on num {
  Length get nanometers => Length.nanometers(this);
  Length get microns => Length.microns(this);
  Length get millimeters => Length.millimeters(this);
  Length get centimeters => Length.centimeters(this);
  Length get decimeters => Length.decimeters(this);
  Length get meters => Length.meters(this);
  Length get decameters => Length.decameters(this);
  Length get hectometers => Length.hectometers(this);
  Length get kilometers => Length.kilometers(this);
  Length get inches => Length.inches(this);
  Length get feet => Length.feet(this);
  Length get yards => Length.yards(this);
  Length get usMiles => Length.usMiles(this);
  Length get nauticalMiles => Length.nauticalMiles(this);
}
