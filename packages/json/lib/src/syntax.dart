import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

extension Codec2Ops<A, B> on ((String, Codec<A>), (String, Codec<B>)) {
  Codec<C> product<C>(
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) =>
      Codec.product2(
        KeyValueCodec($1.$1, $1.$2),
        KeyValueCodec($2.$1, $2.$2),
        apply,
        tupled,
      );
}

extension Codec2KVOps<A, B> on (KeyValueCodec<A>, KeyValueCodec<B>) {
  Codec<C> product<C>(
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) =>
      Codec.product2($1, $2, apply, tupled);
}

extension Codec3Ops<A, B, C> on (
  (String, Codec<A>),
  (String, Codec<B>),
  (String, Codec<C>)
) {
  Codec<D> product<D>(
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) =>
      Codec.product3(
        KeyValueCodec($1.$1, $1.$2),
        KeyValueCodec($2.$1, $2.$2),
        KeyValueCodec($3.$1, $3.$2),
        apply,
        tupled,
      );
}

extension Codec3KVOps<A, B, C> on (
  KeyValueCodec<A>,
  KeyValueCodec<B>,
  KeyValueCodec<C>
) {
  Codec<D> product<D>(
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) =>
      Codec.product3($1, $2, $3, apply, tupled);
}

final class Pet {
  final String name;
  final int age;
  final double weight;

  const Pet(this.name, this.age, this.weight);

  static final codecA = Codec.product3(
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'weight'.as(Codec.dubble),
    Pet.new,
    (p) => (p.name, p.age, p.weight),
  );

  static final codecB = (
    ('name', Codec.string),
    ('age', Codec.integer),
    ('weight', Codec.dubble)
  ).product(Pet.new, (p) => (p.name, p.age, p.weight));

  static final codecC = (
    'name'.as(Codec.string),
    'age'.as(Codec.integer),
    'weight'.as(Codec.dubble),
  ).product(Pet.new, (p) => (p.name, p.age, p.weight));
}
