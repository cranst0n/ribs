import 'dart:convert' as convert;

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/filtered_codec.dart';
import 'package:ribs_core/ribs_core.dart';

/// A collection of codecs for encoding and decoding strings of various encodings.
final class StringCodec {
  /// A codec for ASCII encoded strings.
  static Codec<String> acsii() {
    final encoder = Encoder.instance(
      (String s) => Either.right(ByteVector(convert.ascii.encode(s)).bits),
    );

    final decoder = Decoder.instance(
      (bv) => Either.right(DecodeResult.successful(convert.ascii.decode(bv.toByteArray()))),
    );

    return Codec.of(decoder, encoder, description: 'ascii');
  }

  /// A codec for UTF-8 encoded strings.
  static Codec<String> utf8() {
    final encoder = Encoder.instance(
      (String s) => Either.right(ByteVector(convert.utf8.encode(s)).bits),
    );

    final decoder = Decoder.instance(
      (bv) => Either.right(DecodeResult.successful(convert.utf8.decode(bv.toByteArray()))),
    );

    return Codec.of(decoder, encoder, description: 'utf8');
  }

  /// A codec for UTF-16 encoded strings.
  static Codec<String> utf16() {
    final encoder = Encoder.instance((String s) => Either.right(ByteVector(s.codeUnits).bits));

    final decoder = Decoder.instance(
      (bv) => Either.right(DecodeResult.successful(String.fromCharCodes(bv.toByteArray()))),
    );

    return Codec.of(decoder, encoder, description: 'utf16');
  }

  /// A codec for null-terminated (C-style) ASCII strings.
  static Codec<String> cstring() {
    final nul = ByteVector.low(1);
    final filter = Codec.of<BitVector>(
      Decoder.instance(
        (bv) => bv.bytes
            .indexOfSlice(nul)
            .fold(
              () => Either.left(Err.general('Does not contain a NUL termination byte.')),
              (ix) => Either.right(DecodeResult(bv.take(ix * 8), bv.drop(ix * 8 + 8))),
            ),
      ),
      Encoder.instance((s) => Either.right(s.concat(nul.bits))),
    );

    return FilteredCodec<String>(acsii(), filter);
  }
}
