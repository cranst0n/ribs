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

    test('operator +', () {
      final result = 2.0.squareMeters + 10000.0.squareCentimeters;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Area.squareMeters));
    });

    test('operator -', () {
      final result = 5.0.squareMeters - 10000.0.squareCentimeters;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(Area.squareMeters));
    });

    group('operator * (Area * Length => Volume)', () {
      test('squareMeters * meters => cubicMeters', () {
        final v = 3.0.squareMeters * 2.0.meters;
        expect(v.toCubicMeters.value, closeTo(6.0, 1e-9));
        expect(v.unit, equals(Volume.cubicMeters));
      });

      test('squareUsMiles * usMiles => cubicUsMiles', () {
        final v = 3.0.squareUsMiles * 2.0.usMiles;
        expect(v.toCubicUsMiles.value, closeTo(6.0, 1e-9));
        expect(v.unit, equals(Volume.cubicUsMiles));
      });

      test('squareYards * yards => cubicYards', () {
        final v = 3.0.squareYards * 2.0.yards;
        expect(v.toCubicYards.value, closeTo(6.0, 1e-9));
        expect(v.unit, equals(Volume.cubicYards));
      });

      test('squareFeet * feet => cubicFeet', () {
        final v = 3.0.squareFeet * 2.0.feet;
        expect(v.toCubicFeet.value, closeTo(6.0, 1e-9));
        expect(v.unit, equals(Volume.cubicFeet));
      });

      test('squareInches * inches => cubicInches', () {
        final v = 3.0.squareInches * 2.0.inches;
        expect(v.toCubicInches.value, closeTo(6.0, 1e-9));
        expect(v.unit, equals(Volume.cubicInches));
      });

      test('hectares (default branch) * meters => cubicMeters', () {
        final v = 1.0.hectares * 1.0.meters;
        expect(v.toCubicMeters.value, closeTo(1e4, 1e-6));
        expect(v.unit, equals(Volume.cubicMeters));
      });
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
