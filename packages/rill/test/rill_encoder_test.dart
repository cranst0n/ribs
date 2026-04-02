import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/ribs_rill_test.dart';
import 'package:test/test.dart';

void main() {
  group('RillEncoder', () {
    Future<List<int>> decodeBytes(Rill<BitVector> rill) async {
      final bits = await rill.compile.toIList.map((l) => l.toList()).unsafeRunFuture();
      return bits.expand((bv) {
        return List.generate(
          bv.size ~/ 8,
          (i) => bv.slice(i * 8, (i + 1) * 8).toInt(signed: false),
        );
      }).toList();
    }

    group('emit', () {
      test('always outputs fixed bits regardless of input', () async {
        final bits = Codec.uint8.encode(0xAB).getOrElse(() => BitVector.empty);
        final enc = RillEncoder.emit<int>(bits);
        final output = await decodeBytes(enc.encode(Rill.emits([1, 2, 3])));
        expect(output, [0xAB]);
      });
    });

    group('empty', () {
      test('produces no output', () {
        expect(RillEncoder.empty<int>().encode(Rill.emits([1, 2, 3])), producesNothing());
      });
    });

    group('raiseError', () {
      test('raises error during encoding', () {
        final enc = RillEncoder.raiseError<int>('enc-err');
        expect(enc.encode(Rill.emit(1)), producesError());
      });
    });

    group('once', () {
      test('encodes the first element only', () async {
        final enc = RillEncoder.once<int>(Codec.uint8);
        final output = await decodeBytes(enc.encode(Rill.emits([42, 99, 7])));
        expect(output, [42]);
      });

      test('empty stream produces nothing', () {
        final enc = RillEncoder.once<int>(Codec.uint8);
        expect(enc.encode(Rill.empty()), producesNothing());
      });
    });

    group('many', () {
      test('encodes all elements', () async {
        final enc = RillEncoder.many<int>(Codec.uint8);
        final output = await decodeBytes(enc.encode(Rill.emits([1, 2, 3, 4, 5])));
        expect(output, [1, 2, 3, 4, 5]);
      });

      test('empty stream produces nothing', () {
        final enc = RillEncoder.many<int>(Codec.uint8);
        expect(enc.encode(Rill.empty()), producesNothing());
      });
    });

    group('tryOnce', () {
      test('encodes the first element if encoder succeeds', () async {
        final enc = RillEncoder.tryOnce<int>(Codec.uint8);
        final output = await decodeBytes(enc.encode(Rill.emits([55, 66])));
        expect(output, [55]);
      });

      test('empty stream produces nothing', () {
        final enc = RillEncoder.tryOnce<int>(Codec.uint8);
        expect(enc.encode(Rill.empty()), producesNothing());
      });
    });

    group('tryMany', () {
      test('encodes all elements', () async {
        final enc = RillEncoder.tryMany(Codec.uint8);
        final output = await decodeBytes(enc.encode(Rill.emits([10, 20, 30])));
        expect(output, [10, 20, 30]);
      });
    });

    group('append', () {
      test('appends a fallback encoder', () async {
        // emit a fixed byte, then fall through to once
        final fixed = Codec.uint8.encode(0xFF).getOrElse(() => BitVector.empty);
        final enc = RillEncoder.emit<int>(fixed).append(() => RillEncoder.once(Codec.uint8));
        final output = await decodeBytes(enc.encode(Rill.emit(0x0A)));
        expect(output, [0xFF, 0x0A]);
      });
    });

    group('or', () {
      test('uses first encoder when it produces output', () async {
        final enc = RillEncoder.once<int>(Codec.uint8).or(RillEncoder.once(Codec.uint8));
        final output = await decodeBytes(enc.encode(Rill.emit(0x42)));
        expect(output, [0x42]);
      });

      test('falls back to second encoder when first produces nothing', () async {
        final fixed = Codec.uint8.encode(0xBB).getOrElse(() => BitVector.empty);
        final enc = RillEncoder.empty<int>().or(RillEncoder.emit(fixed));
        final output = await decodeBytes(enc.encode(Rill.emit(0x42)));
        expect(output, [0xBB]);
      });
    });

    group('xmap', () {
      test('maps values before encoding', () async {
        // Encode strings as their length (uint8).
        final enc = RillEncoder.once<int>(
          Codec.uint8,
        ).xmap<String>((n) => 'x' * n, (s) => s.length);
        final output = await decodeBytes(enc.encode(Rill.emit('hello')));
        expect(output, [5]);
      });
    });

    group('toPipe / toPipeByte', () {
      test('toPipe encodes a Rill<A> to Rill<BitVector>', () async {
        final pipe = RillEncoder.many<int>(Codec.uint8).toPipe;
        final output = await decodeBytes(Rill.emits([1, 2, 3]).through(pipe));
        expect(output, [1, 2, 3]);
      });

      test('toPipeByte encodes to Rill<int> bytes', () async {
        final pipe = RillEncoder.many<int>(Codec.uint8).toPipeByte;
        final bytes =
            await Rill.emits([
              10,
              20,
              30,
            ]).through(pipe).compile.toIList.map((l) => l.toList()).unsafeRunFuture();
        expect(bytes, [10, 20, 30]);
      });
    });

    group('roundtrip', () {
      test('many encoder + many decoder roundtrips uint8 values', () {
        final enc = RillEncoder.many<int>(Codec.uint8);
        final dec = RillDecoder.many(Codec.uint8);
        final values = Rill.emits([1, 2, 3, 4, 5]);
        expect(values.through(enc.toPipe).through(dec.toPipe), producesInOrder([1, 2, 3, 4, 5]));
      });

      test('many encoder + many decoder roundtrips uint16 values', () {
        final enc = RillEncoder.many<int>(Codec.uint16);
        final dec = RillDecoder.many(Codec.uint16);
        final values = Rill.emits([256, 1000, 65535]);
        expect(values.through(enc.toPipe).through(dec.toPipe), producesInOrder([256, 1000, 65535]));
      });
    });
  });
}
