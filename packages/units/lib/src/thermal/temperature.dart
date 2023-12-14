import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Temperature extends Quantity<Temperature> {
  Temperature(super.value, super.unit);

  Temperature operator +(Temperature that) =>
      Temperature(value + that._convert(unit, withOffset: false).value, unit);
  Temperature operator -(Temperature that) =>
      Temperature(value - that._convert(unit, withOffset: false).value, unit);

  @override
  double to(UnitOfMeasure<Temperature> uom) => _convert(uom).value;

  Temperature get toFahrenheit => _convert(fahrenheit);
  Temperature get toCelsius => _convert(celcius);
  Temperature get toKelvin => _convert(kelvin);
  Temperature get toRankine => _convert(rankine);

  Temperature get toFahrenheitDegrees =>
      _convert(fahrenheit, withOffset: false);
  Temperature get toCelsiusDegrees => _convert(celcius, withOffset: false);
  Temperature get toKelvinDegrees => _convert(kelvin, withOffset: false);
  Temperature get toRankineDegrees => _convert(rankine, withOffset: false);

  @override
  String toString() => unit is Kelvin
      ? super.toString()
      : '${value.toStringAsFixed(1)}${unit.symbol}';

  static const celcius = Celcius._();
  static const fahrenheit = Fahrenheit._();
  static const kelvin = Kelvin._();
  static const rankine = Rankine._();

  static const units = {
    celcius,
    fahrenheit,
    kelvin,
    rankine,
  };

  static Option<Temperature> parse(String s) => Quantity.parse(s, units);

  Temperature _convert(
    UnitOfMeasure<Temperature> toScale, {
    bool withOffset = true,
  }) {
    if (toScale == unit) {
      return this;
    } else if (withOffset) {
      if (unit is Fahrenheit && toScale is Celcius) {
        return TemperatureConversions.fahrenheitToCelsiusScale(value).celcius;
      } else if (unit is Celcius && toScale is Fahrenheit) {
        return TemperatureConversions.celsiusToFahrenheitScale(value)
            .fahrenheit;
      } else if (unit is Celcius && toScale is Kelvin) {
        return TemperatureConversions.celsiusToKelvinScale(value).kelvin;
      } else if (unit is Kelvin && toScale is Celcius) {
        return TemperatureConversions.kelvinToCelsiusScale(value).celcius;
      } else if (unit is Fahrenheit && toScale is Kelvin) {
        return TemperatureConversions.fahrenheitToKelvinScale(value).kelvin;
      } else if (unit is Kelvin && toScale is Fahrenheit) {
        return TemperatureConversions.kelvinToFahrenheitScale(value).fahrenheit;
      } else if (unit is Fahrenheit && toScale is Rankine) {
        return TemperatureConversions.fahrenheitToRankineScale(value).rankine;
      } else if (unit is Rankine && toScale is Fahrenheit) {
        return TemperatureConversions.rankineToFahrenheitScale(value)
            .fahrenheit;
      } else if (unit is Celcius && toScale is Rankine) {
        return TemperatureConversions.celsiusToRankineScale(value).rankine;
      } else if (unit is Rankine && toScale is Celcius) {
        return TemperatureConversions.rankineToCelsiusScale(value).celcius;
      } else if (unit is Kelvin && toScale is Rankine) {
        return TemperatureConversions.kelvinToRankineScale(value).rankine;
      } else if (unit is Rankine && toScale is Kelvin) {
        return TemperatureConversions.rankineToKelvinScale(value).kelvin;
      }
    } else {
      if (unit is Fahrenheit && toScale is Celcius) {
        return TemperatureConversions.fahrenheitToCelsiusDegrees(value).celcius;
      } else if (unit is Celcius && toScale is Fahrenheit) {
        return TemperatureConversions.celsiusToFahrenheitDegrees(value)
            .fahrenheit;
      } else if (unit is Celcius && toScale is Kelvin) {
        return TemperatureConversions.celsiusToKelvinDegrees(value).kelvin;
      } else if (unit is Kelvin && toScale is Celcius) {
        return TemperatureConversions.kelvinToCelsiusDegrees(value).celcius;
      } else if (unit is Fahrenheit && toScale is Kelvin) {
        return TemperatureConversions.fahrenheitToKelvinDegrees(value).kelvin;
      } else if (unit is Kelvin && toScale is Fahrenheit) {
        return TemperatureConversions.kelvinToFahrenheitDegrees(value)
            .fahrenheit;
      } else if (unit is Fahrenheit && toScale is Rankine) {
        return TemperatureConversions.fahrenheitToRankineDegrees(value).rankine;
      } else if (unit is Rankine && toScale is Fahrenheit) {
        return TemperatureConversions.rankineToFahrenheitDegrees(value)
            .fahrenheit;
      } else if (unit is Celcius && toScale is Rankine) {
        return TemperatureConversions.celsiusToRankineDegrees(value).rankine;
      } else if (unit is Rankine && toScale is Celcius) {
        return TemperatureConversions.rankineToCelsiusDegrees(value).celcius;
      } else if (unit is Kelvin && toScale is Rankine) {
        return TemperatureConversions.kelvinToRankineDegrees(value).rankine;
      } else if (unit is Rankine && toScale is Kelvin) {
        return TemperatureConversions.rankineToKelvinDegrees(value).kelvin;
      }
    }

    throw StateError('Illegal temperature state: ([$unit] -> [$toScale])');
  }
}

abstract class TemperatureScale extends UnitOfMeasure<Temperature> {
  @override
  final String symbol;

  const TemperatureScale(this.symbol);

  @override
  Temperature call(num value) => Temperature(value.toDouble(), this);
}

final class Celcius extends TemperatureScale {
  const Celcius._() : super('°C');

  @override
  double converterFrom(double value) =>
      TemperatureConversions.celsiusToKelvinScale(value);

  @override
  double converterTo(double value) =>
      TemperatureConversions.kelvinToCelsiusScale(value);
}

final class Fahrenheit extends TemperatureScale {
  const Fahrenheit._() : super('°F');

  @override
  double converterFrom(double value) =>
      TemperatureConversions.fahrenheitToKelvinScale(value);

  @override
  double converterTo(double value) =>
      TemperatureConversions.kelvinToFahrenheitScale(value);
}

final class Kelvin extends TemperatureScale {
  const Kelvin._() : super('K');

  @override
  double converterFrom(double value) => 1;

  @override
  double converterTo(double value) => 1;
}

final class Rankine extends TemperatureScale {
  const Rankine._() : super('°R');

  @override
  double converterFrom(double value) =>
      TemperatureConversions.rankineToKelvinScale(value);

  @override
  double converterTo(double value) =>
      TemperatureConversions.kelvinToRankineScale(value);
}

class TemperatureConversions {
  TemperatureConversions._();

  /*
   * Degree conversions are used to convert a quantity of degrees from one scale to another.
   * These conversions do not adjust for the zero offset.
   * Essentially they only do the 9:5 conversion between F degrees and C|K degrees
   */
  static double celsiusToFahrenheitDegrees(double celsius) =>
      celsius * 9.0 / 5.0;
  static double fahrenheitToCelsiusDegrees(double fahrenheit) =>
      fahrenheit * 5.0 / 9.0;
  static double celsiusToKelvinDegrees(double celsius) => celsius;
  static double kelvinToCelsiusDegrees(double kelvin) => kelvin;
  static double fahrenheitToKelvinDegrees(double fahrenheit) =>
      fahrenheit * 5.0 / 9.0;
  static double kelvinToFahrenheitDegrees(double kelvin) => kelvin * 9.0 / 5.0;
  static double celsiusToRankineDegrees(double celsius) => celsius * 9.0 / 5.0;
  static double rankineToCelsiusDegrees(double rankine) => rankine * 5.0 / 9.0;
  static double fahrenheitToRankineDegrees(double fahrenheit) => fahrenheit;
  static double rankineToFahrenheitDegrees(double rankine) => rankine;
  static double kelvinToRankineDegrees(double kelvin) => kelvin * 9.0 / 5.0;
  static double rankineToKelvinDegrees(double rankine) => rankine * 5.0 / 9.0;

  /*
   * Scale conversions are used to convert a "thermometer" temperature from one scale to another.
   * These conversions will adjust the result by the zero offset.
   * They are used to find the equivalent absolute temperature in the other scale.
   */
  static double celsiusToFahrenheitScale(double celsius) =>
      celsius * 9.0 / 5.0 + 32.0;
  static double fahrenheitToCelsiusScale(double fahrenheit) =>
      (fahrenheit - 32.0) * 5.0 / 9.0;
  static double celsiusToKelvinScale(double celsius) => celsius + 273.15;
  static double kelvinToCelsiusScale(double kelvin) => kelvin - 273.15;
  static double fahrenheitToKelvinScale(double fahrenheit) =>
      (fahrenheit + 459.67) * 5.0 / 9.0;
  static double kelvinToFahrenheitScale(double kelvin) =>
      kelvin * 9.0 / 5.0 - 459.67;
  static double celsiusToRankineScale(double celsius) =>
      (celsius + 273.15) * 9.0 / 5.0;
  static double rankineToCelsiusScale(double rankine) =>
      (rankine - 491.67) * 5.0 / 9.0;
  static double fahrenheitToRankineScale(double fahrenheit) =>
      fahrenheit + 459.67;
  static double rankineToFahrenheitScale(double rankine) => rankine - 459.67;
  static double kelvinToRankineScale(double kelvin) => kelvin * 9.0 / 5.0;
  static double rankineToKelvinScale(double rankine) => rankine * 5.0 / 9.0;
}

extension TemperatureOps on num {
  Temperature get celcius => Temperature.celcius(this);
  Temperature get fahrenheit => Temperature.fahrenheit(this);
  Temperature get kelvin => Temperature.kelvin(this);
  Temperature get rankine => Temperature.rankine(this);
}
