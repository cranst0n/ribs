import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  forAll('hashCode / equality', (bitVector, bitVector, Gen.integer).tupled,
      (t) {
    final (b, b2, n) = t;

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
    expect(BitVector.high(1).bytes(), ByteVector.fromList([0x80]));
    expect(BitVector.high(2).bytes(), ByteVector.fromList([0xc0]));
    expect(BitVector.high(3).bytes(), ByteVector.fromList([0xe0]));
    expect(BitVector.high(4).bytes(), ByteVector.fromList([0xf0]));
    expect(BitVector.high(5).bytes(), ByteVector.fromList([0xf8]));
    expect(BitVector.high(6).bytes(), ByteVector.fromList([0xfc]));
    expect(BitVector.high(7).bytes(), ByteVector.fromList([0xfe]));
    expect(BitVector.high(8).bytes(), ByteVector.fromList([0xff]));
    expect(BitVector.high(9).bytes(), ByteVector.fromList([0xff, 0x80]));
    expect(BitVector.high(10).bytes(), ByteVector.fromList([0xff, 0xc0]));
  });

  test('empty toByteVector', () {
    expect(BitVector.empty().bytes(), ByteVector.empty());
  });

  test('indexing', () {
    final vec = BitVector.fromByteVector(ByteVector.fromList([0xf0, 0x0f]));
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

  forAll('getByte', bitVector, (x) {
    final bytes = x.bytes();
    IList.range(0, (x.size + 7) ~/ 8).forEach((i) {
      expect(bytes(i), x.getByte(i));
    });
  });

  test('updated', () {
    final vec = BitVector.low(16);
    expect(vec.set(6).get(6), isTrue);
    expect(vec.set(10).get(10), isTrue);
    expect(vec.set(10).clear(10).get(10), isFalse);
  });

  test('drop (1)', () {
    expect(
      BitVector.high(8).drop(4).bytes(),
      ByteVector.fromList([0xf0]),
    );

    expect(
      BitVector.high(8).drop(3).bytes(),
      ByteVector.fromList([0xf8]),
    );

    expect(
      BitVector.high(10).drop(3).bytes(),
      ByteVector.fromList([0xfe]),
    );

    expect(
      BitVector.high(10).drop(3),
      BitVector.high(7),
    );

    expect(
      BitVector.high(12).drop(3).bytes(),
      ByteVector.fromList([0xff, 0x80]),
    );

    expect(
      BitVector.empty().drop(4),
      BitVector.empty(),
    );

    expect(
      BitVector.high(4).drop(8),
      BitVector.empty(),
    );

    expect(
      BitVector.high(8).drop(-20),
      BitVector.high(8),
    );
  });

  forAll('drop (2)', (bitVector, Gen.integer).tupled, (t) {
    final (x, n) = t;

    final m = x.nonEmpty ? n % x.size : 0;
    expect(x.drop(m).take(4), x.drop(m).take(4));
  });

  forAll('containsSlice', bitVector, (bv) {
    if (bv.nonEmpty) {
      IList.range(0, bv.size).forEach((n) {
        expect(bv.containsSlice(bv.drop(n)), isTrue);
      });
    } else {
      expect(bv.containsSlice(bv), isFalse);
    }
  });

  forAll('dropWhile', bitVector, (bv) {
    expect(bv.dropWhile((_) => false), bv);
    expect(bv.dropWhile((_) => true), BitVector.empty());

    if (bv.size > 1) {
      expect(bv.drop(1).head, bv.get(1));
    } else if (bv.size == 1) {
      expect(bv.drop(1).isEmpty, isTrue);
    } else {
      expect(bv.drop(1), bv);
    }
  });

  forAll('endsWith', bitVector, (bv) {
    IList.range(0, bv.size).forEach((n) {
      expect(bv.endsWith(bv.drop(n)), isTrue);
    });
  });

  forAll('headOption', bitVector, (bv) {
    expect(bv.headOption.isDefined, bv.nonEmpty);

    if (bv.nonEmpty) {
      expect(bv.headOption, isSome(bv.head));
    }
  });

  forAll('init', bitVector, (bv) {
    expect(bv.startsWith(bv.init()), isTrue);

    if (bv.nonEmpty) {
      expect(bv.init().size, bv.size - 1);
    } else {
      expect(bv.init(), bv);
    }
  });

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

  forAll('patch', (bitVector, bitVector, Gen.integer).tupled, (t) {
    final (x, y, n0) = t;

    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.patch(n, x.slice(n, n)), x);
    expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
  });

  forAll('populationCount', Gen.chooseInt(0, 100), (n) {
    expect(BitVector.high(n).populationCount(), n);
    expect(BitVector.low(n).populationCount(), 0);
  });

  test('rotations (1)', () {
    expect(
      BitVector.fromValidBin('10101').rotateRight(3),
      BitVector.fromValidBin('10110'),
    );

    expect(
      BitVector.fromValidBin('10101').rotateLeft(3),
      BitVector.fromValidBin('01101'),
    );
  });

  forAll('rotations (2)', (bitVector, Gen.integer).tupled, (t) {
    final (b, n) = t;

    expect(b.rotateLeft(b.size), b);
    expect(b.rotateRight(b.size), b);

    final n0 = b.nonEmpty ? n % b.size : n;
    expect(b.rotateRight(n0).rotateLeft(n0), b);
    expect(b.rotateLeft(n0).rotateRight(n0), b);
  });

  forAll('splice', (bitVector, bitVector, Gen.integer).tupled, (t) {
    final (x, y, n0) = t;

    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.splice(n, BitVector.empty()), x);
    expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
  });

  forAll('toBin / fromBin roundtrip', bitVector, (bv) {
    expect(BitVector.fromBin(bv.toBin()), isSome(bv));
  });

  forAll('toHex / fromHex roundtrip', bitVector, (bv) {
    expect(BitVector.fromHex(bv.toHex()), isSome(bv));
  });
}
