// ignore_for_file: avoid_print, unused_local_variable

import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';

// #region bitvector-1
// Creating ByteVectors
final bytesA = ByteVector.empty;
final bytesB = ByteVector([0, 12, 32]);
final bytesC = ByteVector.low(10); // 10 bytes with all bits set to 0
final bytesD = ByteVector.high(10); // 10 bytes with all bits set to 1
final bytesE = ByteVector(Uint8List(10));

// Creating BitVectors
final bitsA = BitVector.empty;
final bitsB = BitVector.fromByteVector(bytesA);
final bitsC = BitVector.low(10); // 10 bits all set to 0
final bitsD = BitVector.high(10); // 10 bits all set to 1
// #endregion bitvector-1

void byteVectorOps() {
  // #region bitvector-byte-ops
  final header = ByteVector([0xca, 0xfe, 0xba, 0xbe]);
  final payload = ByteVector([0x01, 0x02, 0x03]);

  // Concatenate two vectors
  final packet = header.concat(payload); // 7 bytes

  // Slice, drop, and take
  final first4 = packet.take(4); // 0xcafebabe
  final rest = packet.drop(4); // 0x010203
  final middle = packet.slice(1, 3); // 0xfeba

  // Split at a position
  final (head, tail) = packet.splitAt(4);

  // Index into individual bytes
  final secondByte = packet[1]; // 0xfe
  final safe = packet.lift(99); // None — index out of range
  // #endregion bitvector-byte-ops
}

void byteVectorEncoding() {
  // #region bitvector-byte-encode
  // Parsing from string representations
  final fromHex = ByteVector.fromValidHex('cafebabe');
  final fromBin = ByteVector.fromValidBin('10110011');
  final fromB64 = ByteVector.fromValidBase64('AAEC');

  // Encoding to string representations
  print(fromHex.toHex()); // cafebabe
  print(fromBin.toBin()); // 10110011
  print(fromB64.toBase64()); // AAEC

  // Hex dump for debugging
  ByteVector([0xde, 0xad, 0xbe, 0xef]).printHexDump();
  // 00000000  de ad be ef                                       |....|
  // #endregion bitvector-byte-encode
}

void byteVectorNumeric() {
  // #region bitvector-byte-numeric
  // Integer ↔ ByteVector (big-endian by default)
  final encoded = ByteVector.fromInt(0x0102, size: 2); // 0x0102
  final value = encoded.toInt(); // 258

  // Unsigned decode (no sign extension)
  final unsigned = ByteVector([0xff]).toUnsignedInt(); // 255
  // #endregion bitvector-byte-numeric
}

void byteVectorBitwise() {
  // #region bitvector-byte-bitwise
  final a = ByteVector.fromValidHex('0f');
  final b = ByteVector.fromValidHex('aa');

  print((a & b).toHex()); // 0a — AND
  print((a | b).toHex()); // af — OR
  print((a ^ b).toHex()); // a5 — XOR
  print((~a).toHex()); // f0 — NOT

  print((a << 2).toHex()); // 3c — left shift
  print((b >> 1).toHex()); // 55 — right shift
  // #endregion bitvector-byte-bitwise
}

void snippet2() {
  // #region bitvector-2
  final bits = BitVector.bits([true, false, true, true, false, false, true, true]);

  print(bits.toBin()); // 10110011
  print('0x${bits.toHex()}'); // 0xb3

  bits.concat(bits); // combine 2 BitVectors
  bits.drop(6); // drop the first 6 bits
  bits.get(7); // get 7th bit
  bits.clear(3); // set bit at index 3 to 0
  bits.set(3); // set bit at index 3 to 1
  // #endregion bitvector-2
}

void bitVectorOps() {
  // #region bitvector-bit-ops
  // Build a 13-bit control field manually
  var frame = BitVector.low(13); // 0000000000000
  frame = frame.set(0); // set the first flag
  frame = frame.set(3); // set a second flag
  frame = frame.clear(0); // clear the first flag again

  // Pad to a byte boundary before serialising
  final aligned = frame.padRight(16); // 16 bits (2 bytes)
  print(aligned.toHex()); // 0008

  // Bitwise operations work identically to ByteVector
  final mask = BitVector.fromValidBin('1010');
  final data = BitVector.fromValidBin('1100');
  print(data.and(mask).toBin()); // 1000
  print((data | mask).toBin()); // 1110
  // #endregion bitvector-bit-ops
}

void conversionSnippet() {
  // #region bitvector-conversion
  // ByteVector → BitVector: every byte expands to 8 bits
  final bytes = ByteVector([0xb3]); // 1 byte
  final bits = bytes.bits; // 8 bits: 10110011

  print(bits.size); // 8
  print(bits.toBin()); // 10110011

  // BitVector → ByteVector: bits are grouped into bytes (last byte zero-padded)
  final tenBits = BitVector.fromValidBin('1011001101'); // 10 bits
  final asBytes = tenBits.bytes; // 2 bytes (last 6 bits padded with zeros)

  print(asBytes.size); // 2
  print(asBytes.toHex()); // b340
  // #endregion bitvector-conversion
}
