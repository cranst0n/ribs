import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ThermalCapacity', () {
    QuantityProperties.parsing(ThermalCapacity.parse, ThermalCapacity.units);
    QuantityProperties.equivalence(thermalCapacity, thermalCapacityUnit);
    QuantityProperties.roundtrip(thermalCapacity, roundTrips);
  });
}

final roundTrips = <Function1<ThermalCapacity, ThermalCapacity>>[
  (t) => ThermalCapacity(t.toJoulesPerKelvin.to(t.unit), t.unit),
  (t) => ThermalCapacity(t.toBtuPerFahrenheit.to(t.unit), t.unit),
];
