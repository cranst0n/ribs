import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/discriminated_codec.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

sealed class Animal {
  const Animal();
}

class Dog extends Animal {
  final int age;

  const Dog(this.age);

  static final codec = Codec.product2(
    constant(ByteVector.fromList([1, 2]).bits),
    int8,
    (_, age) => Dog(age),
    (Dog dog) => (null, dog.age),
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
    final codec = DiscriminatorCodec.typecases<int, Animal>(
        uint8,
        ilist([
          (7, Dog.codec),
          (1, Cat.codec),
          (3, Lion.codec),
        ]));

    expect(
      const Dog(2),
      codec
          .encode(const Dog(2))
          .flatMap((a) => codec.decode(a))
          .getOrElse(() => fail('discriminated codec failed'))
          .value,
    );

    final roundTripLion = codec
        .encode(const Lion())
        .flatMap((a) => codec.decode(a))
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
}
