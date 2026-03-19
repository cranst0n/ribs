import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class ThermalCapacity extends Quantity<ThermalCapacity> {
  ThermalCapacity(super.value, super.unit);

  ThermalCapacity operator +(ThermalCapacity that) => ThermalCapacity(value + that.to(unit), unit);
  ThermalCapacity operator -(ThermalCapacity that) => ThermalCapacity(value - that.to(unit), unit);

  ThermalCapacity get toJoulesPerKelvin => to(joulesPerKelvin).joulesPerKelvin;
  ThermalCapacity get toBtuPerFahrenheit => to(btuPerFahrenheit).btuPerFahrenheit;

  static const ThermalCapacityUnit joulesPerKelvin = JoulesPerKelvin._();
  static const ThermalCapacityUnit btuPerFahrenheit = BtuPerFahrenheit._();

  static const units = {
    joulesPerKelvin,
    btuPerFahrenheit,
  };

  static Option<ThermalCapacity> parse(String s) => Quantity.parse(s, units);
}

abstract class ThermalCapacityUnit extends BaseUnit<ThermalCapacity> {
  const ThermalCapacityUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  ThermalCapacity call(num value) => ThermalCapacity(value.toDouble(), this);
}

final class JoulesPerKelvin extends ThermalCapacityUnit {
  const JoulesPerKelvin._() : super('joule/kelvin', 'J/K', 1.0);
}

final class BtuPerFahrenheit extends ThermalCapacityUnit {
  const BtuPerFahrenheit._() : super('BTU/fahrenheit', 'BTU/°F', 1899.100534716);
}

extension ThermalCapacityOps on num {
  ThermalCapacity get joulesPerKelvin => ThermalCapacity.joulesPerKelvin(this);
  ThermalCapacity get btuPerFahrenheit => ThermalCapacity.btuPerFahrenheit(this);
}
