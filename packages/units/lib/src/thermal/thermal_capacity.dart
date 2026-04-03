import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing thermal capacity (heat capacity), i.e. the amount
/// of energy required to raise a system's temperature by one degree.
final class ThermalCapacity extends Quantity<ThermalCapacity> {
  ThermalCapacity(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [ThermalCapacity].
  ThermalCapacity operator +(ThermalCapacity that) => ThermalCapacity(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [ThermalCapacity].
  ThermalCapacity operator -(ThermalCapacity that) => ThermalCapacity(value - that.to(unit), unit);

  /// Converts this to joules per kelvin (J/K).
  ThermalCapacity get toJoulesPerKelvin => to(joulesPerKelvin).joulesPerKelvin;

  /// Converts this to BTU per degree Fahrenheit (BTU/°F).
  ThermalCapacity get toBtuPerFahrenheit => to(btuPerFahrenheit).btuPerFahrenheit;

  /// Unit for joules per kelvin (J/K).
  static const ThermalCapacityUnit joulesPerKelvin = JoulesPerKelvin._();

  /// Unit for BTU per degree Fahrenheit (BTU/°F).
  static const ThermalCapacityUnit btuPerFahrenheit = BtuPerFahrenheit._();

  /// All supported [ThermalCapacity] units.
  static const units = {
    joulesPerKelvin,
    btuPerFahrenheit,
  };

  /// Parses [s] into a [ThermalCapacity], returning [None] if parsing fails.
  static Option<ThermalCapacity> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [ThermalCapacity] units.
abstract class ThermalCapacityUnit extends BaseUnit<ThermalCapacity> {
  const ThermalCapacityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ThermalCapacity call(num value) => ThermalCapacity(value.toDouble(), this);
}

/// Joules per kelvin (J/K) — the SI unit of thermal capacity.
final class JoulesPerKelvin extends ThermalCapacityUnit {
  const JoulesPerKelvin._() : super('joule/kelvin', 'J/K', 1.0);
}

/// British Thermal Units per degree Fahrenheit (BTU/°F).
final class BtuPerFahrenheit extends ThermalCapacityUnit {
  const BtuPerFahrenheit._() : super('BTU/fahrenheit', 'BTU/°F', 1899.100534716);
}

/// Extension methods for constructing [ThermalCapacity] values from [num].
extension ThermalCapacityOps on num {
  /// Creates a [ThermalCapacity] of this value in joules per kelvin.
  ThermalCapacity get joulesPerKelvin => ThermalCapacity.joulesPerKelvin(this);

  /// Creates a [ThermalCapacity] of this value in BTU per degree Fahrenheit.
  ThermalCapacity get btuPerFahrenheit => ThermalCapacity.btuPerFahrenheit(this);
}
