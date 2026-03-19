import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Pressure', () {
    QuantityProperties.parsing(Pressure.parse, Pressure.units);
    QuantityProperties.equivalence(pressure, pressureUnit);
    QuantityProperties.roundtrip(pressure, roundTrips);
  });
}

final roundTrips = <Function1<Pressure, Pressure>>[
  (p) => Pressure(p.toPascals.to(p.unit), p.unit),
  (p) => Pressure(p.toKilopascals.to(p.unit), p.unit),
  (p) => Pressure(p.toMegapascals.to(p.unit), p.unit),
  (p) => Pressure(p.toGigapascals.to(p.unit), p.unit),
  (p) => Pressure(p.toBars.to(p.unit), p.unit),
  (p) => Pressure(p.toMillibars.to(p.unit), p.unit),
  (p) => Pressure(p.toPoundsPerSquareInch.to(p.unit), p.unit),
  (p) => Pressure(p.toAtmospheres.to(p.unit), p.unit),
  (p) => Pressure(p.toTorr.to(p.unit), p.unit),
];
