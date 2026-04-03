import 'package:ribs_binary/ribs_binary.dart';

BitVector _hex(String str) => BitVector.fromValidHex(str);

/// Parameters that fully define a CRC (Cyclic Redundancy Check) algorithm.
///
/// A CRC algorithm is determined by five values:
/// - A generator [poly]nomial.
/// - An [initial] register value.
/// - Whether to [reflectInput] bits within each byte before processing.
/// - Whether to [reflectOutput] the final register before XOR.
/// - A [finalXor] mask applied to the output.
///
/// Use the named factory constructors (e.g. [CrcParams.crc32],
/// [CrcParams.crc16]) to obtain parameters for well-known standards,
/// or [CrcParams.hex] to build custom parameters from hex strings.
///
/// Pass a [CrcParams] to [Crc.from] to obtain a CRC computation function.
///
/// See also:
/// - [Crc], which uses these parameters to perform CRC calculations.
class CrcParams {
  /// The generator polynomial that defines the CRC algorithm.
  ///
  /// The [BitVector.size] of this value determines the [width] of the CRC
  /// in bits (e.g. 8, 16, 32).
  final BitVector poly;

  /// The initial value loaded into the CRC register before processing
  /// any input data.
  ///
  /// Common values are all-zeros (`0x00…`) and all-ones (`0xFF…`).
  final BitVector initial;

  /// Whether each input byte is bit-reflected (LSB-first) before being
  /// fed into the CRC register.
  ///
  /// Many hardware CRC implementations process bits LSB-first, requiring
  /// this flag to be `true` for compatibility.
  final bool reflectInput;

  /// Whether the final CRC register value is bit-reflected before the
  /// [finalXor] is applied.
  final bool reflectOutput;

  /// A bitmask XORed with the (possibly reflected) CRC register to
  /// produce the final checksum value.
  final BitVector finalXor;

  /// Creates a [CrcParams] from the given component values.
  ///
  /// All [BitVector] arguments ([poly], [initial], [finalXor]) must have
  /// the same [BitVector.size].
  const CrcParams(
    this.poly,
    this.initial,
    this.reflectInput,
    this.reflectOutput,
    this.finalXor,
  );

  /// The width of this CRC in bits, equal to the size of the [poly]nomial.
  int get width => poly.size;

  /// Creates [CrcParams] by parsing [poly], [initial], and [finalXor] as
  /// hexadecimal strings.
  ///
  /// The hex strings must encode the same number of bits.
  /// The CRC width is inferred from the hex string length.
  ///
  /// ```dart
  /// // CRC-32 ISO-HDLC
  /// final params = CrcParams.hex(
  ///   '0x04c11db7', '0xffffffff', true, true, '0xffffffff',
  /// );
  /// ```
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

  /// Default CRC-8 parameters.
  ///
  /// Alias for [CrcParams.crc8SMBus].
  factory CrcParams.crc8() => CrcParams.crc8SMBus();

  /// CRC-8/SMBUS parameters.
  ///
  /// - Polynomial: `0x07`
  /// - Initial: `0x00`
  /// - Reflect input/output: `false`
  /// - Final XOR: `0x00`
  factory CrcParams.crc8SMBus() => CrcParams.hex('0x07', '0x00', false, false, '0x00');

  /// CRC-8/ROHC parameters, used in Robust Header Compression.
  ///
  /// - Polynomial: `0x07`
  /// - Initial: `0xFF`
  /// - Reflect input/output: `true`
  /// - Final XOR: `0x00`
  factory CrcParams.crc8Rohc() => CrcParams.hex('0x07', '0xff', true, true, '0x00');

  /// Default CRC-16 parameters.
  ///
  /// Alias for [CrcParams.crc16Arc].
  factory CrcParams.crc16() => CrcParams.crc16Arc();

  /// CRC-16/ARC parameters.
  ///
  /// - Polynomial: `0x8005`
  /// - Initial: `0x0000`
  /// - Reflect input/output: `true`
  /// - Final XOR: `0x0000`
  factory CrcParams.crc16Arc() => CrcParams.hex('0x8005', '0x0000', true, true, '0x0000');

  /// CRC-16/Kermit parameters, used in the Kermit file transfer protocol.
  ///
  /// - Polynomial: `0x1021`
  /// - Initial: `0x0000`
  /// - Reflect input/output: `true`
  /// - Final XOR: `0x0000`
  factory CrcParams.crc16Kermit() => CrcParams.hex('0x1021', '0x0000', true, true, '0x0000');

  /// Default CRC-24 parameters.
  ///
  /// Alias for [CrcParams.crc24OpenPgp].
  factory CrcParams.crc24() => CrcParams.crc24OpenPgp();

  /// CRC-24/OpenPGP parameters, as defined in
  /// [RFC 4880](https://tools.ietf.org/html/rfc4880).
  ///
  /// - Polynomial: `0x864CFB`
  /// - Initial: `0xB704CE`
  /// - Reflect input/output: `false`
  /// - Final XOR: `0x000000`
  factory CrcParams.crc24OpenPgp() =>
      CrcParams.hex('0x864cfb', '0xb704ce', false, false, '0x000000');

  /// Default CRC-32 parameters.
  ///
  /// Alias for [CrcParams.crc32IsoHdlc].
  factory CrcParams.crc32() => CrcParams.crc32IsoHdlc();

  /// CRC-32/ISO-HDLC parameters, the most common CRC-32 variant.
  ///
  /// This is the CRC used by Ethernet, PKZIP, gzip, PNG, and many other
  /// protocols and formats.
  ///
  /// - Polynomial: `0x04C11DB7`
  /// - Initial: `0xFFFFFFFF`
  /// - Reflect input/output: `true`
  /// - Final XOR: `0xFFFFFFFF`
  factory CrcParams.crc32IsoHdlc() =>
      CrcParams.hex('0x04c11db7', '0xffffffff', true, true, '0xffffffff');
}
