// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';

// bitvector-1

// Creating ByteVectors
final bytesA = ByteVector.empty();
final bytesB = ByteVector.fromList([0, 12, 32]);
final bytesC = ByteVector.low(10); // 10 bytes with all bits set to 0
final bytesD = ByteVector.high(10); // 10 bytes with all bits set to 1
final bytesE = ByteVector(Uint8List(10));

// Creating BitVectors
final bitsA = BitVector.empty();
final bitsB = BitVector.fromByteVector(bytesA);
final bitsC = BitVector.low(8); // 10 bits all set to 0
final bitsD = BitVector.high(8); // 10 bits all set to 1

// bitvector-1

void snippet2() {
  // bitvector-2

  final bits =
      BitVector.bits([true, false, true, true, false, false, true, true]);

  print(bits.toBin()); // 10110011
  print('0x${bits.toHex()}'); // 0xb3

  bits.concat(bits); // combine 2 BitVectors
  bits.drop(6); // drop the first 6 bits
  bits.get(7); // get 7th bit
  bits.clear(3); // set bit at index 3 to 0
  bits.set(3); // set bit at index 3 to 1

  // bitvector-2
}
