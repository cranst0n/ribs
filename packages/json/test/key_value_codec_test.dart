import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  group('KeyValueCodec', () {
    forAll('tuple2', Gen.integer.tuple2, (t) {
      final codecN = KeyValueCodec.tuple2(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
      );
      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple3', Gen.integer.tuple3, (t) {
      final codecN = KeyValueCodec.tuple3(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple4', Gen.integer.tuple4, (t) {
      final codecN = KeyValueCodec.tuple4(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple5', Gen.integer.tuple5, (t) {
      final codecN = KeyValueCodec.tuple5(
        KeyValueCodec('', Codec.integer).withKey('a'),
        KeyValueCodec('', Codec.integer).withKey('b'),
        KeyValueCodec('', Codec.integer).withKey('c'),
        KeyValueCodec('', Codec.integer).withKey('d'),
        KeyValueCodec('', Codec.integer).withKey('e'),
      );

      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    forAll('tuple6', Gen.integer.tuple6, (t) {
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

    forAll('tuple7', Gen.integer.tuple7, (t) {
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

    forAll('tuple8', Gen.integer.tuple8, (t) {
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

    forAll('tuple9', Gen.integer.tuple9, (t) {
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

    forAll('tuple10', Gen.integer.tuple10, (t) {
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

    forAll('tuple11', Gen.integer.tuple11, (t) {
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

    forAll('tuple12', Gen.integer.tuple12, (t) {
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

    forAll('tuple13', Gen.integer.tuple13, (t) {
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

    forAll('tuple14', Gen.integer.tuple14, (t) {
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

    forAll('tuple15', Gen.integer.tuple15, (t) {
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
