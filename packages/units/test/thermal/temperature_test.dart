import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Temperature', () {
    QuantityProperties.parsing(Temperature.parse, Temperature.units);
    QuantityProperties.equivalence(temperature, temperatureUnit);
    QuantityProperties.roundtrip(temperature, roundTrips);

    group('scale getters', () {
      test('toCelsius', () {
        expect(32.0.fahrenheit.toCelsius.value, closeTo(0.0, 1e-9));
        expect(212.0.fahrenheit.toCelsius.value, closeTo(100.0, 1e-9));
        expect(273.15.kelvin.toCelsius.value, closeTo(0.0, 1e-9));
        expect(491.67.rankine.toCelsius.value, closeTo(0.0, 1e-9));
        expect(0.0.celcius.toCelsius.value, closeTo(0.0, 1e-9));
      });

      test('toKelvin', () {
        expect(0.0.celcius.toKelvin.value, closeTo(273.15, 1e-9));
        expect(32.0.fahrenheit.toKelvin.value, closeTo(273.15, 1e-9));
        expect(491.67.rankine.toKelvin.value, closeTo(273.15, 1e-9));
        expect(273.15.kelvin.toKelvin.value, closeTo(273.15, 1e-9));
      });

      test('toRankine', () {
        expect(0.0.celcius.toRankine.value, closeTo(491.67, 1e-9));
        expect(32.0.fahrenheit.toRankine.value, closeTo(491.67, 1e-9));
        expect(273.15.kelvin.toRankine.value, closeTo(491.67, 1e-9));
        expect(491.67.rankine.toRankine.value, closeTo(491.67, 1e-9));
      });
    });

    group('degree getters', () {
      test('toCelsiusDegrees', () {
        expect(9.0.fahrenheit.toCelsiusDegrees.value, closeTo(5.0, 1e-9));
        expect(9.0.rankine.toCelsiusDegrees.value, closeTo(5.0, 1e-9));
        expect(5.0.kelvin.toCelsiusDegrees.value, closeTo(5.0, 1e-9));
        expect(5.0.celcius.toCelsiusDegrees.value, closeTo(5.0, 1e-9));
      });

      test('toFahrenheitDegrees', () {
        expect(5.0.celcius.toFahrenheitDegrees.value, closeTo(9.0, 1e-9));
        expect(5.0.kelvin.toFahrenheitDegrees.value, closeTo(9.0, 1e-9));
        expect(9.0.rankine.toFahrenheitDegrees.value, closeTo(9.0, 1e-9));
        expect(9.0.fahrenheit.toFahrenheitDegrees.value, closeTo(9.0, 1e-9));
      });

      test('toKelvinDegrees', () {
        expect(5.0.celcius.toKelvinDegrees.value, closeTo(5.0, 1e-9));
        expect(9.0.fahrenheit.toKelvinDegrees.value, closeTo(5.0, 1e-9));
        expect(9.0.rankine.toKelvinDegrees.value, closeTo(5.0, 1e-9));
        expect(5.0.kelvin.toKelvinDegrees.value, closeTo(5.0, 1e-9));
      });

      test('toRankineDegrees', () {
        expect(5.0.celcius.toRankineDegrees.value, closeTo(9.0, 1e-9));
        expect(9.0.fahrenheit.toRankineDegrees.value, closeTo(9.0, 1e-9));
        expect(5.0.kelvin.toRankineDegrees.value, closeTo(9.0, 1e-9));
        expect(9.0.rankine.toRankineDegrees.value, closeTo(9.0, 1e-9));
      });
    });

    group('arithmetic operators', () {
      test('operator + adds degree deltas', () {
        final sum = 20.0.celcius + 5.0.celcius;
        expect(sum.value, closeTo(25.0, 1e-9));
        expect(sum.unit, equals(Temperature.celcius));
      });

      test('operator + cross-unit adds degree equivalent', () {
        // 9°F == 5°C in degrees; 20°C + 9°F == 20°C + 5°C == 25°C
        final sum = 20.0.celcius + 9.0.fahrenheit;
        expect(sum.value, closeTo(25.0, 1e-9));
      });

      test('operator - subtracts degree deltas', () {
        final diff = 20.0.celcius - 5.0.celcius;
        expect(diff.value, closeTo(15.0, 1e-9));
        expect(diff.unit, equals(Temperature.celcius));
      });

      test('operator - cross-unit subtracts degree equivalent', () {
        // 9°F == 5°C in degrees; 20°C - 9°F == 20°C - 5°C == 15°C
        final diff = 20.0.celcius - 9.0.fahrenheit;
        expect(diff.value, closeTo(15.0, 1e-9));
      });
    });

    group('toString', () {
      test('Kelvin uses default format', () {
        expect(300.0.kelvin.toString(), equals('300.0 K'));
      });

      test('Celsius uses fixed-1 with symbol', () {
        expect(100.0.celcius.toString(), equals('100.0°C'));
      });

      test('Fahrenheit uses fixed-1 with symbol', () {
        expect(32.0.fahrenheit.toString(), equals('32.0°F'));
      });

      test('Rankine uses fixed-1 with symbol', () {
        expect(491.67.rankine.toString(), equals('491.7°R'));
      });
    });

    group('converterFrom / converterTo', () {
      test('Celcius.converterFrom converts to Kelvin scale', () {
        expect(
          Temperature.celcius.converterFrom(0.0),
          closeTo(273.15, 1e-9),
        );
        expect(
          Temperature.celcius.converterFrom(100.0),
          closeTo(373.15, 1e-9),
        );
      });

      test('Celcius.converterTo converts from Kelvin scale', () {
        expect(
          Temperature.celcius.converterTo(273.15),
          closeTo(0.0, 1e-9),
        );
      });

      test('Fahrenheit.converterFrom converts to Kelvin scale', () {
        expect(
          Temperature.fahrenheit.converterFrom(32.0),
          closeTo(273.15, 1e-9),
        );
      });

      test('Fahrenheit.converterTo converts from Kelvin scale', () {
        expect(
          Temperature.fahrenheit.converterTo(273.15),
          closeTo(32.0, 1e-9),
        );
      });
    });
  });
}

final roundTrips = <Function1<Temperature, Temperature>>[
  (t) => Temperature(t.toFahrenheit.to(t.unit), t.unit),
  (t) => Temperature(t.toCelsius.to(t.unit), t.unit),
  (t) => Temperature(t.toKelvin.to(t.unit), t.unit),
  (t) => Temperature(t.toRankine.to(t.unit), t.unit),
];
