import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  ByteVector bin(String str) => ByteVector.fromValidBin(str);

  ByteVector hex(String str) => ByteVector.fromValidHex(str);

  ByteVector base32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => ByteVector.fromValidBase32(s, alphabet);

  ByteVector base58(String str) => ByteVector.fromValidBase58(str);

  final deadbeef = ByteVector([0xde, 0xad, 0xbe, 0xef]);

  group('ByteVector', () {
    bytesWithIndex.forAll('hashCode / equals', (t) {
      final (b, n) = t;

      expect(b.take(n).concat(b.drop(n)), b);
      expect(b.take(n).concat(b.drop(n)).hashCode, b.hashCode);

      if (b.take(3) == b.drop(3).take(3)) {
        expect(b.take(3).hashCode, b.drop(3).take(3).hashCode);
      }
    });

    test('fromValidBin', () {
      expect(bin(deadbeef.toBin()), deadbeef);
      expect(() => bin('1101a000'), throwsArgumentError);
    });

    binString.forAll('fromValidBin (gen)', (str) {
      expect(bin(str).size, (str.length / 8).ceil());
    });

    test('fromBinDescriptive', () {
      expect(
        ByteVector.fromBinDescriptive(deadbeef.toBin()),
        deadbeef.asRight<String>(),
      );

      expect(
        ByteVector.fromBinDescriptive(
          deadbeef.toBin().grouped(4).mkString(sep: ' '),
        ),
        deadbeef.asRight<String>(),
      );

      expect(
        ByteVector.fromBinDescriptive('0001 0011'),
        ByteVector([0x13]).asRight<String>(),
      );

      expect(
        ByteVector.fromBinDescriptive('0b 0001 0011 0111'),
        ByteVector([0x01, 0x37]).asRight<String>(),
      );

      expect(
        ByteVector.fromBinDescriptive('1101a000'),
        "Invalid binary character 'a' at index 4".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBinDescriptive('0b1101a000'),
        "Invalid binary character 'a' at index 6".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBinDescriptive('0B1101a000'),
        "Invalid binary character 'a' at index 6".asLeft<ByteVector>(),
      );
    });

    test('fromBinDescriptive with comments', () {
      expect(
        ByteVector.fromBinDescriptive('''
          00110011 ; first line
          11001100 # second line
          11110000
        '''),
        bin('001100111100110011110000').asRight<String>(),
      );

      expect(
        ByteVector.fromBinDescriptive(
          r'''
            00110011 $ first line
            11001100 $ second line
            11110000
          ''',
          CustomBinAlphabet(),
        ),
        BitVector.fromValidBin('001100111100110011110000').bytes.asRight<String>(),
      );
    });

    test('toBin', () {
      expect(deadbeef.toBin(), '11011110101011011011111011101111');
    });

    byteVector.forAll('toBin fromBin roundtrip', (b) {
      expect(bin(b.toBin()), b);
    });

    hexString.forAll('fromValidHex (gen)', (str) {
      expect(hex(str).size, (str.length / 2).ceil());
    });

    test('fromValidHex', () {
      expect(hex('00').toHex(), '00');
      expect(hex('0x00').toHex(), '00');
      expect(hex('0x000F').toHex(), '000f');

      expect(
        () => hex('0x00QF').toHex(),
        throwsArgumentError,
      );
    });

    test('fromHexDescriptive', () {
      final good = deadbeef.asRight<String>();

      expect(ByteVector.fromHexDescriptive('0xdeadbeef'), good);
      expect(ByteVector.fromHexDescriptive('0xDEADBEEF'), good);
      expect(ByteVector.fromHexDescriptive('0XDEADBEEF'), good);
      expect(ByteVector.fromHexDescriptive('deadbeef'), good);
      expect(ByteVector.fromHexDescriptive('DEADBEEF'), good);
      expect(ByteVector.fromHexDescriptive('de ad be ef'), good);
      expect(ByteVector.fromHexDescriptive('de\tad\nbe\tef'), good);
      expect(ByteVector.fromHexDescriptive('0xde_ad_be_ef'), good);

      expect(
        ByteVector.fromHexDescriptive('0xdeadbee'),
        ByteVector([0x0d, 0xea, 0xdb, 0xee]).asRight<String>(),
      );

      expect(
        ByteVector.fromHexDescriptive('0xde_ad_be_e'),
        ByteVector([0x0d, 0xea, 0xdb, 0xee]).asRight<String>(),
      );

      expect(
        ByteVector.fromHexDescriptive('garbage'),
        "Invalid hexadecimal character 'g' at index 0".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromHexDescriptive('deadbefg'),
        "Invalid hexadecimal character 'g' at index 7".asLeft<ByteVector>(),
      );
    });

    test('fromHexDescriptive', () {
      expect(
        ByteVector.fromHexDescriptive('''
          deadbeef ; first line
          01020304 # second line
          05060708
        '''),
        hex('deadbeef0102030405060708').asRight<String>(),
      );

      expect(
        ByteVector.fromHexDescriptive(
          r'''
            deadbeef $ first line
            01020304 $ second line
            05060708
          ''',
          CustomHexAlphabet(),
        ),
        hex('deadbeef0102030405060708').asRight<String>(),
      );
    });

    test('hex with comments example', () {
      const raw = '''
          ; Start of first packet from https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/mpeg2_mp2t_with_cc_drop01.pcap
          01 00 5e 7b ad 47 00 0c db 78 7d 00 08 00                      ; Ethernet header
          45 00 05 40 b6 9f 40 00 0c 11 de 95 51 a3 96 3c e9 70 03 28    ; IPv4 header
          c3 50 15 7c 05 2c 00 00                                        ; UDP header
          47 02 00 1e                                                    ; MP2T header
        ''';

      final packet = hex(raw);
      expect(packet.size, 46);
    });

    test('toHex', () {
      expect(deadbeef.toHex(), 'deadbeef');
    });

    byteVector.forAll('toHex fromHex roundtrip', (b) {
      expect(hex(b.toHex()), b);
    });

    test('fromValidBase32', () {
      expect(base32(''), ByteVector.empty);
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

    test('fail due to illegal character fromBase32', () {
      expect(
        ByteVector.fromBase32Descriptive('7654321'),
        "Invalid base 32 character '1' at index 6".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase32Descriptive('ABc'),
        "Invalid base 32 character 'c' at index 2".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase32Descriptive('AB CD 0'),
        "Invalid base 32 character '0' at index 6".asLeft<ByteVector>(),
      );

      expect(ByteVector.fromBase32("a").isEmpty, isTrue);
    });

    test('fromValidBase32(Crockford)', () {
      expect(base32('', Alphabets.base32Crockford), ByteVector.empty);
      expect(base32('00======', Alphabets.base32Crockford), hex('00'));
      expect(base32('ZZZZZZZZ', Alphabets.base32Crockford), hex('ffffffffff'));
      expect(base32('HJKMNPTV', Alphabets.base32Crockford), hex('8ca74adb5b'));
      expect(base32('hjkmnptv', Alphabets.base32Crockford), hex('8ca74adb5b'));
      expect(base32('00011111', Alphabets.base32Crockford), hex('0000108421'));
      expect(base32('0Oo1IiLl', Alphabets.base32Crockford), hex('0000108421'));
    });

    test('toBase32(Crockford)', () {
      expect(hex('').toBase32(Alphabets.base32Crockford), '');
      expect(hex('00').toBase32(Alphabets.base32Crockford), '00======');
      expect(hex('ffffffffff').toBase32(Alphabets.base32Crockford), 'ZZZZZZZZ');
      expect(hex('8ca74adb5b').toBase32(Alphabets.base32Crockford), 'HJKMNPTV');
    });

    test('fromValidBase58', () {
      void expectBase58(String actual58, String expectedHex) {
        expect(base58(actual58), hex(expectedHex));
      }

      expect(base58(''), ByteVector.empty);

      expectBase58('1', '00');
      expectBase58('2g', '61');
      expectBase58('a3gV', '626262');
      expectBase58('aPEr', '636363');

      expectBase58(
        '2cFupjhnEsSn59qHXstmK2ffpLv2',
        '73696d706c792061206c6f6e6720737472696e67',
      );

      expectBase58(
        '1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L',
        '00eb15231dfceb60925886b67d065299925915aeb172c06647',
      );

      expectBase58('ABnLTmg', '516b6fcd0f');
      expectBase58('3SEo3LWLoPntC', 'bf4f89001e670274dd');
      expectBase58('3EFU7m', '572e4794');
      expectBase58('EJDM8drfXA6uyA', 'ecac89cad93923c02321');
      expectBase58('Rt5zm', '10c8511e');
      expectBase58('1111111111', '00000000000000000000');
    });

    test('fail due to illegal character fromBase58', () {
      expect(
        ByteVector.fromBase58Descriptive('R3C0NFxN'),
        "Invalid base 58 character '0' at index 3".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase58Descriptive('03CMNFxN'),
        "Invalid base 58 character '0' at index 0".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase58('3CMNFxN1oHBc4R1EpboAL5yzHGgE611Xol'),
        isNone(),
      );
    });

    base64UrlString.forAll('toBase64Url / fromBase64Url roundtrip', (str) {
      const dartCodec = Base64Codec.urlSafe();

      final dartBytes = dartCodec.decode(str);
      final bv = ByteVector.fromValidBase64(str, Alphabets.base64Url);
      final ribsBytes = bv.toByteArray();

      expect(dartBytes.length, ribsBytes.length);

      dartBytes.toIList().zip(ribsBytes.toIList()).foreach((t) => expect(t.$1, t.$2));

      final dartString = dartCodec.encode(dartBytes);
      final ribsString = bv.toBase64Url();

      expect(dartString, ribsString);
    });

    byteVector.forAll('bin roundtrip', (bv) {
      expect(ByteVector.fromBin(bv.toBin()), isSome(bv));
    });

    byteVector.forAll('hex roundtrip', (bv) {
      expect(ByteVector.fromHex(bv.toHex()), isSome(bv));
    });

    byteVector.forAll('base32 roundtrip', (bv) {
      expect(ByteVector.fromBase32(bv.toBase32()), isSome(bv));
    });

    test('foo', () {
      final bv = hex('a9');
      expect(bv.toBase58(), '3v');
    });

    byteVector.forAll('base58 roundtrip', (bv) {
      expect(ByteVector.fromBase58(bv.toBase58()), isSome(bv));
    });

    byteVector.forAll('base64 roundtrip', (bv) {
      expect(ByteVector.fromBase64(bv.toBase64()), isSome(bv));
    });

    byteVector.forAll('base64 (no padding) roundtrip', (bv) {
      expect(ByteVector.fromBase64(bv.toBase64NoPad()), isSome(bv));
    });

    test('fromBase64 - digit count non-divisble by 4', () {
      expect(
        ByteVector.fromBase64Descriptive("A"),
        'Final base 64 quantum had only 1 digit - must have at least 2 digits'.asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase64Descriptive("AB"),
        hex("00").asRight<String>(),
      );

      expect(
        ByteVector.fromBase64Descriptive("ABC"),
        hex("0010").asRight<String>(),
      );

      expect(
        ByteVector.fromBase64Descriptive("ABCD"),
        hex("001083").asRight<String>(),
      );

      expect(
        ByteVector.fromBase64Descriptive("ABCDA"),
        "Final base 64 quantum had only 1 digit - must have at least 2 digits".asLeft<ByteVector>(),
      );

      expect(
        ByteVector.fromBase64Descriptive("ABCDAB"),
        hex("00108300").asRight<String>(),
      );
    });

    test("fromBase64 - padding", () {
      expect(
        ByteVector.fromBase64Descriptive("AB=="),
        hex("00").asRight<String>(),
      );

      final paddingError =
          "Malformed padding - final quantum may optionally be padded with one or two padding characters such that the quantum is completed"
              .asLeft<ByteVector>();

      expect(ByteVector.fromBase64Descriptive("A="), paddingError);
      expect(ByteVector.fromBase64Descriptive("A=="), paddingError);
      expect(ByteVector.fromBase64Descriptive("A==="), paddingError);
      expect(ByteVector.fromBase64Descriptive("A===="), paddingError);
      expect(ByteVector.fromBase64Descriptive("AB="), paddingError);
      expect(ByteVector.fromBase64Descriptive("AB==="), paddingError);
      expect(ByteVector.fromBase64Descriptive("ABC=="), paddingError);
      expect(ByteVector.fromBase64Descriptive("="), paddingError);
      expect(ByteVector.fromBase64Descriptive("=="), paddingError);
      expect(ByteVector.fromBase64Descriptive("==="), paddingError);
      expect(ByteVector.fromBase64Descriptive("===="), paddingError);
      expect(ByteVector.fromBase64Descriptive("====="), paddingError);
    });

    test("fromBase64 - empty input string", () {
      expect(
        ByteVector.fromBase64Descriptive(""),
        ByteVector.empty.asRight<String>(),
      );
    });

    byteVector.forAll('Uint8List roundtrip', (b) {
      final fromList = ByteVector(b.toByteArray());

      expect(b, fromList);
      expect(fromList, b);

      final fromList2 = ByteVector(b.toByteArray());
      expect(fromList, fromList2);
    });

    (byteVector, Gen.integer).forAll(
      'dropping from a view is consistent with dropping from a strict vector',
      (b, n0) {
        final view = ByteVector.view(b.toByteArray());
        final n = n0.abs();

        expect(b.drop(n), view.drop(n));
      },
    );

    byteVector.forAll('and/or/not/xor', (bv) {
      expect(bv & bv, bv);
      expect(bv & ~bv, ByteVector.low(bv.size));

      expect(bv | bv, bv);
      expect(bv | ~bv, ByteVector.high(bv.size));

      expect(bv ^ bv, ByteVector.low(bv.size));
      expect(bv ^ ~bv, ByteVector.high(bv.size));
    });

    test('<<', () {
      expect(
        ByteVector([0x55, 0x55, 0x55]) << 1,
        ByteVector([0xaa, 0xaa, 0xaa]),
      );
    });

    test('>>', () {
      expect(
        ByteVector([0x55, 0x55, 0x55]) >> 1,
        ByteVector([0x2a, 0xaa, 0xaa]),
      );

      expect(
        ByteVector([0xaa, 0xaa, 0xaa]) >> 1,
        ByteVector([0xd5, 0x55, 0x55]),
      );
    });

    test('>>>', () {
      expect(
        ByteVector([0x55, 0x55, 0x55]) >>> 1,
        ByteVector([0x2a, 0xaa, 0xaa]),
      );

      expect(
        ByteVector([0xaa, 0xaa, 0xaa]) >>> 1,
        ByteVector([0x55, 0x55, 0x55]),
      );
    });

    byteVector.forAll('acquire', (bv) {
      if (bv.isEmpty) {
        expect(bv.acquire(1), isLeft<String, ByteVector>());
      } else {
        expect(bv.acquire(1), isRight<String, ByteVector>());
      }

      expect(bv.acquire(bv.size), isRight<String, ByteVector>());
      expect(bv.acquire(bv.size + 1), isLeft<String, ByteVector>());
    });

    (
      byteVector,
      Gen.ilistOf(Gen.chooseInt(0, 10), byteVector),
      Gen.nonNegativeInt,
    ).forAll(
      'buffer append',
      (b, bs, n) {
        final unbuf = bs.foldLeft(b, (a, b) => a.concat(b));

        final buf = bs.foldLeft(
          b.bufferBy(max(n % 50, 0) + 1),
          (acc, a) => a.foldLeft(acc, (x, y) => x.append(y)),
        );

        expect(unbuf, buf);
      },
      testOn: '!browser',
    );

    (
      byteVector,
      Gen.ilistOf(Gen.chooseInt(0, 10), byteVector),
      Gen.nonNegativeInt,
    ).forAll(
      'buffer concat/take/drop',
      (b, bs, n) {
        final unbuf = bs.foldLeft(b, (a, b) => a.concat(b));
        final buf = bs.foldLeft(
          b.bufferBy(max(n % 50, 0) + 1),
          (a, b) => a.concat(b),
        );

        expect(unbuf, buf);

        final ind = max(n % (unbuf.size + 1), 0) + 1;

        expect(buf.take(ind), unbuf.take(ind));
        expect(buf.drop(ind), unbuf.drop(ind));
      },
    );

    (byteVector, byteVector, byteVector, Gen.integer).forAll(
      'buffer rebuffering',
      (b1, b2, b3, n) {
        final chunkSize = max(n % 50, 0) + 1;

        final b1b = b1.bufferBy(chunkSize);
        final b1b2b3 = b1b.concat(b2).bufferBy(chunkSize + 1).concat(b3);

        expect(b1b2b3, b1.concat(b2).concat(b3));
      },
    );

    test('compact is a no-op for already compact byte vectors', () {
      final b = ByteVector([0x80]);
      expect(b.compact(), b.compact());
    });

    Gen.ilistOf(Gen.chooseInt(0, 10), byteVector).forAll('concat', (bvs) {
      final c = ByteVector.concatAll(bvs);

      expect(c.size, bvs.foldLeft(0, (acc, bv) => acc + bv.size));

      bvs.headOption.foreach((h) => expect(c.startsWith(h), isTrue));
      bvs.lastOption.foreach((l) => expect(c.endsWith(l), isTrue));
    });

    test('drop', () {
      expect(hex("0011223344").drop(3), hex("3344"));
      expect(hex("0011223344").drop(-10), hex("0011223344"));
      expect(hex("0011223344").drop(1000), hex(""));
    });

    byteVector.forAll('dropWhile', (bv) {
      expect(bv.dropWhile((_) => false), bv);
      expect(bv.dropWhile((_) => true), ByteVector.empty);

      final (expected, _) = bv.foldLeft((ByteVector.empty, true), (tuple, b) {
        final (acc, dropping) = tuple;

        if (dropping) {
          if (b == 0) {
            return (acc.append(0), false);
          } else {
            return (acc, true);
          }
        } else {
          return (acc.append(b), false);
        }
      });

      expect(bv.dropWhile((b) => b != 0), expected);
    });

    (byteVector, Gen.integer).forAll('endsWith', (bv, n0) {
      final n = bv.nonEmpty ? (n0 % bv.size).abs() : 0;
      final slice = bv.takeRight(n);

      expect(bv.endsWith(slice), isTrue);

      if (slice.nonEmpty) expect(bv.endsWith(~slice), isFalse);
    });

    byteVector.forAll('foldLeft', (b) {
      expect(b.foldLeft(ByteVector.empty, (acc, b) => acc.append(b)), b);
    });

    byteVector.forAll('foldRight', (b) {
      expect(b.foldRight(ByteVector.empty, (b, acc) => acc.prepend(b)), b);
    });

    byteVector.forAll('grouped + concat', (bv) {
      if (bv.isEmpty) {
        expect(bv.grouped(1).toIList(), nil<int>());
      } else if (bv.size < 3) {
        expect(bv.grouped(bv.size).toIList(), ilist([bv]));
      } else {
        expect(
          bv.grouped(bv.size ~/ 3).toIList().foldLeft(ByteVector.empty, (acc, b) => acc.concat(b)),
          bv,
        );
      }
    });

    byteVector.forAll('headOption', (bv) {
      expect(bv.headOption.isDefined, bv.nonEmpty);

      if (bv.nonEmpty) {
        expect(bv.headOption, isSome(bv.head));
      }
    });

    (byteVector, Gen.integer, Gen.integer).forAll(
      'indexOfSlice / containsSlice / startsWith',
      (bv, m0, n0) {
        final m = bv.nonEmpty ? (m0 % bv.size).abs() : 0;
        final n = bv.nonEmpty ? (n0 % bv.size).abs() : 0;

        final slice = bv.slice(min(m, n), max(m, n));
        final idx = bv.indexOfSlice(slice);

        expect(idx, bv.toIList().indexOfSlice(slice.toIList()));
        expect(bv.containsSlice(slice), isTrue);

        if (bv.nonEmpty) expect(bv.containsSlice(bv.concat(bv)), isFalse);
      },
    );

    byteVector.forAll('init', (bv) {
      expect(bv.startsWith(bv.init), isTrue);

      if (bv.nonEmpty) {
        expect(bv.init.size, bv.size - 1);
      } else {
        expect(bv.init, bv);
      }
    });

    test('insert (1)', () {
      final b = ByteVector.empty;

      expect(b.insert(0, 1), ByteVector([1]));
      expect(
        ByteVector([1, 2, 3, 4]).insert(0, 0),
        ByteVector([0, 1, 2, 3, 4]),
      );
      expect(
        ByteVector([1, 2, 3, 4]).insert(1, 0),
        ByteVector([1, 0, 2, 3, 4]),
      );
    });

    byteVector.forAll('insert (2)', (b) {
      expect(
        b.foldLeft(ByteVector.empty, (acc, b) => acc.insert(acc.size, b)),
        b,
      );
    });

    (byteVector, Gen.byte).forAll('last', (bv, byte) {
      if (bv.nonEmpty) {
        expect(bv.last, bv[bv.size - 1]);
      }

      expect(bv.append(byte).last, byte);
    });

    (byteVector, Gen.byte).forAll('lastOption', (bv, byte) {
      expect(bv.lastOption.isDefined, bv.nonEmpty);
      expect(bv.append(byte).lastOption, isSome(byte));
    });

    byteVector.forAll('padLeft', (bv) {
      expect(() => bv.padLeft(bv.size - 1), throwsArgumentError);
      expect(bv.padLeft(bv.size + 3).size, bv.size + 3);
      expect(bv.padLeft(bv.size + 1).head, 0);
    });

    byteVector.forAll('padRight', (bv) {
      expect(() => bv.padRight(bv.size - 1), throwsArgumentError);
      expect(bv.padRight(bv.size + 3).size, bv.size + 3);
      expect(bv.padRight(bv.size + 1).last, 0);

      expect(bv.padTo(bv.size + 10), bv.padRight(bv.size + 10));
    });

    (byteVector, byteVector, Gen.integer).forAll('patch', (x, y, n0) {
      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;

      expect(x.patch(n, x.slice(n, n)), x);
      expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
    });

    byteVector.forAll('reverse.reverse == id', (b) {
      expect(b.reverse.reverse, b);
    });

    (byteVector, Gen.integer).forAll('rotations', (b, n) {
      expect(b.rotateLeft(b.size * 8), b);
      expect(b.rotateRight(b.size * 8), b);
      expect(b.rotateRight(n).rotateLeft(n), b);
      expect(b.rotateLeft(n).rotateRight(n), b);
    });

    test('slice', () {
      expect(hex("001122334455").slice(1, 4), hex("112233"));
      expect(hex("001122334455").slice(-21, 4), hex("00112233"));
      expect(hex("001122334455").slice(-21, -4), hex(""));
    });

    test('sliding', () {
      final b = hex("1122334455");

      expect(
        b.sliding(2).toIList(),
        ilist([hex('1122'), hex('2233'), hex('3344'), hex('4455')]),
      );
    });

    test('sliding with step', () {
      final b = hex("1122334455");

      expect(
        b.sliding(2, 2).toIList(),
        ilist([hex('1122'), hex('3344'), hex('55')]),
      );
    });

    (byteVector, byteVector, Gen.integer).forAll('splice', (x, y, n0) {
      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;

      expect(x.splice(n, ByteVector.empty), x);
      expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
    });

    byteVector.forAll('splitAt', (bv) {
      expect(bv.splitAt(0), (ByteVector.empty, bv));
      expect(bv.splitAt(bv.size), (bv, ByteVector.empty));

      IList.range(0, bv.size).foreach((n) {
        expect(bv.splitAt(n)((a, b) => a.concat(b)), bv);
      });
    });

    test('take', () {
      expect(hex("0011223344").take(3), hex("001122"));
      expect(hex("0011223344").take(1000), hex("0011223344"));
      expect(hex("0011223344").take(-10), hex(""));
    });

    byteVector.forAll('takeWhile', (bv) {
      final (expected, _) = bv.foldLeft((ByteVector.empty, true), (acct, b) {
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

    Gen.integer.forAll('toInt roundtrip', (n) {
      expect(ByteVector.fromInt(n).toInt(), n);

      expect(
        ByteVector.fromInt(n, ordering: Endian.little).toInt(ordering: Endian.little),
        n,
      );
    });

    test('very large vectors', () {
      final huge = ByteVector.fill(0x1FFFFFFFFFFFFF - 4, 0);
      final huge2 = huge.concat(hex('deadbeef'));

      expect(huge2.takeRight(2), hex('beef'));
    });

    test('zipWith (1)', () {
      final b1 = ByteVector([0, 1, 2, 3]);
      final b2 = ByteVector([1, 2, 3, 4]);

      expect(b1.zipWithI(b2, (a, b) => a + b), ByteVector([1, 3, 5, 7]));
    });

    byteVector.forAll('zipWith2', (b) {
      expect(b.zipWithI(b, (a, b) => a - b), ByteVector.fill(b.size, 0));
    });
  });
}

final class CustomBinAlphabet extends BinaryAlphabet {
  @override
  String toChar(int index) => switch (index) {
    0 => '0',
    1 => '1',
    _ => throw ArgumentError('invalid binary index: $index'),
  };

  @override
  int toIndex(String c) => switch (c) {
    '0' => 0,
    '1' => 1,
    r'$' => Bases.IgnoreRestOfLine,
    _ => throw ArgumentError('Invalid binary char: $c'),
  };

  @override
  bool ignore(String c) => c.trim().isEmpty;
}

final class CustomHexAlphabet extends LenientHex {
  static final chars = ilist([
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
  ]);

  @override
  String toChar(int index) => chars[index];

  @override
  int toIndex(String c) => switch (c) {
    r'$' => Bases.IgnoreRestOfLine,
    _ => super.toIndex(c),
  };
}
