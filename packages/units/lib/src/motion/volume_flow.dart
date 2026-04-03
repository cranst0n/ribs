import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing volumetric flow rate (volume per unit time).
final class VolumeFlow extends Quantity<VolumeFlow> {
  VolumeFlow(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [VolumeFlow].
  VolumeFlow operator +(VolumeFlow that) => VolumeFlow(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [VolumeFlow].
  VolumeFlow operator -(VolumeFlow that) => VolumeFlow(value - that.to(unit), unit);

  /// Converts this to cubic meters per second (m³/s).
  VolumeFlow get toCubicMetersPerSecond => to(cubicMetersPerSecond).cubicMetersPerSecond;

  /// Converts this to cubic feet per second (ft³/s).
  VolumeFlow get toCubicFeetPerSecond => to(cubicFeetPerSecond).cubicFeetPerSecond;

  /// Converts this to cubic feet per minute (ft³/min).
  VolumeFlow get toCubicFeetPerMinute => to(cubicFeetPerMinute).cubicFeetPerMinute;

  /// Converts this to gallons per minute (gal/min).
  VolumeFlow get toGallonsPerMinute => to(gallonsPerMinute).gallonsPerMinute;

  /// Converts this to liters per second (L/s).
  VolumeFlow get toLitersPerSecond => to(litersPerSecond).litersPerSecond;

  /// Converts this to liters per minute (L/min).
  VolumeFlow get toLitersPerMinute => to(litersPerMinute).litersPerMinute;

  /// Converts this to liters per hour (L/h).
  VolumeFlow get toLitersPerHour => to(litersPerHour).litersPerHour;

  /// Converts this to nanoliters per second (nL/s).
  VolumeFlow get toNanolitersPerSecond => to(nanolitersPerSecond).nanolitersPerSecond;

  /// Converts this to microliters per second (µL/s).
  VolumeFlow get toMicrolitersPerSecond => to(microlitersPerSecond).microlitersPerSecond;

  /// Converts this to milliliters per second (mL/s).
  VolumeFlow get toMillilitersPerSecond => to(millilitersPerSecond).millilitersPerSecond;

  /// Converts this to milliliters per minute (mL/min).
  VolumeFlow get toMillilitersPerMinute => to(millilitersPerMinute).millilitersPerMinute;

  /// Converts this to milliliters per hour (mL/h).
  VolumeFlow get toMillilitersPerHour => to(millilitersPerHour).millilitersPerHour;

  /// Unit for cubic meters per second (m³/s) — the SI unit of volumetric flow.
  static const VolumeFlowUnit cubicMetersPerSecond = CubicMetersPerSecond._();

  /// Unit for cubic feet per second (ft³/s).
  static const VolumeFlowUnit cubicFeetPerSecond = CubicFeetPerSecond._();

  /// Unit for cubic feet per minute (ft³/min).
  static const VolumeFlowUnit cubicFeetPerMinute = CubicFeetPerMinute._();

  /// Unit for US gallons per minute (gal/min).
  static const VolumeFlowUnit gallonsPerMinute = GallonsPerMinute._();

  /// Unit for liters per second (L/s).
  static const VolumeFlowUnit litersPerSecond = LitersPerSecond._();

  /// Unit for liters per minute (L/min).
  static const VolumeFlowUnit litersPerMinute = LitersPerMinute._();

  /// Unit for liters per hour (L/h).
  static const VolumeFlowUnit litersPerHour = LitersPerHour._();

  /// Unit for nanoliters per second (nL/s).
  static const VolumeFlowUnit nanolitersPerSecond = NanolitersPerSecond._();

  /// Unit for microliters per second (µL/s).
  static const VolumeFlowUnit microlitersPerSecond = MicrolitersPerSecond._();

  /// Unit for milliliters per second (mL/s).
  static const VolumeFlowUnit millilitersPerSecond = MillilitersPerSecond._();

  /// Unit for milliliters per minute (mL/min).
  static const VolumeFlowUnit millilitersPerMinute = MillilitersPerMinute._();

  /// Unit for milliliters per hour (mL/h).
  static const VolumeFlowUnit millilitersPerHour = MillilitersPerHour._();

  /// All supported [VolumeFlow] units.
  static const units = {
    cubicMetersPerSecond,
    cubicFeetPerSecond,
    cubicFeetPerMinute,
    gallonsPerMinute,
    litersPerSecond,
    litersPerMinute,
    litersPerHour,
    nanolitersPerSecond,
    microlitersPerSecond,
    millilitersPerSecond,
    millilitersPerMinute,
    millilitersPerHour,
  };

  /// Parses [s] into a [VolumeFlow], returning [None] if parsing fails.
  static Option<VolumeFlow> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [VolumeFlow] units.
abstract class VolumeFlowUnit extends BaseUnit<VolumeFlow> {
  const VolumeFlowUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  VolumeFlow call(num value) => VolumeFlow(value.toDouble(), this);
}

/// Cubic meters per second (m³/s).
final class CubicMetersPerSecond extends VolumeFlowUnit {
  const CubicMetersPerSecond._() : super('cubic meter/second', 'm³/s', 1.0);
}

/// Cubic feet per second (ft³/s).
final class CubicFeetPerSecond extends VolumeFlowUnit {
  const CubicFeetPerSecond._() : super('cubic feet/second', 'ft³/s', 0.028317016);
}

/// Cubic feet per minute (ft³/min).
final class CubicFeetPerMinute extends VolumeFlowUnit {
  const CubicFeetPerMinute._() : super('cubic feet/minute', 'ft³/min', 0.028317016 / 60.0);
}

/// US gallons per minute (gal/min).
final class GallonsPerMinute extends VolumeFlowUnit {
  const GallonsPerMinute._() : super('gallon/minute', 'gal/min', 6.30901964e-5);
}

/// Liters per second (L/s).
final class LitersPerSecond extends VolumeFlowUnit {
  const LitersPerSecond._() : super('liter/second', 'L/s', 1e-3);
}

/// Liters per minute (L/min).
final class LitersPerMinute extends VolumeFlowUnit {
  const LitersPerMinute._() : super('liter/minute', 'L/min', 1e-3 / 60.0);
}

/// Liters per hour (L/h).
final class LitersPerHour extends VolumeFlowUnit {
  const LitersPerHour._() : super('liter/hour', 'L/h', 1e-3 / 3600.0);
}

/// Nanoliters per second (nL/s).
final class NanolitersPerSecond extends VolumeFlowUnit {
  const NanolitersPerSecond._() : super('nanoliter/second', 'nL/s', 1e-12);
}

/// Microliters per second (µL/s).
final class MicrolitersPerSecond extends VolumeFlowUnit {
  const MicrolitersPerSecond._() : super('microliter/second', 'µL/s', 1e-9);
}

/// Milliliters per second (mL/s).
final class MillilitersPerSecond extends VolumeFlowUnit {
  const MillilitersPerSecond._() : super('milliliter/second', 'mL/s', 1e-6);
}

/// Milliliters per minute (mL/min).
final class MillilitersPerMinute extends VolumeFlowUnit {
  const MillilitersPerMinute._() : super('milliliter/minute', 'mL/min', 1e-6 / 60.0);
}

/// Milliliters per hour (mL/h).
final class MillilitersPerHour extends VolumeFlowUnit {
  const MillilitersPerHour._() : super('milliliter/hour', 'mL/h', 1e-6 / 3600.0);
}

/// Extension methods for constructing [VolumeFlow] values from [num].
extension VolumeFlowOps on num {
  /// Creates a [VolumeFlow] of this value in cubic meters per second.
  VolumeFlow get cubicMetersPerSecond => VolumeFlow.cubicMetersPerSecond(this);

  /// Creates a [VolumeFlow] of this value in cubic feet per second.
  VolumeFlow get cubicFeetPerSecond => VolumeFlow.cubicFeetPerSecond(this);

  /// Creates a [VolumeFlow] of this value in cubic feet per minute.
  VolumeFlow get cubicFeetPerMinute => VolumeFlow.cubicFeetPerMinute(this);

  /// Creates a [VolumeFlow] of this value in US gallons per minute.
  VolumeFlow get gallonsPerMinute => VolumeFlow.gallonsPerMinute(this);

  /// Creates a [VolumeFlow] of this value in liters per second.
  VolumeFlow get litersPerSecond => VolumeFlow.litersPerSecond(this);

  /// Creates a [VolumeFlow] of this value in liters per minute.
  VolumeFlow get litersPerMinute => VolumeFlow.litersPerMinute(this);

  /// Creates a [VolumeFlow] of this value in liters per hour.
  VolumeFlow get litersPerHour => VolumeFlow.litersPerHour(this);

  /// Creates a [VolumeFlow] of this value in nanoliters per second.
  VolumeFlow get nanolitersPerSecond => VolumeFlow.nanolitersPerSecond(this);

  /// Creates a [VolumeFlow] of this value in microliters per second.
  VolumeFlow get microlitersPerSecond => VolumeFlow.microlitersPerSecond(this);

  /// Creates a [VolumeFlow] of this value in milliliters per second.
  VolumeFlow get millilitersPerSecond => VolumeFlow.millilitersPerSecond(this);

  /// Creates a [VolumeFlow] of this value in milliliters per minute.
  VolumeFlow get millilitersPerMinute => VolumeFlow.millilitersPerMinute(this);

  /// Creates a [VolumeFlow] of this value in milliliters per hour.
  VolumeFlow get millilitersPerHour => VolumeFlow.millilitersPerHour(this);
}
