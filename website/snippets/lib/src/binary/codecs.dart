// ignore_for_file: avoid_print

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

// codecs-1

final class Document {
  final Header header;
  final IList<Message> messages;

  const Document(this.header, this.messages);
}

final class Header {
  final double version;
  final String comment;
  final int numMessages;

  const Header(this.version, this.comment, this.numMessages);
}

sealed class Message {}

final class Info extends Message {
  final String message;

  Info(this.message);
}

final class Debug extends Message {
  final int lineNumber;
  final String message;

  Debug(this.lineNumber, this.message);
}

// codecs-1

// codecs-2

final infoCodec = utf16_32.xmap((str) => Info(str), (info) => info.message);

final debugCodec = Codec.product2(
  int32L, // 32-bit little endian int
  ascii32, // ascii bytes with 32bit size prefix
  Debug.new,
  (dbg) => (dbg.lineNumber, dbg.message),
);

// codecs-2

// codecs-3

final messageCodec = discriminatedBy(
  uint8, // encode identifier using an 8-bit integer
  imap({
    0: infoCodec, // instances of Info prefixed by ID 0
    1: debugCodec, // instances of Debug prefixed by ID 1
  }),
);

// codecs-3

// codecs-4

final documentCodec = Codec.product2(
  headerCodec,
  // ilist of Messages with 16-bit int prefix indicating # of elements
  ilistOfN(int16, messageCodec),
  Document.new,
  (doc) => (doc.header, doc.messages),
);

final headerCodec = Codec.product3(
  float32, // 32-bit floating point
  utf8_32, // utf8 bytes with 32bit size prefix
  int64, // 64-bit integer
  (version, comment, numMessages) => Header(version, comment, numMessages),
  (hdr) => (hdr.version, hdr.comment, hdr.numMessages),
);

// codecs-4

void snippet5() {
  // codecs-5
  final doc = Document(
      const Header(1.1, 'Top Secret', 3),
      IList.of([
        Info('Hello!'),
        Debug(123, 'breakpoint-1'),
        Info('Goodbye!'),
      ]));

  // Encoding will give us an error or the successfully encoded BitVector
  final Either<Err, BitVector> bits = documentCodec.encode(doc);

  print(bits);
  // Right(3f8ccccd00000050546f702053656372657400000000000000030003000000003048656c6c6f21017b00000000000060627265616b706f696e742d310000000040476f6f6462796521)

  // Decoding will give us either an error if it failed or the DecodeResult
  // A DecodeResult gives us the successfully decoded value and any remaining bits from the input
  // ** Note the throw is included only for edification purposes. This is not a good idea in production code
  final Either<Err, DecodeResult<Document>> decoded = documentCodec
      .decode(bits.getOrElse(() => throw Exception('encode failed!')));

  print(decoded);
  // Right(DecodeResult(Instance of 'Document', ByteVector.empty))

  // codecs-5
}
