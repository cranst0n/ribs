import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';

final class MacAddress extends Ordered<MacAddress> {
  final Uint8List _bytes;

  const MacAddress._(this._bytes);

  static Option<MacAddress> fromByteList(Iterable<int> bytes) => Option.when(
    () => bytes.length == 6,
    () => MacAddress._(Uint8List.fromList(bytes.toList())),
  );

  static MacAddress fromBytes(
    int b0,
    int b1,
    int b2,
    int b3,
    int b4,
    int b5,
  ) => MacAddress._(
    Uint8List.fromList(
      [b0, b1, b2, b3, b4, b5].map((b) => b & 0xff).toList(),
    ),
  );

  static MacAddress fromInt(int value) {
    final bytes = Uint8List(6);

    var rem = value;

    Range.inclusive(-5, 0, -1).foreach((i) {
      bytes[i] = rem & 0x0ff;
      rem = (rem / 256).floor();
    });

    return MacAddress._(bytes);
  }

  static Option<MacAddress> fromString(String value) {
    final trimmed = value.trim();
    final fields = trimmed.split(':');

    if (fields.length == 6) {
      final result = Uint8List(6);
      var i = 0;

      while (i < result.length) {
        final field = fields[i];
        if (field.length == 2) {
          try {
            result[i] = int.parse(field, radix: 16) & 0xff;
            i++;
          } catch (_) {
            return none();
          }
        } else {
          return none();
        }
      }

      return Some(MacAddress._(result));
    } else {
      return none();
    }
  }

  int toInt() {
    var result = 0;

    for (final b in _bytes) {
      result = (result * 256) + (0x0ff & b);
    }

    return result;
  }

  @override
  int compareTo(MacAddress other) {
    var i = 0;
    var result = 0;

    while (i < _bytes.length && result == 0) {
      result = _bytes[i].compareTo(other._bytes[i]);
      i++;
    }

    return result;
  }

  @override
  bool operator ==(Object that) => switch (that) {
    final MacAddress that => ilist(_bytes).zip(ilist(that._bytes)).forall((t) => t.$1 == t.$2),
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll(_bytes);

  @override
  String toString() =>
      _bytes.toIList().map((b) => b.toRadixString(16).padLeft(2, '0')).mkString(sep: ':');
}
