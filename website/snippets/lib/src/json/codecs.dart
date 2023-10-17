// ignore_for_file: avoid_print, unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// codecs-1

final class User {
  final String name;
  final int age;
  final IList<Pet> pets;

  const User(this.name, this.age, this.pets);
}

final class Pet {
  final String name;
  final Option<double> weight;
  final PetType type;

  const Pet(this.name, this.weight, this.type);
}

enum PetType { mammal, reptile, other }

// codecs-1

void snippet2() {
  // codecs-2
  final petTypeDecoder = Decoder.integer.map((n) => PetType.values[n]);

  final petDecoder = Decoder.product3(
    Decoder.string.at('name'),
    Decoder.dubble.optional().at('weight'),
    petTypeDecoder.at('type'),
    (name, weight, type) => Pet(name, weight, type),
  );

  final userDecoder = Decoder.product3(
    Decoder.string.at('name'),
    Decoder.integer.at('age'),
    Decoder.ilist(petDecoder).at('pets'),
    (name, age, pets) => User(name, age, pets),
  );

  const jsonStr = '''
  {
    "name": "Joe",
    "age": 20,
    "pets": [
      { "name": "Ribs", "weight": 22.1, "type": 0 },
      { "name": "Lizzy", "type": 11 }
    ]
  }
  ''';

  print(Json.decode(jsonStr, userDecoder));
  // Right(Instance of 'User')

  // codecs-2
}

void snippet3() {
  // codecs-3
  final petTypeDecoder = Decoder.integer.map((n) => PetType.values[n]);

  print(Json.decode('0', petTypeDecoder)); // Right(PetType.mammal)
  print(Json.decode('1', petTypeDecoder)); // Right(PetType.reptile)
  print(Json.decode('2', petTypeDecoder)); // Right(PetType.other)
  print(Json.decode('100', petTypeDecoder)); // ???

  // codecs-3
}

void snippet4() {
  // codecs-4
  // Solution using .emap
  final petTypeDecoderA = Decoder.integer.emap(
    (n) => Either.cond(() => 0 <= n && n < PetType.values.length,
        () => PetType.values[n], () => 'Invalid value index for PetType: $n'),
  );

  print(Json.decode('100', petTypeDecoderA));
  // Left(DecodingFailure(CustomReason(Invalid PetType index: 100), None))

  // codecs-4
}

// codecs-enumeration
// Uses Enum.index to look up instance
final petTypeDecoderByIndex = Decoder.enumerationByIndex(PetType.values);

// Uses Enum.name to look up instance
final petTypeDecoderByName = Decoder.enumerationByName(PetType.values);

// codecs-enumeration

void snippet5() {
  // codecs-5
  final petTypeEncoder = Encoder.instance((PetType t) => Json.number(t.index));
  // Alternative PetType solution
  final petTypeEncoderAlt = Encoder.integer.contramap<PetType>((t) => t.index);

  final petEncoder = Encoder.instance(
    (Pet p) => Json.obj(
      [
        ('name', Json.str(p.name)),
        ('weight', p.weight.fold(() => Json.Null, (w) => Json.number(w))),
        ('type', petTypeEncoder.encode(p.type)),
      ],
    ),
  );

  final userEncoder = Encoder.instance(
    (User u) => Json.obj(
      [
        ('name', Json.str(u.name)),
        ('age', Json.number(u.age)),
        ('pets', Json.arrI(u.pets.map(petEncoder.encode))),
      ],
    ),
  );

  print(
    userEncoder
        .encode(
          User(
            'Henry',
            40,
            ilist([
              const Pet('Ribs', Some(22.0), PetType.mammal),
              const Pet('Lizzy', None(), PetType.reptile),
            ]),
          ),
        )
        .printWith(Printer.spaces2),
  );
  // {
  //   "name" : "Henry",
  //   "age" : 40,
  //   "pets" : [
  //     {
  //       "name" : "Ribs",
  //       "weight" : 22.0,
  //       "type" : 0
  //     },
  //     {
  //       "name" : "Lizzy",
  //       "weight" : null,
  //       "type" : 1
  //     }
  //   ]
  // }
  // codecs-5
}

void snippet6() {
  // codecs-6
  final petTypeCodec = Codec.integer.iemap(
    (n) => Either.cond(
      () => 0 <= n && n < PetType.values.length,
      () => PetType.values[n],
      () => 'Invalid PetType index: $n',
    ),
    (petType) => petType.index,
  );

  final petCodec = Codec.product3(
    'name'.as(Codec.string), // Same as: Codec.string.atField('name'),
    'weight'.as(Codec.dubble).optional(),
    'type'.as(petTypeCodec),
    Pet.new,
    (p) => (p.name, p.weight, p.type),
  );

  final userCodec = Codec.product3(
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'pets'.as(Codec.ilist(petCodec)),
    User.new, // Constructor tear-off
    (u) => (u.name, u.age, u.pets), // Describe how to turn user into tuple
  );

  const jsonStr = '''
  {
    "name": "Joe",
    "age": 20,
    "pets": [
      { "name": "Ribs", "weight": 22.1, "type": 0 },
      { "name": "Lizzy", "type": 11 }
    ]
  }
  ''';

  // Codecs can decode and encode
  final user = Json.decode(jsonStr, userCodec);
  final str = userCodec.encode(const User('name', 20, IList.nil()));

  // codecs-6
}

void foo6() {}
