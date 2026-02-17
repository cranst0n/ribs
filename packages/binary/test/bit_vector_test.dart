import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  BitVector bin(String str) => BitVector.fromValidBin(str);
  BitVector hex(String str) => BitVector.fromValidHex(str);

  forAll3('hashCode / equality', bitVector, bitVector, Gen.integer, (b, b2, n) {
    expect(b.take(n).concat(b.drop(n)), b);

    expect(b.take(n).concat(b.drop(n)).hashCode, b.hashCode);

    if (b.take(3) == b2.take(3)) {
      expect(b.take(3).hashCode, b2.take(3).hashCode);
    }
  });

  test('fromBin', () {
    expect(BitVector.fromBinDescriptive('0b 0000 0101').isRight, isTrue);
    expect(BitVector.fromBinDescriptive('0000 0101').isRight, isTrue);
    expect(BitVector.fromBinDescriptive('1010 1101').isRight, isTrue);

    expect(BitVector.fromBinDescriptive('0000 a0101').isLeft, isTrue);
  });

  test('fromHex', () {
    expect(BitVector.fromHexDescriptive('dead beef').isRight, isTrue);
    expect(BitVector.fromHexDescriptive('0x1234').isRight, isTrue);

    expect(BitVector.fromHexDescriptive('0x1234 zzzz').isLeft, isTrue);
  });

  test('1-bit vectors', () {
    expect(BitVector.zero.head, isFalse);
    expect(BitVector.one.head, isTrue);
    expect(BitVector.bit(false).head, isFalse);
    expect(BitVector.bit(true).head, isTrue);
  });

  test('construct via high', () {
    expect(BitVector.high(1).bytes, ByteVector([0x80]));
    expect(BitVector.high(2).bytes, ByteVector([0xc0]));
    expect(BitVector.high(3).bytes, ByteVector([0xe0]));
    expect(BitVector.high(4).bytes, ByteVector([0xf0]));
    expect(BitVector.high(5).bytes, ByteVector([0xf8]));
    expect(BitVector.high(6).bytes, ByteVector([0xfc]));
    expect(BitVector.high(7).bytes, ByteVector([0xfe]));
    expect(BitVector.high(8).bytes, ByteVector([0xff]));
    expect(BitVector.high(9).bytes, ByteVector([0xff, 0x80]));
    expect(BitVector.high(10).bytes, ByteVector([0xff, 0xc0]));
  });

  test('empty toByteVector', () {
    expect(BitVector.empty.bytes, ByteVector.empty);
  });

  test('indexing', () {
    final vec = BitVector.fromByteVector(ByteVector([0xf0, 0x0f]));
    expect(vec(0), isTrue);
    expect(vec(1), isTrue);
    expect(vec(2), isTrue);
    expect(vec(3), isTrue);
    expect(vec(4), isFalse);
    expect(vec(5), isFalse);
    expect(vec(6), isFalse);
    expect(vec(7), isFalse);
    expect(vec(8), isFalse);
    expect(vec(9), isFalse);
    expect(vec(10), isFalse);
    expect(vec(11), isFalse);
    expect(vec(12), isTrue);
    expect(vec(13), isTrue);
    expect(vec(14), isTrue);
    expect(vec(15), isTrue);
  });

  forAll(
    'BigInt conversions - consistent with toInt without options',
    Gen.chooseInt(-1, 1000000),
    (n) {
      expect(BitVector.fromInt(n).toBigInt(), BigInt.from(n));
    },
  );

  forAll('BigInt conversions - verify sign handling', Gen.integer, (n) {
    expect(
      BitVector.fromInt(n).toBigInt(signed: false),
      n >= 0 ? BigInt.from(n) : BigInt.from(n).toUnsigned(Integer.Size),
    );
  });

  test('BigInt conversions - bigger than int', () {
    final bits = hex('01 ffff ffff ffff ffff');
    expect(
      bits.toBigInt(),
      BigInt.parse('1FFFFFFFFFFFFFFFF', radix: 16),
    );
  });

  forAll('BigInt conversions - roundtrip', Gen.bigInt, (n) {
    expect(BitVector.fromBigInt(n, size: Some(n.bitLength + 1)).toBigInt(), n);
  });

  forAll('BigInt conversions - roundtrip arbitrary size', Gen.bigInt, (n) {
    expect(BitVector.fromBigInt(n).toBigInt(), n);
  });

  forAll('getByte', bitVector, (x) {
    final bytes = x.bytes;
    Range.exclusive(0, (x.size + 7) ~/ 8).foreach((i) {
      expect(bytes.get(i), x.getByte(i));
    });
  });

  test('compareTo', () {
    expect(BitVector.empty.compareTo(BitVector.empty), 0);
    expect(BitVector.fromDart([1]).compareTo(BitVector.fromDart([1])), 0);
    expect(BitVector.empty.compareTo(BitVector.fromDart([1])), -1);
    expect(BitVector.fromDart([1]).compareTo(BitVector.fromDart([1, 2])), -1);
    expect(BitVector.fromDart([1, 2]).compareTo(BitVector.fromDart([1])), 1);
    expect(BitVector.fromDart([1, 2]).compareTo(BitVector.fromDart([2])), -1);
    expect(BitVector.fromDart([2]).compareTo(BitVector.fromDart([1, 2])), 1);
  });

  forAll('concat', Gen.ilistOf(Gen.chooseInt(0, 10), bitVector), (bvs) {
    final c = BitVector.concat(bvs);

    expect(c.size, bvs.map((bv) => bv.size).sum());

    bvs.headOption.foreach((h) => expect(c.startsWith(h), isTrue));
    bvs.lastOption.foreach((l) => expect(c.endsWith(l), isTrue));
  });

  test('drop (1)', () {
    expect(
      BitVector.high(8).drop(4).bytes,
      ByteVector([0xf0]),
    );

    expect(
      BitVector.high(8).drop(3).bytes,
      ByteVector([0xf8]),
    );

    expect(
      BitVector.high(10).drop(3).bytes,
      ByteVector([0xfe]),
    );

    expect(
      BitVector.high(10).drop(3),
      BitVector.high(7),
    );

    expect(
      BitVector.high(12).drop(3).bytes,
      ByteVector([0xff, 0x80]),
    );

    expect(
      BitVector.empty.drop(4),
      BitVector.empty,
    );

    expect(
      BitVector.high(4).drop(8),
      BitVector.empty,
    );

    expect(
      BitVector.high(8).drop(-20),
      BitVector.high(8),
    );
  });

  forAll2('drop (2)', bitVector, Gen.integer, (x, n) {
    final m = x.nonEmpty ? n % x.size : 0;
    expect(x.drop(m).take(4), x.drop(m).take(4));
  });

  forAll('dropWhile', bitVector, (bv) {
    expect(bv.dropWhile((_) => false), bv);
    expect(bv.dropWhile((_) => true), BitVector.empty);

    if (bv.size > 1) {
      expect(bv.drop(1).head, bv.get(1));
    } else if (bv.size == 1) {
      expect(bv.drop(1).isEmpty, isTrue);
    } else {
      expect(bv.drop(1), bv);
    }
  });

  forAll2('endsWith', bitVector, Gen.integer, (bv, n0) {
    final n = bv.nonEmpty ? (n0 % bv.size).abs() : 0;
    final slice = bv.takeRight(n);

    expect(bv.endsWith(slice), isTrue);

    if (slice.nonEmpty) {
      expect(bv.endsWith(~slice), isFalse);
    }
  });

  forAll('headOption', bitVector, (bv) {
    expect(bv.headOption.isDefined, bv.nonEmpty);

    if (bv.nonEmpty) {
      expect(bv.headOption, isSome(bv.head));
    }
  });

  test('highByte', () {
    expect(BitVector.highByte.toBin(), '11111111');
  });

  forAll3(
    'indexOfSlice / containsSlice / startsWith',
    bitVector,
    Gen.integer,
    Gen.integer,
    (bv, m0, n0) {
      final m = bv.nonEmpty ? (m0 % bv.size).abs() : 0;
      final n = bv.nonEmpty ? (n0 % bv.size).abs() : 0;
      final slice = bv.slice(min(m, n), max(m, n));
      final idx = bv.indexOfSlice(slice);

      expect(
        idx,
        bv.toIList().indexOfSlice(slice.toIList()).getOrElse(() => 1),
      );

      expect(bv.containsSlice(slice), isTrue);

      if (bv.nonEmpty) {
        expect(bv.containsSlice(bv.concat(bv)), isFalse);
      }
    },
  );

  forAll('init', bitVector, (bv) {
    expect(bv.startsWith(bv.init), isTrue);

    if (bv.nonEmpty) {
      expect(bv.init.size, bv.size - 1);
    } else {
      expect(bv.init, bv);
    }
  });

  forAll('int conversions', Gen.integer, (n) {
    expect(BitVector.fromInt(n).toInt(), n);

    expect(BitVector.fromInt(n, ordering: Endian.little).toInt(ordering: Endian.little), n);

    if (n >= -16383 && n < 16384) {
      expect(BitVector.fromInt(n, size: 15).toInt(), n);

      expect(
        BitVector.fromInt(n, size: 15, ordering: Endian.little).toInt(ordering: Endian.little),
        n,
      );
    }
  }, testOn: '!browser');

  forAll('padLeft', bitVector, (bv) {
    expect(bv.padLeft(0), bv);
    expect(bv.padLeft(bv.size), bv);
    expect(bv.padLeft(bv.size + 3).size, bv.size + 3);
    expect(bv.padLeft(bv.size + 1).head, false);
  });

  forAll('padRight', bitVector, (bv) {
    expect(bv.padRight(0), bv);
    expect(bv.padRight(bv.size), bv);
    expect(bv.padRight(bv.size + 3).size, bv.size + 3);
    expect(bv.padRight(bv.size + 1).last, false);

    expect(bv.padTo(bv.size + 10), bv.padRight(bv.size + 10));
  });

  forAll3('patch', bitVector, bitVector, Gen.integer, (x, y, n0) {
    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.patch(n, x.slice(n, n)), x);
    expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
  });

  forAll('populationCount', Gen.chooseInt(0, 100), (n) {
    expect(BitVector.high(n).populationCount(), n);
    expect(BitVector.low(n).populationCount(), 0);
  });

  forAll(
    'reverseBitOrder',
    bitVector,
    (b) => expect(b.reverseBitOrder().reverseBitOrder(), b),
  );

  test('rotations (1)', () {
    expect(
      bin('10101').rotateRight(3),
      bin('10110'),
    );

    expect(
      bin('10101').rotateLeft(3),
      bin('01101'),
    );
  });

  forAll2('rotations (2)', bitVector, Gen.integer, (b, n) {
    expect(b.rotateLeft(b.size), b);
    expect(b.rotateRight(b.size), b);

    final n0 = b.nonEmpty ? n % b.size : n;
    expect(b.rotateRight(n0).rotateLeft(n0), b);
    expect(b.rotateLeft(n0).rotateRight(n0), b);
  });

  forAll('sizeLessThan', bitVector, (x) {
    expect(x.sizeLessThan(x.size + 1), isTrue);
    expect(x.sizeLessThan(x.size), isFalse);
  });

  test('slice', () {
    expect(hex('001122334455').slice(8, 32), hex('112233'));
    expect(hex('001122334455').slice(-21, 32), hex('00112233'));
    expect(hex('001122334455').slice(-21, -5), hex(''));
  });

  forAll3('splice', bitVector, bitVector, Gen.integer, (x, y, n0) {
    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.splice(n, BitVector.empty), x);
    expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
  });

  forAll2('sliding', bitVector, Gen.integer, (b, n0) {
    final n = (b.nonEmpty ? n0 % b.size.abs() : 0) + 1;
    final expected = b.toBin().sliding(n).map(BitVector.fromValidBin).toIList();

    expect(b.sliding(n).toIList(), expected);
  });

  forAll2('sliding with step', bitVector, Gen.integer, (b, n0) {
    final n = (b.nonEmpty ? n0 % b.size.abs() : 0) + 1;

    final expected = b.toBin().sliding(n, n).map(BitVector.fromValidBin).toIList();

    expect(b.sliding(n, n).toIList(), expected);
  });

  forAll('toBin / fromBin roundtrip', bitVector, (bv) {
    expect(BitVector.fromBin(bv.toBin()), isSome(bv));
  });

  forAll('toHex (2)', bitVector, (bv) {
    if (bv.size % 8 == 0 || bv.size % 8 > 4) {
      expect(bv.toHex(), bv.bytes.toHex());
    } else {
      expect(bv.toHex(), bv.bytes.toHex().init);
    }
  });

  test('updated', () {
    final vec = BitVector.low(16);
    expect(vec.set(6).get(6), isTrue);
    expect(vec.set(10).get(10), isTrue);
    expect(vec.set(10).clear(10).get(10), isFalse);
  });
}
