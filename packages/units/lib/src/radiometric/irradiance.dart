import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Irradiance extends Quantity<Irradiance> {
  Irradiance(super.value, super.unit);

  Irradiance operator +(Irradiance that) => Irradiance(value + that.to(unit), unit);
  Irradiance operator -(Irradiance that) => Irradiance(value - that.to(unit), unit);

  Irradiance get toMilliwattsPerSquareMeter =>
      to(milliwattsPerSquareMeter).milliwattsPerSquareMeter;
  Irradiance get toWattsPerSquareMeter => to(wattsPerSquareMeter).wattsPerSquareMeter;
  Irradiance get toErgsPerSecondPerSquareCentimeter =>
      to(ergsPerSecondPerSquareCentimeter).ergsPerSecondPerSquareCentimeter;

  static const IrradianceUnit milliwattsPerSquareMeter = MilliwattsPerSquareMeter._();
  static const IrradianceUnit wattsPerSquareMeter = WattsPerSquareMeter._();
  static const IrradianceUnit ergsPerSecondPerSquareCentimeter =
      ErgsPerSecondPerSquareCentimeter._();

  static const units = {
    milliwattsPerSquareMeter,
    wattsPerSquareMeter,
    ergsPerSecondPerSquareCentimeter,
  };

  static Option<Irradiance> parse(String s) => Quantity.parse(s, units);
}

abstract class IrradianceUnit extends BaseUnit<Irradiance> {
  const IrradianceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Irradiance call(num value) => Irradiance(value.toDouble(), this);
}

final class MilliwattsPerSquareMeter extends IrradianceUnit {
  const MilliwattsPerSquareMeter._() : super('milliwatt/square meter', 'mW/m²', MetricSystem.Milli);
}

final class WattsPerSquareMeter extends IrradianceUnit {
  const WattsPerSquareMeter._() : super('watt/square meter', 'W/m²', 1.0);
}

final class ErgsPerSecondPerSquareCentimeter extends IrradianceUnit {
  const ErgsPerSecondPerSquareCentimeter._()
    : super('erg/second/square centimeter', 'erg/s/cm²', 1e-3);
}

extension IrradianceOps on num {
  Irradiance get milliwattsPerSquareMeter => Irradiance.milliwattsPerSquareMeter(this);
  Irradiance get wattsPerSquareMeter => Irradiance.wattsPerSquareMeter(this);
  Irradiance get ergsPerSecondPerSquareCentimeter =>
      Irradiance.ergsPerSecondPerSquareCentimeter(this);
}
