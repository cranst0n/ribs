import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('AreaDensity', () {
    QuantityProperties.parsing(AreaDensity.parse, AreaDensity.units);
    QuantityProperties.equivalence(areaDensity, areaDensityUnit);
    QuantityProperties.roundtrip(areaDensity, roundTrips);
  });
}

final roundTrips = <Function1<AreaDensity, AreaDensity>>[
  (a) => AreaDensity(a.toKilogramsPerSquareMeter.to(a.unit), a.unit),
  (a) => AreaDensity(a.toGramsPerSquareCentimeter.to(a.unit), a.unit),
  (a) => AreaDensity(a.toPoundsPerSquareFoot.to(a.unit), a.unit),
];
