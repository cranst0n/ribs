import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Power', () {
    QuantityProperties.parsing(Power.parse, Power.units);
    QuantityProperties.equivalence(power, powerUnit);
    QuantityProperties.roundtrip(power, roundTrips);
  });
}

final roundTrips = <Function1<Power, Power>>[
  (p) => Power(p.toMilliwatts.to(p.unit), p.unit),
  (p) => Power(p.toWatts.to(p.unit), p.unit),
  (p) => Power(p.toKilowatts.to(p.unit), p.unit),
  (p) => Power(p.toMegawatts.to(p.unit), p.unit),
  (p) => Power(p.toGigawatts.to(p.unit), p.unit),
  (p) => Power(p.toTerawatts.to(p.unit), p.unit),
  (p) => Power(p.toBtuPerHour.to(p.unit), p.unit),
  (p) => Power(p.toErgsPerSecond.to(p.unit), p.unit),
  (p) => Power(p.toHorsepower.to(p.unit), p.unit),
  (p) => Power(p.toSolarLuminosities.to(p.unit), p.unit),
];
