import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Length', () {
    QuantityProperties.parsing(Length.parse, Length.units);
    QuantityProperties.equivalence(length, lengthUnit);
    QuantityProperties.roundtrip(length, roundTrips);

    test('operator +', () {
      final result = 1.0.meters + 100.0.centimeters;
      expect(result.value, closeTo(2.0, 1e-9));
      expect(result.unit, equals(Length.meters));
    });

    test('operator -', () {
      final result = 3.0.meters - 100.0.centimeters;
      expect(result.value, closeTo(2.0, 1e-9));
      expect(result.unit, equals(Length.meters));
    });
  });
}

final roundTrips = <Function1<Length, Length>>[
  (l) => Length(l.toNanometers.to(l.unit), l.unit),
  (l) => Length(l.toMicrons.to(l.unit), l.unit),
  (l) => Length(l.toMillimeters.to(l.unit), l.unit),
  (l) => Length(l.toCentimeters.to(l.unit), l.unit),
  (l) => Length(l.toDecimeters.to(l.unit), l.unit),
  (l) => Length(l.toMeters.to(l.unit), l.unit),
  (l) => Length(l.toDecameters.to(l.unit), l.unit),
  (l) => Length(l.toHectometers.to(l.unit), l.unit),
  (l) => Length(l.toKilometers.to(l.unit), l.unit),
  (l) => Length(l.toInches.to(l.unit), l.unit),
  (l) => Length(l.toFeet.to(l.unit), l.unit),
  (l) => Length(l.toYards.to(l.unit), l.unit),
  (l) => Length(l.toUsMiles.to(l.unit), l.unit),
  (l) => Length(l.toNauticalMiles.to(l.unit), l.unit),
];
