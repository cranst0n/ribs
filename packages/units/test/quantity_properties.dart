import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import 'gen.dart';

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
    forAll(
      'equivalentTo',
      (gen, genUnit).tupled,
      (tuple) {
        final (original, otherUnit) = tuple;
        expect(
          otherUnit(original.to(otherUnit)).equivalentTo(original),
          isTrue,
        );
      },
    );
  }

  static void roundtrip<A extends Quantity<A>>(
    Gen<A> gen,
    Iterable<Function1<A, A>> roundTrips,
  ) {
    forAll('roundtrip', (gen, Gen.oneOf(roundTrips)).tupled, (tuple) {
      final (original, roundTrip) = tuple;
      final actual = roundTrip(original);

      expect(original.value, closeTo(actual.value, 1e-6));
    });
  }
}
