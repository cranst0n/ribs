import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing spectral power — radiant flux per unit wavelength interval.
final class SpectralPower extends Quantity<SpectralPower> {
  SpectralPower(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [SpectralPower].
  SpectralPower operator +(SpectralPower that) => SpectralPower(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [SpectralPower].
  SpectralPower operator -(SpectralPower that) => SpectralPower(value - that.to(unit), unit);

  /// Converts this to milliwatts per meter (mW/m).
  SpectralPower get toMilliwattsPerMeter => to(milliwattsPerMeter).milliwattsPerMeter;

  /// Converts this to watts per meter (W/m).
  SpectralPower get toWattsPerMeter => to(wattsPerMeter).wattsPerMeter;

  /// Unit for milliwatts per meter (mW/m).
  static const SpectralPowerUnit milliwattsPerMeter = MilliwattsPerMeter._();

  /// Unit for watts per meter (W/m).
  static const SpectralPowerUnit wattsPerMeter = WattsPerMeter._();

  /// All supported [SpectralPower] units.
  static const units = {
    milliwattsPerMeter,
    wattsPerMeter,
  };

  /// Parses [s] into a [SpectralPower], returning [None] if parsing fails.
  static Option<SpectralPower> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [SpectralPower] units.
abstract class SpectralPowerUnit extends BaseUnit<SpectralPower> {
  const SpectralPowerUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  SpectralPower call(num value) => SpectralPower(value.toDouble(), this);
}

/// Milliwatts per meter (mW/m).
final class MilliwattsPerMeter extends SpectralPowerUnit {
  const MilliwattsPerMeter._() : super('milliwatt/meter', 'mW/m', MetricSystem.Milli);
}

/// Watts per meter (W/m).
final class WattsPerMeter extends SpectralPowerUnit {
  const WattsPerMeter._() : super('watt/meter', 'W/m', 1.0);
}

/// Extension methods for constructing [SpectralPower] values from [num].
extension SpectralPowerOps on num {
  /// Creates a [SpectralPower] of this value in milliwatts per meter.
  SpectralPower get milliwattsPerMeter => SpectralPower.milliwattsPerMeter(this);

  /// Creates a [SpectralPower] of this value in watts per meter.
  SpectralPower get wattsPerMeter => SpectralPower.wattsPerMeter(this);
}
