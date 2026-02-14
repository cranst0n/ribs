import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';
import 'matchers.dart';

void main() {
  group('text', () {
    group('lines / linesLimited', () {
      forAll('newlines appear in between chunks', stringRill, (lines) {
        expect(lines.intersperse('\n').through(Pipes.text.lines), producesSameAs(lines));
        expect(lines.intersperse('\r\n').through(Pipes.text.lines), producesSameAs(lines));
        expect(lines.intersperse('\r').through(Pipes.text.lines), producesSameAs(lines));
      });

      forAll('single string', stringRill, (lines) async {
        final list = await lines.compile.toList.unsafeRunFuture();

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

      forAll('grouped in 3 character chunks', stringRill, (lines) async {
        final s0 = await lines.intersperse('\r\n').compile.toList.unsafeRunFuture();
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
                  .toList
                  .unsafeRunFutureOutcome();

          final resB =
              await rill
                  .through(Pipes.text.linesLimited(line.length))
                  .compile
                  .toList
                  .unsafeRunFutureOutcome();

          expect(resA.isError, isTrue);
          expect(resB, Outcome.succeeded(ilist([line])));
        }
      });
    });

    group('base64', () {
      forAll3(
        'base64.encode andThen base64.decode',
        Gen.listOf(Gen.chooseInt(0, 20), Gen.listOf(Gen.chooseInt(0, 20), Gen.byte)),
        Gen.boolean,
        Gen.integer,
        (bs, unchunked, rechunkSeed) {
          final actual = bs
              .map(Chunk.fromList)
              .fold(Rill.empty<int>(), (acc, chunk) => acc.append(() => Rill.chunk(chunk)))
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

          expect(actual.compile.toList.map(ByteVector.from), ioSucceeded(expected));
        },
      );

      forAll(
        'optional padding',
        Gen.listOf(Gen.chooseInt(0, 20), Gen.listOf(Gen.chooseInt(0, 20), Gen.byte)),
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

          expect(actual.compile.toList.map(ByteVector.from), ioSucceeded(expected));
        },
      );
    });
  });
}
