import 'dart:math';
import 'package:meta/meta.dart';
import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Binary Codecs', () {
    testCodec('bits', bitVector, Codec.bits);
    testCodec(
      'bitsStrict',
      bitVector.map((a) => a.concat(BitVector.low(100)).take(100)),
      Codec.bitsStrict(100),
    );
    testCodec('boolean', Gen.boolean, Codec.boolean);
    testCodec('booleanN', Gen.boolean, Codec.booleanN(2));
    testCodec('bytes', byteVector, Codec.bytes);
    testCodec(
      'bytesStrict',
      byteVector.map((a) => a.concat(ByteVector.low(16)).take(16)),
      Codec.bytesStrict(16),
    );
    testCodec('int4', genInt4, Codec.int4);
    testCodec('int8', genInt8, Codec.int8);
    testCodec('int16', genInt16, Codec.int16);
    testCodec('int24', genInt24, Codec.int24);
    testCodec('int32', genInt32, Codec.int32);
    testCodec('int64', genInt64, Codec.int64, testOn: '!browser');

    testCodec('int4L', genInt4, Codec.int4L);
    testCodec('int8L', genInt8, Codec.int8L);
    testCodec('int16L', genInt16, Codec.int16L);
    testCodec('int24L', genInt24, Codec.int24L);
    testCodec('int32L', genInt32, Codec.int32L);
    testCodec('int64L', genInt64, Codec.int64L, testOn: '!browser');

    testCodec('uint4', genUint4, Codec.uint4);
    testCodec('uint8', genUint8, Codec.uint8);
    testCodec('uint16', genUint16, Codec.uint16);
    testCodec('uint24', genUint24, Codec.uint24);
    testCodec('uint32', genUint32, Codec.uint32);

    testCodec('uint4L', genUint4, Codec.uint4L);
    testCodec('uint8L', genUint8, Codec.uint8L);
    testCodec('uint16L', genUint16, Codec.uint16L);
    testCodec('uint24L', genUint24, Codec.uint24L);
    testCodec('uint32L', genUint32, Codec.uint32L);

    testVariableInt('integer', genIntN(true), (bits) => Codec.integer(bits));
    testVariableInt('integerL', genIntN(true), (bits) => Codec.integerL(bits));

    testVariableInt('uinteger', genIntN(false), (bits) => Codec.uinteger(bits));
    testVariableInt('uintegerL', genIntN(false), (bits) => Codec.uintegerL(bits));

    testCodec('float32', genFloat32, Codec.float32, customMatcher: (f) => closeTo(f, 1));
    testCodec('float64', genFloat64, Codec.float64, customMatcher: (f) => closeTo(f, 1));

    testCodec('float32L', genFloat32, Codec.float32L, customMatcher: (f) => closeTo(f, 1));
    testCodec('float64L', genFloat64, Codec.float64L, customMatcher: (f) => closeTo(f, 1));

    testCodec('ascii', Gen.stringOf(Gen.asciiChar), Codec.ascii);
    testCodec('ascii32', Gen.stringOf(Gen.asciiChar), Codec.ascii32);
    testCodec('ascii32L', Gen.stringOf(Gen.asciiChar), Codec.ascii32L);

    testCodec('utf8', Gen.stringOf(Gen.asciiChar), Codec.utf8);
    testCodec('utf8_32', Gen.stringOf(Gen.asciiChar), Codec.utf8_32);
    testCodec('utf8_32L', Gen.stringOf(Gen.asciiChar), Codec.utf8_32L);

    testCodec('utf16', Gen.stringOf(Gen.asciiChar), Codec.utf16);
    testCodec('utf16_32', Gen.stringOf(Gen.asciiChar), Codec.utf16_32);
    testCodec('utf16_32L', Gen.stringOf(Gen.asciiChar), Codec.utf16_32L);

    testCodec(
      'cstring',
      Gen.stringOf(Gen.chooseInt(1, 127).map(String.fromCharCode)),
      Codec.cstring,
    );

    testCodec(
      'listOfN',
      Gen.listOfN(100, Gen.chooseInt(-100, 100)),
      Codec.listOfN(Codec.int8, Codec.int32),
    );

    testCodec(
      'ilistOfN',
      Gen.ilistOfN(100, Gen.chooseInt(-100, 100)),
      Codec.ilistOfN(Codec.int8, Codec.int32),
    );

    forAll('peek', Gen.stringOf(Gen.asciiChar), (str) {
      final codec = Codec.peek(Codec.ascii32);
      final result = codec.encode(str).flatMap((a) => codec.decode(a));

      result.fold(
        (err) => fail('peek codec failed on input [$str]: $err'),
        (a) {
          expect(a.value, str);
          expect(a.remainder, codec.encode(str).getOrElse(() => fail('peek encode failed')));
        },
      );
    });

    testCodec('option', Gen.option(genInt32), Codec.int32.optional(Codec.boolean));

    testCodec(
      'either',
      Gen.either(genInt32, Gen.boolean),
      Codec.either(Codec.boolean, Codec.int32, Codec.boolean),
    );

    forAll('byteAligned', Gen.chooseInt(0, 8).map((a) => BitVector.low(a)), (bv) {
      final codec = Codec.byteAligned(Codec.bits);

      codec.encode(bv).fold(
        (err) => fail('byteAligned codec failed on input [$bv]: $err'),
        (bv) {
          expect(bv.size % 8 == 0, isTrue);
        },
      );
    });

    testCodec(
      'bitsN',
      Gen.chooseInt(0, 8)
          .flatMap((a) => Gen.listOfN(a, Gen.charSample('01')))
          .map((a) => a.join())
          .map(BitVector.fromValidBin)
          .map((a) => a.padTo(8)),
      Codec.bitsN(8),
    );

    forAll('ignore', Gen.chooseInt(0, 100), (nBits) {
      final codec = Codec.ignore(nBits);

      final encoded = codec.encode(Unit());
      final decoded = encoded.flatMap(codec.decode);

      encoded.fold(
        (err) => fail('ignore encode failed for $nBits bits: $err'),
        (a) => expect(a, BitVector.low(nBits)),
      );

      decoded.fold(
        (err) => fail('ignore decode failed for $nBits bits: $err'),
        (a) => expect(a.remainder.isEmpty, isTrue),
      );
    });
  });
}

Gen<int> genInt4 = Gen.chooseInt(-8, 7);
Gen<int> genInt8 = Gen.chooseInt(-128, 127);
Gen<int> genInt16 = Gen.chooseInt(-32768, 32767);
Gen<int> genInt24 = Gen.chooseInt(-8388608, 8388607);
Gen<int> genInt32 = Gen.chooseInt(-2147483648, 2147483647);

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
Gen<int> genInt64 = Gen.chooseInt(
  kIsWeb ? -2147483648 : -4.611686e18.round(),
  kIsWeb ? 2147483647 : 4.611686e18.round(),
);

Gen<int> genUint4 = Gen.chooseInt(0, 15);
Gen<int> genUint8 = Gen.chooseInt(0, 255);
Gen<int> genUint16 = Gen.chooseInt(0, 65535);
Gen<int> genUint24 = Gen.chooseInt(0, 16777215);
Gen<int> genUint32 = Gen.chooseInt(0, 4294967295);

// floating point math FTW
Gen<double> genFloat32 = Gen.chooseDouble(-10000000.0, 10000000.0);
Gen<double> genFloat64 = Gen.chooseDouble(-100000000.0, 100000000.0);

Gen<(int, int)> genIntN(bool signed) => Gen.chooseInt(2, 32).flatMap((bits) {
  final min = signed ? -pow(2, bits - 1).toInt() : 0;
  final max = (pow(2, signed ? bits - 1 : bits).toInt()) - 1;
  return (
    Gen.constant(bits),
    Gen.chooseInt(min, max),
  ).tupled;
});

@isTest
void testCodec<A>(
  String description,
  Gen<A> gen,
  Codec<A> codec, {
  Function1<A, Matcher>? customMatcher,
  String? testOn,
}) {
  forAll(description, gen, (n) {
    final result = codec.encode(n).flatMap((a) => codec.decode(a));

    result.fold(
      (err) => fail('$codec failed on input [$n]: $err'),
      (result) {
        expect(result.value, customMatcher?.call(n) ?? n);
        expect(result.remainder.isEmpty, isTrue);
      },
    );
  }, testOn: testOn);
}

@isTest
void testVariableInt(String description, Gen<(int, int)> gen, Function1<int, Codec<int>> codecC) {
  forAll(description, gen, (t) {
    final (bits, n) = t;
    final codec = codecC(bits);

    final result = codec.encode(n).flatMap((a) => codec.decode(a));

    result.fold(
      (err) => fail('$codec failed on input [$n]: $err'),
      (result) {
        expect(result.value, n);
        expect(result.remainder.isEmpty, isTrue);
      },
    );
  });
}
