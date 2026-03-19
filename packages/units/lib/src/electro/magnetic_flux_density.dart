import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class MagneticFluxDensity extends Quantity<MagneticFluxDensity> {
  MagneticFluxDensity(super.value, super.unit);

  MagneticFluxDensity operator +(MagneticFluxDensity that) =>
      MagneticFluxDensity(value + that.to(unit), unit);
  MagneticFluxDensity operator -(MagneticFluxDensity that) =>
      MagneticFluxDensity(value - that.to(unit), unit);

  MagneticFluxDensity get toNanoteslas => to(nanoteslas).nanoteslas;
  MagneticFluxDensity get toMicroteslas => to(microteslas).microteslas;
  MagneticFluxDensity get toMilliteslas => to(milliteslas).milliteslas;
  MagneticFluxDensity get toTeslas => to(teslas).teslas;
  MagneticFluxDensity get toGauss => to(gauss).gauss;

  static const MagneticFluxDensityUnit nanoteslas = Nanoteslas._();
  static const MagneticFluxDensityUnit microteslas = Microteslas._();
  static const MagneticFluxDensityUnit milliteslas = Milliteslas._();
  static const MagneticFluxDensityUnit teslas = Teslas._();
  static const MagneticFluxDensityUnit gauss = Gauss._();

  static const units = {
    nanoteslas,
    microteslas,
    milliteslas,
    teslas,
    gauss,
  };

  static Option<MagneticFluxDensity> parse(String s) => Quantity.parse(s, units);
}

abstract class MagneticFluxDensityUnit extends BaseUnit<MagneticFluxDensity> {
  const MagneticFluxDensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MagneticFluxDensity call(num value) => MagneticFluxDensity(value.toDouble(), this);
}

final class Nanoteslas extends MagneticFluxDensityUnit {
  const Nanoteslas._() : super('nanotesla', 'nT', MetricSystem.Nano);
}

final class Microteslas extends MagneticFluxDensityUnit {
  const Microteslas._() : super('microtesla', 'µT', MetricSystem.Micro);
}

final class Milliteslas extends MagneticFluxDensityUnit {
  const Milliteslas._() : super('millitesla', 'mT', MetricSystem.Milli);
}

final class Teslas extends MagneticFluxDensityUnit {
  const Teslas._() : super('tesla', 'T', 1.0);
}

final class Gauss extends MagneticFluxDensityUnit {
  const Gauss._() : super('gauss', 'G', 1e-4);
}

extension MagneticFluxDensityOps on num {
  MagneticFluxDensity get nanoteslas => MagneticFluxDensity.nanoteslas(this);
  MagneticFluxDensity get microteslas => MagneticFluxDensity.microteslas(this);
  MagneticFluxDensity get milliteslas => MagneticFluxDensity.milliteslas(this);
  MagneticFluxDensity get teslas => MagneticFluxDensity.teslas(this);
  MagneticFluxDensity get gauss => MagneticFluxDensity.gauss(this);
}
