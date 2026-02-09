// 'Forked' from https://github.com/darkxanter/punycode_converter until it can
// handle some of the validation issues I raised
abstract class Punycode {
  static const _maxInt = 2147483647;
  static const _base = 36;
  static const _tMin = 1;
  static const _tMax = 26;
  static const _skew = 38;
  static const _damp = 700;
  static const _initialBias = 72;
  static const _initialN = 128; // 0x80
  static const _delimiter = '-'; // '\x2D'
  static const _baseMinusTMin = _base - _tMin;

  /// Converts a Punycode Uri to Unicode.
  ///
  /// Only the encoded parts of the [domain] will be converted, i.e.
  /// it doesn't matter if you call it on a string that has already been
  /// converted to Unicode.
  static Uri uriDecode(Uri uri) => uri.replace(host: domainDecode(uri.host));

  /// Converts a Unicode Uri to Punycode.
  ///
  /// Only the non-ASCII parts of the [domain] name will be converted,
  /// i.e. it doesn't matter if you call it with a domain that's already in
  /// ASCII.
  static Uri uriEncode(Uri uri) => uri.replace(host: domainEncode(Uri.decodeComponent(uri.host)));

  /// Converts a Punycode string representing a domain name or an email address
  /// to Unicode.
  ///
  /// Only the encoded parts of the [domain] will be converted, i.e.
  /// it doesn't matter if you call it on a string that has already been
  /// converted to Unicode.
  static String domainDecode(String domain) {
    return _mapDomain(domain, (part) {
      if (part.length > 63 || part.startsWith('-') || part.endsWith('-')) {
        throw PunycodeException.invalidInput();
      }

      return part.startsWith('xn--') ? decode(part.substring(4).toLowerCase()) : part;
    });
  }

  /// Converts a Unicode string representing a domain name or an email address to
  /// Punycode.
  ///
  /// Only the non-ASCII parts of the [domain] name will be converted,
  /// i.e. it doesn't matter if you call it with a domain that's already in
  /// ASCII.
  static String domainEncode(String domain) {
    final regexNonASCII = RegExp(r'[^\0-\x7E]'); // non-ASCII chars
    return _mapDomain(domain, (part) {
      if (part.length > 63 || part.startsWith('-') || part.endsWith('-')) {
        throw PunycodeException.invalidInput();
      }

      return regexNonASCII.hasMatch(part) ? 'xn--${encode(part)}' : part;
    });
  }

  /// Converts a Punycode string of ASCII-only symbols to a string of Unicode symbols.
  ///
  /// For domains use [domainDecode] function.
  static String decode(String inputString) {
    final input = inputString.codeUnits;

    // Don't use UCS-2.
    final output = <int>[];

    // Handle the basic code points: let `basic` be the number of input code
    // points before the last delimiter, or `0` if there is none, then copy
    // the first basic code points to the output.
    final basic = inputString.lastIndexOf(_delimiter).clamp(0, _maxInt);

    for (var j = 0; j < basic; ++j) {
      // if it's not a basic code point
      if (input[j] >= 0x80) {
        throw PunycodeException.notBasic();
      }
      output.add(input[j]);
    }

    // Main decoding loop: start just after the last delimiter if any basic code
    // points were copied; start at the beginning otherwise.

    var i = 0;
    var n = _initialN;
    var bias = _initialBias;
    for (var index = basic > 0 ? basic + 1 : 0; index < input.length;) {
      // `index` is the index of the next character to be consumed.
      // Decode a generalized variable-length integer into `delta`,
      // which gets added to `i`. The overflow checking is easier
      // if we increase `i` as we go, then subtract off its starting
      // value at the end to obtain `delta`.
      final oldI = i;
      for (var w = 1, k = _base; ; k += _base) {
        if (index >= input.length) {
          throw PunycodeException.invalidInput();
        }

        final digit = _basicToDigit(input[index++]);

        if (digit >= _base || digit > ((_maxInt - i) ~/ w)) {
          throw PunycodeException.overflow();
        }

        i += digit * w;
        final t = k <= bias ? _tMin : (k >= bias + _tMax ? _tMax : k - bias);

        if (digit < t) {
          break;
        }

        final baseMinusT = _base - t;
        if (w > _maxInt ~/ baseMinusT) {
          throw PunycodeException.overflow();
        }

        w *= baseMinusT;
      }

      final out = output.length + 1;
      bias = _adapt(i - oldI, out, oldI == 0);

      // `i` was supposed to wrap around from `out` to `0`,
      // incrementing `n` each time, so we'll fix that now:
      if ((i ~/ out) > _maxInt - n) {
        throw PunycodeException.overflow();
      }

      n += i ~/ out;
      i %= out;

      // Insert `n` at position `i` of the output.
      output.insert(i++, n);
    }

    return String.fromCharCodes(output);
  }

  /// Converts a string of Unicode symbols (e.g. a domain name label) to a
  /// Punycode string of ASCII-only symbols.
  ///
  /// For domains use [domainEncode] function.
  static String encode(String inputString) {
    final output = <String>[];

    // Convert the input in UCS-2 to an array of Unicode code points.
    final input = _ucs2decode(inputString);

    // Cache the length.
    final inputLength = input.length;

    // Initialize the state.
    var n = _initialN;
    var delta = 0;
    var bias = _initialBias;

    // Handle the basic code points.
    for (final currentValue in input) {
      if (currentValue < 0x80) {
        output.add(String.fromCharCode(currentValue));
      }
    }

    final basicLength = output.length;
    var handledCPCount = basicLength;

    // `handledCPCount` is the number of code points that have been handled;
    // `basicLength` is the number of basic code points.

    // Finish the basic string with a delimiter unless it's empty.
    if (basicLength > 0) {
      output.add(_delimiter);
    }

    // Main encoding loop:
    while (handledCPCount < inputLength) {
      // All non-basic code points < n have been handled already. Find the next
      // larger one:
      var m = _maxInt;
      for (final currentValue in input) {
        if (currentValue >= n && currentValue < m) {
          m = currentValue;
        }
      }

      // Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
      // but guard against overflow.
      final handledCPCountPlusOne = handledCPCount + 1;
      if (m - n > ((_maxInt - delta) / handledCPCountPlusOne).floor()) {
        throw PunycodeException.overflow();
      }

      delta += (m - n) * handledCPCountPlusOne;
      n = m;

      for (final currentValue in input) {
        if (currentValue < n && ++delta > _maxInt) {
          throw PunycodeException.overflow();
        }
        if (currentValue == n) {
          // Represent delta as a generalized variable-length integer.
          var q = delta;
          for (var k = _base; /* no condition */ ; k += _base) {
            final t = k <= bias ? _tMin : (k >= bias + _tMax ? _tMax : k - bias);
            if (q < t) {
              break;
            }
            final qMinusT = q - t;
            final baseMinusT = _base - t;
            output.add(
              String.fromCharCode(_digitToBasic(t + qMinusT % baseMinusT)),
            );
            q = (qMinusT / baseMinusT).floor();
          }

          output.add(String.fromCharCode(_digitToBasic(q)));
          bias = _adapt(
            delta,
            handledCPCountPlusOne,
            handledCPCount == basicLength,
          );
          delta = 0;
          ++handledCPCount;
        }
      }

      ++delta;
      ++n;
    }
    return output.join();
  }

  /// A simple wrapper to work with domain name strings or email
  /// addresses.
  ///
  /// Returns a new string of characters returned by the [callback] function for [domain].
  static String _mapDomain(String domain, String Function(String) callback) {
    var domainLocal = domain;
    var result = '';

    final parts = domainLocal.split('@');

    if (parts.length > 1) {
      // In email addresses, only the domain name should be encoded. Leave
      // the local part (i.e. everything up to `@`) intact.
      result = '${parts[0]}@';
      domainLocal = parts[1];
    }
    final regexSeparators = RegExp(
      '[\x2E\u3002\uFF0E\uFF61]',
    ); // RFC 3490 separators
    domainLocal = domainLocal.replaceAll(regexSeparators, '\x2E');
    final labels = domainLocal.split('.');
    final encoded = labels.map(callback).join('.');
    return result + encoded;
  }

  /// Creates an array containing the numeric code points of each Unicode
  /// character in the string. While JavaScript uses UCS-2 internally,
  /// this function will convert a pair of surrogate halves (each of which
  /// UCS-2 exposes as separate characters) into a single code point,
  /// matching UTF-16.
  static List<int> _ucs2decode(String string) {
    final output = <int>[];
    var counter = 0;
    final length = string.length;
    while (counter < length) {
      final value = string.codeUnitAt(counter++);
      if (value >= 0xD800 && value <= 0xDBFF && counter < length) {
        // It's a high surrogate, and there is a next character.
        final extra = string.codeUnitAt(counter++);
        if ((extra & 0xFC00) == 0xDC00) {
          // Low surrogate.
          output.add(((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000);
        } else {
          // It's an unmatched surrogate; only append this code unit, in case the
          // next code unit is the high surrogate of a surrogate pair.
          output.add(value);
          counter--;
        }
      } else {
        output.add(value);
      }
    }
    return output;
  }

  /// Converts a basic code point into a digit/integer.
  ///
  /// The numeric value of a basic code point (for use in
  /// representing integers) in the range `0` to `base - 1`, or `base` if
  /// the code point does not represent a value.
  static int _basicToDigit(int codePoint) {
    if (codePoint - 0x30 < 0x0A) {
      return codePoint - 0x16;
    }
    if (codePoint - 0x41 < 0x1A) {
      return codePoint - 0x41;
    }
    if (codePoint - 0x61 < 0x1A) {
      return codePoint - 0x61;
    }
    return _base;
  }

  /// Converts a digit/integer into a basic code point.
  ///
  /// The basic code point whose value (when used for
  /// representing integers) is `digit`, which needs to be in the range
  /// `0` to `base - 1`. If `flag` is non-zero, the uppercase form is
  /// used; else, the lowercase form is used. The behavior is undefined
  /// if `flag` is non-zero and `digit` has no uppercase form.
  static int _digitToBasic(int digit) {
    if (digit >= 0 && digit <= 25) {
      return digit + 'a'.codeUnitAt(0);
    }
    if (digit >= 26 && digit <= 35) {
      return digit - 26 + '0'.codeUnitAt(0);
    }
    throw PunycodeException.invalidInput();
  }

  /// Bias adaptation function as per section 3.4 of RFC 3492.
  /// https://tools.ietf.org/html/rfc3492#section-3.4
  static int _adapt(int delta, int numPoints, bool firstTime) {
    var deltaLocal = delta;

    if (firstTime) {
      deltaLocal ~/= _damp;
    } else {
      deltaLocal ~/= 2;
    }
    deltaLocal += deltaLocal ~/ numPoints;
    var k = 0;
    while (deltaLocal > (_baseMinusTMin * _tMax / 2)) {
      deltaLocal ~/= _baseMinusTMin;
      k += _base;
    }
    return k + (_baseMinusTMin + 1) * deltaLocal ~/ (deltaLocal + _skew);
  }
}

class PunycodeException implements Exception {
  final String message;

  factory PunycodeException.overflow() => const PunycodeException._('overflow');
  factory PunycodeException.notBasic() =>
      const PunycodeException._('Illegal input >= 0x80 (not a basic code point)');
  factory PunycodeException.invalidInput() => const PunycodeException._('Invalid input');

  const PunycodeException._(this.message);
}

extension PunycodeUriExtension on Uri {
  Uri get punyEncoded => Punycode.uriEncode(this);
  Uri get punyDecoded => Punycode.uriDecode(this);
}
