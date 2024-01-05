import 'dart:convert';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('ByteVector', () {
    forAll('hashCode / equality', bytesWithIndex, (t) {
      final (b, n) = t;

      expect(b.take(n).concat(b.drop(n)), b);
      expect(b.take(n).concat(b.drop(n)).hashCode, b.hashCode);
    });

    test('fromValidBin (invalid)', () {
      expect(
        () => ByteVector.fromValidBin('21010'),
        throwsArgumentError,
      );
    });

    forAll('fromValidBin (gen)', binString, (str) {
      expect(ByteVector.fromValidBin(str).size, str.length / 8);
    });

    test('fromValidHex (invalid)', () {
      expect(ByteVector.fromValidHex('aa0').toHex(), '0aa0');

      expect(
        () => ByteVector.fromValidHex('ff324V'),
        throwsArgumentError,
      );
    });

    forAll('fromValidHex (gen)', hexString, (str) {
      expect(ByteVector.fromValidHex(str).size, str.length / 2);
    });

    test('fromValidHex', () {
      expect(ByteVector.fromValidHex('00').toHex(), '00');
      expect(ByteVector.fromValidHex('0x00').toHex(), '00');
      expect(ByteVector.fromValidHex('0x000F').toHex(), '000f');

      expect(
        () => ByteVector.fromValidHex('0x00QF').toHex(),
        throwsArgumentError,
      );
    });

    test('fromValidBase32', () {
      ByteVector hex(String s) => ByteVector.fromValidHex(s);
      ByteVector base32(String s) => ByteVector.fromValidBase32(s);

      expect(base32(''), ByteVector.empty());
      expect(base32('AA======'), hex('00'));
      expect(base32('ME======'), hex('61'));
      expect(base32('MJRGE==='), hex('626262'));
      expect(base32('MNRWG==='), hex('636363'));
      expect(
        base32('ONUW24DMPEQGCIDMN5XGOIDTORZGS3TH'),
        hex('73696d706c792061206c6f6e6720737472696e67'),
      );
      expect(
        base32('ADVRKIY57TVWBESYQ23H2BSSTGJFSFNOWFZMAZSH'),
        hex('00eb15231dfceb60925886b67d065299925915aeb172c06647'),
      );
      expect(base32('KFVW7TIP'), hex('516b6fcd0f'));
      expect(base32('X5HYSAA6M4BHJXI='), hex('bf4f89001e670274dd'));
      expect(base32('K4XEPFA='), hex('572e4794'));
      expect(base32('5SWITSWZHER4AIZB'), hex('ecac89cad93923c02321'));
      expect(base32('CDEFCHQ='), hex('10c8511e'));
      expect(base32('AAAAAAAAAAAAAAAA'), hex('00000000000000000000'));
    });

    test('toBase32', () {
      ByteVector hex(String s) => ByteVector.fromValidHex(s);

      expect(hex('').toBase32(), '');
      expect(hex('00').toBase32(), 'AA======');
      expect(hex('61').toBase32(), 'ME======');
      expect(hex('626262').toBase32(), 'MJRGE===');
      expect(hex('636363').toBase32(), 'MNRWG===');
      expect(
        hex('73696d706c792061206c6f6e6720737472696e67').toBase32(),
        'ONUW24DMPEQGCIDMN5XGOIDTORZGS3TH',
      );
      expect(
        hex('00eb15231dfceb60925886b67d065299925915aeb172c06647').toBase32(),
        'ADVRKIY57TVWBESYQ23H2BSSTGJFSFNOWFZMAZSH',
      );
      expect(hex('516b6fcd0f').toBase32(), 'KFVW7TIP');
      expect(hex('bf4f89001e670274dd').toBase32(), 'X5HYSAA6M4BHJXI=');
      expect(hex('572e4794').toBase32(), 'K4XEPFA=');
      expect(hex('ecac89cad93923c02321').toBase32(), '5SWITSWZHER4AIZB');
      expect(hex('10c8511e').toBase32(), 'CDEFCHQ=');
      expect(hex('00000000000000000000').toBase32(), 'AAAAAAAAAAAAAAAA');
    });

    forAll('fromValidBase64 (gen)', base64String, (str) {
      expect(ByteVector.fromBase64(str).isDefined, isTrue);
    });

    forAll('and/or/not/xor', byteVector, (bv) {
      expect(bv & bv, bv);
      expect(bv & ~bv, ByteVector.low(bv.size));

      expect(bv | bv, bv);
      expect(bv | ~bv, ByteVector.high(bv.size));

      expect(bv ^ bv, ByteVector.low(bv.size));
      expect(bv ^ ~bv, ByteVector.high(bv.size));
    });

    forAll('acquire', byteVector, (bv) {
      if (bv.isEmpty) {
        expect(bv.acquire(1), isLeft<String, ByteVector>());
      } else {
        expect(bv.acquire(1), isRight<String, ByteVector>());
      }

      expect(bv.acquire(bv.size), isRight<String, ByteVector>());
      expect(bv.acquire(bv.size + 1), isLeft<String, ByteVector>());
    });

    forAll('concat', Gen.ilistOf(Gen.chooseInt(0, 10), byteVector), (bvs) {
      final c = ByteVector.concatAll(bvs);

      expect(c.size, bvs.foldLeft(0, (acc, bv) => acc + bv.size));

      bvs.headOption.forEach((h) => expect(c.startsWith(h), isTrue));
      bvs.lastOption.forEach((l) => expect(c.endsWith(l), isTrue));
    });

    forAll('containsSlice', byteVector, (bv) {
      if (bv.nonEmpty) {
        IList.range(0, bv.size).foreach((n) {
          expect(bv.containsSlice(bv.drop(n)), isTrue);
        });
      } else {
        expect(bv.containsSlice(bv), isFalse);
      }
    });

    forAll('dropWhile', byteVector, (bv) {
      expect(bv.dropWhile((_) => false), bv);
      expect(bv.dropWhile((_) => true), ByteVector.empty());

      if (bv.size > 1) {
        expect(bv.drop(1).head, bv.get(1));
      } else if (bv.size == 1) {
        expect(bv.drop(1).isEmpty, isTrue);
      } else {
        expect(bv.drop(1), bv);
      }
    });

    forAll('endsWith', byteVector, (bv) {
      IList.range(0, bv.size).foreach((n) {
        expect(bv.endsWith(bv.drop(n)), isTrue);
      });
    });

    forAll('foldLeft', byteVector, (bv) {
      expect(bv.foldLeft(ByteVector.empty(), (acc, b) => acc.append(b)), bv);
    });

    forAll('foldRight', byteVector, (bv) {
      expect(bv.foldRight(ByteVector.empty(), (b, acc) => acc.prepend(b)), bv);
    });

    test('grouped', () {
      final bv = ByteVector.fromList([0, 1, 2, 3, 4, 5, 6]);

      expect(
        bv.grouped(1),
        IList.fromDart([
          ByteVector.fromList([0]),
          ByteVector.fromList([1]),
          ByteVector.fromList([2]),
          ByteVector.fromList([3]),
          ByteVector.fromList([4]),
          ByteVector.fromList([5]),
          ByteVector.fromList([6]),
        ]),
      );

      expect(
        bv.grouped(2),
        IList.fromDart([
          ByteVector.fromList([0, 1]),
          ByteVector.fromList([2, 3]),
          ByteVector.fromList([4, 5]),
          ByteVector.fromList([6]),
        ]),
      );
    });

    forAll('headOption', byteVector, (bv) {
      expect(bv.headOption.isDefined, bv.nonEmpty);

      if (bv.nonEmpty) {
        expect(bv.headOption, isSome(bv.head));
      }
    });

    forAll('init', byteVector, (bv) {
      expect(bv.startsWith(bv.init()), isTrue);

      if (bv.nonEmpty) {
        expect(bv.init().size, bv.size - 1);
      } else {
        expect(bv.init(), bv);
      }
    });

    test('insert (1)', () {
      expect(ByteVector.empty().insert(0, 1), ByteVector.fromList([1]));
      expect(
        ByteVector.fromList([1, 2, 3, 4]).insert(0, 0),
        ByteVector.fromList([0, 1, 2, 3, 4]),
      );
      expect(
        ByteVector.fromList([1, 2, 3, 4]).insert(1, 0),
        ByteVector.fromList([1, 0, 2, 3, 4]),
      );
    });

    forAll('insert (2)', byteVector, (bv) {
      expect(
        bv.foldLeft(ByteVector.empty(), (acc, b) => acc.insert(acc.size, b)),
        bv,
      );
    });

    forAll('last', (byteVector, byte).tupled, (t) {
      final (bv, byte) = t;

      if (bv.nonEmpty) {
        expect(bv.last, bv.get(bv.size - 1));
      }

      expect(bv.append(byte).last, byte);
    });

    forAll('lastOption', (byteVector, byte).tupled, (t) {
      final (bv, byte) = t;

      expect(bv.lastOption.isDefined, bv.nonEmpty);
      expect(bv.append(byte).lastOption, isSome(byte));
    });

    forAll('padLeft', byteVector, (bv) {
      expect(bv.padLeft(0), bv);
      expect(bv.padLeft(bv.size), bv);
      expect(bv.padLeft(bv.size + 3).size, bv.size + 3);
      expect(bv.padLeft(bv.size + 1).head, 0);
    });

    forAll('padRight', byteVector, (bv) {
      expect(bv.padRight(0), bv);
      expect(bv.padRight(bv.size), bv);
      expect(bv.padRight(bv.size + 3).size, bv.size + 3);
      expect(bv.padRight(bv.size + 1).last, 0);

      expect(bv.padTo(bv.size + 10), bv.padRight(bv.size + 10));
    });

    forAll('patch', (byteVector, byteVector, Gen.integer).tupled, (t) {
      final (x, y, n0) = t;

      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
      expect(x.patch(n, x.slice(n, n)), x);
      expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
    });

    forAll('rotations', (byteVector, Gen.chooseInt(0, 100)).tupled, (t) {
      final (bv, n) = t;

      expect(bv.rotateLeft(bv.size * 8), bv);
      expect(bv.rotateRight(bv.size * 8), bv);
      expect(bv.rotateRight(n).rotateLeft(n), bv);
      expect(bv.rotateLeft(n).rotateRight(n), bv);
    });

    forAll('splice', (byteVector, byteVector, Gen.integer).tupled, (t) {
      final (x, y, n0) = t;

      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
      expect(x.splice(n, ByteVector.empty()), x);
      expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
    });

    forAll('splitAt', byteVector, (bv) {
      expect(bv.splitAt(0), (ByteVector.empty(), bv));
      expect(bv.splitAt(bv.size), (bv, ByteVector.empty()));

      IList.range(0, bv.size).foreach((n) {
        expect(bv.splitAt(n)((a, b) => a.concat(b)), bv);
      });
    });

    forAll('takeWhile', byteVector, (bv) {
      final (expected, _) = bv.foldLeft((ByteVector.empty(), true), (acct, b) {
        final (acc, taking) = acct;

        if (taking) {
          if (b == 0) {
            return (acc, false);
          } else {
            return (acc.append(b), true);
          }
        } else {
          return (acc, false);
        }
      });

      expect(bv.takeWhile((a) => a != 0), expected);
    });

    forAll('toBin / fromBin roundtrip', byteVector, (bv) {
      expect(ByteVector.fromBin(bv.toBin()), isSome(bv));
    });

    forAll('toHex / fromHex roundtrip', byteVector, (bv) {
      expect(ByteVector.fromHex(bv.toHex()), isSome(bv));
    });

    forAll('toBase32 / fromBase32 roundtrip', base32String, (str) {
      expect(ByteVector.fromBase32(str), isSome<ByteVector>());
    });

    test('fromBase64 exemplars', () {
      expect(ByteVector.fromValidBase64('AB').toHex(), '00');
      expect(ByteVector.fromValidBase64('ABC').toHex(), '0010');
      expect(ByteVector.fromValidBase64('ABCD').toHex(), '001083');
      expect(ByteVector.fromValidBase64('e1MTVE').toHex(), '7b531354');
    });

    forAll('toBase64 / fromBase64 roundtrip', base64String, (str) {
      final dartBytes = base64Decode(str);
      final bv = ByteVector.fromValidBase64(str);
      final ribsBytes = bv.toByteArray();

      expect(dartBytes.length, ribsBytes.length);

      dartBytes
          .toIList()
          .zip(ribsBytes.toIList())
          .forEachN((dart, ribs) => expect(dart, ribs));

      final dartString = base64Encode(dartBytes);
      final ribsString = bv.toBase64();

      expect(dartString, ribsString);
    });

    forAll('toBase64Url / fromBase64Url roundtrip', base64UrlString, (str) {
      const dartCodec = Base64Codec.urlSafe();

      final dartBytes = dartCodec.decode(str);
      final bv = ByteVector.fromValidBase64(str, Alphabets.base64Url);
      final ribsBytes = bv.toByteArray();

      expect(dartBytes.length, ribsBytes.length);

      dartBytes
          .toIList()
          .zip(ribsBytes.toIList())
          .forEachN((dart, ribs) => expect(dart, ribs));

      final dartString = dartCodec.encode(dartBytes);
      final ribsString = bv.toBase64Url();

      expect(dartString, ribsString);
    });

    forAll('int conversion', Gen.integer, (i) {
      expect(ByteVector.fromInt(i).toInt(), i);
    });
  });
}
