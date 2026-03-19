import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Energy', () {
    QuantityProperties.parsing(Energy.parse, Energy.units);
    QuantityProperties.equivalence(energy, energyUnit);
    QuantityProperties.roundtrip(energy, roundTrips);
  });
}

final roundTrips = <Function1<Energy, Energy>>[
  (e) => Energy(e.toJoules.to(e.unit), e.unit),
  (e) => Energy(e.toMillijoules.to(e.unit), e.unit),
  (e) => Energy(e.toKilojoules.to(e.unit), e.unit),
  (e) => Energy(e.toMegajoules.to(e.unit), e.unit),
  (e) => Energy(e.toGigajoules.to(e.unit), e.unit),
  (e) => Energy(e.toTerajoules.to(e.unit), e.unit),
  (e) => Energy(e.toWattHours.to(e.unit), e.unit),
  (e) => Energy(e.toKilowattHours.to(e.unit), e.unit),
  (e) => Energy(e.toMegawattHours.to(e.unit), e.unit),
  (e) => Energy(e.toGigawattHours.to(e.unit), e.unit),
  (e) => Energy(e.toBtu.to(e.unit), e.unit),
  (e) => Energy(e.toCalories.to(e.unit), e.unit),
  (e) => Energy(e.toKilocalories.to(e.unit), e.unit),
  (e) => Energy(e.toElectronvolts.to(e.unit), e.unit),
];
