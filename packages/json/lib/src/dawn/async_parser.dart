import 'dart:convert';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/byte_based_parser.dart';
import 'package:ribs_json/src/dawn/dawn.dart';
import 'package:ribs_json/src/dawn/fcontext.dart';

/// Controls how an [AsyncParser] interprets its input stream.
enum AsyncParserMode {
  /// The input is a JSON array; each element is emitted as a separate value.
  unwrapArray(-5, 1),

  /// The input contains multiple whitespace-separated JSON values.
  valueStream(-1, 0),

  /// The input contains exactly one JSON value.
  singleValue(-1, -1);

  final int _start;
  final int _value;

  const AsyncParserMode(this._start, this._value);
}

/// A stateful, incremental JSON parser that accepts data in chunks.
///
/// Call [absorb] / [absorbString] to feed bytes or string chunks, and
/// [finish] / [finalAbsorb] when the last chunk has been delivered. Each call
/// returns `Right(IList<Json>)` containing any values completed so far, or
/// `Left(ParseException)` on a syntax error.
///
/// The parsing mode is set at construction time via [AsyncParserMode]:
/// - [AsyncParserMode.singleValue] — one complete JSON value
/// - [AsyncParserMode.valueStream] — multiple whitespace-separated values
/// - [AsyncParserMode.unwrapArray] — elements of a top-level JSON array
///
/// [AsyncParser] is used internally by [JsonTransformer]; prefer that API for
/// stream-based decoding.
final class AsyncParser extends Parser with ByteBasedParser {
  int _state;
  int _curr;
  FContext? _context;
  List<FContext> _stack;
  final List<int> _data;
  int _len;
  int _offset;
  bool _done;
  int _streamMode;
  final bool _multiValue;

  int _line = 0;
  int _pos = 0;

  factory AsyncParser({
    AsyncParserMode mode = AsyncParserMode.singleValue,
    bool multiValue = false,
  }) => AsyncParser._(
    mode._start,
    0,
    null,
    [],
    List.empty(growable: true),
    0,
    0,
    false,
    mode._value,
    multiValue,
  );

  AsyncParser._(
    this._state,
    this._curr,
    this._context,
    this._stack,
    this._data,
    this._len,
    this._offset,
    this._done,
    this._streamMode,
    this._multiValue,
  );

  /// Feeds [buf] into the parser and returns any [Json] values completed so
  /// far. Does not signal end-of-input; call [finish] when done.
  Either<ParseException, IList<Json>> absorb(Uint8List buf) {
    _done = false;
    _data.addAll(buf);
    _len = _data.length;
    return _churn();
  }

  /// Encodes [buf] as UTF-8 and feeds it to [absorb].
  Either<ParseException, IList<Json>> absorbString(String buf) => absorb(utf8.encoder.convert(buf));

  /// Feeds [buf] and signals end-of-input, returning all remaining [Json]
  /// values or a [ParseException] if the input is incomplete or invalid.
  Either<ParseException, IList<Json>> finalAbsorb(Uint8List buf) => absorb(buf).fold(
    (err) => err.asLeft(),
    (xs) => finish().fold(
      (err) => err.asLeft(),
      (ys) => xs.concat(ys).asRight(),
    ),
  );

  /// Encodes [buf] as UTF-8 and calls [finalAbsorb].
  Either<ParseException, IList<Json>> finalAbsorbString(String buf) =>
      finalAbsorb(utf8.encoder.convert(buf));

  @override
  String at(int i) => String.fromCharCode(byte(i));

  @override
  int atCodeUnit(int i) => byte(i);

  @override
  bool atEof(int i) => _done && i >= _len;

  @override
  String atRange(int i, int j) {
    if (j > _len) throw AsyncException();
    final size = j - i;

    final bytes = _data.getRange(i, i + size);
    return String.fromCharCodes(bytes);
  }

  @override
  int byte(int i) {
    if (i >= _len) {
      throw AsyncException();
    } else {
      return _data[i];
    }
  }

  @override
  void checkpoint(int state, int i, FContext context, List<FContext> stack) {
    _state = state;
    _curr = i;
    _context = context;
    _stack = List.of(stack);
  }

  @override
  void close() {}

  @override
  int column(int i) => i - _pos;

  /// Signals end-of-input and flushes any remaining buffered data, returning
  /// completed [Json] values or a [ParseException].
  Either<ParseException, IList<Json>> finish() {
    _done = true;
    return _churn();
  }

  @override
  int line() => _line;

  @override
  void newline(int i) {
    _line += 1;
    _pos = i + 1;
  }

  @override
  int reset(int i) {
    if (_offset >= 1000000) {
      final diff = _offset;

      _curr -= diff;
      _len -= diff;
      _offset = 0;
      _pos -= diff;

      _data.removeRange(0, diff);

      return i - diff;
    } else {
      return i;
    }
  }

  Either<ParseException, IList<Json>> _churn() {
    final results = List<Json>.empty(growable: true);

    // we rely on exceptions to tell us when we run out of data
    try {
      while (true) {
        if (_state < 0) {
          final b = atCodeUnit(_offset);

          switch (b) {
            case 10: // '\n'
              newline(_offset);
              _offset += 1;
            case 32: // ' '
            case 9: // '\t'
            case 13: // '\r'
              _offset += 1;
            case 91: // '['
              if (_state == _ASYNC_PRESTART) {
                _offset += 1;
                _state = _ASYNC_START;
              } else if (_state == _ASYNC_END) {
                if (_multiValue) {
                  _offset += 1;
                  _state = _ASYNC_START;
                } else {
                  die(_offset, 'expected eof');
                }
              } else if (_state == _ASYNC_POSTVAL) {
                die(_offset, 'expected , or ]');
              } else {
                _state = 0;
              }
            case 44: // ','
              if (_state == _ASYNC_POSTVAL) {
                _offset += 1;
                _state = _ASYNC_PREVAL;
              } else if (_state == _ASYNC_END) {
                die(_offset, 'expected eof');
              } else {
                die(_offset, 'expected json value');
              }
            case 93: // ']'
              if (_state == _ASYNC_POSTVAL || _state == _ASYNC_START) {
                if (_streamMode > 0) {
                  _offset += 1;
                  _state = _ASYNC_END;
                } else {
                  die(_offset, 'expected json value or eof');
                }
              } else if (_state == _ASYNC_END) {
                die(_offset, 'expected eof');
              } else {
                die(_offset, 'expected json value');
              }
            default:
              if (_state == _ASYNC_END) {
                die(_offset, 'expected eof');
              } else if (_state == _ASYNC_POSTVAL) {
                die(_offset, 'expected ] or ,');
              } else {
                if (_state == _ASYNC_PRESTART && _streamMode > 0) {
                  _streamMode = -1;
                }
                _state = 0;
              }
          }
        } else {
          // jump straight back into rparse
          _offset = reset(_offset);
          final (value, j) =
              _state <= 0 ? parseAt(_offset) : iparse(_state, _curr, _context!, _stack);
          if (_streamMode > 0) {
            _state = _ASYNC_POSTVAL;
          } else if (_streamMode == 0) {
            _state = _ASYNC_PREVAL;
          } else {
            _state = _ASYNC_END;
          }

          _curr = j;
          _offset = j;
          _context = null;
          _stack = [];
          results.add(value);
        }
      }
    } on AsyncException {
      if (_done) {
        // if we are done, make sure we ended at a good stopping point
        if (_state == _ASYNC_PREVAL || _state == _ASYNC_END) {
          return ilist(results).asRight();
        } else {
          return ParseException('exhausted input', -1, -1, -1).asLeft();
        }
      } else {
        // we ran out of data, so return what we have so far
        return ilist(results).asRight();
      }
    } on ParseException catch (e) {
      return e.asLeft();
    }
  }

  static const _ASYNC_PRESTART = -5;
  static const _ASYNC_START = -4;
  static const _ASYNC_END = -3;
  static const _ASYNC_POSTVAL = -2;
  static const _ASYNC_PREVAL = -1;
}

/// Internal sentinel thrown when [AsyncParser] runs out of buffered data
/// mid-parse; caught and handled by [AsyncParser] itself.
final class AsyncException implements Exception {}
