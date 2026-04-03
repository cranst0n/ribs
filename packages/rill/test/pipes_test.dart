import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/ribs_rill_test.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('compression', () {
    intRill.forAll('gzip roundtrip', (rill) {
      final bytes = rill.map((i) => i & 0xff);
      final roundtrip = bytes
          .through(Pipes.compression.gzip.encode)
          .through(Pipes.compression.gzip.decode);

      expect(roundtrip, producesSameAs(bytes));
    });
  });
  group('text', () {
    group('lines / linesLimited', () {
      stringRill.forAll('newlines appear in between chunks', (lines) {
        expect(lines.intersperse('\n').through(Pipes.text.lines), producesSameAs(lines));
        expect(lines.intersperse('\r\n').through(Pipes.text.lines), producesSameAs(lines));
        expect(lines.intersperse('\r').through(Pipes.text.lines), producesSameAs(lines));
      });

      stringRill.forAll('single string', (lines) async {
        final list = await lines.compile.toIList.unsafeRunFuture();

        if (list.nonEmpty) {
          final s = await lines.intersperse('\r\n').compile.string.unsafeRunFuture();
          expect(lines, producesSameAs(Rill.emit(s).through(Pipes.text.lines)));
        }
      });

      test('EOF', () {
        ['\n', '\r\n', '\r'].forEach((delimeter) {
          final s = 'a$delimeter';
          expect(Rill.emit(s).through(Pipes.text.lines), producesInOrder(['a', '']));
        });
      });

      stringRill.forAll('grouped in 3 character chunks', (lines) async {
        final s0 = await lines.intersperse('\r\n').compile.toIList.unsafeRunFuture();
        final s = Chunk.from(s0.mkString().grouped(3));

        if (s.isEmpty) {
          expect(Rill.chunk(s).through(Pipes.text.lines), producesNothing());
        } else {
          expect(Rill.chunk(s).through(Pipes.text.lines), producesSameAs(lines));
          expect(
            Rill.chunk(s).chunkLimit(1).unchunks.through(Pipes.text.lines),
            producesSameAs(lines),
          );
        }
      });

      test('linesLimited', () async {
        final line = 'foo' * 100;

        for (final i in List.generate(line.length, (i) => i + 1)) {
          final rill = Rill.emits(line.split('')).chunkN(i).map((ch) => ch.toList().join());

          final resA =
              await rill
                  .through(Pipes.text.linesLimited(10))
                  .compile
                  .toIList
                  .unsafeRunFutureOutcome();

          final resB =
              await rill
                  .through(Pipes.text.linesLimited(line.length))
                  .compile
                  .toIList
                  .unsafeRunFutureOutcome();

          expect(resA.isError, isTrue);
          expect(resB, Outcome.succeeded(ilist([line])));
        }
      });
    });

    group('base64', () {
      (
        Gen.listOf(
          Gen.chooseInt(0, 20),
          Gen.listOf(Gen.chooseInt(0, 20), Gen.byte),
        ),
        Gen.boolean,
        Gen.integer,
      ).forAll(
        'base64.encode andThen base64.decode',
        (bs, unchunked, rechunkSeed) {
          final actual = bs
              .map(Chunk.fromList)
              .fold(
                Rill.empty<int>(),
                (acc, chunk) => acc.append(() => Rill.chunk(chunk)),
              )
              .through(Pipes.text.base64.encode)
              .through((rill) {
                if (unchunked) {
                  return rill.chunkLimit(1).unchunks;
                } else {
                  return rill.rechunkRandomly(seed: rechunkSeed);
                }
              })
              .through((rill) {
                // add some whitespace
                return rill
                    .chunks()
                    .interleave(
                      Rill.emits([' ', '\r\n']).map(Chunk.singleton).repeat(),
                    )
                    .unchunks;
              })
              .through(Pipes.text.base64.decode);

          final expected = ilist(bs)
              .map((bytes) => ByteVector.view(Uint8List.fromList(bytes)))
              .foldLeft(ByteVector.empty, (acc, elem) => acc.concat(elem));

          expect(actual.compile.toIList.map(ByteVector.from), succeeds(expected));
        },
      );

      Gen.listOf(Gen.chooseInt(0, 20), Gen.listOf(Gen.chooseInt(0, 20), Gen.byte)).forAll(
        'optional padding',
        (bs) {
          final actual = bs
              .map(Chunk.fromList)
              .fold(Rill.empty<int>(), (acc, chunk) => acc.append(() => Rill.chunk(chunk)))
              .through(Pipes.text.base64.encode)
              .map((str) => str.takeWhile((c) => c != '='))
              .through(Pipes.text.base64.decode);

          final expected = ilist(bs)
              .map((bytes) => ByteVector.view(Uint8List.fromList(bytes)))
              .foldLeft(ByteVector.empty, (acc, elem) => acc.concat(elem));

          expect(actual.compile.toIList.map(ByteVector.from), succeeds(expected));
        },
      );
    });

    group('hex', () {
      Gen.listOf(Gen.chooseInt(0, 20), Gen.listOf(Gen.chooseInt(0, 20), Gen.byte)).forAll(
        'hex.encode andThen hex.decode',
        (bs) {
          final actual = bs
              .map(Chunk.fromList)
              .fold(Rill.empty<int>(), (acc, chunk) => acc.append(() => Rill.chunk(chunk)))
              .through(Pipes.text.hex.encode)
              .through(Pipes.text.hex.decode);

          final expected = ilist(bs)
              .map((bytes) => ByteVector.fromDart(bytes))
              .foldLeft(ByteVector.empty, (acc, elem) => acc.concat(elem));

          expect(actual.compile.toIList.map(ByteVector.from), succeeds(expected));
        },
      );

      (
        Gen.listOf(Gen.chooseInt(0, 20), Gen.listOf(Gen.chooseInt(0, 20), Gen.byte)),
        Gen.integer,
      ).forAll(
        'hex.encode andThen hex.decode with rechunking',
        (bs, rechunkSeed) {
          final actual = bs
              .map(Chunk.fromList)
              .fold(Rill.empty<int>(), (acc, chunk) => acc.append(() => Rill.chunk(chunk)))
              .through(Pipes.text.hex.encode)
              .rechunkRandomly(seed: rechunkSeed)
              .through(Pipes.text.hex.decode);

          final expected = ilist(bs)
              .map((bytes) => ByteVector.fromDart(bytes))
              .foldLeft(ByteVector.empty, (acc, elem) => acc.concat(elem));

          expect(actual.compile.toIList.map(ByteVector.from), succeeds(expected));
        },
      );

      test('encode known value', () {
        expect(
          Rill.emits([0xde, 0xad, 0xbe, 0xef]).through(Pipes.text.hex.encode),
          producesOnly('deadbeef'),
        );
      });

      test('decode known lowercase hex', () {
        expect(
          Rill.emit('deadbeef').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode uppercase hex', () {
        expect(
          Rill.emit('DEADBEEF').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode strips 0x prefix', () {
        expect(
          Rill.emit('0xdeadbeef').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode strips 0X prefix', () {
        expect(
          Rill.emit('0XDEADBEEF').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode ignores whitespace', () {
        expect(
          Rill.emit('de ad be ef').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode ignores underscores', () {
        expect(
          Rill.emit('de_ad_be_ef').through(Pipes.text.hex.decode),
          producesInOrder([0xde, 0xad, 0xbe, 0xef]),
        );
      });

      test('decode empty stream', () {
        expect(Rill.empty<String>().through(Pipes.text.hex.decode), producesNothing());
      });

      test('decode errors on invalid character', () {
        expect(
          Rill.emit('zz').through(Pipes.text.hex.decode),
          producesError(),
        );
      });

      test('decode errors on odd number of nibbles', () {
        expect(
          Rill.emit('abc').through(Pipes.text.hex.decode),
          producesError(),
        );
      });

      test('encodeWithAlphabet(hexUpper) produces uppercase', () {
        expect(
          Rill.emits([
            0xde,
            0xad,
            0xbe,
            0xef,
          ]).through(Pipes.text.hex.encodeWithAlphabet(Alphabets.hexUpper)),
          producesOnly('DEADBEEF'),
        );
      });

      test('decodeWithAlphabet(hexUpper) roundtrip', () {
        final bytes = [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef];
        expect(
          Rill.emits(bytes)
              .through(Pipes.text.hex.encodeWithAlphabet(Alphabets.hexUpper))
              .through(Pipes.text.hex.decodeWithAlphabet(Alphabets.hexUpper)),
          producesInOrder(bytes),
        );
      });
    });
  });
}
