import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing temperature.
///
/// Unlike most quantities, temperature conversions involve both a scale factor
/// *and* a zero-point offset (e.g. Celsius and Fahrenheit share a 9:5 ratio
/// but differ by 32° at zero). This class handles both:
///
/// - **Scale conversions** (`toFahrenheit`, `toCelsius`, etc.) adjust for the
///   zero-point offset and are appropriate when converting thermometer readings.
/// - **Degree conversions** (`toFahrenheitDegrees`, `toCelsiusDegrees`, etc.)
///   skip the offset and are appropriate when converting a *difference* between
///   two temperatures (e.g. "5 Celsius degrees warmer").
///
/// Arithmetic (`+`, `-`) operates on degree magnitudes without offset
/// adjustment so that `37°C + 1°C == 38°C` rather than trying to account
/// for absolute zero.
final class Temperature extends Quantity<Temperature> {
  Temperature(super.value, super.unit);

  /// Returns the sum of degree magnitudes in the units of this [Temperature].
  ///
  /// The addend is converted to [unit] without zero-offset adjustment so that
  /// adding temperatures behaves as adding scalar magnitudes.
  Temperature operator +(Temperature that) =>
      Temperature(value + that._convert(unit, withOffset: false).value, unit);

  /// Returns the difference of degree magnitudes in the units of this [Temperature].
  ///
  /// The subtrahend is converted to [unit] without zero-offset adjustment.
  Temperature operator -(Temperature that) =>
      Temperature(value - that._convert(unit, withOffset: false).value, unit);

  @override
  double to(UnitOfMeasure<Temperature> uom) => _convert(uom).value;

  /// Converts this temperature to the Fahrenheit scale.
  Temperature get toFahrenheit => _convert(fahrenheit);

  /// Converts this temperature to the Celsius scale.
  Temperature get toCelsius => _convert(celcius);

  /// Converts this temperature to the Kelvin scale.
  Temperature get toKelvin => _convert(kelvin);

  /// Converts this temperature to the Rankine scale.
  Temperature get toRankine => _convert(rankine);

  /// Converts this temperature *magnitude* to Fahrenheit degrees (no offset).
  Temperature get toFahrenheitDegrees => _convert(fahrenheit, withOffset: false);

  /// Converts this temperature *magnitude* to Celsius degrees (no offset).
  Temperature get toCelsiusDegrees => _convert(celcius, withOffset: false);

  /// Converts this temperature *magnitude* to Kelvin degrees (no offset).
  Temperature get toKelvinDegrees => _convert(kelvin, withOffset: false);

  /// Converts this temperature *magnitude* to Rankine degrees (no offset).
  Temperature get toRankineDegrees => _convert(rankine, withOffset: false);

  @override
  String toString() =>
      unit is Kelvin ? super.toString() : '${value.toStringAsFixed(1)}${unit.symbol}';

  /// Unit for degrees Celsius (°C).
  static const celcius = Celcius._();

  /// Unit for degrees Fahrenheit (°F).
  static const fahrenheit = Fahrenheit._();

  /// Unit for Kelvin (K).
  static const kelvin = Kelvin._();

  /// Unit for degrees Rankine (°R).
  static const rankine = Rankine._();

  /// All supported [Temperature] units.
  static const units = {
    celcius,
    fahrenheit,
    kelvin,
    rankine,
  };

  /// Parses [s] into a [Temperature], returning [None] if parsing fails.
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
        return TemperatureConversions.celsiusToFahrenheitScale(value).fahrenheit;
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
        return TemperatureConversions.rankineToFahrenheitScale(value).fahrenheit;
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
        return TemperatureConversions.celsiusToFahrenheitDegrees(value).fahrenheit;
      } else if (unit is Celcius && toScale is Kelvin) {
        return TemperatureConversions.celsiusToKelvinDegrees(value).kelvin;
      } else if (unit is Kelvin && toScale is Celcius) {
        return TemperatureConversions.kelvinToCelsiusDegrees(value).celcius;
      } else if (unit is Fahrenheit && toScale is Kelvin) {
        return TemperatureConversions.fahrenheitToKelvinDegrees(value).kelvin;
      } else if (unit is Kelvin && toScale is Fahrenheit) {
        return TemperatureConversions.kelvinToFahrenheitDegrees(value).fahrenheit;
      } else if (unit is Fahrenheit && toScale is Rankine) {
        return TemperatureConversions.fahrenheitToRankineDegrees(value).rankine;
      } else if (unit is Rankine && toScale is Fahrenheit) {
        return TemperatureConversions.rankineToFahrenheitDegrees(value).fahrenheit;
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

/// Base class for temperature scale units.
abstract class TemperatureScale extends UnitOfMeasure<Temperature> {
  @override
  final String unit;

  @override
  final String symbol;

  const TemperatureScale(this.unit, this.symbol);

  @override
  Temperature call(num value) => Temperature(value.toDouble(), this);
}

/// The Celsius temperature scale (°C).
final class Celcius extends TemperatureScale {
  const Celcius._() : super('celcius', '°C');

  @override
  double converterFrom(double value) => TemperatureConversions.celsiusToKelvinScale(value);

  @override
  double converterTo(double value) => TemperatureConversions.kelvinToCelsiusScale(value);
}

/// The Fahrenheit temperature scale (°F).
final class Fahrenheit extends TemperatureScale {
  const Fahrenheit._() : super('fahrenheit', '°F');

  @override
  double converterFrom(double value) => TemperatureConversions.fahrenheitToKelvinScale(value);

  @override
  double converterTo(double value) => TemperatureConversions.kelvinToFahrenheitScale(value);
}

/// The Kelvin temperature scale (K).
///
/// Kelvin is the SI base unit for temperature. Its zero point is absolute
/// zero, so no offset adjustment is needed during conversion.
final class Kelvin extends TemperatureScale {
  const Kelvin._() : super('kelvin', 'K');

  @override
  double converterFrom(double value) => 1;

  @override
  double converterTo(double value) => 1;
}

/// The Rankine temperature scale (°R).
///
/// Rankine uses the same degree size as Fahrenheit but with absolute zero
/// as its zero point.
final class Rankine extends TemperatureScale {
  const Rankine._() : super('rankine', '°R');

  @override
  double converterFrom(double value) => TemperatureConversions.rankineToKelvinScale(value);

  @override
  double converterTo(double value) => TemperatureConversions.kelvinToRankineScale(value);
}

/// Low-level temperature conversion formulas.
///
/// Two families of conversions are provided:
///
/// - **Degree conversions** (e.g. [celsiusToFahrenheitDegrees]) convert a
///   *magnitude* of degrees from one scale to another, without adjusting for
///   the zero-point offset. Use these when converting temperature *differences*.
/// - **Scale conversions** (e.g. [celsiusToFahrenheitScale]) convert an
///   absolute thermometer reading from one scale to another, including the
///   zero-point offset. Use these when converting actual temperatures.
class TemperatureConversions {
  TemperatureConversions._();

  /*
   * Degree conversions are used to convert a quantity of degrees from one scale to another.
   * These conversions do not adjust for the zero offset.
   * Essentially they only do the 9:5 conversion between F degrees and C|K degrees
   */
  /// Converts a Celsius degree magnitude to Fahrenheit degrees (no offset).
  static double celsiusToFahrenheitDegrees(double celsius) => celsius * 9.0 / 5.0;

  /// Converts a Fahrenheit degree magnitude to Celsius degrees (no offset).
  static double fahrenheitToCelsiusDegrees(double fahrenheit) => fahrenheit * 5.0 / 9.0;

  /// Converts a Celsius degree magnitude to Kelvin degrees (identity).
  static double celsiusToKelvinDegrees(double celsius) => celsius;

  /// Converts a Kelvin degree magnitude to Celsius degrees (identity).
  static double kelvinToCelsiusDegrees(double kelvin) => kelvin;

  /// Converts a Fahrenheit degree magnitude to Kelvin degrees (no offset).
  static double fahrenheitToKelvinDegrees(double fahrenheit) => fahrenheit * 5.0 / 9.0;

  /// Converts a Kelvin degree magnitude to Fahrenheit degrees (no offset).
  static double kelvinToFahrenheitDegrees(double kelvin) => kelvin * 9.0 / 5.0;

  /// Converts a Celsius degree magnitude to Rankine degrees (no offset).
  static double celsiusToRankineDegrees(double celsius) => celsius * 9.0 / 5.0;

  /// Converts a Rankine degree magnitude to Celsius degrees (no offset).
  static double rankineToCelsiusDegrees(double rankine) => rankine * 5.0 / 9.0;

  /// Converts a Fahrenheit degree magnitude to Rankine degrees (identity).
  static double fahrenheitToRankineDegrees(double fahrenheit) => fahrenheit;

  /// Converts a Rankine degree magnitude to Fahrenheit degrees (identity).
  static double rankineToFahrenheitDegrees(double rankine) => rankine;

  /// Converts a Kelvin degree magnitude to Rankine degrees (no offset).
  static double kelvinToRankineDegrees(double kelvin) => kelvin * 9.0 / 5.0;

  /// Converts a Rankine degree magnitude to Kelvin degrees (no offset).
  static double rankineToKelvinDegrees(double rankine) => rankine * 5.0 / 9.0;

  /*
   * Scale conversions are used to convert a "thermometer" temperature from one scale to another.
   * These conversions will adjust the result by the zero offset.
   * They are used to find the equivalent absolute temperature in the other scale.
   */
  /// Converts a Celsius temperature to its Fahrenheit equivalent.
  static double celsiusToFahrenheitScale(double celsius) => celsius * 9.0 / 5.0 + 32.0;

  /// Converts a Fahrenheit temperature to its Celsius equivalent.
  static double fahrenheitToCelsiusScale(double fahrenheit) => (fahrenheit - 32.0) * 5.0 / 9.0;

  /// Converts a Celsius temperature to its Kelvin equivalent.
  static double celsiusToKelvinScale(double celsius) => celsius + 273.15;

  /// Converts a Kelvin temperature to its Celsius equivalent.
  static double kelvinToCelsiusScale(double kelvin) => kelvin - 273.15;

  /// Converts a Fahrenheit temperature to its Kelvin equivalent.
  static double fahrenheitToKelvinScale(double fahrenheit) => (fahrenheit + 459.67) * 5.0 / 9.0;

  /// Converts a Kelvin temperature to its Fahrenheit equivalent.
  static double kelvinToFahrenheitScale(double kelvin) => kelvin * 9.0 / 5.0 - 459.67;

  /// Converts a Celsius temperature to its Rankine equivalent.
  static double celsiusToRankineScale(double celsius) => (celsius + 273.15) * 9.0 / 5.0;

  /// Converts a Rankine temperature to its Celsius equivalent.
  static double rankineToCelsiusScale(double rankine) => (rankine - 491.67) * 5.0 / 9.0;

  /// Converts a Fahrenheit temperature to its Rankine equivalent.
  static double fahrenheitToRankineScale(double fahrenheit) => fahrenheit + 459.67;

  /// Converts a Rankine temperature to its Fahrenheit equivalent.
  static double rankineToFahrenheitScale(double rankine) => rankine - 459.67;

  /// Converts a Kelvin temperature to its Rankine equivalent.
  static double kelvinToRankineScale(double kelvin) => kelvin * 9.0 / 5.0;

  /// Converts a Rankine temperature to its Kelvin equivalent.
  static double rankineToKelvinScale(double rankine) => rankine * 5.0 / 9.0;
}

/// Extension methods for constructing [Temperature] values from [num].
extension TemperatureOps on num {
  /// Creates a [Temperature] of this value in degrees Celsius.
  Temperature get celcius => Temperature.celcius(this);

  /// Creates a [Temperature] of this value in degrees Fahrenheit.
  Temperature get fahrenheit => Temperature.fahrenheit(this);

  /// Creates a [Temperature] of this value in Kelvin.
  Temperature get kelvin => Temperature.kelvin(this);

  /// Creates a [Temperature] of this value in degrees Rankine.
  Temperature get rankine => Temperature.rankine(this);
}
