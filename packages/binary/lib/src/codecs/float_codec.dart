import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class FloatCodec {
  static Codec<double> float32(Endian ordering) => _generic(
    32,
    (bd, f) => bd.buffer.asByteData().setFloat32(0, f, ordering),
    (bd) => bd.getFloat32(0, ordering),
    'float32${ordering == Endian.little ? 'L' : ''}',
  );

  static Codec<double> float64(Endian ordering) => _generic(
    64,
    (bd, f) => bd.buffer.asByteData().setFloat64(0, f, ordering),
    (bd) => bd.getFloat64(0, ordering),
    'float64${ordering == Endian.little ? 'L' : ''}',
  );

  static Codec<double> _generic(
    int nBits,
    Function2<ByteData, double, void> setter,
    Function1<ByteData, double> getter,
    String description,
  ) {
    final encoder = Encoder.instance((double d) {
      final bytes = Uint8List(nBits ~/ 8);
      setter(bytes.buffer.asByteData(), d);
      return Either.right(ByteVector(bytes).bits);
    });

    final decoder = Decoder.instance<double>(
      (bv) => bv
          .acquire(nBits)
          .fold(
            (_) => Either.left(Err.insufficientBits(nBits, bv.size)),
            (bits) => Either.right(
              DecodeResult(
                getter(ByteData.sublistView(bits.toByteArray())),
                bv.drop(nBits),
              ),
            ),
          ),
    );

    return Codec.of(decoder, encoder, description: description);
  }
}
