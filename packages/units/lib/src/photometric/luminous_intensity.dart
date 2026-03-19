import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class LuminousIntensity extends Quantity<LuminousIntensity> {
  LuminousIntensity(super.value, super.unit);

  LuminousIntensity operator +(LuminousIntensity that) =>
      LuminousIntensity(value + that.to(unit), unit);
  LuminousIntensity operator -(LuminousIntensity that) =>
      LuminousIntensity(value - that.to(unit), unit);

  LuminousIntensity get toMicrocandelas => to(microcandelas).microcandelas;
  LuminousIntensity get toMillicandelas => to(millicandelas).millicandelas;
  LuminousIntensity get toCandelas => to(candelas).candelas;

  static const LuminousIntensityUnit microcandelas = Microcandelas._();
  static const LuminousIntensityUnit millicandelas = Millicandelas._();
  static const LuminousIntensityUnit candelas = Candelas._();

  static const units = {
    microcandelas,
    millicandelas,
    candelas,
  };

  static Option<LuminousIntensity> parse(String s) => Quantity.parse(s, units);
}

abstract class LuminousIntensityUnit extends BaseUnit<LuminousIntensity> {
  const LuminousIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  LuminousIntensity call(num value) => LuminousIntensity(value.toDouble(), this);
}

final class Microcandelas extends LuminousIntensityUnit {
  const Microcandelas._() : super('microcandela', 'µcd', MetricSystem.Micro);
}

final class Millicandelas extends LuminousIntensityUnit {
  const Millicandelas._() : super('millicandela', 'mcd', MetricSystem.Milli);
}

final class Candelas extends LuminousIntensityUnit {
  const Candelas._() : super('candela', 'cd', 1.0);
}

extension LuminousIntensityOps on num {
  LuminousIntensity get microcandelas => LuminousIntensity.microcandelas(this);
  LuminousIntensity get millicandelas => LuminousIntensity.millicandelas(this);
  LuminousIntensity get candelas => LuminousIntensity.candelas(this);
}
