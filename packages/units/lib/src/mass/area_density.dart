import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class AreaDensity extends Quantity<AreaDensity> {
  AreaDensity(super.value, super.unit);

  AreaDensity operator +(AreaDensity that) => AreaDensity(value + that.to(unit), unit);
  AreaDensity operator -(AreaDensity that) => AreaDensity(value - that.to(unit), unit);

  AreaDensity get toKilogramsPerSquareMeter => to(kilogramsPerSquareMeter).kilogramsPerSquareMeter;
  AreaDensity get toGramsPerSquareCentimeter =>
      to(gramsPerSquareCentimeter).gramsPerSquareCentimeter;
  AreaDensity get toPoundsPerSquareFoot => to(poundsPerSquareFoot).poundsPerSquareFoot;

  static const AreaDensityUnit kilogramsPerSquareMeter = KilogramsPerSquareMeter._();
  static const AreaDensityUnit gramsPerSquareCentimeter = GramsPerSquareCentimeter._();
  static const AreaDensityUnit poundsPerSquareFoot = PoundsPerSquareFoot._();

  static const units = {
    kilogramsPerSquareMeter,
    gramsPerSquareCentimeter,
    poundsPerSquareFoot,
  };

  static Option<AreaDensity> parse(String s) => Quantity.parse(s, units);
}

abstract class AreaDensityUnit extends BaseUnit<AreaDensity> {
  const AreaDensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  AreaDensity call(num value) => AreaDensity(value.toDouble(), this);
}

final class KilogramsPerSquareMeter extends AreaDensityUnit {
  const KilogramsPerSquareMeter._() : super('kilogram/square meter', 'kg/m²', 1.0);
}

final class GramsPerSquareCentimeter extends AreaDensityUnit {
  const GramsPerSquareCentimeter._() : super('gram/square centimeter', 'g/cm²', 10.0);
}

final class PoundsPerSquareFoot extends AreaDensityUnit {
  const PoundsPerSquareFoot._() : super('pound/square foot', 'lb/ft²', 4.88242763638);
}

extension AreaDensityOps on num {
  AreaDensity get kilogramsPerSquareMeter => AreaDensity.kilogramsPerSquareMeter(this);
  AreaDensity get gramsPerSquareCentimeter => AreaDensity.gramsPerSquareCentimeter(this);
  AreaDensity get poundsPerSquareFoot => AreaDensity.poundsPerSquareFoot(this);
}
