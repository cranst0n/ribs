import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

class QuantityProperties {
  static void parsing<A extends Quantity<A>>(
    Function1<String, Option<A>> parse,
    Iterable<UnitOfMeasure<A>> units,
  ) {
    forAll(
      'parse',
      quantityString(units),
      (str) => expect(parse(str).isDefined, isTrue),
    );
  }

  static void equivalence<A extends Quantity<A>, B extends UnitOfMeasure<A>>(
    Gen<A> gen,
    Gen<B> genUnit,
  ) {
    forAll2('equivalentTo', gen, genUnit, (original, otherUnit) {
      expect(
        otherUnit(original.to(otherUnit)).equivalentTo(original),
        isTrue,
      );
    });
  }

  static void roundtrip<A extends Quantity<A>>(
    Gen<A> gen,
    Iterable<Function1<A, A>> roundTrips,
  ) {
    forAll2('roundtrip', gen, Gen.oneOf(roundTrips), (original, roundTrip) {
      final actual = roundTrip(original);

      expect(original.value, closeTo(actual.value, 1e-6));
    });
  }
}
