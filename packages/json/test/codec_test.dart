// ignore_for_file: unreachable_from_main

import 'package:meta/meta.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Codec', () {
    testCodec('bigInt', Gen.bigInt, Codec.bigInt);

    testCodec('boolean', Gen.boolean, Codec.boolean);

    testCodec('dateTime', Gen.dateTime, Codec.dateTime);

    forAll(
        'dubble',
        Gen.chooseDouble(-double.maxFinite, double.maxFinite,
            specials:
                ilist([double.infinity, double.negativeInfinity, double.nan])),
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

    testCodec(
      'oneOf',
      Gen.oneOfGen([Dog.gen, Cat.gen, HermitCrab.gen]),
      Animal.codec,
    );

    testCodec('nonEmptyIList', Gen.nonEmptyIList(Gen.positiveInt, 500),
        Codec.nonEmptyIList(Codec.integer));

    testCodec('num', Gen.oneOf([1, 3.14, -1238.12]), Codec.number);

    testCodec('option', Gen.option(Gen.positiveInt), Codec.integer.optional());

    forAll('tuple2', Gen.integer.tuple2, (t) {
      final d = Codec.tuple2(Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple3', Gen.integer.tuple3, (t) {
      final d = Codec.tuple3(Codec.integer, Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple4', Gen.integer.tuple4, (t) {
      final d = Codec.tuple4(
          Codec.integer, Codec.integer, Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple5', Gen.integer.tuple5, (t) {
      final d = Codec.tuple5(Codec.integer, Codec.integer, Codec.integer,
          Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple6', Gen.integer.tuple6, (t) {
      final d = Codec.tuple6(Codec.integer, Codec.integer, Codec.integer,
          Codec.integer, Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple7', Gen.integer.tuple7, (t) {
      final d = Codec.tuple7(Codec.integer, Codec.integer, Codec.integer,
          Codec.integer, Codec.integer, Codec.integer, Codec.integer);
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple8', Gen.integer.tuple8, (t) {
      final d = Codec.tuple8(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple9', Gen.integer.tuple9, (t) {
      final d = Codec.tuple9(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple9', Gen.integer.tuple9, (t) {
      final d = Codec.tuple9(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple10', Gen.integer.tuple10, (t) {
      final d = Codec.tuple10(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });
    forAll('tuple11', Gen.integer.tuple11, (t) {
      final d = Codec.tuple11(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple12', Gen.integer.tuple12, (t) {
      final d = Codec.tuple12(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple13', Gen.integer.tuple13, (t) {
      final d = Codec.tuple13(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple14', Gen.integer.tuple14, (t) {
      final d = Codec.tuple14(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple15', Gen.integer.tuple15, (t) {
      final d = Codec.tuple15(
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
        Codec.integer,
      );
      expect(d.decode(d.encode(t)), t.asRight<DecodingFailure>());
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

sealed class Animal {
  const Animal();

  static final Codec<Animal> codec =
      Codec.oneOf(Dog.codec, Cat.codec, HermitCrab.codec);
}

final class Dog extends Animal {
  final String name;
  final int age;
  final int tailWags;

  const Dog(this.name, this.age, this.tailWags);

  static final codec = (
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'tailWags'.as(Codec.integer)
  ).product(Dog.new, (d) => (d.name, d.age, d.tailWags));

  static final gen = (Gen.alphaNumString(10), Gen.integer, Gen.integer)
      .tupled
      .map(Dog.new.tupled);

  @override
  bool operator ==(Object other) {
    if (other is! Dog) {
      return false;
    } else if (other.name != name || other.age != age) {
      return false;
    } else {
      return true;
    }
  }

  @override
  int get hashCode => Object.hash(name, age);
}

final class Cat extends Animal {
  final String name;
  final int age;
  final int lives;

  const Cat(this.name, this.age, this.lives);

  @override
  bool operator ==(Object other) {
    if (other is! Cat) {
      return false;
    } else if (other.name != name || other.age != age || other.lives != lives) {
      return false;
    } else {
      return true;
    }
  }

  @override
  int get hashCode => Object.hash(name, age, lives);

  static final codec = (
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'lives'.as(Codec.integer)
  ).product(Cat.new, (c) => (c.name, c.age, c.lives));

  static final gen = (Gen.alphaNumString(10), Gen.integer, Gen.integer)
      .tupled
      .map(Cat.new.tupled);
}

final class HermitCrab extends Animal {
  final String name;
  final int age;
  final int shells;

  const HermitCrab(this.name, this.age, this.shells);

  @override
  bool operator ==(Object other) {
    if (other is! HermitCrab) {
      return false;
    } else if (other.name != name ||
        other.age != age ||
        other.shells != shells) {
      return false;
    } else {
      return true;
    }
  }

  @override
  int get hashCode => Object.hash(name, age, shells);

  static final codec = (
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'shells'.as(Codec.integer)
  ).product(HermitCrab.new, (hc) => (hc.name, hc.age, hc.shells));

  static final gen = (Gen.alphaNumString(10), Gen.integer, Gen.integer)
      .tupled
      .map(HermitCrab.new.tupled);
}
