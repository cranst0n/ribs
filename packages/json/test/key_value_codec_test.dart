import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  group('KeyValueCodec', () {
    Gen.integer.tuple2.forAll('tuple2', (t) {
      final codecN = KeyValueCodec.tuple2(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
      );
      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple3.forAll('tuple3', (t) {
      final codecN = KeyValueCodec.tuple3(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple4.forAll('tuple4', (t) {
      final codecN = KeyValueCodec.tuple4(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple5.forAll('tuple5', (t) {
      final codecN = KeyValueCodec.tuple5(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple6.forAll('tuple6', (t) {
      final codecN = KeyValueCodec.tuple6(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple7.forAll('tuple7', (t) {
      final codecN = KeyValueCodec.tuple7(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple8.forAll('tuple8', (t) {
      final codecN = KeyValueCodec.tuple8(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple9.forAll('tuple9', (t) {
      final codecN = KeyValueCodec.tuple9(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple10.forAll('tuple10', (t) {
      final codecN = KeyValueCodec.tuple10(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple11.forAll('tuple11', (t) {
      final codecN = KeyValueCodec.tuple11(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
        KeyValueCodec('', Codec.integer).withKey('k'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple12.forAll('tuple12', (t) {
      final codecN = KeyValueCodec.tuple12(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
        KeyValueCodec('', Codec.integer).withKey('k'),
        KeyValueCodec('', Codec.integer).withKey('l'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple13.forAll('tuple13', (t) {
      final codecN = KeyValueCodec.tuple13(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
        KeyValueCodec('', Codec.integer).withKey('k'),
        KeyValueCodec('', Codec.integer).withKey('l'),
        KeyValueCodec('', Codec.integer).withKey('m'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple14.forAll('tuple14', (t) {
      final codecN = KeyValueCodec.tuple14(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
        KeyValueCodec('', Codec.integer).withKey('k'),
        KeyValueCodec('', Codec.integer).withKey('l'),
        KeyValueCodec('', Codec.integer).withKey('m'),
        KeyValueCodec('', Codec.integer).withKey('n'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    Gen.integer.tuple15.forAll('tuple15', (t) {
      final codecN = KeyValueCodec.tuple15(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
        KeyValueCodec('', Codec.integer).withKey('f'),
        KeyValueCodec('', Codec.integer).withKey('g'),
        KeyValueCodec('', Codec.integer).withKey('h'),
        KeyValueCodec('', Codec.integer).withKey('i'),
        KeyValueCodec('', Codec.integer).withKey('j'),
        KeyValueCodec('', Codec.integer).withKey('k'),
        KeyValueCodec('', Codec.integer).withKey('l'),
        KeyValueCodec('', Codec.integer).withKey('m'),
        KeyValueCodec('', Codec.integer).withKey('n'),
        KeyValueCodec('', Codec.integer).withKey('o'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });
  });
}
