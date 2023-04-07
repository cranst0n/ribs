import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('emit', () async {
    final r = Rill.emit('a');
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist(['a']));
  });

  test('emits', () async {
    final l = ilist([1, 2, 3]);
    final r = Rill.emits(l);
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, l);
  });

  test('empty', () async {
    final r = Rill.empty<int>();
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, const IList<int>.nil());
  });

  test('eval', () async {
    final r = Rill.eval(IO.pure(42));
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([42]));
  });

  test('map', () async {
    final r = Rill.emits(ilist([1, 2, 3])).map((a) => a * 2);
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('flatMap', () async {
    final r = Rill.emits(ilist([1, 2, 3]))
        .flatMap((a) => Rill.emits(ilist([a - 1, a, a + 1])));
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([0, 1, 2, 1, 2, 3, 2, 3, 4]));
  });

  test('handleErrorWith', () async {
    final r = Rill.emits(ilist([1, 2, 3]))
        .flatMap((x) =>
            x.isEven ? Rill.raiseError<int>(IOError('boom')) : Rill.emit(x * 2))
        .handleErrorWith((e) => Rill.emits(ilist([3, 2, 1])));

    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([2, 3, 2, 1]));
  });

  test('onComplete', () async {
    final r = Rill.emits(ilist([1, 2, 3])).onComplete(() => Rill.emit(123));

    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([1, 2, 3, 123]));
  });

  test('evalMap', () async {
    final r = Rill.emits(ilist([1, 2, 3])).evalMap((a) => IO.pure(a * 2));

    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([2, 4, 6]));
  });

  test('evalTap', () async {
    int sum = 0;

    final r =
        Rill.emits(ilist([1, 2, 3])).evalTap((a) => IO.exec(() => sum += a));

    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([1, 2, 3]));
    expect(sum, 6);
  });
}
