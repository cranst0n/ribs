import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Area', () {
    QuantityProperties.parsing(Area.parse, Area.units);
    QuantityProperties.equivalence(area, areaUnit);
    QuantityProperties.roundtrip(area, roundTrips);

    length.tuple2.forAll('multiple / divide', (t) {
      final (a, b) = t;
      expect((a * b / b).to(a.unit), closeTo(a.value, 1e-6));
    });
  });
}

final roundTrips = <Function1<Area, Area>>[
  (a) => Area(a.toSquareMeters.to(a.unit), a.unit),
  (a) => Area(a.toSquareCentimeters.to(a.unit), a.unit),
  (a) => Area(a.toSquareKilometers.to(a.unit), a.unit),
  (a) => Area(a.toSquareUsMiles.to(a.unit), a.unit),
  (a) => Area(a.toSquareYards.to(a.unit), a.unit),
  (a) => Area(a.toSquareFeet.to(a.unit), a.unit),
  (a) => Area(a.toSquareInches.to(a.unit), a.unit),
  (a) => Area(a.toHectares.to(a.unit), a.unit),
  (a) => Area(a.toAcres.to(a.unit), a.unit),
  (a) => Area(a.toBarnes.to(a.unit), a.unit),
];
