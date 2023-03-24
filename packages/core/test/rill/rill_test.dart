import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  final ints = Rill.iterate(0, (x) => x + 1);

  test('emits', () async {
    final l = List.generate(5, id);
    final s = Rill.emits(l);
    final result = await s.compile().toList().unsafeRunToFuture();

    expect(result, l);
  });

  test('range', () async {
    final integers = Rill.range(0, 5, 1);
    final doubles = Rill.range(0.0, 0.3, 0.1);

    final intList = await integers.compile().toList().unsafeRunToFuture();
    final doubleList = await doubles.compile().toList().unsafeRunToFuture();

    expect(intList, [0, 1, 2, 3, 4]);
    expect(doubleList, [0.0, 0.1, 0.2]);
  });

  test('concat', () async {
    final a = ints.take(5);
    final b = ints.drop(10).take(5);

    final c = await (a + b).compile().toIList().unsafeRunToFuture();

    expect(c, ilist([0, 1, 2, 3, 4, 10, 11, 12, 13, 14]));
  });

  test('pipe', () async {
    final strings =
        ints.through((i) => i.map((i) => String.fromCharCode(i + 65)));

    final result =
        await strings.take(26).compile().toList().unsafeRunToFuture();

    expect(result, List.generate(26, (ix) => String.fromCharCode(ix + 65)));
  });

  test('mapEval', () async {
    var x = 0;

    await Rill.emits([1, 2, 3])
        .repeat()
        .take(7)
        .mapEval((y) => IO.delay(() => x = x + y).as(y))
        .compile()
        .drain()
        .unsafeRunToFuture();

    expect(x, 13);
  });

  test('handleErrorWith', () async {
    final bomb = Rill.eval(IO.delay(() => int.parse('boom')))
        .handleErrorWith((_) => Rill.eval(IO.pure(42)));

    final result = await bomb.compile().toList().unsafeRunToFuture();

    expect(result, [42]);
  });

  test('onComplete', () async {
    bool completed = false;

    final bomb = Rill.eval(IO.delay(() => int.parse('123')))
        .onComplete(() => Rill.eval(IO.delay(() => completed = true).as(666)));

    final result = await bomb.compile().toList().unsafeRunToFuture();

    expect(result, [123, 666]);
    expect(completed, isTrue);
  });

  test('scan', () async {
    final scanned =
        ints.take(10000).scan(0, (x, y) => x + 2).filter((x) => x % 1000 == 0);

    final result = await scanned.compile().last.unsafeRunToFuture();

    expect(result, 20000.some);
  });

  test('takeWhile', () async {
    final smallInts = ints.take(10000).takeWhile((a) => a < 10);

    final result = await smallInts.compile().toList().unsafeRunToFuture();

    expect(result, List.generate(10, id));
  });

  test('dropRight', () async {
    final result =
        await ints.take(50000).dropRight(2).compile().last.unsafeRunToFuture();

    expect(result, 49997.some);
  });

  test('dropWhile', () async {
    final mediumInts = ints.take(100).dropWhile((a) => a < 10).take(10);

    final result = await mediumInts.compile().toList().unsafeRunToFuture();

    expect(result, List.generate(10, (ix) => ix + 10));
  });

  test('zipWithIndex', () async {
    final result = await ints
        .drop(42)
        .take(15)
        .zipWithIndex()
        .compile()
        .last
        .unsafeRunToFuture();

    expect(result, const Tuple2(56, 14).some);
  });

  test('zipWith', () async {
    final a = Rill.emits([1, 2, 3, 4, 5]);
    final b = Rill.emits([5, 4, 3, 2, 1, 0, -1, -2]);

    final c = a.zip(b);

    final result = await c.compile().toList().unsafeRunToFuture();

    expect(
      result,
      [
        const Tuple2(1, 5),
        const Tuple2(2, 4),
        const Tuple2(3, 3),
        const Tuple2(4, 2),
        const Tuple2(5, 1),
      ],
    );
  });

  test('bracket', () async {
    var fileOpen = false;
    var bytesRead = 0;

    const path = '/dev/random';

    IO<RandomAccessFile> aquire(String path) => IO
        .delay(() => fileOpen = true)
        .productR(() => IO.fromFuture(IO.delay(() => File(path).open())));

    Rill<Unit> use(RandomAccessFile raf) =>
        Rill.eval(IO.fromFuture(IO.delay(() => raf.read(1))))
            .repeat()
            .take(3000)
            .zipWithIndex()
            .mapEval((x) {
              final bytes = x.$1;
              final ix = x.$2;

              if (ix == 30) {
                throw StateError('boom...');
              } else {
                return IO.pure(bytes);
              }
            })
            .evalTap((a) => IO.exec(() => bytesRead += a.length))
            .voided();

    IO<Unit> release(RandomAccessFile raf) =>
        IO.delay(() => fileOpen = false).productR(() =>
            IO.fromFuture(IO.delay(() => raf.close().then((value) => Unit()))));

    final program = Rill.bracket(aquire(path), release).flatMap(use);

    await program.compile().drain().attempt().unsafeRunToFuture();

    expect(bytesRead, 30);
    expect(fileOpen, isFalse);
  }, testOn: 'linux');

  test('attempt', () async {
    final s = Rill.emits([1, 2, 3, 4, 5, 6])
        .mapEval(
            (a) => a == 4 ? IO.raiseError<int>(StateError('boom')) : IO.pure(a))
        .attempt();

    final result = await s.compile().toList().unsafeRunToFuture();

    expect(result, hasLength(4));
    expect(result.take(3).toList(), [1, 2, 3].map((x) => x.asRight<IOError>()));
    expect(result[3].isLeft, isTrue);
  });

  test('last', () async {
    final s = Rill.emits([1, 2, 3, 4, 5, 6]);

    final result = await s.compile().last.unsafeRunToFuture();

    expect(result, 6.some);
  });

  test('count', () async {
    final s = Rill.emit(1).repeat().take(1000);

    final result = await s.compile().count().unsafeRunToFuture();

    expect(result, 1000);
  });

  test('string', () async {
    final s = Rill.emits(['h', 'e', 'l', 'l', 'o']);

    final result = await s.compile().string().unsafeRunToFuture();

    expect(result, 'hello');
  });

  test('fromStream', () async {
    final dartStream = Stream.periodic(const Duration(milliseconds: 2), id);
    final rill = Rill.fromStream(dartStream).take(20);

    final result = await rill.compile().toList().unsafeRunToFuture();

    expect(result, List.generate(20, id));
  });

  test('unNone', () async {
    final rill =
        Rill.emits([1.some, 2.some, none<int>(), 4.some, none<int>(), 6.some]);

    final result = await rill.unNone().compile().toList().unsafeRunToFuture();

    expect(result, [1, 2, 4, 6]);
  });

  test('never', () async {
    final a = Rill.emits([1, 2, 3])
        .compile()
        .last
        .delayBy(const Duration(milliseconds: 100));
    final b = (Rill.emit(42) + Rill.never).compile().last;

    final result = await IO.race(a, b).unsafeRunToFuture();

    expect(result, 3.some.asLeft<Option<int>>());
  });

  test('toStream', () async {
    final stream = Rill.emits([1, 2, 3])
        .repeat()
        .take(5)
        .mapEval((a) => IO.sleep(const Duration(milliseconds: 100)).as(a))
        .toStream()
        .asBroadcastStream();

    expect(stream, emitsInOrder([1, 2, 3, 1, 2]));
  });

  test('interleave', () async {
    final odds = Rill.emits([1, 3, 5, 7, 9]);
    final evens = Rill.emits([2, 4, 6, 8, 10]);

    final all = odds.interleave(evens);

    final result = await all.compile().toList().unsafeRunToFuture();

    expect(result, List.generate(10, (ix) => ix + 1));
  });

  test('intersperse', () async {
    final ones = Rill.emits([1, 2, 3]);

    final result =
        await ones.intersperse(0).compile().toList().unsafeRunToFuture();

    expect(result, [1, 0, 2, 0, 3]);
  });

  test('exists', () async {
    final result = await ints
        .mapEval((a) => IO.sleep(const Duration(milliseconds: 100)).as(a))
        .take(12)
        .exists((x) => x == 11)
        .compile()
        .last
        .unsafeRunToFuture();

    expect(result, true.some);
  });

  test('find', () async {
    final result = await ints
        .mapEval((a) => IO.sleep(const Duration(milliseconds: 100)).as(a))
        .take(12)
        .find((x) => x == 11)
        .compile()
        .last
        .unsafeRunToFuture();

    expect(result.flatten(), 11.some);
  });

  test('forall', () async {
    final result = await ints
        .mapEval((a) => IO.sleep(const Duration(milliseconds: 100)).as(a))
        .take(10)
        .forall((x) => x < 10)
        .compile()
        .last
        .unsafeRunToFuture();

    expect(result, true.some);
  });

  test('evalFilter', () async {
    final result = await ints
        .evalFilter((a) => IO.pure(25 < a && a < 75))
        .take(25)
        .compile()
        .last
        .unsafeRunToFuture();

    expect(result, 50.some);
  });

  test('fixedDelay', () async {
    final now = Rill.fixedDelay(const Duration(milliseconds: 100))
        .mapEval((_) => IO
            .delay(() => DateTime.now())
            .delayBy(const Duration(milliseconds: 50)))
        .take(10);

    final result = await now.compile().count().timed().unsafeRunToFuture();

    result(
      (elapsed, count) {
        // (100ms for fixed delay + 50ms for DateTime.now delay) * 10 elements
        expect(elapsed >= const Duration(milliseconds: 1500), isTrue);
        expect(count, 10);
      },
    );
  });

  test('fixedRate', () async {
    final now = Rill.fixedRate(const Duration(milliseconds: 100))
        .mapEval((_) => IO
            .delay(() => DateTime.now())
            .delayBy(const Duration(milliseconds: 50)))
        .take(10);

    final result = await now.compile().count().timed().unsafeRunToFuture();

    result(
      (elapsed, count) {
        expect(elapsed < const Duration(milliseconds: 1200), isTrue);
        expect(count, 10);
      },
    );
  });

  test('filterWithPrevious', () async {
    final rill = Rill.emits([1, 9, 5, 6, 7, 8, 9, 10])
        .filterWithPrevious((previous, current) => previous < current);

    final result = await rill.compile().toList().unsafeRunToFuture();

    expect(result, [1, 9, 10]);
  });

  test('changesBy', () async {
    final rill =
        Rill.emits(['hi', 'on', 'the', 'toy', 'a', 'b', 'ribs', 'hello'])
            .changesBy((a, b) => a.length == b.length);

    final result = await rill.compile().toList().unsafeRunToFuture();

    expect(result, ['hi', 'the', 'a', 'ribs', 'hello']);
  });

  test('split', () async {
    final rill = Rill.range(0, 10, 1).split((a) => a % 4 == 0);

    final result = await rill.compile().toList().unsafeRunToFuture();

    expect(
      result,
      [
        nil<int>(),
        ilist([1, 2, 3]),
        ilist([5, 6, 7]),
        ilist([9]),
      ],
    );
  });

  test('sliding', () async {
    final result = await ints
        .take(5)
        .sliding(2, step: 3)
        .compile()
        .toList()
        .unsafeRunToFuture();

    Future.any([]);

    expect(
      result,
      [
        ilist([0, 1]),
        ilist([3, 4]),
      ],
    );
  });
}
