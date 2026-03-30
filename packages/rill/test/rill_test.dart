import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/test.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';
import 'counter.dart';

// yolo-mode
extension<A> on Rill<A> {
  Future<IList<A>> get toList => compile.toIList.unsafeRunFuture();
}

void main() {
  test('stack safety - stepPull deeply nested flatMap', () {
    const n = 2000000;
    final test = Rill.chunk(Chunk.fill(n, 0)).flatMap((x) => Rill.emit(x + 1)).compile.drain;
    expect(test, succeeds(Unit()));
  });

  test('stack safety - stepPull deeply nested flatMap with type change', () {
    const n = 2000000;
    final test = Rill.chunk(Chunk.fill(n, 42)).flatMap((x) => Rill.emit('v=$x')).compile.count;
    expect(test, succeeds(n));
  });

  group('bracket', () {
    test('basic', () async {
      final buffer = StringBuffer();

      final test = Rill.bracket(
            IO.exec(() => buffer.writeln('Acquired')),
            (_) {
              buffer.writeln('ReleaseInvoked');
              return IO.exec(() => buffer.writeln('Released'));
            },
          )
          .flatMap((_) {
            buffer.writeln('Used');
            return Rill.emit(Unit());
          })
          .flatMap((s) {
            buffer.writeln('FlatMapped');
            return Rill.emit(s);
          });

      await expectLater(test.compile.drain, succeeds(Unit()));
      expect(buffer.toString().split('\n').where((l) => l.isNotEmpty), [
        'Acquired',
        'Used',
        'FlatMapped',
        'ReleaseInvoked',
        'Released',
      ]);
    });

    test('brackets in sequence', () {
      final test = Counter.create().flatMap((counter) {
        return Rill.range(0, 10000)
            .flatMap((_) {
              return Rill.bracket(
                counter.increment,
                (_) => counter.decrement,
              ).flatMap((_) => Rill.emit(1));
            })
            .compile
            .drain
            .flatMap((_) => counter.count);
      });

      expect(test, succeeds(0));
    });

    group('finalizer are run in LIFO order', () {
      test('explicit release', () {
        final test = IO.ref(nil<int>()).flatMap((track) {
          return IList.range(0, 10)
              .foldLeft(
                Rill.emit(0),
                (acc, i) => Rill.bracket(
                  IO.pure(i),
                  (i) => track.update((l) => l.appended(i)),
                ).flatMap((_) => acc),
              )
              .compile
              .drain
              .flatMap((_) => track.value());
        });

        expect(test, succeeds(ilist([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])));
      });

      test('scope closure', () {
        final test = IO.ref(nil<int>()).flatMap((track) {
          return IList.range(0, 10)
              .foldLeft(
                Rill.emit(1).map((_) => throw 'BOOM'),
                (acc, i) => Rill.bracket(
                  IO.pure(i),
                  (i) => track.update((l) => l.appended(i)),
                ).flatMap((_) => acc),
              )
              .attempt()
              .compile
              .drain
              .flatMap((_) => track.value());
        });

        expect(test, succeeds(ilist([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])));
      });
    });

    test('propogate error from closing the root scope', () {
      final s1 = Rill.bracket(IO.pure(1), (_) => IO.unit);
      final s2 = Rill.bracket(IO.pure('a'), (_) => IO.raiseError('BOOM'));

      expect(s1.zip(s2).compile.drain, errors('BOOM'));
      expect(s2.zip(s1).compile.drain, errors('BOOM'));
    });
  });

  test('append', () {
    final rillA = Rill.emits([1, 2]);
    final rillB = Rill.emits([3, 4]);

    expect(rillA.append(() => rillB), producesInOrder([1, 2, 3, 4]));
  });

  group('broadcastThrough', () {
    test('each pipe receives all source elements', () {
      final source = Rill.emits([1, 2, 3]);

      // Two pipes: one doubles, one triples each element.
      // broadcastThrough fans out so both pipes see [1, 2, 3].
      final pipes = ilist<Pipe<int, int>>([
        (r) => r.map((i) => i * 2),
        (r) => r.map((i) => i * 3),
      ]);

      expect(source.broadcastThrough(pipes), producesUnordered([2, 4, 6, 3, 6, 9]));
    });
  });

  group('buffer', () {
    (rillOf(Gen.integer), Gen.positiveInt).forAll('identity', (r, n) {
      expect(r.buffer(n), producesSameAs(r));
    });
  });

  test('changes', () {
    expect(Rill.empty<int>().changes(), producesNothing());
    expect(Rill.emits([1, 2, 3, 4]).changes(), producesInOrder([1, 2, 3, 4]));
    expect(Rill.emits([1, 2, 2, 1, 1, 1, 3]).changes(), producesInOrder([1, 2, 1, 3]));
    expect(
      Rill.emits(['1', '2', '33', '44', '5', '66']).changesBy((s) => s.length),
      producesInOrder(['1', '33', '5', '66']),
    );
  });

  test('chunk', () {
    final rill = Rill.emits([1, 2]);
    expect(rill, producesInOrder([1, 2]));
  });

  test('chunkLimit', () {
    final rill = Rill.emits([1, 2, 3, 4, 5]).chunkLimit(2);

    expect(
      rill,
      producesInOrder([
        chunk([1, 2]),
        chunk([3, 4]),
        chunk([5]),
      ]),
    );
  });

  test('chunkMin', () {
    final rill = Rill.emit(
      0,
    ).append(() => Rill.emit(1)).append(() => Rill.emit(2)).append(() => Rill.emit(3));

    expect(
      rill.chunkMin(3),
      producesInOrder([
        chunk([0, 1, 2]),
        chunk([3]),
      ]),
    );

    expect(
      rill.chunkMin(3, allowFewerTotal: false),
      producesOnly(chunk([0, 1, 2])),
    );
  });

  intRill.forAll('collect consistent with IList.collect', (r) async {
    Option<int> f(int n) => Option.when(() => n.isEven, () => n);

    final result = await r.toList;
    expect(r.collect(f), producesInOrder(result.collect(f)));
  });

  test('collect', () {
    final rillTwo = Rill.range(0, 10).collect((n) => Option.when(() => n == 2, () => n));
    final rillOdd = Rill.range(0, 10).collect((n) => Option.when(() => n.isOdd, () => n));
    final rillBig = Rill.range(0, 10).collect((n) => Option.when(() => n > 100, () => n));

    expect(rillTwo, producesOnly(2));
    expect(rillOdd, producesInOrder([1, 3, 5, 7, 9]));
    expect(rillBig, producesNothing());
  });

  rillOf(Gen.integer).forAll('collectFirst consistent with IList.collect', (r) async {
    Option<int> f(int n) => Option.when(() => n.isEven, () => n);

    final result = await r.toList;
    expect(r.collectFirst(f), producesInOrder(result.collectFirst(f)));
  });

  test('collectFirst', () {
    final rillFirstTwo = Rill.range(0, 10).collectFirst((n) => Option.when(() => n == 2, () => n));
    final rillFirstOdd = Rill.range(0, 10).collectFirst((n) => Option.when(() => n.isOdd, () => n));
    final rillFirstBig = Rill.range(0, 10).collectFirst((n) => Option.when(() => n > 100, () => n));

    expect(rillFirstTwo, producesOnly(2));
    expect(rillFirstOdd, producesOnly(1));
    expect(rillFirstBig, producesNothing());
  });

  (intRill, intRill).forAll('collectWhile', (s1, s2) {
    Option<int> f(int n) => Option.when(() => n.isEven, () => n);

    final even = s1.filter((n) => n.isEven);
    final odd = s2.filter((n) => n.isOdd);

    expect(even.append(() => odd).collectWhile(f), producesSameAs(even));
  });

  test('concurrently', () async {
    final buffer = StringBuffer();

    final rillA = Rill.range(0, 5)
        .evalMap((n) => IO.pure(n).delayBy(100.milliseconds))
        .onFinalize(IO.exec(() => buffer.write('!')));

    final rillB = Rill.emits([
      'a',
      'b',
      'c',
    ]).repeat().evalTap((c) => IO.exec(() => buffer.write(c)).delayBy(250.milliseconds));

    final test = rillA.concurrently(rillB).compile.toIList;

    await expectLater(test.ticked, succeeds(ilist([0, 1, 2, 3, 4])));
    expect(buffer.toString(), 'ab!');
  });

  test('dampening', () async {
    const count = 10;
    final period = 100.milliseconds;

    await Rill.awakeEvery(period)
        .take(count)
        .mapAccumulate(0, (acc, o) => (acc + 1, o))
        .evalMapN((i, o) => IO.sleep(i == 2 ? period * 5 : 0.seconds).as(o))
        .compile
        .toIList
        .map((l) {
          final elapsed = l.last - l.head;
          expect(elapsed > period * count, isTrue);
        })
        .unsafeRunFuture();
  });

  test('debounce', () {
    final delay = 200.milliseconds;

    final rill = Rill.emits([1, 2, 3])
        .andWait(delay * 2)
        .append(() => Rill.empty())
        .append(() => Rill.emits([4, 5]))
        .andWait(delay * 0.5)
        .append(() => Rill.emit(6));

    expect(rill.debounce(delay), producesInOrder([3, 6]));
  });

  test('delayBy', () async {
    final rill = Rill.range(0, 3).delayBy(1.second);

    final sw = Stopwatch()..start();
    await expectLater(rill, producesInOrder([0, 1, 2]));
    final elapsed = sw.elapsed;

    expect((elapsed.inMilliseconds - 1000).abs() < 100, isTrue);
  });

  (intRill, Gen.nonNegativeInt).forAll('delete', (r, idx0) async {
    final v = await r.toList;
    final i = v.isEmpty ? 0 : v[(idx0 % v.size).abs()];
    expect(
      r.delete((n) => n == i),
      producesInOrder(v.diff(ilist([i]))),
    );
  });

  (intRill, Gen.nonNegativeInt, Gen.boolean).forAll(
    'drop',
    (r, n0, negate) async {
      final v = await r.toList;
      final n1 = v.isEmpty ? 0 : (n0 % v.size).abs();
      final n = negate ? -n1 : n1;

      expect(r.drop(n), producesInOrder(v.drop(n)));
    },
  );

  intRill.forAll('dropLast', (r) async {
    final v = await r.toList;
    expect(r.dropLast, producesInOrder(v.dropRight(1)));
  });

  intRill.forAll('dropLastIf', (r) async {
    final v = await r.toList;

    expect(r.dropLastIf((_) => false), producesInOrder(v));
    expect(r.dropLastIf((_) => true), producesInOrder(v.dropRight(1)));
  });

  (intRill, Gen.nonNegativeInt, Gen.boolean).forAll(
    'dropRight',
    (r, n0, negate) async {
      final v = await r.toList;
      final n1 = v.isEmpty ? 0 : (n0 % v.size).abs();
      final n = negate ? -n1 : n1;

      expect(r.dropRight(n), producesInOrder(v.dropRight(n)));
    },
  );

  (intRill, Gen.positiveInt).forAll('dropWhile', (r, n0) async {
    final n = (n0 % 20).abs();

    final v = await r.toList;
    final set = v.take(n).toISet();

    expect(
      r.dropWhile(set.contains),
      producesInOrder(v.dropWhile(set.contains)),
    );
  });

  (intRill, Gen.positiveInt).forAll('dropThrough', (r, n0) async {
    final n = (n0 % 20).abs();
    final v = await r.toList;

    final set = v.take(n).toISet();
    final vec = v.dropWhile(set.contains);

    final expected = vec.isEmpty ? vec : vec.tail;

    expect(r.dropThrough(set.contains), producesInOrder(expected));
  });

  test('duration', () async {
    final delay = 200.milliseconds;

    final r = await Rill.unit.append(() => Rill.sleep(delay)).zipRight(Rill.duration()).tail.toList;

    expect(r.size, 1);
    expect((r.head.inMilliseconds - delay.inMilliseconds).abs() < 100, isTrue);
  });

  (intRill, intRill).forAll('either', (s1, s2) async {
    final s1List = await s1.toList;
    final s2List = await s2.toList;

    final result = await s1.either(s2).toList;

    expect(result.collect((e) => e.swap().toOption()), s1List);
    expect(result.collect((e) => e.toOption()), s2List);
  });

  test('emit', () {
    expect(Rill.emit(0), producesOnly(0));
  });

  intRill.forAll('evalFilter - const true', (r) {
    expect(r.evalFilter((_) => IO.pure(true)), producesSameAs(r));
  });

  intRill.forAll('evalFilter - const false', (r) {
    expect(r.evalFilter((_) => IO.pure(false)), producesNothing());
  });

  test('evalFilter', () {
    expect(
      Rill.range(0, 10).evalFilter((n) => IO.pure(n.isEven)),
      producesInOrder([0, 2, 4, 6, 8]),
    );
  });

  intRill.forAll('evalFilterNot - const true', (r) {
    expect(r.evalFilterNot((_) => IO.pure(true)), producesNothing());
  });

  intRill.forAll('evalFilterNot - const false', (r) {
    expect(r.evalFilterNot((_) => IO.pure(false)), producesSameAs(r));
  });

  test('evalFilterNot', () {
    expect(
      Rill.range(0, 10).evalFilterNot((n) => IO.pure(n.isEven)),
      producesInOrder([1, 3, 5, 7, 9]),
    );
  });

  (intRill, Gen.integer).forAll('evalFold', (r, n) {
    int f(int x, int y) => x + y;
    expect(
      r.evalFold(n, (a, b) => IO.pure(f(a, b))),
      producesSameAs(r.fold(n, f)),
    );
  });

  intRill.forAll('evalMapFilter - identity', (r) {
    expect(r.evalMapFilter((n) => IO.some(n)), producesSameAs(r));
  });

  intRill.forAll('evalMapFilter - none', (r) {
    expect(r.evalMapFilter((n) => IO.none()), producesNothing());
  });

  test('evalMapFilter - evens', () {
    final r = Rill.range(0, 10).evalMapFilter((n) => IO.pure(Some(n).filter((n) => n.isEven)));
    expect(r, producesInOrder([0, 2, 4, 6, 8]));
  });

  (intRill, Gen.stringOf(Gen.asciiChar, 100)).forAll('evalScan', (s, n) async {
    IO<String> f(String a, int b) => IO.pure('$a$b');
    String g(String a, int b) => '$a$b';

    final expected = (await s.toList).scanLeft(n, g);

    expect(s.evalScan(n, f), producesInOrder(expected));
  });

  (intRill, Gen.integer).forAll('exists', (s, n0) async {
    final n = (n0 % 20).abs() + 1;
    bool f(int i) => i % n == 0;

    final expected = (await s.toList).exists(f);

    expect(s.exists(f), producesInOrder([expected]));
  });

  test('flatMap', () {
    final rill = Rill.emits([1, 2, 3]).flatMap((x) => Rill.emits([x - 1, x, x + 1]));
    expect(rill, producesInOrder([0, 1, 2, 1, 2, 3, 2, 3, 4]));
  });

  test('flatMap (2)', () {
    final rill = Rill.emits([1, 2, 3]).flatMap((x) => Rill.chunk(Chunk.fill(x, '$x')));
    expect(rill, producesInOrder(['1', '2', '2', '3', '3', '3']));
  });

  test('flatMap - huge chunk', () async {
    final rill = Rill.chunk(
      Chunk.fromList(List.generate(50000, (i) => i)),
    ).flatMap((i) => Rill.emit(i));

    final count = await rill.compile.count.unsafeRunFuture();
    expect(count, 50000);
  });

  intRill.forAll('fold1', (r) async {
    final v = await r.toList;
    int f(int a, int b) => a + b;

    final expected = v.headOption.fold(
      () => nil<int>(),
      (h) => ilist<int>([v.drop(1).foldLeft(h, f)]),
    );

    expect(r.fold1(f), producesInOrder(expected));
  });

  test('forall', () {
    final s = Rill.chunk(Chunk.from(IList.range(0, 5)));

    expect(s.forall((n) => n.isEven), producesOnly(false));
    expect(s.forall((n) => n < 4), producesOnly(false));
    expect(s.forall((n) => n < 5), producesOnly(true));
  });

  Gen.either(Gen.constant('BOOM'), Gen.integer).forAll('fromEither', (either) {
    final r = Rill.fromEither(either);

    either.fold(
      (err) => expect(r, producesError()),
      (i) => expect(r, producesOnly(i)),
    );
  });

  Gen.option(Gen.integer).forAll('fromOption', (option) {
    final r = Rill.fromOption(option);

    option.fold(
      () => expect(r, producesNothing()),
      (i) => expect(r, producesOnly(i)),
    );
  });

  group('fromQueue', () {
    test('noneTerminated', () {
      final test = Queue.unbounded<Option<int>>().flatMap((q1) {
        final s1 = Rill.fromQueueNoneUnterminated(q1);

        return ilist([
              chunk([1, 2]),
              Chunk.empty<int>(),
              chunk([3, 4, 5]),
            ])
            .traverseIO((chunk) => q1.tryOfferN(chunk.toIList().map((n) => n.some)))
            .flatMap((_) => q1.offer(none()))
            .flatMap((_) => s1.compile.toIList);
      });

      expect(test, succeeds(ilist([1, 2, 3, 4, 5])));
    });
  });

  (intRill, Gen.integer).forAll('groupAdjacentBy', (s, n0) async {
    final n = (n0 % 20).abs() + 1;
    int f(int i) => i % n;

    final s1 = s.groupAdjacentBy(f);
    final s2 = s.map(f).changes();

    final res1A = (await s1.mapN((_, chunk) => chunk).toList).flatMap((ch) => ch.toIList());
    final res1B = await s.toList;

    expect(res1A, res1B);

    expect(s1.mapN((key, _) => key), producesSameAs(s2));

    expect(
      s1.mapN((key, chunk) => chunk.forall((i) => f(i) == key)),
      producesSameAs(s2.as(true)),
    );
  });

  (intRill, Gen.integer).forAll('groupAdjacentByLimit', (s, n0) async {
    final n = (n0 % 20).abs() + 1;
    final s1 = s.groupAdjacentByLimit(n, (_) => true);

    final res1 = (await s1.mapN((_, chunk) => chunk).toList).toIList().map(
      (chunk) => chunk.toIList(),
    );
    final res2 = (await s.toList).grouped(n).toIList();

    expect(res1, res2);
  });

  group('groupWithin', () {
    final groupTimeout = Gen.chooseInt(0, 2000).map((n) => Duration(milliseconds: n));
    IO<Unit> sleep(int d) => IO.sleep(Duration(microseconds: (d % 500).abs()));

    (intRill, groupTimeout, Gen.positiveInt).forAll(
      'should never lose any elements',
      (s, timeout, groupSize) {
        expect(
          s.evalTap(sleep).groupWithin(groupSize, timeout).flatMap(Rill.chunk),
          producesSameAs(s),
        );
      },
    );

    (intRill, groupTimeout, Gen.positiveInt).forAll(
      'should never emit empty groups',
      (s, timeout, groupSize) async {
        final l = await s.evalTap(sleep).groupWithin(groupSize, timeout).toList;
        expect(l.forall((chunk) => chunk.nonEmpty), isTrue);
      },
    );

    (intRill, groupTimeout, Gen.positiveInt).forAll(
      'should never have chunks larger than limit',
      (s, timeout, groupSize) async {
        final l = await s.evalTap(sleep).groupWithin(groupSize, timeout).toList;
        expect(l.forall((chunk) => chunk.size <= groupSize), isTrue);
      },
    );

    test('should be equivalent to chunkN when no timeouts occur', () {
      final r = Rill.range(0, 100);
      const size = 5;

      expect(r.groupWithin(size, 1.second), producesSameAs(r.chunkN(size)));
    });

    Gen.listOf(Gen.chooseInt(1, 1000), Gen.integer).forAll(
      'giant group size emits single chunk',
      (list) {
        expect(
          Rill.emits(list).groupWithin(list.length, 1.day),
          producesOnly(chunk(list)),
        );
      },
    );

    test('accumulation and splitting', () {
      final t = 200.milliseconds;
      const size = 5;

      Rill<int> mkChunk(int from, int size) => Rill.range(from, from + size).chunkAll().unchunks;

      final source = mkChunk(
        1,
        3,
      ).andWait(t * 2).append(() => mkChunk(4, 12)).append(() => mkChunk(16, 7));

      final expected = ilist([
        ilist([1, 2, 3]),
        ilist([4, 5, 6, 7, 8]),
        ilist([9, 10, 11, 12, 13]),
        ilist([14, 15, 16, 17, 18]),
        ilist([19, 20, 21, 22]),
      ]);

      expect(source.groupWithin(size, t).map((c) => c.toIList()), producesInOrder(expected));
    });
  });

  test('handleErrorWith', () {
    final rillA = Rill.emits([1, 2]);
    final rillB = Rill.raiseError<int>('BOOM');
    final rillC = Rill.emit(4);

    final rill = rillA.append(() => rillB).append(() => rillC);

    expect(rill.handleErrorWith((_) => Rill.emit(42)), producesInOrder([1, 2, 42]));
  });

  test('holdResource', () {
    final sourceStream = Rill.awakeEvery(1.second).zipWithIndex().mapN((_, idx) => idx + 1);

    final program = Ref.of(nil<int>()).flatMap((st) {
      IO<Unit> record(int value) => st.update((st) => st.appended(value));

      return sourceStream
          .holdResource(0)
          .use((signal) {
            return signal.value().flatMap((val0) {
              return record(val0).flatMap((_) {
                return IO.sleep(2500.milliseconds).flatMap((_) {
                  return signal.value().flatMap((val2) {
                    return record(val2).flatMap((_) {
                      return IO.sleep(2.seconds).flatMap((_) {
                        return signal.value().flatMap((val4) {
                          return record(val4);
                        });
                      });
                    });
                  });
                });
              });
            });
          })
          .flatMap((_) => st.value());
    });

    expect(program.ticked, succeeds(ilist([0, 2, 4])));
  });

  group('ifEmpty', () {
    test('when empty', () {
      expect(Rill.empty<int>().ifEmptyEmit(() => 0), producesOnly(0));
    });

    test('when empty', () {
      expect(Rill.emit(1).ifEmptyEmit(() => 0), producesOnly(1));
    });
  });

  group('interleave', () {
    test('interleave left/right side infinite', () {
      final ones = Rill.constant('1');
      final r = Rill.emits(['A', 'B', 'C']);

      expect(ones.interleave(r), producesInOrder(['1', 'A', '1', 'B', '1', 'C']));
      expect(r.interleave(ones), producesInOrder(['A', '1', 'B', '1', 'C', '1']));
    });

    test('interleave both sides infinite', () {
      final ones = Rill.constant('1');
      final r = Rill.constant('A');

      expect(ones.interleave(r).take(3), producesInOrder(['1', 'A', '1']));
      expect(r.interleave(ones).take(3), producesInOrder(['A', '1', 'A']));
    });

    test('interleaveAll left/right side infinite', () {
      final ones = Rill.constant('1');
      final r = Rill.emits(['A', 'B', 'C']);

      expect(
        ones.interleaveAll(r).take(9),
        producesInOrder(['1', 'A', '1', 'B', '1', 'C', '1', '1', '1']),
      );

      expect(
        r.interleaveAll(ones).take(9),
        producesInOrder(['A', '1', 'B', '1', 'C', '1', '1', '1', '1']),
      );
    });

    test('interleaveAll both sides infinite', () {
      final ones = Rill.constant('1');
      final r = Rill.constant('A');

      expect(ones.interleaveAll(r).take(3), producesInOrder(['1', 'A', '1']));
      expect(r.interleaveAll(ones).take(3), producesInOrder(['A', '1', 'A']));
    });
  });

  test('interruptWhen', () {
    IO<bool> signalAfter(Duration duration) => IO.pure(true).delayBy(duration);

    final source = Rill.range(
      0,
      5,
    ).evalMap((n) => IO.pure(n).delayBy(50.milliseconds));

    expect(
      source.interruptWhen(signalAfter(150.milliseconds)),
      producesInOrder([0, 1]),
    );

    expect(
      source.interruptWhen(signalAfter(500.milliseconds)),
      producesInOrder([0, 1, 2, 3, 4]),
    );
  });

  test('interruptWhenTrue', () {
    final signal = Rill.eval(
      IO.pure(false).delayBy(100.milliseconds),
    ).repeatN(5).append(() => Rill.emit(true));

    final ticks = Rill.emit('tick').delayBy(150.milliseconds).repeat();

    expect(
      ticks.interruptWhenTrue(signal),
      producesInOrder(['tick', 'tick', 'tick']),
    );
  });

  (intRill, Gen.integer).forAll('intersperse', (r, n) async {
    final l = await r.toList;
    final expected = l.flatMap((i) => ilist([i, n])).dropRight(1);

    expect(r.intersperse(n), producesInOrder(expected));
  });

  test('iterate', () {
    const n = 50000;
    final r = Rill.iterate(0, (o) => o + 1).take(n);

    expect(r, producesInOrder(List.generate(n, (i) => i)));
  });

  test('iterateEval', () {
    const n = 100;
    final r = Rill.iterateEval(0, (o) => IO.pure(o + 1)).take(n);

    expect(r, producesInOrder(List.generate(n, (i) => i)));
  });

  test('keepAlive', () {
    final irregularRill = Rill.emits([1, 2])
        .andWait(250.milliseconds)
        .append(() => Rill.emits([3, 4]))
        .andWait(500.milliseconds)
        .append(() => Rill.emit(5))
        .andWait(50.milliseconds)
        .append(() => Rill.emit(6));

    expect(
      irregularRill.keepAlive(200.milliseconds, IO.pure(0)),
      producesInOrder([1, 2, 0, 3, 4, 0, 0, 5, 6]),
    );
  });

  intRill.forAll('last', (r) async {
    final l = await r.toList;
    expect(r.last, producesInOrder([l.lastOption]));
  });

  (intRill, Gen.integer).forAll('lastOr', (r, n0) async {
    final n = (n0 % 20).abs() + 1;
    final l = await r.toList;

    expect(r.lastOr(() => n), producesOnly(l.lastOption.getOrElse(() => n)));
  });

  test('map', () {
    final rill = Rill.emits([1, 2, 3, 4, 5]).map((x) => x * 2);
    expect(rill, producesInOrder([2, 4, 6, 8, 10]));
  });

  (intRill, Gen.integer, Gen.integer).forAll('mapAccumulate', (s, m, n0) async {
    final n = (n0 % 20).abs() + 1;
    bool f(int i) => (i % n).isEven;

    final r = s.mapAccumulate(m, (s, i) => (s + i, f(i)));
    final l = await s.toList;

    expect(r.mapN((s, _) => s), producesInOrder(l.scanLeft(m, (a, b) => a + b).tail));
    expect(r.mapN((_, v) => v), producesInOrder(l.map(f)));
  });

  group('mapAsync', () {
    intRill.forAll('same as map', (s) async {
      int f(int n) => n + 1;
      final r = s.mapAsync(16, (n) => IO.pure(f(n)));
      final sList = await s.toList;

      expect(r, producesInOrder(sList.map(f)));
    });

    intRill.forAll('exception', (s) async {
      IO<int> f(int n) => IO.raiseError('BOOM');
      final r = s.append(() => Rill.emit(1)).mapAsync(1, (n) => f(n)).attempt();

      final result = await r.toList;

      expect(result.size, 1);
      expect(result[0].isLeft, isTrue);
    });
  });

  test('mapAsyncUnordered', () {
    expect(
      Rill.emits([1, 5, 2, 0, 7, 3]).parEvalMap(2, (n) => IO.sleep((n * 100).milliseconds).as(n)),
      producesInOrder([1, 5, 2, 0, 7, 3]),
    );

    expect(
      Rill.emits([
        1,
        5,
        2,
        0,
        7,
        3,
      ]).parEvalMapUnordered(1, (n) => IO.sleep((n * 100).milliseconds).as(n)),
      producesInOrder([1, 5, 2, 0, 7, 3]),
    );

    expect(
      Rill.emits([
        1,
        5,
        2,
        0,
        7,
        3,
      ]).parEvalMapUnordered(10, (n) => IO.sleep((n * 100).milliseconds).as(n)),
      producesInOrder([0, 1, 2, 3, 5, 7]),
    );
  });

  intRill.forAll('mapAsyncUnordered', (s) async {
    int f(int n) => n + 1;
    final r = s.mapAsync(16, (n) => IO.pure(f(n)));
    final sList = await s.toList;

    expect(r, producesUnordered(sList.map(f)));
  });

  group('merge', () {
    test('delayed', () {
      final rillA = Rill.range(0, 5, chunkSize: 1).evalTap((_) => IO.sleep(75.milliseconds));
      final rillB = Rill.range(5, 10, chunkSize: 1).evalTap((_) => IO.sleep(200.milliseconds));

      final test = rillA.merge(rillB).compile.toIList;

      expect(test.ticked, succeeds(ilist([0, 1, 5, 2, 3, 4, 6, 7, 8, 9])));
    });

    test('merge - error propogation (right)', () async {
      final failure = Rill.pure(42).delayBy(200.milliseconds).append(() => Rill.raiseError('BOOM'));
      final infinite = Rill.repeatEval(IO.pure(0).delayBy(50.milliseconds));

      final rightFailure = await failure.merge(infinite).compile.drain.unsafeRunFutureOutcome();

      rightFailure.fold(
        () => fail('merge should end in error'),
        (err, _) => expect(err, 'BOOM'),
        (_) => fail('merge should end in error'),
      );
    });

    test('merge - error propogation (left)', () async {
      final failure = Rill.pure(42).delayBy(200.milliseconds).append(() => Rill.raiseError('BOOM'));
      final infinite = Rill.repeatEval(IO.pure(0).delayBy(50.milliseconds));

      final leftFailure = await infinite.merge(failure).compile.drain.unsafeRunFutureOutcome();

      leftFailure.fold(
        () => fail('merge should end in error'),
        (err, _) => expect(err, 'BOOM'),
        (_) => fail('merge should end in error'),
      );
    });

    test('merge - hangs', () {
      final full = Rill.constant(42).evalTap((_) => IO.cede);

      final hang = Rill.repeatEval(IO.never<int>());
      final hang2 = full.drain();

      expect(full.merge(hang).take(1), producesOnly(42));
      expect(full.merge(hang2).take(1), producesOnly(42));
      expect(hang.merge(full).take(1), producesOnly(42));
    });
  });

  test('mergeHaltBoth', () {
    final rillA = Rill.range(0, 5).evalMap((n) => IO.pure(n).delayBy(100.milliseconds));
    final rillB = Rill.range(5, 10).evalMap((n) => IO.pure(n).delayBy(400.milliseconds));

    expect(
      rillA.mergeHaltBoth(rillB).take(10),
      producesInOrder([0, 1, 2, 5, 3, 4]),
    );
  });

  (intRill, intRill).forAll('mergeHaltL emits all from left stream in order', (left, right) {
    final leftTagged = left.map((n) => n.asLeft<int>());
    final rightTagged = right.map((n) => n.asRight<int>());

    final rill = leftTagged.mergeHaltL(rightTagged).collect((either) => either.swap().toOption());

    expect(rill, producesSameAs(left));
  });

  (intRill, intRill).forAll('mergeHaltR emits all from right stream in order', (left, right) {
    final leftTagged = left.map((n) => n.asLeft<int>());
    final rightTagged = right.map((n) => n.asRight<int>());

    final rill = leftTagged.mergeHaltR(rightTagged).collect((either) => either.toOption());

    expect(rill, producesSameAs(right));
  });

  test('metered should not start immediately', () {
    expect(
      Rill.emit(1).repeatN(10).metered(1.second).interruptAfter(500.milliseconds),
      producesNothing(),
    );
  });

  test('meteredStartImmediately should start immediately', () {
    expect(
      Rill.emit(1).repeatN(10).meteredStartImmediately(1.second).interruptAfter(500.milliseconds),
      producesOnly(1),
    );
  });

  test('metered should not wait between events that last longer than the rate', () {
    expect(
      Rill.eval(
        IO.sleep(200.milliseconds).as(1),
      ).repeatN(10).metered(200.milliseconds).interruptAfter(1.second),
      producesInOrder([1, 1, 1]),
    );
  });

  test('meteredStartImmediately should not wait between events that last longer than the rate', () {
    expect(
      Rill.eval(
        IO.sleep(200.milliseconds).as(1),
      ).repeatN(10).meteredStartImmediately(200.milliseconds).interruptAfter(1.second),
      producesInOrder([1, 1, 1, 1]),
    );
  });

  test('onFinalize', () {
    final expected = ilist([
      "rill - start",
      "rill - done",
      "io - done",
      "io - start",
    ]);

    final test = Ref.of(nil<String>()).flatMap((st) {
      IO<Unit> record(String s) => st.update((st) => st.appended(s));

      final rill =
          Rill.emit(
            'rill - start',
          ).onFinalize(record('rill - done')).evalMap((x) => record(x)).compile.lastOrError;

      final io = Rill.emit(
        'io - start',
      ).onFinalize(record('io - done')).compile.lastOrError.flatMap((x) => record(x));

      return rill.flatMap((_) => io).flatMap((_) => st.value());
    });

    expect(test, succeeds(expected));
  });

  test('onlyOrError', () {
    final a = Rill.empty<int>();
    final b = Rill.emit(1);
    final c = Rill.emits([1, 2]);

    expect(a.compile.onlyOrError, errors());
    expect(b.compile.onlyOrError, succeeds(1));
    expect(c.compile.onlyOrError, errors());
  });

  test('parJoin', () {
    final rill = Rill.emits([
      Rill.range(0, 5).evalMap((n) => IO.pure(n).delayBy((n * 100).milliseconds)),
      Rill.range(5, 10).evalMap((n) => IO.pure(n).delayBy((n * 10).milliseconds)),
      Rill.range(10, 15).evalMap((n) => IO.pure(n).delayBy((n * 1).milliseconds)),
    ]);

    expect(rill.parJoin(3), producesUnordered(List.generate(15, (i) => i)));
  });

  test('parJoin resource lifecycle', () {
    final test = IO.ref(nil<String>()).flatMap((log) {
      IO<Unit> record(String s) => log.update((l) => l.appended(s));

      final inner1 = Rill.range(0, 2).onFinalize(record('inner1-done'));
      final inner2 = Rill.range(2, 4).onFinalize(record('inner2-done'));

      final outer = Rill.bracket(
        record('outer-acquired'),
        (_) => record('outer-released'),
      ).flatMap((_) => Rill.emits([inner1, inner2]));

      return outer.parJoin(2).compile.drain.flatMap((_) => log.value());
    });

    expect(
      test.map((log) => log.last),
      succeeds('outer-released'),
    );
  });

  test('pauseWhen', () {
    final signal = Rill.emit(false)
        .andWait(250.milliseconds)
        .append(() => Rill.emit(true).andWait(250.milliseconds))
        .append(() => Rill.emit(false).andWait(250.milliseconds));

    final s = Rill.repeatEval(IO.sleep(150.milliseconds).as(1)).interruptAfter(1500.milliseconds);

    expect(s.pauseWhen(signal), producesInOrder([1, 1, 1]));
  });

  test('range', () {
    expect(Rill.range(0, 100), producesInOrder(IList.range(0, 100)));
    expect(Rill.range(0, 1), producesInOrder(IList.range(0, 1)));
    expect(Rill.range(0, 0), producesInOrder(IList.range(0, 0)));
    expect(Rill.range(0, 101, step: 2), producesInOrder(IList.range(0, 101, 2)));
    expect(Rill.range(5, 0, step: -1), producesInOrder(IList.range(5, 0, -1)));
    expect(Rill.range(5, 0), producesNothing());
    expect(Rill.range(10, 50, step: 0), producesNothing());
  });

  test('rechunkRandomly does not drop elements', () {
    expect(Rill.range(0, 100).rechunkRandomly(), producesInOrder(List.generate(100, (i) => i)));
  });

  (intRill, Gen.chooseInt(0, 1000000000)).forAll(
    'rechunkRandomly is deterministic',
    (r, seed) {
      expect(
        r.rechunkRandomly(seed: seed),
        producesSameAs(r.rechunkRandomly(seed: seed)),
      );
    },
  );

  test('repeat', () {
    final rill = Rill.range(0, 3).repeat();

    expect(rill.take(5), producesInOrder([0, 1, 2, 0, 1]));
    expect(rill.drop(1).take(8), producesInOrder([1, 2, 0, 1, 2, 0, 1, 2]));
  });

  test('repeatN', () {
    final rill = Rill.range(0, 3).repeatN(3);

    expect(rill.take(5), producesInOrder([0, 1, 2, 0, 1]));
    expect(rill.drop(1).take(100), producesInOrder([1, 2, 0, 1, 2, 0, 1, 2]));
  });

  test('repeatEval', () {
    final rill = Rill.repeatEval(IO.pure(42)).take(5);
    expect(rill, producesInOrder([42, 42, 42, 42, 42]));
  });

  group('resource', () {
    test('basic', () {
      final test = Ref.of(nil<String>()).flatMap((st) {
        IO<Unit> record(String s) => st.update((l) => l.appended(s));
        Resource<Unit> mkRes(String s) =>
            Resource.make(record('acquire $s'), (_) => record('release $s'));

        // We aim to trigger all the possible cases, and make sure all of them
        // introduce scopes.

        // Allocate
        final res1 = mkRes("1");
        // Bind
        final res2 = mkRes("21").flatMap((_) => mkRes('22'));
        // Suspend
        final res3 = Resource.suspend(record("suspend").as(mkRes("3")));

        return ilist([
              res1,
              res2,
              res3,
            ])
            .foldLeft(Rill.empty<Unit>(), (acc, res) => acc.append(() => Rill.resource(res)))
            .evalTap((_) => record('use'))
            .append(() => Rill.exec(record('done')))
            .compile
            .drain
            .flatMap((_) => st.value());
      });

      final expected = ilist([
        'acquire 1',
        'use',
        'release 1',
        'acquire 21',
        'acquire 22',
        'use',
        'release 22',
        'release 21',
        'suspend',
        'acquire 3',
        'use',
        'release 3',
        'done',
      ]);

      expect(test, succeeds(expected));
    });

    test('append', () {
      final res1 = Resource.make(IO.pure('start'), (_) => IO.unit);
      final rill = Rill.resource(res1).append(() => Rill.emit('done'));

      expect(rill, producesInOrder(['start', 'done']));
    });
  });

  group('retry', () {
    test('immediate success', () {
      final program = Counter.create().flatMap((attempts) {
        final job = attempts.increment.as('success');

        return Rill.retry(
          job,
          100.milliseconds,
          (x) => x,
          100,
        ).compile.lastOrError.productR(attempts.count);
      });

      expect(program, succeeds(1));
    });

    test('eventual success', () {
      final program = (Counter.create(), Counter.create()).tupled.flatMapN((failures, successes) {
        final job = failures.count.flatMap((n) {
          return n == 5
              ? successes.increment.as('success')
              : failures.increment.productR(IO.raiseError<String>('retry error'));
        });

        return Rill.retry(
          job,
          100.milliseconds,
          (x) => x,
          100,
        ).compile.lastOrError.flatMap((_) => (failures.count, successes.count).tupled);
      });

      expect(program, succeeds((5, 1)));
    });

    test('max retries', () {
      final program = Counter.create().flatMap((failures) {
        final job = failures.increment
            .productR(failures.count)
            .flatMap((v) => IO.raiseError<Unit>(v));

        return Rill.retry(
          job,
          100.milliseconds,
          (x) => x,
          5,
        ).compile.drain.flatMap((_) => IO.raiseError<Unit>('Expected retry error')).handleErrorWith(
          (err) {
            return failures.count.flatMap((c) => IO.exec(() => expect(c, 5)));
          },
        );
      });

      expect(program, succeeds());
    });
  });

  (intRill, Gen.integer).forAll('scan', (r, n) async {
    int f(int a, int b) => a + b;
    final l = await r.toList;

    expect(r.scan(n, f), producesInOrder(l.scanLeft(n, f)));
  });

  intRill.forAll('scan', (r) async {
    int f(int a, int b) => a + b;
    final l = await r.toList;
    final expected = l.headOption.fold(() => nil<int>(), (h) => l.drop(1).scanLeft(h, f));

    expect(r.scan1(f), producesInOrder(expected));
  });

  test('scan1', () {
    expect(
      Rill.range(0, 10).scan1((acc, n) => acc + n),
      producesInOrder([0, 1, 3, 6, 10, 15, 21, 28, 36, 45]),
    );
  });

  test('scanChunks', () {
    expect(
      Rill.range(0, 5, chunkSize: 1).scanChunks(100, (s, hd) => (s + s, hd.map((n) => n + s))),
      producesInOrder([100, 201, 402, 803, 1604]),
    );
  });

  (intRill, Gen.integer, Gen.integer).forAll('sliding', (r, n0, n1) async {
    final size = (n0 % 20).abs() + 1;
    final step = (n1 % 20).abs() + 1;

    final expected = (await r.toList).sliding(size, step).map(Chunk.from).toIList();
    expect(r.sliding(size, step: step), producesInOrder(expected));
  });

  test('spaced should start immediately if startImmediately is not set', () {
    expect(
      Rill.emit(1).repeatN(10).spaced(1.second).interruptAfter(500.milliseconds),
      producesOnly(1),
    );
  });

  test('spaced should not start immediately if startImmediately is set to false', () {
    expect(
      Rill.emit(
        1,
      ).repeatN(10).spaced(1.second, startImmediately: false).interruptAfter(500.milliseconds),
      producesNothing(),
    );
  });

  test('spaced should wait between events', () {
    expect(
      Rill.eval(
        IO.sleep(200.milliseconds).as(1),
      ).repeatN(10).spaced(200.milliseconds).interruptAfter(1.second),
      producesInOrder([1, 1]),
    );
  });

  test('split', () {
    expect(
      Rill.emits([0, 1, 2, 2, 2, 3, 5, 6, 6, 8, 8, 9, 10]).split((n) => n.isOdd),
      producesInOrder([
        chunk([0]),
        chunk([2, 2, 2]),
        Chunk.empty<int>(),
        chunk([6, 6, 8, 8]),
        chunk([10]),
      ]),
    );
  });

  group('switchMap', () {
    test('basic', () {
      Rill<String> inner(int n) =>
          Rill.awakeEvery(250.milliseconds).zipWithIndex().mapN((_, idx) => '$n-$idx').take(5);

      final outer = Rill.awakeEvery(1.second).zipWithIndex().mapN((_, idx) => idx).take(5);
      final test = outer.switchMap(inner).compile.toIList;

      final expected = ilist([
        '0-0',
        '0-1',
        '0-2',
        '0-3',
        '1-0',
        '1-1',
        '1-2',
        '1-3',
        '2-0',
        '2-1',
        '2-2',
        '2-3',
        '3-0',
        '3-1',
        '3-2',
        '3-3',
        '4-0',
        '4-1',
        '4-2',
        '4-3',
        '4-4',
      ]);

      expect(test.ticked, succeeds(expected));
    });
  });

  test('take', () {
    final s = Rill.chunk(Chunk.from(IList.range(0, 5)));
    expect(s.take(2), producesInOrder([0, 1]));
  });

  test('takeRight', () {
    final rill = Rill.emits([1, 2, 3, 4, 5]);

    expect(rill.takeRight(0), producesInOrder([]));
    expect(rill.takeRight(1), producesInOrder([5]));
    expect(rill.takeRight(5), producesInOrder([1, 2, 3, 4, 5]));
    expect(rill.takeRight(10), producesInOrder([1, 2, 3, 4, 5]));
  });

  test('takeWhile', () {
    final rill = Rill.emits([1, 2, 3, 4, 5]);

    expect(rill.takeWhile((n) => n < 10), producesInOrder([1, 2, 3, 4, 5]));
    expect(rill.takeWhile((n) => n > 10), producesInOrder([]));
    expect(rill.takeWhile((n) => n < 4), producesInOrder([1, 2, 3]));
  });

  test('unfold', () {
    final test = Rill.unfold((0, 1), (state) {
      final (current, next) = state;
      return Option.when(() => current < 50000, () => (current, (next, next + 1)));
    }).takeRight(2);

    expect(test, producesInOrder([49998, 49999]));
  });

  test('zip', () {
    final rillA = Rill.range(0, 5);
    final rillB = Rill.emits(['a', 'b', 'c', 'd', 'e']);

    expect(
      rillA.zip(rillB),
      producesInOrder([(0, 'a'), (1, 'b'), (2, 'c'), (3, 'd'), (4, 'e')]),
    );

    expect(
      rillA.zip(rillB).drop(1).take(2),
      producesInOrder([(1, 'b'), (2, 'c')]),
    );

    expect(
      rillA.drop(1).zip(rillB),
      producesInOrder([(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd')]),
    );

    expect(
      rillA.zip(rillB.drop(1)),
      producesInOrder([(0, 'b'), (1, 'c'), (2, 'd'), (3, 'e')]),
    );
  });

  test('zip left/right side infinite', () {
    final ones = Rill.constant('1');
    final s = Rill.emits(['A', 'B', 'C']);

    expect(ones.zip(s), producesInOrder([('1', 'A'), ('1', 'B'), ('1', 'C')]));
    expect(s.zip(ones), producesInOrder([('A', '1'), ('B', '1'), ('C', '1')]));
  });

  test('zip both side infinite', () {
    final ones = Rill.constant('1');
    final as = Rill.constant('A');

    expect(ones.zip(as).take(3), producesInOrder([('1', 'A'), ('1', 'A'), ('1', 'A')]));
    expect(as.zip(ones).take(3), producesInOrder([('A', '1'), ('A', '1'), ('A', '1')]));
  });

  test('zipAll', () {
    final rillA = Rill.range(0, 5);
    final rillB = Rill.emits(['a', 'b', 'c', 'd', 'e']).chunkLimit(1).unchunks;

    expect(
      rillA.zipAllWith(rillB, 42, '?', (a, b) => (a, b)),
      producesInOrder([(0, 'a'), (1, 'b'), (2, 'c'), (3, 'd'), (4, 'e')]),
    );

    expect(
      rillA.take(3).zipAllWith(rillB, 42, '?', (a, b) => (a, b)),
      producesInOrder([(0, 'a'), (1, 'b'), (2, 'c'), (42, 'd'), (42, 'e')]),
    );

    expect(
      rillA.zipAllWith(rillB.take(3), 42, '?', (a, b) => (a, b)),
      producesInOrder([(0, 'a'), (1, 'b'), (2, 'c'), (3, '?'), (4, '?')]),
    );
  });

  test('zipLatest', () {
    final xs = Rill.emits([1, 2, 3, 4]);
    final as = Rill.emits(['a', 'b', 'c']);

    IO<A> pureAndCede<A>(A a) => IO.pure(a).productL(IO.cede);

    expect(xs.zipLatest(as), producesInOrder([(4, 'a'), (4, 'b'), (4, 'c')]));

    expect(
      xs.evalMap(pureAndCede).zipLatest(as.evalMap(pureAndCede)),
      producesInOrder([
        (1, 'a'),
        (2, 'a'),
        (2, 'b'),
        (3, 'b'),
        (3, 'c'),
        (4, 'c'),
      ]),
    );
  });

  test('zipWith left/right side infinite', () {
    final ones = Rill.constant('1');
    final s = Rill.emits(['A', 'B', 'C']);

    expect(ones.zipWith(s, (a, b) => a + b), producesInOrder(['1A', '1B', '1C']));
    expect(s.zipWith(ones, (a, b) => a + b), producesInOrder(['A1', 'B1', 'C1']));
  });

  test('zipWith both sides infinite', () {
    final ones = Rill.constant('1');
    final as = Rill.constant('A');

    expect(ones.zipWith(as, (a, b) => a + b).take(3), producesInOrder(['1A', '1A', '1A']));
    expect(as.zipWith(ones, (a, b) => a + b).take(3), producesInOrder(['A1', 'A1', 'A1']));
  });

  test('zipAllWith left/right side infinite', () {
    final ones = Rill.constant('1');
    final s = Rill.emits(['A', 'B', 'C']);

    expect(
      ones.zipAllWith(s, '2', 'Z', (a, b) => a + b).take(5),
      producesInOrder(['1A', '1B', '1C', '1Z', '1Z']),
    );

    expect(
      s.zipAllWith(ones, 'Z', '2', (a, b) => a + b).take(5),
      producesInOrder(['A1', 'B1', 'C1', 'Z1', 'Z1']),
    );
  });

  intRill.forAll('zipWithIndex', (r) async {
    final l = await r.toList;
    expect(r.zipWithIndex(), producesInOrder(l.zipWithIndex()));
  });

  intRill.forAll('zipWithNext', (r) async {
    final xs = await r.toList;

    expect(
      r.zipWithNext(),
      producesInOrder(xs.zipAll(xs.map((x) => Some(x)).drop(1), -1, none<int>())),
    );
  });

  test('zipWithNext - 2', () {
    expect(Rill.empty<int>().zipWithNext(), producesNothing());
    expect(Rill.emit(0).zipWithNext(), producesOnly((0, none<int>())));
    expect(
      Rill.emits([0, 1, 2]).zipWithNext(),
      producesInOrder([(0, const Some(1)), (1, const Some(2)), (2, none<int>())]),
    );
  });

  intRill.forAll('zipWithPrevious', (r) async {
    final xs = await r.toList;

    expect(
      r.zipWithPrevious(),
      producesInOrder(xs.map((n) => Option(n)).prepended(none()).zip(xs)),
    );
  });

  test('zipWithPrevious - 2', () {
    expect(Rill.empty<int>().zipWithPrevious(), producesNothing());
    expect(Rill.emit(0).zipWithPrevious(), producesOnly((none<int>(), 0)));
    expect(
      Rill.emits([0, 1, 2]).zipWithPrevious(),
      producesInOrder([(none<int>(), 0), (const Some(0), 1), (const Some(1), 2)]),
    );
  });

  intRill.forAll('zipWithPreviousAndNext', (r) async {
    final xs = await r.toList;

    final zipWithPrevious = xs.map((n) => Option(n)).prepended(none()).zip(xs);
    final zipWithPreviousAndNext = zipWithPrevious
        .zipAll(xs.map((x) => Some(x)).drop(1), (
          none<int>(),
          -1,
        ), none<int>())
        .map((t) => t.$1.appended(t.$2));

    expect(r.zipWithPreviousAndNext(), producesInOrder(zipWithPreviousAndNext));
  });

  test('zipWithPreviousAndNext - 2', () {
    expect(Rill.empty<int>().zipWithPreviousAndNext(), producesNothing());
    expect(Rill.emit(0).zipWithPreviousAndNext(), producesOnly((none<int>(), 0, none<int>())));
    expect(
      Rill.emits([0, 1, 2]).zipWithPreviousAndNext(),
      producesInOrder([
        (none<int>(), 0, const Some(1)),
        (const Some(0), 1, const Some(2)),
        (const Some(1), 2, none<int>()),
      ]),
    );
  });

  test('zipWithScan', () {
    expect(
      Rill.emits(['uno', 'dos', 'tres', 'cuatro']).zipWithScan(0, (acc, o) => acc + o.length),
      producesInOrder([('uno', 0), ('dos', 3), ('tres', 6), ('cuatro', 10)]),
    );

    expect(Rill.empty<int>().zipWithScan(0, (a, b) => a + b), producesNothing());
  });

  test('zipWithScan1', () {
    expect(
      Rill.emits(['uno', 'dos', 'tres', 'cuatro']).zipWithScan1(0, (acc, o) => acc + o.length),
      producesInOrder([('uno', 3), ('dos', 6), ('tres', 10), ('cuatro', 16)]),
    );

    expect(Rill.empty<int>().zipWithScan1(0, (a, b) => a + b), producesNothing());
  });

  test('fromStream', () {
    final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
    final rill = Rill.fromStream(stream);

    expect(rill, producesInOrder([1, 2, 3, 4, 5]));
  });

  test('fromStream - error', () {
    final stream = Stream.fromIterable([1, 2, 3, 4, 5]).map((n) => n == 4 ? throw 'boom' : n);
    final rill = Rill.fromStream(stream);

    expect(rill, producesError());
  });

  test('toStream', () {
    final rill = Rill.range(0, 5);
    final stream = rill.toDartStream();

    expect(stream, emitsInOrder([0, 1, 2, 3, 4]));
  });

  group('compile', () {
    group('resource', () {
      test('onFinalize', () {
        final test = Ref.of(nil<String>()).flatMap((st) {
          IO<Unit> record(String s) => st.update((st) => st.appended(s));

          final rill =
              Rill.emit(
                'rill - start',
              ).onFinalize(record('rill - done')).evalMap((x) => record(x)).compile.lastOrError;

          final io = Rill.emit(
            'io - start',
          ).onFinalize(record('io - done')).compile.lastOrError.flatMap(record);

          final resource = Rill.emit(
            'resource - start',
          ).onFinalize(record('resource - done')).compile.resource.lastOrError.use(record);

          return rill.productR(io).productR(resource).productR(st.value());
        });

        expect(
          test,
          succeeds(
            ilist([
              'rill - start',
              'rill - done',
              'io - done',
              'io - start',
              'resource - start',
              'resource - done',
            ]),
          ),
        );
      });
    });
  });

  group('bracketCase', () {
    test('release receives succeeded ExitCase on normal completion', () {
      final test = IO.ref<ExitCase?>(null).flatMap((ref) {
        return Rill.bracketCase(
          IO.pure(42),
          (_, ec) => ref.setValue(ec),
        ).compile.drain.productR(ref.value());
      });

      expect(
        test.map((ec) => ec!.isSuccess),
        succeeds(isTrue),
      );
    });

    test('release receives errored ExitCase on error', () {
      final test = IO.ref<ExitCase?>(null).flatMap((ref) {
        return Rill.bracketCase(IO.pure(42), (_, ec) => ref.setValue(ec))
            .flatMap((_) => Rill.raiseError<int>('BOOM'))
            .compile
            .drain
            .attempt()
            .productR(ref.value());
      });

      expect(
        test.map((ec) => ec!.isError),
        succeeds(isTrue),
      );
    });
  });

  group('bracketFull', () {
    test('acquire receives Poll and release is called', () {
      final test = IO.ref(false).flatMap((released) {
        return Rill.bracketFull(
          (_) => IO.pure(1),
          (_, _) => released.setValue(true),
        ).compile.toIList.productR(released.value());
      });

      expect(test, succeeds(isTrue));
    });
  });

  group('force', () {
    test('wraps IO<Rill> and emits elements', () {
      final r = Rill.force(IO.pure(Rill.emits<int>([1, 2, 3])));
      expect(r, producesInOrder([1, 2, 3]));
    });

    test('defers Rill construction until stream is run', () {
      var built = false;
      final r = Rill.force(
        IO.delay(() {
          built = true;
          return Rill.emit(99);
        }),
      );

      expect(built, isFalse);
      expect(r, producesOnly(99));
    });
  });

  group('suspend', () {
    test('emits elements from lazily-constructed Rill', () {
      expect(
        Rill.suspend(() => Rill.emits<int>([1, 2, 3])),
        producesInOrder([1, 2, 3]),
      );
    });

    test('defers construction until stream is run', () {
      var built = false;
      final r = Rill.suspend(() {
        built = true;
        return Rill.emit(7);
      });

      expect(built, isFalse);
      expect(r, producesOnly(7));
    });
  });

  test('never does not emit any elements within take(0)', () {
    expect(Rill.never.take(0), producesNothing());
  });

  group('fromIterator', () {
    test('wraps a Dart Iterator', () {
      final it = [1, 2, 3].iterator;
      expect(Rill.fromIterator(it), producesInOrder([1, 2, 3]));
    });

    test('empty iterator produces empty stream', () {
      final it = <int>[].iterator;
      expect(Rill.fromIterator(it), producesNothing());
    });
  });

  group('fromQueueUnterminated', () {
    test('reads elements offered to the queue', () {
      final test = Queue.bounded<int>(10).flatMap((q) {
        final producer = IList.range(0, 5).traverseIO_((i) => q.offer(i));
        final consumer = Rill.fromQueueUnterminated(q).take(5).compile.toIList;

        return IO.both(producer, consumer).mapN((_, b) => b);
      });

      expect(test, succeeds(ilist([0, 1, 2, 3, 4])));
    });
  });

  group('unfoldChunk', () {
    test('produces elements via chunk-based unfold', () {
      expect(
        Rill.unfoldChunk<int, int>(0, (s) {
          if (s >= 3) {
            return none();
          } else {
            return Some((Chunk.fromDart([s * 2, s * 2 + 1]), s + 1));
          }
        }),
        producesInOrder([0, 1, 2, 3, 4, 5]),
      );
    });

    test('empty when initial predicate returns None', () {
      expect(
        Rill.unfoldChunk<int, int>(0, (_) => none()),
        producesNothing(),
      );
    });
  });

  group('unfoldEval', () {
    test('produces elements via IO-based unfold', () {
      expect(
        Rill.unfoldEval<int, int>(0, (s) => IO.pure(s < 3 ? Some((s, s + 1)) : none())),
        producesInOrder([0, 1, 2]),
      );
    });

    test('empty when IO returns None immediately', () {
      expect(
        Rill.unfoldEval<int, int>(0, (_) => IO.pure(none())),
        producesNothing(),
      );
    });
  });

  group('unfoldChunkEval', () {
    test('produces chunks via IO-based chunk unfold', () {
      expect(
        Rill.unfoldChunkEval<int, int>(
          0,
          (s) => IO.pure(s >= 2 ? none() : Some((Chunk.fromDart([s, s + 10]), s + 1))),
        ),
        producesInOrder([0, 10, 1, 11]),
      );
    });
  });

  group('cons / cons1', () {
    test('cons prepends a Chunk to the stream', () {
      expect(
        Rill.emits<int>([3, 4]).cons(Chunk.fromDart([1, 2])),
        producesInOrder([1, 2, 3, 4]),
      );
    });

    test('cons with empty Chunk returns stream unchanged', () {
      expect(
        Rill.emits<int>([1, 2]).cons(Chunk.empty()),
        producesInOrder([1, 2]),
      );
    });

    test('cons1 prepends a single element', () {
      expect(
        Rill.emits<int>([2, 3]).cons1(1),
        producesInOrder([1, 2, 3]),
      );
    });
  });

  group('operator +', () {
    test('appends two streams', () {
      expect(
        Rill.emits<int>([1, 2]) + Rill.emits<int>([3, 4]),
        producesInOrder([1, 2, 3, 4]),
      );
    });

    test('right operand is not evaluated until left is exhausted', () async {
      final log = <String>[];
      final left = Rill.emits<int>([1]).evalTap((_) => IO.exec(() => log.add('left')));
      final right = Rill.emits<int>([2]).evalTap((_) => IO.exec(() => log.add('right')));

      await (left + right).compile.drain.unsafeRunFuture();

      expect(log, ['left', 'right']);
    });
  });

  group('onComplete', () {
    test('appends continuation after natural completion', () {
      expect(
        Rill.emits<int>([1, 2]).onComplete(() => Rill.emits<int>([3, 4])),
        producesInOrder([1, 2, 3, 4]),
      );
    });

    test('continuation is NOT appended after error', () async {
      var continuationRan = false;
      final r = Rill.emit(1).append(() => Rill.raiseError<int>('BOOM')).onComplete(() {
        continuationRan = true;
        return Rill.emit(99);
      });
      await r.compile.drain.unsafeRunFutureOutcome();
      expect(continuationRan, isFalse);
    });
  });

  group('onFinalizeCase', () {
    test('receives succeeded ExitCase on normal completion', () {
      final test = IO.ref<ExitCase?>(null).flatMap((ref) {
        return Rill.emit(1).onFinalizeCase(ref.setValue).compile.drain.productR(ref.value());
      });

      expect(test.map((ec) => ec!.isSuccess), succeeds(isTrue));
    });

    test('receives errored ExitCase on stream error', () {
      final test = IO.ref<ExitCase?>(null).flatMap((ref) {
        return Rill.raiseError<int>(
          'BOOM',
        ).onFinalizeCase(ref.setValue).compile.drain.attempt().productR(ref.value());
      });

      expect(test.map((ec) => ec!.isError), succeeds(isTrue));
    });
  });

  group('filterWithPrevious', () {
    test('emits element when predicate is true for consecutive pair', () {
      // First element is always emitted. Subsequent elements are emitted when
      // p(prev, curr) returns true.
      expect(
        Rill.emits<int>([1, 2, 3, 2, 1]).filterWithPrevious((a, b) => b > a),
        producesInOrder([1, 2, 3]),
      );
    });

    test('always emits first element', () {
      expect(
        Rill.emits<int>([5, 3, 4]).filterWithPrevious((_, _) => false),
        producesOnly(5),
      );
    });
  });

  group('changesWith', () {
    test('emits when custom predicate detects a change', () {
      // changesWith(f) emits when f(prev, curr) returns true
      expect(
        Rill.emits<int>([1, 1, 2, 2, 3]).changesWith((a, b) => a != b),
        producesInOrder([1, 2, 3]),
      );
    });
  });

  group('distinct', () {
    test('passes through already-unique elements unchanged', () {
      expect(
        Rill.emits<int>([1, 2, 3]).distinct,
        producesInOrder([1, 2, 3]),
      );
    });

    test('empty stream stays empty', () {
      expect(Rill.empty<int>().distinct, producesNothing());
    });
  });

  group('head', () {
    test('emits only first element', () {
      expect(Rill.emits<int>([1, 2, 3]).head, producesOnly(1));
    });

    test('empty stream produces nothing', () {
      expect(Rill.empty<int>().head, producesNothing());
    });
  });

  group('tail', () {
    test('drops first element', () {
      expect(Rill.emits<int>([1, 2, 3]).tail, producesInOrder([2, 3]));
    });

    test('empty stream produces nothing', () {
      expect(Rill.empty<int>().tail, producesNothing());
    });

    test('single-element stream produces nothing', () {
      expect(Rill.emit(1).tail, producesNothing());
    });
  });

  group('last (Rill<Option<O>>)', () {
    test('empty stream emits None', () {
      expect(Rill.empty<int>().last, producesOnly(none<int>()));
    });

    test('non-empty stream emits Some of last element', () {
      expect(Rill.emits<int>([1, 2, 3]).last, producesOnly(const Some(3)));
    });
  });

  group('lastOr', () {
    test('empty stream emits fallback', () {
      expect(Rill.empty<int>().lastOr(() => 42), producesOnly(42));
    });

    test('non-empty stream emits last element', () {
      expect(Rill.emits<int>([10, 20, 30]).lastOr(() => 42), producesOnly(30));
    });
  });

  group('mask', () {
    test('passes through normal elements', () {
      expect(Rill.emits<int>([1, 2, 3]).mask, producesInOrder([1, 2, 3]));
    });

    test('empty stream produces nothing', () {
      expect(Rill.empty<int>().mask, producesNothing());
    });
  });

  group('timeout', () {
    test('interrupts the stream after the given duration', () {
      // timeout is identical in implementation to interruptAfter.
      final r = Rill.repeatEval(IO.sleep(50.milliseconds).as(1)).timeout(200.milliseconds);
      expect(r.compile.toIList.map((l) => l.size < 10), succeeds(isTrue));
    });
  });

  group('noneTerminate', () {
    test('wraps elements in Some and appends None', () {
      expect(
        Rill.emits<int>([1, 2, 3]).noneTerminate(),
        producesInOrder([const Some(1), const Some(2), const Some(3), none<int>()]),
      );
    });

    test('empty stream emits only None', () {
      expect(Rill.empty<int>().noneTerminate(), producesOnly(none<int>()));
    });
  });

  group('foreach', () {
    test('executes IO side-effect for each element', () {
      final test = IO.ref(nil<int>()).flatMap((ref) {
        return Rill.emits<int>([
          1,
          2,
          3,
        ]).foreach((x) => ref.update((l) => l.appended(x))).compile.drain.productR(ref.value());
      });

      expect(test, succeeds(ilist([1, 2, 3])));
    });
  });

  group('mapChunks', () {
    test('transforms each chunk', () {
      expect(
        Rill.emits<int>([1, 2, 3]).mapChunks((c) => c.map((x) => x * 10)),
        producesInOrder([10, 20, 30]),
      );
    });

    test('can change element type', () {
      expect(
        Rill.emits<int>([1, 2, 3]).mapChunks((c) => c.map((x) => '$x')),
        producesInOrder(['1', '2', '3']),
      );
    });
  });

  group('ifEmpty', () {
    test('empty stream emits fallback Rill', () {
      expect(
        Rill.empty<int>().ifEmpty(() => Rill.emits<int>([10, 20])),
        producesInOrder([10, 20]),
      );
    });

    test('non-empty stream is returned as-is', () {
      expect(
        Rill.emits<int>([1, 2]).ifEmpty(() => Rill.emits<int>([99])),
        producesInOrder([1, 2]),
      );
    });
  });

  group('zipLeft / zipRight', () {
    test('zipLeft keeps left elements, terminates with shorter', () {
      expect(
        Rill.emits<int>([1, 2, 3]).zipLeft(Rill.emits<String>(['a', 'b', 'c'])),
        producesInOrder([1, 2, 3]),
      );
    });

    test('zipLeft terminates when right is shorter', () {
      expect(
        Rill.emits<int>([1, 2, 3]).zipLeft(Rill.emits<String>(['a', 'b'])),
        producesInOrder([1, 2]),
      );
    });

    test('zipRight keeps right elements', () {
      expect(
        Rill.emits<int>([1, 2, 3]).zipRight(Rill.emits<String>(['a', 'b', 'c'])),
        producesInOrder(['a', 'b', 'c']),
      );
    });
  });

  group('zipLatestWith', () {
    test('combines using function', () {
      IO<A> cede<A>(A a) => IO.pure(a).productL(IO.cede);
      expect(
        Rill.emits<int>([1, 2])
            .evalMap(cede)
            .zipLatestWith(
              Rill.emits<String>(['a', 'b']).evalMap(cede),
              (i, s) => '$i$s',
            ),
        producesInOrder(['1a', '2a', '2b']),
      );
    });
  });

  group('takeThrough', () {
    test('includes first element that fails the predicate', () {
      expect(
        Rill.emits<int>([1, 2, 3, 4, 5]).takeThrough((x) => x < 3),
        producesInOrder([1, 2, 3]),
      );
    });

    test('takes all when all elements pass', () {
      expect(
        Rill.emits<int>([1, 2, 3]).takeThrough((x) => x < 10),
        producesInOrder([1, 2, 3]),
      );
    });

    test('empty stream produces nothing', () {
      expect(Rill.empty<int>().takeThrough((x) => x < 3), producesNothing());
    });
  });

  group('parEvalMapUnbounded', () {
    test('maps elements concurrently with no bound', () {
      expect(
        Rill.range(0, 5).parEvalMapUnbounded((i) => IO.pure(i * 2)),
        producesUnordered([0, 2, 4, 6, 8]),
      );
    });
  });

  group('parEvalMapUnorderedUnbounded', () {
    test('maps elements concurrently with no bound, unordered', () {
      expect(
        Rill.range(0, 5).parEvalMapUnorderedUnbounded((i) => IO.pure(i * 2)),
        producesUnordered([0, 2, 4, 6, 8]),
      );
    });
  });

  group('scanChunksOpt', () {
    test('returns None to stop early', () {
      // When f returns None, scanning stops.
      // Force one element per chunk so f is called once per element.
      expect(
        Rill.range(0, 10).flatMap((int i) => Rill.emit(i)).scanChunksOpt<int, int>(0, (int s) {
          if (s >= 3) return none();
          return Some(
            (Chunk<int> c) => c.mapAccumulate(s, (int acc, int x) => (acc + 1, x * 10)),
          );
        }),
        producesInOrder([0, 10, 20]),
      );
    });

    test('behaves like scanChunks when never returning None', () {
      expect(
        Rill.emits<int>([1, 2, 3]).scanChunksOpt<int, int>(0, (int s) {
          return Some(
            (Chunk<int> c) => c.mapAccumulate(s, (int acc, int x) => (acc + x, x)),
          );
        }),
        producesInOrder([1, 2, 3]),
      );
    });
  });

  group('sleep_', () {
    test('emits no elements of the typed output type', () {
      // sleep_<int> sleeps but produces a Rill<int> with no elements.
      expect(Rill.sleep_<int>(1.milliseconds), producesNothing());
    });
  });

  group('interruptWhenSignaled', () {
    test('interrupts when Signal<bool> becomes true', () {
      final test = SignallingRef.of(false).flatMap((sig) {
        final toggleAfterDelay = IO.sleep(100.milliseconds).productR(sig.setValue(true));
        final stream =
            Rill.repeatEval(
              IO.sleep(20.milliseconds).as(1),
            ).interruptWhenSignaled(sig).compile.toIList;
        return IO.both(toggleAfterDelay, stream).mapN((_, b) => b);
      });

      expect(test.map((l) => l.size < 20), succeeds(isTrue));
    });
  });

  group('pauseWhenSignal', () {
    test('pauses while Signal<bool> is true', () {
      final test = SignallingRef.of(false).flatMap((sig) {
        final pause = IO
            .sleep(50.milliseconds)
            .productR(sig.setValue(true))
            .productR(IO.sleep(200.milliseconds))
            .productR(sig.setValue(false));

        final stream =
            Rill.repeatEval(
              IO.sleep(30.milliseconds).as(1),
            ).interruptAfter(500.milliseconds).pauseWhenSignal(sig).compile.toIList;

        return IO.both(pause, stream).mapN((_, b) => b);
      });

      // Should have produced some elements before pause and some after resume,
      // fewer than if unpaused for the full duration.
      expect(test.map((l) => l.size < 15), succeeds(isTrue));
    });
  });
}
