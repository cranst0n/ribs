import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing pressure (force per unit area).
final class Pressure extends Quantity<Pressure> {
  Pressure(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Pressure].
  Pressure operator +(Pressure that) => Pressure(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Pressure].
  Pressure operator -(Pressure that) => Pressure(value - that.to(unit), unit);

  /// Converts this to pascals (Pa).
  Pressure get toPascals => to(pascals).pascals;

  /// Converts this to kilopascals (kPa).
  Pressure get toKilopascals => to(kilopascals).kilopascals;

  /// Converts this to megapascals (MPa).
  Pressure get toMegapascals => to(megapascals).megapascals;

  /// Converts this to gigapascals (GPa).
  Pressure get toGigapascals => to(gigapascals).gigapascals;

  /// Converts this to bars.
  Pressure get toBars => to(bars).bars;

  /// Converts this to millibars (mbar).
  Pressure get toMillibars => to(millibars).millibars;

  /// Converts this to pounds per square inch (psi).
  Pressure get toPoundsPerSquareInch => to(poundsPerSquareInch).poundsPerSquareInch;

  /// Converts this to standard atmospheres (atm).
  Pressure get toAtmospheres => to(atmospheres).atmospheres;

  /// Converts this to torr.
  Pressure get toTorr => to(torr).torr;

  /// Unit for pascals (Pa) — the SI unit of pressure.
  static const PressureUnit pascals = Pascals._();

  /// Unit for kilopascals (kPa).
  static const PressureUnit kilopascals = Kilopascals._();

  /// Unit for megapascals (MPa).
  static const PressureUnit megapascals = Megapascals._();

  /// Unit for gigapascals (GPa).
  static const PressureUnit gigapascals = Gigapascals._();

  /// Unit for bars (100 000 Pa).
  static const PressureUnit bars = Bars._();

  /// Unit for millibars (mbar).
  static const PressureUnit millibars = Millibars._();

  /// Unit for pounds per square inch (psi).
  static const PressureUnit poundsPerSquareInch = PoundsPerSquareInch._();

  /// Unit for standard atmospheres (atm ≈ 101 325 Pa).
  static const PressureUnit atmospheres = Atmospheres._();

  /// Unit for torr (≈ 133.322 Pa).
  static const PressureUnit torr = Torr._();

  /// All supported [Pressure] units.
  static const units = {
    pascals,
    kilopascals,
    megapascals,
    gigapascals,
    bars,
    millibars,
    poundsPerSquareInch,
    atmospheres,
    torr,
  };

  /// Parses [s] into a [Pressure], returning [None] if parsing fails.
  static Option<Pressure> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Pressure] units.
abstract class PressureUnit extends BaseUnit<Pressure> {
  const PressureUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Pressure call(num value) => Pressure(value.toDouble(), this);
}

/// Pascals (Pa) — the SI unit of pressure.
final class Pascals extends PressureUnit {
  const Pascals._() : super('pascal', 'Pa', 1.0);
}

/// Kilopascals (kPa).
final class Kilopascals extends PressureUnit {
  const Kilopascals._() : super('kilopascal', 'kPa', MetricSystem.Kilo);
}

/// Megapascals (MPa).
final class Megapascals extends PressureUnit {
  const Megapascals._() : super('megapascal', 'MPa', MetricSystem.Mega);
}

/// Gigapascals (GPa).
final class Gigapascals extends PressureUnit {
  const Gigapascals._() : super('gigapascal', 'GPa', MetricSystem.Giga);
}

/// Bars (100 000 Pa).
final class Bars extends PressureUnit {
  const Bars._() : super('bar', 'bar', 1e5);
}

/// Millibars (mbar).
final class Millibars extends PressureUnit {
  const Millibars._() : super('millibar', 'mbar', 100.0);
}

/// Pounds per square inch (psi).
final class PoundsPerSquareInch extends PressureUnit {
  const PoundsPerSquareInch._() : super('pound/square inch', 'psi', 6894.757293168361);
}

/// Standard atmospheres (atm ≈ 101 325 Pa).
final class Atmospheres extends PressureUnit {
  const Atmospheres._() : super('atmosphere', 'atm', 101325.0);
}

/// Torr (≈ 133.322 Pa) — 1/760 of a standard atmosphere.
final class Torr extends PressureUnit {
  const Torr._() : super('torr', 'Torr', 133.32236842105263);
}

/// Extension methods for constructing [Pressure] values from [num].
extension PressureOps on num {
  /// Creates a [Pressure] of this value in pascals.
  Pressure get pascals => Pressure.pascals(this);

  /// Creates a [Pressure] of this value in kilopascals.
  Pressure get kilopascals => Pressure.kilopascals(this);

  /// Creates a [Pressure] of this value in megapascals.
  Pressure get megapascals => Pressure.megapascals(this);

  /// Creates a [Pressure] of this value in gigapascals.
  Pressure get gigapascals => Pressure.gigapascals(this);

  /// Creates a [Pressure] of this value in bars.
  Pressure get bars => Pressure.bars(this);

  /// Creates a [Pressure] of this value in millibars.
  Pressure get millibars => Pressure.millibars(this);

  /// Creates a [Pressure] of this value in pounds per square inch.
  Pressure get poundsPerSquareInch => Pressure.poundsPerSquareInch(this);

  /// Creates a [Pressure] of this value in standard atmospheres.
  Pressure get atmospheres => Pressure.atmospheres(this);

  /// Creates a [Pressure] of this value in torr.
  Pressure get torr => Pressure.torr(this);
}
