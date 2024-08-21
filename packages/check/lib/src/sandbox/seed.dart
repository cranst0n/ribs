import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

final class Seed {
  final int a;
  final int b;
  final int c;
  final int d;

  const Seed(this.a, this.b, this.c, this.d);

  static Seed fromInt(int s) {
    var seed = Seed(0xf1ea5eed, s, s, s);

    var i = 0;
    while (i < 20) {
      seed = seed.next;
      i += 1;
    }

    return seed;
  }

  static Seed random() => Seed.fromInt(Random().nextInt(1 << 32));

  static Seed fromBase64(String s) {
    Never fail(String s) => throw ArgumentError(s);

    int dec(String c) {
      if ('A' <= c && c <= 'Z') {
        return c - 'A';
      } else if ('a' <= c && c <= 'z') {
        return (c - 'a') + 26;
      } else if ('0' <= c && c <= '9') {
        return (c - '0') + 52;
      } else if (c == '-') {
        return 62;
      } else if (c == '_') {
        return 63;
      } else {
        fail("illegal Base64 character: $c");
      }
    }

    final longs = Array.fill(4, 0);

    Seed decode(int x, int shift, int i, int j) {
      if (i >= 43) {
        return Seed(longs[0]!, longs[1]!, longs[2]!, longs[3]!);
      } else {
        final b = dec(s[i]);

        if (shift < 58) {
          return decode(x | (b << shift), shift + 6, i + 1, j);
        } else {
          longs[j] = x | (b << shift);
          final sh = 64 - shift;
          return decode(b >>> sh, 6 - sh, i + 1, j + 1);
        }
      }
    }

    if (s.length != 44) fail('wrong Base64 length');
    if (s[43] != '=') fail('wrong Base64 format: $s');
    if (s[42] == '=') fail('wrong Base64 format: $s');

    return decode(0, 0, 0, 0);
  }

  Seed get next {
    final e = a - Integer.rotateLeft(b, 7);
    final a1 = b ^ Integer.rotateLeft(c, 13);
    final b1 = c + Integer.rotateLeft(d, 37);
    final c1 = d + e;
    final d1 = e + a;

    return Seed(a1, b1, c1, d1);
  }

  Seed slide() {
    final (n, s) = integer;
    return s.reseed(n);
  }

  (int, Seed) get integer => (d, next);

  (double, Seed) get dubble => ((d >>> 11) * 1.1102230246251565e-16, next);

  Seed reseed(int n) {
    final n0 = (n >>> 32) & 0xffffffff;
    final n1 = n & 0xffffffff;
    var i = 0;
    var seed = Seed(a ^ n0, b ^ n1, c, d);

    while (i < 16) {
      seed = seed.next;
      i += 1;
    }

    return seed;
  }

  String get toBase64 {
    String enc(int x) => _Alphabet[(x & 0x3f)];
    final chars = Array.fill(44, '');

    String encode(int x, int shift, int i, IList<int> rest) {
      if (shift < 58) {
        chars[i] = enc(x >>> shift);
        return encode(x, shift + 6, i + 1, rest);
      } else {
        return rest.uncons((hdtl) {
          return hdtl.fold(
            () {
              chars[i] = enc(x >>> 60);
              chars[i + 1] = '=';
              return chars.toList().toIList().mkString();
            },
            (hdtl) {
              final (y, ys) = hdtl;
              final sh = 64 - shift;
              chars[i] = enc((x >>> shift) | (y << sh));
              return encode(y, (6 - sh) % 6, i + 1, ys);
            },
          );
        });
      }
    }

    return encode(a, 0, 0, ilist([b, c, d]));
  }

  @override
  String toString() => toBase64;

  static final IList<String> _Alphabet = IList.range(0, 26)
      .map((cc) => String.fromCharCode('A'.codeUnitAt(0) + cc))
      .concat(IList.range(0, 26)
          .map((cc) => String.fromCharCode('a'.codeUnitAt(0) + cc)))
      .concat(IList.range(0, 10)
          .map((cc) => String.fromCharCode('0'.codeUnitAt(0) + cc)))
      .appended('-')
      .appended('_');
}

extension on String {
  bool operator <=(String that) => compareTo(that) <= 0;

  int operator -(String that) => codeUnitAt(0) - that.codeUnitAt(0);
}
