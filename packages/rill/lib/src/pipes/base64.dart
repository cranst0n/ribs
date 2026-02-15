import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class Base64Pipes {
  static final Base64Pipes _singleton = Base64Pipes._();

  factory Base64Pipes() => _singleton;

  Base64Pipes._();

  Pipe<String, int> get decode => decodeWithAlphabet(Alphabets.base64);
  Pipe<int, String> get encode => encodeWithAlphabet(Alphabets.base64);

  Pipe<String, int> decodeWithAlphabet(Base64Alphabet alphabet) {
    const paddingError =
        'Malformed padding - final quantum may optionally be padded with one or two padding characters such that the quantum is completed';

    Either<String, (_State, Chunk<int>)> decode(_State state, String str) {
      var buffer = state.buffer;
      var mod = state.mod;
      var padding = state.padding;
      var idx = 0;
      var bidx = 0;

      final acc = List.filled((str.length + 3) ~/ 4 * 3, 0);

      while (idx < str.length) {
        final c = str[idx];

        if (!alphabet.ignore(c)) {
          late int cidx;

          if (padding == 0) {
            if (c == alphabet.pad) {
              if (mod == 2 || mod == 3) {
                padding += 1;
                cidx = 0;
              } else {
                return paddingError.asLeft();
              }
            } else {
              try {
                cidx = alphabet.toIndex(c);
              } catch (e) {
                return "Invalid base 64 character '$c' at index $idx".asLeft();
              }
            }
          } else if (c == alphabet.pad) {
            if (padding == 1 && mod == 3) {
              padding += 1;
              cidx = 0;
            } else {
              return paddingError.asLeft();
            }
          } else {
            return "Unexpected character '$c' at index $idx after padding character; only '=' and whitespace characters allowed after first padding character"
                .asLeft();
          }

          if (mod == 0) {
            buffer = cidx & 0x3f;
            mod += 1;
          } else if (mod == 1 || mod == 2) {
            buffer = (buffer << 6) | (cidx & 0x3f);
            mod += 1;
          } else if (mod == 3) {
            buffer = (buffer << 6) | (cidx & 0x3f);
            mod = 0;

            acc[bidx] = (buffer >> 16) & 0xff;
            acc[bidx + 1] = (buffer >> 8) & 0xff;
            acc[bidx + 2] = buffer & 0xff;
            bidx += 3;
          }
        }

        idx += 1;
      }

      final paddingInBuffer = mod == 0 ? padding : 0;

      // TODO: Chunk.byteVector API?
      final out = Chunk.fromList(acc.toIList().take(bidx - paddingInBuffer).toList());
      final carry = _State(buffer, mod, padding);

      return (carry, out).asRight();
    }

    Either<String, Chunk<int>> finish(_State state) {
      if (state.padding != 0 && state.mod != 0) {
        return paddingError.asLeft();
      } else {
        return switch (state.mod) {
          0 => Chunk.empty<int>().asRight(),
          1 => 'Final base 64 quantum had only 1 digit - must hav at least 2 digits'.asLeft(),
          2 => chunk([(state.buffer >> 4) & 0xff]).asRight(),
          3 =>
            chunk([
              (state.buffer >> 10) & 0xff,
              (state.buffer >> 2) & 0xff,
            ]).asRight(),
          _ => 'base64 decode bad mod: ${state.mod}'.asLeft(),
        };
      }
    }

    Pull<int, Unit> go(_State state, Rill<String> rill) {
      return rill.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => finish(state).fold(
            (err) => Pull.raiseError(err),
            (out) => Pull.output(out),
          ),
          (hd, tl) => decode(state, hd).foldN(
            (err) => Pull.raiseError(err),
            (newState, out) => Pull.output(out).append(() => go(newState, tl)),
          ),
        );
      });
    }

    return (rill) => go(_State(0, 0, 0), rill).rill;
  }

  Pipe<int, String> encodeWithAlphabet(Base64Alphabet alphabet) {
    (String, ByteVector) encode(ByteVector c) {
      final bytes = c.toByteArray();
      final bldr = StringBuffer();
      var idx = 0;
      final mod = bytes.length % 3;

      while (idx < bytes.length - mod) {
        var buffer =
            ((bytes[idx] & 0xff) << 16) | ((bytes[idx + 1] & 0xff) << 8) | (bytes[idx + 2] & 0xff);

        final fourth = buffer & 0x3f;
        buffer = buffer >> 6;
        final third = buffer & 0x3f;
        buffer = buffer >> 6;
        final second = buffer & 0x3f;
        buffer = buffer >> 6;
        final first = buffer;

        bldr
          ..write(alphabet.toChar(first))
          ..write(alphabet.toChar(second))
          ..write(alphabet.toChar(third))
          ..write(alphabet.toChar(fourth));

        idx += 3;
      }

      final out = bldr.toString().split('').join();

      if (mod == 0) {
        return (out, ByteVector.empty);
      } else if (mod == 1) {
        return (out, ByteVector.of(bytes[idx]));
      } else {
        return (out, ByteVector.fromDart([bytes[idx], bytes[idx + 1]]));
      }
    }

    Pull<String, Unit> go(ByteVector carry, Rill<int> rill) {
      return rill.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () {
            switch (carry.size) {
              case 0:
                return Pull.done;
              case 1:
                var buffer = (carry[0] & 0xff) << 4;
                final second = buffer & 0x3f;
                buffer = buffer >> 6;

                final first = buffer;
                final out =
                    alphabet.toChar(first) + alphabet.toChar(second) + alphabet.pad + alphabet.pad;

                return Pull.output1(out);
              case 2:
                var buffer = ((carry[0] & 0xff) << 10) | ((carry[1] & 0xff) << 2);
                final third = buffer & 0x3f;
                buffer = buffer >> 6;
                final second = buffer & 0x3f;
                buffer = buffer >> 6;
                final first = buffer;

                final out =
                    alphabet.toChar(first) +
                    alphabet.toChar(second) +
                    alphabet.toChar(third) +
                    alphabet.pad;

                return Pull.output1(out);

              default:
                return Pull.raiseError('carry must be size 0, 1 or 2 but was: ${carry.size}');
            }
          },
          (hd, tl) {
            final (out, newCarry) = encode(carry.concat(ByteVector.from(hd)));
            return Pull.output1(out).append(() => go(newCarry, tl));
          },
        );
      });
    }

    return (rill) => go(ByteVector.empty, rill).rill;
  }
}

final class _State {
  final int buffer;
  final int mod;
  final int padding;

  _State(this.buffer, this.mod, this.padding);
}
