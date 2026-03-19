import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Density extends Quantity<Density> {
  Density(super.value, super.unit);

  Density operator +(Density that) => Density(value + that.to(unit), unit);
  Density operator -(Density that) => Density(value - that.to(unit), unit);

  Density get toKilogramsPerCubicMeter => to(kilogramsPerCubicMeter).kilogramsPerCubicMeter;
  Density get toGramsPerCubicCentimeter => to(gramsPerCubicCentimeter).gramsPerCubicCentimeter;
  Density get toKilogramsPerLiter => to(kilogramsPerLiter).kilogramsPerLiter;
  Density get toPoundsPerCubicFoot => to(poundsPerCubicFoot).poundsPerCubicFoot;
  Density get toPoundsPerCubicInch => to(poundsPerCubicInch).poundsPerCubicInch;
  Density get toKilogramsPerCubicFoot => to(kilogramsPerCubicFoot).kilogramsPerCubicFoot;

  static const DensityUnit kilogramsPerCubicMeter = KilogramsPerCubicMeter._();
  static const DensityUnit gramsPerCubicCentimeter = GramsPerCubicCentimeter._();
  static const DensityUnit kilogramsPerLiter = KilogramsPerLiter._();
  static const DensityUnit poundsPerCubicFoot = PoundsPerCubicFoot._();
  static const DensityUnit poundsPerCubicInch = PoundsPerCubicInch._();
  static const DensityUnit kilogramsPerCubicFoot = KilogramsPerCubicFoot._();

  static const units = {
    kilogramsPerCubicMeter,
    gramsPerCubicCentimeter,
    kilogramsPerLiter,
    poundsPerCubicFoot,
    poundsPerCubicInch,
    kilogramsPerCubicFoot,
  };

  static Option<Density> parse(String s) => Quantity.parse(s, units);
}

abstract class DensityUnit extends BaseUnit<Density> {
  const DensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Density call(num value) => Density(value.toDouble(), this);
}

final class KilogramsPerCubicMeter extends DensityUnit {
  const KilogramsPerCubicMeter._() : super('kilogram/cubic meter', 'kg/m³', 1.0);
}

final class GramsPerCubicCentimeter extends DensityUnit {
  const GramsPerCubicCentimeter._() : super('gram/cubic centimeter', 'g/cm³', 1000.0);
}

final class KilogramsPerLiter extends DensityUnit {
  const KilogramsPerLiter._() : super('kilogram/liter', 'kg/L', 1000.0);
}

final class PoundsPerCubicFoot extends DensityUnit {
  const PoundsPerCubicFoot._() : super('pound/cubic foot', 'lb/ft³', 16.01846337396014);
}

final class PoundsPerCubicInch extends DensityUnit {
  const PoundsPerCubicInch._() : super('pound/cubic inch', 'lb/in³', 27679.9047102031);
}

final class KilogramsPerCubicFoot extends DensityUnit {
  const KilogramsPerCubicFoot._() : super('kilogram/cubic foot', 'kg/ft³', 35.3146667214886);
}

extension DensityOps on num {
  Density get kilogramsPerCubicMeter => Density.kilogramsPerCubicMeter(this);
  Density get gramsPerCubicCentimeter => Density.gramsPerCubicCentimeter(this);
  Density get kilogramsPerLiter => Density.kilogramsPerLiter(this);
  Density get poundsPerCubicFoot => Density.poundsPerCubicFoot(this);
  Density get poundsPerCubicInch => Density.poundsPerCubicInch(this);
  Density get kilogramsPerCubicFoot => Density.kilogramsPerCubicFoot(this);
}
