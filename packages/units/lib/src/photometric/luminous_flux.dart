import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class LuminousFlux extends Quantity<LuminousFlux> {
  LuminousFlux(super.value, super.unit);

  LuminousFlux operator +(LuminousFlux that) => LuminousFlux(value + that.to(unit), unit);
  LuminousFlux operator -(LuminousFlux that) => LuminousFlux(value - that.to(unit), unit);

  LuminousFlux get toMicrolumens => to(microlumens).microlumens;
  LuminousFlux get toMillilumens => to(millilumens).millilumens;
  LuminousFlux get toLumens => to(lumens).lumens;

  static const LuminousFluxUnit microlumens = Microlumens._();
  static const LuminousFluxUnit millilumens = Millilumens._();
  static const LuminousFluxUnit lumens = Lumens._();

  static const units = {
    microlumens,
    millilumens,
    lumens,
  };

  static Option<LuminousFlux> parse(String s) => Quantity.parse(s, units);
}

abstract class LuminousFluxUnit extends BaseUnit<LuminousFlux> {
  const LuminousFluxUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  LuminousFlux call(num value) => LuminousFlux(value.toDouble(), this);
}

final class Microlumens extends LuminousFluxUnit {
  const Microlumens._() : super('microlumen', 'µlm', MetricSystem.Micro);
}

final class Millilumens extends LuminousFluxUnit {
  const Millilumens._() : super('millilumen', 'mlm', MetricSystem.Milli);
}

final class Lumens extends LuminousFluxUnit {
  const Lumens._() : super('lumen', 'lm', 1.0);
}

extension LuminousFluxOps on num {
  LuminousFlux get microlumens => LuminousFlux.microlumens(this);
  LuminousFlux get millilumens => LuminousFlux.millilumens(this);
  LuminousFlux get lumens => LuminousFlux.lumens(this);
}
