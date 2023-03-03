import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('emits', () async {
    final l = List.generate(5, id);
    final s = Rill.emits(l);
    final result = await s.compile.toList.unsafeRun();

    expect(result, l);
  });

  test('concat', () async {
    final intRill = Rill.iterate(0, (x) => x + 1);

    final a = intRill.take(5);
    final b = intRill.drop(10).take(5);

    final c = await a.concat(b).compile.toIList.unsafeRun();

    expect(c, ilist([0, 1, 2, 3, 4, 10, 11, 12, 13, 14]));
  });

  test('pipe', () async {
    final ints = Rill.iterate(0, (a) => a + 1);
    final strings =
        ints.through((ints) => ints.map((i) => String.fromCharCode(i + 65)));

    final result = await strings.take(26).compile.toList.unsafeRun();

    expect(result, List.generate(26, (ix) => String.fromCharCode(ix + 65)));
  });

  test('mapEval', () async {
    var x = 0;

    final ints = Rill.emits([1, 2, 3]).repeat;

    await ints
        .take(7)
        .mapEval((y) => IO.sync(() => x = x + y).as(y))
        .compile
        .drain
        .unsafeRun();

    expect(x, 13);
  });

  test('handleErrorWith', () async {
    final bomb = Rill.eval(IO.sync(() => int.parse('boom')))
        .handleErrorWith((_) => Rill.eval(IO.print('defused!').as(42)));

    final result = await bomb.compile.toList.unsafeRun();

    expect(result, [42]);
  });

  test('onComplete', () async {
    final bomb = Rill.eval(IO.sync(() => int.parse('123')))
        .onComplete(() => Rill.eval(IO.print('that').as(666)));

    final result = await bomb.compile.toList.unsafeRun();

    expect(result, [123, 666]);
  });

  test('sandbox', () async {
    const path = '/home/cranston/Desktop/system_config.xml';

    IO<RandomAccessFile> aquire(String path) =>
        IO.fromFuture(() => File(path).open());

    Rill<Unit> use(RandomAccessFile raf) {
      return Rill.eval(IO.fromFuture(() => raf.read(1024)))
          .repeat
          .take(3)
          .mapEval((bytes) => IO.print(String.fromCharCodes(bytes)));
    }

    IO<Unit> release(RandomAccessFile raf) =>
        IO.fromFuture(() => raf.close()).voided;

    final program = Rill.eval(aquire(path)).flatMap((raf) {
      return use(raf).onComplete(() => Rill.eval(release(raf)));
    });

    await program.compile.drain.unsafeRun();
  });
}
