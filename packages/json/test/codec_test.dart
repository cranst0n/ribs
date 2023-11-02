import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

import 'gen.dart';

void main() {
  group('Codec', () {
    testCodec('bigInt', Gen.bigInt, Codec.bigInt);
    testCodec('boolean', Gen.boolean, Codec.boolean);
    testCodec('dateTime', Gen.dateTime, Codec.dateTime);

    forAll('dubble', Gen.chooseDouble(-double.maxFinite, double.maxFinite),
        (a) {
      if (a.isFinite) {
        expect(
          Codec.dubble.decode(Codec.dubble.encode(a)),
          isRight<DecodingFailure, double>(a),
        );
      } else {
        Codec.dubble.decode(Codec.dubble.encode(a)).fold(
              (err) => fail('Codec.double failed for [$a]: $err'),
              (n) => expect(n.isNaN, isTrue),
            );
      }
    });

    testCodec('duration', Gen.duration, Codec.duration);
    testCodec('enumerationByIndex', Gen.chooseEnum(Vehicles.values),
        Codec.enumerationByIndex(Vehicles.values));
    testCodec('enumerationByName', Gen.chooseEnum(Vehicles.values),
        Codec.enumerationByName(Vehicles.values));
    testCodec('integer', Gen.chooseInt(-2147483648, 2147483648), Codec.integer);

    testCodec(
        'ilist',
        Gen.chooseInt(0, 20).flatMap((n) => Gen.ilistOf(n, Gen.boolean)),
        Codec.ilist(Codec.boolean));

    testCodec('json', genJson, Codec.json);

    forAll(
        'list', Gen.chooseInt(0, 20).flatMap((n) => Gen.listOf(n, Gen.boolean)),
        (l) {
      Codec.list(Codec.boolean)
          .decode(Codec.list(Codec.boolean).encode(l))
          .fold(
            (err) => fail('Codec.list failed for [$l]: $err'),
            (a) => expect(ilist(a), ilist(l)),
          );
    });

    testCodec('nonEmptyIList', Gen.nonEmptyIList(Gen.positiveInt, 500),
        Codec.nonEmptyIList(Codec.integer));

    testCodec('num', Gen.oneOf(ilist([1, 3.14, -1238.12])), Codec.number);
  });
}

void testCodec<A>(String description, Gen<A> gen, Codec<A> codec) {
  forAll(description, gen, (a) {
    expect(
      codec.decode(codec.encode(a)),
      isRight<DecodingFailure, A>(a),
    );
  });
}

enum Vehicles { Car, Bike, Motorcycle, Bus, Airplane }
