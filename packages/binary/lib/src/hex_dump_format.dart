import 'dart:convert' as convert;

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class HexDumpFormat {
  final bool includeAddressColumn;
  final int dataColumnCount;
  final int dataColumnWidthInBytes;
  final bool includeAsciiColumn;
  final HexAlphabet alphabet;
  final bool ansiEnabled;
  final int addressOffset;
  final int lengthLimit;

  HexDumpFormat._(
    this.includeAddressColumn,
    this.dataColumnCount,
    this.dataColumnWidthInBytes,
    this.includeAsciiColumn,
    this.alphabet,
    this.ansiEnabled,
    this.addressOffset,
    this.lengthLimit,
  );

  static final Default = HexDumpFormat._(
      true, 2, 8, true, Alphabets.hexLower, true, 0, 2147483647);

  static final NoAnsi = Default.withAnsi(false);

  int get numBytesPerLine => dataColumnWidthInBytes * dataColumnCount;
  int get numBitsPerLine => numBytesPerLine * 8;

  String renderBytes(ByteVector bytes) => renderBits(bytes.bits);

  String renderBits(BitVector bits) {
    final bldr = StringBuffer();
    _renderImpl(bits, 0, bldr.write);
    return bldr.toString();
  }

  // ignore: avoid_print
  void printBytes(ByteVector bytes) => printBits(bytes.bits);

  // ignore: avoid_print
  void printBits(BitVector bits) => _renderImpl(bits, 0, (a) => print(a));

  void _renderImpl(
    BitVector bits,
    int position,
    Function1<String, void> onLine,
  ) {
    BitVector bv = bits;
    int pos = position;
    bool takeFullLine = true;

    while (bv.nonEmpty && takeFullLine) {
      takeFullLine = pos + numBytesPerLine <= lengthLimit;

      final bitsToTake =
          takeFullLine ? numBitsPerLine : (lengthLimit - pos) * 8;

      if (bv.nonEmpty && bitsToTake > 0) {
        final bitsInLine = bv.take(bitsToTake);
        final line = _renderLine(bitsInLine.bytes(), addressOffset + pos);

        onLine(line);

        bv = bv.drop(numBitsPerLine);
        pos += bitsInLine.size;
      }
    }
  }

  String _renderLine(ByteVector bytes, int address) {
    final bldr = StringBuffer();

    if (includeAddressColumn) {
      if (ansiEnabled) {
        bldr.write(_Ansi.Faint);
      }

      bldr.write(ByteVector.fromInt(address ~/ 8).toHex(alphabet));

      if (ansiEnabled) {
        bldr.write(_Ansi.Normal);
      }

      bldr.write('  ');
    }

    bytes.grouped(dataColumnWidthInBytes).forEach((columnBytes) {
      _renderHex(bldr, columnBytes);
      bldr.write(' ');
    });

    if (ansiEnabled) {
      bldr.write(_Ansi.Reset);
    }

    if (includeAsciiColumn) {
      final bytesOnThisLine = bytes.size;
      final dataBytePadding = (numBytesPerLine - bytesOnThisLine) * 3 - 1;
      final numFullDataColumns =
          (bytesOnThisLine - 1) ~/ dataColumnWidthInBytes;
      final numAdditionalColumnSpacers = dataColumnCount - numFullDataColumns;
      final padding = dataBytePadding + numAdditionalColumnSpacers;

      bldr.write(' ' * padding);
      bldr.write('|');
      _renderAsciiBestEffort(bldr, bytes);
      bldr.write('|');
    }

    bldr.write('\n');
    return bldr.toString();
  }

  void _renderHex(StringBuffer bldr, ByteVector bytes) {
    bytes.forEach((b) {
      if (ansiEnabled) {
        _Ansi.foregroundColor(bldr, _rgbForByte(b));
      }

      bldr
        ..write(alphabet.toChar(b >> 4 & 0x0f))
        ..write(alphabet.toChar(b & 0x0f))
        ..write(' ');
    });
  }

  (int, int, int) _rgbForByte(int b) {
    const saturation = 0.4;
    const value = 0.75;
    final hue = ((b & 0xff) / 256.0) * 360.0;

    return _hsvToRgb(hue, saturation, value);
  }

  (int, int, int) _hsvToRgb(double hue, double saturation, double value) {
    final c = saturation * value;
    final h = hue / 60;
    final x = c * (1 - (h % 2 - 1).abs());
    const z = 0.0;

    final (r1, g1, b1) = switch (h.toInt()) {
      0 => (c, x, z),
      1 => (x, c, z),
      2 => (z, c, x),
      3 => (z, x, c),
      4 => (x, z, c),
      5 => (c, z, x),
      _ => throw Exception('bad h: $h'),
    };

    final m = value - c;
    final (r, g, b) = (r1 + m, g1 + m, b1 + m);

    int scale(double v) => (v * 256).toInt();

    return (scale(r), scale(g), scale(b));
  }

  final _FaintDot = '${_Ansi.Faint}.${_Ansi.Normal}';
  final _FaintUnmappable = '${_Ansi.Faint}�${_Ansi.Normal}';

  void _renderAsciiBestEffort(StringBuffer bldr, ByteVector bytes) {
    final decoded =
        convert.ascii.decode(bytes.toByteArray(), allowInvalid: true);
    final nonPrintableReplacement = ansiEnabled ? _FaintDot : '.';
    final printable =
        _replaceNoPrintable(decoded, replaceWith: nonPrintableReplacement);
    final colorized =
        ansiEnabled ? printable.replaceAll("�", _FaintUnmappable) : printable;

    bldr.write(colorized);
  }

  String _replaceNoPrintable(String value, {String replaceWith = ' '}) {
    final charCodes = <int>[];

    for (final codeUnit in value.codeUnits) {
      if (32 <= codeUnit && codeUnit <= 126) {
        charCodes.add(codeUnit);
      } else {
        if (replaceWith.isNotEmpty) {
          charCodes.add(replaceWith.codeUnits[0]);
        }
      }
    }

    return String.fromCharCodes(charCodes);
  }

  HexDumpFormat withAnsi(bool ansiEnabled) => HexDumpFormat._(
      includeAddressColumn,
      dataColumnCount,
      dataColumnWidthInBytes,
      includeAsciiColumn,
      alphabet,
      ansiEnabled,
      addressOffset,
      lengthLimit);
}

final class _Ansi {
  static const Faint = '\u001b[;2m';
  static const Normal = '\u001b[;22m';
  static const Reset = '\u001b[0m';

  static void foregroundColor(StringBuffer bldr, (int, int, int) rgb) {
    bldr
      ..write("\u001b[38;2;")
      ..write(rgb.$1)
      ..write(";")
      ..write(rgb.$2)
      ..write(";")
      ..write(rgb.$3)
      ..write("m");
  }
}
