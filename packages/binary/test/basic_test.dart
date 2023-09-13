import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

sealed class Animal {
  const Animal();

  static final codec = discriminatedBy(
      uint8,
      imap({
        7: Dog.codec,
        1: Cat.codec,
        3: Lion.codec,
      }));
}

class Dog extends Animal {
  final int age;

  const Dog(this.age);

  static final codec = Codec.product2(
    constant(ByteVector.fromList([1, 2]).bits),
    int8,
    (_, age) => Dog(age),
    (Dog dog) => (Unit(), dog.age),
  );

  @override
  String toString() => 'Dog($age)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Dog && other.age == age;

  @override
  int get hashCode => age.hashCode;
}

class Cat extends Animal {
  const Cat();
  static final codec = constant(ByteVector.fromList([1, 2]).bits)
      .xmap((a) => const Cat(), (_) => Unit());
}

class Lion extends Cat {
  const Lion();
  static final codec = constant(ByteVector.fromList([1, 2]).bits)
      .xmap((a) => const Lion(), (_) => Unit());
}

void main() {
  test('uint8', () {
    final codec = uint8;

    final value = codec
        .decode(ByteVector.fromBin('101').getOrElse(() => fail('boom')).bits)
        .getOrElse(() => fail('boom'))
        .value;

    final roundTrip = codec
        .encode(value)
        .flatMap((a) => codec.decode(a))
        .getOrElse(() => fail('uint8 round trip failed.'));

    expect(roundTrip.value, 5);
    expect(roundTrip.remainder, isEmpty);
  });

  test('discriminated', () {
    expect(
      const Dog(2),
      Animal.codec
          .encode(const Dog(2))
          .flatMap((a) => Animal.codec.decode(a))
          .getOrElse(() => fail('discriminated codec failed'))
          .value,
    );

    final roundTripLion = Animal.codec
        .encode(const Lion())
        .flatMap((a) => Animal.codec.decode(a))
        .getOrElse(() => fail('discriminated codec failed.'));

    expect(roundTripLion.value, isA<Lion>());
    expect(roundTripLion.remainder, isEmpty);
  });

  test('prepend', () {
    final codec = Dog.codec
        .prepend((dog) => provide(BitVector.low(dog.age)))
        .xmap((a) => a.$1, (a) => (a, BitVector.low(a.age)));

    expect(
      const Dog(2),
      codec
          .encode(const Dog(2))
          .flatMap((a) => Dog.codec.decode(a))
          .getOrElse(() => fail('codec.prepend fialed'))
          .value,
    );
  });

  test('update', () {
    final res = BitVector.high(6).update(1, false).update(4, false);

    expect(res.toBinString(), '101101');
  });

  test('BitVector.bits', () {
    final bv = BitVector.bits([false, false, true, false, true, false]);

    expect(bv.toBinString(), '001010');
  });

  test('StreamDecoder', () async {
    final animalBits = animalStream.expand(
      (animal) {
        final bits = Animal.codec
            .encode(animal)
            .getOrElse(() => throw Exception('Animal.encode failed'));

        // Split into uneven chunks
        final (a, b) = bits.splitAt(bits.size ~/ 2);
        final (a1, a2) = a.splitAt(a.size ~/ 3);
        final (b1, b2) = b.splitAt(b.size ~/ 4);

        return [a1, a2, b1, b2];
      },
    );

    const n = 20;
    int count = 0;

    final animals = animalBits.transform(StreamDecoder(Animal.codec)).take(n);

    await for (final _ in animals) {
      count += 1;
    }

    expect(count, n);
  });

  test('StreamEncoder', () async {
    final roundTrip = animalStream
        .transform(StreamEncoder(Animal.codec))
        .transform(StreamDecoder(Animal.codec));

    const n = 44;
    int count = 0;

    final animals = roundTrip.take(n);

    await for (final _ in animals) {
      count += 1;
    }

    expect(count, n);
  });
}

Stream<Animal> get animalStream =>
    Stream.periodic(Duration.zero, id).map((age) => switch (age) {
          _ when age.isEven => Dog(age),
          _ when age % 3 == 0 => const Cat(),
          _ => const Lion(),
        });
