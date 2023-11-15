import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

Either<String, (ByteVector, int)> fromBinInternal(
  String s, [
  BinaryAlphabet alphabet = Alphabets.binary,
]) {
  final prefixed = s.startsWith('0b') || s.startsWith('0B');
  final withoutPrefix = prefixed ? s.substring(2) : s;

  var idx = 0;
  var byte = 0;
  var bits = 0;
  var count = 0;

  String? err;

  final bldr = List<int>.empty(growable: true);

  while (idx < withoutPrefix.length && err == null) {
    final c = withoutPrefix[idx];

    if (!alphabet.ignore(c)) {
      try {
        byte = (byte << 1) | (1 & alphabet.toIndex(c));
        bits += 1;
        count += 1;
      } catch (e) {
        err =
            "Invalid binary character '$c' at index ${idx + (prefixed ? 2 : 0)}";
      }
    }

    if (bits == 8) {
      bldr.add(byte);
      byte = 0;
      bits = 0;
    }

    idx += 1;
  }

  if (err == null) {
    if (bits > 0) {
      bldr.add(byte << (8 - bits));
      return (
        ByteVector(Uint8List.fromList(bldr)).shiftRight(8 - bits, false),
        count
      ).asRight();
    } else {
      return (ByteVector(Uint8List.fromList(bldr)), count).asRight();
    }
  } else {
    return err.asLeft();
  }
}

Either<String, (ByteVector, int)> fromHexInternal(
  String str,
  HexAlphabet alphabet,
) {
  final prefixed =
      str.length >= 2 && str[0] == '0' && (str[1] == 'x' || str[1] == 'X');

  final withoutPrefix = prefixed ? str.substring(2) : str;

  var idx = 0;
  var hi = 0;
  var count = 0;
  var midByte = false;

  String? err;

  final length = withoutPrefix.length;
  final out = List.filled((length + 1) ~/ 2, 0);

  var j = 0;

  while (idx < length && err == null) {
    final c = withoutPrefix[idx];

    if (!alphabet.ignore(c)) {
      try {
        final nibble = alphabet.toIndex(c);

        if (nibble >= 0) {
          if (midByte) {
            out[j] = (hi | nibble) & 0xff;
            j += 1;
            midByte = false;
          } else {
            hi = nibble << 4;
            midByte = true;
          }

          count += 1;
        }
      } catch (e) {
        final c = withoutPrefix[idx];

        err =
            "Invalid hexadecimal character '$c' at index ${idx + (prefixed ? 2 : 0)}";
      }
    }

    idx += 1;
  }

  final ByteVector result;

  if (err == null) {
    if (midByte) {
      out[j] = hi & 0xff;
      j += 1;
      result = ByteVector.fromList(out).take(j).shiftRight(4, false);
    } else {
      result = ByteVector.fromList(out).take(j);
    }

    return (result, count).asRight();
  } else {
    return err.asLeft();
  }
}

Either<String, (ByteVector, int)> fromBase32Internal(
  String str,
  Base32Alphabet alphabet,
) {
  const bitsPerChar = 5;

  final pad = alphabet.pad;

  var idx = 0;
  var bidx = 0;
  var buffer = 0;
  var padding = 0;
  var count = 0;

  String? err;

  final acc = List<int>.empty(growable: true);

  while (idx < str.length && err == null) {
    final c = str[idx];

    if (pad != '0' && c == pad) {
      padding += 1;
    } else if (!alphabet.ignore(c)) {
      if (padding > 0) {
        err =
            "Unexpected character '$c' at index $idx after padding character; only '=' and whitespace characters allowed after first padding character";
      }

      try {
        final index = alphabet.toIndex(c);

        buffer |= (index << (8 - bitsPerChar) >>> bidx) & 0xff;
        bidx += bitsPerChar;

        if (bidx >= 8) {
          bidx -= 8;
          acc.add(buffer & 0xff);
          count += 1;

          buffer = (index << (8 - bidx)) & 0xff;
        }
      } catch (e) {
        err = "Invalid base 32 character '$c' at index $idx";
      }
    }

    idx += 1;
  }

  if (err == null) {
    if (bidx >= bitsPerChar) {
      acc.add(buffer);
      count += 1;
    }

    final bytes = ByteVector.fromList(acc);

    final expectedPadding =
        (((bytes.size + bitsPerChar - 1) ~/ bitsPerChar * bitsPerChar) -
                bytes.size) *
            8 /
            bitsPerChar;

    return Either.cond(
      () => padding == 0 || padding == expectedPadding,
      () => (bytes, count),
      () =>
          "Malformed padding - optionally expected $expectedPadding padding characters such that the quantum is completed",
    );
  } else {
    return err.asLeft();
  }
}

Either<String, (ByteVector, int)> fromBase64Internal(
  String str,
  Base64Alphabet alphabet,
) {
  final pad = alphabet.pad;

  var idx = 0;
  var bidx = 0;
  var buffer = 0;
  var mod = 0;
  var padding = 0;

  final acc = List.filled((str.length + 3) ~/ 4 * 3, 0);

  while (idx < str.length) {
    final c = str[idx];

    if (!alphabet.ignore(c)) {
      final int cidx;

      if (padding == 0) {
        if (c == pad) {
          if (mod == 2 || mod == 3) {
            padding += 1;
            cidx = 0;
          } else {
            return Base64PaddingError.asLeft();
          }
        } else {
          try {
            cidx = alphabet.toIndex(c);
          } catch (e) {
            return "Invalid base 64 character '$c' at index $idx".asLeft();
          }
        }
      } else if (c == pad) {
        if (padding == 1 && mod == 3) {
          padding += 1;
          cidx = 0;
        } else {
          return Base64PaddingError.asLeft();
        }
      } else {
        return "Unexpected character '$c' at index $idx after padding character; only '=' and whitespace characters allowed after first padding character"
            .asLeft();
      }

      if (mod == 0) {
        buffer = cidx & 0x3f;
        mod += 1;
      } else if (mod == 1) {
        buffer = (buffer << 6) | (cidx & 0x3f);
        mod += 1;
      } else if (mod == 2) {
        buffer = (buffer << 6) | (cidx & 0x3f);
        mod += 1;
      } else if (mod == 3) {
        buffer = (buffer << 6) | (cidx & 0x3f);
        mod = 0;
        final c = buffer & 0x0ff;
        final b = (buffer >> 8) & 0x0ff;
        final a = (buffer >> 16) & 0x0ff;

        acc[bidx] = a;
        acc[bidx + 1] = b;
        acc[bidx + 2] = c;

        bidx += 3;
      }
    }

    idx += 1;
  }

  if (padding != 0 && mod != 0) {
    return Base64PaddingError.asLeft();
  } else {
    if (mod == 0) {
      return (ByteVector.fromList(acc).take(bidx - padding), bidx).asRight();
    } else if (mod == 1) {
      return 'Final base 64 quantum had only 1 digit - must have at least 2 digits'
          .asLeft();
    } else if (mod == 2) {
      acc[bidx] = (buffer >> 4) & 0x0ff;
      bidx += 1;

      return (ByteVector.fromList(acc).take(bidx), bidx).asRight();
    } else if (mod == 3) {
      acc[bidx] = (buffer >> 10) & 0x0ff;
      acc[bidx + 1] = (buffer >> 2) & 0x0ff;
      bidx += 2;

      return (ByteVector.fromList(acc).take(bidx), bidx).asRight();
    } else {
      return 'Unhandled base 64 padding/mod: $padding/$mod'.asLeft();
    }
  }
}

const Base64PaddingError =
    'Malformed padding - final quantum may optionally be padded with one or two padding characters such that the quantum is completed';

BigInt readBytes(Uint8List bytes) {
  BigInt result = BigInt.zero;

  for (final byte in bytes) {
    // reading in big-endian, so we essentially concat the new byte to the end
    result = (result << 8) | BigInt.from(byte & 0xff);
  }
  return result;
}

IList<int> writeBigInt(BigInt number) {
  BigInt bi = number;

  // Not handling negative numbers. Decide how you want to do that.
  final bytes = (bi.bitLength + 7) >> 3;
  final b256 = BigInt.from(256);
  final result = Uint8List(bytes);
  for (int i = 0; i < bytes; i++) {
    result[bytes - 1 - i] = bi.remainder(b256).toInt();
    bi = bi >> 8;
  }
  return result.toIList();
}
