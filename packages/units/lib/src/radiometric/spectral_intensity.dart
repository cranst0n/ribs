import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing spectral intensity — radiant intensity per unit
/// wavelength interval.
final class SpectralIntensity extends Quantity<SpectralIntensity> {
  SpectralIntensity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [SpectralIntensity].
  SpectralIntensity operator +(SpectralIntensity that) =>
      SpectralIntensity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [SpectralIntensity].
  SpectralIntensity operator -(SpectralIntensity that) =>
      SpectralIntensity(value - that.to(unit), unit);

  /// Converts this to milliwatts per steradian per meter (mW/sr/m).
  SpectralIntensity get toMilliwattsPerSteradianPerMeter =>
      to(milliwattsPerSteradianPerMeter).milliwattsPerSteradianPerMeter;

  /// Converts this to watts per steradian per meter (W/sr/m).
  SpectralIntensity get toWattsPerSteradianPerMeter =>
      to(wattsPerSteradianPerMeter).wattsPerSteradianPerMeter;

  /// Unit for milliwatts per steradian per meter (mW/sr/m).
  static const SpectralIntensityUnit milliwattsPerSteradianPerMeter =
      MilliwattsPerSteradianPerMeter._();

  /// Unit for watts per steradian per meter (W/sr/m).
  static const SpectralIntensityUnit wattsPerSteradianPerMeter = WattsPerSteradianPerMeter._();

  /// All supported [SpectralIntensity] units.
  static const units = {
    milliwattsPerSteradianPerMeter,
    wattsPerSteradianPerMeter,
  };

  /// Parses [s] into a [SpectralIntensity], returning [None] if parsing fails.
  static Option<SpectralIntensity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [SpectralIntensity] units.
abstract class SpectralIntensityUnit extends BaseUnit<SpectralIntensity> {
  const SpectralIntensityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SpectralIntensity call(num value) => SpectralIntensity(value.toDouble(), this);
}

/// Milliwatts per steradian per meter (mW/sr/m).
final class MilliwattsPerSteradianPerMeter extends SpectralIntensityUnit {
  const MilliwattsPerSteradianPerMeter._()
    : super('milliwatt/steradian/meter', 'mW/sr/m', MetricSystem.Milli);
}

/// Watts per steradian per meter (W/sr/m).
final class WattsPerSteradianPerMeter extends SpectralIntensityUnit {
  const WattsPerSteradianPerMeter._() : super('watt/steradian/meter', 'W/sr/m', 1.0);
}

/// Extension methods for constructing [SpectralIntensity] values from [num].
extension SpectralIntensityOps on num {
  /// Creates a [SpectralIntensity] of this value in milliwatts per steradian per meter.
  SpectralIntensity get milliwattsPerSteradianPerMeter =>
      SpectralIntensity.milliwattsPerSteradianPerMeter(this);

  /// Creates a [SpectralIntensity] of this value in watts per steradian per meter.
  SpectralIntensity get wattsPerSteradianPerMeter =>
      SpectralIntensity.wattsPerSteradianPerMeter(this);
}
