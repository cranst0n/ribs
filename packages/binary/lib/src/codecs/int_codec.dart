import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class IntCodec extends Codec<int> {
  final int bits;
  final bool signed;
  final Endian ordering;

  final int minValue;
  final int maxValue;

  IntCodec(this.bits, this.signed, this.ordering)
      : minValue = signed ? -(1 << (bits - 1)) : 0,
        maxValue = (1 << (signed ? bits - 1 : bits)) - 1;

  @override
  Either<Err, DecodeResult<int>> decode(BitVector bv) {
    return bv.acquire(bits).fold(
      (_) => Either.left(Err.insufficientBits(bits, bv.size)),
      (intBits) {
        final i = intBits.toInt(signed: signed, ordering: ordering);

        if (i > maxValue) {
          return Either.left(Err.general(
              '$i is greating than maximum value $maxValue for $description'));
        } else if (i < minValue) {
          return Either.left(Err.general(
              '$i is less than minimum value $minValue for $description'));
        } else {
          return Either.right(DecodeResult(i, bv.drop(bits)));
        }
      },
    );
  }

  @override
  Either<Err, BitVector> encode(int i) {
    if (i > maxValue) {
      return Either.left(Err.general(
          '$i is greating than maximum value $maxValue for $description'));
    } else if (i < minValue) {
      return Either.left(Err.general(
          '$i is less than minimum value $minValue for $description'));
    } else {
      return Either.right(BitVector.fromInt(i, size: bits, ordering: ordering));
    }
  }

  @override
  String? get description =>
      '${signed ? 'u' : ''}int$bits${ordering == Endian.little ? 'L' : ''}';
}
