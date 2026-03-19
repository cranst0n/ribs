import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ElectricCharge extends Quantity<ElectricCharge> {
  ElectricCharge(super.value, super.unit);

  ElectricCharge operator +(ElectricCharge that) => ElectricCharge(value + that.to(unit), unit);
  ElectricCharge operator -(ElectricCharge that) => ElectricCharge(value - that.to(unit), unit);

  ElectricCharge get toCoulombs => to(coulombs).coulombs;
  ElectricCharge get toAmpereHours => to(ampereHours).ampereHours;
  ElectricCharge get toMilliampereHours => to(milliampereHours).milliampereHours;

  static const ElectricChargeUnit coulombs = Coulombs._();
  static const ElectricChargeUnit ampereHours = AmpereHours._();
  static const ElectricChargeUnit milliampereHours = MilliampereHours._();

  static const units = {
    coulombs,
    ampereHours,
    milliampereHours,
  };

  static Option<ElectricCharge> parse(String s) => Quantity.parse(s, units);
}

abstract class ElectricChargeUnit extends BaseUnit<ElectricCharge> {
  const ElectricChargeUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricCharge call(num value) => ElectricCharge(value.toDouble(), this);
}

final class Coulombs extends ElectricChargeUnit {
  const Coulombs._() : super('coulomb', 'C', 1.0);
}

final class AmpereHours extends ElectricChargeUnit {
  const AmpereHours._() : super('ampere-hour', 'Ah', 3600.0);
}

final class MilliampereHours extends ElectricChargeUnit {
  const MilliampereHours._() : super('milliampere-hour', 'mAh', 3.6);
}

extension ElectricChargeOps on num {
  ElectricCharge get coulombs => ElectricCharge.coulombs(this);
  ElectricCharge get ampereHours => ElectricCharge.ampereHours(this);
  ElectricCharge get milliampereHours => ElectricCharge.milliampereHours(this);
}
