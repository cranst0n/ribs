// ignore_for_file: avoid_print

import 'package:ribs_binary/ribs_binary.dart';

void main() async {
  // BitVector: Bit-level manipulation
  final bv = BitVector.fromValidHex('0a0b');
  print('Original BitVector (hex): ${bv.toHex()}');
  print('Size in bits: ${bv.size}');

  // Drop first 4 bits, take next 8 bits, and concat with 0xff
  final manipulated = bv.drop(4).take(8).concat(BitVector.fromInt(0xff, size: 8));
  print('Manipulated BitVector (hex): ${manipulated.toHex()}');
  print('Bits: ${manipulated.toBin()}');

  // ByteVector: Byte-level handling
  final byteVec = ByteVector.fromValidHex('deadbeef');
  print('ByteVector (hex): ${byteVec.toHex()}');
  print('As Base64: ${byteVec.toBase64()}');

  // Check for a prefix
  if (byteVec.startsWith(ByteVector.fromValidHex('dead'))) {
    print('The vector starts with "dead"!');
  }

  // Define a simple domain model
  final messageCodec = (
    Codec.uint16, // ID
    Codec.boolean, // Flag
    Codec.variableSized(Codec.uint8, Codec.utf8), // Name
  ).product(
    (int id, bool flag, String name) => Message(id, flag, name),
    (Message m) => (m.id, m.flag, m.name),
  );

  final myMsg = Message(1024, true, 'Ribs Binary');
  print('Original Message: $myMsg');

  // Encode
  final encoded = messageCodec.encode(myMsg).getOrElse(() => BitVector.empty);
  print('Encoded Message (hex): ${encoded.toHex()}');

  // Decode
  final decoded = messageCodec
      .decode(encoded)
      .fold(
        (Err err) => throw Exception('Decode failed: $err'),
        (DecodeResult<Message> result) => result.value,
      );

  print('Decoded Message: $decoded');

  // Simulate a stream of binary data arriving in chunks
  final part1 = encoded.take(16); // ID + some bits
  final part2 = encoded.drop(16); // The rest

  final bitStream = Stream.fromIterable([part1, part2]);

  // Use StreamDecoder to incrementally decode the Message from the stream
  final decodedStream = bitStream.transform(StreamDecoder<Message>(messageCodec));

  await for (final msg in decodedStream) {
    print('Decoded from stream: $msg');
  }
}

class Message {
  final int id;
  final bool flag;
  final String name;

  Message(this.id, this.flag, this.name);

  @override
  String toString() => 'Message(id: $id, flag: $flag, name: "$name")';
}
