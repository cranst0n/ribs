import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing radiant intensity — the radiant flux emitted per
/// unit solid angle in a given direction.
final class RadiantIntensity extends Quantity<RadiantIntensity> {
  RadiantIntensity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [RadiantIntensity].
  RadiantIntensity operator +(RadiantIntensity that) =>
      RadiantIntensity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [RadiantIntensity].
  RadiantIntensity operator -(RadiantIntensity that) =>
      RadiantIntensity(value - that.to(unit), unit);

  /// Converts this to milliwatts per steradian (mW/sr).
  RadiantIntensity get toMilliwattsPerSteradian =>
      to(milliwattsPerSteradian).milliwattsPerSteradian;

  /// Converts this to watts per steradian (W/sr).
  RadiantIntensity get toWattsPerSteradian => to(wattsPerSteradian).wattsPerSteradian;

  /// Unit for milliwatts per steradian (mW/sr).
  static const RadiantIntensityUnit milliwattsPerSteradian = MilliwattsPerSteradian._();

  /// Unit for watts per steradian (W/sr) — the SI unit of radiant intensity.
  static const RadiantIntensityUnit wattsPerSteradian = WattsPerSteradian._();

  /// All supported [RadiantIntensity] units.
  static const units = {
    milliwattsPerSteradian,
    wattsPerSteradian,
  };

  /// Parses [s] into a [RadiantIntensity], returning [None] if parsing fails.
  static Option<RadiantIntensity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [RadiantIntensity] units.
abstract class RadiantIntensityUnit extends BaseUnit<RadiantIntensity> {
  const RadiantIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  RadiantIntensity call(num value) => RadiantIntensity(value.toDouble(), this);
}

/// Milliwatts per steradian (mW/sr).
final class MilliwattsPerSteradian extends RadiantIntensityUnit {
  const MilliwattsPerSteradian._() : super('milliwatt/steradian', 'mW/sr', MetricSystem.Milli);
}

/// Watts per steradian (W/sr).
final class WattsPerSteradian extends RadiantIntensityUnit {
  const WattsPerSteradian._() : super('watt/steradian', 'W/sr', 1.0);
}

/// Extension methods for constructing [RadiantIntensity] values from [num].
extension RadiantIntensityOps on num {
  /// Creates a [RadiantIntensity] of this value in milliwatts per steradian.
  RadiantIntensity get milliwattsPerSteradian => RadiantIntensity.milliwattsPerSteradian(this);

  /// Creates a [RadiantIntensity] of this value in watts per steradian.
  RadiantIntensity get wattsPerSteradian => RadiantIntensity.wattsPerSteradian(this);
}
