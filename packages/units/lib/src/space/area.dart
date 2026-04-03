import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing a two-dimensional area.
final class Area extends Quantity<Area> {
  Area(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Area].
  Area operator +(Area that) => Area(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Area].
  Area operator -(Area that) => Area(value - that.to(unit), unit);

  /// Multiplies this area by [that] length to produce a [Volume].
  ///
  /// The result unit is chosen to match the unit of `this` where possible
  /// (e.g. `squareFeet * feet → cubicFeet`); otherwise defaults to cubic meters.
  Volume operator *(Length that) => switch (unit) {
    SquareUsMiles _ => Volume.cubicUsMiles(value * that.toUsMiles.value),
    SquareYards _ => Volume.cubicYards(value * that.toYards.value),
    SquareFeet _ => Volume.cubicFeet(value * that.toFeet.value),
    SquareInches _ => Volume.cubicInches(value * that.toInches.value),
    _ => Volume.cubicMeters(toSquareMeters.value * that.toMeters.value),
  };

  /// Divides this area by [that] length to produce a [Length].
  ///
  /// The result unit is chosen to match the unit of `this` where possible;
  /// otherwise defaults to meters.
  Length operator /(Length that) => switch (unit) {
    SquareUsMiles _ => Length.usMiles(value / that.toUsMiles.value),
    SquareYards _ => Length.yards(value / that.toYards.value),
    SquareFeet _ => Length.feet(value / that.toFeet.value),
    SquareInches _ => Length.inches(value / that.toInches.value),
    _ => Length.meters(toSquareMeters.value / that.toMeters.value),
  };

  /// Converts this to square meters (m²).
  Area get toSquareMeters => to(squareMeters).squareMeters;

  /// Converts this to square centimeters (cm²).
  Area get toSquareCentimeters => to(squareCentimeters).squareCentimeters;

  /// Converts this to square kilometers (km²).
  Area get toSquareKilometers => to(squareKilometers).squareKilometers;

  /// Converts this to square US miles (mi²).
  Area get toSquareUsMiles => to(squareUsMiles).squareUsMiles;

  /// Converts this to square yards (yd²).
  Area get toSquareYards => to(squareYards).squareYards;

  /// Converts this to square feet (ft²).
  Area get toSquareFeet => to(squareFeet).squareFeet;

  /// Converts this to square inches (in²).
  Area get toSquareInches => to(squareInches).squareInches;

  /// Converts this to hectares (ha).
  Area get toHectares => to(hectares).hectares;

  /// Converts this to acres.
  Area get toAcres => to(acres).acres;

  /// Converts this to barns (b), used in nuclear physics.
  Area get toBarnes => to(barnes).barnes;

  /// Unit for square meters (m²).
  static const AreaUnit squareMeters = SquareMeters._();

  /// Unit for square centimeters (cm²).
  static const AreaUnit squareCentimeters = SquareCentimeters._();

  /// Unit for square kilometers (km²).
  static const AreaUnit squareKilometers = SquareKilometers._();

  /// Unit for square US miles (mi²).
  static const AreaUnit squareUsMiles = SquareUsMiles._();

  /// Unit for square yards (yd²).
  static const AreaUnit squareYards = SquareYards._();

  /// Unit for square feet (ft²).
  static const AreaUnit squareFeet = SquareFeet._();

  /// Unit for square inches (in²).
  static const AreaUnit squareInches = SquareInches._();

  /// Unit for hectares (ha).
  static const AreaUnit hectares = Hectares._();

  /// Unit for acres.
  static const AreaUnit acres = Acres._();

  /// Unit for barns (b) — 10⁻²⁸ m², used in nuclear and particle physics.
  static const AreaUnit barnes = Barnes._();

  /// All supported [Area] units.
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

  /// Parses [s] into an [Area], returning [None] if parsing fails.
  static Option<Area> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Area] units.
abstract class AreaUnit extends BaseUnit<Area> {
  const AreaUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Area call(num value) => Area(value.toDouble(), this);
}

/// Square meters (m²) — the SI unit of area.
final class SquareMeters extends AreaUnit {
  const SquareMeters._() : super('square meter', 'm²', 1);
}

/// Square centimeters (cm²).
final class SquareCentimeters extends AreaUnit {
  const SquareCentimeters._()
    : super('square centimeter', 'cm²', MetricSystem.Centi * MetricSystem.Centi);
}

/// Square kilometers (km²).
final class SquareKilometers extends AreaUnit {
  const SquareKilometers._()
    : super('square kilometer', 'km²', MetricSystem.Kilo * MetricSystem.Kilo);
}

/// Square US miles (mi²).
final class SquareUsMiles extends AreaUnit {
  const SquareUsMiles._() : super('square mile', 'mi²', 2.589988110336 * 1e6);
}

/// Square yards (yd²).
final class SquareYards extends AreaUnit {
  const SquareYards._() : super('square yard', 'yd²', 8.3612736e-1);
}

/// Square feet (ft²).
final class SquareFeet extends AreaUnit {
  const SquareFeet._() : super('square feet', 'ft²', 9.290304e-2);
}

/// Square inches (in²).
final class SquareInches extends AreaUnit {
  const SquareInches._() : super('square inch', 'in²', 6.4516 * 1e-4);
}

/// Hectares (ha).
final class Hectares extends AreaUnit {
  const Hectares._() : super('hectare', 'ha', 1e4);
}

/// Acres.
final class Acres extends AreaUnit {
  const Acres._() : super('acre', 'acre', 43560 * 9.290304e-2);
}

/// Barns (b) — 10⁻²⁸ m², used in nuclear and particle physics cross-sections.
final class Barnes extends AreaUnit {
  const Barnes._() : super('barne', 'b', 1e-28);
}

/// Extension methods for constructing [Area] values from [num].
extension AreaOps on num {
  /// Creates an [Area] of this value in square meters.
  Area get squareMeters => Area.squareMeters(this);

  /// Creates an [Area] of this value in square centimeters.
  Area get squareCentimeters => Area.squareCentimeters(this);

  /// Creates an [Area] of this value in square kilometers.
  Area get squareKilometers => Area.squareKilometers(this);

  /// Creates an [Area] of this value in square US miles.
  Area get squareUsMiles => Area.squareUsMiles(this);

  /// Creates an [Area] of this value in square yards.
  Area get squareYards => Area.squareYards(this);

  /// Creates an [Area] of this value in square feet.
  Area get squareFeet => Area.squareFeet(this);

  /// Creates an [Area] of this value in square inches.
  Area get squareInches => Area.squareInches(this);

  /// Creates an [Area] of this value in hectares.
  Area get hectares => Area.hectares(this);

  /// Creates an [Area] of this value in acres.
  Area get acres => Area.acres(this);

  /// Creates an [Area] of this value in barns.
  Area get barnes => Area.barnes(this);
}
