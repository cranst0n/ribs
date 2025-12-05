import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Area extends Quantity<Area> {
  Area(super.value, super.unit);

  Volume operator *(Length that) => switch (unit) {
        SquareUsMiles _ => Volume.cubicUsMiles(value * that.toUsMiles.value),
        SquareYards _ => Volume.cubicYards(value * that.toYards.value),
        SquareFeet _ => Volume.cubicFeet(value * that.toFeet.value),
        SquareInches _ => Volume.cubicInches(value * that.toInches.value),
        _ => Volume.cubicMeters(toSquareMeters.value * that.toMeters.value),
      };

  Length operator /(Length that) => switch (unit) {
        SquareUsMiles _ => Length.usMiles(value / that.toUsMiles.value),
        SquareYards _ => Length.yards(value / that.toYards.value),
        SquareFeet _ => Length.feet(value / that.toFeet.value),
        SquareInches _ => Length.inches(value / that.toInches.value),
        _ => Length.meters(toSquareMeters.value / that.toMeters.value),
      };

  Area get toSquareMeters => to(squareMeters).squareMeters;
  Area get toSquareCentimeters => to(squareCentimeters).squareCentimeters;
  Area get toSquareKilometers => to(squareKilometers).squareKilometers;
  Area get toSquareUsMiles => to(squareUsMiles).squareUsMiles;
  Area get toSquareYards => to(squareYards).squareYards;
  Area get toSquareFeet => to(squareFeet).squareFeet;
  Area get toSquareInches => to(squareInches).squareInches;
  Area get toHectares => to(hectares).hectares;
  Area get toAcres => to(acres).acres;
  Area get toBarnes => to(barnes).barnes;

  static const AreaUnit squareMeters = SquareMeters._();
  static const AreaUnit squareCentimeters = SquareCentimeters._();
  static const AreaUnit squareKilometers = SquareKilometers._();
  static const AreaUnit squareUsMiles = SquareUsMiles._();
  static const AreaUnit squareYards = SquareYards._();
  static const AreaUnit squareFeet = SquareFeet._();
  static const AreaUnit squareInches = SquareInches._();
  static const AreaUnit hectares = Hectares._();
  static const AreaUnit acres = Acres._();
  static const AreaUnit barnes = Barnes._();

  static const units = {
    squareMeters,
    squareCentimeters,
    squareKilometers,
    squareUsMiles,
    squareYards,
    squareFeet,
    squareInches,
    hectares,
    acres,
    barnes,
  };

  static Option<Area> parse(String s) => Quantity.parse(s, units);
}

abstract class AreaUnit extends BaseUnit<Area> {
  const AreaUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Area call(num value) => Area(value.toDouble(), this);
}

final class SquareMeters extends AreaUnit {
  const SquareMeters._() : super('square meter', 'm²', 1);
}

final class SquareCentimeters extends AreaUnit {
  const SquareCentimeters._()
      : super('square centimeter', 'cm²', MetricSystem.Centi * MetricSystem.Centi);
}

final class SquareKilometers extends AreaUnit {
  const SquareKilometers._()
      : super('square kilometer', 'km²', MetricSystem.Kilo * MetricSystem.Kilo);
}

final class SquareUsMiles extends AreaUnit {
  const SquareUsMiles._() : super('square mile', 'mi²', 2.589988110336 * 1e6);
}

final class SquareYards extends AreaUnit {
  const SquareYards._() : super('square yard', 'yd²', 8.3612736e-1);
}

final class SquareFeet extends AreaUnit {
  const SquareFeet._() : super('square feet', 'ft²', 9.290304e-2);
}

final class SquareInches extends AreaUnit {
  const SquareInches._() : super('square inch', 'in²', 6.4516 * 1e-4);
}

final class Hectares extends AreaUnit {
  const Hectares._() : super('hectare', 'ha', 1e4);
}

final class Acres extends AreaUnit {
  const Acres._() : super('acre', 'acre', 43560 * 9.290304e-2);
}

final class Barnes extends AreaUnit {
  const Barnes._() : super('barne', 'b', 1e-28);
}

extension AreaOps on num {
  Area get squareMeters => Area.squareMeters(this);
  Area get squareCentimeters => Area.squareCentimeters(this);
  Area get squareKilometers => Area.squareKilometers(this);
  Area get squareUsMiles => Area.squareUsMiles(this);
  Area get squareYards => Area.squareYards(this);
  Area get squareFeet => Area.squareFeet(this);
  Area get squareInches => Area.squareInches(this);
  Area get hectares => Area.hectares(this);
  Area get acres => Area.acres(this);
  Area get barnes => Area.barnes(this);
}
