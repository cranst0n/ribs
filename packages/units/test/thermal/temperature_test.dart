import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../gen.dart';
import '../quantity_properties.dart';

void main() {
  group('Temperature', () {
    QuantityProperties.parsing(Temperature.parse, Temperature.units);
    QuantityProperties.equivalence(temperature, temperatureUnit);
    QuantityProperties.roundtrip(temperature, roundTrips);
  });
}

final roundTrips = <Function1<Temperature, Temperature>>[
  (t) => Temperature(t.toFahrenheit.to(t.unit), t.unit),
];
