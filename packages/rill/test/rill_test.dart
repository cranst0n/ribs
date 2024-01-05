import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('drop', () async {
    final r = Rill.emits(IList.range(0, 1000)).drop(100);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, IList.range(100, 1000));
  });

  test('dropThrough', () async {
    final r = Rill.emits(IList.range(0, 100)).dropThrough((a) => a < 10);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, IList.range(11, 100));
  });

  test('dropWhile', () async {
    final r = Rill.emits(IList.range(0, 100)).dropWhile((a) => a < 10);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, IList.range(10, 100));
  });

  test('emit', () async {
    final r = Rill.emit('a');
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist(['a']));
  });

  test('emits', () async {
    final l = ilist([1, 2, 3]);
    final r = Rill.emits(l);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, l);
  });

  test('empty', () async {
    final r = Rill.empty<int>();
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, const Nil<int>());
  });

  test('eval', () async {
    final r = Rill.eval(IO.pure(42));
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([42]));
  });

  test('evalMap', () async {
    final r = Rill.emits(ilist([1, 2, 3])).evalMap((a) => IO.pure(a * 2));

    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('evalTap', () async {
    int sum = 0;

    final r =
        Rill.emits(ilist([1, 2, 3])).evalTap((a) => IO.exec(() => sum += a));

    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([1, 2, 3]));
    expect(sum, 6);
  });

  test('exists', () async {
    final a = Rill.range(0, 100).exists((a) => a == 42);
    final b = Rill.range(0, 40).exists((a) => a == 42);

    final exists = await a.compile().toIList().unsafeRunFuture();
    final notExists = await b.compile().toIList().unsafeRunFuture();

    expect(exists, isTrue);
    expect(notExists, isFalse);
  }, skip: 'flatMap signature ???');

  test('filter', () async {
    final r = Rill.range(1, 10).filter((a) => a.isEven);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([2, 4, 6, 8]));
  });

  test('filterWithPrevious', () async {
    final r = Rill.emits(ilist([1, 9, 5, 6, 7, 8, 9, 10]))
        .filterWithPrevious((previous, current) => previous < current);

    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([1, 9, 10]));
  });

  test('flatMap', () async {
    final r = Rill.emits(ilist([1, 2, 3]))
        .flatMap((a) => Rill.emits(ilist([a - 1, a, a + 1])));
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([0, 1, 2, 1, 2, 3, 2, 3, 4]));
  });

  test('find', () async {
    final r = Rill.range(0, 100).find((a) => a == 42);
    final found = await r.compile().toIList().unsafeRunFuture();

    final r2 = Rill.range(0, 100).find((a) => a == -1);
    final notFound = await r2.compile().toIList().unsafeRunFuture();

    expect(found, ilist([42]));
    expect(notFound, IList.empty<int>());
  });

  test('handleErrorWith', () async {
    final r = Rill.emits(ilist([1, 2, 3]))
        .flatMap((x) => x.isEven
            ? Rill.raiseError<int>(RuntimeException('boom'))
            : Rill.emit(x * 2))
        .handleErrorWith((e) => Rill.emits(ilist([3, 2, 1])));

    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([2, 3, 2, 1]));
  });

  test('map', () async {
    final r = Rill.emits(ilist([1, 2, 3])).map((a) => a * 2);
    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('onComplete', () async {
    final r = Rill.emits(ilist([1, 2, 3])).onComplete(() => Rill.emit(123));

    final result = await r.compile().toIList().unsafeRunFuture();

    expect(result, ilist([1, 2, 3, 123]));
  });

  test('range', () async {
    const n = 100000;

    final r = Rill.range(0, n);
    final result = await r.compile().count().unsafeRunFuture();

    expect(result, n);
  });
}
