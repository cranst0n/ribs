import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing magnetic flux density (magnetic field strength).
final class MagneticFluxDensity extends Quantity<MagneticFluxDensity> {
  MagneticFluxDensity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [MagneticFluxDensity].
  MagneticFluxDensity operator +(MagneticFluxDensity that) =>
      MagneticFluxDensity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [MagneticFluxDensity].
  MagneticFluxDensity operator -(MagneticFluxDensity that) =>
      MagneticFluxDensity(value - that.to(unit), unit);

  /// Converts this to nanoteslas (nT).
  MagneticFluxDensity get toNanoteslas => to(nanoteslas).nanoteslas;

  /// Converts this to microteslas (µT).
  MagneticFluxDensity get toMicroteslas => to(microteslas).microteslas;

  /// Converts this to milliteslas (mT).
  MagneticFluxDensity get toMilliteslas => to(milliteslas).milliteslas;

  /// Converts this to teslas (T).
  MagneticFluxDensity get toTeslas => to(teslas).teslas;

  /// Converts this to gauss (G).
  MagneticFluxDensity get toGauss => to(gauss).gauss;

  /// Unit for nanoteslas (nT).
  static const MagneticFluxDensityUnit nanoteslas = Nanoteslas._();

  /// Unit for microteslas (µT).
  static const MagneticFluxDensityUnit microteslas = Microteslas._();

  /// Unit for milliteslas (mT).
  static const MagneticFluxDensityUnit milliteslas = Milliteslas._();

  /// Unit for teslas (T) — the SI unit of magnetic flux density.
  static const MagneticFluxDensityUnit teslas = Teslas._();

  /// Unit for gauss (G) — the CGS unit of magnetic flux density (1 G = 10⁻⁴ T).
  static const MagneticFluxDensityUnit gauss = Gauss._();

  /// All supported [MagneticFluxDensity] units.
  static const units = {
    nanoteslas,
    microteslas,
    milliteslas,
    teslas,
    gauss,
  };

  /// Parses [s] into a [MagneticFluxDensity], returning [None] if parsing fails.
  static Option<MagneticFluxDensity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [MagneticFluxDensity] units.
abstract class MagneticFluxDensityUnit extends BaseUnit<MagneticFluxDensity> {
  const MagneticFluxDensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MagneticFluxDensity call(num value) => MagneticFluxDensity(value.toDouble(), this);
}

/// Nanoteslas (nT).
final class Nanoteslas extends MagneticFluxDensityUnit {
  const Nanoteslas._() : super('nanotesla', 'nT', MetricSystem.Nano);
}

/// Microteslas (µT).
final class Microteslas extends MagneticFluxDensityUnit {
  const Microteslas._() : super('microtesla', 'µT', MetricSystem.Micro);
}

/// Milliteslas (mT).
final class Milliteslas extends MagneticFluxDensityUnit {
  const Milliteslas._() : super('millitesla', 'mT', MetricSystem.Milli);
}

/// Teslas (T) — the SI unit of magnetic flux density.
final class Teslas extends MagneticFluxDensityUnit {
  const Teslas._() : super('tesla', 'T', 1.0);
}

/// Gauss (G) — the CGS unit of magnetic flux density (1 G = 10⁻⁴ T).
final class Gauss extends MagneticFluxDensityUnit {
  const Gauss._() : super('gauss', 'G', 1e-4);
}

/// Extension methods for constructing [MagneticFluxDensity] values from [num].
extension MagneticFluxDensityOps on num {
  /// Creates a [MagneticFluxDensity] of this value in nanoteslas.
  MagneticFluxDensity get nanoteslas => MagneticFluxDensity.nanoteslas(this);

  /// Creates a [MagneticFluxDensity] of this value in microteslas.
  MagneticFluxDensity get microteslas => MagneticFluxDensity.microteslas(this);

  /// Creates a [MagneticFluxDensity] of this value in milliteslas.
  MagneticFluxDensity get milliteslas => MagneticFluxDensity.milliteslas(this);

  /// Creates a [MagneticFluxDensity] of this value in teslas.
  MagneticFluxDensity get teslas => MagneticFluxDensity.teslas(this);

  /// Creates a [MagneticFluxDensity] of this value in gauss.
  MagneticFluxDensity get gauss => MagneticFluxDensity.gauss(this);
}
