import 'package:meta/meta.dart';
import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Binary Codecs', () {
    testCodec('int8', genInt8, int8);
    testCodec('int16', genInt16, int16);
    testCodec('int24', genInt24, int24);
    testCodec('int32', genInt32, int32);
    testCodec('int64', genInt64, int64);

    testCodec('int8L', genInt8, int8L);
    testCodec('int16L', genInt16, int16L);
    testCodec('int24L', genInt24, int24L);
    testCodec('int32L', genInt32, int32L);
    testCodec('int64L', genInt64, int64L);

    testCodec('uint8', genUint8, uint8);
    testCodec('uint16', genUint16, uint16);
    testCodec('uint24', genUint24, uint24);
    testCodec('uint32', genUint32, uint32);

    testCodec('uint8L', genUint8, uint8L);
    testCodec('uint16L', genUint16, uint16L);
    testCodec('uint24L', genUint24, uint24L);
    testCodec('uint32L', genUint32, uint32L);

    testVariableInt('integer', genIntN(true), (bits) => integer(bits));
    testVariableInt('integerL', genIntN(true), (bits) => integerL(bits));

    testVariableInt('uinteger', genIntN(false), (bits) => uinteger(bits));
    testVariableInt('uintegerL', genIntN(false), (bits) => uintegerL(bits));

    testCodec('float32', genFloat32, float32, (f) => closeTo(f, 1)); // sigh

    testCodec('ascii', Gen.stringOf(Gen.asciiChar), ascii);
    testCodec('ascii32', Gen.stringOf(Gen.asciiChar), ascii32);
    testCodec('ascii32L', Gen.stringOf(Gen.asciiChar), ascii32L);

    testCodec('utf8', Gen.stringOf(Gen.unicodeChar), utf8);
    testCodec('utf8_32', Gen.stringOf(Gen.unicodeChar), utf8_32);
    testCodec('utf8_32L', Gen.stringOf(Gen.unicodeChar), utf8_32L);

    testCodec(
      'cstring',
      Gen.stringOf(Gen.chooseInt(1, 127).map(String.fromCharCode)),
      cstring,
    );

    testCodec('listOfN', Gen.listOf(100, Gen.chooseInt(-100, 100)),
        listOfN(int8, int32));

    testCodec('ilistOfN', Gen.ilistOf(100, Gen.chooseInt(-100, 100)),
        ilistOfN(int8, int32));

    forAll('peek', Gen.stringOf(Gen.asciiChar), (str) {
      final codec = peek(ascii32);
      final result = codec.encode(str).flatMap((a) => codec.decode(a));

      result.fold(
        (err) => fail('peek codec failed on input [$str]: $err'),
        (a) {
          expect(a.value, str);
          expect(a.remainder,
              codec.encode(str).getOrElse(() => fail('peek encode failed')));
        },
      );
    });

    testCodec('option', Gen.option(Gen.positiveInt), option(boolean, int32));

    testCodec('either', Gen.either(Gen.positiveInt, Gen.boolean),
        either(boolean, int32, boolean));

    forAll('byteAligned', Gen.chooseInt(0, 8).map((a) => BitVector.low(a)),
        (bv) {
      final codec = byteAligned(bits);

      codec.encode(bv).fold(
        (err) => fail('byteAligned codec failed on input [$bv]: $err'),
        (bv) {
          expect(bv.size % 8 == 0, isTrue);
        },
      );
    });
  });
}

Gen<int> genInt8 = Gen.chooseInt(-128, 127);
Gen<int> genInt16 = Gen.chooseInt(-32768, 32767);
Gen<int> genInt24 = Gen.chooseInt(-8388608, 8388607);
Gen<int> genInt32 = Gen.chooseInt(-2147483648, 2147483647);
Gen<int> genInt64 = Gen.chooseInt(-2147483648, 2147483647);
// Gen<int> genInt64 = Gen.chooseInt(-9223372036854775808, 9223372036854775807);

Gen<int> genUint8 = Gen.chooseInt(0, 2 ^ 8);
Gen<int> genUint16 = Gen.chooseInt(0, 2 ^ 16);
Gen<int> genUint24 = Gen.chooseInt(0, 2 ^ 24);
Gen<int> genUint32 = Gen.chooseInt(0, 2 ^ 32);
// Gen<int> genUint64 = Gen.chooseInt(0, 2 ^ 32);

// floating point math FTW
Gen<double> genFloat32 = Gen.chooseDouble(-10000000.0, 10000000.0);

Gen<(int, int)> genIntN(bool signed) => Gen.chooseInt(2, 32).flatMap((bits) {
      return (
        Gen.constant(bits),
        Gen.chooseInt(signed ? -(1 << (bits - 1)) : 0,
            (1 << (signed ? bits - 1 : bits)) - 1),
      ).tupled;
    });

@isTest
void testCodec<A>(String description, Gen<A> gen, Codec<A> codec,
    [Function1<A, Matcher>? customMatcher]) {
  forAll(description, gen, (n) {
    final result = codec.encode(n).flatMap((a) => codec.decode(a));

    result.fold(
      (err) => fail('$codec failed on input [$n]: $err'),
      (result) {
        expect(result.value, customMatcher?.call(n) ?? n);
        expect(result.remainder.isEmpty, isTrue);
      },
    );
  });
}

@isTest
void testVariableInt(String description, Gen<(int, int)> gen,
    Function1<int, Codec<int>> codecC) {
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
