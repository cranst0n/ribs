import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class HexPipes {
  static final HexPipes _singleton = HexPipes._();

  factory HexPipes() => _singleton;

  HexPipes._();

  Pipe<String, int> get decode => decodeWithAlphabet(Alphabets.hexLower);
  Pipe<int, String> get encode => encodeWithAlphabet(Alphabets.hexLower);

  Pipe<String, int> decodeWithAlphabet(HexAlphabet alphabet) {
    (Chunk<int>, int, bool) decode1(String str, int hi0, bool midByte0) {
      final bldr = <int>[];
      var idx = 0;
      var hi = hi0;
      var midByte = midByte0;

      while (idx < str.length) {
        final c = str[idx];

        if (!alphabet.ignore(c)) {
          try {
            final nibble = alphabet.toIndex(c);

            if (midByte) {
              bldr.add((hi | nibble) & 0xff);
              midByte = false;
            } else {
              hi = (nibble << 4) & 0xff;
              midByte = true;
            }
          } catch (e) {
            throw "Invalid hexadecimal character: '$c'";
          }
        }

        idx += 1;
      }

      return (Chunk.fromList(bldr.toList()), hi, midByte);
    }

    Pull<int, Unit> go(Rill<String> s, int hi, bool midByte) {
      return s.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => midByte ? Pull.raiseError('Nibble left over') : Pull.done,
          (hd, tl) {
            final (out, newHi, newMidByte) = decode1(hd, hi, midByte);
            return Pull.output(out).append(() => go(tl, newHi, newMidByte));
          },
        );
      });
    }

    Pull<int, Unit> dropPrefix(Rill<String> s, String acc) {
      return s.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            if (acc.length + hd.length < 2) {
              return dropPrefix(tl, acc + hd);
            } else {
              final str = acc + hd;
              final withOutPrefix =
                  str.startsWith('0x') || str.startsWith('0X') ? str.substring(2) : str;

              return go(tl.cons1(withOutPrefix), 0, false);
            }
          },
        );
      });
    }

    return (rill) => dropPrefix(rill, '').rillNoScope;
  }

  Pipe<int, String> encodeWithAlphabet(HexAlphabet alphabet) =>
      (rill) => rill.chunks().map((c) => ByteVector.from(c).toHex(alphabet));
}
