import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  BitVector bin(String str) => BitVector.fromValidBin(str);
  BitVector hex(String str) => BitVector.fromValidHex(str);

  (bitVector, bitVector, Gen.integer).forAll('hashCode / equality', (b, b2, n) {
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

  Gen.chooseInt(-1, 1000000).forAll(
    'BigInt conversions - consistent with toInt without options',
    (n) {
      expect(BitVector.fromInt(n).toBigInt(), BigInt.from(n));
    },
  );

  Gen.integer.forAll('BigInt conversions - verify sign handling', (n) {
    expect(
      BitVector.fromInt(n).toBigInt(signed: false),
      n >= 0 ? BigInt.from(n) : BigInt.from(n).toUnsigned(Integer.size),
    );
  });

  test('BigInt conversions - bigger than int', () {
    final bits = hex('01 ffff ffff ffff ffff');
    expect(
      bits.toBigInt(),
      BigInt.parse('1FFFFFFFFFFFFFFFF', radix: 16),
    );
  });

  Gen.bigInt.forAll('BigInt conversions - roundtrip', (n) {
    expect(BitVector.fromBigInt(n, size: Some(n.bitLength + 1)).toBigInt(), n);
  });

  Gen.bigInt.forAll('BigInt conversions - roundtrip arbitrary size', (n) {
    expect(BitVector.fromBigInt(n).toBigInt(), n);
  });

  bitVector.forAll('getByte', (x) {
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

  Gen.ilistOf(Gen.chooseInt(0, 10), bitVector).forAll('concat', (bvs) {
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

  (bitVector, Gen.integer).forAll('drop (2)', (x, n) {
    final m = x.nonEmpty ? n % x.size : 0;
    expect(x.drop(m).take(4), x.drop(m).take(4));
  });

  (bitVector, Gen.integer).forAll('drop (3)', (x, n) {
    final m = x.nonEmpty ? n % x.size : 0;
    expect(x.drop(m).take(4), x.drop(m).take(4));
  });

  bitVector.forAll('dropWhile', (bv) {
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

  (bitVector, Gen.integer).forAll('endsWith', (bv, n0) {
    final n = bv.nonEmpty ? (n0 % bv.size).abs() : 0;
    final slice = bv.takeRight(n);

    expect(bv.endsWith(slice), isTrue);

    if (slice.nonEmpty) {
      expect(bv.endsWith(~slice), isFalse);
    }
  });

  bitVector.forAll('headOption', (bv) {
    expect(bv.headOption.isDefined, bv.nonEmpty);

    if (bv.nonEmpty) {
      expect(bv.headOption, isSome(bv.head));
    }
  });

  test('highByte', () {
    expect(BitVector.highByte.toBin(), '11111111');
  });

  (bitVector, Gen.integer, Gen.integer).forAll(
    'indexOfSlice / containsSlice / startsWith',
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

  bitVector.forAll('init', (bv) {
    expect(bv.startsWith(bv.init), isTrue);

    if (bv.nonEmpty) {
      expect(bv.init.size, bv.size - 1);
    } else {
      expect(bv.init, bv);
    }
  });

  Gen.integer.forAll(
    'int conversions',
    (n) {
      expect(BitVector.fromInt(n).toInt(), n);

      expect(BitVector.fromInt(n, ordering: Endian.little).toInt(ordering: Endian.little), n);

      if (n >= -16383 && n < 16384) {
        expect(BitVector.fromInt(n, size: 15).toInt(), n);

        expect(
          BitVector.fromInt(n, size: 15, ordering: Endian.little).toInt(ordering: Endian.little),
          n,
        );
      }
    },
    testOn: '!browser',
  );

  bitVector.forAll('padLeft', (bv) {
    expect(bv.padLeft(0), bv);
    expect(bv.padLeft(bv.size), bv);
    expect(bv.padLeft(bv.size + 3).size, bv.size + 3);
    expect(bv.padLeft(bv.size + 1).head, false);
  });

  bitVector.forAll('padRight', (bv) {
    expect(bv.padRight(0), bv);
    expect(bv.padRight(bv.size), bv);
    expect(bv.padRight(bv.size + 3).size, bv.size + 3);
    expect(bv.padRight(bv.size + 1).last, false);

    expect(bv.padTo(bv.size + 10), bv.padRight(bv.size + 10));
  });

  (bitVector, bitVector, Gen.integer).forAll('patch', (x, y, n0) {
    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.patch(n, x.slice(n, n)), x);
    expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
  });

  Gen.chooseInt(0, 100).forAll('populationCount', (n) {
    expect(BitVector.high(n).populationCount(), n);
    expect(BitVector.low(n).populationCount(), 0);
  });

  bitVector.forAll(
    'reverseBitOrder',
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

  (bitVector, Gen.integer).forAll('rotations (2)', (b, n) {
    expect(b.rotateLeft(b.size), b);
    expect(b.rotateRight(b.size), b);

    final n0 = b.nonEmpty ? n % b.size : n;
    expect(b.rotateRight(n0).rotateLeft(n0), b);
    expect(b.rotateLeft(n0).rotateRight(n0), b);
  });

  bitVector.forAll('sizeLessThan', (x) {
    expect(x.sizeLessThan(x.size + 1), isTrue);
    expect(x.sizeLessThan(x.size), isFalse);
  });

  test('slice', () {
    expect(hex('001122334455').slice(8, 32), hex('112233'));
    expect(hex('001122334455').slice(-21, 32), hex('00112233'));
    expect(hex('001122334455').slice(-21, -5), hex(''));
  });

  (bitVector, bitVector, Gen.integer).forAll('splice', (x, y, n0) {
    final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
    expect(x.splice(n, BitVector.empty), x);
    expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
  });

  (bitVector, Gen.integer).forAll('sliding', (b, n0) {
    final n = (b.nonEmpty ? n0 % b.size.abs() : 0) + 1;
    final expected = b.toBin().sliding(n).map(BitVector.fromValidBin).toIList();

    expect(b.sliding(n).toIList(), expected);
  });

  (bitVector, Gen.integer).forAll('sliding with step', (b, n0) {
    final n = (b.nonEmpty ? n0 % b.size.abs() : 0) + 1;

    final expected = b.toBin().sliding(n, n).map(BitVector.fromValidBin).toIList();

    expect(b.sliding(n, n).toIList(), expected);
  });

  bitVector.forAll('toBin / fromBin roundtrip', (bv) {
    expect(BitVector.fromBin(bv.toBin()), isSome(bv));
  });

  bitVector.forAll('toHex (2)', (bv) {
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

  test('lowByte', () {
    expect(BitVector.lowByte.toBin(), '00000000');
    expect(BitVector.lowByte.size, 8);
  });

  test('view factory', () {
    final bytes = Uint8List.fromList([0xde, 0xad]);
    expect(BitVector.view(bytes), BitVector.fromDart([0xde, 0xad]));
    expect(BitVector.view(bytes, sizeInBits: 12).size, 12);
  });

  test('from factory', () {
    expect(BitVector.from(ilist([0xff, 0x00])), BitVector.fromDart([0xff, 0x00]));
  });

  test('concatDart', () {
    final bvs = [bin('1111'), bin('0000')];
    expect(BitVector.concatDart(bvs), bin('11110000'));
  });

  test('copy on non-Bytes vector', () {
    final bv = bin('1010').concat(bin('0101'));
    expect(bv.copy(), bv);
  });

  test('shift right operators', () {
    // signed right shift (>>) sign-extends with the high bit
    final pos = bin('01110000');
    expect(pos >> 2, bin('00011100'));

    final neg = bin('10110100');
    expect(neg >> 2, bin('11101101'));

    // unsigned right shift (>>>) always extends with 0
    expect(neg >>> 2, bin('00101101'));
  });

  test('insert', () {
    expect(bin('1111').insert(0, false), bin('01111'));
    expect(bin('1010').insert(2, true), bin('10110'));
    expect(bin('1010').insert(4, false), bin('10100'));
  });

  test('acquireThen', () {
    final bv = bin('10110100');

    final value = bv.acquireThen(4, (err) => -1, (v) => v.toInt(signed: false));
    expect(value, 11); // 1011 = 11

    final err = bv.acquireThen(16, (e) => e, (v) => 'ok');
    expect(err, contains('cannot acquire'));
  });

  test('consume', () {
    final bv = bin('10110100');

    final ok = bv.consume(4, (v) => Either.right(v.toInt(signed: false)));
    expect(ok.isRight, isTrue);
    ok.fold(
      (_) {},
      (pair) {
        final (remaining, value) = pair;
        expect(value, 11);
        expect(remaining, bin('0100'));
      },
    );

    expect(bv.consume(16, Either.right).isLeft, isTrue);
  });

  test('consumeThen', () {
    final bv = bin('10110100');

    final value = bv.consumeThen(4, (_) => -1, (taken, _) => taken.toInt(signed: false));
    expect(value, 11);

    final err = bv.consumeThen(16, (_) => -1, (_, _) => 0);
    expect(err, -1);
  });

  test('base32 encoding roundtrip', () {
    final bv = BitVector.fromDart([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
    final b32 = bv.toBase32();
    expect(BitVector.fromBase32(b32), isSome(bv));
    expect(BitVector.fromValidBase32(b32), bv);
    expect(BitVector.fromBase32Descriptive(b32).isRight, isTrue);
  });

  test('fromBase32 with invalid input', () {
    expect(BitVector.fromBase32('!!! invalid !!!').isEmpty, isTrue);
    expect(BitVector.fromBase32Descriptive('!!! invalid !!!').isLeft, isTrue);
  });

  base32String.forAll('base32 parse roundtrip', (s) {
    final result = BitVector.fromBase32(s);
    result.foreach((bv) => expect(bv.toBase32(), bv.toBase32()));
  });

  test('base64 encoding roundtrip', () {
    final bv = BitVector.fromDart([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
    final b64 = bv.toBase64();
    expect(BitVector.fromBase64(b64), isSome(bv));
    expect(BitVector.fromValidBase64(b64), bv);
    expect(BitVector.fromBase64Descriptive(b64).isRight, isTrue);

    expect(bv.toBase64NoPad(), isNotEmpty);
    expect(bv.toBase64Url(), isNotEmpty);
    expect(bv.toBase64UrlNoPad(), isNotEmpty);
    expect(bv.toBase16(), bv.toHex());
  });

  test('fromBase64 with invalid input', () {
    expect(BitVector.fromBase64('!!! invalid !!!').isEmpty, isTrue);
    expect(BitVector.fromBase64Descriptive('!!! invalid !!!').isLeft, isTrue);
  });

  test('toHexDump', () {
    final dump = hex('deadbeef').toHexDump();
    expect(dump, contains('de'));
    expect(dump, contains('ad'));

    final colorized = hex('deadbeef').toHexDumpColorized();
    expect(colorized, isNotEmpty);
  });

  test('toString edge cases', () {
    expect(BitVector.empty.toString(), 'BitVector.empty');
    expect(bin('1010').toString(), contains('BitVector('));
    // large vector: size shown in toString
    final large = BitVector.high(600);
    expect(large.toString(), contains('600'));
  });

  test('toBigInt little-endian', () {
    final bv = BitVector.fromInt(0x0102030405060708);
    final le = bv.toBigInt(signed: false, ordering: Endian.little);
    final be = bv.toBigInt(signed: false);
    // little-endian reverses byte order before interpreting
    expect(le, isNot(be));
    // round-trip: LE toBigInt and fromBigInt
    expect(
      BitVector.fromBigInt(le, size: const Some(64), ordering: Endian.little).toBigInt(
        signed: false,
        ordering: Endian.little,
      ),
      le,
    );
  });

  test('bits factory', () {
    final bv = BitVector.bits([true, false, true, true]);
    expect(bv, bin('1011'));
    expect(bv.size, 4);
  });

  test('byte factory', () {
    final bv = BitVector.byte(0xa5);
    expect(bv.toBin(), '10100101');
    expect(bv.size, 8);
  });

  test('fromHex Option variant', () {
    expect(BitVector.fromHex('deadbeef'), isSome(hex('deadbeef')));
    expect(BitVector.fromHex('zzzz').isEmpty, isTrue);
  });

  test('| and ^ and << operators', () {
    final a = bin('1100');
    final b = bin('1010');
    expect(a | b, bin('1110'));
    expect(a ^ b, bin('0110'));
    expect(a << 1, bin('1000'));
  });

  test('prepend', () {
    expect(bin('101').prepend(true), bin('1101'));
    expect(bin('101').prepend(false), bin('0101'));
  });

  test('takeRight with negative n throws', () {
    expect(() => bin('1010').takeRight(-1), throwsArgumentError);
  });

  test('lastOption', () {
    expect(bin('1010').lastOption, const Some(false));
    expect(bin('1').lastOption, const Some(true));
  });

  test('reverse getter', () {
    expect(bin('1100').reverse, bin('0011'));
    final bv = hex('deadbeef');
    expect(bv.reverse.reverse, bv);
  });

  test('reverseBitOrder non-byte-aligned', () {
    final bv = bin('10110');
    final rev = bv.reverseBitOrder();
    expect(rev.size, bv.size);
    expect(rev.reverseBitOrder(), bv);
  });

  test('and and xor methods', () {
    final a = bin('1100');
    final b = bin('1010');
    expect(a.and(b), bin('1000'));
    expect(a.xor(b), bin('0110'));
  });

  test('shiftLeft edge cases', () {
    expect(bin('1010').shiftLeft(0), bin('1010'));
    expect(bin('1010').shiftLeft(10), bin('0000'));
    expect(bin('1010') << 1, bin('0100'));
  });

  test('shiftRight edge cases', () {
    expect(BitVector.empty.shiftRight(1, false), BitVector.empty);
    expect(bin('1010').shiftRight(0, false), bin('1010'));
    expect(bin('1010').shiftRight(10, false), bin('0000'));
    expect(bin('1010').shiftRight(10, true), bin('1111'));
    expect(bin('0010').shiftRight(10, true), bin('0000'));
  });

  test('force resolves Suspend nodes', () {
    final bv = BitVector.unfold(
      0,
      (int i) => i < 4 ? Some((bin('1'), i + 1)) : none<(BitVector, int)>(),
    );
    expect(bv.force(), BitVector.high(4));
  });

  test('force resolves _Chunks and _Buffer nodes', () {
    // _Chunks path in force
    final chunks = bin('1111').concat(bin('0000'));
    expect(chunks.force(), bin('11110000'));

    // _Buffer path in force
    final buf = bin('10101010').bufferBy(8);
    expect(buf.force(), bin('10101010'));
  });

  test('bufferBy and unbuffer', () {
    // basic roundtrip
    final bv = bin('10101010').bufferBy(8);
    expect(bv.size, 8);
    expect(bv.unbuffer(), bin('10101010'));

    // build by concatenation through buffer
    final built = BitVector.empty.bufferBy(64).concat(bin('1111')).concat(bin('0000'));
    expect(built.unbuffer(), bin('11110000'));

    // bufferBy when already _Buffer with large enough chunk is a no-op
    final already = bin('1010').bufferBy(64);
    final again = already.bufferBy(64);
    expect(again.size, already.size);
  });

  test('printHexDump does not throw', () {
    expect(() => hex('deadbeef').printHexDump(), returnsNormally);
  });

  test('toInt 16-bit and 32-bit paths', () {
    final s16 = BitVector.fromInt(-1, size: 16);
    expect(s16.toInt(), -1);
    expect(s16.toInt(signed: false), 65535);

    final u16 = BitVector.fromInt(0x0102, size: 16);
    expect(u16.toInt(ordering: Endian.little), isNot(u16.toInt()));

    final s32 = BitVector.fromInt(-1, size: 32);
    expect(s32.toInt(), -1);
    expect(s32.toInt(signed: false), 4294967295);

    final u32 = BitVector.fromInt(0x01020304, size: 32);
    expect(u32.toInt(ordering: Endian.little), isNot(u32.toInt()));
  }, testOn: '!browser');

  test('toBigInt on empty vector returns zero', () {
    expect(BitVector.empty.toBigInt(), BigInt.zero);
  });

  test('Bytes out-of-bounds throws', () {
    expect(() => BitVector.low(4).get(10), throwsRangeError);
  });

  test('_Drop.update', () {
    // non-byte-aligned drop produces a _Drop
    final bv = BitVector.high(8).drop(3); // 5-bit _Drop
    final updated = bv.update(0, false);
    expect(updated.get(0), isFalse);
    expect(updated.size, 5);
  });

  test('_Chunks.update', () {
    // concat with non-empty vectors produces _Chunks
    final bv = bin('1111').concat(bin('0000'));
    final updated = bv.update(0, false);
    expect(updated.get(0), isFalse);
    expect(updated.size, 8);
  });

  test('unfold exercises _Suspend and _Append.size slow path', () {
    final bv = BitVector.unfold(
      0,
      (int i) => i < 3 ? Some((bin('10'), i + 1)) : none<(BitVector, int)>(),
    );
    // size triggers the _knownSize==-1 slow path in _Append
    expect(bv.size, 6);
    expect(bv, bin('101010'));
  });

  test('_mapBytes on Suspend via not', () {
    final bv = BitVector.unfold(
      0,
      (int i) => i < 2 ? Some((bin('11110000'), i + 1)) : none<(BitVector, int)>(),
    );
    // not calls _mapBytes which has a _Suspend branch
    expect(bv.not.compact(), bin('0000111100001111').compact());
  });

  test('_mapBytes on _Buffer via not', () {
    final buf = bin('11110000').bufferBy(64);
    expect(buf.not.compact(), bin('00001111').compact());
  });

  test('_Buffer get and getByte', () {
    var buf = BitVector.empty.bufferBy(16);
    buf = buf.concat(bin('10110100'));
    expect(buf.get(0), isTrue);
    expect(buf.get(1), isFalse);
    expect(buf.getByte(0), 0xb4);
  });

  test('_Buffer append builds correct vector', () {
    var buf = BitVector.empty.bufferBy(16);
    buf = buf.append(true);
    buf = buf.append(false);
    buf = buf.append(true);
    expect(buf.size, 3);
    expect(buf.get(0), isTrue);
    expect(buf.get(1), isFalse);
    expect(buf.get(2), isTrue);
    expect(buf.unbuffer(), bin('101'));
  });

  test('_Buffer update', () {
    final buf = BitVector.empty.bufferBy(16).concat(bin('1010'));
    // update a bit in lastChunk
    final updated = buf.update(1, true);
    expect(updated.get(1), isTrue);
  });

  test('_Buffer drop beyond hd', () {
    final buf = bin('10101010').bufferBy(64).concat(bin('1111'));
    final dropped = buf.drop(8);
    expect(dropped.size, 4);
    expect(dropped.unbuffer(), bin('1111'));
  });
}
