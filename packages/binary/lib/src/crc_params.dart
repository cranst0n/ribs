import 'package:ribs_binary/ribs_binary.dart';

BitVector _hex(String str) => BitVector.fromValidHex(str);

// TODO: Add more params
class CrcParams {
  final BitVector poly;
  final BitVector initial;
  final bool reflectInput;
  final bool reflectOutput;
  final BitVector finalXor;

  const CrcParams(
    this.poly,
    this.initial,
    this.reflectInput,
    this.reflectOutput,
    this.finalXor,
  );

  int get width => poly.size;

  factory CrcParams.hex(
    String poly,
    String initial,
    bool reflectInput,
    bool reflectOutput,
    String finalXor,
  ) {
    final polyBits = _hex(poly);
    final initialBits = _hex(initial);
    final finalXorBits = _hex(finalXor);

    assert(polyBits.nonEmpty, 'empty polynomial');

    assert(
      polyBits.size == initialBits.size && polyBits.size == finalXorBits.size,
      'poly, initial and finalXor must be same length',
    );

    return CrcParams(
      polyBits,
      initialBits,
      reflectInput,
      reflectOutput,
      finalXorBits,
    );
  }

  factory CrcParams.crc8() => CrcParams.crc8SMBus();

  factory CrcParams.crc8SMBus() => CrcParams.hex('0x07', '0x00', false, false, '0x00');

  factory CrcParams.crc8Rohc() => CrcParams.hex('0x07', '0xff', true, true, '0x00');

  factory CrcParams.crc16() => CrcParams.crc16Arc();

  factory CrcParams.crc16Arc() => CrcParams.hex('0x8005', '0x0000', true, true, '0x0000');

  factory CrcParams.crc16Kermit() => CrcParams.hex('0x1021', '0x0000', true, true, '0x0000');

  factory CrcParams.crc24() => CrcParams.crc24OpenPgp();

  factory CrcParams.crc24OpenPgp() =>
      CrcParams.hex('0x864cfb', '0xb704ce', false, false, '0x000000');

  factory CrcParams.crc32() => CrcParams.crc32IsoHdlc();

  factory CrcParams.crc32IsoHdlc() =>
      CrcParams.hex('0x04c11db7', '0xffffffff', true, true, '0xffffffff');
}
