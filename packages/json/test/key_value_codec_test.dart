import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
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

    Gen.integer.tuple16.forAll('tuple16', (t) {
      final codecN = KeyValueCodec.tuple16(
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
        KeyValueCodec('', Codec.integer).withKey('p'),
      );
      expect(codecN.decode(codecN.encode(t)), t.asRight<DecodingFailure>());
    });

    KeyValueCodec<int> kv(String k) => KeyValueCodec('', Codec.integer).withKey(k);

    test('tuple17', () {
      final codec = KeyValueCodec.tuple17(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    test('tuple18', () {
      final codec = KeyValueCodec.tuple18(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'), kv('r'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    test('tuple19', () {
      final codec = KeyValueCodec.tuple19(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'), kv('r'), kv('s'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    test('tuple20', () {
      final codec = KeyValueCodec.tuple20(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'), kv('r'), kv('s'), kv('t'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    test('tuple21', () {
      final codec = KeyValueCodec.tuple21(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'), kv('r'), kv('s'), kv('t'), kv('u'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    test('tuple22', () {
      final codec = KeyValueCodec.tuple22(kv('a'), kv('b'), kv('c'), kv('d'), kv('e'), kv('f'), kv('g'), kv('h'), kv('i'), kv('j'), kv('k'), kv('l'), kv('m'), kv('n'), kv('o'), kv('p'), kv('q'), kv('r'), kv('s'), kv('t'), kv('u'), kv('v'));
      const t = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22);
      expect(codec.decode(codec.encode(t)), t.asRight<DecodingFailure>());
    });

    group('error handling', () {
      final codec = KeyValueCodec.tuple2(kv('a'), kv('b'));

      test('wrong type', () {
        expect(codec.decode(Json.True), isLeft());
      });

      test('missing field', () {
        expect(codec.decode(Json.obj([('a', Json.number(1))])), isLeft());
      });
    });

    group('instance methods', () {
      test('xmap', () {
        final codec = kv('x').xmap((i) => i.toString(), (s) => int.parse(s));
        expect(codec.decode(codec.encode('42')), '42'.asRight<DecodingFailure>());
      });

      test('iemap', () {
        final codec = kv('x').iemap(
          (i) => i >= 0 ? i.asRight<String>() : 'negative'.asLeft<int>(),
          (i) => i,
        );
        expect(codec.decode(codec.encode(5)), 5.asRight<DecodingFailure>());
        expect(codec.decode(Json.obj([('x', Json.number(-1))])), isLeft());
      });

      test('nullable', () {
        final codec = kv('x').nullable();
        expect(codec.decode(codec.encode(42)), (42 as int?).asRight<DecodingFailure>());
        expect(codec.decode(codec.encode(null)), (null as int?).asRight<DecodingFailure>());
      });

      test('optional', () {
        final codec = kv('x').optional();
        expect(codec.decode(codec.encode(const Some(42))), const Some(42).asRight<DecodingFailure>());
        expect(codec.decode(codec.encode(none<int>())), none<int>().asRight<DecodingFailure>());
      });
    });
  });
}
