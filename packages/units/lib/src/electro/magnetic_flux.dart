import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class MagneticFlux extends Quantity<MagneticFlux> {
  MagneticFlux(super.value, super.unit);

  MagneticFlux operator +(MagneticFlux that) => MagneticFlux(value + that.to(unit), unit);
  MagneticFlux operator -(MagneticFlux that) => MagneticFlux(value - that.to(unit), unit);

  MagneticFlux get toMicrowebers => to(microwebers).microwebers;
  MagneticFlux get toMilliwebers => to(milliwebers).milliwebers;
  MagneticFlux get toWebers => to(webers).webers;

  static const MagneticFluxUnit microwebers = Microwebers._();
  static const MagneticFluxUnit milliwebers = Milliwebers._();
  static const MagneticFluxUnit webers = Webers._();

  static const units = {
    microwebers,
    milliwebers,
    webers,
  };

  static Option<MagneticFlux> parse(String s) => Quantity.parse(s, units);
}

abstract class MagneticFluxUnit extends BaseUnit<MagneticFlux> {
  const MagneticFluxUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MagneticFlux call(num value) => MagneticFlux(value.toDouble(), this);
}

final class Microwebers extends MagneticFluxUnit {
  const Microwebers._() : super('microweber', 'µWb', MetricSystem.Micro);
}

final class Milliwebers extends MagneticFluxUnit {
  const Milliwebers._() : super('milliweber', 'mWb', MetricSystem.Milli);
}

final class Webers extends MagneticFluxUnit {
  const Webers._() : super('weber', 'Wb', 1.0);
}

extension MagneticFluxOps on num {
  MagneticFlux get microwebers => MagneticFlux.microwebers(this);
  MagneticFlux get milliwebers => MagneticFlux.milliwebers(this);
  MagneticFlux get webers => MagneticFlux.webers(this);
}
