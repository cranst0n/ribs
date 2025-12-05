import 'package:meta/meta.dart';
import 'package:ribs_binary/ribs_binary.dart';
import 'package:test/test.dart';

void main() {
  group('crc', () {
    testCrcBin('CRC-3/ROHC', '011', '111', true, true, '000', '110');
    testCrcBin('CRC-4/ITU', '0011', '0000', true, true, '0000', '0111');
    testCrcBin('CRC-5/EPC', '01001', '01001', false, false, '00000', '00000');
    testCrcBin('CRC-5/USB', '00101', '11111', true, true, '11111', '11001');

    testCrc(
      'CRC-5/ITU',
      hex('09').drop(1),
      hex('00').drop(1),
      false,
      false,
      hex('00').drop(1),
      hex('75').drop(1),
    );

    testCrc(
      'CRC-7',
      hex('15').drop(3),
      hex('00').drop(3),
      true,
      true,
      hex('00').drop(3),
      hex('07').drop(3),
    );

    test('CRC8', () => expect(Crc.crc8(checkBytes), hex('f4')));

    test('CCITT-16', () {
      final ccitt16 =
          Crc.of(hex('1021'), hex('ffff'), false, false, hex('0000'));

      expect(ccitt16(hex('12345670')), hex('b1e4'));
      expect(ccitt16(hex('5a261977')), hex('1aad'));
    });

    testCrcHex(
      'CRC-32',
      '04c11db7',
      'ffffffff',
      true,
      true,
      'ffffffff',
      'cbf43926',
    );

    testCrcHex(
      'CRC-32c',
      '1edc6f41',
      'ffffffff',
      true,
      true,
      'ffffffff',
      'e3069283',
    );

    testCrcHex(
      'CRC-40/GSM',
      '0004820009',
      '0000000000',
      false,
      false,
      'ffffffffff',
      'd4164fc646',
    );

    testCrc(
      'CRC-82/DARC',
      ByteVector.fromValidHex('0308c0111011401440411').bits.drop(6),
      ByteVector.fromValidHex('000000000000000000000').bits.drop(6),
      true,
      true,
      ByteVector.fromValidHex('000000000000000000000').bits.drop(6),
      ByteVector.fromValidHex('09ea83f625023801fd612').bits.drop(6),
    );
  });

  group('CrcParams', () {
    testCrcParams('Crc8', CrcParams.crc8(), hex('0xf4'));
    testCrcParams('Crc8 / SMBus', CrcParams.crc8(), hex('0xf4'));
    testCrcParams('Crc8 / ROHC', CrcParams.crc8Rohc(), hex('0xd0'));
    testCrcParams('Crc16', CrcParams.crc16Arc(), hex('0xbb3d'));
    testCrcParams('Crc16 / ARC', CrcParams.crc16Arc(), hex('0xbb3d'));
    testCrcParams('Crc16 / Kermit', CrcParams.crc16Kermit(), hex('0x2189'));
    testCrcParams('Crc24', CrcParams.crc24(), hex('0x21cf02'));
    testCrcParams('Crc24 / OpenPgp', CrcParams.crc24OpenPgp(), hex('0x21cf02'));
    testCrcParams('Crc32', CrcParams.crc32(), hex('0xcbf43926'));
    testCrcParams(
        'Crc32 / ISO HDLC', CrcParams.crc32IsoHdlc(), hex('0xcbf43926'));
  });
}

final checkBytes = ByteVector('123456789'.codeUnits).bits;

BitVector bin(String str) => BitVector.fromValidBin(str);
BitVector hex(String str) => BitVector.fromValidHex(str);

@isTest
void testCrcParams(String label, CrcParams crcParams, BitVector expected) {
  test(label, () {
    final crc = Crc.from(crcParams);
    expect(crc(checkBytes), expected);
  });
}

@isTest
void testCrc(
  String label,
  BitVector poly,
  BitVector initial,
  bool reflectInput,
  bool reflectOutput,
  BitVector finalXor,
  BitVector expected,
) {
  final crcParams =
      CrcParams(poly, initial, reflectInput, reflectOutput, finalXor);

  testCrcParams(label, crcParams, expected);
}

@isTest
void testCrcBin(
  String label,
  String poly,
  String initial,
  bool reflectInput,
  bool reflectOutput,
  String finalXor,
  String expected,
) {
  testCrc(
    label,
    bin(poly),
    bin(initial),
    reflectInput,
    reflectOutput,
    bin(finalXor),
    bin(expected),
  );
}

@isTest
void testCrcHex(
  String label,
  String poly,
  String initial,
  bool reflectInput,
  bool reflectOutput,
  String finalXor,
  String expected,
) {
  testCrc(
    label,
    hex(poly),
    hex(initial),
    reflectInput,
    reflectOutput,
    hex(finalXor),
    hex(expected),
  );
}
