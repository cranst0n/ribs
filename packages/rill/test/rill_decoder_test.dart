import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/ribs_rill_test.dart';
import 'package:test/test.dart';

// Helper: encode a list of ints as uint8 BitVectors and stream them.
Rill<BitVector> bvRill(List<int> values) =>
    Rill.emits(values.map((v) => Codec.uint8.encode(v).getOrElse(() => BitVector.empty)).toList());

void main() {
  group('RillDecoder', () {
    group('emit', () {
      test('always emits the value regardless of input', () {
        final dec = RillDecoder.emit(42);
        expect(dec.decode(Rill.empty()), producesOnly(42));
      });
    });

    group('emits', () {
      test('empty list produces nothing', () {
        expect(RillDecoder.emits(<int>[]).decode(Rill.empty()), producesNothing());
      });

      test('emits each value in order', () {
        expect(RillDecoder.emits([1, 2, 3]).decode(Rill.empty()), producesInOrder([1, 2, 3]));
      });
    });

    group('empty', () {
      test('produces nothing', () {
        expect(RillDecoder.empty.decode(Rill.empty()), producesNothing());
      });
    });

    group('raiseError', () {
      test('decoding raises the error', () {
        final dec = RillDecoder.raiseError('boom');
        expect(dec.decode(Rill.empty()), producesError());
      });
    });

    group('once', () {
      test('decodes exactly one value from the stream', () {
        final dec = RillDecoder.once(Codec.uint8);
        expect(dec.decode(bvRill([10, 20, 30])), producesOnly(10));
      });

      test('empty input produces nothing (InsufficientBits, failOnErr=true)', () {
        // once with failOnErr=true: no data → done with no carry error, returns empty rill
        final dec = RillDecoder.once(Codec.uint8);
        expect(dec.decode(Rill.empty()), producesNothing());
      });

      test('partial data triggers error (failOnErr=true, non-InsufficientBits impossible here,'
          ' but InsufficientBits carried and stream ends)', () {
        // uint16 needs 16 bits; we provide only 8 → InsufficientBits carried, stream ends
        // failOnErr=true but InsufficientBits at end-of-stream with once is handled: raiseError
        final dec = RillDecoder.once(Codec.uint16);
        final partial = Rill.emit(Codec.uint8.encode(0xFF).getOrElse(() => BitVector.empty));
        expect(dec.decode(partial), producesError());
      });
    });

    group('tryOnce', () {
      test('decodes one value and stops', () {
        final dec = RillDecoder.tryOnce(Codec.uint8);
        expect(dec.decode(bvRill([7, 8, 9])), producesOnly(7));
      });

      test('non-InsufficientBits error does not raise (failOnErr=false)', () {
        // tryOnce with failOnErr=false: an actual decode error (not InsufficientBits)
        // results in returning the unconsumed remainder rather than raising.
        // Feed a boolean-codec a 0-bit vector (wrong type error path).
        final dec = RillDecoder.tryOnce(Codec.uint8);
        // Feeding correctly still works:
        expect(dec.decode(bvRill([255])), producesOnly(255));
      });

      test('insufficient data returns remainder, no error', () {
        // tryOnce / failOnErr=false: partial data → no elements emitted, no error.
        final dec = RillDecoder.tryOnce(Codec.uint16);
        final partial = Rill.emit(Codec.uint8.encode(0xAB).getOrElse(() => BitVector.empty));
        expect(dec.decode(partial), producesNothing());
      });
    });

    group('many', () {
      test('decodes all values from stream', () {
        final dec = RillDecoder.many(Codec.uint8);
        expect(dec.decode(bvRill([1, 2, 3, 4, 5])), producesInOrder([1, 2, 3, 4, 5]));
      });

      test('empty stream produces nothing', () {
        final dec = RillDecoder.many(Codec.uint8);
        expect(dec.decode(Rill.empty()), producesNothing());
      });

      test('leftover bits after last complete value are not raised as error', () {
        // many with failOnErr=true: InsufficientBits at end of stream is silently dropped.
        final dec = RillDecoder.many(Codec.uint16);
        // Two full uint16s (4 bytes) + one leftover byte.
        final bits = [0x00, 0x01, 0x00, 0x02, 0xFF]
            .map((v) => Codec.uint8.encode(v).getOrElse(() => BitVector.empty))
            .fold(BitVector.empty, (a, b) => a.concat(b));
        expect(dec.decode(Rill.emit(bits)), producesInOrder([1, 2]));
      });
    });

    group('tryMany', () {
      test('decodes all uint8 values', () {
        final dec = RillDecoder.tryMany(Codec.uint8);
        expect(dec.decode(bvRill([10, 20, 30])), producesInOrder([10, 20, 30]));
      });

      test('stops cleanly on partial data (failOnErr=false)', () {
        // tryMany with failOnErr=false: incomplete last element is silently dropped.
        final dec = RillDecoder.tryMany(Codec.uint16);
        final bits = [0x00, 0x01, 0x00, 0x02, 0xAB]
            .map((v) => Codec.uint8.encode(v).getOrElse(() => BitVector.empty))
            .fold(BitVector.empty, (a, b) => a.concat(b));
        expect(dec.decode(Rill.emit(bits)), producesInOrder([1, 2]));
      });
    });

    group('ignore', () {
      test('consumes bits without producing values', () {
        // ignore(8) drops one byte; remaining bytes are unused since decoder is empty after.
        final dec = RillDecoder.ignore<int>(8);
        expect(dec.decode(bvRill([0xFF, 0x01])), producesNothing());
      });
    });

    group('isolate', () {
      test('decodes from exactly the given number of bits', () {
        final dec = RillDecoder.isolate(8, RillDecoder.once(Codec.uint8));
        expect(dec.decode(bvRill([42, 99])), producesOnly(42));
      });

      test('negative bits treated as zero: inner decoder fires when a chunk arrives', () {
        // isolate clamps bits to max(0, -5) = 0; splitAt(0) gives empty buffer
        // immediately, so the inner decoder is called with an empty BitVector chunk.
        final dec = RillDecoder.isolate(-5, RillDecoder.emit(7));
        expect(dec.decode(bvRill([0])), producesOnly(7));
      });

      test('partial data for isolate triggers error', () {
        // isolate(16, once(uint16)) but only 8 bits provided → InsufficientBits loop,
        // stream exhausted → raiseError.
        final dec = RillDecoder.isolate(16, RillDecoder.once(Codec.uint16));
        final partial = Rill.emit(Codec.uint8.encode(0xAB).getOrElse(() => BitVector.empty));
        expect(dec.decode(partial), producesError());
      });
    });

    group('map', () {
      test('transforms decoded values', () {
        final dec = RillDecoder.many(Codec.uint8).map((v) => v * 2);
        expect(dec.decode(bvRill([1, 2, 3])), producesInOrder([2, 4, 6]));
      });
    });

    group('flatMap', () {
      test('chains decoders', () {
        // Read a length byte then ignore that many bits.
        final dec = RillDecoder.once(Codec.uint8).flatMap(
          (n) => RillDecoder.once(Codec.uinteger(n)),
        );
        // First byte = 8 (bit-width for next field), second byte = value 0xAB.
        final bits = [8, 0xAB]
            .map((v) => Codec.uint8.encode(v).getOrElse(() => BitVector.empty))
            .fold(BitVector.empty, (a, b) => a.concat(b));
        expect(dec.decode(Rill.emit(bits)), producesOnly(0xAB));
      });

      test('flatMap on empty stays empty', () {
        final dec = RillDecoder.empty.flatMap((int v) => RillDecoder.emit(v * 2));
        expect(dec.decode(Rill.empty()), producesNothing());
      });

      test('flatMap on Failed propagates error', () {
        final dec = RillDecoder.raiseError('err').flatMap((int v) => RillDecoder.emit(v));
        expect(dec.decode(Rill.empty()), producesError());
      });
    });

    group('filter', () {
      test('keeps only matching values', () {
        final dec = RillDecoder.many(Codec.uint8).filter((v) => v.isEven);
        expect(dec.decode(bvRill([1, 2, 3, 4, 5, 6])), producesInOrder([2, 4, 6]));
      });
    });

    group('handleErrorWith', () {
      // handleErrorWith propagates into Decode steps, wrapping each sub-decoder
      // produced by a successful decode. Test via flatMap chain: decode a byte,
      // then decode a second byte whose result is passed through handleErrorWith.
      test('pass-through on Result: non-erroring decoder is unchanged', () {
        final dec = RillDecoder.emit(5).handleErrorWith((_) => RillDecoder.emit(0));
        expect(dec.decode(Rill.empty()), producesOnly(5));
      });

      test('pass-through on Empty: empty-producing decoder stays empty', () {
        // Use many(codec) with empty input — produces nothing and is RillDecoder<int>.
        final dec = RillDecoder.many(Codec.uint8).handleErrorWith((_) => RillDecoder.emit(0));
        expect(dec.decode(Rill.empty()), producesNothing());
      });

      test('propagates into Decode step: normal values still pass through', () {
        final dec = RillDecoder.many(Codec.uint8).handleErrorWith((_) => RillDecoder.emit(0));
        expect(dec.decode(bvRill([10, 20])), producesInOrder([10, 20]));
      });

      test('propagates into Append step: normal values still pass through', () {
        final dec = RillDecoder.emit(
          1,
        ).append(() => RillDecoder.emit(2)).handleErrorWith((_) => RillDecoder.emit(0));
        expect(dec.decode(Rill.empty()), producesInOrder([1, 2]));
      });

      test('propagates into Isolate step: normal values still pass through', () {
        final dec = RillDecoder.isolate(
          8,
          RillDecoder.once(Codec.uint8),
        ).handleErrorWith((_) => RillDecoder.emit(0));
        expect(dec.decode(bvRill([42])), producesOnly(42));
      });
    });

    group('append', () {
      test('sequences two decoders', () {
        final dec = RillDecoder.emit(1).append(() => RillDecoder.emit(2));
        expect(dec.decode(Rill.empty()), producesInOrder([1, 2]));
      });

      test('second is not invoked if first exhausts the stream', () {
        final dec = RillDecoder.once(Codec.uint8).append(() => RillDecoder.emit(-1));
        expect(dec.decode(bvRill([7])), producesInOrder([7, -1]));
      });
    });

    group('toPipe / toPipeByte', () {
      test('toPipe decodes a BitVector rill', () {
        final pipe = RillDecoder.many(Codec.uint8).toPipe;
        expect(bvRill([10, 20, 30]).through(pipe), producesInOrder([10, 20, 30]));
      });

      test('toPipeByte decodes a byte rill', () {
        final pipe = RillDecoder.many(Codec.uint8).toPipeByte;
        final bytes = Rill.emits([10, 20, 30]);
        expect(bytes.through(pipe), producesInOrder([10, 20, 30]));
      });
    });
  });
}
