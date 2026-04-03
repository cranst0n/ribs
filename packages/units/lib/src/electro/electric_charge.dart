import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing electric charge.
final class ElectricCharge extends Quantity<ElectricCharge> {
  ElectricCharge(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ElectricCharge].
  ElectricCharge operator +(ElectricCharge that) => ElectricCharge(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ElectricCharge].
  ElectricCharge operator -(ElectricCharge that) => ElectricCharge(value - that.to(unit), unit);

  /// Converts this to coulombs (C).
  ElectricCharge get toCoulombs => to(coulombs).coulombs;

  /// Converts this to ampere-hours (Ah).
  ElectricCharge get toAmpereHours => to(ampereHours).ampereHours;

  /// Converts this to milliampere-hours (mAh).
  ElectricCharge get toMilliampereHours => to(milliampereHours).milliampereHours;

  /// Unit for coulombs (C) — the SI unit of electric charge.
  static const ElectricChargeUnit coulombs = Coulombs._();

  /// Unit for ampere-hours (Ah) — commonly used for battery capacity.
  static const ElectricChargeUnit ampereHours = AmpereHours._();

  /// Unit for milliampere-hours (mAh) — commonly used for small battery capacity.
  static const ElectricChargeUnit milliampereHours = MilliampereHours._();

  /// All supported [ElectricCharge] units.
  static const units = {
    coulombs,
    ampereHours,
    milliampereHours,
  };

  /// Parses [s] into an [ElectricCharge], returning [None] if parsing fails.
  static Option<ElectricCharge> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ElectricCharge] units.
abstract class ElectricChargeUnit extends BaseUnit<ElectricCharge> {
  const ElectricChargeUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ElectricCharge call(num value) => ElectricCharge(value.toDouble(), this);
}

/// Coulombs (C) — the SI unit of electric charge.
final class Coulombs extends ElectricChargeUnit {
  const Coulombs._() : super('coulomb', 'C', 1.0);
}

/// Ampere-hours (Ah) — 3 600 coulombs; used for battery capacity.
final class AmpereHours extends ElectricChargeUnit {
  const AmpereHours._() : super('ampere-hour', 'Ah', 3600.0);
}

/// Milliampere-hours (mAh) — 3.6 coulombs; used for small battery capacity.
final class MilliampereHours extends ElectricChargeUnit {
  const MilliampereHours._() : super('milliampere-hour', 'mAh', 3.6);
}

/// Extension methods for constructing [ElectricCharge] values from [num].
extension ElectricChargeOps on num {
  /// Creates an [ElectricCharge] of this value in coulombs.
  ElectricCharge get coulombs => ElectricCharge.coulombs(this);

  /// Creates an [ElectricCharge] of this value in ampere-hours.
  ElectricCharge get ampereHours => ElectricCharge.ampereHours(this);

  /// Creates an [ElectricCharge] of this value in milliampere-hours.
  ElectricCharge get milliampereHours => ElectricCharge.milliampereHours(this);
}
