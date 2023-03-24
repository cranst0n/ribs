import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class Printer {
  final String indent;
  final String lbraceLeft;
  final String lbraceRight;
  final String rbraceLeft;
  final String rbraceRight;
  final String lbracketLeft;
  final String lbracketRight;
  final String rbracketLeft;
  final String rbracketRight;
  final String lrbracketsEmpty;
  final String arrayCommaLeft;
  final String arrayCommaRight;
  final String objectCommaLeft;
  final String objectCommaRight;
  final String colonLeft;
  final String colonRight;
  final bool dropNullValues;
  final bool escapeNonAscii;

  Printer({
    this.indent = '',
    this.lbraceLeft = '',
    this.lbraceRight = '',
    this.rbraceLeft = '',
    this.rbraceRight = '',
    this.lbracketLeft = '',
    this.lbracketRight = '',
    this.rbracketLeft = '',
    this.rbracketRight = '',
    this.lrbracketsEmpty = '',
    this.arrayCommaLeft = '',
    this.arrayCommaRight = '',
    this.objectCommaLeft = '',
    this.objectCommaRight = '',
    this.colonLeft = '',
    this.colonRight = '',
    this.dropNullValues = false,
    this.escapeNonAscii = false,
  });

  String print(Json json) {
    final folder = _PrintFolder(this);
    json.foldWith(folder);
    return folder.buffer.toString();
  }

  Printer copy({
    String? indent,
    String? lbraceLeft,
    String? lbraceRight,
    String? rbraceLeft,
    String? rbraceRight,
    String? lbracketLeft,
    String? lbracketRight,
    String? rbracketLeft,
    String? rbracketRight,
    String? lrbracketsEmpty,
    String? arrayCommaLeft,
    String? arrayCommaRight,
    String? objectCommaLeft,
    String? objectCommaRight,
    String? colonLeft,
    String? colonRight,
    bool? dropNullValues,
    bool? escapeNonAscii,
  }) =>
      Printer(
        indent: indent ?? this.indent,
        lbraceLeft: lbraceLeft ?? this.lbraceLeft,
        lbraceRight: lbraceRight ?? this.lbraceRight,
        rbraceLeft: rbraceLeft ?? this.rbraceLeft,
        rbraceRight: rbraceRight ?? this.rbraceRight,
        lbracketLeft: lbracketLeft ?? this.lbracketLeft,
        lbracketRight: lbracketRight ?? this.lbracketRight,
        rbracketLeft: rbracketLeft ?? this.rbracketLeft,
        rbracketRight: rbracketRight ?? this.rbracketRight,
        lrbracketsEmpty: lrbracketsEmpty ?? this.lrbracketsEmpty,
        arrayCommaLeft: arrayCommaLeft ?? this.arrayCommaLeft,
        arrayCommaRight: arrayCommaRight ?? this.arrayCommaRight,
        objectCommaLeft: objectCommaLeft ?? this.objectCommaLeft,
        objectCommaRight: objectCommaRight ?? this.objectCommaRight,
        colonLeft: colonLeft ?? this.colonLeft,
        colonRight: colonRight ?? this.colonRight,
        dropNullValues: dropNullValues ?? this.dropNullValues,
        escapeNonAscii: escapeNonAscii ?? this.escapeNonAscii,
      );

  _PiecesAtDepth get _pieces => indent.isEmpty
      ? _ConstantPieces(_Pieces.fromPrinter(this))
      : _MemoizedPieces(this);

  static Printer noSpaces = Printer();

  static Printer spaces2 = indented('  ');

  static Printer spaces4 = indented('    ');

  static Printer indented(String indent) => Printer(
      indent: indent,
      lbraceRight: '\n',
      rbraceLeft: '\n',
      lbracketRight: '\n',
      rbracketLeft: '\n',
      lrbracketsEmpty: '\n',
      arrayCommaRight: '\n',
      objectCommaRight: '\n',
      colonLeft: ' ',
      colonRight: ' ');
}

class _PrintFolder extends JsonFolder<void> {
  final Printer printer;

  final buffer = StringBuffer();
  int depth = 0;

  _PrintFolder(this.printer);

  @override
  void onArray(IList<Json> value) {
    final originalDepth = depth;
    final p = printer._pieces.atDepth(depth);

    if (value.isEmpty) {
      buffer.write(p.lrEmptyBrackets);
    } else {
      final iterator = value.toList().iterator;

      buffer.write(p.lBrackets);

      depth += 1;
      iterator.moveNext();
      iterator.current.foldWith(this);

      depth = originalDepth;

      while (iterator.moveNext()) {
        buffer.write(p.arrayCommas);
        depth += 1;
        iterator.current.foldWith(this);
        depth = originalDepth;
      }

      buffer.write(p.rBrackets);
    }
  }

  @override
  void onBoolean(bool value) => buffer.write(value);

  @override
  void onNull() => buffer.write('null');

  @override
  void onNumber(num value) => value.isFinite ? buffer.write(value) : onNull();

  @override
  void onObject(JsonObject value) {
    final originalDepth = depth;
    final p = printer._pieces.atDepth(depth);

    bool first = true;

    final iterator = value.toIList().toList().iterator;

    buffer.write(p.lBraces);

    while (iterator.moveNext()) {
      final next = iterator.current;

      final key = next.$1;
      final value = next.$2;

      if (!printer.dropNullValues || !value.isNull) {
        if (!first) {
          buffer.write(p.objectCommas);
        }

        onString(key);
        buffer.write(p.colons);

        depth += 1;
        value.foldWith(this);
        depth = originalDepth;
        first = false;
      }
    }

    buffer.write(p.rBraces);
  }

  @override
  void onString(String value) {
    buffer.write('"');

    int i = 0;

    while (i < value.length) {
      final c = value[i];

      final int esc;

      switch (c) {
        case '"':
          esc = '"'.codeUnits[0];
          break;
        case '\\':
          esc = '\\'.codeUnits[0];
          break;
        case '\b':
          esc = 'b'.codeUnits[0];
          break;
        case '\f':
          esc = 'f'.codeUnits[0];
          break;
        case '\n':
          esc = 'n'.codeUnits[0];
          break;
        case '\r':
          esc = 'r'.codeUnits[0];
          break;
        case '\t':
          esc = 't'.codeUnits[0];
          break;
        default:
          esc = printer.escapeNonAscii && c.codeUnitAt(0) > 127 ? 1 : 0;
          break;
      }

      if (esc != 0) {
        buffer.write('\\\\');
        if (esc != 1) {
          buffer.write(String.fromCharCode(esc));
        } else {
          buffer.write(_escapedChar(c.codeUnitAt(0)));
        }
      } else {
        buffer.write(c);
      }

      i += 1;
    }

    buffer.write('"');
  }

  String _escapedChar(int s) {
    return 'u${_toHex((s >> 12) & 15)}'
        '${_toHex((s >> 8) & 15)}'
        '${_toHex((s >> 4) & 15)}'
        '${_toHex((s >> 0) & 15)}';
  }

  String _toHex(int nibble) =>
      String.fromCharCode(nibble + (nibble >= 10 ? 87 : 48));
}

class _Pieces {
  final String lBraces;
  final String rBraces;
  final String lBrackets;
  final String rBrackets;
  final String lrEmptyBrackets;
  final String arrayCommas;
  final String objectCommas;
  final String colons;

  static const openBrace = '{';
  static const closeBrace = '}';
  static const openArray = '[';
  static const closeArray = ']';
  static const comma = ',';
  static const colon = ':';

  const _Pieces(
    this.lBraces,
    this.rBraces,
    this.lBrackets,
    this.rBrackets,
    this.lrEmptyBrackets,
    this.arrayCommas,
    this.objectCommas,
    this.colons,
  );

  factory _Pieces.fromPrinter(Printer p) {
    return _Pieces(
      '${p.lbraceLeft}$openBrace${p.lbraceRight}',
      '${p.rbraceLeft}$closeBrace${p.rbraceRight}',
      '${p.lbracketLeft}$openArray${p.lbracketRight}',
      '${p.lbracketLeft}$closeArray${p.lbracketRight}',
      '$openArray${p.lrbracketsEmpty}$closeArray',
      '${p.arrayCommaLeft}$comma${p.arrayCommaRight}',
      '${p.objectCommaLeft}$comma${p.objectCommaRight}',
      '${p.colonLeft}$colon${p.colonRight}',
    );
  }
}

abstract class _PiecesAtDepth {
  _Pieces atDepth(int i);
}

class _ConstantPieces extends _PiecesAtDepth {
  final _Pieces pieces;

  _ConstantPieces(this.pieces);

  @override
  _Pieces atDepth(int i) => pieces;
}

class _MemoizedPieces extends _PiecesAtDepth {
  final Printer printer;
  final _memoized = <int, _Pieces>{};

  _MemoizedPieces(this.printer);

  @override
  _Pieces atDepth(int i) => _memoized.putIfAbsent(i, () => _compute(i));

  _Pieces _compute(int i) {
    final builder = StringBuffer();

    addIndentation(builder, printer.lbraceLeft, i);
    builder.write(_Pieces.openBrace);
    addIndentation(builder, printer.lbraceRight, i + 1);

    final lBraces = builder.toString();

    builder.clear();

    addIndentation(builder, printer.rbraceLeft, i);
    builder.write(_Pieces.closeBrace);
    addIndentation(builder, printer.rbraceRight, i + 1);

    final rBraces = builder.toString();

    builder.clear();

    addIndentation(builder, printer.lbracketLeft, i);
    builder.write(_Pieces.openArray);
    addIndentation(builder, printer.lbracketRight, i + 1);

    final lBrackets = builder.toString();

    builder.clear();

    addIndentation(builder, printer.rbracketLeft, i);
    builder.write(_Pieces.closeArray);
    addIndentation(builder, printer.rbracketRight, i + 1);

    final rBrackets = builder.toString();

    builder.clear();

    builder.write(_Pieces.openArray);
    addIndentation(builder, printer.lrbracketsEmpty, i);
    builder.write(_Pieces.closeArray);

    final lrEmptyBrackets = builder.toString();

    builder.clear();

    addIndentation(builder, printer.arrayCommaLeft, i + 1);
    builder.write(_Pieces.comma);
    addIndentation(builder, printer.arrayCommaRight, i + 1);

    final arrayCommas = builder.toString();

    builder.clear();

    addIndentation(builder, printer.objectCommaLeft, i + 1);
    builder.write(_Pieces.comma);
    addIndentation(builder, printer.objectCommaRight, i + 1);

    final objectCommas = builder.toString();

    builder.clear();

    addIndentation(builder, printer.colonLeft, i + 1);
    builder.write(_Pieces.colon);
    addIndentation(builder, printer.colonRight, i + 1);

    final colons = builder.toString();

    return _Pieces(lBraces, rBraces, lBrackets, rBrackets, lrEmptyBrackets,
        arrayCommas, objectCommas, colons);
  }

  void addIndentation(StringBuffer builder, String s, int depth) {
    final lastNewLineIndex = s.lastIndexOf('\n');

    if (lastNewLineIndex == -1) {
      builder.write(s);
    } else {
      builder.write('$s${printer.indent * depth}');
    }
  }
}
