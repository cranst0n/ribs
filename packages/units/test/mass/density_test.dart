import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Density', () {
    QuantityProperties.parsing(Density.parse, Density.units);
    QuantityProperties.equivalence(density, densityUnit);
    QuantityProperties.roundtrip(density, roundTrips);
  });
}

final roundTrips = <Function1<Density, Density>>[
  (d) => Density(d.toKilogramsPerCubicMeter.to(d.unit), d.unit),
  (d) => Density(d.toGramsPerCubicCentimeter.to(d.unit), d.unit),
  (d) => Density(d.toKilogramsPerLiter.to(d.unit), d.unit),
  (d) => Density(d.toPoundsPerCubicFoot.to(d.unit), d.unit),
  (d) => Density(d.toPoundsPerCubicInch.to(d.unit), d.unit),
  (d) => Density(d.toKilogramsPerCubicFoot.to(d.unit), d.unit),
];
