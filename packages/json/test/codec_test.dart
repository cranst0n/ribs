import 'package:meta/meta.dart';
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

    testCodec('integer', Gen.integer, Codec.integer);

    testCodec('ilist', Gen.ilistOf(Gen.chooseInt(0, 20), Gen.boolean),
        Codec.ilist(Codec.boolean));

    testCodec(
        'imap',
        Gen.chooseInt(0, 20).flatMap((n) =>
            Gen.imapOfN(n, Gen.stringOf(Gen.alphaUpperChar), Gen.boolean)),
        Codec.imapOf(KeyCodec.string, Codec.boolean));

    testCodec('json', genJson, Codec.json);

    forAll('list', Gen.listOf(Gen.chooseInt(0, 20), Gen.boolean), (l) {
      Codec.list(Codec.boolean)
          .decode(Codec.list(Codec.boolean).encode(l))
          .fold(
            (err) => fail('Codec.list failed for [$l]: $err'),
            (a) => expect(ilist(a), ilist(l)),
          );
    });

    forAll('map',
        Gen.mapOfN(100, Gen.stringOf(Gen.alphaUpperChar), Gen.nonNegativeInt),
        (m) {
      Codec.mapOf(KeyCodec.string, Codec.integer)
          .decode(Codec.mapOf(KeyCodec.string, Codec.integer).encode(m))
          .fold(
        (err) => fail('Codec.list failed for [$m]: $err'),
        (a) {
          expect(m.length, a.length);
          m.forEach((key, value) {
            expect(a.containsKey(key), isTrue);
            expect(m[key], a[key]);
          });
        },
      );
    });

    testCodec('nonEmptyIList', Gen.nonEmptyIList(Gen.positiveInt, 500),
        Codec.nonEmptyIList(Codec.integer));

    testCodec('num', Gen.oneOf(ilist([1, 3.14, -1238.12])), Codec.number);

    testCodec('option', Gen.option(Gen.positiveInt), Codec.integer.optional());

    forAll('product2', prod2Gen(Gen.positiveInt, Codec.integer), (c) {
      final (codec, json) = c;
      expect(
        codec.decode(json).map(codec.encode),
        json.asRight<DecodingFailure>(),
      );
    });

    forAll('product3', prod3Gen(Gen.positiveInt, Codec.integer), (c) {
      final (codec, json) = c;
      expect(
        codec.decode(json).map(codec.encode),
        json.asRight<DecodingFailure>(),
      );
    });
  });
}

@isTest
void testCodec<A>(String description, Gen<A> gen, Codec<A> codec) {
  forAll(description, gen, (a) {
    expect(
      codec.decode(codec.encode(a)),
      isRight<DecodingFailure, A>(a),
    );
  });
}

enum Vehicles { Car, Bike, Motorcycle, Bus, Airplane }

final keyGen = Gen.stringOf(Gen.alphaNumChar, 20);

Gen<(Codec<(A, A)>, Json)> prod2Gen<A>(Gen<A> valueGen, Codec<A> valueCodec) {
  return (keyGen, valueGen).tupled.tuple2.map((tup) {
    final ((k1, v1), (k2, v2)) = tup;

    return (
      KeyValueCodec.product2<A, A, (A, A)>(
        KeyValueCodec(k1, valueCodec),
        KeyValueCodec(k2, valueCodec),
        (a, b) => (a, b),
        id,
      ),
      Json.obj([
        (k1, valueCodec.encode(v1)),
        (k2, valueCodec.encode(v2)),
      ]),
    );
  });
}

Gen<(Codec<(A, A, A)>, Json)> prod3Gen<A>(
    Gen<A> valueGen, Codec<A> valueCodec) {
  return (keyGen, valueGen).tupled.tuple3.map((tup) {
    final ((k1, v1), (k2, v2), (k3, v3)) = tup;

    return (
      KeyValueCodec.product3<A, A, A, (A, A, A)>(
        KeyValueCodec(k1, valueCodec),
        KeyValueCodec(k2, valueCodec),
        KeyValueCodec(k3, valueCodec),
        (a, b, c) => (a, b, c),
        id,
      ),
      Json.obj([
        (k1, valueCodec.encode(v1)),
        (k2, valueCodec.encode(v2)),
        (k3, valueCodec.encode(v3)),
      ]),
    );
  });
}
