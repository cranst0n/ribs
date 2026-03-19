import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Volume', () {
    QuantityProperties.parsing(Volume.parse, Volume.units);
    QuantityProperties.equivalence(volume, volumeUnit);
    QuantityProperties.roundtrip(volume, roundTrips);

    test('operator +', () {
      final result = 1.0.litres + 500.0.millilitres;
      expect(result.value, closeTo(1.5, 1e-9));
      expect(result.unit, equals(Volume.litres));
    });

    test('operator -', () {
      final result = 2.0.litres - 500.0.millilitres;
      expect(result.value, closeTo(1.5, 1e-9));
      expect(result.unit, equals(Volume.litres));
    });
  });
}

final roundTrips = <Function1<Volume, Volume>>[
  (v) => Volume(v.toCubicMeters.to(v.unit), v.unit),
  (v) => Volume(v.toLitres.to(v.unit), v.unit),
  (v) => Volume(v.toNanolitres.to(v.unit), v.unit),
  (v) => Volume(v.toMicrolitres.to(v.unit), v.unit),
  (v) => Volume(v.toMillilitres.to(v.unit), v.unit),
  (v) => Volume(v.toCentilitres.to(v.unit), v.unit),
  (v) => Volume(v.toDecilitres.to(v.unit), v.unit),
  (v) => Volume(v.toHectolitres.to(v.unit), v.unit),
  (v) => Volume(v.toCubicUsMiles.to(v.unit), v.unit),
  (v) => Volume(v.toCubicYards.to(v.unit), v.unit),
  (v) => Volume(v.toCubicFeet.to(v.unit), v.unit),
  (v) => Volume(v.toCubicInches.to(v.unit), v.unit),
  (v) => Volume(v.toUsGallons.to(v.unit), v.unit),
  (v) => Volume(v.toUsQuarts.to(v.unit), v.unit),
  (v) => Volume(v.toUsPints.to(v.unit), v.unit),
  (v) => Volume(v.toUsCups.to(v.unit), v.unit),
  (v) => Volume(v.toFluidOunces.to(v.unit), v.unit),
  (v) => Volume(v.toTablespoons.to(v.unit), v.unit),
  (v) => Volume(v.toTeaspoons.to(v.unit), v.unit),
];
