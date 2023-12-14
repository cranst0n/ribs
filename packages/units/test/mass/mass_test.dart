import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../gen.dart';
import '../quantity_properties.dart';

void main() {
  group('Mass', () {
    QuantityProperties.parsing(Mass.parse, Mass.units);
    QuantityProperties.equivalence(mass, massUnit);
    QuantityProperties.roundtrip(mass, roundTrips);
  });
}

final roundTrips = <Function1<Mass, Mass>>[
  (m) => Mass(m.toGrams.to(m.unit), m.unit),
  (m) => Mass(m.toNanograms.to(m.unit), m.unit),
  (m) => Mass(m.toMicrograms.to(m.unit), m.unit),
  (m) => Mass(m.toMilligrams.to(m.unit), m.unit),
  (m) => Mass(m.toKilograms.to(m.unit), m.unit),
  (m) => Mass(m.toTonnes.to(m.unit), m.unit),
  (m) => Mass(m.toOunces.to(m.unit), m.unit),
  (m) => Mass(m.toPounds.to(m.unit), m.unit),
  (m) => Mass(m.toKilopounds.to(m.unit), m.unit),
  (m) => Mass(m.toMegapounds.to(m.unit), m.unit),
  (m) => Mass(m.toStone.to(m.unit), m.unit),
  (m) => Mass(m.toTroyGrains.to(m.unit), m.unit),
  (m) => Mass(m.toPennyweights.to(m.unit), m.unit),
  (m) => Mass(m.toTroyOunces.to(m.unit), m.unit),
  (m) => Mass(m.toTroyPounds.to(m.unit), m.unit),
  (m) => Mass(m.toTolas.to(m.unit), m.unit),
  (m) => Mass(m.toCarats.to(m.unit), m.unit),
];
