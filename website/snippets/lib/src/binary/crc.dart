// ignore_for_file: avoid_print, unused_local_variable

import 'package:ribs_binary/ribs_binary.dart';

// crc-1

// All CRC specifications define their expected output on ASCII "123456789",
// which makes a convenient sanity-check value.
final data = ByteVector('123456789'.codeUnits).bits;

// One-liner getters for the four standard widths
final crc8Result = Crc.crc8(data); //    0xf4
final crc16Result = Crc.crc16(data); //  0xbb3d
final crc24Result = Crc.crc24(data); //  0x21cf02
final crc32Result = Crc.crc32(data); //  0xcbf43926

// The result is a BitVector; convert to hex for display or to bytes for a packet
void showResult() {
  print(crc32Result.toHex()); // cbf43926

  // Append a 4-byte CRC-32 checksum to a payload
  final payload = ByteVector.fromValidHex('deadbeef');
  final checksum = Crc.crc32(payload.bits).bytes;
  final packet = payload.concat(checksum); // 8 bytes total
}

// crc-1

// crc-2

// Named presets give access to the full catalogue of standard CRC algorithms.
// Crc.from(CrcParams) turns a preset into a reusable Function1<BitVector, BitVector>.
final kermit16 = Crc.from(CrcParams.crc16Kermit()); // CRC-16/KERMIT
final openPgp24 = Crc.from(CrcParams.crc24OpenPgp()); // CRC-24/OpenPGP
final hdlc32 = Crc.from(CrcParams.crc32IsoHdlc()); // CRC-32/ISO-HDLC

// For algorithms not in CrcParams, supply all five parameters directly:
//   poly, initial, reflectInput, reflectOutput, finalXor
final ccitt16 = Crc.of(
  BitVector.fromValidHex('1021'), // polynomial
  BitVector.fromValidHex('ffff'), // initial register value
  false, // do not reflect input bytes
  false, // do not reflect output
  BitVector.fromValidHex('0000'), // final XOR mask
);

void showCustom() {
  print(ccitt16(ByteVector.fromValidHex('12345670').bits).toHex()); // b1e4
}

// crc-2

// crc-3

// CrcBuilder enables incremental computation: feed data in chunks and call
// result() once at the end. Use this when data arrives in pieces (e.g. from
// a streaming read) without buffering the full message.
final crc32Builder = Crc.builder(
  BitVector.fromValidHex('04c11db7'), // CRC-32 polynomial
  BitVector.fromValidHex('ffffffff'), // initial value
  true, // reflect input
  true, // reflect output
  BitVector.fromValidHex('ffffffff'), // final XOR
);

void showIncremental() {
  final header = ByteVector('HEAD'.codeUnits).bits;
  final body = ByteVector('BODY'.codeUnits).bits;

  final checksum =
      crc32Builder
          .updated(header) // feed first chunk
          .updated(body) //   feed second chunk
          .result(); //        finalise

  print(checksum.toHex());

  // mapResult converts the BitVector result to any other type inline
  final asInt = crc32Builder.updated(header).updated(body).mapResult((bv) => bv.toInt()).result();

  print(asInt); // same checksum as a Dart int
}

// crc-3
