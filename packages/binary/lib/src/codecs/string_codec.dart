import 'dart:convert' as convert;

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/codecs/filtered_codec.dart';
import 'package:ribs_core/ribs_core.dart';

final class StringCodec {
  static Codec<String> acsii() {
    final encoder = Encoder.instance((String s) =>
        Either.right(ByteVector.fromList(convert.ascii.encode(s)).bits));

    final decoder = Decoder.instance((bv) => Either.right(
        DecodeResult.successful(convert.ascii.decode(bv.toByteArray()))));

    return Codec.of(decoder, encoder, description: 'ascii');
  }

  static Codec<String> utf8() {
    final encoder = Encoder.instance((String s) =>
        Either.right(ByteVector.fromList(convert.utf8.encode(s)).bits));

    final decoder = Decoder.instance((bv) => Either.right(
        DecodeResult.successful(convert.utf8.decode(bv.toByteArray()))));

    return Codec.of(decoder, encoder, description: 'utf8');
  }

  static Codec<String> utf16() {
    final encoder = Encoder.instance(
        (String s) => Either.right(ByteVector.fromList(s.codeUnits).bits));

    final decoder = Decoder.instance((bv) => Either.right(
        DecodeResult.successful(String.fromCharCodes(bv.toByteArray()))));

    return Codec.of(decoder, encoder, description: 'utf16');
  }

  static Codec<String> cstring() {
    final nul = ByteVector.low(1);
    final filter = Codec.of<BitVector>(
      Decoder.instance((bv) => bv.bytes().indexOfSlice(nul).fold(
          () => Either.left(
              Err.general('Does not contain a NUL termination byte.')),
          (ix) => Either.right(
              DecodeResult(bv.take(ix * 8), bv.drop(ix * 8 + 8))))),
      Encoder.instance((s) => Either.right(s.concat(nul.bits))),
    );

    return FilteredCodec<String>(acsii(), filter);
  }
}
