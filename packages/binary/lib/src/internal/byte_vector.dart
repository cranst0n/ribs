import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

Either<String, (ByteVector, int)> fromBinInternal(String s) {
  final prefixed = s.startsWith('0b') || s.startsWith('0B');
  final withoutPrefix = prefixed ? s.substring(2) : s;
  int idx = 0;
  int byte = 0;
  int bits = 0;
  int count = 0;
  String? err;
  final bldr = List<int>.empty(growable: true);

  while (idx < withoutPrefix.length && err == null) {
    final c = withoutPrefix[idx];

    if (c == '0' || c == '1') {
      byte = (byte << 1) | (1 & int.parse(c));
      bits += 1;
      count += 1;
    } else {
      err = 'Invalid binary character: $c at index ${idx + (prefixed ? 2 : 0)}';
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
