import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ChemicalAmount', () {
    QuantityProperties.parsing(ChemicalAmount.parse, ChemicalAmount.units);
    QuantityProperties.equivalence(chemicalAmount, chemicalAmountUnit);
    QuantityProperties.roundtrip(chemicalAmount, roundTrips);
  });
}

final roundTrips = <Function1<ChemicalAmount, ChemicalAmount>>[
  (c) => ChemicalAmount(c.toMoles.to(c.unit), c.unit),
  (c) => ChemicalAmount(c.toNanomoles.to(c.unit), c.unit),
  (c) => ChemicalAmount(c.toMicromoles.to(c.unit), c.unit),
  (c) => ChemicalAmount(c.toMillimoles.to(c.unit), c.unit),
  (c) => ChemicalAmount(c.toKilomoles.to(c.unit), c.unit),
  (c) => ChemicalAmount(c.toMegamoles.to(c.unit), c.unit),
];
