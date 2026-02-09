import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

final _streamSize = Gen.chooseInt(0, 100);

final intRill = rillOf(Gen.integer);

Gen<Rill<A>> rillOf<A>(Gen<A> gen) => Gen.frequency([
  (
    10,
    Gen.ilistOf(_streamSize, gen).map((l) => Rill.emits(Chunk.from(l)).take(10)),
  ),
  (
    10,
    Gen.ilistOf(
      _streamSize,
      gen,
    ).map((l) => Rill.emits(Chunk.from(l)).take(10).chunkLimit(1).unchunks),
  ),
  (
    5,
    Gen.ilistOf(
      _streamSize,
      gen,
    ).map(
      (l) => Rill.eval(
        l.traverseIO((n) => IO.pure(n)),
      ).flatMap((l) => Rill.emits(Chunk.from(l)).rechunkRandomly(maxFactor: 10.0)),
    ),
  ),
]);
